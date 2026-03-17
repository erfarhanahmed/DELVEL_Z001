*BREAK primusabap.
IF IT_MATNR IS NOT INITIAL.
  IF WA_MATNR-VHILM_KU IS NOT INITIAL.
    CLEAR : lv_sr .
  ENDIF.
  IF wa_matnr-item_type NE 'S'  .
    lv_sr = lv_sr + 1.
    wa_matnr-sr_no = lv_sr.
  ENDIF.
  ENDIF.














