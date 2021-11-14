* Encoding: UTF-8.
SORT CASES BY Client_ID InterviewType_07.
CASESTOVARS
  /ID=Client_ID
  /INDEX=InterviewType_07
  /GROUPBY=VARIABLE.

* Date and Time Wizard: YearEnrolled.
COMPUTE YearEnrolled=XDATE.YEAR(SPARSEnrollmentDate).

* Date and Time Wizard: MonthYearEnrolled.
COMPUTE  MonthYearEnrolled=DATE.DMY(1, Month.1, YearEnrolled).

FORMATS YearEnrolled(F8.0)
    /MonthYearEnrolled (MOYR6).

VARIABLE LABELS 
     YearEnrolled "Year client was enrolled into the grant"
     MonthYearEnrolled "Month and year client was enrolled into SPARS".

VARIABLE LEVEL YearEnrolled MonthYearEnrolled(SCALE).

VARIABLE WIDTH YearEnrolled(8) 
    /MonthYearEnrolled(6).
EXECUTE.

