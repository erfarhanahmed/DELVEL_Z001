*----------------------------------------------------------------------*
***INCLUDE LZFI_TRADE_PARTNRF03.
*----------------------------------------------------------------------*
FORM form_save.


if ZFI_TRADE_PARTNR-KUUNR is NOT INITIAL.

  SELECT SINGLE *
    FROM ZFI_TRADE_PARTNR
    WHERE KUUNR = @ZFI_TRADE_PARTNR-KUUNR
    into @data(ls_trade).
  IF sy-subrc eq 0.
    MESSAGE 'Data already exist for Supplier/Customer' TYPE 'E'.
  ENDIF.

ENDIF.

if ZFI_TRADE_PARTNR-LIFNR is NOT INITIAL.

  SELECT SINGLE *
    FROM ZFI_TRADE_PARTNR
    WHERE lifnr = @ZFI_TRADE_PARTNR-lifnr
    into @ls_trade.
  IF sy-subrc eq 0.
    MESSAGE 'Data already exist for Supplier/Customer' TYPE 'E'.
  ENDIF.

ENDIF.

ENDFORM.
