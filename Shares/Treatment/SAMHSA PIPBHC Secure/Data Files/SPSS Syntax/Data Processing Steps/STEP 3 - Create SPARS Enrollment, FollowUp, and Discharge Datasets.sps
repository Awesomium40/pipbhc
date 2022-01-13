* Encoding: UTF-8.

/*****Create a dataset that stores the demographic information, one record per client******/.
DATASET ACTIVATE FullData.
SELECT IF (RecordStatus = 0).
EXECUTE.

DATASET ACTIVATE FullData.
COMPUTE homeless_intake = homeless.
COMPUTE CurrentWorkorSchool_intake = CurrentWorkorSchool.

RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3)INTO Clinic.
VARIABLE LABELS  Clinic 'Clinic where intervention took place'.
VALUE LABELS Clinic
    1 'Ramon Velez'
    2 'Clay'
    3 'Carlos Pagan'.
EXECUTE.


VALUE LABELS homeless_intake CurrentWorkorSchool_intake
    0 'No' 1 'Yes'.
VARIABLE LABELS
    homeless_intake 'Homeless sometime in the past 30 days at enrollment'.

DATASET ACTIVATE FullData.
SAVE OUTFILE= 'procStepFolder\Demographics.sav'
    /KEEP Client_ID Assessment Clinic FirstReceivedServicesDate
    ObservationDate homeless_intake CurrentWorkorSchool_intake
    gender_binary SexualIdentity_B DOB_New Agegroup race RaceEth Ethnic HispanicLatino RaceBlack
    Age Age_cat Gender  Agegroup educ_cat edu_cat1 SexualIdentity
    EverServed ActiveDuty_Else ViolenceTrauma PTSDSymp PTSD
    DiagnosisOne DiagnosisTwo DiagnosisThree
    DiagnosisOneCategory DiagnosisTwoCategory  DiagnosisThreeCategory
    /RENAME ObservationDate= SPARSEnrollmentDate.
EXECUTE.

/*We only need one row of demographic data per client. This data is taken at baseline, so select for the BL assessment (Assessment EQ 600)*/.
GET
    FILE="procStepFolder\Demographics.sav".
DATASET NAME Demographics.
DATASET ACTIVATE  Demographics.
FILTER OFF.
USE ALL.
SELECT IF (Assessment EQ 600).
EXECUTE.

/*Once the dataset is constructed, Assessment is no longer necessary*/.
DELETE VARIABLES Assessment.
EXECUTE.

/*It is possible that some clients have been discharged and re-enrolled. In those instances, we want to select the most recent enrollment date*/.
DATASET ACTIVATE Demographics.
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
    /DROP=PrimaryFirst InDupGrp.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary' MatchSequence
    'Sequential count of matching cases'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
FREQUENCIES VARIABLES=PrimaryLast MatchSequence.
EXECUTE.

DATASET ACTIVATE Demographics.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryLast = 1).
EXECUTE.

DATASET ACTIVATE  Demographics.
DELETE VARIABLES PrimaryLast MatchSequence.


/******Just as we need a dataset of enrollment/demographic data, we need an additional dataset that contains a record of discharges, one per client*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'procStepFolder\Discharge.sav'
    /KEEP Client_ID Assessment InterviewType_07 ObservationDate LastServiceDate_New.
EXECUTE.

GET
    FILE='procStepFolder\Discharge.sav'.
DATASET NAME Discharge.
DATASET ACTIVATE  Discharge.
FILTER OFF.
USE ALL.
SELECT IF (Assessment EQ 699).
EXECUTE.

/*As with the enrollment data, there are likely to be some clients who were discharged twice. Because we take the latter enrollment as truth, we must do the same for discharge*/.
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
EXECUTE.


/*for duplicate records, keep the most recent one*/.
DATASET ACTIVATE Discharge.
RENAME VARIABLES (ObservationDate=DischargeDate) (PrimaryLast = Discharged).
VARIABLE LABELS
    DischargeDate 'Date client was discharged from the program'
    Discharged 'Client was discharged from the program'.
VALUE LABELS
    Discharged 0 'No' 1 'Yes'.
DATASET ACTIVATE Discharge.
SELECT IF(Discharged = 1).
EXECUTE.

/*Create a variable to indicate if they were terminated as part of the end of the Ramon Valez Program move to Clay, rather than dropping out*/

*Create a year discharged variable. If their ID starts with a 1 and they were discharged in 2020, they were "terminated"*/
    * Date and Time Wizard: YearDischarged.
COMPUTE YearDischarged=XDATE.YEAR(DischargeDate).
VARIABLE LABELS YearDischarged "Year client was discharged".
VARIABLE LEVEL YearDischarged(SCALE).
FORMATS YearDischarged(F8.0).
VARIABLE WIDTH YearDischarged(8).
EXECUTE.

COMPUTE Dis_Month=XDATE.MONTH(DischargeDate).
VARIABLE LABELS Dis_Month.
VARIABLE LEVEL Dis_Month(SCALE).
FORMATS Dis_Month(F8.0).
VARIABLE WIDTH Dis_Month(8).
EXECUTE.

DATASET ACTIVATE Discharge.
RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3)INTO Clinic.
COMPUTE Terminated = 0.
DO IF  ((YearDischarged = 2020)&(Dis_Month=1)).
    RECODE Discharged (1=1) INTO Terminated.
END IF.
DO IF  ((YearDischarged = 2020)&(Dis_Month=2)).
    RECODE Discharged (1=1) INTO Terminated.
END IF.
DO IF  ((YearDischarged = 2021)&(Dis_Month=3)).
    RECODE Discharged (1=1) INTO Terminated.
END IF.
VARIABLE LABELS Terminated 'Discharged when grant ended at Ramon Valez'.
VALUE LABELS Terminated 1 'Terminated when grant ended' 0 'Discharged due to lack of follow up'.


/******Construct a series of datasets, one for each follow-up assessment (3m, 6m, 9m, 12m)******/.

/*Separate out data by Assessment (301=3m, 302=6m, 303=9m, 304=12m)*/.
/*3m assessment*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'procStepFolder\Followup3.sav'
    /KEEP Client_ID InterviewType_07 Assessment ConductedInterview.
EXECUTE.

GET
    FILE='procStepFolder\Followup3.sav'.
DATASET NAME Followup3.
DATASET ACTIVATE  Followup3.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 301).
EXECUTE.

NUMERIC Followup3M (F2.0).
RECODE ConductedInterview (1=1) (ELSE=0) INTO Followup3M.
VARIABLE LABELS  Followup3M 'Completed 3-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup3M
    0 'no' 1 'yes'.
DELETE VARIABLES InterviewType_07 Assessment ConductedInterview.

/*6m assessment*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'procStepFolder\Followup6.sav'
    /KEEP Client_ID InterviewType_07 Assessment ConductedInterview.
EXECUTE.

GET
    FILE='procStepFolder\Followup6.sav'.
DATASET NAME Followup6.
DATASET ACTIVATE  Followup6.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 302).
EXECUTE.

RECODE ConductedInterview (1=1) (ELSE=0) INTO Followup6M.
VARIABLE LABELS  Followup6M 'Completed 6-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup6M
    0 'no' 1 'yes'.
Delete variables InterviewType_07 Assessment ConductedInterview.

/*9m assessment*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'procStepFolder\Followup9.sav'
    /KEEP Client_ID InterviewType_07 Assessment ConductedInterview.
EXECUTE.

GET
    FILE='procStepFolder\Followup9.sav'.
DATASET NAME Followup9.
DATASET ACTIVATE  Followup9.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 303).
EXECUTE.

RECODE ConductedInterview (1=1) (ELSE=0) INTO Followup9M.
VARIABLE LABELS  Followup9M 'Completed 9-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup9M
    0 'no' 1 'yes'.
Delete variables InterviewType_07 Assessment ConductedInterview.

/*12m assessment*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'procStepFolder\Followup12.sav'
    /KEEP Client_ID InterviewType_07 Assessment ConductedInterview.
EXECUTE.

GET
    FILE='procStepFolder\Followup12.sav'.
DATASET NAME Followup12.
DATASET ACTIVATE  Followup12.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 304).
EXECUTE.

RECODE ConductedInterview (1=1) (ELSE=0) INTO Followup12M.
VARIABLE LABELS  Followup12M 'Completed 12-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup12M
    0 'no' 1 'yes'.
Delete variables InterviewType_07 Assessment ConductedInterview.

/*Need a single dataset that represents all follow-up data, so merge the 4 datasets constructed below into one*/.
DATASET ACTIVATE Followup3.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup6.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup9.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup12.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup3.
MATCH FILES /FILE=*
    /FILE='Followup6'
    /BY Client_ID.
EXECUTE.
MATCH FILES /FILE=*
    /FILE='Followup9'
    /BY Client_ID.
EXECUTE.
MATCH FILES /FILE=*
    /FILE='Followup12'
    /BY Client_ID.
EXECUTE.

/*Merge Demographics and discharge datasets into Demographics*/.
DATASET ACTIVATE Demographics.
SORT CASES BY Client_ID.
DATASET ACTIVATE Discharge.
SORT CASES BY Client_ID.
DATASET ACTIVATE Demographics.
MATCH FILES /FILE=*
    /FILE='Discharge'
    /BY Client_ID.
EXECUTE.
DATASET CLOSE Discharge.

/*Merge Followup and Demographics/Discharge into Demographics*/.
DATASET ACTIVATE Demographics.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup3.
SORT CASES BY Client_ID.
DATASET ACTIVATE Demographics.
MATCH FILES /FILE=*
    /FILE='Followup3'
    /BY Client_ID.
EXECUTE.
DATASET CLOSE Followup3.
DATASET CLOSE Followup6.
DATASET CLOSE Followup9.
DATASET CLOSE Followup12.

/*Create variable for time between enrollment and discharge*/

* Date and Time Wizard: TimeEnrolled.
COMPUTE  TimeEnrolled=(DischargeDate - SPARSEnrollmentDate) / time.days(1).
VARIABLE LABELS  TimeEnrolled "Number of days between enrollment in PIPBHC and discharge".
VARIABLE LEVEL  TimeEnrolled (SCALE).
FORMATS  TimeEnrolled (F8.2).
VARIABLE WIDTH  TimeEnrolled(8).
EXECUTE.

/*Clients who have not yet had their 3m follow-up show ther Followup3M variable as missing. Recode this to zero*/.
DO IF (Clinic EQ 3).
    RECODE Followup3M(SYSMS=0).
    RECODE Followup6M(SYSMS=0).
    RECODE Followup9M(SYSMS=0).
    RECODE Followup12M(SYSMS=0).
END IF.
EXECUTE.

/*Remove Discharge data from the primary dataset so that the 'Discharged' variable created above can be merged in from the Discharge dataset accurately*/. 
DATASET ACTIVATE FullData.
FILTER OFF.
USE ALL.
SELECT IF (Assessment NE 699).
EXECUTE.

DELETE VARIABLES DOB_New LastServiceDate_New GenderSpec EthnicOtherSpec gender_binary race
    Agegroup RaceEth Ethnic Age Age_cat Gender HispanicLatino EthnicCentralAmerican EthnicCuban EthnicDominican EthnicMexican EthnicPuertoRican EthnicSouthAmerican
    RaceAmericanIndian EthnicOther Agegroup educ_cat edu_cat1 SexualIdentity_B
    RaceBlack RaceAsian  RaceNativeHawaiian RaceAlaskaNative RaceWhite RaceAmericanIndian Agegroup SexualIdentity SexualIdentityOther WhyNotConducted
    GAFScore EverServed ConductedInterview ViolenceTrauma PTSDSymp PTSD EverServed ActiveDuty_Self ActiveDuty_Else
    VT_NightmaresThoughts VT_NotThinkAboutIt VT_OnGuard VT_NumbDetached EmploymentType_07 OtherResponseSpecify ReassessmentStatus_07 OtherReassessment_07 DischargeStatus
    OtherDischargeStatus Svc_MentalHealthFreq_07 SiteID FirstReceivedServicesDate
    ConsumerPrivateInsurance CurrentSamhsaGrantFunding DiagnosisOneCategory DiagnosisOne DiagnosisTwo DiagnosisThree DiagnosisThreeCategory DiagnosisTwoCategory
    GAFDate_New MedicaidMedicare Other_UseSpec OtherFederalGrantFunding OtherResponse StateFunding OtherEnrolledSpec OtherHousingSpec homeless_intake CurrentWorkorSchool_intake.
EXECUTE.


DATASET ACTIVATE FullData.
* Identify Duplicate Cases.
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
    /DROP=PrimaryFirst InDupGrp.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary' MatchSequence
    'Sequential count of matching cases'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
FREQUENCIES VARIABLES=PrimaryLast MatchSequence.
EXECUTE.


DATASET ACTIVATE FullData.
RECODE MatchSequence (0=1)(1=1)(2=2)(3=3) into Time.
EXECUTE.

DO IF (Clinic LT 3).
    RECODE Assessment(600=1)(302=2)(304=3)(305=4)(306=5) INTO A_Time.
ELSE IF (Clinic EQ 3).
    RECODE Assessment(600=1)(301=2)(302=3)(303=4)(304=5) INTO A_Time.
END IF.

/*Two clients from Velez had a 9m assessment instead of a 6m, so account for these in calcuation of A_Time variable*/.
DO IF (Client_ID EQ 164381 OR Client_ID EQ 163655).
    RECODE Assessment(303=2) INTO A_Time.
END IF. 
EXECUTE.
FORMATS A_Time (F2.0).

DELETE VARIABLES Clinic.
EXECUTE.


