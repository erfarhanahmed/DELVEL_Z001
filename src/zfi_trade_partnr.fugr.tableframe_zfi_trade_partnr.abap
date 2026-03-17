*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZFI_TRADE_PARTNR
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZFI_TRADE_PARTNR   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
