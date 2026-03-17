*BREAK-POINT.
DATA : lv_261 TYPE aufm-menge,
       lv_262 TYPE aufm-menge.
""logic for spare components
SELECT matnr , item_type
           FROM mara
           INTO TABLE @DATA(it_matnr)
           WHERE matnr = @wa_gr_item-matnr
           AND item_type = 'S'.
IF it_matnr IS NOT INITIAL.
  lv_header = 'Spare Bill Of Material'.
  SELECT a~mblnr,
       a~zeile,
       a~matnr,
       a~menge,
       a~aufnr,
       a~bwart,
       b~type
 FROM aufm AS a JOIN mara AS b
   ON a~matnr EQ b~matnr
 FOR ALL ENTRIES IN @lt_mseg
 WHERE a~aufnr = @lt_mseg-aufnr
 AND   a~bwart IN ( '261', '262' )
* AND   b~type  IN ( 'FPJ' , 'ATK' )
 INTO TABLE @DATA(Lt_aufm).
ELSE.
  "logic for loose components
  SELECT matnr , item_type
           FROM mara
           INTO TABLE @DATA(it_loose)
           WHERE matnr = @wa_gr_item-matnr
           AND item_type NE 'S'.
  IF it_loose IS NOT INITIAL.
    lv_header = 'Loose Component'.
    SELECT a~mblnr,
       a~zeile,
       a~matnr,
       a~menge,
       a~aufnr,
       a~bwart,
       b~type
 FROM aufm AS a JOIN mara AS b
   ON a~matnr EQ b~matnr
 FOR ALL ENTRIES IN @lt_mseg
 WHERE a~aufnr = @lt_mseg-aufnr
 AND   a~bwart IN ( '261', '262' )
 AND   b~type  IN ( 'FPJ' , 'ATK' )
 INTO TABLE @lt_aufm.
  ENDIF.
ENDIF .
*if lt_aufm is INITIAL.
*  lv_flag = 'X'.
*ENDIF.
DATA: LV_NAME TYPE THEAD-TDNAME.
DATA LT_LINES TYPE TABLE OF TLINE .
DATA LV_LINES TYPE TLINE .
*BREAK-POINT.
READ TABLE gt_gr_item INTO wa_gr_item INDEX 1.
wa_final_1-matnr = wa_gr_item-matnr.
wa_final_1-zeile = wa_gr_item-zeile.
wa_final_1-menge = wa_gr_item-menge_gr.
wa_final_1-maktx = wa_gr_item-maktx.
READ TABLE lt_mseg INTO DATA(wa_mseg) INDEX 1.
wa_final_1-aufnr = wa_mseg-aufnr.

*APPEND wa_final TO it_final.
CLEAR wa_final.
SELECT SINGLE aufnr ,
       gamng
       FROM afko
       INTO @DATA(wa_afko)
       WHERE aufnr = @wa_mseg-aufnr .
  DATA : LV_COUNT TYPE I VALUE IS INITIAL.
  sort lt_aufm by matnr.
LOOP AT lt_aufm INTO DATA(wa_aufm).
   LOOP AT lt_aufm INTO DATA(wa_aufm_new)
      WHERE matnr = wa_aufm-matnr.
      IF wa_aufm_new-bwart EQ '261'.
        lv_261 = wa_aufm_new-menge + lv_261.
      ELSEIF wa_aufm_new-bwart EQ '262'.
        lv_262 = wa_aufm_new-menge + lv_262.
      ENDIF.
    ENDLOOP.
    wa_aufm-menge = lv_261 - lv_262.
  wa_final-matnr = wa_aufm-matnr.
*  at NEW matnr.
*  LV_COUNT = LV_COUNT + 1.
*  wa_final-zeile = wa_aufm-zeile.
  wa_final-menge = wa_aufm-menge / ( wa_afko-gamng / wa_gr_item-menge_gr  ).

  APPEND wa_final TO it_final.
  CLEAR: wa_final,lv_261,lv_262.
ENDLOOP.
*BREAK-POINT.
delete it_final WHERE menge is INITIAL.
delete ADJACENT DUPLICATES FROM it_final COMPARING matnr.
if it_final is INITIAL.
  lv_flag = 'X'.
ENDIF.
loop at it_final INTO wa_final.
  LV_COUNT = LV_COUNT + 1.
  wa_final-zeile = LV_COUNT.
  MODIFY it_final from wa_final.
ENDLOOP.
