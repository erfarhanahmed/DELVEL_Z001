*&---------------------------------------------------------------------*
*&  Include           ZMTRL_LAST_CONSUMPTION_DATA
*&---------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT.
*  LOOP AT SCREEN.
*    IF screen-group1 = 'BU'.
*      screen-input = '0'.
*      MODIFY SCREEN.
*    ENDIF.
*  ENDLOOP.

START-OF-SELECTION.

PERFORM get_data.
PERFORM get_fieldcat.
PERFORM display_data.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
*BREAK-POINT.
  SELECT a~werks ,
         a~matnr ,
         b~maktx ,
         a~budat_mkpf,
         a~menge,
         a~mblnr,
         a~aufnr,
         a~ebeln,
         a~kostl,
         a~vbeln_im,
         a~kdauf,
         a~kdpos,
         a~CPUDT_MKPF,
         a~cputm_mkpf,
         a~bwart,
         a~ZEILE,
         a~SMBLN,
         a~SMBLP
         FROM mseg AS a
         JOIN makt AS b ON ( b~matnr = a~matnr )
         INTO TABLE @DATA(it_mseg_makt)
         WHERE a~matnr IN @s_matnr
         AND a~werks = @p_werks
         AND a~budat_mkpf IN @s_budat
         AND b~spras = @sy-langu
         AND bwart IN ( '201' , '261' , '543' , '601' , '702' ).
  SORT it_mseg_makt DESCENDING BY matnr budat_mkpf CPUDT_MKPF cputm_mkpf.
*************************Added by Komal.s on 28-4-25**********************

  select a~werks ,
         a~matnr ,
         b~maktx ,
         a~budat_mkpf,
         a~menge,
         a~mblnr,
         a~aufnr,
         a~ebeln,
         a~kostl,
         a~vbeln_im,
         a~kdauf,
         a~kdpos,
         a~CPUDT_MKPF,
         a~cputm_mkpf,
         a~bwart,
         a~ZEILE,
         a~SMBLN,
         a~SMBLP
         FROM mseg AS a
         JOIN makt AS b ON ( b~matnr = a~matnr )
         INTO TABLE @DATA(it_mseg_makt2)
         FOR ALL ENTRIES IN @it_mseg_makt
         WHERE a~matnr IN @s_matnr
         AND a~werks = @p_werks
         AND a~budat_mkpf IN @s_budat
         AND b~spras = @sy-langu
         AND bwart IN (  '262' , '202', '602', '544' )
         and SMBLN = @it_mseg_makt-mblnr
         and SMBLP = @it_mseg_makt-ZEILE.

*data(it_601) = it_mseg_makt.
*delete it_601 where bwart <> '601'.







if it_mseg_makt2 is not INITIAL.
  loop at it_mseg_makt2 into data(wa_mseg_makt2).
    read table it_mseg_makt into DATA(wa_mseg_makt) with key mblnr = wa_mseg_makt2-smbln ZEILE = wa_mseg_makt2-smblp.
    if sy-subrc = 0.
      delete it_mseg_makt INDEX sy-tabix.
    endif.

  ENDLOOP.

  delete it_mseg_makt where SMBLN is not INITIAL.

endif.

*     select * from vbfa
*     INTO table @data(it_vbfa)
*     FOR ALL ENTRIES IN @it_mseg_makt
*     where matnr = @it_mseg_makt-matnr
*     and vbelv = @it_mseg_makt-kdauf
*       AND POSNV = @IT_mseg_makt-kdpos
*     and bwart = '653'.
*sort it_mseg_makt by kdauf kdpos.
*       if it_vbfa is NOT INITIAL.
*         loop at it_vbfa into data(wa_vbfa).
*          loop at it_mseg_makt into DATA(wa_mseg_makt_1) where matnr = wa_vbfa-matnr and  kdauf = wa_vbfa-vbelv and
*           kdpos = wa_vbfa-posnv and bwart = '653'.
**           if sy-subrc is INITIAL.
*             delete it_mseg_makt WHERE MATNR = wa_mseg_makt_1-matnr AND kdauf = wa_mseg_makt_1-KDAUF and kdpos = wa_mseg_makt_1-KDpos.
**           endif.
*         endloop.
*         endloop.
*       endif.


*************************Ended by Komal.s on 28-4-25**********************

  DELETE ADJACENT DUPLICATES FROM it_mseg_makt COMPARING matnr.
  LOOP AT it_mseg_makt INTO wa_mseg_makt.
    wa_final-werks = wa_mseg_makt-werks.
    wa_final-matnr = wa_mseg_makt-matnr.


    CLEAR: lv_lines, ls_mattxt.
    REFRESH lv_lines.
    lv_name = wa_final-matnr.
    IF lv_name IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name
          object                  = 'MATERIAL'
        TABLES
          lines                   = lv_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          REPLACE ALL OCCURRENCES OF '<(>' IN wa_lines-tdline WITH space.
          REPLACE ALL OCCURRENCES OF '<)>' IN wa_lines-tdline WITH space.
          CONCATENATE wa_final-mattxt wa_lines-tdline INTO wa_final-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE wa_final-mattxt.
    ENDIF.

*    wa_final-maktx = wa_mseg_makt-maktx.
    wa_final-budat_mkpf = wa_mseg_makt-budat_mkpf.
    wa_final-menge = wa_mseg_makt-menge.
    wa_final-mblnr = wa_mseg_makt-mblnr.
    lv_bwart  = wa_mseg_makt-bwart.
    CASE lv_bwart.
      WHEN '261'.
        wa_final-aufnr = wa_mseg_makt-aufnr.
      WHEN '543'.
        wa_final-ebeln = wa_mseg_makt-ebeln.
      WHEN '201'.
        wa_final-kostl = wa_mseg_makt-kostl.
      WHEN '601'.
        wa_final-vbeln_im = wa_mseg_makt-kdauf.
      WHEN '702'.
        wa_final-kdauf = wa_mseg_makt-kostl. "kdauf.
    ENDCASE.
*      refresh_on
*      refresh_time
    APPEND wa_final TO it_final.
    CLEAR : wa_final, wa_mseg_makt,lv_bwart.
  ENDLOOP.
  if p_down = 'X'.
    loop at it_final INTO wa_final.
     wa_down-werks       = wa_final-werks     .
     wa_down-matnr       = wa_final-matnr     .
     wa_down-mattxt       = wa_final-mattxt     .
*     wa_down-budat_mkpf  = wa_final-budat_mkpf.
     if wa_final-budat_mkpf is NOT INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = wa_final-budat_mkpf
        IMPORTING
          output = wa_down-budat_mkpf.

      CONCATENATE wa_down-budat_mkpf+0(2) wa_down-budat_mkpf+2(3) wa_down-budat_mkpf+5(4)
                      INTO wa_down-budat_mkpf SEPARATED BY '-'.
     endif.
     wa_down-menge       = wa_final-menge     .
     wa_down-mblnr       = wa_final-mblnr     .
     wa_down-aufnr       = wa_final-aufnr     .
     wa_down-ebeln       = wa_final-ebeln     .
     wa_down-kostl       = wa_final-kostl     .
     wa_down-vbeln_im    = wa_final-vbeln_im  .
     wa_down-kdauf       = wa_final-kdauf     .
*     wa_down-ref_date    =  ref_date          .
*     wa_down-ref_time    =  ref_time          .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.

      CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                      INTO wa_down-ref_date SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2)  INTO wa_down-ref_time.

    append wa_down to it_down.

       CLEAR : wa_final, wa_Down.
  ENDLOOP.
*    endloop.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fieldcat .
  PERFORM fieldcatlog USING  '1'  'WERKS'        'Plant'                '4'.
  PERFORM fieldcatlog USING  '2'  'MATNR'        'Material Code'        '18'.
  PERFORM fieldcatlog USING  '3'  'MATTXT'        'Material Description' '40'.
  PERFORM fieldcatlog USING  '4'  'BUDAT_MKPF'   'Last Consumption Date' '19'.
  PERFORM fieldcatlog USING  '5'  'MENGE'        'Consumed Quantity'     '18'.
  PERFORM fieldcatlog USING  '6'  'MBLNR'        'Material Doc No.'      '14'.
  PERFORM fieldcatlog USING  '7'  'AUFNR'        'Production Order'      '14'.
  PERFORM fieldcatlog USING  '8'  'EBELN'        'Purchase Order'        '16'.
  PERFORM fieldcatlog USING  '9'  'KOSTL'        'Cost Centre'           '11'.
  PERFORM fieldcatlog USING  '10'  'VBELN_IM'    'Sales Order'           '11'.
  PERFORM fieldcatlog USING  '11'  'KDAUF'       'Inventory Right Off'   '19'.
*  PERFORM fieldcatlog USING  '12'  'REFRESH_ON'   'Refreshable On' '13'.
*  PERFORM fieldcatlog USING  '13'  'REFRESH_TIME'   'Refreshable Time' '16'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
*     is_layout          = ''
*     i_callback_top_of_page = ''
      it_fieldcat        = fieldcat[]
*     it_sort            = ''
*     i_save             = ''
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

   IF P_DOWN = 'X'.
    PERFORM download.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0015   text
*      -->P_0016   text
*      -->P_0017   text
*      -->P_0018   text
*----------------------------------------------------------------------*
FORM fieldcatlog  USING    VALUE(col)
                           VALUE(field)
                           VALUE(text)
                           VALUE(length).

  fieldcat-col_pos   = col.
  fieldcat-fieldname = field.
  fieldcat-seltext_l = text.
  fieldcat-outputlen = length.
  APPEND fieldcat.
  CLEAR fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.
  if P_WERKS = 'PL01'.
  lv_file = 'ZMTRL_LAST_CONSUM.TXT'.
  ELSEIF P_WERKS = 'US01' or  P_WERKS = 'US02' or  P_WERKS = 'US03'.
    lv_file = 'ZMTRL_LAST_CONSUM_US.TXT'.
  ELSEIF P_WERKS = 'SU01'.
       lv_file = 'ZMTRL_LAST_CONSUM_SU01.TXT'.
  ENDIF.

  CONCATENATE p_folder '\' lv_file
     INTO lv_fullfile.

  WRITE: / 'ZMTRL_LAST_CONSUM.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CLOSE DATASET lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Plant'
              'Material Code'
              'Material Description'
              'Last Consumption Date'
              'Consumed Quantity'
              'Material Doc No.'
              'Production Order'
              'Purchase Order'
              'Cost Centre'
              'Sales Order'
              'Inventory Right Off'
              'Refreshable Date'
              'Refreshable Time'
                 INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
