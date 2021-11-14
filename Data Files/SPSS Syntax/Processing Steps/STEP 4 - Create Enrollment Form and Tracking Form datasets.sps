* Encoding: UTF-8.
*Add enrollment form data to Baseline SPARS data*/

*********************************RAMON VALEZ BASELINE FORMS****************************************
*Creating dataset for mental health screenings*/

GET DATA
  /TYPE=XLSX
  /FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Additional Client Information Forms\Ramon Velez Forms\Enrollment Forms\Enrollment Form MH Data.xlsx'
  /SHEET=name 'Sheet1'
  /READNAMES=ON
  /LEADINGSPACES IGNORE=YES
  /TRAILINGSPACES IGNORE=YES
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME MentalHealth.

*Labeling mental health variables*/

DATASET ACTIVATE MentalHealth.
RENAME VARIABLES (GAD7 = T_GAD7).
RENAME VARIABLES (PHQ9 = T_PHQ9).
RENAME VARIABLES (ModifiedMini = T_ModifiedMini).
RENAME VARIABLES (PCPTSD = T_PCPTSD).
RENAME VARIABLES (MI = T_MI).
RENAME VARIABLES (SMI = T_SMI).
RENAME VARIABLES (Schiz = T_Schiz).
RENAME VARIABLES (Bipolar = T_Bipolar).
RENAME VARIABLES (MajDep = T_MajDep).
RENAME VARIABLES (Other = T_MI_Other).
RENAME VARIABLES (OtherType = T_OtherType).

VARIABLE LABELS
T_GAD7 'Generalized Anxiety Disorder Scale Score'
T_PHQ9 'Patient Health Questionnaire 9 Score'
T_PCPTSD 'Post-Traumatic Stress Disorder Score'
T_ModifiedMini 'Modified Mini Screen Score'
T_MI 'Any Mental Health Diagnosis'
T_SMI 'Severe Mental Health Diagnosis'
T_Schiz 'Schizophrenia Diagnosis'
T_Bipolar 'Bipolar Diagnosis'
T_MajDep 'Major Depressive Disorder Diagnosis'
T_MI_Other 'Other Mental Illness Diagnosis'.
EXECUTE.

VALUE LABELS
T_MI to T_MI_Other
0 'No'
1 'Yes'.
EXECUTE.

COMPUTE T_Multiple_SMI=T_Schiz + T_Bipolar + T_MajDep.
RECODE T_GAD7 (0 thru 4=0) (5 thru 9=1) (10 thru 14=2) (15 thru 21=3) INTO T_GAD7_cat.
RECODE T_PHQ9 (0 thru 4=0) (5 thru 9=1) (10 thru 14=2) (15 thru 19=3) (20 thru 27=4) INTO T_PHQ9_cat.
RECODE T_PCPTSD (3 thru 5=1) (0 thru 2=0) INTO T_PTSD_cat.
RECODE T_ModifiedMini (0 thru 6=1) (7 thru 9=2)(10 thru highest = 3)(sysmis=sysmis) INTO T_MMS_cat.
EXECUTE.

VARIABLE LABELS
T_GAD7_cat 'Generalized Anxiety Disorder Scale Score in Categories'
T_PHQ9_cat 'Patient Health Questionnaire Score in Categories'
T_PTSD_cat 'Post-Traumatic Stress Disorder Score in Categories'
T_Multiple_SMI 'Number of SMI Diagnoses'
T_MMS_cat 'Modified Mini Screen Score in Categories'.
EXECUTE.

VALUE LABELS T_GAD7_cat
0 'Minimal'
1 'Mild'
2 'Moderate'
3 'Severe'.
VALUE LABELS T_PHQ9_cat
0 'Minimal'
1 'Mild'
2 'Moderate'
3 'Moderately Severe'
4 'Severe'.
VALUE LABELS T_PTSD_cat
0 'No PTSD'
1 'Yes PTSD'.
VALUE LABELS T_MMS_cat
1 'Low likelihood of MI'
2 'Moderate likelihood of MI'
3 'High likelihood of MI'.

****************************************************************Enrollment form additional info***********************************************************************/

GET DATA
  /TYPE=XLSX
  /FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Additional Client Information Forms\Ramon Velez Forms\Enrollment Forms\Enrollment Form Additional Information.xlsx'
  /SHEET=name 'Enrollment Form'
  /READNAMES=ON
  /LEADINGSPACES IGNORE=YES
  /TRAILINGSPACES IGNORE=YES
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DELETE VARIABLES V8 AdditionalComments.
DATASET NAME AdditionalInformation.

*Labeling additional info variables*/

DATASET ACTIVATE AdditionalInformation.
RENAME VARIABLES
(CrimJustice = T_CrimJustice)
(CJType = T_CJType)
(SupportHouse = T_SupportHouse)
(SocialRehabProg = T_SocialRehabProg).

VARIABLE LABELS
T_CrimJustice 'Involved in the Criminal Justice System?'
T_CJType 'Type of Criminal Justice System Involvement'
T_SupportHouse 'Client Living in Supportive Housing or Independent Living Facility?'
T_SocialRehabProg 'Client Participating in Social/Rehabilitative Programs?'.

VALUE LABELS T_CrimJustice T_SupportHouse T_SocialRehabProg
0 'No'
1'Yes'.
VALUE LABELS T_CJType
0 'Parolee'
1 'Probation'
2 'Drug Court'.

*Merging Enrollment Form Sections*/

DATASET ACTIVATE AdditionalInformation.
SORT CASES BY Client_ID.
DATASET ACTIVATE MentalHealth.
SORT CASES BY Client_ID.
DATASET ACTIVATE AdditionalInformation.
MATCH FILES /FILE=*
  /FILE='MentalHealth'
  /BY Client_ID.
EXECUTE.
DATASET NAME EnrollmentData.
ALTER TYPE ALL (A=A30).
dataset close MentalHealth.


*Tracking Form Import*/

GET DATA
  /TYPE=XLSX
  /FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Additional Client Information Forms\Ramon Velez Forms\Tracking Forms\TIC Tracking Forms Data.xlsx'
  /SHEET=name 'Master'
  /READNAMES=ON
  /LEADINGSPACES IGNORE=YES
  /TRAILINGSPACES IGNORE=YES
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.

DELETE VARIABLES PHQ_Q1 PHQ_Q2 PHQ_Q3 PHQ_Q4 PHQ_Q5 PHQ_Q6 PHQ_Q7 PHQ_Q8 PHQ_Q9 PHQ_Q10 GAD_1 GAD_2 
GAD_3 GAD_4 GAD_5 GAD_6 GAD_7 PTSD_1 PTSD_2 PTSD_3 PTSD_4 PTSD_5 CJType2 CJOther.

DATASET NAME TrackingForms.

*Labeling tracking form variables*/

DATASET ACTIVATE TrackingForms.
RENAME VARIABLES (MI = T_MI).
RENAME VARIABLES (SMI = T_SMI).
RENAME VARIABLES (Schiz = T_Schiz).
RENAME VARIABLES (Bipolar = T_Bipolar).
RENAME VARIABLES (MajDep = T_MajDep).
RENAME VARIABLES (SupportHouse = T_SupportHouse).
RENAME VARIABLES (SocialRehabProg = T_SocialRehabProg).
RENAME VARIABLES (Employ = T_Employ).
RENAME VARIABLES (RatePerformance = T_RatePerformance).
RENAME VARIABLES (CrimJustice = T_CrimJustice).
RENAME VARIABLES (CJType1 = T_CJType).
RENAME VARIABLES (Medication = T_Medication).
RENAME VARIABLES (MedFill = T_MedFill).
RENAME VARIABLES (MedTake = T_MedTake).
RENAME VARIABLES (Smoking = T_Smoking).
RENAME VARIABLES (CigNumber = T_CigNumber).
RENAME VARIABLES (PHQ9 = T_PHQ9).
RENAME VARIABLES (GAD7 = T_GAD7).
RENAME VARIABLES (PCPTSD = T_PCPTSD).
RENAME VARIABLES (PTSD_experiencedtrauma = T_PTSD_experiencedtrauma).

VARIABLE LABELS
T_MI 'Any Mental Health Diagnosis'
T_SMI 'Severe Mental Health Diagnosis'
T_Schiz 'Schizophrenia Diagnosis'
T_Bipolar 'Bipolar Diagnosis'
T_MajDep 'Major Depressive Disorder Diagnosis'
T_SupportHouse 'Client Living in Supportive Housing or Independent Living Facility?'
T_SocialRehabProg 'Client Participating in Social/Rehabilitative Programs?'
T_Employ 'Is the Client Working Part- or Full-time?'
T_CigNumber 'Self-Reported Number of Cigarettes Smoked Each Day'
T_RatePerformance 'How Would Client Rate Their Performance at Work?'
T_CrimJustice 'Involved in the Criminal Justice System?'
T_CJType 'Type of Criminal Justice System Involvement'
T_Medication 'Client Has Been Prescribed Medication for Mental Health, Physical Health, or Substance Use'
T_MedFill 'How Often Would Client Say They Fill Their Prescription?'
T_MedTake 'How Often Would Client Say They Take Their Medication?'
T_Smoking 'Client Smokes Cigarettes'
T_GAD7 'GAD7 Scores from Tracking Form'
T_PHQ9 'PHQ9 Scores from Tracking Form'
T_PCPTSD 'PCPTSD Scores from Tracking Form'.
EXECUTE.

recode T_MedTake  (0=3)(1=2)(2=1)(3=0).
recode T_MedFill (0=3)(1=2)(2=1)(3=0).

VALUE LABELS T_MI to T_Employ T_Medication T_Smoking
0 'No'
1 'Yes'.
VALUE LABELS T_RatePerformance
0 'Very Satisfactory'
1 'Satisfactory'.
VALUE LABELS T_CrimJustice
0 'No'
1'Yes'.
VALUE LABELS T_CJType
0 'Parolee'
1 'Probation'
2 'Drug Court'.
VALUE LABELS T_MedFill T_MedTake
3 'All of the Time'
2 'Most of the time'
1 'Sometimes'
0 'Never'.

COMPUTE T_Multiple_SMI=T_Schiz + T_Bipolar + T_MajDep.
RECODE T_GAD7 (0 thru 4=0) (5 thru 9=1) (10 thru 14=2) (15 thru 21=3) INTO T_GAD7_cat.
RECODE T_PHQ9 (0 thru 4=0) (5 thru 9=1) (10 thru 14=2) (15 thru 19=3) (20 thru 27=4) INTO T_PHQ9_cat.
RECODE T_PCPTSD (sysmis = 0).
RECODE T_PCPTSD (3 thru 5=1) (0 thru 2=0) INTO T_PTSD_cat.

EXECUTE.

VARIABLE LABELS
T_GAD7_cat 'Generalized Anxiety Disorder Scale'
T_PHQ9_cat 'Patient Health Questionnaire'
T_PTSD_cat 'Post-Traumatic Stress Disorder'.

VALUE LABELS T_GAD7_cat
0 'Minimal'
1 'Mild'
2 'Moderate'
3 'Severe'.
VALUE LABELS T_PHQ9_cat
0 'Minimal'
1 'Mild'
2 'Moderate'
3 'Moderately Severe'
4 'Severe'.
VALUE LABELS T_PTSD_cat
0 'No'
1 'Yes'.


*****************************************IMPORT FORMS JANUARY 2020 AND LATER**********************************************/

GET DATA
  /TYPE=XLSX
  /FILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Additional Client Information Forms\Additional Client '+
    'Information Form Spreadsheet.xlsx'
  /SHEET=name 'For IMPORT - DO NOT EDIT'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME AdditionalMeasures.
ALTER TYPE ALL (A=A30).
RENAME VARIABLES (MI = T_MI).
RENAME VARIABLES (Schiz = T_Schiz).
RENAME VARIABLES (Bipolar = T_Bipolar).
RENAME VARIABLES (MajDep = T_MajDep).
RENAME VARIABLES (Other = T_MI_Other).
RENAME VARIABLES (OtherType = T_OtherType).
RENAME VARIABLES (CrimJustice = T_CrimJustice).
RENAME VARIABLES (SupportHouse = T_SupportHouse).
RENAME VARIABLES (SocialRehabProg = T_SocialRehabProg).
RENAME VARIABLES (JobTraining = T_JobTraining).
RENAME VARIABLES (Employ = T_Employ).
RENAME VARIABLES (RatePerformance = T_RatePerformance).
RENAME VARIABLES (Medication = T_Medication).
RENAME VARIABLES (MedTake = T_MedTake).
RENAME VARIABLES (PHQ9 = T_PHQ9).
RENAME VARIABLES (GAD7 = T_GAD7).
RENAME VARIABLES (PCPTSD = T_PCPTSD).

DATASET ACTIVATE AdditionalMeasures.
RENAME VARIABLES (ModifiedMini = T_ModifiedMini).
RENAME VARIABLES (Time = T_Time).
RENAME VARIABLES (ACE = T_ACE).
RENAME VARIABLES (FollowUp3M = T_FollowUp3M).

*set -1 as a missing value for the ACE score*

missing values T_ACE (-1).

COMPUTE T_Multiple_SMI=T_Schiz + T_Bipolar + T_MajDep.
EXECUTE.
RECODE T_Multiple_SMI (0=0)(1=1)(2=1)(3=1) into T_SMI.

VARIABLE LABELS
T_ACE 'Adverse Childhood Experiences Score'
T_GAD7 'Generalized Anxiety Disorder Scale Score'
T_PHQ9 'Patient Health Questionnaire 9 Score'
T_PCPTSD 'Post-Traumatic Stress Disorder Score'
T_ModifiedMini 'Modified Mini Screen Score'
T_MI 'Any Mental Health Diagnosis'
T_SMI 'Severe Mental Health Diagnosis'
T_Schiz 'Schizophrenia Diagnosis'
T_Bipolar 'Bipolar Diagnosis'
T_MajDep 'Major Depressive Disorder Diagnosis'
T_MI_Other 'Other Mental Illness Diagnosis'
T_SupportHouse 'Client Living in Supportive Housing or Independent Living Facility?'
T_SocialRehabProg 'Client Participating in Social/Rehabilitative Programs?'
T_Employ 'Is the Client Working Part- or Full-time?'
T_RatePerformance 'How Would Client Rate Their Performance at Work?'
T_CrimJustice 'Involved in the Criminal Justice System?'
T_Medication 'Client Has Been Prescribed Medication for Mental Health, Physical Health, or Substance Use'
T_MedTake 'How Often Would Client Say They Take Their Medication?'
T_JobTraining 'Is the client involved in any job training programs'
T_FollowUp3M 'Does the client need follow-up in 3 months?'.
EXECUTE.

VALUE LABELS T_MI
T_SMI
T_Schiz
T_MajDep
T_Bipolar
T_MI_Other
T_CrimJustice T_Employ T_SupportHouse
T_SocialRehabProg
T_JobTraining T_Medication  T_FollowUp3M
0 'No'
1 'Yes'.

VALUE LABELS T_RatePerformance
0 'Very poor'
1 'Poor'
2 'Good'
3 'Very good'
4 'Excellent'.
VALUE LABELS T_MedTake
3 'All of the Time'
2 'Most of the time'
1 'Sometimes'
0 'Never'.

RECODE T_GAD7 (0 thru 4=0) (5 thru 9=1) (10 thru 14=2) (15 thru 21=3) INTO T_GAD7_cat.
RECODE T_PHQ9 (0 thru 4=0) (5 thru 9=1) (10 thru 14=2) (15 thru 19=3) (20 thru 27=4) INTO T_PHQ9_cat.
RECODE T_PCPTSD (3 thru 5=1) (0 thru 2=0) INTO T_PTSD_cat.
RECODE T_ModifiedMini (0 thru 6=1) (7 thru 9=2)(10 thru highest = 3)(sysmis=sysmis) INTO T_MMS_cat.
RECODE T_ACE (0 =0) (1 thru 3=1) (4 thru 10=2)(sysmis=sysmis)   INTO T_ACE_cat.
EXECUTE.

VARIABLE LABELS
T_GAD7_cat 'Generalized Anxiety Disorder Scale Score in Categories'
T_PHQ9_cat 'Patient Health Questionnaire Score in Categories'
T_PTSD_cat 'Post-Traumatic Stress Disorder Score in Categories'
T_Multiple_SMI 'Number of SMI Diagnoses'
T_MMS_cat 'Modified Mini Screen Score in Categories'
T_ACE_cat 'Adverse Childhood Experiences Score in Categories'.

VALUE LABELS T_GAD7_cat
0 'Minimal'
1 'Mild'
2 'Moderate'
3 'Severe'.
VALUE LABELS T_PHQ9_cat
0 'Minimal'
1 'Mild'
2 'Moderate'
3 'Moderately Severe'
4 'Severe'.
VALUE LABELS T_PTSD_cat
0 'No PTSD'
1 'Yes PTSD'.
VALUE LABELS T_MMS_cat
1 'Low likelihood of MI'
2 'Moderate likelihood of MI'
3 'High likelihood of MI'.

VALUE LABELS ClientType
1 'New Client'
2 'Existing Client'.

/* This variable is deleted and reinitiated below. Values other than 1 are not used.
VALUE LABELS T_Time
1 'Intake'
2 '6-Month'
3 '12-Month'
4 '3-Month'
5 '9-Month'.

VALUE LABELS T_ACE_Cat
0 '0'
1 '1-3'
2 '4+'.

DATASET ACTIVATE AdditionalMeasures.
FILTER OFF.
USE ALL.
SELECT IF (Client_ID >= 0).
EXECUTE.

*******************************************************************************************************************
/*create a verson of enrollment data at intake************************************************************************//

DATASET ACTIVATE enrollmentdata.
DATASET COPY enrollment_demographics.
DATASET ACTIVATE enrollment_demographics.
delete variables ObservationDate.

DATASET ACTIVATE AdditionalMeasures.
DATASET COPY AdditionalMeasures_demographics.
DATASET ACTIVATE AdditionalMeasures_demographics.
FILTER OFF.
USE ALL.
SELECT IF (T_Time = 1).
EXECUTE.

DATASET ACTIVATE enrollment_demographics.
ADD FILES /FILE=*
  /FILE='AdditionalMeasures_demographics'.
EXECUTE.
DELETE VARIABLES T_Time.
DATASET CLOSE AdditionalMeasures_demographics.

DATASET ACTIVATE enrollment_demographics.
RENAME VARIABLES (T_CrimJustice = T_CrimJustice_intake).
RENAME VARIABLES (T_CJType = T_CJType_intake).
RENAME VARIABLES (T_SupportHouse = T_SupportHouse_intake).
RENAME VARIABLES (T_SocialRehabProg = T_SocialRehabProg_intake).
RENAME VARIABLES (T_GAD7 = T_GAD7_intake).
RENAME VARIABLES (T_PHQ9 = T_PHQ9_intake).
RENAME VARIABLES (T_ModifiedMini = T_ModifiedMini_intake).
RENAME VARIABLES (T_PCPTSD = T_PCPTSD_intake).
RENAME VARIABLES (T_ACE = T_ACE_intake).
RENAME VARIABLES (T_MI = T_MI_intake).
RENAME VARIABLES (T_SMI = T_SMI_intake).
RENAME VARIABLES (T_Schiz = T_Schiz_intake).
RENAME VARIABLES (T_Bipolar = T_Bipolar_intake).
RENAME VARIABLES (T_MajDep = T_MajDep_intake).
RENAME VARIABLES (T_Multiple_SMI = T_Multiple_SMI_intake).
RENAME VARIABLES (T_GAD7_cat = T_GAD7_cat_intake).
RENAME VARIABLES (T_PHQ9_cat = T_PHQ9_cat_intake).
RENAME VARIABLES (T_PTSD_cat = T_PTSD_cat_intake).
RENAME VARIABLES (T_MMS_cat = T_MMS_cat_intake).
RENAME VARIABLES (T_ACE_cat = T_ACE_intake_cat).
RENAME VARIABLES (T_MI_Other = T_MI_Other_intake).
RENAME VARIABLES (T_OtherType = T_OtherType_intake).
RENAME VARIABLES (ClientType = ClientType_intake).
RENAME VARIABLES (T_JobTraining = T_JobTraining_intake).
RENAME VARIABLES (T_Employ = T_Employ_intake).
RENAME VARIABLES (T_RatePerformance = T_RatePerformance_intake).
RENAME VARIABLES (T_Medication = T_Medication_intake).
RENAME VARIABLES (T_MedTake = T_MedTake_intake).


DATASET ACTIVATE Demographics.
SORT CASES BY Client_ID.
DATASET ACTIVATE enrollment_demographics.
SORT CASES BY Client_ID.
DATASET ACTIVATE Demographics.
MATCH FILES /FILE=*
  /FILE='enrollment_demographics'
  /BY Client_ID.
EXECUTE.

DATASET CLOSE enrollment_demographics.


******************************************************************************************************************
/*Merge Additional Measures and Enrollment Data to Determine who is missing a form*/


DATASET ACTIVATE TrackingForms.
ADD FILES /FILE=*
  /FILE='EnrollmentData'.
EXECUTE.
dataset close EnrollmentData.

DATASET ACTIVATE TrackingForms.
ADD FILES /FILE=*
  /FILE='AdditionalMeasures'.
EXECUTE.
dataset close AdditionalMeasures.

DATASET ACTIVATE TrackingForms.
FILTER OFF.
USE ALL.
SELECT IF (Client_ID > 0).
EXECUTE.
DELETE VARIABLES T_Time.


* Identify Duplicate Cases.
DATASET ACTIVATE TrackingForms.
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
EXECUTE.

                                              DATASET ACTIVATE TrackingForms.
                                              RENAME VARIABLES  MatchSequence = T_Time.
                                                 EXECUTE.
                                              RECODE T_Time (0=1).                                   .
                                                VARIABLE LABELS  T_Time 'Indicates how many times patient got a follow up with tracking form'.
                                                VALUE LABELS  T_Time 
                                                1 'Enrollment tracking form' 2 'First follow up' 3 'Second follow up' 4 'Third follow up'.
                                                 EXECUTE.
                                                DELETE VARIABLES PrimaryLast.
                                                 EXECUTE.


/******************************Recode variables to create binary versions**********************/

DATASET ACTIVATE TrackingForms.
RECODE T_GAD7_cat (0=0) (1=1) (2=1) (3=1) INTO T_GAD7_Bi.
RECODE T_PHQ9_cat (0=0) (1=1) (2=1) (3=1) (4=1) INTO T_PHQ9_Bi.
RECODE T_MMS_cat (1=0) (2=1) (3=1) INTO T_MMS_Bi.
RECODE T_ACE_cat (0=0) (1=0) (2=1)(sysmis=sysmis)  INTO T_ACE_Bi.

VARIABLE LABELS
T_GAD7_Bi 'Binary GAD-7 Scores at Enrollment'
T_PHQ9_Bi 'Binary PHQ-9 Scores at Enrollment'
 T_MMS_Bi 'Binary Modified Mini Screen Scores at Enrollment'
 T_ACE_Bi 'Binary Adverse Childhood Experience Scores at Enrollment'.
EXECUTE.

VALUE LABELS
T_GAD7_Bi
T_PHQ9_Bi
T_MMS_Bi
T_PTSD_cat T_MI T_SMI T_Schiz T_Bipolar T_MajDep T_ACE_bi
 0 'Not at Risk Based on Screening Score'
 1 'At Risk Based on Screening Score'.

COMPUTE NMentalHealth=Sum(T_GAD7_Bi, T_PHQ9_Bi, T_MMS_Bi, T_PTSD_cat, T_ACE_bi).
EXECUTE.


/*Merge With Final SPARS Dataset*/

DATASET ACTIVATE FullData.
ADD FILES /FILE=*
  /FILE='TrackingForms'.
EXECUTE.

DATASET ACTIVATE FullData.
SORT CASES BY Client_ID.
DATASET ACTIVATE Demographics.
SORT CASES BY Client_ID.
DATASET ACTIVATE FullData.
MATCH FILES /FILE=*
  /TABLE='Demographics'
  /RENAME (InterviewType_07 = d0) 
  /BY Client_ID
  /DROP= d0.
EXECUTE.

DATASET CLOSE Demographics.
DATASET CLOSE TrackingForms.
DATASET ACTIVATE FullData.
DATASET NAME PIPBHC_Long.




