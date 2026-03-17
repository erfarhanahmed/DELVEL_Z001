*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFI_TRADE_PARTNR................................*
DATA:  BEGIN OF STATUS_ZFI_TRADE_PARTNR              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFI_TRADE_PARTNR              .
CONTROLS: TCTRL_ZFI_TRADE_PARTNR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFI_TRADE_PARTNR              .
TABLES: ZFI_TRADE_PARTNR               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
