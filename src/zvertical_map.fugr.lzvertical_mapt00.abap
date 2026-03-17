*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVERTICAL_MAP...................................*
DATA:  BEGIN OF STATUS_ZVERTICAL_MAP                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVERTICAL_MAP                 .
CONTROLS: TCTRL_ZVERTICAL_MAP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZVERTICAL_MAP                 .
TABLES: ZVERTICAL_MAP                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
