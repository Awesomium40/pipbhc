* Encoding: UTF-8.


/***CREATE LISTS OF VARIABLES CONTAINING THE ObservationDate VARS
/***IF THE VARIABLES DON'T EXIST, THESE LISTS WILL BE EMPTY.
SPSSINC SELECT VARIABLES MACRONAME="!OD2" 
     /PROPERTIES  PATTERN = "ObservationDate.2".

SPSSINC SELECT VARIABLES MACRONAME="!OD3" 
     /PROPERTIES  PATTERN = "ObservationDate.3".

SPSSINC SELECT VARIABLES MACRONAME="!OD4" 
     /PROPERTIES  PATTERN = "ObservationDate.4".

SPSSINC SELECT VARIABLES MACRONAME="!OD5" 
     /PROPERTIES  PATTERN = "ObservationDate.5".

*create a variable to indicate if the clients have been re-assessed at 3 months

DATASET ACTIVATE PIPBHC_Long.
RECODE ObservationDate.2 (MISSING=0) into ClientReassessed3M.
EXECUTE.
DO IF (ObservationDate.2 >0).
COMPUTE ClientReassessed3M = 1.
END IF.
EXECUTE.


/***THE FOLLOWING MACRO WORKS IN CONCERT WITH THE ABOVE SPSSINC STATEMENTS
/***TOGETHER, THEY ONLY COMPUTE THE ClientReassessedxM VARS IF THE CORRESPONDING
/***ObservationDate.x VAR EXISTS
/***THIS WILL ELIMINATE THE PROBLEM OF SYNTAX THROWING ERRORS IF VARS DON'T EXIST.
DEFINE ComputeClientReassessedVars ()
!if (!eval(!OD3)<>"") !then
  DATASET ACTIVATE PIPBHC_Long.
  RECODE ObservationDate.3 (MISSING=0) into ClientReassessed6M.
  EXECUTE.
  DO IF (ObservationDate.3 >0).
  COMPUTE ClientReassessed6M = 1.
  END IF.
  EXECUTE.
!ifend

!if (!eval(!OD4)<>"") !then
  DATASET ACTIVATE PIPBHC_Long.
  RECODE ObservationDate.4 (MISSING=0) into ClientReassessed9M.
  EXECUTE.
  DO IF (ObservationDate.4 >0).
  COMPUTE ClientReassessed9M = 1.
  END IF.
  EXECUTE.
!ifend

!if (!eval(!OD5)<>"") !then
  PRINT /"Toasty"
  DATASET ACTIVATE PIPBHC_Long.
  RECODE ObservationDate.5 (MISSING=0) into ClientReassessed12M.
  EXECUTE.
  DO IF (ObservationDate.5 >0).
  COMPUTE ClientReassessed12M = 1.
  END IF.
  EXECUTE.
!ifend
!ENDDEFINE.

/***THIS ACTUALLY EXECUTES THE MACRO DEFINED ABOVE.
ComputeClientReassessedVars.

/***ONCE THE VARS ARE COMPUTED, THE VARIABLE LISTS ARE NO LONGER NECESSARY, SO CLEAR THEM.
DEFINE !OD3() !ENDDEFINE.
DEFINE !OD4() !ENDDEFINE.
DEFINE !OD5() !ENDDEFINE.

COMPUTE today = $time.
EXECUTE.
Formats today(edate10).

COMPUTE  TimeSinceEnrollment=DATEDIF(today, ObservationDate.1, "days").

*Time between enrollment and 12-month follow-up.
COMPUTE  TimeSinceEnrollment2=DATEDIF(today, ObservationDate.1, "days").
EXECUTE.


*3-month follow up window

IF (TimeSinceEnrollment < 60 & TimeSinceEnrollment >= 0) Reassessment3=0.
IF (TimeSinceEnrollment >= 60 & TimeSinceEnrollment <  90) Reassessment3=1.
IF (TimeSinceEnrollment >= 90 & TimeSinceEnrollment <= 120) Reassessment3=2.
IF (TimeSinceEnrollment > 120) Reassessment3=3.
EXECUTE.


*Adding reassessment dates - when the window opens, the due date, and last day for reassessment*/

COMPUTE WindowOpen3 = datesum(ObservationDate.1, 60, 'days').
COMPUTE ReassessmentDue3 = datesum(ObservationDate.1, 90, 'days').
COMPUTE LastDay3 = datesum(ObservationDate.1, 120, 'days').
EXECUTE.

COMPUTE DaysSince3WindowOpen = DATEDIFF(today, WindowOpen3, 'days').
EXECUTE.

COMPUTE DaysLeft3 = DATEDIFF(LastDay3, today, "days").

*6-month follow up window

IF (TimeSinceEnrollment < 150 & TimeSinceEnrollment >= 0) Reassessment6=0.
IF (TimeSinceEnrollment >= 150 & TimeSinceEnrollment <180) Reassessment6=1.
IF (TimeSinceEnrollment >= 180 & TimeSinceEnrollment <=210) Reassessment6=2.
IF (TimeSinceEnrollment > 210) Reassessment6=3.
EXECUTE.


*Adding reassessment dates - when the window opens, the due date, and last day for reassessment*/

COMPUTE WindowOpen6 = datesum(ObservationDate.1, 150, 'days').
COMPUTE ReassessmentDue6 = datesum(ObservationDate.1, 180, 'days').
COMPUTE LastDay6 = datesum(ObservationDate.1, 210, 'days').
EXECUTE.

COMPUTE DaysSince6WindowOpen =datediff(today, WindowOpen6, 'days').
EXECUTE.

COMPUTE DaysLeft6 = datedif(LastDay6, today, "days").

*9-month follow up window

IF (TimeSinceEnrollment < 240 & TimeSinceEnrollment >= 0) Reassessment9=0.
IF (TimeSinceEnrollment >= 240 & TimeSinceEnrollment < 270) Reassessment9=1.
IF (TimeSinceEnrollment >= 270 & TimeSinceEnrollment <= 300) Reassessment9=2.
IF (TimeSinceEnrollment > 300) Reassessment9=3.

* Removing people who are not at risk.
 * IF (Lipid_LDL.1 < 130 AND Lipid_Tri.1 < 150) Reassessment9=5.
 * EXECUTE.



*Adding reassessment dates - when the window opens, the due date, and last day for reassessment*/

COMPUTE WindowOpen9 = datesum(ObservationDate.1, 240, 'days').
COMPUTE ReassessmentDue9 = datesum(ObservationDate.1, 270, 'days').
COMPUTE LastDay9 = datesum(ObservationDate.1, 300, 'days').
EXECUTE.


COMPUTE DaysSince9WindowOpen =datediff(today, WindowOpen9, 'days').
EXECUTE.

COMPUTE DaysLeft9 = datedif(LastDay9, today, "days").

*12-month follow up window

IF (TimeSinceEnrollment2 < 335 & TimeSinceEnrollment2 >= 0) Reassessment12=0.
IF (TimeSinceEnrollment2 >= 335 & TimeSinceEnrollment2 <=365) Reassessment12=1.
IF (TimeSinceEnrollment2 > 365 & TimeSinceEnrollment2 <=395) Reassessment12=2.
IF (TimeSinceEnrollment2 > 395) Reassessment12=3.
EXECUTE.


COMPUTE WindowOpen12 = datesum(ObservationDate.1, 335, 'days').
COMPUTE ReassessmentDue12 = datesum(ObservationDate.1, 365, 'days').
COMPUTE LastDay12 = datesum(ObservationDate.1, 395, 'days').
EXECUTE.


COMPUTE DaysSince12WindowOpen = datediff(today, WindowOpen12, 'days').
COMPUTE DaysLeft12 = datedif(LastDay12, today, "days").
EXECUTE.

/************UPDATE DICTIONARY INFO************/.
FORMATS TimeSinceEnrollment TimeSinceEnrollment2 (F5.0)
/WindowOpen3 ReassessmentDue3 LastDay3 WindowOpen6 ReassessmentDue6 LastDay6 WindowOpen9 ReassessmentDue9 LastDay9 WindowOpen12 ReassessmentDue12 LastDay12(date11).


VALUE LABELS
ClientReassessed3M ClientReassessed6M ClientReassessed9M ClientReassessed12M
    0 ' No'
    1 'Yes'
/Reassessment3 Reassessment6 Reassessment9 Reassessment12
    0 'Not yet in Reassessment Window'
    1 'More than 30 days left'
    2 'Less than 30 days left'
    3 'Reassessment Window Closed'
    5 'Not eligible for assessment'.


* More variable labels.
VARIABLE LABELS
TimeSinceEnrollment "Number of days since client was enrolled"
TimeSinceEnrollment2 "Number of days since client was enrolled"
ClientReassessed3M 'Has the three-month reassessment for this client been completed?'
ClientReassessed6M 'Has the six-month reassessment for this client been completed?'
ClientReassessed9M 'Has the nine-month reassessment for this client been completed?'
ClientReassessed12M 'Has the twelve-month reassessment for this client been completed?'
today 'Current date'
TimeSinceEnrollment2 'Number of days since client was enrolled (for calculating 12-month follow-up)'
Reassessment3 'Client 3-month reassessment status'
WindowOpen3 'Date 3-Month Reassessment Window Opens'
ReassessmentDue3 '3-Month Reassessment Due Date'
LastDay3 'Last Day for 3-Month Reassessment'
DaysSince3WindowOpen 'Days since the 3-month reassessment window opened'
DaysLeft3 'Number of days left in the 3-month reassessment window'
WindowOpen6 'Date 6-Month Reassessment Window Opens'
ReassessmentDue6 '6-Month Reassessment Due Date'
LastDay6 'Last Day for 6-Month Reassessment'
Reassessment6 'Client 6-month reassessment status'
DaysSince6WindowOpen 'Days since the 6-month reassessment window opened'
DaysLeft6 'Number of days left in the 6-month reassessment window'
Reassessment9 'Client 9-month reassessment status'
DaysSince9WindowOpen 'Days since the 9-month reassessment window opened'
DaysLeft9 'Number of days left in the 9-month reassessment window'
WindowOpen9 'Date 9-Month Reassessment Window Opens'
ReassessmentDue9 '9-Month Reassessment Due Date'
LastDay9 'Last Day for 9-Month Reassessment'
Reassessment12 'Client 12-month reassessment status'
DaysSince12WindowOpen 'Days since the 12-month reassessment window opened'
DaysLeft12 'Number of days left in the 12-month reassessment window'
WindowOpen12 'Date 12-Month Reassessment Window Opens'
ReassessmentDue12 '12-Month Reassessment Due Date'
LastDay12 'Last Day for 12-Month Reassessment'.

VARIABLE LEVEL  TimeSinceEnrollment TimeSinceEnrollment2 (SCALE).

VARIABLE WIDTH  TimeSinceEnrollment TimeSinceEnrollment2(5).




