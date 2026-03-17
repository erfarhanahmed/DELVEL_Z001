DATA : lv_261 TYPE aufm-menge,
       lv_262 TYPE aufm-menge,
       lv_261_1 TYPE aufm-menge,
       lv_262_1 TYPE aufm-menge.

SELECT       b~lfimg
             b~brgew
             b~ntgew AS menge
             b~vbelv
             b~posnv
             a~matnr
             a~item_type
             a~type
             c~maktx
             FROM lips AS b
             JOIN mara AS a ON ( a~matnr = b~matnr )
             INNER JOIN makt AS c
             ON ( c~matnr = b~matnr )
             INTO TABLE it_matnr
             WHERE b~vbeln = wa_vepo-vbeln
             AND a~item_type = 'S'
             AND c~spras EQ 'E'.

IF it_matnr IS NOT INITIAL.

  SELECT a~venum,a~exidv,a~vhilm_ku,b~matnr
    FROM vekp AS a INNER JOIN vepo AS b
    ON a~venum EQ b~venum
    WHERE b~vbeln = @wa_vepo-vbeln
    INTO TABLE @DATA(it_vekp).

  SELECT mblnr,
         aufnr,
         kdauf,
         kdpos,
         bwart
    FROM aufm
    FOR ALL ENTRIES IN @it_matnr
    WHERE kdauf = @it_matnr-vbelv
    AND   kdpos = @it_matnr-posnv
    AND   bwart EQ '101'
    INTO TABLE @DATA(it_aufm_101).

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

  SELECT matnr,
       spras,
       maktx
  FROM makt FOR ALL ENTRIES IN @it_aufm_261
  WHERE matnr = @it_aufm_261-matnr
  AND  spras = 'E'
  INTO TABLE @DATA(it_makt).

  SORT it_aufm_261 BY aufnr matnr bwart.
  LOOP AT it_aufm_261 INTO DATA(wa_aufm_261).

    LOOP AT it_aufm_261 INTO DATA(wa_aufm_new)
      WHERE matnr = wa_aufm_261-matnr.
      IF wa_aufm_new-bwart EQ '261'.
        lv_261 = wa_aufm_new-menge + lv_261.
      ELSEIF wa_aufm_new-bwart EQ '262'.
        lv_262 = wa_aufm_new-menge + lv_262.
      ENDIF.
    ENDLOOP.

    wa_matnr-aufnr = wa_aufm_new-aufnr.
    wa_matnr-matnr = wa_aufm_new-matnr.
    wa_matnr-menge = lv_261 - lv_262.



    READ TABLE it_aufm_101 INTO DATA(wa_aufm_101) WITH KEY aufnr = wa_aufm_261-aufnr.
    IF sy-subrc = 0.
      wa_matnr-vbelv = wa_aufm_101-kdauf.
      wa_matnr-posnv = wa_aufm_101-kdpos.
    ENDIF.

    READ TABLE it_makt INTO DATA(wa_makt) WITH KEY matnr = wa_matnr-matnr.
    IF sy-subrc = 0.
      wa_matnr-maktx = wa_makt-maktx .
    ENDIF.

*  SHIFT wa_matnr-posnv LEFT DELETING LEADING '0'.
    IF wa_matnr-menge IS NOT INITIAL.
      APPEND wa_matnr TO it_matnr.
    ENDIF.
    CLEAR :wa_matnr,lv_261,lv_262,wa_aufm_new,wa_aufm_261.
  ENDLOOP.

  SORT it_matnr .
  DELETE ADJACENT DUPLICATES FROM it_matnr COMPARING matnr.
  SORT it_matnr BY vbelv posnv item_type DESCENDING.

ENDIF.

BREAK primusabap.
""logic for loose components
SELECT     b~lfimg
           b~brgew
           b~ntgew AS menge
           b~vbelv
           b~posnv
           a~matnr
           a~item_type
           a~type
           c~maktx
           FROM lips AS b
           JOIN mara AS a ON ( a~matnr = b~matnr )
           INNER JOIN makt AS c
           ON ( c~matnr = b~matnr )
           INTO TABLE it_loose
*           INTO TABLE @DATA(it_loose)
           WHERE b~vbeln = wa_vepo-vbeln
           AND a~item_type NE 'S'
           AND c~spras EQ 'E'.

IF it_loose IS NOT INITIAL .

  SELECT mblnr,
         aufnr,
         kdauf,
         kdpos,
         bwart
  FROM aufm
  FOR ALL ENTRIES IN @it_loose
  WHERE kdauf = @it_loose-vbelv
  AND   kdpos = @it_loose-posnv
  AND   bwart EQ '101'
  INTO TABLE @DATA(it_aufm_new_101).

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

  SELECT matnr,
         spras,
         maktx
  FROM makt FOR ALL ENTRIES IN @it_aufm_new_261
  WHERE matnr = @it_aufm_new_261-matnr
  AND  spras = 'E'
  INTO TABLE @DATA(it_makt_new).

    LOOP AT it_aufm_new_261 INTO DATA(wa_aufm_new_261).

        LOOP AT it_aufm_new_261 INTO DATA(wa_aufm_new1)
      WHERE matnr = wa_aufm_new_261-matnr.
      IF wa_aufm_new1-bwart EQ '261'.
        lv_261_1 = wa_aufm_new1-menge + lv_261_1.
      ELSEIF wa_aufm_new1-bwart EQ '262'.
        lv_262_1 = wa_aufm_new1-menge + lv_262_1.
      ENDIF.
    ENDLOOP.
    wa_final-aufnr = wa_aufm_new1-aufnr.
    wa_final-matnr = wa_aufm_new1-matnr.
    wa_final-type = wa_aufm_new_261-type.
    wa_final-menge = lv_261_1 - lv_262_1.



    READ TABLE it_aufm_new_101 INTO DATA(wa_aufm_new_101) WITH KEY aufnr = wa_aufm_new1-aufnr.
    IF sy-subrc = 0.
      wa_final-vbelv = wa_aufm_new_101-kdauf.
      wa_final-posnv = wa_aufm_new_101-kdpos.
    ENDIF.

    READ TABLE it_makt_new INTO DATA(wa_makt_new) WITH KEY matnr = wa_final-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = wa_makt_new-maktx .
    ENDIF.

*  SHIFT wa_matnr-posnv LEFT DELETING LEADING '0'.
    IF wa_final-menge IS NOT INITIAL.
      APPEND wa_final TO it_loose.
    ENDIF.
    CLEAR :wa_final,lv_261_1,lv_262_1,wa_aufm_new_101,wa_aufm_new_261.

    endloop.
SORT it_loose.
  DELETE ADJACENT DUPLICATES FROM it_loose COMPARING matnr.
  SORT it_loose BY vbelv posnv item_type DESCENDING.

ENDIF.
