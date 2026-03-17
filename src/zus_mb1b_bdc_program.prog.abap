REPORT zmb1b_bdc_program
       NO STANDARD PAGE HEADING LINE-SIZE 255.
TABLES : sscrfields.

INCLUDE zus_mb1b_bdc_program_excel0.
*include ZMB1B_BDC_PROGRAM_excel.
*include bdcrecx1.
TYPES : BEGIN OF ty_data,
          bldat   TYPE string,
          budat   TYPE string,
          bwartwa TYPE string,
          werks   TYPE string,
          lgort   TYPE string,
          umwrk   TYPE string,
          umlgo   TYPE string,
          matnr   TYPE string,
          erfmg   TYPE string,
        END OF ty_data.

TYPES: BEGIN OF msg_data,
         msgtyp  TYPE c,
         message TYPE string,
       END OF msg_data.


DATA: it_data    TYPE TABLE OF ty_data,
      wa_data    TYPE ty_data,
      it_bdcdata TYPE TABLE OF bdcdata,
      wa_bdcdata TYPE bdcdata,
      it_raw     TYPE truxs_t_text_data,
      it_bdc_msg TYPE TABLE OF bdcmsgcoll,
      wa_bdc_msg TYPE bdcmsgcoll,
      it_alv     TYPE TABLE OF msg_data,
      wa_alv     TYPE msg_data.

DATA: it_fcat1 TYPE slis_t_fieldcat_alv,
      wa_fcat1 TYPE slis_fieldcat_alv.



SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename,
             p_mode TYPE ctu_params-dismode DEFAULT 'N'.
SELECTION-SCREEN END OF BLOCK a.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN SKIP.

INITIALIZATION.
*----add displayed text string to buttons-----*
  w_button = 'Download Excel Template'.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'BUT1'.
    PERFORM excel.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = it_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = it_data
*  EXCEPTIONS
*     CONVERSION_FAILED    = 1
*     OTHERS               = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  DATA: lv_input   TYPE string,
        lv_day     TYPE string,
        lv_month   TYPE string,
        lv_year    TYPE string,
        lv_sydatum TYPE string,
        lv_flag    TYPE i.

  LOOP AT it_data INTO wa_data.
    CLEAR : lv_input,lv_day,lv_month,lv_year,lv_sydatum,lv_flag.
    lv_input = wa_data-bldat.
*    lv_day   = lv_input+0(2).
*    lv_month = lv_input+3(2).
    lv_month   = lv_input+0(2).
    lv_day = lv_input+3(2).
    lv_year  = lv_input+6(4).

*    CONCATENATE lv_year lv_month lv_day INTO lv_sydatum.
    CONCATENATE lv_day '.' lv_month '.' lv_year INTO lv_sydatum.
    wa_data-bldat = lv_sydatum.
*    IF lv_sydatum LT sy-datum .
*      lv_flag = '1'.  "COMMENTED ON 19.05.2025
*      MESSAGE 'Backdated document date is not allowed' TYPE 'E'.
*    ENDIF.
    CLEAR : lv_input,lv_day,lv_month,lv_year,lv_sydatum.
    lv_input = wa_data-budat.
*    lv_day   = lv_input+0(2).
*    lv_month = lv_input+3(2).
    lv_month   = lv_input+0(2).
    lv_day = lv_input+3(2).
    lv_year  = lv_input+6(4).

*    CONCATENATE lv_year lv_month lv_day INTO wa_data-budat.
    CONCATENATE lv_day '.' lv_month '.'  lv_year INTO lv_sydatum.
    wa_data-budat = lv_sydatum.
*    IF lv_sydatum LT sy-datum .
*      lv_flag = '1'.   "COMMENTED ON 19.05.2025
*      MESSAGE 'Backdated posting date is not allowed' TYPE 'E'.
*    ENDIF.

    IF ( wa_data-werks = 'US01' OR wa_data-werks = 'US02' OR wa_data-werks = 'US03' ).  " and lv_flag NE '1' .

*perform open_group.
      "screen 1
      PERFORM bdc_dynpro      USING 'SAPMM07M' '0400'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'RM07M-LGORT'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'MKPF-BLDAT'
                                    wa_data-bldat. "'23.04.2025'.
      PERFORM bdc_field       USING 'MKPF-BUDAT'
                                    wa_data-budat. "'23.04.2025'.
      PERFORM bdc_field       USING 'RM07M-BWARTWA'
                                    wa_data-bwartwa. "'301'.
      PERFORM bdc_field       USING 'RM07M-WERKS'
                                    wa_data-werks."'US01'.
      PERFORM bdc_field       USING 'RM07M-LGORT'
                                    wa_data-lgort. "'FG'.
      PERFORM bdc_field       USING 'XFULL'
                                    'X'.
      PERFORM bdc_field       USING 'RM07M-WVERS2'
                                    'X'.

      "screen 2
      PERFORM bdc_dynpro      USING 'SAPMM07M' '0421'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'MSEG-ERFMG(01)'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field       USING 'MSEGK-UMWRK'
                                    wa_data-umwrk. "'US03'.
      PERFORM bdc_field       USING 'MSEGK-UMLGO'
                                    wa_data-umlgo. "'RM'.
      PERFORM bdc_field       USING 'MSEG-MATNR(01)'
                                    wa_data-matnr. "'10L00020513EDL11S'.
      PERFORM bdc_field       USING 'MSEG-ERFMG(01)'
                                    wa_data-erfmg. "'10'.
      PERFORM bdc_field       USING 'DKACB-FMORE'
                                    'X'.

      "screen 3
      PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=ENTE'.
      PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=ENTE'.
      PERFORM bdc_dynpro      USING 'SAPMM07M' '0421'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'MSEG-ERFMG(01)'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=BU'.
      PERFORM bdc_field       USING 'DKACB-FMORE'
                                    'X'.

      "screen 4
      PERFORM bdc_dynpro      USING 'SAPLKACB' '0002'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=ENTE'.

*perform bdc_transaction using 'MB1B'.

*perform close_group.
      CALL TRANSACTION 'MB1B'  USING it_bdcdata MODE p_mode UPDATE 'S' MESSAGES INTO it_bdc_msg.

    ELSE.
*      IF lv_flag  NE '1'.
        CONCATENATE 'Bdc is for only US Plant' '' INTO  wa_alv-message.
*      ELSE.
*        CONCATENATE 'Backdated posting date is not allowed' '' INTO  wa_alv-message.
*      ENDIF.
      wa_alv-msgtyp = 'E'.
      APPEND wa_alv TO it_alv.
    ENDIF.
    LOOP AT it_bdc_msg INTO wa_bdc_msg.

      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = wa_bdc_msg-msgid
          msgnr               = wa_bdc_msg-msgnr
          msgv1               = wa_bdc_msg-msgv1
          msgv2               = wa_bdc_msg-msgv2
          msgv3               = wa_bdc_msg-msgv3
          msgv4               = wa_bdc_msg-msgv4
        IMPORTING
          message_text_output = wa_alv-message.
      wa_alv-msgtyp = wa_bdc_msg-msgtyp.
      APPEND wa_alv TO it_alv.
      REFRESH : it_bdc_msg.
      CLEAR wa_alv.

    ENDLOOP.
    DELETE it_alv WHERE msgtyp = 'I'.

    REFRESH it_bdcdata.
    CLEAR wa_data.
  ENDLOOP.

  wa_fcat1-col_pos = 1.
  wa_fcat1-fieldname = 'MSGTYP'.
  wa_fcat1-seltext_l = 'MESSAGE TYPE'.
  APPEND wa_fcat1 TO it_fcat1.
  CLEAR wa_fcat1.

  wa_fcat1-col_pos = 2.
  wa_fcat1-fieldname = 'MESSAGE'.
  wa_fcat1-seltext_l = 'MESSAGE '.
  APPEND wa_fcat1 TO it_fcat1.
  CLEAR wa_fcat1.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-cprog
      it_fieldcat        = it_fcat1
*
    TABLES
      t_outtab           = it_alv
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



FORM bdc_dynpro USING program dynpro.
  CLEAR wa_bdcdata.
  wa_bdcdata-program  = program.
  wa_bdcdata-dynpro   = dynpro.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = fnam.
  wa_bdcdata-fval = fval.
  APPEND wa_bdcdata TO it_bdcdata.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM excel .

  PERFORM : fill_data,
            download_data,
            modify_cells,
            cell_border.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_data .

  wa_data1-field1   = 'Document Date'.
  wa_data1-field2   = 'Posting Date'.
  wa_data1-field3   = 'Movement Type'.
  wa_data1-field4   = 'Plant'.
  wa_data1-field5   = 'Storage Location'.
  wa_data1-field6   = 'Receiving Plant'.
  wa_data1-field7   = 'Rcvg SLoc'.
  wa_data1-field8   = 'Material'.
  wa_data1-field9   = 'Quantity'.


  APPEND wa_data1 TO it_data1.
  CLEAR wa_data1.

  CREATE OBJECT application 'EXCEL.APPLICATION'.
  SET PROPERTY OF application 'VISIBLE' = 1.
  CALL METHOD OF
    application
      'WORKBOOKS' = workbook.

*----Create New Worksheet-----*
  SET PROPERTY OF application 'SHEETSINNEWWORKBOOK' = 1.
  CALL METHOD OF
    workbook
    'ADD'.

*-----Create First Excel Sheet-------*
  CALL METHOD OF
    application
    'WORKSHEETS' = sheet
    EXPORTING
      #1  = 1.

  CALL METHOD OF
    sheet
    'ACTIVATE'.
  SET PROPERTY OF sheet 'NAME' = 'MB1B Excel Template'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_data .

  ld_rowindx = 1.
  LOOP AT it_data1 INTO wa_data1.

    ld_rowindx = sy-tabix.

*--Fill Columns for current row-----*
    CLEAR ld_colindx.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE wa_data1 TO <fs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      ld_colindx = sy-index.
      CALL METHOD OF
      sheet
      'CELLS' = cells
      EXPORTING
        #1 = ld_rowindx
        #2 = ld_colindx.
      SET PROPERTY OF cells 'VALUE' = <fs>.
    ENDDO.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MODIFY_CELLS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify_cells .
  " *----Formatting of column number row---------*
  CALL METHOD OF
  application
  'CELLS' = cell1
  EXPORTING
    #1 = 1
    #2 = 1.

*--End of range cell-----*
  CALL METHOD OF
  application
  'CELLS' = cell2
  EXPORTING
    #1 = 1
    #2 = 10.

  CALL METHOD OF
  application
  'RANGE' = range
  EXPORTING
    #1 = cell1
    #2 = cell2.

*-----Modify properties of cell range------*
  "Set font details of range
  GET PROPERTY OF range 'FONT' = font.
  SET PROPERTY OF font 'SIZE' = 12.

  "Set cell shading properties of range
  CALL METHOD OF
    range
      'INTERIOR' = shading.
  SET PROPERTY OF shading 'COLORINDEX' = 0.
  SET PROPERTY OF shading 'PATTERN' = 1.
  FREE OBJECT shading.
*---End of formatting of column number row----*

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CELL_BORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cell_border .

  FREE range.
  CALL METHOD OF application 'CELLS' = cell1
  EXPORTING
    #1 = 1
    #2 = 1.

  CALL METHOD OF application 'CELLS' = cell2
  EXPORTING
    #1 = 1
   #2 = 10.

  CALL METHOD OF
  application
  'RANGE' = range
  EXPORTING
    #1 = cell1
    #2 = cell2.

*---Set border properties of range-----*
  CALL METHOD OF
  range
  'BORDER' = border
  EXPORTING
    #1 = '1'.
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 1.
  FREE OBJECT border.

  CALL METHOD OF
  range
  'BORDER' = border
  EXPORTING
    #1 = '2'.
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.
  FREE OBJECT border.

  CALL METHOD OF
range
'BORDER' = border
EXPORTING
  #1 = '3'.
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.
  FREE OBJECT border.

  CALL METHOD OF
range
'BORDER' = border
EXPORTING
 #1 = '4'.
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.
  FREE OBJECT border.

*---Set column to auto fet to width of text------*
  CALL METHOD OF
    sheet
    'SAVEAS'
    EXPORTING
      #1 = 'D:\SAP_DATA\upload_INFOTYPE0006.XLS'
      #2 = 1.

  FREE OBJECT sheet.
  FREE OBJECT workbook.
  FREE OBJECT application.

ENDFORM.
