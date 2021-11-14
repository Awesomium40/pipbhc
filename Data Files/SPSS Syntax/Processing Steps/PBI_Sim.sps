* Encoding: UTF-8.
FILE HANDLE pipbhc_dd /NAME='D:\DropBox\tempchin\Data Files\Excel Files\Data Downloads\PIPBHC Data Download 9.20.21.xlsx'.
*FILE HANDLE dataFile /NAME='D:\SyncThing\tempchin\Data Files\Excel Files\Data Downloads\eight_vars.xlsx'.
FILE HANDLE dataFiles /NAME='D:\DropBox\tempchin\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files'.
FILE HANDLE dataFilesProcSteps /NAME='dataFiles\SPSS Syntax\Data Processing Steps'.
FILE HANDLE additionalInfo /NAME='D:\DropBox\tempchin\Data Files\Excel Files\Data Downloads\Additional Client Information Form Spreadsheet.xlsx'.
FILE HANDLE ddFolder /NAME='D:\DropBox\tempchin\Data Files\Excel Files\Data Downloads'.
FILE HANDLE psFolder /NAME='dataFiles\SPSS Syntax\Data Processing Steps'.

GET DATA
  /TYPE=XLSX
  /FILE='pipbhc_dd'
   /CELLRANGE=FULL
  /READNAMES=ON
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME Fulldata.
DATASET ACTIVATE Fulldata.


/************COMPUTE STEP 1 VARS*************/.
NUMERIC Client_ID (F8.0).
COMPUTE Client_ID=NUMBER(CHAR.SUBSTR(ConsumerID, 2, CHAR.RINDEX(ConsumerID,"'")-2),F8.0).
EXECUTE.

RECODE Client_ID (1090021=0190021).
EXECUTE.

 AUTORECODE VARIABLES=InterviewDate
/into ObservationTemp
/print.

AUTORECODE VARIABLES=DischargeDate
     /INTO ObservationTemp2
     /PRINT.

STRING Interview(A10).
DO IF (ObservationTemp EQ 1 AND ObservationTemp2 EQ 1).
    COMPUTE Interview = '3'.
ELSE IF (ObservationTemp GT 1).
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

DELETE VARIABLES observationtemp ObservationTemp2 InterviewDate DischargeDate ConsumerID interview.
EXECUTE.

AUTORECODE VARIABLES=DOB
/into DOBTemp
/print.

STRING DOB_String (A10).
DO IF  (DOBTemp > 2).
RECODE DOB (ELSE=Copy) INTO DOB_String.
END IF.
EXECUTE.
                         
alter type  DOB_String (f1).
COMPUTE DOB_New  = DATE.MDY(1,1,1900) +( (DOB_String - 2) * 24 * 60 * 60).
FORMATS DOB_New (DATE14).
EXECUTE.

DELETE VARIABLES DOB DOBTemp DOB_String.

AUTORECODE VARIABLES=LastServiceDate
/into LastServiceDateTemp
/print.

STRING LastServiceDate_String (A10).
DO IF  (LastServiceDateTemp > 3).
RECODE LastServiceDate (ELSE=Copy) INTO LastServiceDate_String.
END IF.
EXECUTE.

alter type  LastServiceDate_String (f1).
COMPUTE LastServiceDate_New  = DATE.MDY(1,1,1900) +( (LastServiceDate_String - 2) * 24 * 60 * 60).
FORMATS LastServiceDate_New (DATE14).
EXECUTE.
DELETE VARIABLES LastServiceDate LastServiceDateTemp LastServiceDate_String.
/************END STEP 1 COMPUTATIONS************/.

/************BEGIN STEP 2 COMPUTATIONS************/.

/******COMPUTE THE DEMOGRAPHIC VARS FROM STEP 2******/.
COMPUTE MultiRacial =  RaceBlack + RaceAsian + RaceNativeHawaiian + RaceAlaskaNative + RaceAmericanIndian.
RECODE RaceWhite (1=1) INTO RaceEth.
RECODE RaceBlack (1=2) INTO RaceEth.
RECODE RaceAsian (1=4) INTO RaceEth.
RECODE RaceNativeHawaiian (1=5) INTO RaceEth.
RECODE RaceAlaskaNative (1=5) INTO RaceEth.
RECODE RaceAmericanIndian (1=5) INTO RaceEth.
RECODE Multiracial (2=5)(3=5)(4=5) INTO RaceEth.
RECODE HispanicLatino (1=3) INTO RaceEth.

RECODE Agegroup (4=0) (5=0) (6=1) (7=2) (8=3) (9=3)  INTO age_cat.
RECODE Gender (1=1) (2=2)(Else= sysmis) INTO gender_binary.
RECODE education (11=1)(12=2)(13=3)(14=3)(15=3)(16=3) INTO educ_cat.
RECODE housing (1=1)(2=2)(3=3)(19=4)(5=5)(9=5)(10=5)(11=5)(12=5)(13=5)(14=5)(15=5)(18=5)(6=5) into hous_cat.
RECODE employment (1=1)(2=1)(3=2)(4=2)(5=2)(6=2)(7=2)(8=2) INTO employ.
RECODE education (11=1)(12=2)(13=3)(14=3)(15=3)(16=3) into educ_cat. 
EXECUTE.

COMPUTE edu_cat1 = educ_cat. 
RECODE SexualIdentity (1=1)(2=0)(3=0)(4=0) into SexualIdentity_B.
EXECUTE.

RECODE RaceWhite (1=1) INTO Race.
RECODE RaceBlack (1=2) INTO Race.
RECODE RaceAsian (1=3) INTO Race.
RECODE RaceNativeHawaiian (1=4) INTO Race.
RECODE RaceAlaskaNative (1=4) INTO Race.
RECODE RaceAmericanIndian (1=4) INTO Race.
RECODE Multiracial (2=5)(3=5)(4=5)(5=5)(6=5) INTO Race.
EXECUTE.

DELETE VARIABLES MultiRacial.

RECODE EthnicCentralAmerican (1=1) INTO Ethnic.
RECODE EthnicCuban (1=2) INTO Ethnic.
RECODE EthnicDominican (1=3) INTO Ethnic.
RECODE EthnicMexican (1=4) INTO Ethnic.
RECODE EthnicPuertoRican (1=5) INTO Ethnic.
RECODE EthnicSouthAmerican (1=6) INTO Ethnic.
RECODE EthnicOther (1=7) INTO Ethnic.
EXECUTE.

COMPUTE  Age=DATEDIF(ObservationDate, DOB_new, "years").
VARIABLE LEVEL  Age (SCALE).
FORMATS  Age (F5.0).
VARIABLE WIDTH  Age(5).
EXECUTE.

COMPUTE PTSDSymp = VT_NightmaresThoughts + VT_NotThinkAboutIt + VT_OnGuard + VT_NumbDetached.
RECODE ViolenceTrauma (0=0) into PTSDSymp.
RECODE PTSDSymp (SYSMIS=SYSMIS)(0=0)(1 thru highest =1) into PTSD.
EXECUTE.

/******COMPUTE FUNCTIONAL OUTCOMES FROM STEP 2******/.
COMPUTE K6 = sum (Nervous to worthless).
RECODE K6 (SYSMIS=SYSMIS) (0 thru 13 =1) (14 thru highest =0) INTO NoSeriousPsychDistress.
EXECUTE.

RECODE Cannabis_Use(1=0)(2=2)(3=4)(4=6) into Cannabis_UseREC.
RECODE Cocaine_Use(1=0)(2=2)(3=4)(4=6) into Cocaine_UseREC.
RECODE Stimulants_Use(1=0)(2=2)(3=4)(4=6) into Stimulants_UseREC.
RECODE Meth_Use(1=0)(2=2)(3=4)(4=6) into Meth_UseREC.
RECODE Inhalants_Use(1=0)(2=2)(3=4)(4=6) into Inhalants_UseREC.
RECODE Sedatives_Use(1=0)(2=2)(3=4)(4=6) into Sedatives_UseREC.
RECODE Hallucinogens_Use(1=0)(2=2)(3=4)(4=6) into Hallucinogens_UseREC.
RECODE StreetOpioids_Use(1=0)(2=2)(3=4)(4=6) into StreetOpioids_UseREC.
RECODE RxOpioids_Use(1=0)(2=2)(3=4)(4=6) into RxOpioids_UseREC.
RECODE Other_Use(1=0)(2=2)(3=4)(4=6) into Other_UseREC.
EXECUTE.
COMPUTE IllegalSubstanceUse = sum (Cannabis_UseREC to Other_UseREC).
RECODE IllegalSubstanceUse (SYSMIS=SYSMIS) (0=1) (ELSE=0) INTO NeverUseSub30Days.
EXECUTE.

RECODE Tobacco_Use (1=1)(2 = 0)(3=0)(4=0) into NeverUseTobacco30Days.
RECODE Alcohol_Use (SYSMIS=SYSMIS)(1=1)(ELSE=0) into NotBingeDrinking30Days.
EXECUTE.

/******COMPUTE BIOMARKERS FROM STEP 2******/.
NUMERIC BP (F8.0).
EXECUTE.
DO IF (BPressure_s LT 120 AND BPressure_d < 80).
COMPUTE BP = 0.
ELSE IF (BPressure_s  LT 130 AND BPressure_d  < 80).
COMPUTE BP = 1.
ELSE IF ((BPressure_s LT 140) OR (BPressure_d LT 90)).
COMPUTE BP = 2.
ELSE IF (BPressure_s >= 140 OR BPressure_d >= 90).
COMPUTE BP = 3.
END IF.
EXECUTE.

RECODE BP (0=0)(1=1)(2=1)(3=1) INTO BP_ABR.
EXECUTE.

COMPUTE BMI = Weight / ((Height / 100)**2).
RECODE BMI (SYSMISS=SYSMISS)(lowest thru 25.9999999999999999=0) (26 thru highest =1) INTO BMI_ABR.
RECODE BMI (SYSMISS=SYSMISS)(lowest thru 18.49=0)(18.5 thru 24.99=1) (25 thru 29.99=2)(30 thru highest=3) INTO BMI_cat.

DO IF (Gender =1).
RECODE WaistCircum (SYSMIS = SYSMIS)(0 thru 101 = 0)(102 thru highest = 1) INTO WC.
ELSE IF (Gender ne 1).
RECODE WaistCircum (SYSMIS = SYSMIS)(0 thru 87 = 0)(88 thru highest =1) INTO WC.
END IF.


RECODE BreathCO (SYSMIS = SYSMIS)(0 thru 10 = 0)(10.1 thru highest = 1) INTO BCO_ABR.     
RECODE BreathCO (SYSMIS = SYSMIS)(0 thru 6.9=0)(7 thru 10=1)(10.1 thru highest=2) INTO BCO.

RECODE HgbA1c (SYSMIS = SYSMIS)(0 thru 5.6=0)(5.7 thru highest = 1) INTO A1c_ABR.
RECODE HgbA1c (SYSMIS = SYSMIS)(0 thru 5.6=0)(5.7 thru 6.4=1)(6.5 thru highest=2) INTO A1c.

RECODE Lipid_HDL (SYSMIS = SYSMIS)(1 thru 40=1)(41 thru highest = 0)  INTO HDL.
RECODE Lipid_LDL (SYSMIS = SYSMIS)(130 thru highest=1)(1 thru 129 = 0)  INTO LDL. 
RECODE Lipid_Tri (SYSMIS = SYSMIS)(150 thru highest=1)(1 thru 149 = 0)  INTO Tri.
RECODE Lipid_TotChol (SYSMIS = SYSMIS)(200 thru highest=1)(1 thru 199 = 0)  INTO TotChol.
EXECUTE.

RECODE Plasma_Gluc (SYSMIS = SYSMIS)(0 thru 99 = 0)(100 thru highest = 1) INTO Glucose.  
EXECUTE.

/******COMPUTE BINARY SUBSTANCE USE FROM STEP 2******/.
RECODE Tobacco_Use  (1=0) (2=1) (3=1) (4=1) INTO Tobacc_UseBi.
RECODE Alcohol_Use (1=0) (2=1) (3=1) (4=1) INTO Alcoh_UseBi.
RECODE Cannabis_Use (1=0) (2=1) (3=1) (4=1) INTO Canna_UseBi.
RECODE Cocaine_Use (1=0) (2=1) (3=1) (4=1) INTO Cocain_UseBi.
RECODE Stimulants_Use (1=0) (2=1) (3=1) (4=1) INTO Stim_UseBi.
RECODE Meth_Use (1=0) (2=1) (3=1) (4=1) INTO Meth_UseBi.
RECODE Inhalants_Use (1=0) (2=1) (3=1) (4=1) INTO Inhalant_UseBi.
RECODE Sedatives_Use (1=0) (2=1) (3=1) (4=1) INTO Sedativ_UseBi.
RECODE Hallucinogens_Use (1=0) (2=1) (3=1) (4=1) INTO Hallucinog_UseBi.
RECODE StreetOpioids_Use (1=0) (2=1) (3=1) (4=1) INTO StreetOpio_UseBi.
RECODE RxOpioids_Use (1=0) (2=1) (3=1) (4=1) INTO RxOpioids_UseBi.

COMPUTE NHealthAtRisk=BP_ABR + BMI_ABR + BCO_ABR + HDL + LDL + Tri + Glucose.
EXECUTE.

SAVE OUTFILE='ddFolder\FullData(Step2).sav'.

DATASET ACTIVATE Fulldata.

/************CONCLUDE STEP 2 COMPUTATIONS************/.

/************BEGIN STEP 3 COMPUTATIONS************/.

DATASET ACTIVATE FullData.
SELECT IF (RecordStatus = 0).
EXECUTE.

RECODE Client_ID (20000 thru 29999=2) (100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3)INTO Clinic.
VARIABLE LABELS  
 Clinic 'Clinic where intervention took place'.
VALUE LABELS Clinic 1 'Ramon Velez' 2 'Clay' 3 'Carlos Pagan'.
EXECUTE.

SAVE OUTFILE='dataFilesProcSteps\Demographics.sav'
  /KEEP Client_ID InterviewType_07 Clinic FirstReceivedServicesDate 
                                                  ObservationDate
                                                  gender_binary SexualIdentity_B DOB_New Agegroup race RaceEth Ethnic HispanicLatino RaceBlack
                                                  Age Age_cat Gender  Agegroup educ_cat edu_cat1 SexualIdentity 
                                                   EverServed ActiveDuty_Else ViolenceTrauma PTSDSymp PTSD 
                                                   DiagnosisOne DiagnosisTwo DiagnosisThree                                       
                                                   DiagnosisOneCategory DiagnosisTwoCategory  DiagnosisThreeCategory
  /RENAME ObservationDate= SPARSEnrollmentDate.
EXECUTE.

GET
FILE="dataFilesProcSteps\Demographics.sav".
DATASET NAME Demographics.
DATASET ACTIVATE  Demographics.
FILTER OFF.
USE ALL.
SELECT IF (InterviewType_07 = 1).
EXECUTE.

/************BUILD THE DISCHARGE DATASET************/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'dataFilesProcSteps\Discharge.sav'
  /KEEP Client_ID Clinic InterviewType_07 Assessment ObservationDate LastServiceDate_New.
EXECUTE.

/******MAKE THE FOLLOWING CHANGE: SELECT ON ASSESSMENT EQ 699 INSTEAD OF InterviewType_07 EQ 4 BECAUSE IT IS UNRELIABLE******/.
GET
FILE='dataFilesProcSteps\Discharge.sav'.
DATASET NAME Discharge.
DATASET ACTIVATE  Discharge.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 699).
EXECUTE.

* Identify Duplicate Cases in discharge data - people who were discharged, re-enrolled, and then discharged again. there is also a few duplicates*/

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
EXECUTE.


/*for duplicate records, keep the most recent one*/

DATASET ACTIVATE Discharge.
RENAME VARIABLES (ObservationDate=DischargeDate) (PrimaryLast = Discharged).                                  
SELECT IF(Discharged = 1).
EXECUTE.

COMPUTE YearDischarged=XDATE.YEAR(DischargeDate).
COMPUTE Dis_Month=XDATE.MONTH(DischargeDate).
EXECUTE.

DATASET ACTIVATE Discharge.
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
EXECUTE.

/***SET DICTIONARY INFO FOR NEW VARIABLES****/.
VARIABLE LEVEL  Discharged (ORDINAL)
    /YearDischarged Dis_Month(SCALE).

FORMATS Dis_Month(F8.0) /YearDischarged(F8.0).

VARIABLE WIDTH Dis_Month(8) /YearDischarged(8).  

VARIABLE LABELS  
DischargeDate 'Date client was discharged from the program'
Discharged 'Client was discharged from the program'
Dis_Month 'Month Client was discharged'
YearDischarged "Year client was discharged"
Terminated 'Discharged when grant ended at Ramon Valez'.

VALUE LABELS  
Discharged 0 'No' 1 'Yes'
/Terminated 1 'Terminated when grant ended' 0 'Discharged due to lack of follow up'
/Discharged 0 'Duplicate Case' 1 'Primary Case'.

/******CREATE THE FOLLOWUP DATASETS******/.
/*Create variable to indicate 3-month follow-up*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'dataFilesProcSteps\Followup.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='dataFilesProcSteps\Followup.sav'.
DATASET NAME Followup.
DATASET ACTIVATE  Followup.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 301).
EXECUTE.

RECODE Assessment (301=1) (ELSE=0) INTO Followup3M.
VARIABLE LABELS  Followup3M 'Completed 3-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup3M
0 'no' 1 'yes'.
Delete variables InterviewType_07 Assessment.

/*Create variable to indicate 6-month follow-up*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'dataFilesProcSteps\Followup6.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='dataFilesProcSteps\Followup6.sav'.
DATASET NAME Followup6.
DATASET ACTIVATE  Followup6.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 302).
EXECUTE.

RECODE Assessment (302=1) (ELSE=0) INTO Followup6M.
VARIABLE LABELS  Followup6M 'Completed 6-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup6M
0 'no' 1 'yes'.
Delete variables InterviewType_07 Assessment.

/*Create variable to indicate 9-month follow-up*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'dataFilesProcSteps\Followup9.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='dataFilesProcSteps\Followup9.sav'.
DATASET NAME Followup9.
DATASET ACTIVATE  Followup9.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 303).
EXECUTE.

RECODE Assessment (303=1) (ELSE=0) INTO Followup9M.
VARIABLE LABELS  Followup9M 'Completed 9-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup9M
0 'no' 1 'yes'.
Delete variables InterviewType_07 Assessment.

/*Create variable to indicate 12-month follow-up*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'dataFilesProcSteps\Followup12.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='dataFilesProcSteps\Followup12.sav'.
DATASET NAME Followup12.
DATASET ACTIVATE  Followup12.
FILTER OFF.
USE ALL.
SELECT IF (Assessment = 304).
EXECUTE.

RECODE Assessment (304=1) (ELSE=0) INTO Followup12M.
VARIABLE LABELS  Followup12M 'Completed 12-month follow-up interview'.
EXECUTE.
VALUE LABELS Followup12M
0 'no' 1 'yes'.
Delete variables InterviewType_07 Assessment.

/* Merge Followup sheets.
DATASET ACTIVATE Followup.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup6.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup9.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup12.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup.
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

/*Merge Demographics and discharge datasets*/.
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

/*Merge Followup and discharge datasets*/.
DATASET ACTIVATE Demographics.
SORT CASES BY Client_ID.
DATASET ACTIVATE Followup.
SORT CASES BY Client_ID.
DATASET ACTIVATE Demographics.
MATCH FILES /FILE=*
  /FILE='Followup'
  /BY Client_ID.
EXECUTE.
DATASET CLOSE Followup.
DATASET CLOSE Followup6.
DATASET CLOSE Followup9.
DATASET CLOSE Followup12.

DATASET ACTIVATE FullData.
FILTER OFF.
USE ALL.
SELECT IF (InterviewType_07  <  4).
EXECUTE.

DELETE VARIABLES DOB_New Clinic LastServiceDate_New GenderSpec EthnicOtherSpec gender_binary race
    Agegroup RaceEth Ethnic Age Age_cat Gender HispanicLatino EthnicCentralAmerican EthnicCuban EthnicDominican EthnicMexican EthnicPuertoRican EthnicSouthAmerican 
    RaceAmericanIndian EthnicOther Agegroup educ_cat edu_cat1 SexualIdentity_B
    RaceBlack RaceAsian  RaceNativeHawaiian RaceAlaskaNative RaceWhite RaceAmericanIndian Agegroup SexualIdentity SexualIdentityOther WhyNotConducted 
    GAFScore EverServed ConductedInterview ViolenceTrauma PTSDSymp PTSD EverServed ActiveDuty_Self ActiveDuty_Else
    VT_NightmaresThoughts VT_NotThinkAboutIt VT_OnGuard VT_NumbDetached EmploymentType_07 OtherResponseSpecify ReassessmentStatus_07 OtherReassessment_07 DischargeStatus 
    OtherDischargeStatus Svc_MentalHealthFreq_07 SiteID FirstReceivedServicesDate 
    ConsumerPrivateInsurance CurrentSamhsaGrantFunding DiagnosisOneCategory DiagnosisOne DiagnosisTwo DiagnosisThree DiagnosisThreeCategory DiagnosisTwoCategory 
    MedicaidMedicare Other_UseSpec OtherFederalGrantFunding OtherResponse StateFunding OtherEnrolledSpec OtherHousingSpec.
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

VARIABLE LEVEL  PrimaryLast (ORDINAL) /MatchSequence (SCALE).
VARIABLE LABELS  
    PrimaryLast 'Indicator of each last matching case as Primary' 
    MatchSequence 'Sequential count of matching cases'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.

FREQUENCIES VARIABLES=PrimaryLast MatchSequence.
EXECUTE.
                            
DATASET ACTIVATE FullData.
RECODE MatchSequence (0=1)(1=1)(2=2)(3=3) into Time.
EXECUTE.

SAVE OUTFILE='ddFolder\FullData(Step3).sav'.

/************CONCLUDE STEP 3 COMPUTATIONS************/.

/************BEGIN STEP 4 COMPUTATIONS************/.
INSERT FILE='D:\DropBox\tempchin\Data Files\SPSS Syntax\Processing Steps\STEP 4 - Create Enrollment Form and Tracking Form datasets.sps'.

DATASET ACTIVATE PIPBHC_Long.
SAVE OUTFILE='ddFolder\FullData(Step4).sav'.

