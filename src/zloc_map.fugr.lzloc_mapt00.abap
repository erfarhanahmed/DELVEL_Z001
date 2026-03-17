*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLOC_MAP........................................*
DATA:  BEGIN OF STATUS_ZLOC_MAP                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLOC_MAP                      .
CONTROLS: TCTRL_ZLOC_MAP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZLOC_MAP                      .
TABLES: ZLOC_MAP                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
