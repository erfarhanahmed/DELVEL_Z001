*&---------------------------------------------------------------------*
*& Report ZOPEN_PR_COUNT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zopen_pr_count.

TABLES: t024,
        t001,
        t001w,
        t001l,
        eban,
        zvertical_map.

TYPES: BEGIN OF ty_final,
         estkz TYPE estkz,
         jan   TYPE i,
         feb   TYPE i,
         mar   TYPE i,
         apr   TYPE i,
         may   TYPE i,
         jun   TYPE i,
         jul   TYPE i,
         aug   TYPE i,
         sep   TYPE i,
         oct   TYPE i,
         nov   TYPE i,
         dec   TYPE i,
         total TYPE i,
       END OF ty_final.


DATA: it_eban  TYPE TABLE OF eban,
      wa_eban  TYPE eban,
      it_final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.

DATA: s_badat TYPE RANGE OF eban-badat WITH HEADER LINE.

DATA: it_vertical_map TYPE TABLE OF zvertical_map.

DATA: lv_mon TYPE char2.

DATA: it_fieldcat TYPE TABLE OF slis_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : s_ekgrp FOR t024-ekgrp OBLIGATORY,
                   s_vname FOR zvertical_map-vname OBLIGATORY,
                   s_bukrs FOR t001-bukrs,
                   s_werks FOR t001w-werks OBLIGATORY,
                   s_lgort FOR t001l-lgort.
  PARAMETERS : p_year TYPE char4 OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK b1.

AT SELECTION-SCREEN.

  SELECT * FROM t001k
    INTO TABLE @DATA(it_t001k)
    WHERE bwkey IN @s_werks.

  SELECT bukrs FROM t001
    INTO TABLE @DATA(it_t001)
    WHERE bukrs IN @s_bukrs.

  IF s_werks[] IS NOT INITIAL AND s_bukrs[] IS NOT INITIAL.
    LOOP AT it_t001 INTO DATA(wa_t001).

      IF it_t001k IS INITIAL.
        MESSAGE | Plant { s_werks-low } is not assosiated with Company code { wa_t001-bukrs } | TYPE 'E'.
      ELSE.
        LOOP AT it_t001k INTO DATA(wa_t001k).

          IF wa_t001k-bukrs NE wa_t001-bukrs.
            MESSAGE | Plant { wa_t001k-bwkey } is not assosiated with Company code { wa_t001-bukrs } | TYPE 'E'.
          ENDIF.

        ENDLOOP.
      ENDIF.

    ENDLOOP.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_vname-low.
  PERFORM vname.

START-OF-SELECTION.

  SELECT * FROM zvertical_map
    INTO TABLE it_vertical_map
    WHERE ekgrp IN s_ekgrp
    AND vname IN s_vname.

  IF it_vertical_map IS NOT INITIAL.
    s_badat-sign = 'I'.
    s_badat-option = 'BT'.
    s_badat-low = |{ p_year }0401|.

    s_badat-high = |{ p_year + 1 }0331|.
    APPEND s_badat TO s_badat[].

    SELECT * FROM eban
      INTO TABLE it_eban
      FOR ALL ENTRIES IN it_vertical_map
      WHERE ekgrp = it_vertical_map-ekgrp
      AND werks IN s_werks
      AND lgort IN s_lgort
      AND badat IN s_badat
      AND loekz NE 'X'
      AND EBAKZ NE 'X'.
      "AND extcompanycodeforpurg IN s_bukrs
      "AND STATU EQ 'N'

  ENDIF.

  wa_final-estkz = 'B'.
  APPEND wa_final TO it_final.
  wa_final-estkz = 'R'.
  APPEND wa_final TO it_final.
  wa_final-estkz = 'U'.
  APPEND wa_final TO it_final.

  LOOP AT it_eban INTO wa_eban.

    IF wa_eban-menge NE wa_eban-bsmng.

      READ TABLE it_final INTO wa_final WITH KEY estkz = wa_eban-estkz.

      IF sy-subrc EQ 0.
        lv_mon = wa_eban-badat+4(2).

        CASE lv_mon.
          WHEN '01'.
            wa_final-jan = wa_final-jan + 1.
          WHEN '02'.
            wa_final-feb = wa_final-feb + 1.
          WHEN '03'.
            wa_final-mar = wa_final-mar + 1.
          WHEN '04'.
            wa_final-apr = wa_final-apr + 1.
          WHEN '05'.
            wa_final-may = wa_final-may + 1.
          WHEN '06'.
            wa_final-jun = wa_final-jun + 1.
          WHEN '07'.
            wa_final-jul = wa_final-jul + 1.
          WHEN '08'.
            wa_final-aug = wa_final-aug + 1.
          WHEN '09'.
            wa_final-sep = wa_final-sep + 1.
          WHEN '10'.
            wa_final-oct = wa_final-oct + 1.
          WHEN '11'.
            wa_final-nov = wa_final-nov + 1.
          WHEN '12'.
            wa_final-dec = wa_final-dec + 1.
        ENDCASE.

        wa_final-total = wa_final-jan + wa_final-feb + wa_final-mar + wa_final-apr + wa_final-may + wa_final-jun +
                         wa_final-jul + wa_final-aug + wa_final-sep + wa_final-oct + wa_final-nov + wa_final-dec.

        MODIFY it_final FROM wa_final INDEX sy-tabix.
      ENDIF.

    ENDIF.

    CLEAR: wa_final.
  ENDLOOP.

  wa_fieldcat-fieldname = 'ESTKZ'.
  wa_fieldcat-seltext_m   = 'Creation Indicator'.
  wa_fieldcat-outputlen = 15.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname = 'APR'.
  wa_fieldcat-seltext_m   = |APR-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MAY'.
  wa_fieldcat-seltext_m   = |MAY-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'JUN'.
  wa_fieldcat-seltext_m   = |JUN-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'JUL'.
  wa_fieldcat-seltext_m   = |JUL-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'AUG'.
  wa_fieldcat-seltext_m   = |AUG-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SEP'.
  wa_fieldcat-seltext_m   = |SEP-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'OCT'.
  wa_fieldcat-seltext_m   = |OCT-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'NOV'.
  wa_fieldcat-seltext_m   = |NOV-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'DEC'.
  wa_fieldcat-seltext_m   = |DEC-{ p_year }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'JAN'.
  wa_fieldcat-seltext_m   = |JAN-{ p_year + 1 }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'FEB'.
  wa_fieldcat-seltext_m   = |FEB-{ p_year + 1 }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MAR'.
  wa_fieldcat-seltext_m   = |MAR-{ p_year + 1 }|.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname = 'TOTAL'.
  wa_fieldcat-seltext_m   = 'Grand Total'.
  wa_fieldcat-outputlen = 10.
  wa_fieldcat-do_sum     = 'X'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


FORM vname.

  SELECT * FROM zvertical_map
    INTO TABLE @DATA(it_map).

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield         = 'VNAME'
      dynpprog         = sy-repid
      dynpnr           = sy-dynnr
      dynprofield      = 'S_VNAME-LOW'
      value_org        = 'S'
      callback_program = sy-repid
    TABLES
      value_tab        = it_map.

ENDFORM.
