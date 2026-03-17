*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZASN_AUTH.......................................*
DATA:  BEGIN OF STATUS_ZASN_AUTH                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZASN_AUTH                     .
CONTROLS: TCTRL_ZASN_AUTH
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZASN_AUTH                     .
TABLES: ZASN_AUTH                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
