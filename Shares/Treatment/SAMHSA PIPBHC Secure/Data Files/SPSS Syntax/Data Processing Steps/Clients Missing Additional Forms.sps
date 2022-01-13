* Encoding: UTF-8.
/***********************************
/*Clients Missing Additional Forms.sps
/*Constucts the dataset which lists those clients missing their additional information form for an assessment
/*Clients are missing an additional form if, for any record in PIPBHC Data Download:
/*    - The assessment was conducted (ConductedInterview = 1)
/*    - Assessment point is BL, 6M, 12M (Assessment IN [600, 302, 304])
/*    - No Corresponding record exists in Client Additional Information Form
    

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


/************As of December, 2021, no longer collecting 3m/9m assessment data************/.
/************SS-00006: Add logic to achieve the following************/.
/************1: Remove 3m/9m data from the dataset************/.
/************2: Recode 6m assessments such that they reflect the new values for assessment (600 instead of 300)************/.

/****Remove 3m/rm reassessment data from the dataset, as it is no longer required****/.
SELECT IF (Assessment NE 301 AND Assessment NE 303 AND Assessment NE 305).
EXECUTE.

/****Recode the old assessment values into the new values****/.
RECODE Assessment(302=601)(304=602)(306=603).
EXECUTE.


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
SELECT IF (Assessment EQ 600 OR Assessment EQ 601 OR Assessment EQ 602).
EXECUTE.

SORT CASES BY Client_ID ObservationDate.
RECODE Assessment(600=1)(601=2)(602=3) INTO Time.
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
    2 '6-Month Reassessment' 
    3 '12-Month Reassessment' 
    4 '18-Month Reassessment'.
EXECUTE.
DELETE VARIABLES PrimaryFirst Clinic.
EXECUTE. 

/*Attempt to reconcile the PIPBHC data with the ACIF data, then the discharge data*/.
DATASET ACTIVATE AI.
SORT CASES BY Client_ID Time.
DATASET ACTIVATE CMAF.
SORT CASES BY Client_ID Time.
MATCH FILES /FILE=*
  /FILE='AI'
  /BY Client_ID Time.
EXECUTE.

DATASET ACTIVATE Discharge.
SORT CASES BY Client_ID.
DATASET ACTIVATE CMAF.
SORT CASES BY Client_ID.
MATCH FILES /FILE=*
    /TABLE='Discharge'
    /BY Client_ID.
EXECUTE.

DATASET ACTIVATE CMAF.
DATASET CLOSE AI.
DATASET CLOSE Discharge.

NUMERIC Form_Missing (F2.0).
/*Now compute a value that represents whether a form is missing*/.
DO IF MissedAssessment EQ 0 AND SYSMIS(AdditionalFormDate).
    RECODE Time(ELSE=COPY) INTO Form_Missing.
ELSE.
    COMPUTE Form_Missing = 0.
END IF.
EXECUTE.

VALUE LABELS
    Form_Missing 
        1 'Enrollemnt' 
        2 '6-month Re-assessment' 
        3 '12-month Re-assessment'.



DATASET COPY Dates.
DATASET ACTIVATE Dates.
DELETE VARIABLES InterviewType_07 ConductedInterview WhyNotConducted Assessment Month FFY Clinic InterviewDate_New DischargeDate_New
    ClientType MissedAssessment AdditionalFormDate Followup3M Discharged Form_Missing.


SORT CASES BY Client_ID Time .
CASESTOVARS
  /ID=Client_ID
  /INDEX=Time
  /GROUPBY=VARIABLE.

RENAME VARIABLES 
    ObservationDate.1 = Enrollment_Date 
    ObservationDate.2 = Reassessment6M_Date
    ObservationDate.3 = Reassessment12M_Date.


SORT CASES BY Client_ID.
DATASET ACTIVATE CMAF.
SORT CASES BY Client_ID.
MATCH FILES /FILE=*
    /TABLE=Dates
    /BY Client_ID.
EXECUTE.


DATASET ACTIVATE CMAF.
IF (SYSMIS(Discharged)) Discharged = 0.
SELECT IF Clinic GE 2 and Form_Missing GT 0.
EXECUTE.

SAVE TRANSLATE OUTFILE='acifFolder\Clients_Without_Additional_Forms.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE
  /KEEP=Client_ID Form_Missing Enrollment_Date Reassessment6M_Date Reassessment12M_Date.

DATASET ACTIVATE PIPBHC_Long.
DATASET CLOSE CMAF.

