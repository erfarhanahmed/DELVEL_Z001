  SELECT a~VENUM,a~EXIDV,A~VHILM_KU,b~MATNR
    FROM vekp as a INNER JOIN vepo as b
    on a~VENUM eq b~VENUM
    WHERE b~VBELN = @wa_vepo-vbeln
    AND   B~POSNR = @WA_matnr-posnv
    INTO TABLE @DATA(it_vekp).

IF wa_matnr-item_type = 'S'.
  READ TABLE it_vekp INTO DATA(wa_vekp) WITH KEY matnr = wa_matnr-matnr.
  IF sy-subrc = 0.
    wa_matnr-vhilm_ku = wa_vekp-vhilm_ku.
  ENDIF.
ENDIF.

















