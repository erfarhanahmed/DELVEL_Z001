*&---------------------------------------------------------------------*
*& Report ZMMGRN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmgrn.

TABLES:ekko,ekpo,zvertical_map.
TYPES:BEGIN OF ty_final,
        lifnr      TYPE lfa1-lifnr,
        lifnr_name TYPE lfa1-name1,
        month      TYPE char20,
        costing    TYPE matdoc-menge,
        capacity   TYPE matdoc-menge,
        cellcolor  TYPE slis_t_specialcol_alv,
      END OF ty_final.

TYPES:BEGIN OF ty_final1,
        lifnr      TYPE lfa1-lifnr,
        lifnr_name TYPE lfa1-name1,
        month      TYPE char20,
        costinga   TYPE matdoc-menge,
        costingm   TYPE matdoc-menge,
        capacitya  TYPE matdoc-menge,
        capacitym  TYPE matdoc-menge,
        cellcolor  TYPE slis_t_specialcol_alv,

      END OF ty_final1.
TYPES:BEGIN OF ty_lfa1,
        lifnr TYPE lfa1-lifnr,
        name1 TYPE lfa1-name1,
      END OF ty_lfa1.


TYPES:BEGIN OF ty_final2,
        lifnr      TYPE lfa1-lifnr,
        lifnr_name TYPE lfa1-name1,
        month      TYPE char20,
        costinga   TYPE matdoc-menge,
*        costingm   TYPE matdoc-menge,
        capacity   TYPE matdoc-menge,
        cellcolor  TYPE slis_t_specialcol_alv,
*        capacitym  TYPE matdoc-menge,
      END OF ty_final2.
DATA :lt_lfa1 TYPE STANDARD TABLE OF ty_lfa1.
DATA: lv_ekgrp_string TYPE char100,
      lv_lifnr_str    TYPE char100,
      lv_werks_str    TYPE char100,
      lv_bukrs_str    TYPE char100.
DATA:
  lt_final  TYPE STANDARD TABLE OF ty_final,
  lt_final1 TYPE STANDARD TABLE OF ty_final1,
  lt_final2 TYPE STANDARD TABLE OF ty_final2,
  ls_final2 TYPE ty_final2,
  ls_final  TYPE ty_final,
  ls_final1 TYPE ty_final1.
DATA: lt_color TYPE slis_t_specialcol_alv,
      ls_color TYPE slis_specialcol_alv.
DATA: gs_layout TYPE slis_layout_alv.
DATA:lt_result  TYPE STANDARD TABLE OF zv_supp_matdoc,
     lt_result1 TYPE STANDARD TABLE OF zv_supp_matdoc.
DATA:lt_date TYPE RANGE OF datum,
     ls_date LIKE LINE OF lt_date.

DATA:lv_flag TYPE c.
DATA:lv_flag1 TYPE c.
DATA:
  lv_low   TYPE datum,
  lv_low1  TYPE datum,
  lv_high  TYPE datum,
  lv_high1 TYPE datum.

DATA:
  lv_sum  TYPE mseg-menge,
  lv_sum1 TYPE mseg-menge,
  lv_sum2 TYPE mseg-menge,
  lv_sum3 TYPE mseg-menge,
  lv_sum4 TYPE mseg-menge,
  lv_sum5 TYPE mseg-menge,
  lv_sum6 TYPE mseg-menge.

"" global fill
gs_layout-coltab_fieldname = 'CELLCOLOR'.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
                 s_ekgrp FOR zvertical_map-ekgrp OBLIGATORY NO INTERVALS,
                 s_VNAME FOR zvertical_map-vname OBLIGATORY NO INTERVALS,
                 s_bukrs FOR ekko-bukrs NO INTERVALS,
                 p_lifnr FOR ekko-lifnr NO INTERVALS,
                 s_werks FOR ekpo-werks NO INTERVALS.
  PARAMETERS:p_gjahr TYPE matdoc-mjahr OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.


DATA:ls_fcat TYPE slis_fieldcat_alv,
     lt_fcat TYPE STANDARD TABLE OF slis_fieldcat_alv.

DATA:ls_fcat1 TYPE slis_fieldcat_alv,
     lt_fcat1 TYPE STANDARD TABLE OF slis_fieldcat_alv.
DATA:ls_fcat3 TYPE slis_fieldcat_alv,
     lt_fcat3 TYPE STANDARD TABLE OF slis_fieldcat_alv.


START-OF-SELECTION.
*DATA: ls_date TYPE RANGE OF sy-datum.
  PERFORM get_data.

FORM get_data.
  ls_date-sign   = 'I'.
  ls_date-option = 'BT'.

  ls_date-low  = |{ p_gjahr }0401|.
  ls_date-high = |{ p_gjahr + 1 }0331|.

  APPEND ls_date TO lt_date.
*CLEAR ls_date.
  DATA(lv_year) = sy-datum+0(4).
  DATA(lv_month) = sy-datum+4(2).
  IF lv_month >= 4.
    DATA(lv_curr_fy) = lv_year.
  ELSE.
    lv_curr_fy = lv_year - 1.
  ENDIF.
  DATA: s_ekgrp1 TYPE RANGE OF ekko-ekgrp.

  IF p_gjahr <> lv_curr_fy.
    lv_flag = 'X'.   "" not current financial year.
    lv_low = |{ p_gjahr }0401|.
    lv_low = |{ p_gjahr + 1 }0301|.
    lv_high = |{ p_gjahr + 1 }0229|.
    lv_high1 = |{ p_gjahr + 1 }0331|.
  ELSE.
    lv_flag1 = 'X'.  "" financial year
  ENDIF.
  SELECT * FROM zvertical_map INTO TABLE @DATA(lt_map)
    WHERE ekgrp IN @s_ekgrp AND vname IN @s_vname.

  SELECT DISTINCT
     'I' AS sign,
     'EQ' AS option,
     ekgrp AS low
FROM @lt_map AS a
WHERE ekgrp IS NOT INITIAL
INTO TABLE @s_ekgrp1.

  lv_ekgrp_string = concat_lines_of(
table = VALUE string_table( FOR wa IN s_ekgrp1[] ( |{ wa-low }| ) )
sep   = `,`
).

  lv_lifnr_str = concat_lines_of( table = VALUE string_table(
                   FOR wa1 IN p_lifnr[] ( |{ wa1-low ALPHA = OUT }| ) ) sep = `,` ).

  lv_werks_str = concat_lines_of( table = VALUE string_table(
                   FOR wa2 IN s_werks[] ( |{ wa2-low }| ) ) sep = `,` ).

  lv_bukrs_str = concat_lines_of( table = VALUE string_table(
                       FOR wa3 IN s_bukrs[] ( |{ wa3-low }| ) ) sep = `,` ).


  " 2. Select from the CDS View passing the parameters
  SELECT *
    FROM zv_supp_matdoc(
      p_ekgrp_str = @lv_ekgrp_string,
      p_lifnr_str = @lv_lifnr_str,
      p_werks_str = @lv_werks_str,
      p_bukrs_str = @lv_bukrs_str,
      p_date_low  = @ls_date-low,
      p_date_high = @ls_date-high
    )
    INTO TABLE @lt_result.


  lt_result1  = lt_result.
  SORT lt_result1 BY supplier ASCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_result1 COMPARING supplier.
  IF lt_result1 IS NOT INITIAL.
    SELECT lifnr ,name1 FROM lfa1 INTO TABLE @lt_lfa1
      FOR ALL ENTRIES IN @lt_result1
      WHERE lifnr = @lt_result1-supplier AND spras = 'E'.
  ENDIF.

  IF lv_flag1 = 'X'.
    IF sy-datum+4(2) = '04'.
      lv_low = |{ p_gjahr }0401|.
*   lv_low1 = |{ p_gjahr }0401|.
      lv_high = |{ p_gjahr + 1 }0430|.
*   lv_high1 = |{ p_gjahr + 1 }0731|.
      PERFORM fcat_data.
    ELSEIF sy-datum+4(2) = '05'.

      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }0501|.
      lv_high = |{ p_gjahr  }0430|.
      lv_high1 = |{ p_gjahr  }0531|.
      PERFORM fcat1_data.

    ELSEIF sy-datum+4(2) = '06'.
      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }0601|.
      lv_high = |{ p_gjahr  }0531|.
      lv_high1 = |{ p_gjahr  }0630|.
      PERFORM fcat3_data.
    ELSEIF sy-datum+4(2) = '07'.
      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }0701|.
      lv_high = |{ p_gjahr  }0630|.
      lv_high1 = |{ p_gjahr  }0731|.
      PERFORM fcat4_data.
    ELSEIF sy-datum+4(2) = '08'.
      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }0801|.
      lv_high = |{ p_gjahr  }0731|.
      lv_high1 = |{ p_gjahr  }0831|.
      PERFORM fcat5_data.
    ELSEIF sy-datum+4(2) = '09'.
      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }0901|.
      lv_high = |{ p_gjahr }0831|.
      lv_high1 = |{ p_gjahr  }0930|.
      PERFORM fcat6_data.
    ELSEIF sy-datum+4(2) = '10'.
      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }1001|.
      lv_high = |{ p_gjahr }0930|.
      lv_high1 = |{ p_gjahr  }1031|.
      PERFORM fcat7_data.
    ELSEIF sy-datum+4(2) = '11'.
      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }1101|.
      lv_high = |{ p_gjahr  }1031|.
      lv_high1 = |{ p_gjahr }1130|.
      PERFORM fcat8_data.
    ELSEIF sy-datum+4(2) = '12'.
      lv_low = |{ p_gjahr }0401|.
      lv_low1 = |{ p_gjahr }1201|.
      lv_high = |{ p_gjahr  }1130|.
      lv_high1 = |{ p_gjahr }1231|.
      PERFORM fcat9_data.
    ELSEIF sy-datum+4(2) = '01'.
      lv_low = |{ p_gjahr }0401|.
      lv_high = |{ p_gjahr  }1231|.
      lv_low1 = |{ p_gjahr + 1 }0101|.
      lv_high1 = |{ p_gjahr + 1 }0131|.
      PERFORM fcat10_data.
    ELSEIF sy-datum+4(2) = '02'.
      lv_low = |{ p_gjahr }0401|.
      lv_high = |{ p_gjahr + 1 }0131|.
      lv_low1 = |{ p_gjahr + 1 }0201|.
      lv_high1 = |{ p_gjahr + 1 }0231|.
      PERFORM fcat11_data.
    ELSEIF sy-datum+4(2) = '03'.
      lv_low = |{ p_gjahr }0401|.
      lv_high = |{ p_gjahr + 1 }0229|.
      lv_low1 = |{ p_gjahr + 1 }0301|.
      lv_high1 = |{ p_gjahr + 1 }0331|.
      PERFORM fcat12_data.
    ENDIF.
  ELSEIF lv_flag = 'X'.
    lv_low = |{ p_gjahr }0401|.
    lv_high = |{ p_gjahr + 1 }0331|.
    PERFORM fcat13_data.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).
    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final-lifnr_name = <lfa1>-name1.
    ENDIF.
    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).




    ls_final-costing = ( lv_sum * lv_sum1 ) / 1000.
    ls_final-capacity = lv_sum2 - ls_final1-costinga.

*ls_final1-COSTINGM = ( lv_sum3 * lv_sum4 ) / 1000.
*ls_final1-CAPACITYM = lv_sum2 - ls_final1-COSTINGM.
    ls_final-lifnr = <fs>-supplier.
    ls_final-month = <fs>-taxnumber.

    IF ls_final-capacity < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITY'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final-costing < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTING'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.

    ls_final-cellcolor = lt_color.
    APPEND ls_final TO lt_final.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL'  '40'.
  PERFORM build_fc USING   pr_count 'COSTING'  'Costing Receipt Tonnage April'    'LT_FINAL'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITY'  'Additional Supply Capacity April'    'LT_FINAL'  '40'.
*  PERFORM build_fc USING   pr_count 'CCHAL'  'Document & Challan Created by'    'LT_FINAL'  '40'.
*  PERFORM build_fc USING   pr_count 'TOTAL'  'Total Subcon Po'    'LT_FINAL'  '10'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



ENDFORM.


FORM build_fc  USING        "PR_ROW TYPE I
                            pr_count TYPE i
                            pr_fname TYPE string
                            pr_title TYPE string
                            pr_table TYPE slis_tabname
                            pr_length TYPE string.

  pr_count = pr_count + 1.
*  GS_FIELDCAT-ROW_POS   = PR_ROW.
  ls_fcat-col_pos   = pr_count.
  ls_fcat-fieldname = pr_fname.
  ls_fcat-seltext_l = pr_title.
  ls_fcat-tabname   = pr_table.
  ls_fcat-outputlen = pr_length.

  APPEND ls_fcat TO lt_fcat.
  CLEAR ls_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat1_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat1_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).
    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.

    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto May'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage June'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto May'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity June'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.





""
FORM fcat3_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).

    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.
    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto June'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage July'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto June'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity July'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat4_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat4_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).
    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.

    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto June'    'LT_FINAL'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage July'    'LT_FINAL'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto June '    'LT_FINAL'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity July'    'LT_FINAL'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat5_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat5_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).

    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.
    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto July'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Aug'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto July'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Aug'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat6_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat6_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).
    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.

    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.

    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.

  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto Aug'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Sept'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto Aug'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Sept'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.



FORM fcat7_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).
    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.

    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.

  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto Sept'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Oct'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto Sept'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Oct'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat8_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat8_data .

  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).

    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.
    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto Oct'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Nov'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto Oct'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Nov'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.



FORM fcat9_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).

    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.
    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.

  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto Nov'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Dec'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto Nov'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Dec'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat10_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat10_data .

  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).

    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.
    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto Dec'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Jan'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto Dec'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Jan'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat11_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat11_data .

  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).

    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.
    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto Jan'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Feb'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto Jan'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Feb'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat12_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat12_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low AND lv_high
                                       )
                              NEXT sum = sum +  wa-taxnumber ).


    lv_sum3 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum4 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low1 AND lv_high1
                                         )
                                NEXT sum = sum +  wa-urzzt ).

    lv_sum5 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                              FOR wa IN lt_result
                              WHERE (
                                       supplier = <fs>-supplier
                                           AND postingdate BETWEEN lv_low1 AND lv_high1
                                       )
                              NEXT sum = sum +  wa-taxnumber ).
    READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) WITH KEY lifnr = <fs>-supplier.
    IF <lfa1> IS ASSIGNED.
      ls_final1-lifnr_name = <lfa1>-name1.
    ENDIF.

    ls_final1-costinga = ( lv_sum * lv_sum1 ) / 1000.
*    ls_final1-capacitya = lv_sum2 - ls_final1-costinga.
    ls_final1-capacitya = <fs>-taxnumber - ls_final1-costinga.

    ls_final1-costingm = ( lv_sum3 * lv_sum4 ) / 1000.
*    ls_final1-capacitym = lv_sum2 - ls_final1-costingm.
    ls_final1-capacitym = <fs>-taxnumber - ls_final1-costingm.
    ls_final1-lifnr = <fs>-supplier.
    ls_final1-month = <fs>-taxnumber.

    IF ls_final1-capacitya < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final1-costinga < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGA'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-costingm < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTINGM'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
    IF ls_final1-capacitym < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITYM'.
      ls_color-color-col = 6.
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    ls_final1-cellcolor = lt_color.
    APPEND ls_final1 TO lt_final1.
    CLEAR:ls_final1.
*ls_final1-lifnr = <fs>-supplier.

  ENDLOOP.


  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL1'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGA'  'Costing Receipt Tonnage Upto Feb'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Mar'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYA'  'Additional Supply Capacity Upto Feb'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Mar'    'LT_FINAL1'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = gs_layout
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final1
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form fcat13_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fcat13_data .
  LOOP AT lt_result1 ASSIGNING FIELD-SYMBOL(<fs>).

    lv_sum = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-quantityinbaseunit ).


    lv_sum1 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
                                FOR wa IN lt_result
                                WHERE (
                                         supplier = <fs>-supplier
                                             AND postingdate BETWEEN lv_low AND lv_high
                                         )
                                NEXT sum = sum +  wa-urzzt ).

*    lv_sum2 = REDUCE menge_d( INIT sum = CONV menge_d( 0 )
*                              FOR wa IN lt_result
*                              WHERE (
*                                       supplier = <fs>-supplier
*                                           AND postingdate BETWEEN lv_low AND lv_high
*                                       )
*                              NEXT sum = sum +  wa-taxnumber ).




    ls_final-costing = ( lv_sum * lv_sum1 ) / 1000.
*    ls_final-capacity = lv_sum2 - ls_final1-costinga.
    ls_final-capacity = <fs>-taxnumber - ls_final1-costinga.

*ls_final1-COSTINGM = ( lv_sum3 * lv_sum4 ) / 1000.
*ls_final1-CAPACITYM = lv_sum2 - ls_final1-COSTINGM.
    ls_final-lifnr = <fs>-supplier.
    ls_final-month = <fs>-taxnumber.

    IF ls_final-capacity < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'CAPACITY'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.
    ENDIF.
    IF ls_final-costing < 0.
      CLEAR ls_color.
      ls_color-fieldname = 'COSTING'.
      ls_color-color-col = 6.  "Red
      ls_color-color-int = 1.
      APPEND ls_color TO lt_color.

    ENDIF.
  READ TABLE lt_lfa1 ASSIGNING FIELD-SYMBOL(<lfa1>) with key lifnr = <fs>-supplier.
        IF <lfa1> is ASSIGNED.
       ls_final-lifnr_name = <lfa1>-name1.
        ENDIF.
    ls_final-cellcolor = lt_color.
    APPEND ls_final TO lt_final.
    CLEAR:ls_final1,lv_sum,lv_sum1,lv_sum2,lv_sum3,lv_sum4,lv_sum5.

  ENDLOOP.
  DATA: pr_count TYPE i.
  PERFORM build_fc USING   pr_count 'LIFNR'  'Vendor'    'LT_FINAL2'  '10'.
  PERFORM build_fc USING   pr_count 'LIFNR_NAME'  'Vendor Name'    'LT_FINAL2'  '10'.
  PERFORM build_fc USING   pr_count 'MONTH'  'Monthly Capacity'    'LT_FINAL2'  '40'.
  PERFORM build_fc USING   pr_count 'COSTING'  'Costing Receipt Tonnage Upto Mar'    'LT_FINAL2'  '40'.
*  PERFORM build_fc USING   pr_count 'COSTINGM'  'Costing Receipt Tonnage Feb'    'LT_FINAL1'  '40'.
  PERFORM build_fc USING   pr_count 'CAPACITY'  'Additional Supply Capacity Upto Mar'    'LT_FINAL2'  '40'.
*  PERFORM build_fc USING   pr_count 'CAPACITYM'  'Additional Supply Capacity  Feb'    'LT_FINAL2'  '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = lt_fcat
      i_default          = 'A'
      i_save             = 'A'
    TABLES
      t_outtab           = lt_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
