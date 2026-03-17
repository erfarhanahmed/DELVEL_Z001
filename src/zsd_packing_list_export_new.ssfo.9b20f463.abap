*break primusabap.
IF IT_LOOSE IS NOT INITIAL.

  IF WA_FINAL-VHILM_KU IS NOT INITIAL.
    CLEAR : lv_sr .
  ENDIF.
  IF wa_FINAL-Type EQ 'FPJ' OR wa_FINAL-Type EQ 'ATK' .
    lv_sr = lv_sr + 1.
    wa_FINAL-sr_no = lv_sr.
  ENDIF.
  ENDIF.






















