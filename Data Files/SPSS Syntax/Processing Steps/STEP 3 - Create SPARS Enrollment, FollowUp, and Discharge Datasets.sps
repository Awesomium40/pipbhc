* Encoding: UTF-8.

/*Create dataset with just the demographic info that applies to every observation*/

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
SAVE OUTFILE= 'Demographics.sav'
  /KEEP Client_ID InterviewType_07 Clinic FirstReceivedServicesDate 
                                                  ObservationDate homeless_intake CurrentWorkorSchool_intake 
                                                  gender_binary SexualIdentity_B DOB_New Agegroup race RaceEth Ethnic HispanicLatino RaceBlack
                                                  Age Age_cat Gender  Agegroup educ_cat edu_cat1 SexualIdentity 
                                                   EverServed ActiveDuty_Else ViolenceTrauma PTSDSymp PTSD 
                                                   DiagnosisOne DiagnosisTwo DiagnosisThree                                       
                                                   DiagnosisOneCategory DiagnosisTwoCategory  DiagnosisThreeCategory
  /RENAME ObservationDate= SPARSEnrollmentDate.
EXECUTE.
  


GET
FILE="\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps\Demographics.sav".
DATASET NAME Demographics.
DATASET ACTIVATE  Demographics.
FILTER OFF.
USE ALL.
SELECT IF (InterviewType_07 = 1).
EXECUTE.


DATASET ACTIVATE Demographics.
* Identify Duplicate Cases.
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
DELETE VARIABLES InterviewType_07 PrimaryLast MatchSequence.


/*Split out files into discharge data only*/

DATASET ACTIVATE FullData.
SAVE OUTFILE= 'Discharge.sav'
  /KEEP Client_ID InterviewType_07 ObservationDate LastServiceDate_New.
EXECUTE.

GET
FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps\Discharge.sav'.
DATASET NAME Discharge.
DATASET ACTIVATE  Discharge.
FILTER OFF.
USE ALL.
SELECT IF (InterviewType_07 = 4).
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
                        VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
                        VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
                        VARIABLE LEVEL  PrimaryLast (ORDINAL).
                        EXECUTE.

                    
                        /*for duplicate records, keep the most recent one*/
                
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

/*Create variable to indicate 3-month follow-up*/.
DATASET ACTIVATE FullData.
SAVE OUTFILE= 'Followup.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps\Followup.sav'.
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
SAVE OUTFILE= 'Followup6.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps\Followup6.sav'.
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
SAVE OUTFILE= 'Followup9.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps\Followup9.sav'.
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
SAVE OUTFILE= 'Followup12.sav'
  /KEEP Client_ID InterviewType_07 Assessment.
EXECUTE.

GET
FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps\Followup12.sav'.
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

                        /*Create variable for time between enrollment and discharge*/
            
              * Date and Time Wizard: TimeEnrolled.
                    COMPUTE  TimeEnrolled=(DischargeDate - SPARSEnrollmentDate) / time.days(1).
                    VARIABLE LABELS  TimeEnrolled "Number of days between enrollment in PIPBHC and discharge".
                    VARIABLE LEVEL  TimeEnrolled (SCALE).
                    FORMATS  TimeEnrolled (F8.2).
                    VARIABLE WIDTH  TimeEnrolled(8).
                    EXECUTE.           

/*Create dataset for just follow-up data*/

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
                                                   GAFDate_New MedicaidMedicare Other_UseSpec OtherFederalGrantFunding OtherResponse StateFunding OtherEnrolledSpec OtherHousingSpec homeless_intake CurrentWorkorSchool_intake.
.                                                    EXECUTE.

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

