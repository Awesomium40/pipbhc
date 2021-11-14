* Encoding: UTF-8.
/***CREATE LISTS OF VARIABLES CONTAINING THE ObservationDate VARS
/***IF THE VARIABLES DON'T EXIST, THESE LISTS WILL BE EMPTY.
SPSSINC SELECT VARIABLES MACRONAME="!OD3" 
     /PROPERTIES  PATTERN = "ObservationDate.3".

SPSSINC SELECT VARIABLES MACRONAME="!OD4" 
     /PROPERTIES  PATTERN = "ObservationDate.4".

SPSSINC SELECT VARIABLES MACRONAME="!OD5" 
     /PROPERTIES  PATTERN = "ObservationDate.5".


/***THE FOLLOWING MACRO WORKS IN CONCERT WITH THE ABOVE SPSSINC STATEMENTS
/***TOGETHER, THEY ONLY COMPUTE THE ClientReassessedxM VARS IF THE CORRESPONDING
/***ObservationDate.x VAR EXISTS.
DEFINE ComputeClientReassessedVars ()
!if (!eval(!OD3)<>"") !then
  DATASET ACTIVATE PIPBHC_Long.
  RECODE ObservationDate.3 (MISSING=0) into ClientReassessed6M.
  EXECUTE.
  DO IF (ObservationDate.3 >0).
  COMPUTE ClientReassessed6M = 1.
  END IF.
  EXECUTE.
  
  VARIABLE LABELS ClientReassessed6M 'Has the six-month reassessment for this client been completed?'.
  VALUE LABELS
  ClientReassessed6M 0 ' No' 1 'Yes'.
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

  VARIABLE LABELS ClientReassessed9M 'Has the nine-month reassessment for this client been completed?'.
  VALUE LABELS ClientReassessed9M 0 ' No' 1 'Yes'.
  EXECUTE.
!ifend

!if (!eval(!OD5)<>"") !then
  DATASET ACTIVATE PIPBHC_Long.
  RECODE ObservationDate.5 (MISSING=0) into ClientReassessed12M.
  EXECUTE.
  DO IF (ObservationDate.5 >0).
  COMPUTE ClientReassessed12M = 1.
  END IF.
  EXECUTE.

  VARIABLE LABELS ClientReassessed12M 'Has the twelve-month reassessment for this client been completed?'.
  VALUE LABELS ClientReassessed12M 0 ' No' 1 'Yes'.
  EXECUTE.
!ifend
!ENDDEFINE.

/***THIS ACTUALLY EXECUTES THE MACRO DEFINED ABOVE.
ComputeClientReassessedVars.

/***ONCE THE VARS ARE COMPUTED, THE VARIABLE LISTS ARE NO LONGER NECESSARY, SO CLEAR THEM.
DEFINE !OD3() !ENDDEFINE.
DEFINE !OD4() !ENDDEFINE.
DEFINE !OD5() !ENDDEFINE.
