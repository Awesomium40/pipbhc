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
NUMERIC Client_ID (F10.0).
COMPUTE Client_ID = NUMBER(REPLACE(ConsumerID, "'", ""), "F10.0").
EXECUTE.
RECODE Client_ID (1090021=0190021).
EXECUTE.


****Clinic needs to be computed from the Client ID****.
DATASET ACTIVATE CMAF.
RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3) INTO Clinic.
EXECUTE.

/****Need to compute numeric versions of the InterviewDate and DischargeDate variables****/.
RECODE InterviewDate DischargeDate
    ('01/01/1869', '07/01/1869', '06/01/1869', '08/01/1869', '09/01/1869', '' = '-1').
MISSING VALUES InterviewDate DischargeDate ('-1').
EXECUTE.

RECODE InterviewDate(MISSING=SYSMIS)(CONVERT) INTO InterviewDate_New.
RECODE DischargeDate(MISSING=SYSMIS)(CONVERT) INTO DischargeDate_New.
COMPUTE InterviewDate_New = DATE.MDY(1, 1, 1900) + ((InterviewDate_New - 2 ) * 24 * 3600).
COMPUTE DischargeDate_New = DATE.MDY(1, 1, 1900) + ((DischargeDate_New - 2 ) * 24 * 3600).
EXECUTE.

/*Compute ObsevationDate for all clients*/.
/*A Handful of clients have neither a valid interview date nor discharge date. this will also estimate an ObservationDate for them*/.
DO IF NOT SYSMIS(InterviewDate_New).
    COMPUTE ObservationDate = InterviewDate_New.
ELSE IF NOT SYSMIS(DischargeDate_New).
    COMPUTE ObservationDate = DischargeDate_New.
ELSE.
    NUMERIC #YearTemp (F4.0).
    DO IF Month GE 10.
        COMPUTE #YearTemp = FFY - 1.
    ELSE.
        COMPUTE #YearTemp = FFY.
    END IF.
    COMPUTE ObservationDate = DATE.MDY(Month, 15, #YearTemp).
END IF.
EXECUTE.

FORMATS InterviewDate_New DischargeDate_New ObservationDate (DATE14).
DELETE VARIABLES InterviewDate DischargeDate ConsumerID.

/*We will need to make a list of clients who were discharged*/.
DATASET COPY Discharge.
DATASET ACTIVATE Discharge.
SELECT IF Assessment EQ 699.
EXECUTE.

/*There are likely duplicate cases in the discharge data, so we will select the most recent discharge date*/.
DATASET ACTIVATE Discharge.
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
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

SELECT IF PrimaryLast = 1.
EXECUTE.

DELETE VARIABLES Assessment InterviewType_07 ConductedInterview WhyNotConducted Month FFY Clinic InterviewDate_New DischargeDate_New ObservationDate.
RENAME VARIABLES PrimaryLast=Discharged.

/****Additional Information forms are only collected at BL, 6M, 12M, so filter for those only****/.
DATASET ACTIVATE CMAF.
FILTER OFF.
USE ALL.
SELECT IF (Assessment EQ 600 OR Assessment EQ 302 OR Assessment EQ 304).
EXECUTE.

SORT CASES BY Client_ID ObservationDate.
RECODE Assessment(600=1)(302=2)(304=3) INTO Time.
EXECUTE.

/****Again, there are likely to be duplicate cases, which need to be removed, as some clients were discharged and re-enrolled****/.
/****As with the Discharge data, select the latest in the even of duplicates****/.
* Identify Duplicate Cases.
SORT CASES BY Client_ID(A) Time(A) ObservationDate(A).
MATCH FILES
  /FILE=*
  /BY Client_ID Time
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
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.
SELECT IF PrimaryLast EQ 1.
EXECUTE.

DELETE VARIABLES PrimaryLast.



****Need to determine whether clients missed an assessment****
****ConductedInterview is binary, represents whether the interview actually happened****.
NUMERIC MissedAssessment(F2.0).
    RECODE ConductedInterview (0=1)(ELSE=0) INTO MissedAssessment.
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
    /RENAME ObservationDate=AdditionalFormDate.

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

/***There are likely some duplicate cases in this data as well. This time, we will select the earliest of the duplicates, as later duplicates are mistakes***/.
DATASET ACTIVATE AI.
SORT CASES BY Client_ID(A) Time(A) ClientType(A).
MATCH FILES
  /FILE=*
  /BY Client_ID Time ClientType
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
  /DROP=PrimaryLast InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.
SELECT IF PrimaryFirst EQ 1.
EXECUTE.


VARIABLE LABELS  Time 'Assessment at which client got tracking form'.
VALUE LABELS  Time 
    1 'Enrollment tracking form' 
    2 'First follow up' 
    3 'Second follow up' 
    4 'Third follow up'.
 EXECUTE.
DELETE VARIABLES PrimaryFirst Clinic.
 EXECUTE. 

/*Attempt to reconcile the PIPBHC data with the ACIF data*/.
DATASET ACTIVATE AI.
SORT CASES BY Client_ID Time.
DATASET ACTIVATE CMAF.
SORT CASES BY Client_ID Time.
MATCH FILES /FILE=*
  /FILE='AI'
  /BY Client_ID Time.
EXECUTE.

SELECT IF Clinic GE 2.
EXECUTE.


/**********BELOW HERE IS THE ORIGINAL CODE**********/.



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

