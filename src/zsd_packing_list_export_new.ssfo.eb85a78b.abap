DATA :
       lv_261_1 TYPE aufm-menge,
       lv_262_1 TYPE aufm-menge.

TYPES : BEGIN OF t_mat_lips,
          vemng TYPE vepo-vemng,
        END OF t_mat_lips.
DATA gv_qty_1 TYPE aufm-menge.
CLEAR gv_qty_1.
DATA : wa_mat_lips_loose TYPE t_mat_lips.
*break primusabap.

IF wa_final-type NE 'FPJ' AND wa_final-type NE 'ATK'.

  SELECT SINGLE vemng FROM vepo INTO wa_mat_lips_loose
    WHERE matnr = wa_final-matnr
  AND vbeln = wa_vepo-vbeln
  AND posnr = wa_final-posnv.

  IF sy-subrc IS INITIAL.
    wa_final-menge = wa_mat_lips_loose-vemng   .
    gv_qty_1 = wa_final-menge.
  ENDIF.
ENDIF.
DATA : gv_wemng TYPE afpo-wemng.
*BREAK primusabap.

* IF it_loose IS NOT INITIAL .

  SELECT mblnr,
         aufnr,
         kdauf,
         kdpos,
         bwart
  FROM aufm
*  FOR ALL ENTRIES IN @it_loose
  WHERE kdauf = @WA_final-vbelv
  AND   kdpos = @wa_final-posnv
  AND   bwart EQ '101'
  INTO TABLE @DATA(it_aufm_new_101).
if it_aufm_new_101 is NOT INITIAL.
  SELECT A~mblnr,
        A~zeile,
        A~matnr,
        A~menge,
        A~aufnr,
        A~bwart,
        b~type
  FROM aufm AS A JOIN mara AS B
    ON A~Matnr eq b~matnr
  FOR ALL ENTRIES IN @it_aufm_new_101
  WHERE A~aufnr = @it_aufm_new_101-aufnr
  AND   A~bwart IN ( '261', '262' )
  AND   B~TYPE  IN ( 'FPJ' , 'ATK' )
  INTO TABLE @DATA(it_aufm_new_261).
endif.
if it_aufm_new_101 is NOT INITIAL.
IF wa_final-type EQ 'FPJ' OR wa_final-type EQ 'ATK'.

  READ TABLE it_loose INTO DATA(wa_1) WITH KEY
                                              vbelv = wa_final-vbelv
                                              posnv = wa_final-posnv.
  IF sy-subrc IS INITIAL.
    gv_qty_1 = wa_1-lfimg.
  ENDIF.

  SORT it_aufm_new_261 by matnr.
  sort it_aufm_new_101 by aufnr.
  delete ADJACENT DUPLICATES FROM it_aufm_new_101 COMPARING aufnr.
  LOOP AT it_aufm_new_101 INTO DATA(wa_aufm_101) where  kdauf = wa_final-vbelv
                                            and  kdpos = wa_final-posnv..
    LOOP AT it_aufm_new_261 INTO DATA(wa_aufm_261) WHERE MATNR = WA_FINAL-MATNR
      AND aufnr = wa_aufm_101-aufnr .

     IF wa_aufm_261-bwart EQ '261'.
        lv_261_1 = wa_aufm_261-menge + lv_261_1.
      ELSEIF wa_aufm_261-bwart EQ '262'.
        lv_262_1 = wa_aufm_261-menge + lv_262_1.
      ENDIF.

    ENDLOOP.

  ENDLOOP.

    lv_menge = lv_261_1 - lv_262_1.

  SELECT SUM( wemng )" AS GV_PSMNG
    FROM afpo
    INTO gv_wemng
    WHERE kdauf = wa_final-vbelv
    AND kdpos = wa_final-posnv
    AND MATNR = wa_1-MATNR.
  lv_menge = ( gv_qty_1 *  lv_menge ) / gv_wemng.

ENDIF.
ENDIF.
CLEAR :lv_261_1,lv_262_1.
