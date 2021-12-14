* Encoding: UTF-8.


/**********UPDATE FILE HANDLE FOR THE ROOT FOLDER BELOW BEFORE RUNNING THIS SYNTAX************************/.
*FILE HANDLE rootFolder /NAME='\\casa.casacolumbia.org'.
/******************For JWW Laptop**************************/.
/*FILE HANDLE rootFolder /NAME='D:\DropBox\ptea'.

/******************For JWW PC**************************/.
FILE HANDLE rootFolder /NAME='D:\SyncThing\ptea'.
FILE HANDLE pipbhc /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\Excel Files\Data Downloads\PIPBHC Data Download 12.10.21.xlsx'.
FILE HANDLE procStepFolder /NAME='rootFolder\Shares\Treatment\SAMHSA PIPBHC Secure\Data Files\SPSS Syntax\Data Processing Steps'.


GET DATA
  /TYPE=XLSX
  /FILE="pipbhc"
   /CELLRANGE=FULL
  /READNAMES=ON
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME FullData.

CD "procStepFolder".
INSERT FILE ='procStepFolder\STEP 1 - Open Data and Label Variables and Values.sps'.
INSERT FILE ='procStepFolder\STEP 2 - Recode Variables and Create Scales.sps'.
INSERT FILE ='procStepFolder\STEP 3 - Create SPARS Enrollment, FollowUp, and Discharge Datasets.sps'.
INSERT FILE ='procStepFolder\STEP 4 - Create Enrollment Form and Tracking Form datasets.sps'.

INSERT FILE ='procStepFolder\STEP 5 - Clean up data.sps'.

INSERT FILE ='procStepFolder\STEP 6 - Restructure Data from Long to Wide.sps'.

*INSERT FILE ='STEP 7 - Create additional variables.sps'.
INSERT FILE ='procStepFolder\STEP 7b - Create additional variables - Carlos Pagan only.sps'.

/*THIS STEP UPDATES THE DATA FOR THE PIPBHC WEEKLY AND MONTHLY DASHBOARD*/

INSERT FILE ='procStepFolder\Export for PowerBI Dashboards.sps'.

/*THIS STEP CREATES SPREADSHEET OF CLIENTS DUE FOR REASSESSMENT**************************/

INSERT FILE ='procStepFolder\Due for Reassessment.sps'.

/*THIS STEP CREATES SPREADSHEET OF CLIENTS WITHOUT ADDITIONAL INFO FORMS***************/

INSERT FILE ='Clients Missing Additional Forms.sps'.
