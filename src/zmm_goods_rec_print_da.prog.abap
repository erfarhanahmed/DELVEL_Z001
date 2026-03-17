*&---------------------------------------------------------------------*
*& Report ZMM_GOODS_REC_PRINT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_goods_rec_print_da.

TABLES : mkpf, mseg.
TYPES: abap_bool        TYPE c LENGTH 1.
TYPES : BEGIN OF t_mblnr,
          mblnr TYPE mblnr,
          mjahr TYPE mjahr,
        END OF t_mblnr.

TYPES : BEGIN OF t_doc,
          mblnr TYPE mblnr,
        END OF t_doc.

* DATA DECLARATIONS
DATA : l_fname  TYPE rs38l_fnam,
       wa_mblnr TYPE t_mblnr,
       it_mblnr TYPE STANDARD TABLE OF t_mblnr.

DATA: lv_vbeln     TYPE vbeln,
      lt_lines     TYPE TABLE OF tline,
      ls_lines     TYPE tline,
      lv_proj_name TYPE string.

CONSTANTS : c_x TYPE c VALUE 'X'.
CONSTANTS:
  abap_true  TYPE abap_bool VALUE 'X',
  abap_false TYPE abap_bool VALUE ' '.

DATA:
  it_doc          TYPE STANDARD TABLE OF zmm_gr_data,  "ypm_gr_str,
  hlp_tab         TYPE TABLE OF t_doc,
  hlp_tab1        TYPE TABLE OF t_doc,
  wa_doc          LIKE LINE OF it_doc,
  v_mblnr         TYPE mblnr,
  gv_tot_lines    TYPE i,

* CONTROLS FOR SMARTFORM PRINTING MULTIPLE TIMES
  gs_con_settings TYPE ssfctrlop.          "CONTROL SETTINGS FOR SMART FORMS


*>>
SELECTION-SCREEN : BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : s_mblnr FOR v_mblnr OBLIGATORY.
  PARAMETERS     : p_mjahr TYPE mkpf-mjahr OBLIGATORY .
SELECTION-SCREEN : END OF BLOCK b2.


*>>
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_mblnr-low.

  SELECT DISTINCT mblnr FROM mseg INTO TABLE hlp_tab
    WHERE ( bwart = '101' OR bwart = '501' OR bwart = '262' ).

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'MBLNR'
      value_org       = 'S'
      dynpprog        = 'ZMM_GOODS_REC_PRINT_DA'
      dynpnr          = '1000'
      dynprofield     = 'S_MBLNR'
    TABLES
      value_tab       = hlp_tab
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*****************************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_mblnr-high.

  SELECT DISTINCT mblnr FROM mseg INTO TABLE hlp_tab1 WHERE ( bwart = '101' OR bwart = '501' ).

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'MBLNR'
      value_org       = 'S'
      dynpprog        = 'ZMM_GOODS_REC_PRINT_DA'
      dynpnr          = '1000'
      dynprofield     = 'S_MBLNR'
    TABLES
      value_tab       = hlp_tab1
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


START-OF-SELECTION.

  PERFORM get_data.

  PERFORM form_name.

  PERFORM form_print.

*&---------------------------------------------------------------------*
*&      FORM  GET_DATA
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT mblnr mjahr
         FROM mkpf
         INTO TABLE it_mblnr
         WHERE mblnr IN s_mblnr
         AND mjahr EQ p_mjahr.
ENDFORM.                    " GET_DATA
*&---------------------------------------------------------------------*
*&      FORM  FORM_NAME
*&---------------------------------------------------------------------*
FORM form_name .

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZMM_GOODS_REC_NOTE_DA'
    IMPORTING
      fm_name            = l_fname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " FORM_NAME
*&---------------------------------------------------------------------*
*&      FORM  FORM_PRINT
*&---------------------------------------------------------------------*
FORM form_print .
  SORT it_mblnr BY mblnr.
  DESCRIBE TABLE it_mblnr LINES gv_tot_lines.

  LOOP AT it_mblnr INTO wa_mblnr.

    SELECT mblnr mjahr kdauf
           FROM mseg
           INTO TABLE it_doc
           WHERE mblnr = wa_mblnr-mblnr
           AND mjahr EQ wa_mblnr-mjahr
           AND ( bwart = '101' OR bwart = '501' OR bwart = '262' ).
    IF it_doc[] IS INITIAL.
      CONTINUE.
    ENDIF.

    " begin of code added by sagar darade

*        SELECT SINGLE aufnr
*                  INTO @DATA(lv_aufnr)
*                  FROM mseg
*                  WHERE mblnr = @wa_mblnr-mblnr
*                  AND   mjahr = @wa_mblnr-mjahr
*                  AND bwart = '101'.
*




**--- Get Customer Project Name from SO Header Text
*    IF lv_vbeln IS NOT INITIAL.
*
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          id       = 'Z001'        " <-- Change if needed
*          language = sy-langu
*          name     = lv_vbeln
*          object   = 'VBBK'
*        TABLES
*          lines    = lt_lines
*        EXCEPTIONS
*          OTHERS   = 1.
*
*      IF sy-subrc = 0.
*        LOOP AT lt_lines INTO ls_lines.
*          CONCATENATE lv_proj_name ls_lines-tdline
*            INTO lv_proj_name SEPARATED BY space.
*        ENDLOOP.
*      ENDIF.
*
*    ENDIF.

    " end of code added by sagar darade


****  *&--FOR PRINTING CONTINUOS PAGES IN CASE RANGE IS GIVEN
    IF sy-tabix = 1.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_false.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_false.
* CLOSE SPOOL AT THE LAST LOOP ONLY
      gs_con_settings-no_close  = abap_true.
    ELSE.
* DIALOG AT FIRST LOOP ONLY
      gs_con_settings-no_dialog = abap_true.
* OPEN THE SPOOL AT THE FIRST LOOP ONLY:
      gs_con_settings-no_open   = abap_true.
    ENDIF.

    IF sy-tabix = gv_tot_lines.
* CLOSE SPOOL
      gs_con_settings-no_close  = abap_false.
    ENDIF.

    lv_proj_name = 'Test'.


    CALL FUNCTION l_fname "'/1BCDWB/SF00000198'
      EXPORTING
        control_parameters = gs_con_settings
        iv_proj_name       = lv_proj_name
      TABLES
        it_docs            = it_doc
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.



*    CALL FUNCTION l_fname "'/1BCDWB/SF00000001'
*      EXPORTING
*        control_parameters = gs_con_settings
*      TABLES
*        it_docs            = it_doc
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CLEAR wa_mblnr.
  ENDLOOP.
ENDFORM.                    " FORM_PRINT
*--------------------------------------------------------------------------------
*EXTRACTED BY DIRECT DOWNLOAD ENTERPRISE VERSION 1.3.1 - E.G.MELLODEW. 1998-2005 UK. SAP RELEASE 700
