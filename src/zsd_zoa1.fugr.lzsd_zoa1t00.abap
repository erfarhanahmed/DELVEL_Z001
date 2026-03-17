*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSD_ZOA1........................................*
DATA:  BEGIN OF STATUS_ZSD_ZOA1                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSD_ZOA1                      .
CONTROLS: TCTRL_ZSD_ZOA1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSD_ZOA1                      .
TABLES: ZSD_ZOA1                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
