* Encoding: UTF-8.

*Variables created in this syntax:

*   DEMOGRAPHICS:
    Gender
    Gender_Binary
    Agegroup2
    RaceEth
    Ethnic
    Age
    SexualIdentity


*    HEALTH OUTCOMES
    BP_ABR
    BP
    BMI_ABR
    BMI_Cat
    WC
    BCO_Abr
    BCO
    Glucose
    A1C_Abr
    A1C
    HDL
    LDL
    Tri

*    FUNCTIONAL OUTCOMES
    Healthy 			(binary)
    FunctioningPercep 		(linear)
    PosFunctioning 		(binary)
    k6 		                   (linear)
    NoSeriousPsychDistress 	(binary)
    IllegalSubstanceUse		(linear)
    NeverUseSub30Days 		(binary)
    NeverUseTobacco30Days 	(binary)
    NotBingeDrinking30Days 	(binary)
    ViolenceTrauma 		(binary)
    PTSDSymp		(linear)
    PTSD 			(binary)
    PhysViolence 		(binary)
    NightsAwayFromHome	(linear)
    RetainedComm 		(binary)
    StableHousing 		(binary)
    Homeless 		(binary)
    CurrentWorkorSchool 	(binary)
    NoCriminalJust		(binary)
    CarePercep		(linear) - follow up only
    PosCare 			(binary) - follow up only
    SocialConnect		(linear)
    PosSocialConnect		(binary) ./*

DATASET ACTIVATE FullData.

/*Race Ethnicity Recode According to Federal Guidelines*/.
Compute MultiRacial =  RaceBlack + RaceAsian + RaceNativeHawaiian + RaceAlaskaNative + RaceAmericanIndian.
RECODE RaceWhite (1=1) INTO RaceEth.
RECODE RaceBlack (1=2) INTO RaceEth.
RECODE RaceAsian (1=4) INTO RaceEth.
RECODE RaceNativeHawaiian (1=5) INTO RaceEth.
RECODE RaceAlaskaNative (1=5) INTO RaceEth.
RECODE RaceAmericanIndian (1=5) INTO RaceEth.
RECODE Multiracial (2=5)(3=5)(4=5) INTO RaceEth.
RECODE HispanicLatino (1=3) INTO RaceEth.
VALUE LABELS
    RaceEth
    1 'White, non-Hispanic'
    2 'Black or African American, non-Hispanic'
    3 'Hispanic or Latino'
    4 'Asian, non-Hispanic'
    5 'Other,non-Hispanic, including two or more races'.
EXECUTE.

RECODE RaceWhite (1=1) INTO Race.
RECODE RaceBlack (1=2) INTO Race.
RECODE RaceAsian (1=3) INTO Race.
RECODE RaceNativeHawaiian (1=4) INTO Race.
RECODE RaceAlaskaNative (1=4) INTO Race.
RECODE RaceAmericanIndian (1=4) INTO Race.
RECODE Multiracial (2=5)(3=5)(4=5)(5=5)(6=5) INTO Race.
VALUE LABELS
    Race
    1 'White'
    2 'Black or African American'
    3 'Asian'
    4 'Native Hawaiian/PI, Alaska Native, or American Indian'
    5 'Two or more races'.
EXECUTE.
DELETE VARIABLES MultiRacial.

/*Ethnic origin*/.
RECODE EthnicCentralAmerican (1=1) INTO Ethnic.
RECODE EthnicCuban (1=2) INTO Ethnic.
RECODE EthnicDominican (1=3) INTO Ethnic.
RECODE EthnicMexican (1=4) INTO Ethnic.
RECODE EthnicPuertoRican (1=5) INTO Ethnic.
RECODE EthnicSouthAmerican (1=6) INTO Ethnic.
RECODE EthnicOther (1=7) INTO Ethnic.
VALUE LABELS
    Ethnic
    1 'Central American'
    2 'Cuban'
    3 'Dominican'
    4 'Mexican'
    5 'Puerto Rican'
    6 'South American'
    7 'Other'.
EXECUTE.


/*Age based on today's date*/.
COMPUTE  Age=DATEDIF(ObservationDate, DOB_new, "years").
VARIABLE LABELS  Age "Age in Years at Time of Admission".
VARIABLE LEVEL  Age (SCALE).
FORMATS  Age (F5.0).
VARIABLE WIDTH  Age(5).
EXECUTE.

RECODE Agegroup (4=0) (5=0) (6=1) (7=2) (8=3) (9=3)  INTO age_cat.
VALUE LABELS age_cat
    0 '34 or less'
    1 '35 to 44'
    2 '45 to 54'
    3 '55 and Up'.
EXECUTE.

*Gender.
RECODE Gender (1=1) (2=2)(Else= sysmis) INTO gender_binary.
VALUE LABELS
    gender_binary
    1 'Male'
    2 'Female'.
EXECUTE.

*Education.
RECODE education (11=1)(12=2)(13=3)(14=3)(15=3)(16=3) into educ_cat.
VALUE LABELS
    educ_cat
    1 '11th Grade or less'
    2 '12th Grade/High School Diploma/ Equivalent (GED)'
    3 'Some College Or University or Higher'.
EXECUTE.
VARIABLE LABELS educ_cat 'Education in three categories'.

COMPUTE edu_cat1 = educ_cat.

*Housing.
RECODE housing (1=1)(2=2)(3=3)(19=4)(5=5)(9=5)
    (10=5)(11=5)(12=5)(13=5)(14=5)(15=5)(18=5)(6=5) into hous_cat.
VALUE LABELS
    hous_cat
    1 'Own or rent'
    2 'Live with someone else'
    3 'Homeless'
    4 'Detox Facility'
    5 'Institutional Setting'.
EXECUTE.

*Employment.
RECODE employment (1=1)(2=1)(3=2)(4=2)(5=2)(6=2)(7=2)(8=2) into employ.
VALUE LABELS
    employ
    1 'Employed Full or Part Time'
    2 'Unemployed'.
EXECUTE.

*Heterosexual.
RECODE SexualIdentity (1=1)(2=0)(3=0)(4=0) into SexualIdentity_B.
VALUE LABELS
    SexualIdentity_B
    1 'Heterosexual'
    0 'Lesbian, gay, bisexual, or other'.
EXECUTE.
VARIABLE LABELS SexualIdentity_B 'Which of the following do you consider yourself to be? [Binary version]'.

/*Functional outcomes

*Healthy overall*.
RECODE OverallHealth (1=1)(2=1)(3=1)(4=0)(5=0) into Healthy.
VARIABLE LABELS Healthy 'Considered to be healthy overall, health is excellent, very good, or good'.
VALUE LABELS Healthy 1 'Yes' 0 'No'.

*Consumer perception of functioning in everyday life - mean of at least 5 valid responses*.
COMPUTE FunctioningPercep = mean.5 (HandlingDailyLife to Symptoms).
RECODE FunctioningPercep (SYSMIS=SYSMIS) (0 thru 3.5=0) (3.6 thru highest =1) INTO PosFunctioning.
VARIABLE LABELS  PosFunctioning 'acceptable level of functioning (positive outcome)'.
VALUE LABELS PosFunctioning 1 'Yes' 0 'No'.
EXECUTE.

*No serious psychological distress - K6*.
COMPUTE K6 = sum (Nervous to worthless).
RECODE K6 (SYSMIS=SYSMIS) (0 thru 13 =1) (14 thru highest =0) INTO NoSeriousPsychDistress.
VARIABLE LABELS  NoSeriousPsychDistress 'Have serious psychological distress (positive outcome)'.
VALUE LABELS NoSeriousPsychDistress 1 'Yes' 0 'No'.
EXECUTE.

*Never using illegal substances*.
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
COMPUTE IllegalSubstanceUse = sum (Cannabis_UseREC to Other_UseREC).
RECODE IllegalSubstanceUse (SYSMIS=SYSMIS) (0=1) (ELSE=0) INTO NeverUseSub30Days.
VARIABLE LABELS  NeverUseSub30Days 'Were never using illegal substances in past 30 days'
    IllegalSubstanceUse 'Sum of frequency of use of all substances'.
VALUE LABELS NeverUseSub30Days 1 'Yes' 0 'No'.
EXECUTE.
DELETE VARIABLES Cannabis_UseREC Cocaine_UseREC Stimulants_UseREC Meth_UseREC Inhalants_UseREC Sedatives_UseREC Hallucinogens_UseREC StreetOpioids_UseREC RxOpioids_UseREC Other_UseREC.


*Were not using tobacco products*.
RECODE Tobacco_Use (1=1)(2 = 0)(3=0)(4=0) into NeverUseTobacco30Days.
VALUE LABELS NeverUseTobacco30Days 1 'Yes' 0 'No'.

*Number of days of tobacco use continuous*.
RECODE Tobacco_Use (1=0)(2 = 1.5)(3=4)(4=30) into Smoking30Days.

*Were not binge drinking*.
RECODE Alcohol_Use (SYSMIS=SYSMIS)(1=1)(ELSE=0) into NotBingeDrinking30Days.
RECODE Al_Use_5orMore_Male (1=1) into NotBingeDrinking30Days.
RECODE Al_Use_4orMore_NotMale (1=1) into NotBingeDrinking30Days.
VARIABLE LABELS  NotBingeDrinking30Days 'Were not binge drinking in past 30 days'.
VALUE LABELS NotBingeDrinking30Days 1 'Yes' 0 'No'.
EXECUTE.

*Experienced Symptoms of PTSD*.
COMPUTE PTSDSymp = VT_NightmaresThoughts + VT_NotThinkAboutIt + VT_OnGuard + VT_NumbDetached.
RECODE ViolenceTrauma (0=0) into PTSDSymp.
RECODE PTSDSymp (SYSMIS=SYSMIS)(0=0)(1 thru highest =1) into PTSD.
VARIABLE LABELS PTSD 'Experienced symptoms of PTSD'.
VALUE LABELS PTSD 1 'Yes' 0 'No'.
EXECUTE.

*Experienced phsycial violence*.
RECODE PhysicallyHurt (SYSMIS=SYSMIS)(1=0)(ELSE=1) into PhysViolence.
VARIABLE LABELS PhysViolence 'Experienced physical violence in past 30 days'.
VALUE LABELS PhysViolence 1 'Yes' 0 'No'.
EXECUTE.

*Retained in the community*.
COMPUTE NightsAwayFromHome= sum (NightsHomeless, NightsHospitalMHC, NightsDetox, NightsJail).
RECODE NightsAwayFromHome  (SYSMIS=SYSMIS)(0=1)(1 thru highest=0) into RetainedComm.
VARIABLE LABELS RetainedComm 'Retained in the community (positive outcome)'
    NightsAwayFromHome 'Total nights spent homeless, in hospital, MHC, detox, or jail'.
VALUE LABELS RetainedComm 1 'Yes' 0 'No'.
EXECUTE.

*Had a stable place to live in the community*.
RECODE Housing (SYSMIS=SYSMIS)(1=1)(4=1)(12=1)(14=1)(15=1)(ELSE=0) into StableHousing.
VARIABLE LABELS StableHousing 'Stable place to live in the community (positive outcome)'.
VALUE LABELS StableHousing 1 'Yes' 0 'No'.
EXECUTE.

*Homeless*.
RECODE NightsHomeless (SYSMIS=SYSMIS)(0=0)(1 thru highest =1) into Homeless.
VARIABLE LABELS Homeless 'Homeless sometime in the past 30 days'.
VALUE LABELS Homeless 1 'Yes' 0 'No'.
EXECUTE.


*Were attending school regularly and/or currently employed/retired*/.
RECODE Enrolled (SYSMIS=SYSMIS) (1=1)(2=1)(ELSE=0) into CurrentWorkorSchool.
RECODE Employment (1=1)(2=1)(6=1) into CurrentWorkorSchool.
VARIABLE LABELS CurrentWorkorSchool 'Attending school regularly and/or currently employed/retired'.
VALUE LABELS CurrentWorkorSchool 1 'Yes' 0 'No'.
EXECUTE.

*Had no involvement with the criminal justice system*.
RECODE NumTimesArrested (SYSMIS=SYSMIS) (0=1)(ELSE=0) into NoCriminalJust.
VARIABLE LABELS NoCriminalJust 'No involvement with the criminal justice system in last 30 days'.
VALUE LABELS NoCriminalJust 1 'Yes' 0 'No'.

*Client perception of care*.
COMPUTE CarePercep = mean.9 (Recover to RecommendAgency).
RECODE CarePercep (SYSMIS=SYSMIS) (0 thru 3.5 =0) (ELSE=1) INTO PosCare.
VARIABLE LABELS  PosCare 'Acceptable level of perception of care (positive outcome)'.
VALUE LABELS PosCare 1 'Yes' 0 'No'.
EXECUTE.

*Were socially connected*.
COMPUTE SocialConnect = mean.4 (Friendships to SupportFromFamily).
RECODE  SocialConnect (SYSMIS=SYSMIS) (0 thru 3.5 =0) (ELSE=1) INTO PosSocialConnect.
VARIABLE LABELS  PosSocialConnect 'Acceptable level of social connectedness (positive outcome)'.
VALUE LABELS PosSocialConnect 1 'Yes' 0 'No'.
EXECUTE.

/*Health indicators*/

*Blood pressure*.
RECODE BPressure_s (0 thru 129=0)(130 thru highest = 1) INTO BP_s_abr.
RECODE BPressure_d (0 thru 84=0)(85 thru highest = 1) INTO BP_d_abr.


*Extended BP.
DO IF (BPressure_s < 120 & BPressure_d < 80).
    RECODE BPressure_s (0 thru 119=0) INTO BP.
END IF.
EXECUTE.
DO IF (BPressure_s < 120 & BPressure_d < 80).
    RECODE BPressure_d (0 thru 79=0) INTO BP.
END IF.
EXECUTE.
DO IF (BPressure_s >= 120 & BPressure_s < 130 & BPressure_d < 80).
    RECODE BPressure_s (120 thru 129=1) INTO BP.
END IF.
EXECUTE.
DO IF (BPressure_s >= 120 & BPressure_s < 130 & BPressure_d < 80).
    RECODE BPressure_d (0 thru 79=1) INTO BP.
END IF.
EXECUTE.
DO IF ((BPressure_s >= 130 & BPressure_s < 140) OR (BPressure_d >= 80 & BPressure_d < 90)).
    RECODE BPressure_s (130 thru 139=2) INTO BP.
END IF.
EXECUTE.
DO IF ((BPressure_s >= 130 & BPressure_s < 140) OR (BPressure_d >= 80 & BPressure_d < 90)).
    RECODE BPressure_d (80 thru 89=2) INTO BP.
END IF.
EXECUTE.
DO IF (BPressure_s >= 140 OR BPressure_d >= 90).
    RECODE BPressure_s (140 thru 200=3) INTO BP.
END IF.
EXECUTE.
DO IF (BPressure_s >= 140 OR BPressure_d >= 90).
    RECODE BPressure_d (90 thru 200=3) INTO BP.
END IF.
EXECUTE.

VALUE LABELS
    BP
    0 'Normal'
    1 'Elevated'
    2 'High Stage I'
    3 'High Stage II'.
EXECUTE.

*Breif BP.
RECODE BP (0=0)(1=1)(2=1)(3=1) INTO BP_ABR.
EXECUTE.
VALUE LABELS
    BP_ABR BP_s_abr BP_d_abr
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*BMI.
COMPUTE BMI = Weight / ((Height / 100)**2).

*Brief*.
RECODE BMI (SYSMISS=SYSMISS)(lowest thru 25.9999999999999999=0) (26 thru highest =1) INTO BMI_ABR.
VALUE LABELS BMI_ABR
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*Extended*.
RECODE BMI (SYSMISS=SYSMISS)(lowest thru 18.49=0)(18.5 thru 24.99=1) (25 thru 29.99=2)(30 thru highest=3) INTO BMI_cat.
VALUE LABELS
    BMI_cat
    0 'Underweight'
    1 'Normal'
    2 'Overweight'
    3 'Obese'.
EXECUTE.

*Waist Circumference.
DO IF (Gender =1).
    RECODE WaistCircum (SYSMIS = SYSMIS)(0 thru 101 = 0)(102 thru highest = 1) INTO WC.
ELSE IF (Gender ne 1).
    RECODE WaistCircum (SYSMIS = SYSMIS)(0 thru 87 = 0)(88 thru highest =1) INTO WC.
END IF.
VALUE LABELS WC
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*Breath CO
    *Brief.
RECODE BreathCO (SYSMIS = SYSMIS)(0 thru 10 = 0)(10.1 thru highest = 1) INTO BCO_ABR.
VALUE LABELS
    BCO_ABR
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*Extended

RECODE BreathCO (SYSMIS = SYSMIS)(0 thru 6.9=0)(7 thru 10=1)(10.1 thru highest=2) INTO BCO.
VALUE LABELS
    BCO
    0 '<7'
    1 '7-10'
    2 '>10'.
EXECUTE.

*Plasma Glucose

RECODE Plasma_Gluc (SYSMIS = SYSMIS)(0 thru 99 = 0)(100 thru highest = 1) INTO Glucose.
VALUE LABELS
    Glucose
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*HgbA1C
    *Brief.
RECODE HgbA1c (SYSMIS = SYSMIS)(0 thru 5.6=0)(5.7 thru highest = 1) INTO A1c_ABR.
VALUE LABELS
    A1c_ABR
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*Extended.
RECODE HgbA1c (SYSMIS = SYSMIS)(0 thru 5.6=0)(5.7 thru 6.4=1)(6.5 thru highest=2) INTO A1c.
VALUE LABELS
    A1c
    0 'Normal'
    1 'Prediabetes'
    2 'Diabetes'.
EXECUTE.

*HDL Cholesterol.
RECODE Lipid_HDL (SYSMIS = SYSMIS)(1 thru 40=1)(41 thru highest = 0)  INTO HDL.
VALUE LABELS
    HDL
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*LDL Cholesterol.
RECODE Lipid_LDL (SYSMIS = SYSMIS)(130 thru highest=1)(1 thru 129 = 0)  INTO LDL.
VALUE LABELS
    LDL
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*Triglycerides.
RECODE Lipid_Tri (SYSMIS = SYSMIS)(150 thru highest=1)(1 thru 149 = 0)  INTO Tri.
VALUE LABELS
    Tri
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

*Total Cholesterol.
RECODE Lipid_TotChol (SYSMIS = SYSMIS)(200 thru highest=1)(1 thru 199 = 0)  INTO TotChol.
VALUE LABELS
    TotChol
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

VARIABLE LABELS
    RaceEth 'Race/ethnicity according to federal guidlines'
    Ethnic 'Hispanic ethnic origin'
    age_cat 'Client population categorized by age'
    gender_binary 'Gender of the client (M/F)'
    DateBloodDrawn_New 'Date of blood draw'
    BP_ABR 'Blood pressure meets at-risk criteria'
    BMI 'Body Mass Index'
    BMI_ABR 'BMI level meets at-risk criteria'
    BMI_cat 'BMI categorized'
    WC 'Waist circumference meets at-risk criteria'
    BCO_ABR 'Breath CO level meets at-risk criteria'
    BCO 'Breath carbon monoxide'
    Glucose 'Blood glucose meets at-risk criteria'
    A1c_ABR 'A1c level meets at-risk criteria'
    HDL 'HDL level meets at-risk criteria'
    LDL 'LDL level meets at-risk criteria'
    Tri 'Triglyceride level meets at-risk criteria'
    TotChol 'Total Cholesterol level meets at-risk criteria'
    FunctioningPercep 'How would the client rate their level of functioning?'
    K6 'Level of psychological distress experienced by the client'
    SocialConnect 'Level of social connectedness experienced by the client'
    CarePercep 'Level of care as perceived by the client'
    NeverUseTobacco30Days 'Client never used tobacco products in the past 30 days'
    GAFDate_New 'Client GAF date'
    PTSDSymp 'PTSD symptoms experienced by the client'
    LastServiceDate_New 'Last date the client received grant services'.


RECODE Tobacco_Use  (1=0) (2=1) (3=1) (4=1) INTO Tobacc_UseBi.
VARIABLE LABELS  Tobacc_UseBi 'Tobacco use binary'.

RECODE Alcohol_Use (1=0) (2=1) (3=1) (4=1) INTO Alcoh_UseBi.
VARIABLE LABELS  Alcoh_UseBi 'Alcohol use binary'.

RECODE Cannabis_Use (1=0) (2=1) (3=1) (4=1) INTO Canna_UseBi.
VARIABLE LABELS  Canna_UseBi 'Cannabis use binary'.

RECODE Cocaine_Use (1=0) (2=1) (3=1) (4=1) INTO Cocain_UseBi.
VARIABLE LABELS  Cocain_UseBi 'Cocaine use binary'.

RECODE Stimulants_Use (1=0) (2=1) (3=1) (4=1) INTO Stim_UseBi.
VARIABLE LABELS  Stim_UseBi 'Stimulants use binary'.

RECODE Meth_Use (1=0) (2=1) (3=1) (4=1) INTO Meth_UseBi.
VARIABLE LABELS  Meth_UseBi 'Meth use binary'.

RECODE Inhalants_Use (1=0) (2=1) (3=1) (4=1) INTO Inhalant_UseBi.
VARIABLE LABELS  Inhalant_UseBi 'Inhalant use binary'.

RECODE Sedatives_Use (1=0) (2=1) (3=1) (4=1) INTO Sedativ_UseBi.
VARIABLE LABELS  Sedativ_UseBi 'Sedative use binary'.

RECODE Hallucinogens_Use (1=0) (2=1) (3=1) (4=1) INTO Hallucinog_UseBi.
VARIABLE LABELS  Hallucinog_UseBi 'Hallucinogen use binary'.

RECODE StreetOpioids_Use (1=0) (2=1) (3=1) (4=1) INTO StreetOpio_UseBi.
VARIABLE LABELS  StreetOpio_UseBi 'Street Opioid use binary'.

RECODE RxOpioids_Use (1=0) (2=1) (3=1) (4=1) INTO RxOpioids_UseBi.
VARIABLE LABELS  RxOpioids_UseBi 'Prescription Opioid use binary'.

VALUE LABELS Tobacc_UseBi Alcoh_UseBi Canna_UseBi Cocain_UseBi Stim_UseBi
    Meth_UseBi Inhalant_UseBi Sedativ_UseBi Hallucinog_UseBi StreetOpio_UseBi RxOpioids_UseBi
    1 'Any use' 0 'No use'.

COMPUTE NHealthAtRisk=BP_ABR + BMI_ABR + BCO_ABR + HDL + LDL + Tri + Glucose.
EXECUTE.


RECODE CapableManagingHealthCareNeeds (SYSMIS = SYSMIS)(1 thru 3=0)(4 = 1)  INTO ManageHealthNeeds.
VALUE LABELS
    ManageHealthNeeds
    0 'Not at risk'
    1 'At risk'.
EXECUTE.

RECODE PsychologicalEmotionalProblems (SYSMIS = SYSMIS)(1 thru 2=0)(3 thru 5 = 1)  INTO PsychEmoProb.
VALUE LABELS
    PsychEmoProb
    0 'Not at risk'
    1 'At risk'.
EXECUTE.


RECODE HealthSatisfaction (SYSMIS = SYSMIS)(1 thru 2=1)(3 thru 5 = 0)  INTO HealthSat_Bi.
VALUE LABELS
    HealthSat_Bi
    0 'Not at risk'
    1 'At risk'.
EXECUTE.


