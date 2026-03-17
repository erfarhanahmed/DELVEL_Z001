*&---------------------------------------------------------------------*
*& Report YCK_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_0018.

*TABLES: ekpo , ziverticalmap, ekko.
DATA : lv_ekgrp TYPE ekko-ekgrp,
       lv_vname TYPE ziverticalmap-vname,
       lv_werks TYPE ekpo-werks.
DATA lv_end .


TYPES: BEGIN OF ty_result,
         mtart       TYPE mara-mtart,
         zitem_class TYPE mara-zitem_class,
         cmonth      TYPE char3,
         menge       TYPE ekpo-menge,
         month(13)   TYPE p DECIMALS 6,
         v_apr(13)   TYPE p DECIMALS 6,
         v_may(13)   TYPE p DECIMALS 6,
         v_jun(13)   TYPE p DECIMALS 6,
         v_jul(13)   TYPE p DECIMALS 6,
         v_aug(13)   TYPE p DECIMALS 6,
         v_sep(13)   TYPE p DECIMALS 6,
         v_oct(13)   TYPE p DECIMALS 6,
         v_nov(13)   TYPE p DECIMALS 6,
         v_dec(13)   TYPE p DECIMALS 6,
         v_jan(13)   TYPE p DECIMALS 6,
         v_feb(13)   TYPE p DECIMALS 6,
         v_mar(13)   TYPE p DECIMALS 6,
         q_apr(13)   TYPE p DECIMALS 6,
         q_may(13)   TYPE p DECIMALS 6,
         q_jun(13)   TYPE p DECIMALS 6,
         q_jul(13)   TYPE p DECIMALS 6,
         q_aug(13)   TYPE p DECIMALS 6,
         q_sep(13)   TYPE p DECIMALS 6,
         q_oct(13)   TYPE p DECIMALS 6,
         q_nov(13)   TYPE p DECIMALS 6,
         q_dec(13)   TYPE p DECIMALS 6,
         q_jan(13)   TYPE p DECIMALS 6,
         q_feb(13)   TYPE p DECIMALS 6,
         q_mar(13)   TYPE p DECIMALS 6,
         cellcolor   TYPE lvc_t_scol,
       END OF ty_result.

TYPES: BEGIN OF ty_flag,
         v_apr,
         v_may,
         v_jun,
         v_jul,
         v_aug,
         v_sep,
         v_oct,
         v_nov,
         v_dec,
         v_jan,
         v_feb,
         v_mar,
       END OF ty_flag.

DATA : gs_flag TYPE ty_flag.
DATA gt_color TYPE lvc_t_scol WITH HEADER LINE.

TYPES : BEGIN OF ty_e,
          mtart     TYPE mara-mtart,
          class     TYPE mara-zitem_class,
          dmonth    TYPE char10,
          menge(13) TYPE p DECIMALS 6,
          netpr(13) TYPE p DECIMALS 6,
        END OF ty_e.

DATA : gt_eket1 TYPE TABLE OF ty_e,
       gs_eket1 TYPE  ty_e.
DATA : gv_flag   .
DATA : gv_cmonth TYPE char10.
DATA : lv_month TYPE char10.
DATA : lv_count TYPE i.
DATA : gv_sdate TYPE sy-datum.
DATA : gv_edate TYPE sy-datum.

TYPES tt_result_table TYPE TABLE OF ty_result WITH EMPTY KEY.
DATA gt_result TYPE tt_result_table.
DATA gt_result1 TYPE tt_result_table.
DATA gs_result TYPE ty_result.
DATA gs_result1 TYPE ty_result.

DATA : it_fcat   TYPE slis_t_fieldcat_alv,
       wa_fcat   TYPE slis_fieldcat_alv,
       wa_layout TYPE slis_layout_alv.
DATA : gv_datum TYPE sy-datum.
PARAMETERS: p_bukrs TYPE bukrs OBLIGATORY DEFAULT '1000'.
SELECT-OPTIONS:
s_ekgrp FOR lv_ekgrp OBLIGATORY MEMORY ID abc,
s_vert  FOR lv_vname OBLIGATORY,
s_werks FOR lv_werks.
PARAMETERS: p_year TYPE ekpo-saisj.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR  s_vert-low.
  IF s_ekgrp IS NOT INITIAL.
    SELECT  ekgrp,
            vname,
            bdesc,
            vdesc
    FROM  ziverticalmap
    INTO TABLE  @DATA(lt_vert)
    WHERE ekgrp IN  @s_ekgrp  .
  ELSE.
    SELECT  ekgrp,
            vname,
            bdesc,
            vdesc
            FROM  ziverticalmap
    INTO TABLE  @DATA(lt_vert1).

  ENDIF.
  IF lt_vert1 IS NOT INITIAL.
    lt_vert  = lt_vert1.
  ENDIF.
  DATA lt_ret TYPE TABLE OF  ddshretval.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'VNAME'
      dynprofield     = 'S_VERT-LOW'
      value_org       = 'S'
    TABLES
      value_tab       = lt_vert
      return_tab      = lt_ret
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  READ TABLE lt_ret INTO DATA(ls_ret) INDEX 1.
  IF sy-subrc IS INITIAL.
    s_vert-low = ls_ret-fieldval.
    s_vert-option = 'EQ'.
    s_vert-sign = 'I'.
    APPEND s_vert.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR  s_vert-high.
  IF s_ekgrp IS NOT INITIAL.
    SELECT  ekgrp,
    vname,
    bdesc,
    vdesc
    FROM  ziverticalmap
    INTO TABLE  @DATA(lt_vert)
          WHERE ekgrp IN  @s_ekgrp  .
  ELSE.
    SELECT  ekgrp,
    vname,
    bdesc,
    vdesc
    FROM  ziverticalmap
    INTO TABLE  @DATA(lt_vert1).

  ENDIF.
  IF lt_vert1 IS NOT INITIAL.
    lt_vert  = lt_vert1.
  ENDIF.
  DATA lt_ret TYPE TABLE OF  ddshretval.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'VNAME'
      dynprofield     = 'S_VERT-HIGH'
      value_org       = 'S'
    TABLES
      value_tab       = lt_vert
      return_tab      = lt_ret
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  READ TABLE lt_ret INTO DATA(ls_ret) INDEX 1.
  IF sy-subrc IS INITIAL.
    s_vert-low = ls_ret-fieldval.
    s_vert-option = 'EQ'.
    s_vert-sign = 'I'.
    APPEND s_vert.
  ENDIF.



  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      retfield        = 'VNAME'
    TABLES
      value_tab       = lt_vert
*     FIELD_TAB       =
*     RETURN_TAB      =
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



START-OF-SELECTION.
  PERFORM get_gv_datum.
  PERFORM get_current_month.
  PERFORM get_data.
  PERFORM prepare_field_cat .
  PERFORM display_alv.

*----------------------------------------------------------------------
* GET DATA
*----------------------------------------------------------------------
FORM get_data.
  DATA e_month TYPE string.
  DATA e_year TYPE string.


  CALL FUNCTION 'CACS_DATE_GET_YEAR_MONTH'
    EXPORTING
      i_date  = gv_datum
    IMPORTING
      e_month = e_month.

  SELECT  ekgrp,
          vname,
          bdesc,
          vdesc
  FROM  ziverticalmap
  INTO TABLE  @DATA(it_vert)
        WHERE ekgrp IN @s_ekgrp
        AND vname IN @s_vert.


  IF it_vert IS NOT INITIAL.
    SELECT
    a~ebeln,
    a~bukrs,
    a~bstyp,
    a~bsart,
    a~loekz     AS loekz_hdr,
    a~aedat,
    a~lifnr,
    a~ekgrp,
    b~ebelp,
    b~matnr,
    b~werks,
    b~lgort,
    b~menge,
    b~netpr,
    b~peinh,
    b~elikz,
    b~loekz     AS loekz_item
    INTO TABLE @DATA(gt_ekko)
          FROM ekko AS a
          INNER JOIN ekpo AS b
          ON a~ebeln = b~ebeln
          FOR ALL ENTRIES IN @it_vert
          WHERE a~ekgrp = @it_vert-ekgrp
          AND a~bstyp = 'F'
          AND a~aedat BETWEEN @gv_sdate AND @gv_edate
          AND b~loekz <> 'L'
          AND a~loekz = ''.

  ELSE.

    SELECT
    a~ebeln,
    a~bukrs,
    a~bstyp,
    a~bsart,
    a~loekz    AS loekz_hdr,
    a~aedat,
    a~lifnr,
    a~ekgrp,
    b~ebelp,
    b~matnr,
    b~werks,
    b~lgort,
    b~menge,
    b~netpr,
    b~peinh,
    b~elikz,
    b~loekz    AS loekz_item
    FROM ekko AS a
    INNER JOIN ekpo AS b
    ON a~ebeln = b~ebeln
    WHERE a~ekgrp IN @s_ekgrp
    AND a~bstyp = 'F'
    AND a~aedat BETWEEN @gv_sdate AND @gv_edate
    AND b~loekz <> 'L'
    AND b~elikz = ''
    INTO TABLE @DATA(gt_ekko1).



  ENDIF.
  DELETE  gt_ekko WHERE elikz = 'X'.
  DELETE  gt_ekko WHERE loekz_item = 'L'.
  DELETE  gt_ekko WHERE loekz_hdr = 'X'.
  IF gt_ekko IS INITIAL AND gt_ekko1 IS NOT INITIAL.
    gt_ekko = gt_ekko1.
  ENDIF.

*  LOOP AT gt_ekko ASSIGNING FIELD-SYMBOL(<fs>).
*    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
*      EXPORTING
*        input  = <fs>-matnr
*      IMPORTING
*        output = <fs>-matnr
**     EXCEPTIONS
**       LENGTH_ERROR       = 1
**       OTHERS = 2
*      .
*    IF sy-subrc <> 0.
**     Implement suitable error handling here
*    ENDIF.
*  ENDLOOP.

*    DATA(lv_lifnr) = '0000100354'.
*    DELETE gt_ekko WHERE lifnr NE lv_lifnr.
*    DELETE gt_ekko WHERE ebeln NE '1710114969'.
  DATA(gt_ekko_t) = gt_ekko.

  SORT gt_ekko_t BY matnr.
  SORT gt_ekko BY matnr.
  DELETE ADJACENT DUPLICATES FROM gt_ekko_t COMPARING matnr.

  IF gt_ekko_t IS NOT INITIAL.
    SELECT matnr , mtart, zitem_class
    FROM mara
    INTO TABLE @DATA(gt_mara)
          FOR ALL ENTRIES IN  @gt_ekko_t
          WHERE matnr = @gt_ekko_t-matnr.
  ENDIF.


*******     GET GET open PO QTY
  SELECT ebeln, ebelp, eindt, menge , wemng
  FROM eket
  INTO TABLE @DATA(gt_eket)
        FOR ALL ENTRIES IN @gt_ekko
        WHERE ebeln = @gt_ekko-ebeln
        AND ebelp = @gt_ekko-ebelp.


  LOOP AT gt_eket INTO DATA(eket) .
    IF eket-menge NE eket-wemng .
      READ TABLE gt_ekko INTO DATA(gs_ekko) WITH KEY ebeln = eket-ebeln
                                                       ebelp = eket-ebelp.
      IF sy-subrc IS INITIAL.
        gs_eket1-menge =  ( eket-menge - eket-wemng ) .
        gs_eket1-netpr =  ( eket-menge * gs_ekko-netpr ) / 100000.
        READ TABLE GT_MARA INTO DATA(GS_MARA) with key MATNR = gs_ekko-matnr.
        gs_eket1-mtart =   GS_MARA-mtart.
        gs_eket1-class =   GS_MARA-zitem_class.
      ENDIF.
    ENDIF.

    PERFORM get_current_month_item USING eket-eindt.
    gs_eket1-dmonth = gv_cmonth.
    COLLECT gs_eket1 INTO gt_eket1.
    CLEAR gs_eket1.

  ENDLOOP.

  REFRESH gt_result.
  CLEAR gs_result.
  SORT gt_eket1 BY mtart class dmonth.

  DELETE gt_eket1 WHERE menge IS INITIAL.

  LOOP AT gt_eket1 INTO gs_eket1 .

    CASE gs_eket1-dmonth+0(3).
      WHEN 'JAN'.
        gs_flag-v_jan = 'X'.
        gs_result-v_jan =  gs_result-v_jan + gs_eket1-netpr .
        gs_result-q_jan =  gs_result-v_jan + gs_eket1-menge .
      WHEN 'FEB'.
        gs_flag-v_feb = 'X'.
        gs_result-v_feb =  gs_result-v_feb + gs_eket1-netpr .
        gs_result-q_feb =  gs_result-v_feb + gs_eket1-menge .
      WHEN 'MAR'.
        gs_flag-v_mar = 'X'.
        gs_result-v_mar =  gs_result-v_mar + gs_eket1-netpr .
        gs_result-q_mar =  gs_result-v_mar + gs_eket1-menge .
      WHEN 'APR'.
        gs_flag-v_apr = 'X'.
        gs_result-v_apr =  gs_result-v_apr + gs_eket1-netpr .
        gs_result-q_apr =  gs_result-v_apr + gs_eket1-menge .
      WHEN 'MAY'.
        gs_flag-v_may = 'X'.
        gs_result-v_may =  gs_result-v_may + gs_eket1-netpr .
        gs_result-q_may =  gs_result-v_may + gs_eket1-menge .
      WHEN 'JUN'.
        gs_flag-v_jun = 'X'.
        gs_result-v_jun =  gs_result-v_jun + gs_eket1-netpr .
        gs_result-q_jun =  gs_result-v_jun + gs_eket1-menge .
      WHEN 'JUL'.
        gs_flag-v_jul = 'X'.
        gs_result-v_jul =  gs_result-v_jul + gs_eket1-netpr .
        gs_result-q_jul =  gs_result-v_jul + gs_eket1-menge .
      WHEN 'AUG'.
        gs_flag-v_aug = 'X'.
        gs_result-v_aug =  gs_result-v_aug + gs_eket1-netpr .
        gs_result-q_aug =  gs_result-v_aug + gs_eket1-menge .
      WHEN 'SEP'.
        gs_flag-v_sep = 'X'.
        gs_result-v_sep =  gs_result-v_sep + gs_eket1-netpr .
        gs_result-q_sep =  gs_result-v_sep + gs_eket1-menge .
      WHEN 'OCT'.
        gs_flag-v_oct = 'X'.
        gs_result-v_oct =  gs_result-v_oct + gs_eket1-netpr .
        gs_result-q_oct =  gs_result-v_oct + gs_eket1-menge .
      WHEN 'NOV'.
        gs_flag-v_nov = 'X'.
        gs_result-v_nov =  gs_result-v_nov + gs_eket1-netpr .
        gs_result-q_nov =  gs_result-v_nov + gs_eket1-menge .
      WHEN 'DEC'.
        gs_flag-v_dec = 'X'.
        gs_result-v_dec =  gs_result-v_dec +  gs_eket1-netpr .
        gs_result-q_dec =  gs_result-v_dec +  gs_eket1-menge .
      WHEN OTHERS.
    ENDCASE.

    AT END OF CLASS.
      lv_end = 'X'.
    ENDAT.
    AT END OF MTART.
      lv_end = 'X'.
    ENDAT.

    IF lv_end = 'X'.
      IF gs_result-month IS NOT INITIAL.
        APPEND gs_result TO gt_result.
      ENDIF.
      CLEAR :gs_result, lv_end.
    ENDIF.
  ENDLOOP.


ENDFORM.

FORM prepare_field_cat .
  DATA : lv_count TYPE i VALUE '1'.
*  DATA : lv_string TYPE string.
  DATA count TYPE i.
  DATA e_month TYPE string.
  DATA e_year TYPE string.
  DATA p_year TYPE string.
  DATA : lv_colnm TYPE string.
  CALL FUNCTION 'CACS_DATE_GET_YEAR_MONTH'
    EXPORTING
      i_date  = gv_datum
    IMPORTING
      e_month = e_month
      e_year  = e_year.


*  PERFORM FILL_FCAT USING p_field P_colpos P_ITAB p_desc_m p_edit P_SUM..
  PERFORM fill_fcat USING 'MTART'   lv_count  'Material Type'     . lv_count = lv_count + 1.
  PERFORM fill_fcat USING 'CLASS'   lv_count  'CLASS'       . lv_count = lv_count + 1.

  IF gs_flag-v_apr IS NOT INITIAL.
    lv_colnm = |APR-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_APR'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |APR-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_APR'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.


  IF gs_flag-v_may IS NOT INITIAL.
    lv_colnm = |MAY-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_MAY'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |MAY-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_MAY'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_jun IS NOT INITIAL.
    lv_colnm = |JUN-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_JUN'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |JUN-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_JUN'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_jul IS NOT INITIAL.
    lv_colnm = |JUL-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_JUL'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |JUL-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_JUL'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_aug IS NOT INITIAL.
    lv_colnm = |AUG-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_AUG'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |AUG-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_AUG'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_sep IS NOT INITIAL.
    lv_colnm = |SEP-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_SEP'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |SEP-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_SEP'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_oct IS NOT INITIAL.
    lv_colnm = |OCT-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_OCT'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |OCT-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_OCT'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
    ENDIF.

  IF gs_flag-v_nov IS NOT INITIAL.
    lv_colnm = |NOV-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_NOV'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |NOV-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_NOV'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_dec IS NOT INITIAL.
    lv_colnm = |DEC-{ gv_sdate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_DEC'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |DEC-{ gv_sdate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_DEC'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_jan IS NOT INITIAL.
    lv_colnm = |JAN-{ gv_edate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_JAN'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |JAN-{ gv_edate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_JAN'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_feb IS NOT INITIAL.
    lv_colnm = |FEB-{ gv_edate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_FEB'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |FEB-{ gv_edate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_FEB'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.

  IF gs_flag-v_mar IS NOT INITIAL.
    lv_colnm = |MAR-{ gv_edate+0(4) } Qty|.
    PERFORM fill_fcat USING 'Q_MAR'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.

    lv_colnm = |MAR-{ gv_edate+0(4) } Value|.
    PERFORM fill_fcat USING 'V_MAR'   lv_count  lv_colnm    .
    lv_count = lv_count + 1.
  ENDIF.



ENDFORM.

*&---------------------------------------------------------------------*
*& Form FILL_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> FIELD
*&      --> LENGTH
*&      --> DESC_M
*&      --> EDIT
*&---------------------------------------------------------------------*
FORM fill_fcat  USING    p_field
      p_colpos
      p_desc_m

      .
  wa_fcat-fieldname = p_field.
  wa_fcat-col_pos   = p_colpos.
  wa_fcat-seltext_m = p_desc_m.
  wa_fcat-tabname   = 'GT_FINAL'.
  IF p_field+0(1) = 'V'.
    wa_fcat-emphasize   = 'C100'.
  ENDIF.
  IF p_field+0(1) = 'A'.
    wa_fcat-emphasize   = 'C700'.
  ENDIF.
  IF p_field+0(1) = 'T'.
    wa_fcat-emphasize   = 'C300'.
  ENDIF.

  APPEND wa_fcat TO it_fcat.

ENDFORM.

*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv .
  wa_layout-coltab_fieldname = 'CELLCOLOR'.
  wa_layout-colwidth_optimize = 'X'.
  wa_layout-zebra = 'X'.
*  wa_layout-lights_fieldname = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = wa_layout
      it_fieldcat        = it_fcat
    TABLES
      t_outtab           = gt_result
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form Get_current_Month
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_current_month .
  DATA e_month TYPE string.
  DATA e_year TYPE string.

  CALL FUNCTION 'CACS_DATE_GET_YEAR_MONTH'
    EXPORTING
      i_date  = sy-datum
    IMPORTING
      e_month = e_month
      e_year  = e_year.

  IF p_year LT e_year.
    e_month = 3.
    gv_sdate = |{ p_year - 1 }0401|.
    gv_edate = |{ p_year }0331|.
    gv_datum = gv_edate.
  ELSE.
    gv_datum = sy-datum.
    IF e_month = 1 OR e_month = 2 OR e_month = 3.
      gv_sdate = |{ e_year - 1 }0401|.
      gv_edate = |{ e_year }0331|.
    ELSE.
      gv_sdate = |{ e_year }0401|.
      gv_edate = |{ e_year + 1 }0331|.
    ENDIF.
  ENDIF.


  CASE e_month.
    WHEN 1.
      gv_cmonth = 'JAN' .
    WHEN 2.
      gv_cmonth = 'FEB' .
    WHEN 3.
      gv_cmonth = 'MAR' .
    WHEN 4.
      gv_cmonth = 'APR' .
    WHEN 5.
      gv_cmonth = 'MAY' .
    WHEN 6.
      gv_cmonth = 'JUN' .
    WHEN 7.
      gv_cmonth = 'JUL' .
    WHEN 8.
      gv_cmonth = 'AUG' .
    WHEN 9.
      gv_cmonth = 'SEP' .
    WHEN 10.
      gv_cmonth = 'OCT' .
    WHEN 11.
      gv_cmonth = 'NOV' .
    WHEN 12.
      gv_cmonth = 'DEC' .
    WHEN OTHERS.
  ENDCASE.

ENDFORM.

FORM get_current_month_item USING p_date.
  DATA e_month TYPE string.
  DATA e_year TYPE string.

  CALL FUNCTION 'CACS_DATE_GET_YEAR_MONTH'
    EXPORTING
      i_date  = p_date
    IMPORTING
      e_month = e_month
      e_year  = e_year.


  CASE e_month.
    WHEN 1.
      gv_cmonth = |JAN-{ gv_edate+0(4) }|.
    WHEN 2.
      gv_cmonth = |FEB-{ gv_edate+0(4) }|.
    WHEN 3.
      gv_cmonth = |MAR-{ gv_edate+0(4) }|.
    WHEN 4.
      gv_cmonth = |APR-{ gv_sdate+0(4) }|.
    WHEN 5.
      gv_cmonth = |MAY-{ gv_sdate+0(4) }|.
    WHEN 6.
      gv_cmonth = |JUN-{ gv_sdate+0(4) }|.
    WHEN 7.
      gv_cmonth = |JUL-{ gv_sdate+0(4) }|.
    WHEN 8.
      gv_cmonth = |AUG-{ gv_sdate+0(4) }|.
    WHEN 9.
      gv_cmonth = |SEP-{ gv_sdate+0(4) }|.
    WHEN 10.
      gv_cmonth = |OCT-{ gv_sdate+0(4) }|.
    WHEN 11.
      gv_cmonth = |NOV-{ gv_sdate+0(4) }|.
    WHEN 12.
      gv_cmonth = |DEC-{ gv_sdate+0(4) }|.
    WHEN OTHERS.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_GV_DATUM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_gv_datum .
  IF p_year IS NOT INITIAL.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form COLOR_CELL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM color_cell USING p_fname p_fval.

  CLEAR gt_color.
  IF p_fval LT 0.
    gt_color-fname = p_fname.
    gt_color-color-col = cl_gui_resources=>list_col_negative.
    gt_color-color-int = 0.
    APPEND gt_color.

  ENDIF.
ENDFORM.
