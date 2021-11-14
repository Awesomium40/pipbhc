* Encoding: UTF-8.

* Create a continious version of time between the observation and the clients first enrollment into SPARS
*Date and Time Wizard: Time_Cont.

COMPUTE  Time_Cont=(ObservationDate - SPARSEnrollmentDate) / time.days(1).
EXECUTE.

* Date and Time Wizard: SPARSEnrollmentWeek.
COMPUTE SPARSEnrollmentWeek=XDATE.WEEK(SPARSEnrollmentDate).
EXECUTE.

RECODE Client_ID (20000 thru 29999=2)(100000 thru 199999=1) (200000 thru 299999=2) (300000 thru 399999=3) (3000000 thru 3999999=3)INTO Clinic.
EXECUTE.

/***Update the dictionary info for new variables.
FORMATS  Time_Cont (F8.2)
    /SPARSEnrollmentWeek(F8.0).
VARIABLE LEVEL  Time_Cont SPARSEnrollmentWeek (SCALE).
VARIABLE WIDTH  Time_Cont(8)
    /SPARSEnrollmentWeek(8).

VARIABLE LABELS  Time_Cont "Amount of time in days that passed between enrollment into SPARS and this observation"
    SPARSEnrollmentWeek "Week enrolled into SPARS"
    Clinic 'Clinic where intervention took place'.

VALUE LABELS Clinic
1 'Ramon Velez'
2 'Clay'
3 'Carlos Pagan'.
EXECUTE.


/*Delete some odd records - these are enrollment forms collected 30 days or more before the client was entered into SPARS*/

FILTER OFF.
USE ALL.
SELECT IF (Time_Cont  > -30).
EXECUTE.

/*Clean up to create analytic dataset with records I trust*/

        /*Limit SPARS time 2 data to that observed within the reassessment window 150-210 days post enrollment, and time 3 occurs within 330 - 390 days*/
        
                /**First step is to remove any data in which time = 2 and time between enrollment and observation is < 150 days.
                FILTER OFF.
                USE ALL.
                DO IF Time = 2.
                SELECT IF NOT (Time_Cont < 150).
                END IF.
                EXECUTE.

                /**If any observations occur in time 2 that are more than 320 days after enrollment, assume they are from time 3 and recode accordingly.
                DO IF (Time = 2 AND Time_Cont > 320).
                RECODE Time (2=3).
                END IF.

                /**If any records from time 2 are greater than 210 days, remove them from the dataset.
                FILTER OFF.
                USE ALL.
                DO IF Time = 2.
                SELECT IF NOT (Time_Cont > 210).
                END IF.
                EXECUTE.

                /** If any records from time 3 are greater than 390 days, remove them from the dataset
                FILTER OFF.
                USE ALL.
                DO IF Time = 3.
                SELECT IF NOT (Time_Cont > 391).
                END IF.
                EXECUTE.

/*Some clients only have 90 days follow up for tracking, so these are not enrollment forms and the time is wrong.*/

                /**If more than 30 days sicne enrollment at T_Time 1 at Clinic 1, assume T_Time should be 2 and recode accordingly.
                DO IF (T_Time = 1 AND Time_Cont > 30 AND Clinic=1).
                RECODE T_Time (1=2).
                END IF.

                /**If Less than 30 days since enrollment at T_Time 2 at clinic 1, assume T_Time should be 1 and recode accordingly.
                DO IF (T_Time = 2 AND Time_Cont < 30 AND Clinic=1).
                RECODE T_Time (2=1).
                END IF.

                /***If any records at T_TIme 2 from clinic 1 are more than 210 days since enrollment, remove them
                FILTER OFF.
                USE ALL.
                DO IF (T_Time = 2 AND Clinic=1).
                SELECT IF NOT (Time_Cont > 210).
                END IF.
                EXECUTE.

                /**If More than 150 days since enrollment at T_Time 2, Clinic 1, Assume T_Time should be 3 and recode accordingly.
                DO IF (T_Time = 2 AND Time_Cont > 150 AND Clinic=1).
                RECODE T_Time (2=3).
                END IF.

                /***If any records from T_Time 2 at clinic 1 are more than 120 days since enrollment, remove them from the dataset.
                FILTER OFF.
                USE ALL.
                DO IF (T_Time = 2  AND Clinic=1).
                SELECT IF NOT (Time_Cont > 120).
                END IF.
                EXECUTE.

                /***If any records from T_Time 3 at clinic 1 are less than 150 days since enrollment, remove them from the dataset
                FILTER OFF.
                USE ALL.
                DO IF (T_Time = 3 AND Clinic=1).
                SELECT IF NOT (Time_Cont < 150).
                END IF.
                EXECUTE.

                /***At clinic 1, T_Time 4 should in fact be T_Time 3.
                DO IF (Clinic=1).
                RECODE T_Time (4=3).
                END IF.
                EXECUTE.

DATASET ACTIVATE PIPBHC_Long.
* Identify Duplicate Cases.
SORT CASES BY Client_ID(A) T_Time(A) ObservationDate(A).
MATCH FILES
  /FILE=*
  /BY Client_ID T_Time
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast1.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence1=1-PrimaryLast1.
ELSE.
COMPUTE  MatchSequence1=MatchSequence1+1.
END IF.
LEAVE  MatchSequence1.
FORMATS  MatchSequence1 (f7).
COMPUTE  InDupGrp=MatchSequence1>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast1 InDupGrp MatchSequence1.

VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.

DO IF InterviewType_07 < 3.
RECODE PrimaryFirst (0=1).
END IF.

FILTER OFF.
USE ALL.
SELECT IF (PrimaryFirst = 1).
EXECUTE.

DELETE VARIABLES PrimaryFirst RecordStatus PrimaryLast MatchSequence.
EXECUTE.

DATASET ACTIVATE PIPBHC_Long.
IF  (T_Time > 0) InterviewType_07=T_Time + 3.
IF  (Time = 3) InterviewType_07=3.
EXECUTE.

VALUE LABELS InterviewType_07
1 'SPARS enrollment'
2 'SPARS 6-month'
3 'SPARS 12-month'
4 'Additional measures enrollment'
5 'Additional measures first follow up'
6 'Additional measures second follow up'.





