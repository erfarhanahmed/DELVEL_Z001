DATA : lv_261 TYPE aufm-menge,
       lv_262 TYPE aufm-menge.

TYPES : BEGIN OF t_mat_lips,
          vemng TYPE vepo-vemng,
        END OF t_mat_lips.

DATA : wa_mat_lips TYPE t_mat_lips.

*BREAK PRIMUSABAP.
IF WA_MATNR-ITEM_TYPE = 'S'.

    SELECT SINGLE vemng FROM vepo INTO wa_mat_lips
    WHERE matnr = wa_matnr-matnr
  AND vbeln = wa_vepo-vbeln
  AND posnr = wa_matnr-posnv.

*  SELECT SINGLE LFIMG
*FROM lips
*INTO wa_mat_lips
*WHERE MATNR = wa_MATNR-MATNR
*    AND VBELN = wa_vepo-vbeln.

  IF SY-SUBRC IS INITIAL.
    WA_MATNR-MENGE = wa_mat_lips-vemng .
    DATA(GV_QTY) = WA_MATNR-MENGE.
  ENDIF.
ENDIF.
DATA : GV_wemng_1 TYPE AFPO-wemng.
IF WA_MATNR-ITEM_TYPE NE 'S'.
  READ TABLE IT_MATNR INTO DATA(WA) WITH KEY ITEM_TYPE = 'S'
                                              VBELV = WA_MATNR-VBELV
                                              POSNV = WA_MATNR-POSNV.
  IF SY-SUBRC IS INITIAL.
    GV_QTY = WA-LFIMG.
  ENDIF.

   SELECT mblnr,
         aufnr,
         kdauf,
         kdpos,
         bwart
    FROM aufm
*    FOR ALL ENTRIES IN @it_matnr
    WHERE kdauf = @wa_matnr-vbelv
    AND   kdpos = @wa_matnr-posnv
    AND   bwart EQ '101'
    INTO TABLE @DATA(it_aufm_101).
IF it_aufm_101 IS NOT INITIAL.
  SELECT mblnr,
         zeile,
         matnr,
         menge,
         aufnr,
         bwart
    FROM aufm
    FOR ALL ENTRIES IN @it_aufm_101
    WHERE aufnr = @it_aufm_101-aufnr
    AND   bwart IN ( '261', '262' )
    INTO TABLE @DATA(it_aufm_261).
ENDIF.
    SORT it_aufm_261 by matnr.
    sort it_aufm_101 by aufnr.
  delete ADJACENT DUPLICATES FROM it_aufm_101  COMPARING aufnr.
IF it_aufm_101 IS NOT INITIAL.
  LOOP AT it_aufm_101 INTO DATA(wa_aufm_101) where  kdauf = wa_matnr-vbelv
                                            and  kdpos = wa_matnr-posnv..
    LOOP AT it_aufm_261 INTO DATA(wa_aufm_261) WHERE MATNR = wa_matnr-MATNR
      AND aufnr = wa_aufm_101-aufnr .

     IF wa_aufm_261-bwart EQ '261'.
        lv_261 = wa_aufm_261-menge + lv_261.
      ELSEIF wa_aufm_261-bwart EQ '262'.
        lv_262 = wa_aufm_261-menge + lv_262.
      ENDIF.

    ENDLOOP.

  ENDLOOP.


    lv_menge_1 = lv_261 - lv_262.

  SELECT SUM( wemng )" AS GV_PSMNG
    FROM AFPO
    INTO GV_wemng_1
    WHERE KDAUF = WA_MATNR-VBELV
    AND KDPOS = WA_MATNR-POSNV
    and matnr = wa-matnr.
  lv_menge_1 = ( GV_QTY *  lv_menge_1 ) / GV_wemng_1.
ENDIF.
ENDIF.
CLEAR :lv_261 ,lv_262.

