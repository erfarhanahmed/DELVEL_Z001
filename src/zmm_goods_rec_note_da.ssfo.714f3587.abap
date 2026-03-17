
if WA_MSEG-EBELN is NOT INITIAL.
  select single zgreen_fld
    from ekpo
    INTO @DATA(gv_zgreen_fld1)
    where ebeln = @WA_MSEG-EBELN.
    IF gv_zgreen_fld1 = 'YES'.
    gv_zgreen_fld = 'GREEN SUPPLY'.
    ELSE.
      CLEAR :gv_zgreen_fld.
    ENDIF.

endif.





















