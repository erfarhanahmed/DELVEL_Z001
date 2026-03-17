*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLDREQUIRED.....................................*
DATA:  BEGIN OF STATUS_ZLDREQUIRED                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLDREQUIRED                   .
CONTROLS: TCTRL_ZLDREQUIRED
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLDREQUIRED                   .
TABLES: ZLDREQUIRED                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
