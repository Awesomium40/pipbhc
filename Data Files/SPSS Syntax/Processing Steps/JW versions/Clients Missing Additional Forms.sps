* Encoding: UTF-8.
*Creating a variable for whether or not we've received an additional client information from for a client for Enrollment Forms

DATASET ACTIVATE PIPBHC_Long.
Recode ObservationDate.4 (MISSING=0) into AdditionalClientInfoForm.
EXECUTE.
DO IF (ObservationDate.4 > 0).
Compute AdditionalClientInfoForm = 1.
END IF.
EXECUTE. 

VARIABLE LABELS
AdditionalClientInfoForm 'Additional form received for this client at enrollment'.
VALUE LABELS
AdditionalClientInfoForm
0 'No'
1 'Yes'.
EXECUTE.

DATASET ACTIVATE PIPBHC_Long.
DATASET COPY PIPBHC_temp2.
DATASET ACTIVATE PIPBHC_temp2.
FILTER OFF.
USE ALL.
SELECT IF (AdditionalClientInfoForm = 0).
EXECUTE.

COMPUTE Form_Missing=1.
EXECUTE.

*Creating a variable for whether or not we've received an additional client information from for a client for 3-month Follow-up forms

DATASET ACTIVATE PIPBHC_Long.
DATASET COPY PIPBHC_temp3.
DATASET ACTIVATE PIPBHC_temp3.

Recode ObservationDate.5 (MISSING=0) into AdditionalClientInfoForm3M.
EXECUTE.
DO IF (ObservationDate.5 > 0).
Compute AdditionalClientInfoForm3M= 1.
END IF.
EXECUTE. 

VARIABLE LABELS
AdditionalClientInfoForm3M 'Additional form received for this client first followup'.
VALUE LABELS
AdditionalClientInfoForm3M
0 'No'
1 'Yes'.
EXECUTE.

DATASET ACTIVATE PIPBHC_temp3.
FILTER OFF.
USE ALL.
SELECT IF (AdditionalClientInfoForm3M = 0).
EXECUTE.

DATASET ACTIVATE PIPBHC_temp3.
FILTER OFF.
USE ALL.
SELECT IF (ObservationDate.2 > 0).
EXECUTE.

COMPUTE Form_Missing=2.
EXECUTE.

*Creating a variable for whether or not we've received an additional client information from for a client for 6-month Follow-up forms

DATASET ACTIVATE PIPBHC_Long.
DATASET COPY PIPBHC_temp4.
DATASET ACTIVATE PIPBHC_temp4.

Recode ObservationDate.6 (MISSING=0) into AdditionalClientInfoForm6M.
EXECUTE.
DO IF (ObservationDate.6 > 0).
Compute AdditionalClientInfoForm6M= 1.
END IF.
EXECUTE. 

VARIABLE LABELS
AdditionalClientInfoForm6M 'Additional form received for this client second followup'.
VALUE LABELS
AdditionalClientInfoForm6M
0 'No'
1 'Yes'.
EXECUTE.

DATASET ACTIVATE PIPBHC_temp4.
FILTER OFF.
USE ALL.
SELECT IF (AdditionalClientInfoForm6M = 0).
EXECUTE.

DATASET ACTIVATE PIPBHC_temp4.
FILTER OFF.
USE ALL.
SELECT IF (ObservationDate.3 > 0).
EXECUTE.

COMPUTE Form_Missing=3.
EXECUTE.

/*****merge files together into one spreadsheet*

DATASET ACTIVATE PIPBHC_temp2.
ADD FILES /FILE=*
  /FILE='PIPBHC_temp3'
  /RENAME (AdditionalClientInfoForm3M=d0)
  /DROP=d0.
EXECUTE.

DATASET ACTIVATE PIPBHC_temp2. 
ADD FILES /FILE=* 
  /FILE='PIPBHC_temp4' 
  /RENAME (AdditionalClientInfoForm6M=d0) 
  /DROP=d0. 
EXECUTE.

DATASET ACTIVATE PIPBHC_temp2. 
VALUE LABELS Form_Missing
                     1 'Enrollment'
                     2 '3-Month Re-assessment'
                     3 '6-Month Re-assessment'.
                   EXECUTE.

DATASET ACTIVATE PIPBHC_temp2. 
FILTER OFF.
USE ALL.
SELECT IF (Clinic >= 2).
EXECUTE.
DATASET ACTIVATE PIPBHC_temp2. 
SAVE TRANSLATE OUTFILE='\\casa.casacolumbia.org\Shares\Treatment\SAMHSA PIPBHC Secure\Additional Client Information Forms\Clients_Without_Additional_Forms.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE
  /Keep=Client_ID  Form_Missing ObservationDate.1 ObservationDate.2 ObservationDate.3
  /rename ObservationDate.1=Enrollment_Date ObservationDate.2=Reassessment3M_Date ObservationDate.3=Reassessment6M_Date.
USE ALL.

DATASET CLOSE PIPBHC_temp2.
DATASET CLOSE PIPBHC_temp3.
DATASET CLOSE PIPBHC_temp4.
