*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBANK_SCOPE.....................................*
DATA:  BEGIN OF STATUS_ZBANK_SCOPE                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBANK_SCOPE                   .
CONTROLS: TCTRL_ZBANK_SCOPE
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZBANK_SCOPE                   .
TABLES: ZBANK_SCOPE                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
