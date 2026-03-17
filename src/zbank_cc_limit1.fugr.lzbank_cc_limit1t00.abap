*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBANK_CC_LIMIT1.................................*
DATA:  BEGIN OF STATUS_ZBANK_CC_LIMIT1               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBANK_CC_LIMIT1               .
CONTROLS: TCTRL_ZBANK_CC_LIMIT1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZBANK_CC_LIMIT1               .
TABLES: ZBANK_CC_LIMIT1                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
