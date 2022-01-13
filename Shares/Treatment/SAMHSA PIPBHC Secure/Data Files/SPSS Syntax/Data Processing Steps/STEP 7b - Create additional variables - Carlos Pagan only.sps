* Encoding: UTF-8.
* Encoding: .

*create a variable to indicate if the clients have been re-assessed

DATASET ACTIVATE PIPBHC_Long.
RECODE ObservationDate.2 (MISSING=0) into ClientReassessed6M.
EXECUTE.
DO IF (ObservationDate.2 >0).
COMPUTE ClientReassessed6M = 1.
END IF.
EXECUTE.

VARIABLE LABELS
ClientReassessed6M 'Has the six-month reassessment for this client been completed?'.
VALUE LABELS
    ClientReassessed6M
        0 ' No'
        1 'Yes'.
EXECUTE.

DATASET ACTIVATE PIPBHC_Long.
RECODE ObservationDate.3 (MISSING=0) into ClientReassessed12M.
EXECUTE.
DO IF (ObservationDate.3 >0).
    COMPUTE ClientReassessed12M = 1.
END IF.
EXECUTE.

VARIABLE LABELS
    ClientReassessed12M 'Has the twelve-month reassessment for this client been completed?'.
VALUE LABELS
    ClientReassessed12M
        0 ' No'
        1 'Yes'.
EXECUTE.

COMPUTE today = $time.
EXECUTE.
Formats today(edate10).

COMPUTE  TimeSinceEnrollment=DATEDIF(today, ObservationDate.1, "days").
VARIABLE LABELS  TimeSinceEnrollment "Number of days since client was enrolled".
VARIABLE LEVEL  TimeSinceEnrollment (SCALE).
FORMATS  TimeSinceEnrollment (F5.0).
VARIABLE WIDTH  TimeSinceEnrollment(5).
EXECUTE.

*Time between enrollment and 12-month follow-up

COMPUTE  TimeSinceEnrollment2=DATEDIF(today, ObservationDate.1, "days").
VARIABLE LABELS  TimeSinceEnrollment2 "Number of days since client was enrolled".
VARIABLE LEVEL  TimeSinceEnrollment2 (SCALE).
FORMATS  TimeSinceEnrollment2 (F5.0).
VARIABLE WIDTH  TimeSinceEnrollment2(5).
EXECUTE.

*Adding reassessment dates - when the window opens, the due date, and last day for reassessment*/

*6-month follow up window

IF (TimeSinceEnrollment < 150 & TimeSinceEnrollment >= 0) Reassessment6=0.
IF (TimeSinceEnrollment >= 150 & TimeSinceEnrollment <180) Reassessment6=1.
IF (TimeSinceEnrollment >= 180 & TimeSinceEnrollment <=210) Reassessment6=2.
IF (TimeSinceEnrollment > 210) Reassessment6=3.
EXECUTE.

VALUE LABELS
Reassessment6
0 'Not yet in Reassessment Window'
1 'More than 30 days left'
2 'Less than 30 days left'
3 'Reassessment Window Closed'.
EXECUTE.

*Adding reassessment dates - when the window opens, the due date, and last day for reassessment*/

COMPUTE WindowOpen6 = datesum(ObservationDate.1, 150, 'days').
COMPUTE ReassessmentDue6 = datesum(ObservationDate.1, 180, 'days').
COMPUTE LastDay6 = datesum(ObservationDate.1, 210, 'days').
EXECUTE.

FORMATS WindowOpen6(date11).
FORMATS ReassessmentDue6(date11).
FORMATS LastDay6(date11).

VARIABLE LABELS
WindowOpen6 'Date 6-Month Reassessment Window Opens'
ReassessmentDue6 '6-Month Reassessment Due Date'
LastDay6 'Last Day for 6-Month Reassessment'.
EXECUTE.

COMPUTE DaysSince6WindowOpen =datediff(today, WindowOpen6, 'days').
EXECUTE.

COMPUTE DaysLeft6 = datedif(LastDay6, today, "days").


*12-month follow up window.
IF (TimeSinceEnrollment2 < 335 & TimeSinceEnrollment2 >= 0) Reassessment12=0.
IF (TimeSinceEnrollment2 >= 335 & TimeSinceEnrollment2 <=365) Reassessment12=1.
IF (TimeSinceEnrollment2 > 365 & TimeSinceEnrollment2 <=395) Reassessment12=2.
IF (TimeSinceEnrollment2 > 395) Reassessment12=3.
EXECUTE.

VALUE LABELS
Reassessment12
0 'Not yet in Reassessment Window'
1 'More than 30 days left'
2 'Less than 30 days left'
3 'Reassessment Window Closed'.
EXECUTE.

COMPUTE WindowOpen12 = datesum(ObservationDate.1, 335, 'days').
COMPUTE ReassessmentDue12 = datesum(ObservationDate.1, 365, 'days').
COMPUTE LastDay12 = datesum(ObservationDate.1, 395, 'days').
EXECUTE.

FORMATS WindowOpen12(date11).
FORMATS ReassessmentDue12(date11).
FORMATS LastDay12(date11).

VARIABLE LABELS
WindowOpen12 'Date 12-Month Reassessment Window Opens'
ReassessmentDue12 '12-Month Reassessment Due Date'
LastDay12 'Last Day for 12-Month Reassessment'.
EXECUTE.

COMPUTE DaysSince12WindowOpen = datediff(today, WindowOpen12, 'days').
EXECUTE.

COMPUTE DaysLeft12 = datedif(LastDay12, today, "days").
EXECUTE.

* More variable labels.
VARIABLE LABELS
today 'Current date'
TimeSinceEnrollment2 'Number of days since client was enrolled (for calculating 12-month follow-up)'
Reassessment6 'Client 6-month reassessment status'
DaysSince6WindowOpen 'Days since the 6-month reassessment window opened'
DaysLeft6 'Number of days left in the 6-month reassessment window'
Reassessment12 'Client 12-month reassessment status'
DaysSince12WindowOpen 'Days since the 12-month reassessment window opened'
DaysLeft12 'Number of days left in the 12-month reassessment window'.

