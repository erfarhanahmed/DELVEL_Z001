*BREAK primusabap.
  SELECT a~VENUM,a~EXIDV,A~VHILM_KU,b~MATNR
    FROM vekp as a INNER JOIN vepo as b
    on a~VENUM eq b~VENUM
    WHERE b~VBELN = @wa_vepo-vbeln
    AND   B~POSNR = @WA_final-posnv
    INTO TABLE @DATA(it_vekp).

IF wa_final-item_type NE 'FPJ' OR wa_final-item_type NE 'ATK'.
  READ TABLE it_vekp INTO DATA(wa_vekp) WITH KEY matnr = wa_final-matnr.
  IF sy-subrc = 0.
    wa_final-vhilm_ku = wa_vekp-vhilm_ku.
  ENDIF.
ENDIF.

































