* Encoding: UTF-8.
*Creating a variable for whether or not we've received an additional client information from for a client for Enrollment Forms

FILE HANDLE acifFolder /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Additional Client Information Forms'.

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

SAVE OUTFILE='acifFolder\full_data.sav'
    /KEEP=ConsumerID InterviewType_07 ConductedInterview WhyNotConducted Assessment InterviewDate DischargeDate Month FFY.

GET FILE='acifFolder\full_data.sav'.
DATASET NAME CMAF.
DATASET ACTIVATE CMAF.
DATASET CLOSE FD.


****Numeric Client ID needs to be computed from the string version****.
NUMERIC Client_ID (F8.0).
COMPUTE Client_ID=NUMBER(CHAR.SUBSTR(ConsumerID, 2, CHAR.RINDEX(ConsumerID,"'")-2),F8.0).
EXECUTE.
RECODE Client_ID (1090021=0190021).
EXECUTE.


****Clinic needs to be computed from the Client ID****.
DATASET ACTIVATE CMAF.
RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3) INTO Clinic.
EXECUTE.

****Need to determine whether clients missed an assessment****
****Assessment 699 = discharge, all others represent actual interviews****
****ConductedInterview is binary, represents whether the interview actually happened****.
NUMERIC MissedAssessment(F2.0).
DO IF Assessment NE 699.
    RECODE ConductedInterview (0=1)(ELSE=0) INTO MissedAssessment.
END IF.
EXECUTE.

****Compute the ObservationDate as is done in the typical workflow****.
AUTORECODE VARIABLES=InterviewDate
/into ObservationTemp
/print.

STRING Interview (A11).
DO IF  (ObservationTemp > 1).
RECODE InterviewDate (ELSE=Copy) INTO Interview.
END IF.
EXECUTE.

DO IF  (ObservationTemp = 1).
RECODE DischargeDate (ELSE=Copy) INTO Interview.
END IF.
EXECUTE.

alter type  Interview (f1).
COMPUTE ObservationDate = DATE.MDY(1,1,1900) +( (Interview - 2) * 24 * 60 * 60).
FORMATS ObservationDate (DATE14).
EXECUTE.

VARIABLE LABELS  
ObservationDate 'Date interview was conducted'.

****There are several clients for whom both the InterviewDate and DischargeDate are missing.****
****This will require valid date information, which we can compute from the month and FFY****
****For these clients, the above procedure does not yield a valid ObservationDate, so interpolate using Month, and FFY.
****Fiscal year isn't the same as calendar year (rolls over in October), so compute a valid year.
NUMERIC Year (F4.0).
DO IF Month GE 10.
    COMPUTE Year = FFY - 1.
ELSE IF MONTH LT 10.
    COMPUTE Year = FFY.
END IF.
EXECUTE.

IF SYSMIS(ObservationDate) ObservationDate = DATE.MDY(Month, 15, Year).
EXECUTE.
DELETE VARIABLES observationtemp InterviewDate DischargeDate ConsumerID interview Year.

****The original InterviewType_07 was ambiguous and not useful for computing various other variables****
****Replace with a new version that more clearly describes the interview type****.
DATASET ACTIVATE CMAF.
NUMERIC InterviewType (F2.0).
RECODE Assessment (600 = 1) (301 = 2) (302 = 3) (303 = 4) (304 = 5) (699=9) INTO InterviewType.
EXECUTE.

****Eventually, the PIPBHC dataset will need to be matched to the Additional Forms dataset****
****This can be done via the Client_ID and Time variables****
****in the AF dataset, Time is coded as follows: 1 = BL, 2 = 3m, 3 = 6m****
****Use the Assessment variable to compute Time in this dataset****.
NUMERIC Time (F2.0).
RECODE Assessment (600 = 1) (301 = 2) (302 = 3) (303 = 4) (304 = 5) (699=9) INTO Time.
EXECUTE.

****Load the Additional Form dataset so that it can be matched with the PIPBHC dataset****.
GET DATA
  /TYPE=XLSX
  /FILE='acifFolder\Additional Client Information Form Spreadsheet.xlsx'
  /SHEET=name 'For IMPORT - DO NOT EDIT'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME AdditionalInfo.

DATASET ACTIVATE AdditionalInfo.
SAVE OUTFILE='acifFolder/AdditionalInfo.sav'
    /KEEP=Client_ID ObservationDate ClientType Time Followup3M
    /RENAME ObservationDate=AdditionalFormDate Time=AdditionalForm_Time.

GET FILE='acifFolder/AdditionalInfo.sav'.
DATASET NAME AI.
DATASET ACTIVATE AI.
DATASET CLOSE AdditionalInfo.
SELECT IF NOT SYSMIS(Client_ID).
EXECUTE.

****This dataset will need a clinic variable as well****.
DATASET ACTIVATE AI.
RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3) INTO Clinic.
EXECUTE.

****Compute the T_Time variable, which determines at which point clients got an assessment with additional form****.
DATASET ACTIVATE AI.
SORT CASES BY Client_ID(A) AdditionalFormDate(A).
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
  /DROP=PrimaryFirst InDupGrp.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary' MatchSequence 
    'Sequential count of matching cases'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
EXECUTE.

DATASET ACTIVATE AI.
RENAME VARIABLES  MatchSequence = Time.
EXECUTE.

RECODE Time (0=1).

VARIABLE LABELS  Time 'Assessment at which client got tracking form'.
VALUE LABELS  Time 
    1 'Enrollment tracking form' 
    2 'First follow up' 
    3 'Second follow up' 
    4 'Third follow up'.
 EXECUTE.
DELETE VARIABLES PrimaryLast.
 EXECUTE.

*SORT CASES BY Client_ID TrackingFormCount.
*CASESTOVARS
  /ID=Client_ID
  /INDEX=TrackingFormCount
  /GROUPBY=VARIABLE.




*********************************************BELOW HERE IS THE OLD CODE TO BE REPLACED*********************************************
DATASET ACTIVATE PIPBHC_Long.
Recode ObservationDate.4 (MISSING=0) into AdditionalClientInfoForm.
EXECUTE.
DO IF (ObservationDate.4 > 0).
Compute AdditionalClientInfoForm = 1.
END IF.
EXECUTE. 

VARIABLE LABELS
AdditionalClientInfoForm 'Additional form received for this client at enrollment'.
VALUE LABELS
AdditionalClientInfoForm
0 'No'
1 'Yes'.
EXECUTE.

DATASET ACTIVATE PIPBHC_Long.
DATASET COPY PIPBHC_temp2.
DATASET ACTIVATE PIPBHC_temp2.
FILTER OFF.
USE ALL.
SELECT IF (AdditionalClientInfoForm = 0).
EXECUTE.

COMPUTE Form_Missing=1.
EXECUTE.

*Creating a variable for whether or not we've received an additional client information from for a client for 3-month Follow-up forms

DATASET ACTIVATE PIPBHC_Long.
DATASET COPY PIPBHC_temp3.
DATASET ACTIVATE PIPBHC_temp3.

Recode ObservationDate.5 (MISSING=0) into AdditionalClientInfoForm3M.
EXECUTE.
DO IF (ObservationDate.5 > 0).
Compute AdditionalClientInfoForm3M= 1.
END IF.
EXECUTE. 

VARIABLE LABELS
AdditionalClientInfoForm3M 'Additional form received for this client first followup'.
VALUE LABELS
AdditionalClientInfoForm3M
0 'No'
1 'Yes'.
EXECUTE.

DATASET ACTIVATE PIPBHC_temp3.
FILTER OFF.
USE ALL.
SELECT IF (AdditionalClientInfoForm3M = 0).
EXECUTE.

DATASET ACTIVATE PIPBHC_temp3.
FILTER OFF.
USE ALL.
SELECT IF (ObservationDate.2 > 0).
EXECUTE.

COMPUTE Form_Missing=2.
EXECUTE.

*Creating a variable for whether or not we've received an additional client information from for a client for 6-month Follow-up forms

DATASET ACTIVATE PIPBHC_Long.
DATASET COPY PIPBHC_temp4.
DATASET ACTIVATE PIPBHC_temp4.

Recode ObservationDate.6 (MISSING=0) into AdditionalClientInfoForm6M.
EXECUTE.
DO IF (ObservationDate.6 > 0).
Compute AdditionalClientInfoForm6M= 1.
END IF.
EXECUTE. 

VARIABLE LABELS
AdditionalClientInfoForm6M 'Additional form received for this client second followup'.
VALUE LABELS
AdditionalClientInfoForm6M
0 'No'
1 'Yes'.
EXECUTE.

DATASET ACTIVATE PIPBHC_temp4.
FILTER OFF.
USE ALL.
SELECT IF (AdditionalClientInfoForm6M = 0).
EXECUTE.

DATASET ACTIVATE PIPBHC_temp4.
FILTER OFF.
USE ALL.
SELECT IF (ObservationDate.3 > 0).
EXECUTE.

COMPUTE Form_Missing=3.
EXECUTE.

/*****merge files together into one spreadsheet*

DATASET ACTIVATE PIPBHC_temp2.
ADD FILES /FILE=*
  /FILE='PIPBHC_temp3'
  /RENAME (AdditionalClientInfoForm3M=d0)
  /DROP=d0.
EXECUTE.

DATASET ACTIVATE PIPBHC_temp2. 
ADD FILES /FILE=* 
  /FILE='PIPBHC_temp4' 
  /RENAME (AdditionalClientInfoForm6M=d0) 
  /DROP=d0. 
EXECUTE.

DATASET ACTIVATE PIPBHC_temp2. 
VALUE LABELS Form_Missing
                     1 'Enrollment'
                     2 '3-Month Re-assessment'
                     3 '6-Month Re-assessment'.
                   EXECUTE.

DATASET ACTIVATE PIPBHC_temp2. 
FILTER OFF.
USE ALL.
SELECT IF (Clinic >= 2).
EXECUTE.
DATASET ACTIVATE PIPBHC_temp2. 
SAVE TRANSLATE OUTFILE='acifFolder\Clients_Without_Additional_Forms.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE
  /Keep=Client_ID  Form_Missing ObservationDate.1 ObservationDate.2 ObservationDate.3
  /rename ObservationDate.1=Enrollment_Date ObservationDate.2=Reassessment3M_Date ObservationDate.3=Reassessment6M_Date.
USE ALL.

DATASET CLOSE PIPBHC_temp2.
DATASET CLOSE PIPBHC_temp3.
DATASET CLOSE PIPBHC_temp4.


