* Encoding: windows-1252.
SORT CASES BY Client_ID InterviewType_07.
CASESTOVARS
  /ID=Client_ID
  /INDEX=InterviewType_07
  /GROUPBY=VARIABLE.

* Date and Time Wizard: YearEnrolled.
COMPUTE YearEnrolled=XDATE.YEAR(SPARSEnrollmentDate).
VARIABLE LABELS YearEnrolled "Year client was enrolled into the grant".
VARIABLE LEVEL YearEnrolled(SCALE).
FORMATS YearEnrolled(F8.0).
VARIABLE WIDTH YearEnrolled(8).
EXECUTE.

* Date and Time Wizard: MonthYearEnrolled.
COMPUTE  MonthYearEnrolled=DATE.DMY(1, Month.1, YearEnrolled).
VARIABLE LABELS  MonthYearEnrolled "Month and year client was enrolled into SPARS".
VARIABLE LEVEL  MonthYearEnrolled (SCALE).
FORMATS  MonthYearEnrolled (MOYR6).
VARIABLE WIDTH  MonthYearEnrolled(6).
EXECUTE.

