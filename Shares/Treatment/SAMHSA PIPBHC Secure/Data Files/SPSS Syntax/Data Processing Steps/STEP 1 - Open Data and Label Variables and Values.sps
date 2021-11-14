* Encoding: UTF-8.

/*...................LABEL ALL VARIABLES..................................................*/

Dataset activate Fulldata.

                                        Variable labels 
                                        Assessment 'Assessment type'
                                        ConsumerID 'Consumer ID'
                                        Assessment 'Indicate Assessment Type:'
                                        ConductedInterview 'Was the interview conducted?'
                                        ConsumerType_07 'Consumer Type'
                                        FFY 'Federal Fiscal Year (Calculated field based on InterviewDate)'
                                        FirstReceivedServicesDate '[Enter the month and year when the consumer first received services under the grant for this episode of care.]'
                                        GrantID 'Grant ID (Grant/Contract/Cooperative Agreement)'
                                        InterviewDate 'When?'
                                        InterviewType_07 'Interview Type'
                                        Month '(Calculated field based on InterviewDate)'
                                        NextReassessment_10 'What data will be submitted for the next reassessment?'
                                        Quarter '(Calculated field based on InterviewDate)'
                                        ReassessmentNumber_07 'Reassessment Number'
                                        RecordStatus 'Record Status'
                                        SiteID 'Site ID'
                                        SubmittedAtClinicalDischarge_10 '[CLINICAL DISCHARGE ONLY] What data will be submitted for this Clinical Discharge?'
                                        WhyNotConducted 'Why not? Choose only one.'
                                        WhyNotConducted_10 'Why was the interview not conducted?'.
                                        /*ICD-10-CM:  BEHAVIORAL HEALTH DIAGNOSES
                                        /*Please indicate the consumers current behavioral health diagnoses using the International Classification of Diseases, 10th revision, Clinical Modification (ICD-10-CM) codes listed below
                                        /*Please note that some substance use disorder ICD-10-CM codes have been crosswalked to Diagnostic and Statistical Manual of Mental Disorders, (DSM-5) descriptors*/

                                        Variable labels 
                                        DiagnosisOne 'Substance Use Disorder Diagnosis 1'
                                        DiagnosisOneCategory 'Substance Use Disorder Diagnosis 1 - Category'
                                        DiagnosisThree 'Substance Use Disorder Diagnosis 3'
                                        DiagnosisThreeCategory 'Substance Use Disorder Diagnosis 3 - Category'
                                        DiagnosisTwo 'Substance Use Disorder Diagnosis 2'
                                        DiagnosisTwoCategory 'Substance Use Disorder Diagnosis 2 - Category'.
                                        
                                        /*SECTION A. DEMOGRAPHIC DATA */
                                        
                                        Variable labels 
                                        Agegroup 'Age in 8 categories (Calculated field based on Age)'
                                        DOB 'What is your month and year of birth?'
                                        EthnicCentralAmerican 'What ethnic group do you consider yourself?'
                                        EthnicCuban 'What ethnic group do you consider yourself?'
                                        EthnicDominican 'What ethnic group do you consider yourself?'
                                        EthnicMexican 'What ethnic group do you consider yourself?'
                                        EthnicOther 'What ethnic group do you consider yourself?'
                                        EthnicOtherSpec 'Other specify ethnic group response'
                                        EthnicPuertoRican 'What ethnic group do you consider yourself?'
                                        EthnicSouthAmerican 'What ethnic group do you consider yourself?'
                                        Gender 'What is your gender?'
                                        GenderSpec 'Other specify gender'
                                        HispanicLatino 'Are you Hispanic or Latino?'
                                        RaceAlaskaNative 'What race do you consider yourself?'
                                        RaceAmericanIndian 'What race do you consider yourself?'
                                        RaceAsian 'What race do you consider yourself?'
                                        RaceBlack 'What race do you consider yourself [Black or African American]?'
                                        RaceNativeHawaiian 'What race do you consider yourself?'
                                        RaceWhite 'What race do you consider yourself?'
                                        SexualIdentity 'Which of the following do you consider yourself to be?'
                                        SexualIdentityOther 'Other sexual identity specify'
                                        Si_Assessment 'This column is used to identify which assessment the sexual identity question is supposed to be asked.'.
                                        
                                        /*SECTION B. FUNCTIONING ''.*/
                                        
                                        Variable labels 
                                        Al_Use_4orMore_NotMale 'How many times in the past 30 days have you had four or more drinks in a day? Not male respondents only.'
                                        Al_Use_5orMore_Male 'How many times in the past 30 days have you had five or more drinks in a day? Male respondents only.'
                                        Alcohol_Use 'In the past 30 days, how often have you used… alcoholic beverages (beer, wine, liquor, etc.)?'
                                        Cannabis_Use 'In the past 30 days, how often have you used… cannabis (marijuana, pot, grass, hash, etc.)?'
                                        CapableManagingHealthCareNeeds 'Please select the one answer that most closely matches your situation.  I feel capable of managing my health care needs: '
                                        Cocaine_Use 'In the past 30 days, how often have you used… cocaine (coke, crack, etc.)?'
                                        ControlLife 'I am able to control my life.'
                                        DealWithCrisis 'I am able to deal with crisis.'
                                        Depressed 'During the past 30 days, about how often did you feel so depressed that nothing could cheer you up?'
                                        EnoughEnergyForEverydayLife 'In the last 4 weeks, do you have enough energy for everyday life?'
                                        EverythingEffort 'During the past 30 days, about how often did you feel that everything was an effort?'
                                        FunctioningHousing 'My housing situation is satisfactory.'
                                        GAFDate 'DATE GAF WAS ADMINISTERED'
                                        GAFScore 'WHAT WAS THE CONSUMER’S SCORE? GAF = '
                                        GetsAlongWithFamily 'I am getting along with my family.'
                                        Hallucinogens_Use 'In the past 30 days, how often have you used…hallucinogens (LSD, acid, mushrooms, PCP, Special K, ecstasy, etc.)?'
                                        HandlingDailyLife 'I deal effectively with daily problems.'
                                        HealthSatisfaction 'In the last 4 weeks, how satisfied are you with your health?'
                                        Hopeless 'During the past 30 days, about how often did you feel hopeless?'
                                        Inhalants_Use 'In the past 30 days, how often have you used…inhalants (nitrous oxide, glue, gas, paint thinner, etc.)?'
                                        LifeQuality 'In the last 4 weeks, how would you rate your quality of life?'
                                        Meth_Use 'In the past 30 days, how often have you used… methamphetamine (speed, crystal meth, ice, etc.)?'
                                        Nervous 'During the past 30 days, about how often did you feel nervous?'
                                        Other_Use 'In the past 30 days, how often have you used… other – specify (e-cigarettes, etc.):'
                                        Other_UseSpec 'Other Substance Used specify'
                                        OverallHealth 'How would you rate your overall health right now?'
                                        PerformDailyActivitiesSatisfaction 'In the last 4 weeks, how satisfied are you with your ability to perform your daily living activities?'
                                        PsychologicalEmotionalProblems 'During the past 30 days, how much have you been bothered by these psychological or emotional problems?'
                                        RelationshipSatisfaction 'In the last 4 weeks, how satisfied are you with your personal relationships?'
                                        Restless 'During the past 30 days, about how often did you feel restless or fidgety?'
                                        RxOpioids_Use 'In the past 30 days, how often have you used…prescription opioids (fentanyl, oxycodone [OxyContin, Percocet], hydrocodone [Vicodin], methadone, buprenorphine, etc.)?'
                                        SchoolOrWork 'I do well in school and/or work.'
                                        Sedatives_Use 'In the past 30 days, how often have you used… sedatives or sleeping pills (Valium, Serepax, Ativan, Librium, Xanax, Rohypnol, GHB, etc.)?'
                                        SelfSatisfaction 'In the last 4 weeks, how satisfied are you with yourself?'
                                        SocialSituations 'I do well in social situations.'
                                        Stimulants_Use 'In the past 30 days, how often have you used… prescription stimulants (Ritalin, Concerta, Dexedrine, Adderall, diet pills, etc.)?'
                                        StreetOpioids_Use 'In the past 30 days, how often have you used…street opioids (heroin, opium, etc.)?'
                                        Symptoms 'My symptoms are not bothering me.'
                                        Tobacco_Use 'In the past 30 days, how often have you used… tobacco products (cigarettes, chewing tobacco, cigars, etc.)?'
                                        Worthless 'During the past 30 days, about how often did you feel worthless?'.
                                        
                                        /*SECTION B. MILITARY FAMILY AND DEPLOYMENT */
                                        
                                        Variable labels 
                                        ActiveDuty_Else 'Is anyone in your family or someone close to you currently serving on active duty in or retired/separated from the Armed Forces, the Reserves, or the National Guard?'
                                        ActiveDuty_Self 'Are you currently serving on active duty in the Armed Forces, the Reserves, or the National Guard?'
                                        AD_ArmedForces '[IF YES] In which of the following are you currently serving? Armed Forces?'
                                        AD_NationalGuard '[IF YES] In which of the following are you currently serving?  National Guard?'
                                        AD_P1CombatOpr_11 'For the first person: Has the Service Member experienced any of the following: Deployed in support of Combat Operations? (e.g. Iraq or Afghanistan)'
                                        AD_P1Died_11 'For the first person: Has the Service Member experienced any of the following: Died or was killed?'
                                        AD_P1Injured_11 'For the first person: Has the Service Member experienced any of the following: Was physically injured during Combat Operations?'
                                        AD_P1Rel_OtherSpec_11 'OTHER (SPECIFY)'
                                        AD_P1Relationship_11 'For the first person: What is the relationship of that person (Service Member) to you?'
                                        AD_P1Stress_11 'Developed combat stress symptoms/difficulties adjusting following deployment, including PTSD, depression, or suicidal thoughts?'
                                        AD_P2CombatOpr_11 'For the second person: Has the Service Member experienced any of the following: Deployed in support of Combat Operations? (e.g. Iraq or Afghanistan)'
                                        AD_P2Died_11 'For the second person: Has the Service Member experienced any of the following: Died or was killed?'
                                        AD_P2Injured_11 'For the second person: Has the Service Member experienced any of the following: Was physically injured during Combat Operations?'
                                        AD_P2Rel_OtherSpec_11 'OTHER (SPECIFY)'
                                        AD_P2Relationship_11 'For the second person: What is the relationship of that person (Service Member) to you?'
                                        AD_P2Stress_11 'Developed combat stress symptoms/difficulties adjusting following deployment, including PTSD, depression, or suicidal thoughts?'
                                        AD_P3CombatOpr_11 'For the third person: Has the Service Member experienced any of the following: Deployed in support of Combat Operations? (e.g. Iraq or Afghanistan)'
                                        AD_P3Died_11 'For the third person: Has the Service Member experienced any of the following: Died or was killed?'
                                        AD_P3Injured_11 'For the third person: Has the Service Member experienced any of the following: Was physically injured during Combat Operations?'
                                        AD_P3Rel_OtherSpec_11 'OTHER (SPECIFY)'
                                        AD_P3Relationship_11 'For the third person: What is the relationship of that person (Service Member) to you?'
                                        AD_P3Stress_11 'Developed combat stress symptoms/difficulties adjusting following deployment, including PTSD, depression, or suicidal thoughts?'
                                        AD_P4CombatOpr_11 'For the fourth person: Has the Service Member experienced any of the following: Deployed in support of Combat Operations? (e.g. Iraq or Afghanistan)'
                                        AD_P4Died_11 'For the fourth person: Has the Service Member experienced any of the following: Died or was killed?'
                                        AD_P4Injured_11 'For the fourth person: Has the Service Member experienced any of the following: Was physically injured during Combat Operations?'
                                        AD_P4Rel_OtherSpec_11 'OTHER (SPECIFY)'
                                        AD_P4Relationship_11 'For the fourth person: What is the relationship of that person (Service Member) to you?'
                                        AD_P4Stress_11 'Developed combat stress symptoms/difficulties adjusting following deployment, including PTSD, depression, or suicidal thoughts?'
                                        AD_P5CombatOpr_11 'For the fifth person: Has the Service Member experienced any of the following: Deployed in support of Combat Operations? (e.g. Iraq or Afghanistan)'
                                        AD_P5Died_11 'For the fifth person: Has the Service Member experienced any of the following: Died or was killed?'
                                        AD_P5Injured_11 'For the fifth person: Has the Service Member experienced any of the following: Was physically injured during Combat Operations?'
                                        AD_P5Rel_OtherSpec_11 'OTHER (SPECIFY)'
                                        AD_P5Relationship_11 'For the fifth person: What is the relationship of that person (Service Member) to you?'
                                        AD_P5Stress_11 'Developed combat stress symptoms/difficulties adjusting following deployment, including PTSD, depression, or suicidal thoughts?'
                                        AD_P6CombatOpr_11 'For the sixth person: Has the Service Member experienced any of the following: Deployed in support of Combat Operations? (e.g. Iraq or Afghanistan)'
                                        AD_P6Died_11 'For the sixth person: Has the Service Member experienced any of the following: Died or was killed?'
                                        AD_P6Injured_11 'For the sixth person: Has the Service Member experienced any of the following: Was physically injured during Combat Operations?'
                                        AD_P6Rel_OtherSpec_11 'OTHER (SPECIFY)'
                                        AD_P6Relationship_11 'For the sixth person: What is the relationship of that person (Service Member) to you?'
                                        AD_P6Stress_11 'Has the Service Member experienced any of the following: Developed combat stress symptoms/difficulties adjusting following deployment, including PTSD, depression, or suicidal thoughts?'
                                        AD_Reserves '[IF YES] In which of the following are you currently serving?  Reserves?'
                                        ED_IraqAfghan '[IF YES] To which of the following combat zones have you been deployed? Iraq or Afghanistan (eg., Operation Enduring Freedom/Operational Iraqi Freedom/Operation NewDawn)?'
                                        ED_Korea '[IF YES] To which of the following combat zones have you been deployed? Korea?'
                                        ED_Other '[IF YES] To which of the following combat zones have you been deployed? Deployed to a combat  zone not listed above (e.g., Somalia, Bosnia, Kosovo)?'
                                        ED_PersianGulf '[IF YES] To which of the following combat zones have you been deployed? Persian Gulf (Operation Desert Shield or Desert Storm)?'
                                        ED_VietnamSEAsia '[IF YES] To which of the following combat zones have you been deployed? Vietnam/Southeast Asia?'
                                        ED_WWII '[IF YES] To which of the following combat zones have you been deployed? WWII?'
                                        ES_ArmedForces '[IF YES] In which of the following have you ever served? Armed Forces?'
                                        ES_NationalGuard '[IF YES] In which of the following have you ever served? National Guard?'
                                        ES_Reserves '[IF YES] In which of the following have you ever served?  Reserves?'
                                        EverDeployed 'Have you ever been deployed to a combat zone?'
                                        EverServed 'Have you ever served in the Armed Forces, the Reserves, or the National Guard?'.
                                        
                                        /*SECTION B. VIOLENCE AND TRAUMA*/
                                    
            Variable labels 
            PhysicallyHurt 'In the past 30 days, how often have you been hit, kicked, slapped, or otherwise physically hurt?'
            ViolenceTrauma 'Have you ever experienced violence or trauma in any setting?'
            VT_NightmaresThoughts 'Did any of these experiences feel so frightening, horrible, or upsetting that in the past and/or the present you: Have had nightmares about it or thought about it when you did not want to?'
            VT_NotThinkAboutIt 'Did any of these experiences feel so frightening, horrible, or upsetting that in the past and/or the present you: Tried hard not to think about it or went out of your way to avoid situations that remind you of it?'
            VT_NumbDetached 'Did any of these experiences feel so frightening, horrible, or upsetting that in the past and/or the present you: Felt numb and detached from others, activities, or your surroundings?'
            VT_OnGuard 'Did any of these experiences feel so frightening, horrible, or upsetting that in the past and/or the present you: Were constantly on guard, watchful, or easily startled?'.
                                        
                                        /*SECTION C. STABILITY IN HOUSING*/
                                        
                                        Variable labels 
                                        Housing 'In the past 30 days, where have you been living most of the time?'
                                        LivingConditionsSatisfaction 'In the last 4 weeks, how satisfied are you with the conditions of your living place?'
                                        NightsDetox 'In the past 30 days how many … nights have you spent in a facility for detox/inpatient or residential substance abuse treatment?'
                                        NightsHomeless 'In the past 30 days how many … nights have you been homeless?'
                                        NightsHospitalMHC 'In the past 30 days how many … nights have you spent in a hospital for mental health care?'
                                        NightsJail 'In the past 30 days how many … nights have you spent in a correctional facility including jail, or prison?'
                                        OtherHousingSpec 'Other Housed specify'
                                        TimesER 'In the past 30 days how many … times have you gone to an emergency room for a psychiatric or emotional problem?'.
                                        
                                        /*SECTION D. EDUCATION AND EMPLOYMENT */
                                        
                                        Variable labels 
                                        Education 'What is the highest level of education you have finished, whether or not you received a degree?'
                                        Employed_AnyoneApplied 'Could anyone have applied for this job?'
                                        Employed_MinWageOrAbove 'Are you paid at or above the minimum wage?'
                                        Employed_PaidDirectly 'Are your wages paid directly to you by your employer?'
                                        Employment 'Are you currently employed?'
                                        EmploymentType_07 '[If employed], Is your employment competitive or sheltered?'
                                        EnoughMoneyForNeeds 'In the last 4 weeks, have you enough money to meet your needs?'
                                        Enrolled 'Are you currently enrolled in school or a job training program? If enrolled, is that full time or part time?'
                                        OtherEmploymentSpec 'Other Employment specify'
                                        OtherEnrolledSpec 'Other Enrolled specify'.
                                        
                                        /*SECTION E. CRIME AND CRIMINAL JUSTICE STATUS */
                                        
                                        Variable labels 
                                        NumTimesArrested 'In the past 30 days, how many times have you been arrested?'.
                                        
                                        /*SECTION F. PERCEPTION OF CARE */
                                        
                                        Variable labels 
                                        Choices 'If I had other choices, I would still get services from this agency.'
                                        ComfortableAskingQuestions 'I felt comfortable asking questions about my treatment and medication'
                                        Complain 'I felt free to complain.'
                                        ConsumerRunPrograms 'I was encouraged to use consumer run programs (support groups, drop-in centers, crisis phone line, etc.).'
                                        InformationNeeded 'Staff helped me obtain the information I needed so that I could take charge of managing my illness.'
                                        LikeServices 'I like the services I received here.'
                                        RecommendAgency 'I would recommend this agency to a friend or family member.'
                                        Recover 'Staff here believe that I can grow, change and recover.'
                                        Responsibility 'Staff encouraged me to take responsibility for how I live my life.'
                                        Rights 'I was given information about my rights.'
                                        SensitiveToCulture 'Staff were sensitive to my cultural background (race, religion, language, etc.).'
                                        SharingTreatmentInformation 'Staff respected my wishes about who is and who is not to be given information about my treatment.'
                                        SideEffects 'Staff told me what side effects to watch out for.'
                                        TreatmentGoals 'I, not staff, decided my treatment goals.'
                                        WhoAdministered '[INDICATE WHO ADMINISTERED SECTION F - PERCEPTION OF CARE TO THE RESPONDENT FOR THIS INTERVIEW.]'
                                        WhoAdministered_OtherSpec 'OTHER (SPECIFY)'.
                                        
                                        /*SECTION G. SOCIAL CONNECTEDNESS*/
                                        
                                        Variable labels 
                                        BelongInCommunity 'I feel I belong in my community.'
                                        EnjoyPeople 'I have people with whom I can do enjoyable things.'
                                        Friendships 'I am happy with the friendships I have.'
                                        GenerallyAccomplishGoal 'I generally accomplish what I set out to do.'
                                        SupportFromFamily 'In a crisis, I would have the support I need from family or friends.'
                                        SupportiveFamilyFriends 'I have family or friends that are supportive of my recovery.'.
                                        
                                        /* SECTION H. PROGRAM SPECIFIC QUESTIONS YOU ARE NOT RESPONSIBLE FOR COLLECTING DATA ON ALL 
                                        /*SECTION H QUESTIONS YOUR GPO HAS PROVIDED YOU WITH GUIDANCE ON WHICH SPECIFIC SECTION H QUESTIONS YOU ARE TO COMPLETE
                                        /*IF YOU HAVE ANY QUESTIONS, PLEASE CONTACT YOUR GPO */
                                        
                                        Variable labels 
                                        bpressure_d 'Diastolic blood pressure '
                                        bpressure_s 'Systolic blood pressure '
                                        BreathCO 'Breath CO for smoking status'
                                        DateBloodDrawn 'Date of blood draw'
                                        EightHour_fast 'Did patient successfully fast for 8 hours prior to providing the blood sample?'
                                        Height 'Height'
                                        HgbA1c  'HgbA1c '
                                        Lipid_HDL  'HDL Cholesterol'
                                        Lipid_LDL 'LDL Cholesterol'
                                        Lipid_TotChol  'Total Cholesterol '
                                        Lipid_Tri 'Triglycerides '
                                        MedicaidMedicare 'Please indicate which type of funding source(s) was (were)/will be used to pay for the services provided to this consumer since their last interview: Medicaid/Medicare'
                                        OtherFederalGrantFunding 'Please indicate which type of funding source(s) was (were)/will be used to pay for the services provided to this consumer since their last interview: Other federal grant funding'
                                        OtherResponse 'Please indicate which type of funding source(s) was (were)/will be used to pay for the services provided to this consumer since their last interview: Other (specify)'
                                        OtherResponseSpecify 'Other (specify)'
                                        Plasma_gluc 'Fasting plasma glucose'
                                        StateFunding 'Please indicate which type of funding source(s) was (were)/will be used to pay for the services provided to this consumer since their last interview: State funding'
                                        WaistCircum  'Waist circumference '
                                        Weight 'Weight'
                                        BeenHospitalizedIntegerCount 'In the past 30 days how many times have you been hospitalized overnight for a physical healthcare problem? [REPORT NUMBER OF NIGHTS HOSPITALIZED]'
                                        BeenToEmergencyRoomIntegerCount 'In the past 30 days how many times have you been to the emergency room for a physical healthcare problem?'
                                        ConsumerPrivateInsurance 'Please indicate which type of funding source(s) was (were)/will be used to pay for the services provided to this consumer since their last interview Consumer’s private insurance'
                                        CurrentSamhsaGrantFunding 'Please indicate which type of funding source(s) was (were)/will be used to pay for the services provided to this consumer since their last interview Current SAMHSA grant funding'.
                                        
                                        /*SECTION I. REASSESSMENT STATUS */
                                        
                                        Variable labels 
                                        NoContact90Days 'Have you or other grant staff had contact with the consumer within 90 days of last encounter?'
                                        OtherReassessment_07 'Other Reassessment status specify response'
                                        ReassessmentStatus_07 'What is the Reassessment status of the consumer?'
                                        StillReceivingServices 'Is the consumer still receiving services from your project?'.
                                        
                                        /*SECTION J. CLINICAL DISCHARGE STATUS */
                                        
                                        Variable labels 
                                        DischargeDate 'On what date was the consumer discharged? (Month and Year only)'
                                        DischargeStatus 'What is the consumers discharge status?'
                                        OtherDischargeStatus 'Other discharge status specify response'.
                                        
                                        /*SECTION K. SERVICES RECEIVED*/.
                                        
                                        Variable labels 
                                        LastServiceDate 'On what date did the consumer last receive services? (Month and Year only)'
                                        Svc_Assessment 'Assessment since last NOMs Interview?'
                                        Svc_CaseManagement 'Case Management since last NOMs Interview?'
                                        Svc_ChildCare 'Child care services since last NOMs Interview?'
                                        Svc_ConsumerOperated 'Consumer Operated services since last NOMs Interview?'
                                        Svc_CoOccuring 'Co-occurring services since last NOMs Interview?'
                                        Svc_Education 'Education services since last NOMs Interview?'
                                        Svc_Employment 'Employment services since last NOMs Interview?'
                                        Svc_Family 'Family services since last NOMs Interview?'
                                        Svc_HIVTesting 'HIV Testing services since last NOMs Interview?'
                                        Svc_Housing 'Housing services since last NOMs Interview?'
                                        Svc_MedicalCare 'Medical care services since last NOMs Interview?'
                                        Svc_MentalHealth 'Mental Health Services since last NOMs Interview?'
                                        Svc_MentalHealthFreq 'Mental Health Services number of times received'
                                        Svc_MentalHealthFreq_07 'Frequency of Mental Health Services'
                                        Svc_MH_FreqPeriod 'Number of times per (Frequency period for number of times Mental Health Services were received)'
                                        Svc_Psychopharmacological 'Psychopharmacological services since last NOMs Interview?'
                                        Svc_ReferredCore 'Was the Consumer referred to another provider for any of the above core services?'
                                        Svc_ReferredSupport 'Was the Consumer referred to another provider for any of the above support services?'
                                        Svc_Screening 'Screening since last NOMs Interview?'
                                        Svc_SocialRecreational 'Social Recreational Activities since last NOMs Interview?'
                                        Svc_Transportation 'Transportation services since last NOMs Interview?'
                                        Svc_TraumaSpecific 'Trauma-specific services since last NOMs Interview?'
                                        Svc_TreatmentPlanning 'Treatment planning or review since last NOMs Interview?'.
                                        EXECUTE.

/*.........................INDICATE MISSING VALUES WHERE -4 BECOMES SYSTEM MISSING, AND -2, -3, -6, -7, -8, AND -9 ALL BECOME USER MISSING.............................*/

            RECODE        InterviewType_07 ConsumerType_07 ReassessmentNumber_07 Assessment ConductedInterview WhyNotConducted WhyNotConducted_10 NextReassessment_10 
SubmittedAtClinicalDischarge_10 FFY Quarter Month RecordStatus DiagnosisOne DiagnosisOneCategory DiagnosisTwo DiagnosisTwoCategory 
DiagnosisThree DiagnosisThreeCategory Gender
HispanicLatino EthnicCentralAmerican EthnicCuban EthnicDominican EthnicMexican EthnicPuertoRican EthnicSouthAmerican EthnicOther
RaceBlack RaceAsian RaceNativeHawaiian RaceAlaskaNative RaceWhite RaceAmericanIndian
Agegroup SexualIdentity Si_Assessment OverallHealth CapableManagingHealthCareNeeds HandlingDailyLife ControlLife 
DealWithCrisis GetsAlongWithFamily SocialSituations SchoolOrWork FunctioningHousing Symptoms Nervous Hopeless Restless 
Depressed EverythingEffort Worthless PsychologicalEmotionalProblems LifeQuality EnoughEnergyForEverydayLife 
PerformDailyActivitiesSatisfaction HealthSatisfaction SelfSatisfaction RelationshipSatisfaction 
Tobacco_Use Alcohol_Use Al_Use_5orMore_Male Al_Use_4orMore_NotMale Cannabis_Use Cocaine_Use Stimulants_Use Meth_Use 
Inhalants_Use Sedatives_Use Hallucinogens_Use StreetOpioids_Use RxOpioids_Use Other_Use
GAFScore EverServed ES_ArmedForces ES_Reserves ES_NationalGuard ActiveDuty_Self AD_ArmedForces AD_Reserves AD_NationalGuard 
EverDeployed ED_IraqAfghan ED_PersianGulf ED_VietnamSEAsia ED_Korea ED_WWII ED_Other ActiveDuty_Else AD_P1Relationship_11 
AD_P1Rel_OtherSpec_11 AD_P1CombatOpr_11 AD_P1Injured_11 AD_P1Stress_11 AD_P1Died_11 AD_P2Relationship_11 
AD_P2Rel_OtherSpec_11 AD_P2CombatOpr_11 AD_P2Injured_11 AD_P2Stress_11 AD_P2Died_11 AD_P3Relationship_11 
AD_P3Rel_OtherSpec_11 AD_P3CombatOpr_11 AD_P3Injured_11 AD_P3Stress_11 AD_P3Died_11 AD_P4Relationship_11 
AD_P4Rel_OtherSpec_11 AD_P4CombatOpr_11 AD_P4Injured_11 AD_P4Stress_11 AD_P4Died_11 AD_P5Relationship_11 
AD_P5Rel_OtherSpec_11 AD_P5CombatOpr_11 AD_P5Injured_11 AD_P5Stress_11 AD_P5Died_11 AD_P6Relationship_11 
AD_P6Rel_OtherSpec_11 AD_P6CombatOpr_11 AD_P6Injured_11 AD_P6Stress_11 AD_P6Died_11 
ViolenceTrauma VT_NightmaresThoughts VT_NotThinkAboutIt VT_OnGuard VT_NumbDetached PhysicallyHurt 
NightsHomeless NightsHospitalMHC NightsDetox NightsJail TimesER Housing
LivingConditionsSatisfaction Enrolled Education Employment
EmploymentType_07 Employed_MinWageOrAbove Employed_PaidDirectly Employed_AnyoneApplied EnoughMoneyForNeeds 
NumTimesArrested Recover Complain Rights Responsibility SideEffects SharingTreatmentInformation SensitiveToCulture 
InformationNeeded ConsumerRunPrograms ComfortableAskingQuestions TreatmentGoals LikeServices Choices RecommendAgency WhoAdministered
Friendships EnjoyPeople BelongInCommunity SupportFromFamily SupportiveFamilyFriends GenerallyAccomplishGoal BeenToEmergencyRoomIntegerCount 
BeenHospitalizedIntegerCount CurrentSamhsaGrantFunding OtherFederalGrantFunding StateFunding ConsumerPrivateInsurance 
MedicaidMedicare OtherResponse OtherResponseSpecify BPressure_s BPressure_d Weight Height WaistCircum BreathCO EightHour_Fast
Plasma_Gluc HgbA1c Lipid_TotChol Lipid_HDL Lipid_LDL Lipid_Tri ReassessmentStatus_07 OtherReassessment_07 NoContact90Days StillReceivingServices
DischargeStatus Svc_Screening Svc_Assessment Svc_TreatmentPlanning Svc_Psychopharmacological Svc_MentalHealth Svc_MentalHealthFreq_07 
Svc_MentalHealthFreq Svc_MH_FreqPeriod Svc_CoOccuring Svc_CaseManagement Svc_TraumaSpecific Svc_ReferredCore Svc_MedicalCare 
Svc_Employment Svc_Family Svc_ChildCare Svc_Transportation Svc_Education Svc_Housing Svc_SocialRecreational Svc_ConsumerOperated 
Svc_HIVTesting Svc_ReferredSupport
             (-1=-9)(-2=-9)(-3=-9)(-4 =-9)(-5 = -9)(-6=-9)(-7=-9)(-8=-9). 
             EXECUTE.
                        
            missing values  InterviewType_07 ConsumerType_07 ReassessmentNumber_07 Assessment ConductedInterview WhyNotConducted WhyNotConducted_10 NextReassessment_10 
SubmittedAtClinicalDischarge_10 FFY Quarter Month RecordStatus DiagnosisOne DiagnosisOneCategory DiagnosisTwo DiagnosisTwoCategory 
DiagnosisThree DiagnosisThreeCategory Gender
HispanicLatino EthnicCentralAmerican EthnicCuban EthnicDominican EthnicMexican EthnicPuertoRican EthnicSouthAmerican EthnicOther
RaceBlack RaceAsian RaceNativeHawaiian RaceAlaskaNative RaceWhite RaceAmericanIndian
Agegroup SexualIdentity Si_Assessment OverallHealth CapableManagingHealthCareNeeds HandlingDailyLife ControlLife 
DealWithCrisis GetsAlongWithFamily SocialSituations SchoolOrWork FunctioningHousing Symptoms Nervous Hopeless Restless 
Depressed EverythingEffort Worthless PsychologicalEmotionalProblems LifeQuality EnoughEnergyForEverydayLife 
PerformDailyActivitiesSatisfaction HealthSatisfaction SelfSatisfaction RelationshipSatisfaction 
Tobacco_Use Alcohol_Use Al_Use_5orMore_Male Al_Use_4orMore_NotMale Cannabis_Use Cocaine_Use Stimulants_Use Meth_Use 
Inhalants_Use Sedatives_Use Hallucinogens_Use StreetOpioids_Use RxOpioids_Use Other_Use
GAFScore EverServed ES_ArmedForces ES_Reserves ES_NationalGuard ActiveDuty_Self AD_ArmedForces AD_Reserves AD_NationalGuard 
EverDeployed ED_IraqAfghan ED_PersianGulf ED_VietnamSEAsia ED_Korea ED_WWII ED_Other ActiveDuty_Else AD_P1Relationship_11 
AD_P1Rel_OtherSpec_11 AD_P1CombatOpr_11 AD_P1Injured_11 AD_P1Stress_11 AD_P1Died_11 AD_P2Relationship_11 
AD_P2Rel_OtherSpec_11 AD_P2CombatOpr_11 AD_P2Injured_11 AD_P2Stress_11 AD_P2Died_11 AD_P3Relationship_11 
AD_P3Rel_OtherSpec_11 AD_P3CombatOpr_11 AD_P3Injured_11 AD_P3Stress_11 AD_P3Died_11 AD_P4Relationship_11 
AD_P4Rel_OtherSpec_11 AD_P4CombatOpr_11 AD_P4Injured_11 AD_P4Stress_11 AD_P4Died_11 AD_P5Relationship_11 
AD_P5Rel_OtherSpec_11 AD_P5CombatOpr_11 AD_P5Injured_11 AD_P5Stress_11 AD_P5Died_11 AD_P6Relationship_11 
AD_P6Rel_OtherSpec_11 AD_P6CombatOpr_11 AD_P6Injured_11 AD_P6Stress_11 AD_P6Died_11 
ViolenceTrauma VT_NightmaresThoughts VT_NotThinkAboutIt VT_OnGuard VT_NumbDetached PhysicallyHurt 
NightsHomeless NightsHospitalMHC NightsDetox NightsJail TimesER Housing
LivingConditionsSatisfaction Enrolled Education Employment
EmploymentType_07 Employed_MinWageOrAbove Employed_PaidDirectly Employed_AnyoneApplied EnoughMoneyForNeeds 
NumTimesArrested Recover Complain Rights Responsibility SideEffects SharingTreatmentInformation SensitiveToCulture 
InformationNeeded ConsumerRunPrograms ComfortableAskingQuestions TreatmentGoals LikeServices Choices RecommendAgency WhoAdministered
Friendships EnjoyPeople BelongInCommunity SupportFromFamily SupportiveFamilyFriends GenerallyAccomplishGoal BeenToEmergencyRoomIntegerCount 
BeenHospitalizedIntegerCount CurrentSamhsaGrantFunding OtherFederalGrantFunding StateFunding ConsumerPrivateInsurance 
MedicaidMedicare OtherResponse OtherResponseSpecify BPressure_s BPressure_d Weight Height WaistCircum BreathCO EightHour_Fast
Plasma_Gluc HgbA1c Lipid_TotChol Lipid_HDL Lipid_LDL Lipid_Tri ReassessmentStatus_07 OtherReassessment_07 NoContact90Days StillReceivingServices
DischargeStatus Svc_Screening Svc_Assessment Svc_TreatmentPlanning Svc_Psychopharmacological Svc_MentalHealth Svc_MentalHealthFreq_07 
Svc_MentalHealthFreq Svc_MH_FreqPeriod Svc_CoOccuring Svc_CaseManagement Svc_TraumaSpecific Svc_ReferredCore Svc_MedicalCare 
Svc_Employment Svc_Family Svc_ChildCare Svc_Transportation Svc_Education Svc_Housing Svc_SocialRecreational Svc_ConsumerOperated 
Svc_HIVTesting Svc_ReferredSupport
             ( -9).
            

/*Format ID so it's numbers and doesn't contain ' ' */

            STRING  Client_ID (A8).
            COMPUTE Client_ID=CHAR.SUBSTR(ConsumerID,2,8).
            VARIABLE LABELS  
                 Client_ID 'ID of clients for matching across datasets'.

            ALTER TYPE Client_ID (F1).

            STRING  Client_ID_7 (A8).
            COMPUTE Client_ID_7=CHAR.SUBSTR(ConsumerID,2,7).
            VARIABLE LABELS  
                 Client_ID_7 'ID of clients for matching across datasets'.

            ALTER TYPE Client_ID_7 (F1).

            DATASET ACTIVATE FullData.
            DO IF  Missing(Client_ID).
            RECODE Client_ID_7 (ELSE=Copy) INTO Client_ID.
            END IF.
            EXECUTE.

            DATASET ACTIVATE FullData.
            DELETE VARIABLES Client_ID_7.

            STRING  Client_ID_6 (A8).
            COMPUTE Client_ID_6=CHAR.SUBSTR(ConsumerID,2,6).
            VARIABLE LABELS  
                 Client_ID_6 'ID of clients for matching across datasets'.

            ALTER TYPE Client_ID_6 (F1).

            DATASET ACTIVATE FullData.
            DO IF  Missing(Client_ID).
            RECODE Client_ID_6 (ELSE=Copy) INTO Client_ID.
            END IF.
            EXECUTE.

            DATASET ACTIVATE FullData.
            DELETE VARIABLES Client_ID_6.

     
/*Fix the one case where the ID is entered wrong*/
            
            RECODE Client_ID (1090021=0190021).
            EXECUTE.
           
/*..............................................................FIX DATES...................................................*/

/*Create one variable from interview date and discharge date, and then transfer Excel 5 digit date to real date*/

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

                            NUMERIC ODValid (F2.0).
                            COMPUTE ODValid = NOT SYSMIS(ObservationDate).
                            VARIABLE LABELS ODValid 'ObservationDate is Valid'.
                            VALUE LABELS ODVALID 0 'False' 1 'True'.
                            EXECUTE.
                            DATASET ACTIVATE FullData.
                            FREQUENCIES VARIABLES=ODValid
                              /ORDER=ANALYSIS.

                            DELETE VARIABLES ODValid.
                            EXECUTE.

                            /*There are 39 rows for whom this process does not work because both their InterviewDate and Discharge date are MISSING*/.
                            /*Workaround is to compute a date for them from Month and FFY*/.
<<<<<<< HEAD

=======
>>>>>>> SS-00001
                            /*First step is to compute a valid year from FFY*/.
                            DO IF Month GE 10.
                                COMPUTE YearTemp = FFY - 1.
                            ELSE.
                                COMPUTE YearTemp = FFY.
                            END IF.
                            EXECUTE.
                            /*Then use valid year to compute a valid ObservationDate*/.
                            IF SYSMIS(ObservationDate) ObservationDate = DATE.MDY(Month, 15, YearTemp).
                            EXECUTE.
                            
                            DELETE VARIABLES observationtemp InterviewDate DischargeDate ConsumerID interview YearTemp.
                            
/*Fix other dates in the file*/
                            
                            AUTORECODE VARIABLES=GAFDate
                            /into GAFDateTemp
                            /print.
                            
                            STRING GAFDate_String (A11).
                            DO IF  (GAFDateTemp > 2).
                            RECODE GAFDate (ELSE=Copy) INTO GAFDate_String.
                            END IF.
                            EXECUTE.
                                                     
                            alter type  GAFDate_String (f1).
                            COMPUTE GAFDate_New  = DATE.MDY(1,1,1900) +( (GAFDate_String - 2) * 24 * 60 * 60).
                            FORMATS GAFDate_New (DATE14).
                            EXECUTE.

                             DELETE VARIABLES GAFDate GAFDateTemp GAFDate_String.
                            
                            AUTORECODE VARIABLES=DateBloodDrawn
                            /into DateBloodDrawnTemp
                            /print.
                            
                            STRING DateBloodDrawn_String (A11).
                            DO IF  (DateBloodDrawnTemp > 3).
                            RECODE DateBloodDrawn (ELSE=Copy) INTO DateBloodDrawn_String.
                            END IF.
                            EXECUTE.
                            
                            alter type  DateBloodDrawn_String (f1).
                            COMPUTE DateBloodDrawn_New  = DATE.MDY(1,1,1900) +( (DateBloodDrawn_String - 2) * 24 * 60 * 60).
                            FORMATS DateBloodDrawn_New (DATE14).
                            EXECUTE.
                            DELETE VARIABLES DateBloodDrawnTemp DateBloodDrawn_String .

                            AUTORECODE VARIABLES=LastServiceDate
                            /into LastServiceDateTemp
                            /print.
                            
                            STRING LastServiceDate_String (A11).
                            DO IF  (LastServiceDateTemp > 3).
                            RECODE LastServiceDate (ELSE=Copy) INTO LastServiceDate_String.
                            END IF.
                            EXECUTE.
                            
                            alter type  LastServiceDate_String (f1).
                            COMPUTE LastServiceDate_New  = DATE.MDY(1,1,1900) +( (LastServiceDate_String - 2) * 24 * 60 * 60).
                            FORMATS LastServiceDate_New (DATE14).
                            EXECUTE.
                            DELETE VARIABLES LastServiceDate LastServiceDateTemp LastServiceDate_String.

                            AUTORECODE VARIABLES=DOB
                            /into DOBTemp
                            /print.
                            
                            STRING DOB_String (A11).
                            DO IF  (DOBTemp > 2).
                            RECODE DOB (ELSE=Copy) INTO DOB_String.
                            END IF.
                            EXECUTE.
                                                     
                            alter type  DOB_String (f1).
                            COMPUTE DOB_New  = DATE.MDY(1,1,1900) +( (DOB_String - 2) * 24 * 60 * 60).
                            FORMATS DOB_New (DATE14).
                            EXECUTE.

                             DELETE VARIABLES DOB DOBTemp DOB_String.

/*..........................ADD VALUE LABELS..............................................*/

/*Yes and No*/

RECODE OtherFederalGrantFunding
StateFunding
ConsumerPrivateInsurance
MedicaidMedicare
OtherResponse
(2=0).

VALUE LABELS
ConductedInterview EverServed HispanicLatino EthnicCentralAmerican EthnicCuban EthnicDominican EthnicMexican EthnicPuertoRican EthnicSouthAmerican 
EthnicOther RaceBlack RaceAsian RaceNativeHawaiian RaceAlaskaNative RaceWhite RaceAmericanIndian ActiveDuty_Self ViolenceTrauma 
VT_NightmaresThoughts VT_NotThinkAboutIt VT_OnGuard VT_NumbDetached Employed_MinWageOrAbove Employed_PaidDirectly Employed_AnyoneApplied 
EightHour_fast NoContact90Days StillReceivingServices Svc_Screening Svc_Assessment Svc_TreatmentPlanning Svc_Psychopharmacological 
Svc_MentalHealth Svc_CoOccuring Svc_CaseManagement Svc_TraumaSpecific Svc_ReferredCore Svc_MedicalCare Svc_Employment Svc_Family 
Svc_ChildCare Svc_Transportation Svc_Education Svc_Housing Svc_SocialRecreational Svc_ConsumerOperated Svc_HIVTesting Svc_ReferredSupport  
OtherFederalGrantFunding StateFunding ConsumerPrivateInsurance MedicaidMedicare OtherResponse 
1 'Yes' 0 'No'.

/*Demographics*/

VALUE LABELS Gender 1 'Male'
 2 'Female'
 3 'Transgender'
 4 'Other'.
VALUE LABELS Agegroup 
 2 'Age 10 to 12 years old'
 3 'Age 13 to 15 years old'
 4 'Age 16 to 25 years old'
 5 'Age 26 to 34 years old'
 6 'Age 35 to 44 years old'
 7 'Age 45 to 54 years old'
 8 'Age 55 to 64 years old'
 9 'Age 65 to 74 years old'
 10 'Age 75 to 84 years old'
 11 'Age 85 to 94 years old'
 12 'Age 95 years or older'.
VALUE LABELS SexualIdentity 1 'Heterosexual'
 2 'Lesbian or gay'
 3 'Bisexual'
 4 'Other'.

/*FUNCTIONING*/

VALUE LABELS OverallHealth 1 'Excellent'
 2 'Very Good'
 3 'Good'
 4 'Fair'
 5 'Poor'.
VALUE LABELS CapableManagingHealthCareNeeds 1 'On my own most of the time'
 2 'On my own some of the time and with support from others some of the time'
 3 'With support from others most of the time'
 4 'Rarely or never'.
VALUE LABELS HandlingDailyLife to Symptoms
 1 'Strongly Disagree'
 2 'Disagree'
 3 'Undecided'
 4 'Agree'
 5 'Strongly Agree'.
VALUE LABELS
Nervous to Worthless
0 'None of the Time'
1 'A Little of the Time'
2 'Some of the Time'
3 'Most of the Time'
4 'All of the Time'.
VALUE LABELS
PsychologicalEmotionalProblems 1 'Not at all'
 2 'Slightly'
 3 'Moderately'
 4 'Considerably'
 5 'Extremely'.
VALUE LABELS
LifeQuality 1 'Very Poor'
 2 'Poor'
 3 'Neither Good nor Poor'
 4 'Good'
 5 'Very Good'.
VALUE LABELS
EnoughEnergyForEverydayLife 1 'Not at All'
 2 'A Little'
 3 'Moderately'
 4 'Mostly'
 5 'Completely'.
VALUE LABELS
PerformDailyActivitiesSatisfaction to RelationshipSatisfaction 1 'Very Dissatisfied'
 2 'Dissatisfied'
 3 'Neither Satisfied nor Dissatisfied'
 4 'Satisfied'
 5 'Very Satisfied'.
VALUE LABELS
Tobacco_Use to Other_Use
1 'Never'
2 'Once or Twice'
3 'Weekly'
4 'Daily or Almost Daily'.
EXECUTE.

/*Stability in Housing*/

VALUE LABELS
PhysicallyHurt 1 'Never'
 4 'Once'
 2 'A few times'
 3 'More than a few times'.
VALUE LABELS Housing 1 'Owned Or Rented House, Apartment, Trailer, Room'
 2 'Someone Elses House, Apartment, Trailer, Room'
 3 'Homeless (Shelter, Street/Outdoors, Park)'
 4 'Group Home'
 5 'Adult Foster Care'
 6 'Transitional Living Facility'
 9 'Hospital (Medical)'
 10 'Hospital (Psychiatric)'
 19 'Detox/Inpatient Or Residential Substance Abuse Treatment Facility'
 11 'Correctional Facility (Jail/Prison)'
 12 'Nursing Home'
 13 'Va Hospital'
 14 'Veterans Home'
 15 'Military Base'
 18 'Other Housed (Specify)'.
VALUE LABELS LivingConditionsSatisfaction 1 'Very Dissatisfied'
 2 'Dissatisfied'
 3 'Neither Satisfied nor Dissatisfied'
 4 'Satisfied'
 5 'Very Satisfied'.
VALUE LABELS
Enrolled 0 'Not Enrolled'
 1 'Enrolled, Full Time'
 2 'Enrolled, Part Time'
 3 'Other (Specify)'.
VALUE LABELS
 Education 11 'Less Than 12th Grade'
 12 '12th Grade /High School Diploma/ Equivalent (Ged)'
 13 'Voc/Tech Diploma'
 14 'Some College Or University'
 15 'Bachelors Degree (Ba, Bs)'
 16 'Graduate Work/Graduate Degree'.
VALUE LABELS Employment 1 'Employed Full Time (35+ Hours Per Week, Or Would Have Been)'
 2 'Employed Part Time'
 3 'Unemployed, Looking For Work'
 4 'Unemployed, Disabled'
 5 'Unemployed, Volunteer Work'
 6 'Unemployed, Retired'
 7 'Unemployed, Not Looking For Work'
 8 'Other (Specify)'.
VALUE LABELS Employmenttype_07 1 'Competitive Employment'
 2 'Sheltered Employment'.
VALUE LABELS Enoughmoneyforneeds 1 'Not At All'
 2 'A Little'
 3 'Moderately'
 4 'Mostly'
 5 'Completely'.
VALUE LABELS 
Recover to RecommendAgency
1 'Strongly Disagree'
2 'Disagree'
3 'Undecided'
4 'Agree'
5 'Strongly Agree'.
VALUE LABELS
Friendships to GenerallyAccomplishGoal
1 'Strongly Disagree'
2 'Disagree'
3 'Undecided'
4 'Agree'
5 'Strongly Agree'.
EXECUTE.

*Diagnosis Categories */

VALUE LABELS
DiagnosisOne DiagnosisTwo DiagnosisThree
1 'F10.10 - Alcohol use disorder, uncomplicated, mild' 
2 'F10.11 - Alcohol use disorder, mild, in remission' 
3 'F10.20 - Alcohol use disorder, uncomplicated, moderate or severe' 
4 'F10.21 - Alcohol use disorder, moderate or severe, in remission'
5 'F10.9 - Alcohol use, unspecified'
6 'F11.10 - Opioid use disorder, uncomplicated, mild'
7 'F11.11 - Opioid use disorder, mild, in remission'
8 'F11.20 - Opioid use disorder, uncomplicated, moderate or severe'
9 'F11.21 - Opioid use disorder, moderate or severe, in remission'
10 'F11.9 - Opioid use, unspecified'
11 'F12.10 - Cannabis use disorder, uncomplicated, mild'
12 'F12.11 - Cannabis use disorder, mild, in remission'
13 'F12.20 - Cannabis use disorder, uncomplicated, moderate or severe'
14 'F12.21 - Cannabis use disorder, moderate or severe, in remission'
15 'F12.9 - Cannabis use, unspecified'
16 'F13.10 - Sedative, hypnotic, or anxiolytic use disorder, uncomplicated, mild'
17 'F13.11 - Sedative, hypnotic, or anxiolytic use disorder, mild, in remission'
18 'F13.20 - Sedative, hypnotic, or anxiolytic use disorder, uncomplicated, moderate or severe'
19 'F13.21 - Sedative, hypnotic, or anxiolytic use disorder, moderate or severe, in remission'
20 'F13.9 - Sedative, hypnotic, or anxiolytic use, unspecified'
21 'F14.10 - Cocaine use disorder, uncomplicated, mild'
22 'F14.11 - Cocaine use disorder, mild, in remission'
23 'F14.20 - Cocaine use disorder, uncomplicated, moderate or severe'
24 'F14.21 - Cocaine use disorder, moderate or severe, in remission'
25 'F14.9 - Cocaine use, unspecified'
26 'F15.10 - Other stimulant use disorder, uncomplicated, mild'
27 'F15.11 - Other stimulant use disorder, mild, in remission'
28 'F15.20 - Other stimulant use disorder, uncomplicated, moderate or severe'
29 'F15.21 - Other stimulant use disorder, moderate or severe, in remission'
30 'F15.9 - Other stimulant use, unspecified'
31 'F16.10 - Hallucinogen use disorder, uncomplicated, mild'
32 'F16.11 - Hallucinogen use disorder, mild, in remission'
33 'F16.20 - Hallucinogen use disorder, uncomplicated, moderate or severe'
34 'F16.21 - Hallucinogen use disorder moderate or severe, in remission'
35 'F16.9 - Hallucinogen use, unspecified'
36 'F18.10 - Inhalant use disorder, uncomplicated, mild'
37 'F18.11 - Inhalant use disorder, mild, in remission'
38 'F18.20 - Inhalant use disorder, uncomplicated, moderate or severe'
39 'F18.21 - Inhalant use disorder, moderate or severe, in remission'
40 'F18.9 - Inhalant use, unspecified'
41 'F19.10 - Other psychoactive substance use disorder, uncomplicated, mild'
42 'F19.11 - Other psychoactive substance use disorder, in remission'
43 'F19.20 - Other psychoactive substance use disorder, uncomplicated, moderate or severe'
44 'F19.21 - Other psychoactive substance use disorder, moderate or severe, in remission'
45 'F19.9 - Other psychoactive substance use, unspecified'
46 'F17.20 - Tobacco use disorder, mild or moderate or severe'
47 'F17.21 - Tobacco use disorder, mild or moderate or severe, in remission'
48 'F20 - Schizophrenia'
49 'F21 - Schizotypal disorder'
50 'F22 - Delusional disorder'
51 'F23 - Brief psychotic disorder'
52 'F24 - Shared psychotic disorder'
53 'F25 - Schizoaffective disorders'
54 'F28 - Other psychotic disorder not due to a substance or known physiological condition'
55 'F29 - Unspecified psychosis not due to a substance or known physiological condition'
56 'F30 - Manic episode'
57 'F31 - Bipolar disorder'
58 'F32 - Major depressive disorder, single episode'
59 'F33 - Major depressive disorder, recurrent'
60 'F34 - Persistent mood [affective] disorders'
61 'F39 - Unspecified mood [affective] disorder'
62 'F40-F48 - Anxiety, dissociative, stress-related, somatoform and other nonpsychotic mental disorders'
63 'F50 - Eating disorders'
64 'F51 - Sleep disorders not due to a substance or known physiological condition'
65 'F60.2 - Antisocial personality disorder'
66 'F60.3 - Borderline personality disorder'
67 'F60.0, F60.1, F60.4-F69 - Other personality disorders'
68 'F70-F79 - Intellectual disabilities'
69 'F80-F89 - Pervasive and specific developmental disorders'
70 'F90 - Attention-deficit hyperactivity disorders' 
71 'F91 - Conduct disorders'
72 'F93 - Emotional disorders with onset specific to childhood'
73 'F94 - Disorders of social functioning with onset specific to childhood or adolescence'
74 'F95 - Tic disorder' 
75 'F98 - Other behavioral and emotional disorders with onset usually occurring in childhood and adolescence'
76 'F99 - Unspecified mental disorder'.
EXECUTE.

/*DROP ALL THE Un-needed Variables*/

DELETE VARIABLES
ConsumerType_07 
ReassessmentNumber_07 WhyNotConducted_10 NextReassessment_10 SubmittedAtClinicalDischarge_10
AD_ArmedForces AD_NationalGuard AD_P1CombatOpr_11 AD_P1Died_11 AD_P1Injured_11 AD_P1Rel_OtherSpec_11 AD_P1Relationship_11 
AD_P1Stress_11 AD_P2CombatOpr_11 AD_P2Died_11 AD_P2Injured_11 AD_P2Rel_OtherSpec_11 AD_P2Relationship_11 AD_P2Stress_11 
AD_P3CombatOpr_11 AD_P3Died_11 AD_P3Injured_11 AD_P3Rel_OtherSpec_11 AD_P3Relationship_11 AD_P3Stress_11 AD_P4CombatOpr_11 AD_P4Died_11 
AD_P4Injured_11 AD_P4Rel_OtherSpec_11 AD_P4Relationship_11 AD_P4Stress_11 AD_P5CombatOpr_11 AD_P5Died_11 AD_P5Injured_11 AD_P5Rel_OtherSpec_11 
AD_P5Relationship_11 AD_P5Stress_11 AD_P6CombatOpr_11 AD_P6Died_11 AD_P6Injured_11 AD_P6Rel_OtherSpec_11 AD_P6Relationship_11 AD_P6Stress_11 
AD_Reserves ED_IraqAfghan ED_Korea ED_Other ED_PersianGulf 
ED_VietnamSEAsia ED_WWII ES_ArmedForces ES_NationalGuard ES_Reserves EverDeployed
Si_Assessment.
EXECUTE.

