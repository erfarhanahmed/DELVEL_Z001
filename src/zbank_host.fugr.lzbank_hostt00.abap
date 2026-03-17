*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBANK_HOST......................................*
DATA:  BEGIN OF STATUS_ZBANK_HOST                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBANK_HOST                    .
CONTROLS: TCTRL_ZBANK_HOST
            TYPE TABLEVIEW USING SCREEN '9000'.
*.........table declarations:.................................*
TABLES: *ZBANK_HOST                    .
TABLES: ZBANK_HOST                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
