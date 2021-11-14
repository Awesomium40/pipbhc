* Encoding: UTF-8.
* Date and Time Wizard: SPARSEnrollmentWeek Used for reporting enrollment by week in old dashboards but not anymore!*/.
FILE HANDLE dbFolder /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Dashboards\Dashboard Data'.

COMPUTE SPARSEnrollmentWeeks=SPARSEnrollmentWeek   +  (52* (YearEnrolled - 2018)).
EXECUTE.


* Encoding: windows-1252.

DATASET ACTIVATE PIPBHC_Long.

/******FIX THE CLIENTS WITH INVALID MonthYearEnrolled******/.
DO IF SYSMIS(MonthYearEnrolled).
COMPUTE Month.1 = XDATE.MONTH(SPARSEnrollmentDate).
COMPUTE  MonthYearEnrolled=DATE.DMY(1, Month.1, YearEnrolled).
END IF.
EXECUTE.

SAVE TRANSLATE OUTFILE="dbFolder\MonthlyDashboard Dataset.xlsx"
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE
  /KEEP= Client_ID Clinic YearEnrolled MonthYearEnrolled SPARSEnrollmentDate SPARSEnrollmentWeek Discharged DischargeDate Followup6M
Followup12M Time.1
Time.2 T_Time.4
T_Time.5
  RaceEth age_cat Gender gender_binary educ_cat edu_cat1 SexualIdentity FFY.1 FFY.2 Quarter.1 Month.1 hous_cat.1
  employ.1 NoSeriousPsychDistress.1 BP.1 BP.2 BP_ABR.1
BP_ABR.2
BMI_cat.1 BMI_cat.2 BCO.1 BCO.2 A1c.1 A1c.2 
    Lipid_TotChol.1 Lipid_TotChol.2   TotChol.1 TotChol.2   Tri.1 Tri.2   Lipid_HDL.1 Lipid_HDL.2   HDL.1 HDL.2   Lipid_LDL.1 Lipid_LDL.2   LDL.1 LDL.2   Lipid_Tri.1 Lipid_Tri.2  
  T_MI.4 T_SMI.4 T_Schiz.4 T_Bipolar.4 T_MajDep.4 T_GAD7_cat.4 T_PHQ9_cat.4 T_PTSD_cat.4 T_MMS_cat.4 
  T_MI.5 T_SMI.5 T_Schiz.5 T_Bipolar.5 T_MajDep.5 T_GAD7_cat.5 T_PHQ9_cat.5 T_PTSD_cat.5 T_MMS_cat.5
  T_GAD7_Bi.4 T_PHQ9_Bi.4 T_MMS_Bi.4 T_GAD7_Bi.5 T_PHQ9_Bi.5 T_MMS_Bi.5
  BP_ABR.1 BP_ABR.2 BMI_ABR.1 BMI_ABR.2 BCO_ABR.1 BCO_ABR.2 WC.1 WC.2 A1c_ABR.1 A1c_ABR.2 
  T_ACE.1 T_ACE.2 T_ACE.3 T_ACE.4 T_ACE.5 T_ACE.6 T_ACE_cat.1 T_ACE_cat.2 T_ACE_cat.3 
T_ACE_cat.4 T_ACE_cat.5 T_ACE_cat.6 T_ACE_Bi.1 
T_ACE_Bi.2 T_ACE_Bi.3 T_ACE_Bi.4 T_ACE_Bi.5 T_ACE_Bi.6
  NHealthAtRisk.1 NMentalHealth.1 T_GAD7_Bi.4 T_PHQ9_Bi.4 T_MMS_Bi.4
  Tobacc_UseBi.1 Tobacc_UseBi.2 Tobacc_UseBi.3 Alcoh_UseBi.1 Alcoh_UseBi.2 Alcoh_UseBi.3
Canna_UseBi.1 Canna_UseBi.2 Canna_UseBi.3 Cocain_UseBi.1 Cocain_UseBi.2 Cocain_UseBi.3 Stim_UseBi.1 
Stim_UseBi.2 Stim_UseBi.3 Meth_UseBi.1 Meth_UseBi.2 Meth_UseBi.3 Inhalant_UseBi.1 Inhalant_UseBi.2
Inhalant_UseBi.3 Sedativ_UseBi.1 Sedativ_UseBi.2 Sedativ_UseBi.3 Hallucinog_UseBi.1 Hallucinog_UseBi.2
Hallucinog_UseBi.3 StreetOpio_UseBi.1 StreetOpio_UseBi.2 StreetOpio_UseBi.3 RxOpioids_UseBi.1 RxOpioids_UseBi.2 RxOpioids_UseBi.3
IllegalSubstanceUse.1 IllegalSubstanceUse.2 NeverUseSub30Days.1 NeverUseSub30Days.2 NeverUseTobacco30Days.1 NeverUseTobacco30Days.2 NotBingeDrinking30Days.1 NotBingeDrinking30Days.2
LastReceivedServiceDate.
