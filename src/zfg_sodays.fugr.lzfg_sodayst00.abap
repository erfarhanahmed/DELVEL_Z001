*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSALES_SHORTAGE.................................*
DATA:  BEGIN OF STATUS_ZSALES_SHORTAGE               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSALES_SHORTAGE               .
CONTROLS: TCTRL_ZSALES_SHORTAGE
            TYPE TABLEVIEW USING SCREEN '0102'.
*.........table declarations:.................................*
TABLES: *ZSALES_SHORTAGE               .
TABLES: ZSALES_SHORTAGE                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
