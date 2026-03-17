*----------------------------------------------------------------------*
***INCLUDE ZI_QM_PERF_SUPP_YR_DISP_ALV.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form display_yearly_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_YEARLY_ALV .
  DATA: L_TEXT TYPE SCRTEXT_M.
  SELECT MNR, KTX FROM T247 INTO TABLE @DATA(LT_MONTHS)
    WHERE SPRAS = 'E'.
  IF SY-SUBRC <> 0.
    CLEAR LT_MONTHS.
  ENDIF.

  LOOP AT LT_PERIOD INTO LS_PERIOD.
    ASSIGN LT_MONTHS[ MNR = LS_PERIOD-END_DT+4(2) ] TO FIELD-SYMBOL(<LFS_MONTH>).
    IF SY-SUBRC <> 0.
      CLEAR <LFS_MONTH>.
    ELSE.
      IF LV_PERIOD1_NAME IS INITIAL.
        LV_PERIOD1_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD2_NAME IS INITIAL.
        LV_PERIOD2_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD3_NAME IS INITIAL.
        LV_PERIOD3_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD4_NAME IS INITIAL.
        LV_PERIOD4_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD5_NAME IS INITIAL.
        LV_PERIOD5_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD6_NAME IS INITIAL.
        LV_PERIOD6_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD7_NAME IS INITIAL.
        LV_PERIOD7_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD8_NAME IS INITIAL.
        LV_PERIOD8_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD9_NAME IS INITIAL.
        LV_PERIOD9_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD10_NAME IS INITIAL.
        LV_PERIOD10_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD11_NAME IS INITIAL.
        LV_PERIOD11_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ELSEIF LV_PERIOD12_NAME IS INITIAL.
        LV_PERIOD12_NAME = |{ <LFS_MONTH>-KTX }| && |-| && |{ LS_PERIOD-END_DT+2(2) }|.
      ENDIF.
    ENDIF.
  ENDLOOP.
***********************************************************************************************
  GV_REPID = SY-REPID.
*    ls_layout-colwidth_optimize = abap_true. " Optimize column widths
  LS_LAYOUT-EDIT              = ABAP_FALSE. " Set to abap_true for editable ALV

  LS_FIELDCAT-FIELDNAME = 'LIFNR'.
  LS_FIELDCAT-SELTEXT_M = 'Vendor'.
  LS_FIELDCAT-COL_POS   = 1.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'NAME1'.
  LS_FIELDCAT-SELTEXT_M = 'Vendor Name'.
  LS_FIELDCAT-COL_POS   = 2.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD1'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD1_NAME.
  LS_FIELDCAT-COL_POS   = 3.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD2'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD2_NAME.
  LS_FIELDCAT-COL_POS   = 4.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD3'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD3_NAME.
  LS_FIELDCAT-COL_POS   = 5.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD4'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD4_NAME.
  LS_FIELDCAT-COL_POS   = 6.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD5'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD5_NAME.
  LS_FIELDCAT-COL_POS   = 7.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD6'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD6_NAME.
  LS_FIELDCAT-COL_POS   = 8.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD7'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD7_NAME.
  LS_FIELDCAT-COL_POS   = 9.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.


  LS_FIELDCAT-FIELDNAME = 'PERIOD8'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD8_NAME.
  LS_FIELDCAT-COL_POS   = 10.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.


  LS_FIELDCAT-FIELDNAME = 'PERIOD9'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD9_NAME.
  LS_FIELDCAT-COL_POS   = 11.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD10'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD10_NAME.
  LS_FIELDCAT-COL_POS   = 12.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD11'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD11_NAME.
  LS_FIELDCAT-COL_POS   = 13.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'PERIOD12'.
  LS_FIELDCAT-SELTEXT_M = LV_PERIOD12_NAME.
  LS_FIELDCAT-COL_POS   = 14.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.

  LS_FIELDCAT-FIELDNAME = 'AVG'.
  LS_FIELDCAT-SELTEXT_M = 'Average'.
  LS_FIELDCAT-COL_POS   = 14.
  LS_FIELDCAT-OUTPUTLEN = 10.
  APPEND LS_FIELDCAT TO LT_FIELDCAT.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
*i_structure_name = '
      IS_LAYOUT          = LS_LAYOUT
      IT_FIELDCAT        = LT_FIELDCAT
    TABLES
      T_OUTTAB           = LT_YR_FINAL
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.

*    ******************************************************************************************

*----------------------------------------------------------------------------------------------*
*DATA: lo_custom_container TYPE REF TO cl_gui_custom_container,
*      lo_alv_grid   TYPE REF TO cl_gui_alv_grid,
*      ls_fcat       TYPE lvc_s_fcat,
*      lt_fcat       TYPE lvc_t_fcat,
*      ls_layout     type LVC_S_LAYO.
*
*ls_fcat-fieldname = 'LIFNR'.
*ls_fcat-scrtext_m = 'Vendor'. " Set the medium text
*ls_fcat-outputlen = 20.
**ls_fcat-optimize = 'X'.
*APPEND ls_fcat TO lt_fcat.
*CLEAR ls_fcat.
*
*ls_fcat-fieldname = 'NAME1'.
*ls_fcat-scrtext_m = 'Vendor Name'.
*ls_fcat-outputlen = 30.
**ls_fcat-optimize = 'X'.
*APPEND ls_fcat TO lt_fcat.
*CLEAR ls_fcat.
*
*ls_fcat-fieldname = 'PERIOD1'.
*ls_fcat-scrtext_m = lv_period1_name.
*ls_fcat-outputlen = 30.
**ls_fcat-optimize = 'X'.
*APPEND ls_fcat TO lt_fcat.
*CLEAR ls_fcat.
*
*ls_fcat-fieldname = 'PERIOD2'.
*ls_fcat-scrtext_m = lv_period2_name.
*ls_fcat-outputlen = 30.
**ls_fcat-optimize = 'X'.
*APPEND ls_fcat TO lt_fcat.
*CLEAR ls_fcat.
*
*CREATE OBJECT lo_custom_container
*      EXPORTING
*        container_name = 'CUSTOM_CONTAINER'. " Name of the custom control area in Screen Painter
*
*    CREATE OBJECT lo_alv_grid
*      EXPORTING
*        i_parent = lo_custom_container.
*
*CALL METHOD LO_ALV_GRID->SET_TABLE_FOR_FIRST_DISPLAY
*  EXPORTING
**    I_BUFFER_ACTIVE               =
**    I_BYPASSING_BUFFER            =
**    I_CONSISTENCY_CHECK           =
**    I_STRUCTURE_NAME              =
**    IS_VARIANT                    =
**    I_SAVE                        =
*    I_DEFAULT                     = 'X'
*    IS_LAYOUT                     = ls_layout
**    IS_PRINT                      =
**    IT_SPECIAL_GROUPS             =
**    IT_TOOLBAR_EXCLUDING          =
**    IT_HYPERLINK                  =
**    IT_ALV_GRAPHICS               =
**    IT_EXCEPT_QINFO               =
**    IR_SALV_ADAPTER               =
*  CHANGING
*    IT_OUTTAB                     = lt_yr_final[]
*    IT_FIELDCATALOG               = lt_fcat[]
**    IT_SORT                       =
**    IT_FILTER                     =
*  EXCEPTIONS
*    INVALID_PARAMETER_COMBINATION = 1
*    PROGRAM_ERROR                 = 2
*    TOO_MANY_LINES                = 3
*    OTHERS                        = 4
*        .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.
*




*----------------------------------------------------------------------------------------------*
*TRY.
*        " Create ALV object from internal table
*        cl_salv_table=>factory(
*          IMPORTING
*            r_salv_table = lo_alv
*          CHANGING
*            t_table      = lt_yr_final
*        ).
*
*DATA: lv_out_len TYPE lvc_outlen.
*
*        DATA(lo_column) = lo_alv->get_columns( )->get_column('PERIOD1').
*lo_column->set_medium_text( lv_period1_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*
* lo_column = lo_alv->get_columns( )->get_column('PERIOD2').
*lo_column->set_short_text( lv_period2_name ).
*lo_column->set_output_length( 15 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD3').
*lo_column->set_medium_text( lv_period3_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD4').
*lo_column->set_medium_text( lv_period4_name ).
*lv_out_len = 20.
*lo_column->set_output_length( lv_out_len ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD5').
*lo_column->set_medium_text( lv_period5_name ).
*lo_column->set_output_length( 35 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD6').
*lo_column->set_medium_text( lv_period6_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD7').
*lo_column->set_medium_text( lv_period7_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD8').
*lo_column->set_medium_text( lv_period8_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD9').
*lo_column->set_medium_text( lv_period9_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD10').
*lo_column->set_medium_text( lv_period10_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD11').
*lo_column->set_medium_text( lv_period11_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('PERIOD12').
*lo_column->set_medium_text( lv_period12_name ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*lo_column = lo_alv->get_columns( )->get_column('AVG').
*lo_column->set_medium_text( 'Average' ).
*lo_column->set_output_length( 20 ).
*lo_alv->get_columns( )->set_optimize( abap_true ).
*
*" Optional: Optimize column widths
**lo_alv->get_columns( )->set_optimize( abap_true ).
*
*"Enable default ALV toolbar functions
**lo_alv->get_functions( )->set_default( abap_true ).
**lo_display->set_list_header( 'This is our custom heading' ).
*
*lo_alv->get_layout( )->set_default( abap_true ).
*        " Display ALV
*        lo_alv->display( ).
*
*      CATCH cx_salv_msg INTO DATA(lx_msg).
*        MESSAGE lx_msg->get_text( ) TYPE 'E'.
*    ENDTRY.
ENDFORM.
