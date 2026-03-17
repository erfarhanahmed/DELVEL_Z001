REPORT z_alv_overview_request.
*---------------------------------------------------------------------*
* Overview transport requests for all systems and clients             *
*---------------------------------------------------------------------*
* Updated 22-May-15  14h00
*---------------------------------------------------------------------*
* Macro definition
DEFINE mac_line.
  selection-screen begin of block b0&1.
  selection-screen begin of line.
  selection-screen position 1.
  parameters p_pgmid&1 type sctsobject-pgmid  modif id out.
  parameters p_objct&1 type sctsobject-object value check.
  selection-screen position 11.
  parameters p_objtx&1 type sctsobject-text visible length 19
                       lower case modif id 2d.
  selection-screen position 31.
  parameters p_objnm&1 type ty_objnam.
  selection-screen:
    pushbutton 77(4) v_90&1 user-command zd&1.              "#EC NEEDED
  selection-screen end of line.
  selection-screen end of block b0&1.
END-OF-DEFINITION.
*---------------------------------------------------------------------*
* Macro definition
DEFINE mac_selection_screen.

at selection-screen on p_objct&1.

  perform f_selection_screen_object using p_objct&1
                                 changing p_pgmid&1
                                          p_objtx&1.

at selection-screen on block b0&1.

  if sscrfields-ucomm = 'ZD&1'.
    clear : p_pgmid&1, p_objct&1, p_objnm&1, p_objtx&1,
            gt_where&1.
  endif.

  perform f_selection_screen using p_objnm&1
                          changing p_pgmid&1
                                   p_objct&1
                                   gt_where&1.

at selection-screen on value-request for p_objnm&1.

  perform f_help_object_name using p_pgmid&1
                                   p_objct&1
                                   'P_OBJNM&1'
                                   'X'
                          changing p_objnm&1.

END-OF-DEFINITION.
DEFINE mac_sys.
  selection-screen begin of line.
  parameters p_&1 as checkbox.
  selection-screen comment 5(30) text_p&1 for field p_&1.
  selection-screen end of line.
END-OF-DEFINITION.
* Macro definition
DEFINE m_bdc_dynpro.
  clear ls_bdcdata.
  ls_bdcdata-program  = &1.
  ls_bdcdata-dynpro   = &2.
  ls_bdcdata-dynbegin = wc_x.
  append ls_bdcdata to lt_bdcdata.

  clear ls_bdcdata.
  ls_bdcdata-fnam     = 'BDC_OKCODE'.
  ls_bdcdata-fval     = &3.
  append ls_bdcdata to lt_bdcdata.
END-OF-DEFINITION.

DEFINE m_bdc_field.
  clear ls_bdcdata.
  ls_bdcdata-fnam = &1.
  ls_bdcdata-fval = &2.
  append ls_bdcdata to lt_bdcdata.
END-OF-DEFINITION.
*---------------------------------------------------------------------*
TABLES sscrfields.                     " Screen fields
*---------------------------------------------------------------------*
TYPE-POOLS slis.                       " Types for ALV
*---------------------------------------------------------------------*
TYPES:
  ty_trkorr     TYPE RANGE OF trkorr,
  ty_where_t    TYPE STANDARD TABLE OF char200,
  ty_objnam(43) TYPE c,
  BEGIN OF ty_e071.
        INCLUDE TYPE e071.
TYPES: checkbox TYPE char1,
 as4date TYPE as4date,
 as4time TYPE as4time,
 timestamp TYPE tstamp.
TYPES END OF ty_e071.

*---------------------------------------------------------------------*
DATA gt_tmstpalog TYPE tmstpalogs.
DATA gs_tmstpalog TYPE tmstpalog.
DATA gt_syslst    TYPE tmscsyslst_typ.
DATA gt_fieldcat  TYPE slis_t_fieldcat_alv.  " Field catalog
DATA gr_trkorr    TYPE ty_trkorr.
DATA gt_where1    TYPE ty_where_t.
DATA gt_where2    TYPE ty_where_t.
DATA gt_where3    TYPE ty_where_t.
DATA gt_where4    TYPE ty_where_t.
DATA gt_where5    TYPE ty_where_t.
DATA gt_e071      TYPE TABLE OF ty_e071.
DATA gt_object_texts TYPE tr_object_texts.
*---------------------------------------------------------------------*
FIELD-SYMBOLS
  <gt_data> TYPE STANDARD TABLE.       " Data to display
*---------------------------------------------------------------------*
CONSTANTS:
  c_20010101 TYPE datum      VALUE '20010101',
  c_eb9      TYPE syucomm    VALUE '&EB9',
  c_odn      TYPE syucomm    VALUE '&ODN',
  c_oup      TYPE syucomm    VALUE '&OUP',
  c_refresh  TYPE syucomm    VALUE '&REFRESH',
  c_zsyst    TYPE rvari_vnam VALUE 'ZSYST',
  c_0000     TYPE tvarv_numb VALUE '0000',
  c_p        TYPE rsscr_kind VALUE 'P',
  c_trkorr   TYPE fieldname  VALUE 'TRKORR',
  c_checkbox TYPE fieldname  VALUE 'CHECKBOX',
  c_colortab TYPE fieldname  VALUE 'COLORTAB',
  c_admin    TYPE char8      VALUE '_ADMIN',
  c_retcode  TYPE char8      VALUE '_RETCODE'.
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK bl0 WITH FRAME TITLE text-bl0.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text_100 FOR FIELD p_date_b.
PARAMETERS p_date_b TYPE dats OBLIGATORY.
SELECTION-SCREEN PUSHBUTTON 52(4) v_104 USER-COMMAND zinit. "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 57(4) v_100 USER-COMMAND datm7. "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 62(4) v_101 USER-COMMAND datm.  "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 67(4) v_102 USER-COMMAND datp.  "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 72(4) v_103 USER-COMMAND datp7. "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 77(4) v_105 USER-COMMAND dmax.  "#EC NEEDED
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(31) text_101 FOR FIELD p_date_e.
PARAMETERS p_date_e TYPE dats OBLIGATORY DEFAULT sy-datum.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(28) text_102 FOR FIELD s_trkorr.
SELECT-OPTIONS s_trkorr FOR gs_tmstpalog-trkorr VISIBLE LENGTH 10.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(28) text_103 FOR FIELD s_truser.
SELECT-OPTIONS s_truser FOR gs_tmstpalog-truser DEFAULT sy-uname
                        MATCHCODE OBJECT user_addr.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(28) text_104 FOR FIELD s_korrdv.
SELECT-OPTIONS s_korrdv FOR gs_tmstpalog-korrdev.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(28) text_105 FOR FIELD s_trfnct.
SELECT-OPTIONS s_trfnct FOR gs_tmstpalog-trfunction.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK bl0.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-bl1.
mac_line 1.
mac_line 2.
mac_line 3.
mac_line 4.
mac_line 5.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_ssobj AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_114 FOR FIELD p_ssobj.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE text-bl2.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_format AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_106 FOR FIELD p_format.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_nocolr AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_107 FOR FIELD p_nocolr.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_alvlst AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_108 FOR FIELD p_alvlst.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_iconrc AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_109 FOR FIELD p_iconrc.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_no_rc AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_110 FOR FIELD p_no_rc.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_nouser AS CHECKBOX DEFAULT wc_x.
SELECTION-SCREEN COMMENT 5(30) text_111 FOR FIELD p_nouser.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_sysid AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_112 FOR FIELD p_sysid.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_wrkb AS CHECKBOX.
SELECTION-SCREEN COMMENT 5(30) text_113 FOR FIELD p_wrkb.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_debug TYPE boole-boole.
SELECTION-SCREEN COMMENT 5(30) text_115 FOR FIELD p_debug.
SELECTION-SCREEN END OF LINE.

PARAMETERS p_call   TYPE flag   NO-DISPLAY.
PARAMETERS p_trkorr TYPE trkorr NO-DISPLAY.

SELECTION-SCREEN END OF BLOCK bl2.

SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE text-bl3.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON 02(4) v_200 USER-COMMAND zsel.  "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 10(4) v_201 USER-COMMAND zdesel. "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 18(4) v_202 USER-COMMAND ztvarv. "#EC NEEDED
SELECTION-SCREEN PUSHBUTTON 26(4) v_203 USER-COMMAND zmod.  "#EC NEEDED
SELECTION-SCREEN END OF LINE.
mac_sys 01.
mac_sys 02.
mac_sys 03.
mac_sys 04.
mac_sys 05.
mac_sys 06.
mac_sys 07.
mac_sys 08.
mac_sys 09.
mac_sys 10.
mac_sys 11.
mac_sys 12.
mac_sys 13.
mac_sys 14.
mac_sys 15.
mac_sys 16.
mac_sys 17.
mac_sys 18.
mac_sys 19.
mac_sys 20.
SELECTION-SCREEN END OF BLOCK bl3.

*---------------------------------------------------------------------*
LOAD-OF-PROGRAM.

* Get System list
  CALL FUNCTION 'TMS_CI_GET_SYSTEMLIST'
    EXPORTING
      iv_only_active              = wc_x
    TABLES
      tt_syslst                   = gt_syslst
    EXCEPTIONS
      tms_is_not_active           = 1
      invalid_ci_conf_with_domain = 2
      no_systems                  = 3
      OTHERS                      = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  SORT gt_syslst BY sysnam.

  PERFORM read_object_table CHANGING gt_object_texts.

  v_901 = v_902 = v_903 = v_904 = v_905 = '@11@'.

*---------------------------------------------------------------------*
  mac_selection_screen 1.
  mac_selection_screen 2.
  mac_selection_screen 3.
  mac_selection_screen 4.
  mac_selection_screen 5.
*---------------------------------------------------------------------*
AT SELECTION-SCREEN.

  IF sscrfields-ucomm = 'DATM'.
    SUBTRACT 1 FROM p_date_b.
    PERFORM f_datem CHANGING p_date_b.
  ELSEIF sscrfields-ucomm = 'DATM7'.
    SUBTRACT 7 FROM p_date_b.
    PERFORM f_datem CHANGING p_date_b.
  ELSEIF sscrfields-ucomm = 'DATP'.
    ADD 1 TO p_date_b.
    IF p_date_b > sy-datum.
      p_date_b = sy-datum.
    ENDIF.
    PERFORM f_datem CHANGING p_date_b.
  ELSEIF sscrfields-ucomm = 'DATP7'.
    ADD 7 TO p_date_b.
    IF p_date_b > sy-datum.
      p_date_b = sy-datum.
    ENDIF.
    PERFORM f_datem CHANGING p_date_b.
  ELSEIF sscrfields-ucomm = 'ZINIT'.
    p_sysid = wc_x.
    p_date_b = c_20010101.
  ELSEIF sscrfields-ucomm = 'DMAX'.
    p_date_e = sy-datum.
    p_date_b = sy-datum.
  ELSEIF sscrfields-ucomm = 'ZSEL'.
    PERFORM sel_desel USING 'X'.
  ELSEIF sscrfields-ucomm = 'ZDESEL'.
    PERFORM sel_desel USING ''.
  ELSEIF sscrfields-ucomm = 'ZTVARV'.
    PERFORM sel_tvarv.
  ELSEIF sscrfields-ucomm = 'ZMOD'.
    PERFORM mod_tvarv.
  ENDIF.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

  IF p_date_b IS INITIAL.
    p_date_b = sy-datum - 1.
  ENDIF.

  PERFORM at_selection_screen_output.

*---------------------------------------------------------------------*
INITIALIZATION.

  PERFORM initialization.

*---------------------------------------------------------------------*
START-OF-SELECTION.

* Stop for debugging if desired.
  IF p_debug NE space.
    SET EXTENDED CHECK OFF.
    BREAK-POINT.
    SET EXTENDED CHECK ON.
  ENDIF.

  IF p_call IS NOT INITIAL.
    DELETE gt_syslst WHERE sysnam(3) = 'ZLD' OR sysnam(3) = 'FRM'
                        OR sysnam(3) = 'TST'
                        OR sysnam(3) = 'DS0'.
  ENDIF.

  IF p_01 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p01(3). ENDIF.
  IF p_02 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p02(3). ENDIF.
  IF p_03 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p03(3). ENDIF.
  IF p_04 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p04(3). ENDIF.
  IF p_05 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p05(3). ENDIF.
  IF p_06 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p06(3). ENDIF.
  IF p_07 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p07(3). ENDIF.
  IF p_08 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p08(3). ENDIF.
  IF p_09 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p09(3). ENDIF.
  IF p_10 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p10(3). ENDIF.
  IF p_11 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p11(3). ENDIF.
  IF p_12 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p12(3). ENDIF.
  IF p_13 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p13(3). ENDIF.
  IF p_14 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p14(3). ENDIF.
  IF p_15 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p15(3). ENDIF.
  IF p_16 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p16(3). ENDIF.
  IF p_17 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p17(3). ENDIF.
  IF p_18 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p18(3). ENDIF.
  IF p_19 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p19(3). ENDIF.
  IF p_20 IS INITIAL. DELETE gt_syslst WHERE sysnam = text_p20(3). ENDIF.

  IF gt_syslst IS INITIAL.
    APPEND sy-sysid TO gt_syslst.
  ENDIF.

  PERFORM f_read.

*---------------------------------------------------------------------*
END-OF-SELECTION.

  IF p_alvlst IS INITIAL.
*   Switch List -> Grid
    SET PARAMETER ID 'SALV_SWITCH_TO_LIST' FIELD space.
  ELSE.
*   Switch Grid -> List
    SET PARAMETER ID 'SALV_SWITCH_TO_LIST' FIELD wc_x.
  ENDIF.

  PERFORM display_data.

*---------------------------------------------------------------------*
*      Form  f_read
*---------------------------------------------------------------------*
FORM f_read.

  LOOP AT s_trkorr.
    SHIFT s_trkorr-low LEFT DELETING LEADING space.
    s_trkorr-low = s_trkorr-low(10).
    SHIFT s_trkorr-high LEFT DELETING LEADING space.
    s_trkorr-high = s_trkorr-high(10).
    MODIFY s_trkorr.
  ENDLOOP.

  REFRESH gr_trkorr.
* Read object in requests
  PERFORM f_read_request USING gt_where1 space.
  PERFORM f_read_request USING gt_where2 space.
  PERFORM f_read_request USING gt_where3 space.
  PERFORM f_read_request USING gt_where4 space.
  PERFORM f_read_request USING gt_where5 space.
  PERFORM read_data.

ENDFORM.                               " F_READ
*---------------------------------------------------------------------*
*       Form  read_data
*---------------------------------------------------------------------*
FORM read_data.

  DEFINE m_component.
    clear ls_component.
    ls_component-name = &1.
    ls_component-type ?= cl_abap_elemdescr=>describe_by_name( &2 ).
    append ls_component to lt_component.
  END-OF-DEFINITION.

  DATA:
    l_system      TYPE char7,
    l_fname       TYPE fieldname,
    l_field       TYPE char20,
    lt_system     TYPE TABLE OF char7,
    ls_tabcolor   TYPE lvc_s_scol,
    lt_tabcolor   TYPE lvc_t_scol,
    lp_table      TYPE REF TO data,      " Pointer to dynamic table
    ls_fieldcat   TYPE slis_fieldcat_alv,
    ls_tmstpalog  TYPE tmstpalog,
    lt_tmstpalog_tmp TYPE tmstpalogs,
    ls_e070       TYPE e070,
    lt_e070       TYPE SORTED TABLE OF e070 WITH UNIQUE KEY trkorr,
    lp_struct     TYPE REF TO data,
    ls_tmscsys    TYPE tmscsyslst,
    lr_trkorr     TYPE ty_trkorr,
    ls_trkorr     LIKE LINE OF gr_trkorr,
    l_low         TYPE tvarv-low,
    l_high        TYPE tvarv-high,
    l_str_tmp     TYPE string,
    l_syst        TYPE sysysid,
    lt_syst       TYPE TABLE OF sysysid,
    lt_syst_save  TYPE TABLE OF char7.

* RTTS Declarations.
  DATA:
    lo_struct_typ   TYPE REF TO cl_abap_datadescr,
    lo_dyntable_typ TYPE REF TO cl_abap_tabledescr,
    ls_component    TYPE cl_abap_structdescr=>component,
    lt_component    TYPE cl_abap_structdescr=>component_table.

  FIELD-SYMBOLS:
    <ls_header> TYPE any,
    <lv_field>  TYPE any.

  REFRESH: gt_tmstpalog, gt_fieldcat.

  IF p_sysid IS NOT INITIAL.
    DELETE gt_syslst WHERE sysnam <> sy-sysid.
  ENDIF.

  IF <gt_data> IS ASSIGNED.
    REFRESH <gt_data>.
  ENDIF.

  APPEND LINES OF gr_trkorr TO lr_trkorr.
  APPEND LINES OF s_trkorr  TO lr_trkorr.

  LOOP AT gt_syslst INTO ls_tmscsys.
    PERFORM get_transport USING ls_tmscsys-sysnam
                                p_date_b
                                p_date_e
                                lr_trkorr.
  ENDLOOP.

  DELETE gt_tmstpalog WHERE truser NOT IN s_truser
                         OR trfunction NOT IN s_trfnct.

  IF gt_tmstpalog[] IS NOT INITIAL.

    REFRESH lr_trkorr.
    LOOP AT gt_tmstpalog INTO ls_tmstpalog.
      ls_trkorr-sign = 'I'.
      ls_trkorr-option = 'EQ'.
      ls_trkorr-low = ls_tmstpalog-trkorr.
      APPEND ls_trkorr TO lr_trkorr.
    ENDLOOP.

    SORT lr_trkorr.
    DELETE ADJACENT DUPLICATES FROM lr_trkorr.

    IF NOT ( p_date_b = c_20010101 AND p_date_e = sy-datum ).
      REFRESH gt_tmstpalog.
      LOOP AT gt_syslst INTO ls_tmscsys.
        PERFORM get_transport USING ls_tmscsys-sysnam
                                    c_20010101
                                    sy-datum
                                    lr_trkorr.
      ENDLOOP.
    ENDIF.
  ENDIF.

  lt_tmstpalog_tmp[] = gt_tmstpalog[].
  SORT lt_tmstpalog_tmp BY trkorr.
  DELETE ADJACENT DUPLICATES FROM lt_tmstpalog_tmp COMPARING trkorr.

  IF lt_tmstpalog_tmp[] IS NOT INITIAL.
*   Lecture  en-tête ordres/tâches
    SELECT * FROM e070 INTO TABLE lt_e070
          FOR ALL ENTRIES IN lt_tmstpalog_tmp
            WHERE trkorr = lt_tmstpalog_tmp-trkorr
              AND korrdev IN s_korrdv.
  ENDIF.

  SORT gt_tmstpalog BY listname trcli trtime.

  LOOP AT gt_tmstpalog INTO ls_tmstpalog.
    READ TABLE lt_e070 WITH KEY trkorr = ls_tmstpalog-trkorr
                   TRANSPORTING NO FIELDS.
    CHECK sy-subrc IS NOT INITIAL.
    DELETE gt_tmstpalog.
  ENDLOOP.

  READ TABLE lt_e070 INDEX 1 INTO ls_e070.

  LOOP AT gt_tmstpalog INTO ls_tmstpalog WHERE listname(3) = sy-sysid.
    IF p_wrkb IS INITIAL.
      CONCATENATE ls_tmstpalog-listname(3) '_' ls_tmstpalog-trcli
             INTO l_system.
    ELSE.
      CONCATENATE ls_tmstpalog-listname(3) '_'
             INTO l_system.
    ENDIF.
    READ TABLE lt_system WITH TABLE KEY table_line = l_system
                      TRANSPORTING NO FIELDS.
    IF sy-subrc IS NOT INITIAL.
      APPEND l_system TO lt_system.
    ENDIF.
  ENDLOOP.

  LOOP AT gt_tmstpalog INTO ls_tmstpalog
                      WHERE listname(3) = ls_e070-tarsystem.
    IF p_wrkb IS INITIAL.
      CONCATENATE ls_tmstpalog-listname(3) '_' ls_tmstpalog-trcli
             INTO l_system.
    ELSE.
      CONCATENATE ls_tmstpalog-listname(3) '_'
             INTO l_system.
    ENDIF.
    READ TABLE lt_system WITH TABLE KEY table_line = l_system
                      TRANSPORTING NO FIELDS.
    IF sy-subrc IS NOT INITIAL.
      APPEND l_system TO lt_system.
    ENDIF.
  ENDLOOP.

  LOOP AT gt_tmstpalog INTO ls_tmstpalog
                      WHERE listname(3) <> sy-sysid
                        AND listname(3) <> ls_e070-tarsystem.
    IF p_wrkb IS INITIAL.
      CONCATENATE ls_tmstpalog-listname(3) '_' ls_tmstpalog-trcli
             INTO l_system.
    ELSE.
      CONCATENATE ls_tmstpalog-listname(3) '_'
             INTO l_system.
    ENDIF.
    READ TABLE lt_system WITH TABLE KEY table_line = l_system
                      TRANSPORTING NO FIELDS.
    IF sy-subrc IS NOT INITIAL.
      APPEND l_system TO lt_system.
    ENDIF.
  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM lt_system.

* Read System-Color in table TVARV
  SELECT SINGLE low high INTO (l_low, l_high) FROM tvarv
   WHERE name = c_zsyst AND numb = c_0000 AND type = c_p AND sign = ''.
  CONCATENATE l_low l_high INTO l_str_tmp.
  SPLIT l_str_tmp AT '/' INTO TABLE lt_syst.
  IF lt_syst[] IS NOT INITIAL.
    lt_syst_save = lt_system.
    REFRESH lt_system.
    LOOP AT lt_syst INTO l_syst.
      LOOP AT lt_syst_save INTO l_system.
        IF l_system(3) = l_syst(3).
          APPEND l_system TO lt_system.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDIF.

  m_component c_checkbox 'LVC_CHECKB'.

  IF p_nocolr IS INITIAL.
    m_component c_colortab 'LVC_T_SCOL'.
  ENDIF.

  m_component c_trkorr c_trkorr.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = c_trkorr.
  ls_fieldcat-ref_tabname = 'E070'.
  ls_fieldcat-hotspot = wc_x.
  ls_fieldcat-key = wc_x.
  APPEND ls_fieldcat TO gt_fieldcat.

  m_component 'AS4TEXT' 'AS4TEXT'.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'AS4TEXT'.
  ls_fieldcat-ref_tabname = 'TMSTPALOG'.
  ls_fieldcat-key = wc_x.
  APPEND ls_fieldcat TO gt_fieldcat.

  m_component 'TRFUNCTION' 'TRFUNCTION'.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'TRFUNCTION'.
  ls_fieldcat-rollname = 'TRFUNCTION'.
  APPEND ls_fieldcat TO gt_fieldcat.

  m_component 'KORRDEV' 'TRCATEG'.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'KORRDEV'.
  ls_fieldcat-rollname = 'TRCATEG'.
  APPEND ls_fieldcat TO gt_fieldcat.

  m_component 'AS4USER' 'TR_AS4USER'.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname = 'AS4USER'.
  ls_fieldcat-ref_tabname = 'E070'.
  APPEND ls_fieldcat TO gt_fieldcat.

  LOOP AT lt_system INTO l_system.
*   For each line, a column is created in the fieldcatalog
*   Build Fieldcatalog
    IF p_format = wc_x.
      m_component l_system 'DATUM'.
    ELSE.
      m_component l_system 'TSTAMP'.
    ENDIF.

*   Build Fieldcatalog
    CLEAR ls_fieldcat.
    ls_fieldcat-fieldname = l_system.
    IF p_format = wc_x.
*     ls_fieldcat-ref_fieldname = 'DATUM'.
*     ls_fieldcat-ref_tabname = 'SYST'.
      ls_fieldcat-rollname = 'DATUM'.
    ELSE.
      ls_fieldcat-ref_fieldname = 'TRTIME'.
      ls_fieldcat-ref_tabname = 'TMSTPALOG'.
*     ls_fieldcat-edit_mask = '==TSTPS'.
      ls_fieldcat-edit_mask = '==TSTLC'.
    ENDIF.
    ls_fieldcat-seltext_s = l_system.
    ls_fieldcat-seltext_m = l_system.
    ls_fieldcat-seltext_l = l_system.
    ls_fieldcat-just = 'C'.
    APPEND ls_fieldcat TO gt_fieldcat.

    IF p_no_rc IS INITIAL.
      CONCATENATE l_system c_retcode INTO l_fname.
      m_component l_fname 'TRRETCODE'.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = l_fname.
      IF p_iconrc IS NOT INITIAL.
        ls_fieldcat-ref_fieldname = 'RETCODE'.
        ls_fieldcat-ref_tabname = 'TMSTPALOG'.
        ls_fieldcat-no_zero = wc_x.
      ELSE.
        ls_fieldcat-inttype = 'C'.
        ls_fieldcat-outputlen = 30.
        ls_fieldcat-icon = wc_x.
        ls_fieldcat-seltext_s = ls_fieldcat-seltext_m
                              = ls_fieldcat-seltext_l = 'RC'.
      ENDIF.
      APPEND ls_fieldcat TO gt_fieldcat.
    ENDIF.

    IF p_nouser IS INITIAL.
      CONCATENATE l_system c_admin INTO l_fname.

      m_component l_fname 'AS4USER'.

      CLEAR ls_fieldcat.
      ls_fieldcat-fieldname = l_fname.
      ls_fieldcat-ref_fieldname = 'ADMIN'.
      ls_fieldcat-ref_tabname = 'TMSTPALOG'.
      APPEND ls_fieldcat TO gt_fieldcat.
    ENDIF.

  ENDLOOP.

  IF <gt_data> IS NOT ASSIGNED.
*   Create internal table
    lo_struct_typ  ?= cl_abap_structdescr=>create( p_components = lt_component ).
    lo_dyntable_typ = cl_abap_tabledescr=>create( p_line_type = lo_struct_typ ).

    CREATE DATA lp_table TYPE HANDLE lo_dyntable_typ.
    ASSIGN lp_table->* TO <gt_data>.
  ENDIF.

  IF <ls_header> IS NOT ASSIGNED.
*   Create structure = structure of the internal table
    CREATE DATA lp_struct LIKE LINE OF <gt_data>.
    ASSIGN lp_struct->* TO <ls_header>.
  ENDIF.

  IF p_nocolr IS INITIAL.
    LOOP AT gt_fieldcat INTO ls_fieldcat WHERE fieldname <> c_checkbox
                                           AND fieldname <> c_colortab.
      CLEAR ls_tabcolor.
      ls_tabcolor-fname = ls_fieldcat-fieldname.

      IF ls_tabcolor-fname+3(1) = '_'.
        IF lt_syst[] IS INITIAL.
          CASE ls_tabcolor-fname(3).
            WHEN ls_e070-tarsystem.
              ls_tabcolor-color-col = 5.
            WHEN sy-sysid.
              ls_tabcolor-color-col = 3.
            WHEN OTHERS.
              ls_tabcolor-color-col = 6.
          ENDCASE.
        ELSE.
          READ TABLE lt_syst
          WITH KEY table_line(3) = ls_tabcolor-fname(3) INTO l_syst.
          IF sy-subrc IS INITIAL AND l_syst+3(1) CA '123456'.
            ls_tabcolor-color-col = l_syst+3(1).
          ENDIF.
        ENDIF.
      ELSE.
        ls_tabcolor-color-col = 4.
      ENDIF.

      APPEND ls_tabcolor TO lt_tabcolor.
    ENDLOOP.
  ENDIF.

  IF p_wrkb IS INITIAL.
    SORT gt_tmstpalog BY trkorr listname trtime.
  ELSE.
    SORT gt_tmstpalog BY trkorr listname trtime DESCENDING.
    DELETE ADJACENT DUPLICATES FROM gt_tmstpalog COMPARING trkorr listname.
  ENDIF.

* Fill the internal to display <gt_data>
  LOOP AT lt_e070 INTO ls_e070.
    CLEAR <ls_header>.
    ASSIGN COMPONENT 'AS4USER' OF STRUCTURE <ls_header> TO <lv_field>.
    IF sy-subrc EQ 0.
      <lv_field> = ls_e070-as4user.
    ENDIF.

    LOOP AT gt_tmstpalog INTO ls_tmstpalog
                        WHERE trkorr = ls_e070-trkorr.

      MOVE-CORRESPONDING ls_tmstpalog TO <ls_header>.

      IF p_wrkb IS INITIAL.
        CONCATENATE ls_tmstpalog-listname(3) '_' ls_tmstpalog-trcli
               INTO l_system.
      ELSE.
        CONCATENATE ls_tmstpalog-listname(3) '_'
               INTO l_system.
      ENDIF.
      APPEND l_system TO lt_system.

      ASSIGN COMPONENT l_system OF STRUCTURE <ls_header> TO <lv_field>.
      IF sy-subrc EQ 0.
        <lv_field> = ls_tmstpalog-trtime.
      ENDIF.

      CONCATENATE l_system c_retcode INTO l_field.
      ASSIGN COMPONENT l_field OF STRUCTURE <ls_header> TO <lv_field>.
      IF sy-subrc IS INITIAL.
        IF p_iconrc IS NOT INITIAL.
          <lv_field> = ls_tmstpalog-retcode.
        ELSE.
          CASE ls_tmstpalog-retcode.
            WHEN '0000'.
            WHEN '0004'.
              <lv_field> = '@5D@'.
            WHEN '0008'.
              <lv_field> = '@5C@'.
            WHEN OTHERS.
              <lv_field> = '@5C@'.
          ENDCASE.
        ENDIF.
      ENDIF.

      CONCATENATE l_system c_admin INTO l_field.
      ASSIGN COMPONENT l_field OF STRUCTURE <ls_header> TO <lv_field>.
      IF sy-subrc IS INITIAL.
        <lv_field> = ls_tmstpalog-admin.
      ENDIF.

    ENDLOOP.

    ASSIGN COMPONENT 'KORRDEV' OF STRUCTURE <ls_header> TO <lv_field>.
    IF sy-subrc EQ 0.
      MOVE ls_e070-korrdev TO <lv_field>.
    ENDIF.

    IF p_nocolr IS INITIAL.
      ASSIGN COMPONENT c_colortab OF STRUCTURE <ls_header>
                                            TO <lv_field>.
      IF sy-subrc EQ 0.
        MOVE lt_tabcolor TO <lv_field>.
      ENDIF.
    ENDIF.

    APPEND <ls_header> TO <gt_data>.
  ENDLOOP.

  IF p_trkorr IS NOT INITIAL.
    LOOP AT <gt_data> ASSIGNING <ls_header>.
      ASSIGN COMPONENT c_trkorr OF STRUCTURE <ls_header>
                    TO <lv_field>.
      CHECK sy-subrc IS INITIAL.
      CHECK <lv_field> = p_trkorr.
      ASSIGN COMPONENT c_checkbox OF STRUCTURE <ls_header>
                    TO <lv_field>.
      CHECK sy-subrc IS INITIAL.
      <lv_field> = wc_x.
      EXIT.                            " Exit Loop
    ENDLOOP.
  ENDIF.

ENDFORM.                               " READ_DATA
*---------------------------------------------------------------------*
*       Form  get_transport
*---------------------------------------------------------------------*
FORM get_transport USING u_tmssysnam TYPE tmssysnam
                         u_startdate TYPE dats
                         u_enddate   TYPE dats
                         ur_trkorr   TYPE ty_trkorr.

  DATA:
    l_exp  TYPE flag,
    lt_log TYPE tmstpalogs.

  IF u_tmssysnam = sy-sysid.
    l_exp = wc_x.
  ENDIF.

  CALL FUNCTION 'TMS_TM_GET_TRLIST'
    EXPORTING
      iv_system      = u_tmssysnam
      iv_startdate   = u_startdate
      iv_starttime   = '000000'
      iv_enddate     = u_enddate
      iv_endtime     = '240000'
      iv_allcli      = wc_x
      iv_imports     = wc_x
      iv_exports     = l_exp
      iv_last_import = wc_x
    IMPORTING
      et_tmstpalog   = lt_log
    TABLES
      irt_requests   = ur_trkorr
    EXCEPTIONS
      alert          = 1
      OTHERS         = 2.

  APPEND LINES OF lt_log TO gt_tmstpalog.

ENDFORM.                               " GET_TRANSPORT
*---------------------------------------------------------------------*
*       Form  display_data
*---------------------------------------------------------------------*
FORM display_data.

  DATA:
    ls_layout     TYPE slis_layout_alv,
    ls_fieldcat   TYPE slis_fieldcat_alv,
    ls_event_exit TYPE slis_event_exit,
    lt_event_exit TYPE slis_t_event_exit,
    ls_print      TYPE slis_print_alv,
    ls_sort       TYPE slis_sortinfo_alv,
    lt_sort       TYPE slis_t_sortinfo_alv.

* IF p_alvlst IS INITIAL.
  ls_layout-box_fieldname = c_checkbox.
* ENDIF.
  ls_layout-colwidth_optimize = wc_x.
  ls_layout-group_change_edit = wc_x.
  ls_layout-allow_switch_to_list = wc_x.

  IF p_nocolr IS INITIAL.
    ls_layout-coltab_fieldname = c_colortab.
  ENDIF.

* Activate button
  CLEAR ls_event_exit.
  ls_event_exit-ucomm = c_eb9.         " More
  ls_event_exit-after = wc_x.
  APPEND ls_event_exit TO lt_event_exit.
  ls_event_exit-ucomm = c_odn.
  ls_event_exit-after = wc_x.
  APPEND ls_event_exit TO lt_event_exit.
  ls_event_exit-ucomm = c_oup.
  ls_event_exit-after = wc_x.
  APPEND ls_event_exit TO lt_event_exit.
  ls_event_exit-ucomm = c_refresh.     " Refresh
  ls_event_exit-after = wc_x.
  APPEND ls_event_exit TO lt_event_exit.

* Build Sort Table
  LOOP AT gt_fieldcat INTO ls_fieldcat WHERE fieldname(3) = sy-sysid.
    ls_sort-fieldname = ls_fieldcat-fieldname.
    APPEND ls_sort TO lt_sort.
    EXIT.
  ENDLOOP.
  IF sy-subrc IS NOT INITIAL.
    ls_sort-fieldname = c_trkorr.
    APPEND ls_sort TO lt_sort.
  ENDIF.

  IF ls_sort-fieldname IS NOT INITIAL.
    TRY.
        SORT <gt_data> BY (ls_sort-fieldname).
      CATCH cx_sy_dyn_table_ill_comp_val.
        MESSAGE 'Wrong column name!' TYPE 'I'.
    ENDTRY.
  ENDIF.

  PERFORM f_modify_color.

  ls_print-no_print_selinfos  = wc_x.   " Display no selection infos
  ls_print-no_print_listinfos = wc_x.   " Display no listinfos

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-cprog
      i_callback_user_command  = 'USER_COMMAND'
      i_callback_pf_status_set = 'PF_STATUS_SET'
      it_fieldcat              = gt_fieldcat
      it_sort                  = lt_sort
      is_layout                = ls_layout
      is_print                 = ls_print
      it_event_exit            = lt_event_exit
      i_save                   = 'A'
    TABLES
      t_outtab                 = <gt_data>.

ENDFORM.                               " DISPLAY_DATA
*---------------------------------------------------------------------*
*       Form  user_command
*---------------------------------------------------------------------*
FORM user_command USING u_ucomm     TYPE syucomm            "#EC CALLED
                        us_selfield TYPE slis_selfield.

  DATA:
*  lv_tcode   TYPE tcode,
   ls_sort    TYPE abap_sortorder,
   lt_sort    TYPE abap_sortorder_tab,
   ls_sortalv TYPE slis_sortinfo_alv,
   lt_sortalv TYPE slis_t_sortinfo_alv,
   lp_struct  TYPE REF TO data.

  FIELD-SYMBOLS:
    <ls_header> TYPE any,
    <lv_trkorr> TYPE any.

  CASE u_ucomm.
    WHEN '&IC1'.
*     Create structure = structure of the internal table
      CREATE DATA lp_struct LIKE LINE OF <gt_data>.
      ASSIGN lp_struct->* TO <ls_header>.
      READ TABLE <gt_data> ASSIGNING <ls_header>
                               INDEX us_selfield-tabindex.
      CHECK sy-subrc EQ 0.
      ASSIGN COMPONENT c_trkorr OF STRUCTURE <ls_header>
                    TO <lv_trkorr>.
      CHECK sy-subrc EQ 0.
      CASE us_selfield-fieldname.
        WHEN c_trkorr.
          CALL FUNCTION 'TR_PRESENT_REQUEST'
            EXPORTING
              iv_trkorr    = <lv_trkorr>
              iv_highlight = wc_x.
      ENDCASE.
    WHEN c_refresh.
      PERFORM f_read.

*     Read current ALV list information
      CALL FUNCTION 'REUSE_ALV_GRID_LAYOUT_INFO_GET'
        IMPORTING
          et_sort       = lt_sortalv
        EXCEPTIONS
          no_infos      = 1
          program_error = 2
          OTHERS        = 3.

      LOOP AT lt_sortalv INTO ls_sortalv.
        CLEAR ls_sort.
        ls_sort-name = ls_sortalv-fieldname.
        ls_sort-descending = ls_sortalv-down.
        APPEND ls_sort TO lt_sort.
      ENDLOOP.

      IF lt_sort IS NOT INITIAL.
        TRY.
            SORT <gt_data> BY (lt_sort).
          CATCH cx_sy_dyn_table_ill_comp_val.
            MESSAGE 'Wrong column name!' TYPE 'I'.
        ENDTRY.
      ENDIF.

      PERFORM f_modify_color.
      us_selfield-refresh = wc_x.
    WHEN c_eb9.
      PERFORM f_show_objects.
    WHEN c_oup OR c_odn.
      PERFORM f_modify_color.
  ENDCASE.

ENDFORM.                               " USER_COMMAND
*---------------------------------------------------------------------*
*       FORM PF_STATUS_SET                                            *
*---------------------------------------------------------------------*
FORM pf_status_set USING ut_extab TYPE slis_t_extab.        "#EC CALLED

* Display refresh button
  DELETE ut_extab WHERE fcode = c_refresh OR fcode = c_eb9.

  SET PF-STATUS 'STANDARD_FULLSCREEN' OF PROGRAM 'SAPLKKBL'
      EXCLUDING ut_extab.

ENDFORM.                               " PF_STATUS_SET
*---------------------------------------------------------------------*
*      Form  at_selection_screen_output
*---------------------------------------------------------------------*
FORM at_selection_screen_output.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'OUT'.
        screen-input      = '0'.
      WHEN '2D'.
        screen-input      = '0'.
        screen-display_3d = '0'.
    ENDCASE.
    CASE screen-name.
      WHEN 'P_01' OR 'TEXT_P01'. IF text_p01 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_02' OR 'TEXT_P02'. IF text_p02 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_03' OR 'TEXT_P03'. IF text_p03 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_04' OR 'TEXT_P04'. IF text_p04 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_05' OR 'TEXT_P05'. IF text_p05 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_06' OR 'TEXT_P06'. IF text_p06 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_07' OR 'TEXT_P07'. IF text_p07 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_08' OR 'TEXT_P08'. IF text_p08 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_09' OR 'TEXT_P09'. IF text_p09 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_10' OR 'TEXT_P10'. IF text_p10 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_11' OR 'TEXT_P11'. IF text_p11 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_12' OR 'TEXT_P12'. IF text_p12 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_13' OR 'TEXT_P13'. IF text_p13 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_14' OR 'TEXT_P14'. IF text_p14 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_15' OR 'TEXT_P15'. IF text_p15 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_16' OR 'TEXT_P16'. IF text_p16 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_17' OR 'TEXT_P17'. IF text_p17 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_18' OR 'TEXT_P18'. IF text_p18 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_19' OR 'TEXT_P19'. IF text_p19 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'P_20' OR 'TEXT_P20'. IF text_p20 IS INITIAL. screen-invisible = '1'. ENDIF.
      WHEN 'V_202'.
        SELECT COUNT(*) FROM tvarv
         WHERE name = c_zsyst AND numb = c_0000 AND type = c_p.
        IF sy-subrc IS NOT INITIAL.
          screen-invisible = '1'.
        ENDIF.
      WHEN 'V_203'.
        IF sy-uname <> 'XXXXXX'.
          screen-invisible = '1'.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.                               " AT_SELECTION_SCREEN_OUTPUT
*---------------------------------------------------------------------*
*      Form  f_selection_screen
*---------------------------------------------------------------------*
FORM f_selection_screen USING u_objnam TYPE ty_objnam
                     CHANGING u_pgmid  TYPE pgmid
                              u_object TYPE trobjtype
                              ut_where TYPE ty_where_t.

  DATA:
    l_temp1   TYPE char100,
    l_temp2   TYPE char100,
    l_temp3   TYPE char100,
    l_where   TYPE char200,
    lt_where  TYPE ty_where_t.

  IF u_object IS INITIAL AND u_objnam IS NOT INITIAL.
    SELECT SINGLE pgmid object
             INTO (u_pgmid, u_object)
             FROM tadir
            WHERE obj_name = u_objnam.
  ENDIF.

  CHECK u_pgmid IS NOT INITIAL AND
        u_object IS NOT INITIAL AND
        u_objnam IS NOT INITIAL.

* Build dynamic where
  CONCATENATE '''' sy-sysid '%' '''' INTO l_where.
  CONCATENATE 'A~TRKORR LIKE ' l_where 'AND' INTO l_where
    SEPARATED BY space.
  APPEND l_where TO lt_where.

  APPEND '(' TO lt_where.

  CONCATENATE '''' u_pgmid '''' INTO l_temp1.
  CONCATENATE 'PGMID = ' l_temp1 'AND' INTO l_temp1
    SEPARATED BY space.

  CONCATENATE '''' u_object '''' INTO l_temp2.
  CONCATENATE 'OBJECT = ' l_temp2 'AND' INTO l_temp2
    SEPARATED BY space.

  CONCATENATE '''' u_objnam '''' INTO l_temp3.
  IF u_objnam CS '*'.
    TRANSLATE l_temp3 USING '*%'.
    CONCATENATE 'OBJ_NAME LIKE ' l_temp3 INTO l_temp3
      SEPARATED BY space.
  ELSEIF u_objnam CS '+'.
    TRANSLATE l_temp3 USING '+_'.
    CONCATENATE 'OBJ_NAME LIKE ' l_temp3 INTO l_temp3
      SEPARATED BY space.
  ELSE.
    CONCATENATE 'OBJ_NAME = ' l_temp3 INTO l_temp3
      SEPARATED BY space.
  ENDIF.

  CONCATENATE l_temp1 l_temp2 l_temp3 INTO l_where SEPARATED BY space.
  APPEND l_where TO lt_where.

  PERFORM f_subobject USING u_pgmid u_object u_objnam CHANGING lt_where.

  APPEND ')' TO lt_where.

* Read object in requests
  PERFORM f_read_request USING lt_where wc_x.

  ut_where[] = lt_where[].

ENDFORM.                               " F_SELECTION_SCREEN
*---------------------------------------------------------------------*
*      Form  F_HELP_OBJECT_NAME
*---------------------------------------------------------------------*
FORM f_help_object_name USING u_pgmid  TYPE pgmid
                              u_object TYPE trobjtype
                              u_field  TYPE fieldname
                              u_no_tmp TYPE flag
                     CHANGING u_objnam TYPE c.

  TYPES:
    BEGIN OF ty_values,
      object   TYPE trobjtype,
      obj_name TYPE sobj_name,
    END OF ty_values.

  DATA:
    l_dynprofld TYPE dynfnam,
    lt_where    TYPE ty_where_t,
    lt_values   TYPE TABLE OF ty_values,
    ls_return   TYPE ddshretval,
    lt_return   TYPE dmc_ddshretval_table,
    ls_dynpread TYPE dynpread,
    lt_dynpread TYPE TABLE OF dynpread,
    l_dynnum    TYPE sy-dynnr,
    l_progname  TYPE sy-repid,
    ls_condtab  TYPE hrcond,
    lt_condtab  TYPE TABLE OF hrcond.

  CHECK u_pgmid = 'R3TR'.

  l_progname = sy-cprog.
  l_dynnum   = sy-dynnr.

  ls_dynpread-fieldname = u_field.
  APPEND ls_dynpread TO lt_dynpread.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname             = l_progname
      dynumb             = l_dynnum
      translate_to_upper = wc_x
    TABLES
      dynpfields         = lt_dynpread.

  READ TABLE lt_dynpread INDEX 1 INTO ls_dynpread.

  ls_condtab-field = 'I'.
  ls_condtab-opera = 'EQ'.
  ls_condtab-field = 'PGMID'.
  ls_condtab-low  = 'R3TR'.
  APPEND ls_condtab TO lt_condtab.

  ls_condtab-opera = 'EQ'.
  ls_condtab-field = 'OBJECT'.
  ls_condtab-low  = u_object.
  APPEND ls_condtab TO lt_condtab.

  IF u_no_tmp = 'X'.
    ls_condtab-opera = 'NE'.
    ls_condtab-field = 'DEVCLASS'.
    ls_condtab-low  = '$TMP'.
    APPEND ls_condtab TO lt_condtab.
  ENDIF.

  IF ls_dynpread-fieldvalue CS '*' OR ls_dynpread-fieldvalue CS '+'.
    TRANSLATE ls_dynpread-fieldvalue USING '*%'.
    ls_condtab-opera = 'LK'.
    ls_condtab-field = 'OBJ_NAME'.
    ls_condtab-low  = ls_dynpread-fieldvalue.
    APPEND ls_condtab TO lt_condtab.
  ENDIF.

  CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
    EXPORTING
      dbtable         = 'TADIR'
    TABLES
      condtab         = lt_condtab
      where_clause    = lt_where
    EXCEPTIONS
      empty_condtab   = 1
      no_db_field     = 2
      unknown_db      = 3
      wrong_condition = 4
      OTHERS          = 5.

* Lecture de TADIR
  SELECT object obj_name
    INTO TABLE lt_values
      UP TO 500 ROWS
    FROM tadir
   WHERE (lt_where).

  l_dynprofld = u_field.

* F4 help
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = u_field
      dynpprog        = l_progname
      dynpnr          = l_dynnum
      dynprofield     = l_dynprofld
      value_org       = 'S'
    TABLES
      value_tab       = lt_values
      return_tab      = lt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CHECK lt_return[] IS NOT INITIAL.
  READ TABLE lt_return INDEX 1 INTO ls_return.
  u_objnam = ls_return-fieldval.

ENDFORM.                               " F_HELP_OBJECT_NAME
*---------------------------------------------------------------------*
*      Form  f_selection_screen_object
*---------------------------------------------------------------------*
FORM f_selection_screen_object USING u_object TYPE trobjtype
                            CHANGING u_pgmid  TYPE pgmid
                                     u_objtxt TYPE trtext.

  DATA ls_object_text TYPE ko100.

  CHECK u_object IS NOT INITIAL.

  READ TABLE gt_object_texts INTO ls_object_text
    WITH KEY object = u_object.
  IF sy-subrc <> 0.
*   Sélectionnez un type d'objet valide
    MESSAGE e870(tk).
  ELSE.
    u_pgmid = ls_object_text-pgmid.
    u_objtxt = ls_object_text-text.
  ENDIF.

ENDFORM.                               " F_SELECTION_SCREEN_OBJECT
*---------------------------------------------------------------------*
*      Form  READ_OBJECT_TABLE
*---------------------------------------------------------------------*
FORM read_object_table CHANGING ut_object_texts TYPE tr_object_texts.

  CHECK ut_object_texts[] IS INITIAL.

* Get Object Text
  CALL FUNCTION 'TR_OBJECT_TABLE'
    TABLES
      wt_object_text = ut_object_texts.

  DELETE ut_object_texts WHERE pgmid <> 'R3TR'
                           AND pgmid <> 'R3OB'
                           AND pgmid <> 'LIMU'
                           AND pgmid <> 'CORR'.

  SORT ut_object_texts BY pgmid object.

ENDFORM.                               " READ_OBJECT_TABLE
*---------------------------------------------------------------------*
*      Form  f_read_request
*---------------------------------------------------------------------*
FORM f_read_request USING ut_where TYPE ty_where_t
                          u_flag   TYPE xfeld.

  DATA:
    l_max     TYPE i,
    lr_trkorr TYPE ty_trkorr.

  FIELD-SYMBOLS
    <ls_trkorr> LIKE LINE OF lr_trkorr.

  CHECK ut_where[] IS NOT INITIAL.

  IF u_flag IS INITIAL.
    l_max = 1000000.
  ELSE.
    l_max = 1.
  ENDIF.

  SELECT a~trkorr AS low
    INTO CORRESPONDING FIELDS OF TABLE lr_trkorr
    FROM e071 AS a
    JOIN e070 AS b
      ON a~trkorr = b~trkorr
      UP TO l_max ROWS
   WHERE (ut_where)
     AND as4user IN s_truser
     AND as4date BETWEEN p_date_b AND p_date_e
     AND trfunction IN s_trfnct
     AND korrdev IN s_korrdv
     AND trstatus = 'R'
     AND strkorr = space.
  IF sy-subrc IS NOT INITIAL AND u_flag EQ wc_x.
    MESSAGE e208(00) WITH 'No requests found'(001).
  ENDIF.

  CHECK u_flag IS INITIAL.

  LOOP AT lr_trkorr ASSIGNING <ls_trkorr>.
    <ls_trkorr>-sign = 'I'.
    <ls_trkorr>-option = 'EQ'.
  ENDLOOP.

  APPEND LINES OF lr_trkorr TO gr_trkorr.

  SORT gr_trkorr.
  DELETE ADJACENT DUPLICATES FROM gr_trkorr.

ENDFORM.                               " F_READ_REQUEST
*---------------------------------------------------------------------*
*      Form  f_show_objects
*---------------------------------------------------------------------*
FORM f_show_objects.

  DATA:
    ls_layout   TYPE slis_layout_alv,
    lp_struct   TYPE REF TO data,
    lt_e071     TYPE TABLE OF ty_e071,
    lt_trkorr   TYPE TABLE OF trkorr,
    ls_sort     TYPE slis_sortinfo_alv,
    lt_sort     TYPE slis_t_sortinfo_alv,
    ls_fieldcat TYPE slis_fieldcat_alv,
    lt_fieldcat TYPE slis_t_fieldcat_alv. " Field catalog

  FIELD-SYMBOLS:
    <ls_header> TYPE any,
    <lv_field>  TYPE any.

* Create structure = structure of the internal table
  CREATE DATA lp_struct LIKE LINE OF <gt_data>.
  ASSIGN lp_struct->* TO <ls_header>.

  LOOP AT <gt_data> ASSIGNING <ls_header>.
    ASSIGN COMPONENT c_checkbox OF STRUCTURE <ls_header>
                  TO <lv_field>.
    CHECK sy-subrc IS INITIAL.
    CHECK <lv_field> EQ wc_x.
    ASSIGN COMPONENT c_trkorr OF STRUCTURE <ls_header>
                  TO <lv_field>.
    CHECK sy-subrc IS INITIAL.
    APPEND <lv_field> TO lt_trkorr.
  ENDLOOP.

  CHECK lt_trkorr[] IS NOT INITIAL.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_e071
    FROM e071 AS a
    JOIN e070 AS b
      ON a~trkorr = b~trkorr
     FOR ALL ENTRIES IN lt_trkorr
   WHERE a~trkorr = lt_trkorr-table_line.

  DELETE lt_e071 WHERE pgmid = 'CORR' AND object <> 'MERG'.

  CHECK lt_e071 IS NOT INITIAL.

  gt_e071[] = lt_e071[].

  PERFORM delete_dupl.

* Build Sort Table
  ls_sort-up = wc_x.
  ls_sort-fieldname = 'TIMESTAMP'.
  APPEND ls_sort TO lt_sort.

  ls_sort-up = wc_x.
  ls_sort-fieldname = c_trkorr.
  APPEND ls_sort TO lt_sort.

  ls_layout-zebra = wc_x.
  ls_layout-colwidth_optimize = wc_x.
  ls_layout-group_change_edit = wc_x.
  ls_layout-allow_switch_to_list = wc_x.
  ls_layout-box_fieldname = c_checkbox.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'E071'
    CHANGING
      ct_fieldcat      = lt_fieldcat.

  ls_fieldcat-fieldname = 'TIMESTAMP'.
  ls_fieldcat-col_pos = 11.
* ls_fieldcat-edit_mask = '==TSTPS'.
  ls_fieldcat-edit_mask = '==TSTLC'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-cprog
      i_callback_user_command  = 'USER_COMMAND_2'
      i_callback_pf_status_set = 'PF_STATUS_SET'
      it_fieldcat              = lt_fieldcat
      it_sort                  = lt_sort
      is_layout                = ls_layout
    TABLES
      t_outtab                 = gt_e071.

ENDFORM.                               " F_SHOW_OBJECTS
*--------------------------------------------------------------------*
*       Form  user_command_2
*--------------------------------------------------------------------*
FORM user_command_2 USING u_ucomm     TYPE syucomm          "#EC CALLED
                          us_selfield TYPE slis_selfield.

  DATA:
    ls_e071    TYPE e071,
    ls_bdcdata TYPE bdcdata,
    lt_bdcdata TYPE tab_bdcdata.

  CASE u_ucomm.
    WHEN '&IC1'.
      READ TABLE gt_e071 INTO ls_e071 INDEX us_selfield-tabindex.
      CHECK sy-subrc IS INITIAL.
      CASE us_selfield-fieldname.
        WHEN c_trkorr.
          CALL FUNCTION 'TR_PRESENT_REQUEST'
            EXPORTING
              iv_trkorr    = ls_e071-trkorr
              iv_highlight = wc_x.
        WHEN 'ACTIVITY'.
          IF ls_e071-activity IS NOT INITIAL.
            CALL FUNCTION 'TR_SHOW_ACTIVITY'
              EXPORTING
                iv_activity = ls_e071-activity.
          ENDIF.
        WHEN OTHERS.
          CASE ls_e071-object.
            WHEN 'FORM'.
*             SAPscript form
              SET PARAMETER ID 'TXF' FIELD ls_e071-obj_name.
              SET PARAMETER ID 'TXL' FIELD 'FR'.
              CALL TRANSACTION 'SE71' USING lt_bdcdata MODE 'A'.
            WHEN 'SSFO'.
              SELECT SINGLE formname
                INTO ls_e071-obj_name
                FROM stxfadm
               WHERE formname = ls_e071-obj_name
                 AND formtype = space.
              IF sy-subrc IS INITIAL.
*               SAP Smart Forms: Name of a Smart Form
                SET PARAMETER ID 'SSFNAME' FIELD ls_e071-obj_name.
*               SAP Smart Forms
                CALL TRANSACTION 'SMARTFORMS'.
              ELSE.
                m_bdc_dynpro 'SAPMSSFO' '0100' '=RB'.
                m_bdc_field  'RB_TX'  wc_x.
                m_bdc_dynpro 'SAPMSSFO' '0100' '/00'.
                m_bdc_field  'SSFSCREEN-TNAME' ls_e071-obj_name.
                CALL TRANSACTION 'SMARTFORMS' USING lt_bdcdata MODE 'E'.
              ENDIF.
            WHEN 'SSST'.
*             SAP Smart Forms: Name of a Smart Style
              SET PARAMETER ID 'SSFSTYLE' FIELD ls_e071-obj_name.
              m_bdc_dynpro 'SAPMSSFO' '0100' '/00'.
              m_bdc_field  'RB_ST'  wc_x.
              CALL TRANSACTION 'SMARTFORMS' USING lt_bdcdata MODE 'E'.
            WHEN 'AQBG'. " query user group
              SET PARAMETER ID 'AQW' FIELD 'G'. " global
              SET PARAMETER ID 'AQB' FIELD ls_e071-obj_name.
              CALL TRANSACTION 'SQ03'.
            WHEN 'AQQU'. " query
              SET PARAMETER ID 'AQW' FIELD 'G'. " global
              SET PARAMETER ID 'AQB' FIELD ls_e071-obj_name(12). " user group
              SET PARAMETER ID 'AQQ' FIELD ls_e071-obj_name+12.
              CALL TRANSACTION 'SQ01'.
            WHEN 'AQSG'. " query info set
              SET PARAMETER ID 'AQW' FIELD 'G'. " global
              SET PARAMETER ID 'AQS' FIELD ls_e071-obj_name.
              CALL TRANSACTION 'SQ02'.
            WHEN 'SCVI'. " screen variant
              SET PARAMETER ID 'TCD' FIELD ls_e071-obj_name.
              SET PARAMETER ID 'STV' FIELD space.
              CALL TRANSACTION 'SHD0'.
            WHEN 'STVI'.
              SET PARAMETER ID 'SCRVAR' FIELD space.
              SET PARAMETER ID 'STV' FIELD ls_e071-obj_name.
              CALL TRANSACTION 'SHD0'.
            WHEN 'CMOD'.
              PERFORM show_cmod USING ls_e071-obj_name(40).
            WHEN OTHERS.
              CALL FUNCTION 'TR_OBJECT_JUMP_TO_TOOL'
                EXPORTING
                  iv_pgmid          = ls_e071-pgmid
                  iv_object         = ls_e071-object
                  iv_obj_name       = ls_e071-obj_name
                EXCEPTIONS
                  jump_not_possible = 1
                  OTHERS            = 2.
              IF sy-subrc <> 0.
                MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
              ENDIF.
          ENDCASE.
      ENDCASE.
  ENDCASE.

ENDFORM.                               " USER_COMMAND_2
*---------------------------------------------------------------------*
*      Form SHOW_CMOD
*---------------------------------------------------------------------*
FORM show_cmod USING u_name TYPE sobj_name.

  DATA l_modname TYPE modsap-name.

  l_modname = u_name.

  CALL FUNCTION 'MOD_KUN_MEMBERSCRN'
    EXPORTING
      message = wc_x
      mode    = 'SHOM'
      modname = l_modname.

ENDFORM.                               " SHOW_CMOD
*---------------------------------------------------------------------*
*      Form  F_DATEM
*---------------------------------------------------------------------*
FORM f_datem CHANGING u_date TYPE datum.

  CALL FUNCTION 'DATE_CONVERT_TO_FACTORYDATE'
    EXPORTING
      correct_option               = '-'
      date                         = u_date
      factory_calendar_id          = 'Z1' "'FR'
    IMPORTING
      date                         = u_date
    EXCEPTIONS
      calendar_buffer_not_loadable = 1
      correct_option_invalid       = 2
      date_after_range             = 3
      date_before_range            = 4
      date_invalid                 = 5
      factory_calendar_not_found   = 6
      OTHERS                       = 7.
  IF sy-subrc IS NOT INITIAL AND sy-msgid IS NOT INITIAL
  AND sy-subrc <> 6.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                               " F_DATEM
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_trkorr-low.

  PERFORM f_value_request_trkorr CHANGING s_trkorr-low.

*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_trkorr-high.

  PERFORM f_value_request_trkorr CHANGING s_trkorr-high.

*---------------------------------------------------------------------*
*       Form  f_value_request_trkorr
*---------------------------------------------------------------------*
*      <--PV_TRKORR  text
*---------------------------------------------------------------------*
FORM f_value_request_trkorr CHANGING pv_trkorr TYPE trkorr.

  CALL FUNCTION 'TR_F4_REQUESTS'
    EXPORTING
      iv_trkorr_pattern   = pv_trkorr
      iv_trstatus         = 'R'
    IMPORTING
      ev_selected_request = pv_trkorr.

ENDFORM.                               "F_VALUE_REQUEST_TRKORR
*---------------------------------------------------------------------*
*      Form  f_modify_color
*---------------------------------------------------------------------*
FORM f_modify_color.

  DATA lv_int TYPE i.

  FIELD-SYMBOLS:
    <ls_header> TYPE any,
    <ls_color>  TYPE lvc_s_scol,
    <lt_color>  TYPE lvc_t_scol.

  LOOP AT <gt_data> ASSIGNING <ls_header>.

    ASSIGN COMPONENT c_colortab OF STRUCTURE <ls_header>
                                          TO <lt_color>.
    CHECK <lt_color> IS ASSIGNED.
    LOOP AT <lt_color> ASSIGNING <ls_color>.
      <ls_color>-color-int = lv_int.
    ENDLOOP.
    IF lv_int = 1.
      lv_int = 0.
    ELSE.
      lv_int = 1.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " F_MODIFY_COLOR
*---------------------------------------------------------------------*
*      Form  INITIALIZATION
*---------------------------------------------------------------------*
FORM initialization.

  DATA ls_syslst TYPE tmscsyslst.

  v_100 = '@0G@'.
  v_101 = '@0D@'.
  v_102 = '@0E@'.
  v_103 = '@0F@'.
  v_104 = '@0B@'.
  v_105 = '@0C@'.
  v_200 = '@4B@'.
  v_201 = '@4D@'.
  v_202 = '@7D@'.
  text_100 = 'Start date'(100).
  text_101 = 'End date'(101).
  text_102 = 'Transport Requests'(102).
  text_103 = 'Owner of the Request'(103).
  text_104 = 'Request Category'(104).
  text_105 = 'Type of request'(105).
  text_106 = 'Date DD.MM.YYYY'(106).
  text_107 = 'No Color'(107).
  text_108 = 'ALV List'(108).
  text_109 = 'No icon for return code'(109).
  text_110 = 'No return code'(110).
  text_111 = 'No User'(111).
  CONCATENATE sy-sysid 'only' INTO text_112 SEPARATED BY space.
  text_113 = 'No client'.
  text_114 = 'With sub-objects'.
  text_115 = 'Debug'.

  DO.
    READ TABLE gt_syslst INTO ls_syslst INDEX sy-index.
    IF sy-subrc IS NOT INITIAL.EXIT.ENDIF.
    CASE sy-tabix.
      WHEN 1.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p01. p_01 = 'X'.
      WHEN 2.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p02. p_02 = 'X'.
      WHEN 3.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p03. p_03 = 'X'.
      WHEN 4.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p04. p_04 = 'X'.
      WHEN 5.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p05. p_05 = 'X'.
      WHEN 6.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p06. p_06 = 'X'.
      WHEN 7.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p07. p_07 = 'X'.
      WHEN 8.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p08. p_08 = 'X'.
      WHEN 9.  CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p09. p_09 = 'X'.
      WHEN 10. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p10. p_10 = 'X'.
      WHEN 11. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p11. p_11 = 'X'.
      WHEN 12. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p12. p_12 = 'X'.
      WHEN 13. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p13. p_13 = 'X'.
      WHEN 14. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p14. p_14 = 'X'.
      WHEN 15. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p15. p_15 = 'X'.
      WHEN 16. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p16. p_16 = 'X'.
      WHEN 17. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p17. p_17 = 'X'.
      WHEN 18. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p18. p_18 = 'X'.
      WHEN 19. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p19. p_19 = 'X'.
      WHEN 20. CONCATENATE ls_syslst-sysnam '-' ls_syslst-systxt INTO text_p20. p_20 = 'X'.
    ENDCASE.
  ENDDO.

  PERFORM sel_tvarv.

ENDFORM.                               " INITIALIZATION
*---------------------------------------------------------------------*
*      Form  F_SUBOBJECT
*---------------------------------------------------------------------*
FORM f_subobject USING u_pgmid  TYPE pgmid
                       u_object TYPE trobjtype
                       u_objnam TYPE ty_objnam
              CHANGING ut_where TYPE ty_where_t.

  DATA:
    l_temp1 TYPE char100,
    l_temp2 TYPE char100,
    l_temp3 TYPE char100,
    l_where TYPE char200,
    ls_e071 TYPE e071,
    ls_vrso TYPE vrso,
    lt_vrso TYPE TABLE OF vrso.

  CHECK p_ssobj  IS NOT INITIAL AND
        u_pgmid  IS NOT INITIAL AND
        u_object IS NOT INITIAL AND
        u_objnam IS NOT INITIAL AND
        u_objnam NS '*+'.

  ls_e071-pgmid = 'R3TR'.
  ls_e071-object = u_object.
  ls_e071-obj_name = u_objnam.

  CALL FUNCTION 'SVRS_RESOLVE_E071_OBJ'
    EXPORTING
      e071_obj        = ls_e071
    TABLES
      obj_tab         = lt_vrso
    EXCEPTIONS
      not_versionable = 1
      OTHERS          = 2.

  CHECK sy-subrc IS INITIAL.

  LOOP AT lt_vrso INTO ls_vrso.
    MOVE 'OR ( PGMID = ''LIMU'' AND' TO l_temp1.

    CONCATENATE '''' ls_vrso-objtype '''' INTO l_temp2.
    CONCATENATE 'OBJECT = ' l_temp2 'AND' INTO l_temp2
      SEPARATED BY space.

    CONCATENATE '''' ls_vrso-objname '''' INTO l_temp3.
    IF ls_vrso-objname CS '*'.
      TRANSLATE l_temp3 USING '*%'.
      CONCATENATE 'OBJ_NAME LIKE ' l_temp3 ')' INTO l_temp3
        SEPARATED BY space.
    ELSEIF ls_vrso-objname CS '+'.
      TRANSLATE l_temp3 USING '+_'.
      CONCATENATE 'OBJ_NAME LIKE ' l_temp3 ')' INTO l_temp3
        SEPARATED BY space.
    ELSE.
      CONCATENATE 'OBJ_NAME = ' l_temp3 ')' INTO l_temp3
        SEPARATED BY space.
    ENDIF.

    CONCATENATE l_temp1 l_temp2 l_temp3 INTO l_where SEPARATED BY space.
    APPEND l_where TO ut_where.
  ENDLOOP.

ENDFORM.                               " F_SUBOBJECT
*---------------------------------------------------------------------*
*      Form  SEL_DESEL
*---------------------------------------------------------------------*
FORM sel_desel USING pv_flag TYPE flag.

  DATA ls_syslst TYPE tmscsyslst.

  DO.
    READ TABLE gt_syslst INTO ls_syslst INDEX sy-index.
    IF sy-subrc IS NOT INITIAL.EXIT.ENDIF.
    CASE sy-tabix.
      WHEN  1. IF text_p01 IS NOT INITIAL. p_01 = pv_flag. ENDIF.
      WHEN  2. IF text_p02 IS NOT INITIAL. p_02 = pv_flag. ENDIF.
      WHEN  3. IF text_p03 IS NOT INITIAL. p_03 = pv_flag. ENDIF.
      WHEN  4. IF text_p04 IS NOT INITIAL. p_04 = pv_flag. ENDIF.
      WHEN  5. IF text_p05 IS NOT INITIAL. p_05 = pv_flag. ENDIF.
      WHEN  6. IF text_p06 IS NOT INITIAL. p_06 = pv_flag. ENDIF.
      WHEN  7. IF text_p07 IS NOT INITIAL. p_07 = pv_flag. ENDIF.
      WHEN  8. IF text_p08 IS NOT INITIAL. p_08 = pv_flag. ENDIF.
      WHEN  9. IF text_p09 IS NOT INITIAL. p_09 = pv_flag. ENDIF.
      WHEN 10. IF text_p10 IS NOT INITIAL. p_10 = pv_flag. ENDIF.
      WHEN 11. IF text_p11 IS NOT INITIAL. p_11 = pv_flag. ENDIF.
      WHEN 12. IF text_p12 IS NOT INITIAL. p_12 = pv_flag. ENDIF.
      WHEN 13. IF text_p13 IS NOT INITIAL. p_13 = pv_flag. ENDIF.
      WHEN 14. IF text_p14 IS NOT INITIAL. p_14 = pv_flag. ENDIF.
      WHEN 15. IF text_p15 IS NOT INITIAL. p_15 = pv_flag. ENDIF.
      WHEN 16. IF text_p16 IS NOT INITIAL. p_16 = pv_flag. ENDIF.
      WHEN 17. IF text_p17 IS NOT INITIAL. p_17 = pv_flag. ENDIF.
      WHEN 18. IF text_p18 IS NOT INITIAL. p_18 = pv_flag. ENDIF.
      WHEN 19. IF text_p19 IS NOT INITIAL. p_19 = pv_flag. ENDIF.
      WHEN 20. IF text_p20 IS NOT INITIAL. p_20 = pv_flag. ENDIF.
    ENDCASE.
  ENDDO.

ENDFORM.                               " SEL_DESEL
*---------------------------------------------------------------------*
*      Form  DELETE_DUPL
*---------------------------------------------------------------------*
FORM delete_dupl.

  DATA:
    ls_e071  TYPE e071,
    ls_e071s TYPE ty_e071,
    ls_vrso  TYPE vrso,
    lt_vrso  TYPE TABLE OF vrso.

  LOOP AT gt_e071 INTO ls_e071s.
    CONCATENATE ls_e071s-as4date ls_e071s-as4time INTO ls_e071s-timestamp.
    MODIFY gt_e071 FROM ls_e071s.
  ENDLOOP.

  CHECK lines( gt_e071 ) > 1.

  SORT gt_e071 BY timestamp DESCENDING.

  LOOP AT gt_e071 INTO ls_e071s.
    DELETE gt_e071 WHERE trkorr <> ls_e071s-trkorr
                     AND timestamp < ls_e071s-timestamp
                     AND pgmid = ls_e071s-pgmid
                     AND object = ls_e071s-object
                     AND obj_name = ls_e071s-obj_name.
  ENDLOOP.

  LOOP AT gt_e071 INTO ls_e071s WHERE pgmid = 'R3TR'.
    CLEAR : ls_e071, lt_vrso.
    ls_e071-pgmid = 'R3TR'.
    ls_e071-object = ls_e071s-object.
    ls_e071-obj_name = ls_e071s-obj_name.

    CALL FUNCTION 'SVRS_RESOLVE_E071_OBJ'
      EXPORTING
        e071_obj        = ls_e071
      TABLES
        obj_tab         = lt_vrso
      EXCEPTIONS
        not_versionable = 1
        OTHERS          = 2.
    CHECK sy-subrc IS INITIAL.

    LOOP AT lt_vrso INTO ls_vrso.
      DELETE gt_e071 WHERE trkorr <> ls_e071s-trkorr
                       AND timestamp < ls_e071s-timestamp
                       AND object = ls_vrso-objtype
                       AND obj_name = ls_vrso-objname.
    ENDLOOP.
  ENDLOOP.

ENDFORM.                               " DELETE_DUPL
*---------------------------------------------------------------------*
*      Form  SEL_TVARV
*---------------------------------------------------------------------*
FORM sel_tvarv.

  DATA:
    l_low         TYPE tvarv_val,
    l_high        TYPE tvarv_val,
    l_str_tmp     TYPE char100,
    l_syst        TYPE char7,
    lt_syst       TYPE TABLE OF char7.

* Read System-Color in table TVARV
  SELECT SINGLE low high INTO (l_low, l_high) FROM tvarv
   WHERE name = c_zsyst AND numb = c_0000 AND type = c_p AND sign = ''.
  CONCATENATE l_low l_high INTO l_str_tmp.
  SPLIT l_str_tmp AT '/' INTO TABLE lt_syst.

  CHECK lt_syst IS NOT INITIAL.

  PERFORM sel_desel USING space.

  LOOP AT lt_syst INTO l_syst.
    READ TABLE gt_syslst WITH KEY sysnam = l_syst(3) TRANSPORTING NO FIELDS.
    CASE sy-tabix.
      WHEN  1. IF text_p01 IS NOT INITIAL. p_01 = 'X'. ENDIF.
      WHEN  2. IF text_p02 IS NOT INITIAL. p_02 = 'X'. ENDIF.
      WHEN  3. IF text_p03 IS NOT INITIAL. p_03 = 'X'. ENDIF.
      WHEN  4. IF text_p04 IS NOT INITIAL. p_04 = 'X'. ENDIF.
      WHEN  5. IF text_p05 IS NOT INITIAL. p_05 = 'X'. ENDIF.
      WHEN  6. IF text_p06 IS NOT INITIAL. p_06 = 'X'. ENDIF.
      WHEN  7. IF text_p07 IS NOT INITIAL. p_07 = 'X'. ENDIF.
      WHEN  8. IF text_p08 IS NOT INITIAL. p_08 = 'X'. ENDIF.
      WHEN  9. IF text_p09 IS NOT INITIAL. p_09 = 'X'. ENDIF.
      WHEN 10. IF text_p10 IS NOT INITIAL. p_10 = 'X'. ENDIF.
      WHEN 11. IF text_p11 IS NOT INITIAL. p_11 = 'X'. ENDIF.
      WHEN 12. IF text_p12 IS NOT INITIAL. p_12 = 'X'. ENDIF.
      WHEN 13. IF text_p13 IS NOT INITIAL. p_13 = 'X'. ENDIF.
      WHEN 14. IF text_p14 IS NOT INITIAL. p_14 = 'X'. ENDIF.
      WHEN 15. IF text_p15 IS NOT INITIAL. p_15 = 'X'. ENDIF.
      WHEN 16. IF text_p16 IS NOT INITIAL. p_16 = 'X'. ENDIF.
      WHEN 17. IF text_p16 IS NOT INITIAL. p_17 = 'X'. ENDIF.
      WHEN 18. IF text_p16 IS NOT INITIAL. p_18 = 'X'. ENDIF.
      WHEN 19. IF text_p16 IS NOT INITIAL. p_19 = 'X'. ENDIF.
      WHEN 20. IF text_p16 IS NOT INITIAL. p_20 = 'X'. ENDIF.
    ENDCASE.
  ENDLOOP.

ENDFORM.                               " SEL_TVARV
*---------------------------------------------------------------------*
*      Form  MOD_TVARV
*---------------------------------------------------------------------*
FORM mod_tvarv.

  DATA:
    ls_tvarv  TYPE tvarv,
    ls_seltab TYPE rsparams,
    lt_seltab TYPE TABLE OF rsparams.

  SELECT SINGLE * INTO ls_tvarv FROM tvarv
   WHERE name = c_zsyst AND numb = c_0000 AND type = c_p.
  IF sy-subrc IS NOT INITIAL.
    ls_tvarv-name = c_zsyst.
    ls_tvarv-type = c_p.
    ls_tvarv-low = sy-sysid.
    INSERT tvarv FROM ls_tvarv.
  ENDIF.

  ls_seltab-selname = 'I1'.
  ls_seltab-kind    = c_p.
  ls_seltab-sign    = 'I'.
  ls_seltab-option  = 'EQ'.
  ls_seltab-low     = c_zsyst.
  APPEND ls_seltab TO lt_seltab.

  CALL FUNCTION 'RSDU_CALL_SE16'
    EXPORTING
      i_tablename = 'TVARV'
    TABLES
      i_t_seltab  = lt_seltab.

ENDFORM.                               " MOD_TVARV
* Text element
*001  No requests found
*100  Start date
*101  End date
*102  Transport Requests
*103  Owner of the Request
*104  Request Category
*105  Type of request
*106  Date DD.MM.YYYY
*107  No Color
*108  ALV List
*109  No icon for return code
*110  No return code
*111  No User
*113  No client detail
*BL0  Parameters
*BL1  Objects
*BL2  Options
***************** END OF PROGRAM Z_ALV_OVERVIEW_REQUEST ***************
