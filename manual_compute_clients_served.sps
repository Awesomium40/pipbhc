* Encoding: UTF-8.
FILE HANDLE rootFolder /NAME='D:\SyncThing\ptea'.
FILE HANDLE pipbhc /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\Excel Files\Data Downloads\PIPBHC Data Download 11.15.21.xlsx'.
FILE HANDLE procStepFolder /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps'.
FILE HANDLE acifFolder /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Additional Client Information Forms'.

GET DATA
  /TYPE=XLSX
  /FILE='pipbhc'
   /CELLRANGE=FULL
  /READNAMES=ON
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME FullData.

DATASET ACTIVATE FullData.
SAVE OUTFILE='rootFolder/fy2022.sav'
    /KEEP=ConsumerID  LastServiceDate Assessment Month FFY InterviewDate DischargeDate GAFDate DateBloodDrawn DOB FirstReceivedServicesDate
    ConductedInterview WhyNotConducted.

GET FILE='rootFolder/fy2022.sav'.
    DATASET NAME FD.
DATASET ACTIVATE FD.
DATASET CLOSE FullData.

/*Compute Client ID*/.
NUMERIC Client_ID (F10.0).
COMPUTE Client_ID = NUMBER(REPLACE(ConsumerID, "'", ""), "F10.0").
EXECUTE.

/*Compute ordinal time*/.
NUMERIC Time(F2.0).
RECODE Assessment(600=0)(301=3)(302=6)(303=9)(304=12)(305=15)(306=18)(699=99) INTO Time.
EXECUTE.

/*Identify Duplicate Cases and remove them*/.

/*Set missing values for InterviewDate and DischargeDate*/.
RECODE InterviewDate DischargeDate LastServiceDate GAFDate DateBloodDrawn DOB
    ('01/01/1869', '07/01/1869', '06/01/1869', '08/01/1869', '09/01/1869', '' = '-1').
MISSING VALUES InterviewDate DischargeDate LastServiceDate GAFDate DateBloodDrawn DOB ('-1').
EXECUTE.

/*Convert the various date variables into NUMERIC type rather than string*/.
RECODE InterviewDate(MISSING=SYSMIS)(CONVERT) INTO InterviewDate_New.
RECODE DischargeDate(MISSING=SYSMIS)(CONVERT) INTO DischargeDate_New.
RECODE LastServiceDate(MISSING=SYSMIS)(CONVERT) INTO LastServiceDate_New.
RECODE GAFDate(MISSING=SYSMIS)(CONVERT) INTO GAFDate_New.
RECODE DateBloodDrawn(MISSING=SYSMIS)(CONVERT) INTO DateBloodDrawn_New.
RECODE DOB(MISSING=SYSMIS)(CONVERT) INTO DOB_New.
EXECUTE.


/*Compute the ObservationDate variable from InterviewDate and DischargeDate*/.
DO IF NOT SYSMIS(InterviewDate_New).
    COMPUTE ObservationDate = DATE.MDY(1, 1, 1900) + ((InterviewDate_New - 2 ) * 24 * 3600).
ELSE IF NOT SYSMIS(DischargeDate_New).
    COMPUTE ObservationDate = DATE.MDY(1, 1, 1900) + ((DischargeDate_New - 2 ) * 24 * 3600).
END IF.
EXECUTE.

NUMERIC YearTemp (F4.0).
DO IF Month GE 10.
    COMPUTE YearTemp = FFY - 1.
ELSE.
    COMPUTE YearTemp = FFY.
END IF.
DO IF SYSMIS(ObservationDate).
    COMPUTE ObservationDate = DATE.MDY(Month, 15, YearTemp).
END IF.
EXECUTE.

/*Compute the several other dates from their recoded counterparts*/.
COMPUTE LastServiceDate_New = DATE.MDY(1, 1, 1900) + ((LastServiceDate_New - 2 ) * 24 * 3600).
COMPUTE GAFDate_New = DATE.MDY(1, 1, 1900) + ((GAFDate_New - 2 ) * 24 * 3600).
COMPUTE DateBloodDrawn_New = DATE.MDY(1, 1, 1900) + ((DateBloodDrawn_New - 2 ) * 24 * 3600).
COMPUTE DOB_New = DATE.MDY(1, 1, 1900) + ((DOB_New - 2 ) * 24 * 3600).
COMPUTE DischargeDate_New = DATE.MDY(1, 1, 1900) + ((DischargeDate_New - 2 ) * 24 * 3600).
EXECUTE.

/*Compute a LastServiceDate that represents last time client was either served or assessed*/.
NUMERIC LastServed (DATE14).
DO IF (Assessment NE 699).
    COMPUTE LastServed = MAX(ObservationDate, LastServiceDate_New).
END IF.
EXECUTE.

AGGREGATE
    /OUTFILE=* MODE=ADDVARIABLES
    /BREAK=Client_ID
    /LastReceivedServiceDate=MAX(LastServed).
EXECUTE.

FORMATS ObservationDate LastServiceDate_New GAFDate_New DateBloodDrawn_New DOB_New DischargeDate_New (DATE14).
DELETE VARIABLES InterviewDate DischargeDate LastServiceDate GAFDate DateBloodDrawn DOB.

/*There are many duplicate records, these need to be removed*/.
SORT CASES BY Client_ID Time ObservationDate.
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
EXECUTE.

SELECT IF PrimaryLast EQ 1.
EXECUTE.


/*Compute a list of clients who have been discharged*/.
DATASET ACTIVATE FD.
DATASET COPY Discharge.
DATASET ACTIVATE Discharge.
SELECT IF (Assessment EQ 699).
EXECUTE.
COMPUTE Discharged = 1.
EXECUTE.

DELETE VARIABLES ConsumerID Assessment Month FFY FirstReceivedServicesDate InterviewDate_New DischargeDate_New LastServiceDate_New GAFDate_New DateBloodDrawn_New
    DOB_New ObservationDate YearTemp LastServed LastReceivedServiceDate PrimaryLast Time.


DATASET ACTIVATE FD.
SORT CASES BY Client_ID.
DATASET ACTIVATE Discharge.
SORT CASES BY Client_ID.

DATASET ACTIVATE FD.
STRING SOURCE (A12).
COMPUTE SOURCE = 'PIPBHC'.
EXECUTE.

/*Select clients who last received services in FY2022*/.
DATASET ACTIVATE FD.
SELECT IF DATEDIFF(LastReceivedServiceDate, DATE.MDY(10, 1, 2021), 'days') GE 0.
EXECUTE.


    
/*******************Now add in the Additional Client Information data**********************/.
GET DATA
  /TYPE=XLSX
  /FILE='acifFolder\Additional Client Information Form Spreadsheet.xlsx'
  /SHEET=name 'For IMPORT - DO NOT EDIT'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME AdditionalMeasures.

DATASET ACTIVATE AdditionalMeasures.
FILTER OFF.
USE ALL.

SELECT IF (DATEDIFF (ObservationDate, DATE.MDY(10, 1, 2021), 'days') GE 0).
EXECUTE.

DATASET ACTIVATE AdditionalMeasures.
SAVE OUTFILE='rootFolder/fy2022_AM.sav'
    /KEEP=Client_ID ObservationDate.

GET FILE='rootFolder/fy2022_AM.sav'.
DATASET NAME AM.
DATASET ACTIVATE AM.
DATASET CLOSE AdditionalMeasures.

SORT CASES BY Client_ID.
AGGREGATE
    /OUTFILE=* MODE=ADDVARIABLES
    /BREAK=Client_ID
    /LastReceivedServiceDate=MAX(ObservationDate).
EXECUTE.

DELETE VARIABLES ObservationDate.
STRING SOURCE (A12).
COMPUTE SOURCE = 'ACIF'.
EXECUTE.


ADD FILES /FILE=* /FILE='FD'.
EXECUTE.

SORT CASES BY Client_ID.
DATASET ACTIVATE AM.
MATCH FILES /FILE=*
  /TABLE='Discharge'
  /BY Client_ID.
EXECUTE.
DATASET CLOSE Discharge.

DELETE VARIABLES PrimaryLast.


SORT CASES BY Client_ID(A).
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
  /DROP=PrimaryLast InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.

SELECT IF PrimaryFirst EQ 1.
EXECUTE.


SORT CASES BY SOURCE Client_ID.
SPLIT FILE BY SOURCE.

FREQUENCIES PrimaryFirst Client_ID Discharged.
