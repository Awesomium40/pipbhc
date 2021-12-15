* Encoding: UTF-8.

/************CHANGE THESE TO REFLECT FILE SYSTEM STRUCTURE************/.
FILE HANDLE ratFolder /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\Excel Files\Reassessment Tracking Spreadsheets'.

/***OPEN THE EXCEL FORMS AND EXTRACT THE REQUIRED DATA***/.
/*START WITH FULL DOWNLOAD*/.
GET DATA
  /TYPE=XLSX
  /FILE='pipbhc'
   /CELLRANGE=FULL
  /READNAMES=ON
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME FD.
DATASET ACTIVATE FD.


SAVE OUTFILE='ratFolder\DFR.sav'
    /KEEP=ConsumerID InterviewType_07 ConductedInterview Assessment InterviewDate DischargeDate Lipid_LDL Lipid_Tri.

GET FILE='ratFolder\DFR.sav'.
DATASET NAME DFR.
DATASET ACTIVATE DFR.
DATASET CLOSE FD.

/******CREATE Client_ID AS PER STEP 1******/.
NUMERIC Client_ID (F8.0).
COMPUTE Client_ID=NUMBER(CHAR.SUBSTR(ConsumerID, 2, CHAR.RINDEX(ConsumerID,"'")-2),F8.0).
EXECUTE.
RECODE Client_ID (1090021=0190021).
EXECUTE.

/******CREATE Clinic******/.
DATASET ACTIVATE DFR.
RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3) INTO Clinic.
EXECUTE.

/******Compute whether clients missed an interview******/.
NUMERIC MissedAssessment(F2.0).
DO IF Assessment NE 699.
    RECODE ConductedInterview (0=1)(ELSE=0) INTO MissedAssessment.
END IF.
EXECUTE.

/******COMPUTE InterviewType******/.
DATASET ACTIVATE DFR.
NUMERIC InterviewType (F2.0).
RECODE Assessment (600 = 1) (301 = 2) (302 = 3) (303 = 4) (304 = 5) (699=9) INTO InterviewType.
EXECUTE.

/******CREATE ObservationDate******/.
 AUTORECODE VARIABLES=InterviewDate
    /INTO ObservationTemp.

AUTORECODE VARIABLES=DischargeDate
     /INTO ObservationTemp2.

STRING Interview(A10).
DO IF (ObservationTemp GT 1).
    RECODE InterviewDate (ELSE=Copy) INTO Interview.
ELSE.
    RECODE DischargeDate (ELSE=Copy) INTO Interview.
END IF.

ALTER TYPE Interview (f1).
COMPUTE ObservationDate = DATE.MDY(1,1,1900) +( (Interview - 2) * 24 * 60 * 60).
FORMATS ObservationDate (DATE14).
EXECUTE.

VARIABLE LABELS  
ObservationDate 'Date interview was conducted'.

DELETE VARIABLES ObservationTemp ObservationTemp2 InterviewDate DischargeDate ConsumerID interview.


/******FILTER OUT CASES FROM CLINICS 1/2 AS WELL AS CASES WITH NO HCV ******/.
FILTER OFF.
USE ALL.
SELECT IF (Clinic GE 3).
EXECUTE.


/******Add some logic to deal with rows that are in error with respect to 'Assessment'******/.
DATASET ACTIVATE DFR.
DATASET COPY  Assessment_Errors.
DATASET ACTIVATE Assessment_Errors.
FILTER OFF.
USE ALL.
SELECT IF (Clinic GE 3 AND (Assessment NE 600 AND Assessment NE 301 AND Assessment NE 302 AND 
    Assessment NE 303 AND Assessment NE 304 AND Assessment NE 699)).
EXECUTE.


WRITE OUTFILE='rootFolder/reassessment_errors.txt' ENCODING='UTF8'
        /1'|Client ID='Client_ID  '|Assessment=' Assessment '|Date='ObservationDate '|'. 
EXECUTE.

/******Filter out the invalid records******/.
DATASET ACTIVATE DFR.
DATASET CLOSE Assessment_Errors.
SELECT IF (Assessment EQ 600 OR Assessment EQ 301 OR Assessment EQ 302 OR Assessment EQ 303 OR Assessment EQ 304 OR Assessment EQ 699).
EXECUTE.

/******COMPUTE Discharged AS PER STEP 3******/.
DATASET ACTIVATE DFR.
DATASET COPY DFR_Discharge.
DATASET ACTIVATE DFR_Discharge.

DELETE VARIABLES Lipid_LDL Lipid_Tri InterviewType Clinic MissedAssessment ConductedInterview InterviewType_07.
FILTER OFF.
USE ALL.
SELECT IF (Assessment EQ 699).
EXECUTE.

* Identify Duplicate Cases in discharge data - people who were discharged, re-enrolled, and then discharged again. there is also a few duplicates*/

DATASET ACTIVATE DFR_Discharge.
SORT CASES BY Client_ID(A) ObservationDate(A).
MATCH FILES
  /FILE=*
  /BY Client_ID
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst InDupGrp MatchSequence.
EXECUTE.


/*for duplicate records, keep the most recent one*/.
DATASET ACTIVATE DFR_Discharge.
RENAME VARIABLES (ObservationDate=DischargeDate) (PrimaryLast = Discharged).
DELETE VARIABLES Assessment.                            
SELECT IF(Discharged = 1).
EXECUTE.

/******RESTRUCTURE THE DATA AS OCCURS IN STEP 6******/.
DATASET ACTIVATE DFR.
SORT CASES BY Client_ID InterviewType.
CASESTOVARS
  /ID=Client_ID
  /INDEX=InterviewType
  /GROUPBY=VARIABLE.
EXECUTE.
DATASET ACTIVATE DFR.

/******FILL IN MISSING VALUES FOR MissedAssessment vars******/.
/******NOTE THAT THESE LINES MAY THROW ERRORS IF NO CLIENTS HAVE HAD 6m/9m/12m REASSESSMENTS YET. THIS IS EXPECTED******/.
RECODE MissedAssessment.2(SYSMIS=0).
RECODE MissedAssessment.3(SYSMIS=0).
RECODE MissedAssessment.4(SYSMIS=0).
RECODE MissedAssessment.5(SYSMIS=0).
EXECUTE.

/******MERGE Discharge AND FullData AS PER STEP 4******/.
SORT CASES BY Client_ID.
DATASET ACTIVATE DFR_Discharge.
SORT CASES BY Client_ID.
DATASET ACTIVATE DFR.
MATCH FILES /FILE=*
  /FILE='DFR_Discharge'
  /BY Client_ID.
EXECUTE.
DATASET CLOSE DFR_Discharge.

/******MERGE Fulldata and HCV RESULTS******/.
GET DATA
  /TYPE=XLSX
  /FILE='acifFolder\Additional Client Information Form Spreadsheet.xlsx'
  /SHEET=name 'For IMPORT - DO NOT EDIT'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME AI WINDOW=FRONT.
DATASET ACTIVATE AI.
RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3) INTO Clinic.
SELECT IF (NOT SYSMIS(Client_id) AND Clinic EQ 3).
EXECUTE.

SAVE OUTFILE='ratFolder\HCVResults.sav'
    /KEEP=Client_ID Time HCVTestResult
    /RENAME Time=Form_Time.

/***MERGE IN HCV TEST RESULT DATA***/.
/******NOTE THAT THIS MAY THROW AN ERROR FOR LINE 191, CITING DUPLICATE KEY. THIS IS EXPECTED******/.
GET FILE='ratFolder\HCVResults.sav'.
DATASET NAME HCV.
DATASET ACTIVATE HCV.
DATASET CLOSE AI.

/***HCV Test Results only necessary from BL assessment***/.
SELECT IF Form_Time EQ 1.
EXECUTE.

DATASET ACTIVATE DFR.
SORT CASES BY Client_ID.
DATASET ACTIVATE HCV.
SORT CASES BY Client_ID.
DATASET ACTIVATE DFR.
MATCH FILES /FILE=*
  /FILE='HCV'
  /BY Client_ID.
EXECUTE.


DATASET ACTIVATE DFR.
DATASET CLOSE HCV.
SELECT IF NOT SYSMIS(Clinic).
EXECUTE.

NUMERIC today(DATE11).
COMPUTE today = $time.
EXECUTE.
Formats today(edate10).


COMPUTE  TimeSinceEnrollment=DATEDIF(today, ObservationDate.1, "days").

/******COMPUTE CLIENTS THAT ARE Eligible AT ANY TIME POINT******/.
/******NOTE THAT THESE LINES MAY THROW ERRORS IF NO CLIENTS HAVE HAD 6m/9m/12m REASSESSMENTS YET. THIS IS EXPECTED******/.
NUMERIC M3Eligible (F2.0).
NUMERIC M6Eligible (F2.0).
NUMERIC M9Eligible (F2.0).
NUMERIC M12Eligible (F2.0).
NUMERIC AnyEligible (F2.0).
COMPUTE M3Eligible = (TimeSinceEnrollment GE 60 AND TimeSinceEnrollment LE 120) AND SYSMIS(Discharged) AND (SYSMIS(ObservationDate.2) AND MissedAssessment.2 EQ 0) AND (Lipid_LDL.1 GT 130 OR Lipid_Tri.1 GT 150 OR HCVTestResult = 1).
COMPUTE M6Eligible = (TimeSinceEnrollment GE 150 AND TimeSinceEnrollment LE 210) AND SYSMIS(Discharged) AND (SYSMIS(ObservationDate.3) AND MissedAssessment.3 EQ 0).
COMPUTE M9Eligible = (TimeSinceEnrollment GE 240 AND TimeSinceEnrollment LE 300) AND SYSMIS(Discharged) AND (SYSMIS(ObservationDate.4) AND MissedAssessment.4 EQ 0) AND (Lipid_LDL.1 GT 130 OR Lipid_Tri.1 GT 150).
COMPUTE M12Eligible = (TimeSinceEnrollment GE 335 AND TimeSinceEnrollment LE 395) AND SYSMIS(Discharged) AND (SYSMIS(ObservationDate.5) AND MissedAssessment.5 EQ 0).
EXECUTE.
COMPUTE AnyEligible = (M3Eligible EQ 1) OR (M6Eligible EQ 1) OR (M9Eligible EQ 1) OR (M12Eligible EQ 1).
EXECUTE.

/******COMPUTE THE NATURE OF THE ASSESSMENT FOR WHICH A CLIENT IS DUE******/.
NUMERIC AssessmentType (F2.0).
NUMERIC DeadlineReassess(DATE11).
NUMERIC Reassessment(F2.0).
DO IF (M3Eligible EQ 1).
    COMPUTE AssessmentType = 1.
    COMPUTE DeadlineReassess = DATESUM(ObservationDate.1, 120, 'days').
    RECODE TimeSinceEnrollment(60 THRU 90=1)(91 THRU 120=2)(ELSE=0) INTO Reassessment.
ELSE IF (M6Eligible EQ 1).
    COMPUTE AssessmentType = 2.
    COMPUTE DeadlineReassess = DATESUM(ObservationDate.1, 210, 'days').
    RECODE TimeSinceEnrollment(150 THRU 180=1)(181 THRU 210=2)(ELSE=0) INTO Reassessment.
ELSE IF (M9Eligible EQ 1).
    COMPUTE AssessmentType = 3.
    COMPUTE DeadlineReassess = DATESUM(ObservationDate.1, 300, 'days').
    RECODE TimeSinceEnrollment(240 THRU 270=1)(271 THRU 300=2)(ELSE=0) INTO Reassessment.
ELSE IF (M12Eligible EQ 1).
    COMPUTE AssessmentType = 4.
    COMPUTE DeadlineReassess = DATESUM(ObservationDate.1, 395, 'days').
    RECODE TimeSinceEnrollment(335 THRU 365=1)(366 THRU 395=2)(ELSE=0) INTO Reassessment.
END IF.
EXECUTE.

VARIABLE LABELS AssessmentType 'Type of assessment for which a client is due'.
VALUE LABELS AssessmentType 
    1 '3-month reassessment' 
    2 '6-month reassessment' 
    3 '9-month reassessment' 
    4 '12-month reassessment'.

VALUE LABELS
Reassessment
    0 'Not in Reassessment Window'
    1 'More than 30 days left'
    2 'Less than 30 days left'.

DATASET COPY Reassessment.
DATASET ACTIVATE Reassessment.
SELECT IF (AnyEligible EQ 1).
EXECUTE.


DATASET ACTIVATE Reassessment.
SORT CASES BY AssessmentType Client_ID.
EXECUTE.

SAVE TRANSLATE OUTFILE='ratFolder\Reassessment Tracking.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE
  /KEEP=Client_ID Reassessment DeadlineReassess ObservationDate.1 Lipid_LDL.1 Lipid_Tri.1 HCVTestResult AssessmentType
  /RENAME (Client_ID Reassessment DeadlineReassess ObservationDate.1
  = ClientID Reassessment_Status Reassessment_Deadline EnrollmentDate).

DATASET ACTIVATE PIPBHC_Long.
DATASET CLOSE DFR.
DATASET CLOSE Reassessment.

