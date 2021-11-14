* Encoding: UTF-8.
*Filter out Ramon Velez, Clay, and discharged clients

/**UNCOMMENT APPROPRIATE LINE FOR TESTING/LIVE DEPLOYMENT.
FILE HANDLE reassessTracking /NAME='D:\SyncThing\tempchin\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\Excel Files\Reassessment Tracking Spreadsheets\Reassessment Tracking.xls'.
*FILE HANDLE reassessTracking /NAME='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\Excel Files\Reassessment Tracking Spreadsheets\Reassessment Tracking.xls'

/***SELECT ONLY THOSE CLIENTS WHO ATTENDED Clinic 3.
DATASET ACTIVATE PIPBHC_Long.
DATASET COPY PIPBHC_temp.
DATASET ACTIVATE PIPBHC_temp.
FILTER OFF.
USE ALL.
SELECT IF (Clinic = 3).
EXECUTE.

/***FROM THE RECORDS THAT REMAIN, SELECT ONLY THOSE WHO ARE NOT DISCHARGED.
DATASET ACTIVATE PIPBHC_temp.
RECODE Discharged (SYSMIS=0).
DATASET ACTIVATE PIPBHC_temp.
FILTER OFF.
USE ALL.
SELECT IF (Discharged=0).
EXECUTE.

* Excludes people who have already been reassessed.
/***For all clients whose ClientReassessed3M = 1 (True), those who are still inside the reassessment window have their Reassessment3 value recoded ST
/*** they are no longer inside the reassessment window. Everyone else's values stay the same. This way, people still inside the window, but already reassessed
/***are not flagged for a redundant reassessment.
DO IF  (ClientReassessed3M = 1).
RECODE Reassessment3 (1=4)(2=4)(ELSE=Copy).
END IF.
EXECUTE. 

*Will throw error until people have been reassessed at 6M.
DO IF  (ClientReassessed6M = 1).
RECODE Reassessment6 (1=4)(2=4)(ELSE=Copy).
END IF.
EXECUTE.

DO IF  (ClientReassessed9M = 1).
RECODE Reassessment9 (1=4)(2=4)(ELSE=Copy).
END IF.
EXECUTE.

DO IF  (ClientReassessed12M = 1).
RECODE Reassessment12 (1=4)(2=4)(ELSE=Copy).
END IF.
EXECUTE.


/***Compute a variable that determines whether the client needs ANY reassessment at any time point
DATASET ACTIVATE PIPBHC_temp.
RECODE Reassessment12 (1=1) (2=2) (ELSE=3) INTO Reassessment.
RECODE Reassessment9 (1=1) (2=2) (ELSE=3) INTO Reassessment.
RECODE Reassessment6 (1=1) (2=2) (ELSE=3) INTO Reassessment.
RECODE Reassessment3 (1=1) (2=2) (ELSE=3) INTO Reassessment.

VARIABLE LABELS  Reassessment 'Does the client need a reassessment, combined 3, 6, 9, and 12 months'.
EXECUTE.

VALUE LABELS
Reassessment
0 'Not in Reassessment Window'
1 'More than 30 days left'
2 'Less than 30 days left'.
EXECUTE.

* Removes people who are not at risk (for Carlos Pagan).
IF (Lipid_LDL.1 > 130 OR Lipid_Tri.1 > 150) Reassessment3=5.
 * IF (Lipid_LDL.1 < 130 AND Lipid_Tri.1 < 150) Reassessment9=5.
EXECUTE.

DATASET ACTIVATE PIPBHC_temp.
FILTER OFF.
USE ALL.
SELECT IF (Reassessment < 3).
SELECT IF (Reassessment3 = 5 OR Reassessment6 = 5 OR 
                   Reassessment9 = 5 OR Reassessment12 = 5).
EXECUTE.

DO IF  (Reassessment3 = 5).
RECODE LastDay3 (ELSE=Copy) INTO DeadlineReassess.
END IF.
DO IF  (Reassessment6 = 5).
RECODE LastDay6 (ELSE=Copy) INTO DeadlineReassess.
END IF.
DO IF  (Reassessment9 = 5).
RECODE LastDay9 (ELSE=Copy) INTO DeadlineReassess.
END IF.
DO IF  (Reassessment12 = 5).
RECODE LastDay12 (ELSE=Copy) INTO DeadlineReassess.
END IF.
VARIABLE LABELS  DeadlineReassess 'Deadline to reassess before window closes'.
EXECUTE.
Format DeadlineReassess(ADATE10).

SAVE TRANSLATE OUTFILE="reassessTracking"
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE
  /Keep=Client_ID Reassessment DeadlineReassess ObservationDate.1 Lipid_LDL.1 Lipid_Tri.1
  /RENAME (Client_ID Reassessment DeadlineReassess ObservationDate.1
  = ClientID Reassessment_Status Reassessment_Deadline EnrollmentDate).

*DATASET CLOSE PIPBHC_temp.
