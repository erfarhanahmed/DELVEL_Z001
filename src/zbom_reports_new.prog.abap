*&---------------------------------------------------------------------*
*& Report ZBOM_REPORTS_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbom_reports_new.

************************************************************************
*Data Declarations
************************************************************************
TYPE-POOLS : slis.

*Internal Table for field catalog
DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.
DATA : fs_layout TYPE slis_layout_alv.

*Internal Table for sorting
DATA : t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

TYPES : BEGIN OF ty_itab,
          matnr     TYPE mast-matnr,
          long_txt  TYPE char100,
          werks     TYPE mast-werks,
          stlan     TYPE mast-stlan,
          stlal     TYPE mast-stlal,
          bmeng     TYPE char15,
          bmein     TYPE stko-bmein,
          idnrk     TYPE stpo-idnrk,
          long_txt1 TYPE char100,
          menge     TYPE char15,
          meins     TYPE stpo-meins,
          stlst     TYPE stko-stlst,
*          andat     TYPE char11,
          andat     TYPE sy-datum,
          annam     TYPE stko-annam,
*          ref       TYPE char15,
          ref       TYPE sy-datum,

          maktx     TYPE makt-maktx,
          stlnr     TYPE mast-stlnr,
          stlty     TYPE stko-stlty,
          stlkn     TYPE stpo-stlkn,
          compd     TYPE makt-maktx,
*          datuv     TYPE char15, "<----------Added by Amit 23.12.11
          datuv     TYPE sy-datum,
          postp     TYPE stpo-postp,
          posnr     TYPE stpo-posnr,
*          aedat     TYPE char15, "stpo-aedat,
          aedat     TYPE stpo-aedat, "stpo-aedat,
          aenam     TYPE stpo-aenam,
        END OF ty_itab,

        BEGIN OF ty_mattxt,
          matnr  TYPE matnr,
          mattxt TYPE char100,
        END   OF ty_mattxt,

        tty_itab   TYPE STANDARD TABLE OF ty_itab,
        tty_mattxt TYPE STANDARD TABLE OF ty_mattxt.

TYPES: BEGIN OF ty_final ,
         matnr     TYPE mast-matnr,
         long_txt  TYPE char100,
         werks     TYPE mast-werks,
         stlan     TYPE mast-stlan,
         stlal     TYPE mast-stlal,
         bmeng     TYPE char15,
         bmein     TYPE stko-bmein,
         posnr     TYPE stpo-posnr,
         idnrk     TYPE stpo-idnrk,
         long_txt1 TYPE char100,
         menge     TYPE char15,
         meins     TYPE stpo-meins,
         stlst     TYPE stko-stlst,
         andat     TYPE char11,
         annam     TYPE stko-annam,
         datuv     TYPE char11,
         ref       TYPE char11,
         aenam     TYPE stpo-aenam,
         aedat     TYPE char11,
         lvorm     TYPE marc-lvorm,
       END OF ty_final,
       tty_final TYPE STANDARD TABLE OF ty_final.

*DATA : gv_count TYPE char15.

DATA :
*  gv_werks TYPE werks_d,
  gv_stlan TYPE mast-stlan,
  gv_stlst TYPE stko-stlst,
  gv_matnr TYPE matnr,
  itab     TYPE tty_itab,
  it_final TYPE tty_final.

*DATA:
*  lv_id    TYPE thead-tdname,
**  lt_lines TYPE STANDARD TABLE OF tline,
*  ls_lines TYPE tline.

*DATA : wa_stpo TYPE stpo.
**********************SELECTION-SCREEN**************************
SELECTION-SCREEN: BEGIN OF BLOCK b1  WITH FRAME TITLE TEXT-001.
  PARAMETERS  : p_werks TYPE werks_d DEFAULT 'PL01' OBLIGATORY MODIF ID wer.
*                p_stlan TYPE mast-stlan DEFAULT 1 OBLIGATORY,
*                p_stlst TYPE stko-stlst DEFAULT 1 OBLIGATORY.
  SELECT-OPTIONS  :
                    s_stlan FOR gv_stlan DEFAULT 1 NO INTERVALS,
                    s_stlst FOR gv_stlst DEFAULT 1 NO INTERVALS,
                    s_matnr FOR gv_MATNR.
SELECTION-SCREEN: END OF BLOCK b1.
*********************END-OF-SELECTION**************************
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK b3.


*&--------------------------------------------------------------------&*
* START-OF-SELECTION
*&--------------------------------------------------------------------&*

START-OF-SELECTION.

  PERFORM data_select.

  PERFORM sort_list.

  EXPORT it_final TO MEMORY ID 'ZBOM2'.
  PERFORM form_heading.
*&--------------------------------------------------------------------&*
*
*&--------------------------------------------------------------------&*
FORM data_select.
  TYPES: BEGIN OF ty_stlnr,
           stlnr TYPE mast-stlnr,
           stlkn TYPE stpo-stlkn,
           stpoz TYPE stpo-stpoz,
         END   OF ty_Stlnr,
         tty_Stlnr TYPE STANDARD TABLE OF ty_stlnr.

  DATA: lt_stlnr    TYPE tty_stlnr,
        lt_mattxt   TYPE tty_mattxt,
        lt_mattxt_t TYPE STANDARD TABLE OF ty_mattxt,
        lt_mattxt_h TYPE HASHED TABLE OF ty_mattxt WITH UNIQUE KEY matnr.

* New select statements
*  SELECT * FROM zcv_bomrep AS a
  SELECT * FROM zcds_BOMREP AS a

    WHERE
           a~matnr IN @s_matnr
      AND  a~werks = @p_werks
*      AND a~stlan = @p_stlan
*      AND a~stlst = @p_stlst
      AND a~stlan IN @S_stlan
      AND a~stlst IN @S_stlst
    INTO TABLE @DATA(lt_bomrep).

  IF lt_bomrep IS NOT INITIAL.
    lt_stlnr = CORRESPONDING #( lt_bomrep MAPPING stlnr = stlnr
                                                  stlkn = stlkn
                                                  stpoz = stpoz  ).
    SORT lt_stlnr BY stlnr stlkn stpoz.
    DELETE ADJACENT DUPLICATES FROM lt_stlnr COMPARING stlnr stlkn stpoz.

    IF lt_stlnr IS NOT INITIAL.
      SELECT FROM stpo AS a
        FIELDS
        a~stlnr,
        a~vgknt,
        a~vgpzl,
        a~idnrk,
        a~andat,
        a~menge,
        a~meins,
        a~datuv,
        a~postp,
        a~posnr,
        a~stlkn,
        a~stpoz,
        a~aenam,
        a~aedat
        FOR ALL ENTRIES IN @lt_stlnr
        WHERE a~stlnr = @lt_stlnr-stlnr
          AND a~vgknt = @lt_stlnr-stlkn
          AND a~vgpzl = @lt_stlnr-stpoz
        INTO TABLE @DATA(lt_stpo).

      SORT lt_bomrep BY stlnr stlkn stpoz.
      LOOP AT lt_stpo INTO DATA(ls_stpo).
        READ TABLE lt_bomrep ASSIGNING FIELD-SYMBOL(<f1>) WITH KEY
                                         stlnr = ls_stpo-stlnr
                                         stlkn = ls_stpo-vgknt
                                         stpoz = ls_stpo-vgpzl BINARY SEARCH.
        IF <f1> IS ASSIGNED AND sy-subrc = 0.
          <f1>-idnrk = ls_stpo-idnrk.
          <f1>-andat = ls_stpo-andat.
          <f1>-meins = ls_stpo-meins.
          <f1>-menge = ls_stpo-menge.
          <f1>-datuv = ls_stpo-datuv.
*          <f1>-postp = ls_stpo-postp.
          <f1>-posnr = ls_stpo-posnr.
          <f1>-stlnr = ls_stpo-stlnr.
          <f1>-stlkn = ls_stpo-stlkn.
        ENDIF.
      ENDLOOP.

      lt_mattxt = CORRESPONDING #( lt_bomrep MAPPING matnr = idnrk ).

      lt_mattxt_t = CORRESPONDING #( lt_bomrep MAPPING matnr = matnr ).
      SORT lt_mattxt_t BY matnr.
      DELETE ADJACENT DUPLICATES FROM lt_mattxt_t COMPARING matnr.

      APPEND LINES OF lt_mattxt_t TO lt_mattxt.

      SORT lt_mattxt BY matnr.
      DELETE ADJACENT DUPLICATES FROM lt_mattxt COMPARING matnr.
      CLEAR: lt_mattxt_t.

* Read from STAS
      DELETE ADJACENT DUPLICATES FROM lt_stlnr COMPARING stlnr.

      SELECT FROM stas AS a
          INNER JOIN @lt_stlnr AS b ON b~stlnr = a~stlnr      ##ITAB_KEY_IN_SELECT
        FIELDS
            a~stlnr,
            a~stlkn,
            COUNT( a~stlkn ) AS stlkn_cnt
          GROUP BY a~stlnr, a~stlkn
          INTO TABLE @DATA(lt_stas).
      SORT lt_stas BY stlnr stlkn.

* join
      SELECT FROM @lt_bomrep AS a
          INNER JOIN @lt_stas AS b ON b~stlnr = a~stlnr
                                  AND b~stlkn = a~stlkn
                                  AND b~stlkn_cnt < 2
        FIELDS
        a~*
        INTO TABLE @DATA(lt_bomrep2).
    ENDIF.
  ENDIF.
  CLEAR: lt_bomrep.

  PERFORM enrich_texts CHANGING lt_mattxt.
  lt_mattxt_h = lt_mattxt.
************************************************************************************************************
  SORT lt_bomrep2 BY stlnr posnr datuv.
  itab[] = CORRESPONDING #( lt_bomrep2 MAPPING aenam = aenam_po
                                               aedat = aedat_po ).

* Update itab with material text
  DATA: ls_final TYPE ty_final.
  CLEAR: it_final.
  LOOP AT itab ASSIGNING FIELD-SYMBOL(<f2>).
    <f2>-long_txt1 = VALUE #( lt_mattxt_h[ matnr = <f2>-idnrk ]-mattxt OPTIONAL ).
    <f2>-long_txt = VALUE #( lt_mattxt_h[ matnr = <f2>-matnr ]-mattxt OPTIONAL ).

* For file download
    IF p_down IS NOT INITIAL.
      MOVE-CORRESPONDING <f2> TO ls_final.

*    WRITE: <f2>-andat TO ls_final-andat dd-mmm-yyyy.
      PERFORM change_Date_format USING <f2>-andat CHANGING ls_final-andat.
      PERFORM change_Date_format USING <f2>-aedat CHANGING ls_final-aedat.
      PERFORM change_Date_format USING <f2>-ref CHANGING ls_final-ref.
      PERFORM change_Date_format USING <f2>-datuv CHANGING ls_final-datuv.

      APPEND ls_final TO it_final.
      CLEAR: ls_final.
    ENDIF.
  ENDLOOP.

ENDFORM.

FORM form_heading .

  REFRESH t_fieldcat.

  PERFORM t_fieldcatlog USING  '1'  'MATNR'         'Material Code' '18'.
  PERFORM t_fieldcatlog USING  '2'  'LONG_TXT'         'Description' '50'.
  PERFORM t_fieldcatlog USING  '3'  'WERKS'         'Plant' '5'.
  PERFORM t_fieldcatlog USING  '4' 'STLAN'         'BOM Usage'   '10'.
  PERFORM t_fieldcatlog USING  '5' 'STLAL'         'Alt BOM' '10'. "<----------Added by nupur 10.12.11
  PERFORM t_fieldcatlog USING  '6'  'BMENG'         'Base Qty' '10'.
  PERFORM t_fieldcatlog USING  '7'  'BMEIN'         'UOM'  '5'.

  PERFORM t_fieldcatlog USING  '8'  'POSNR'         'Line Item' '15'.

  PERFORM t_fieldcatlog USING  '9'  'IDNRK'         'Component' '18'.
  PERFORM t_fieldcatlog USING  '10'  'LONG_TXT1'         'Component Description' '50'.
  PERFORM t_fieldcatlog USING  '11'  'MENGE'         'Qty' '10'.
  PERFORM t_fieldcatlog USING  '12'  'MEINS'         'UOM' '5'.
  PERFORM t_fieldcatlog USING  '13' 'STLST'         'BOM Status' '10'.
  PERFORM t_fieldcatlog USING  '14' 'ANDAT'         'Created Date' '15'.
  PERFORM t_fieldcatlog USING  '15' 'ANNAM'         'Created By' '15'.
  PERFORM t_fieldcatlog USING  '16' 'DATUV'         'Valid From' '15'.
  PERFORM t_fieldcatlog USING  '17' 'REF'         'Refresh Date' '15'.
  PERFORM t_fieldcatlog USING  '19' 'AEDAT'         'Changed  Date' '15'.
  PERFORM t_fieldcatlog USING  '18' 'AENAM'         'Changed By' '15'.


*   perform t_fieldcatlog using  '14' 'DATUV'         'Valid From'. "<----------Added by Amit 23.12.11
*   perform t_fieldcatlog using  '15' 'POSTP'         'Item Category'.
*   perform t_fieldcatlog using  '16' 'STLNR'         'Bill of Material'.

  PERFORM g_display_grid.
ENDFORM.                    " FORM_HEADING

FORM sort_list .
  t_sort-spos      = '1'.
  t_sort-fieldname = 'WERKS'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '2'.
  t_sort-fieldname = 'MATNR'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '3'.
  t_sort-fieldname = 'LONG_TXT'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '12'.
  t_sort-fieldname = 'STLAL'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
*  t_sort-subtot    = 'X'.
  APPEND t_sort.
ENDFORM.                    " SOR


**&---------------------------------------------------------------------*
**&      Form  G_DISPLAY_GRID
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**  -->  p1        text
**  <--  p2        text
**----------------------------------------------------------------------*



FORM g_display_grid .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      is_layout              = fs_layout
      i_callback_top_of_page = 'TOP-OF-PAGE'
      it_fieldcat            = t_fieldcat[]
      it_sort                = t_sort[]
      i_save                 = 'X'
    TABLES
      t_outtab               = itab
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF p_down = 'X'.
    PERFORM download TABLES it_final USING p_folder.
  ENDIF.


ENDFORM.                    " G_DISPLAY_GRID
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0800   text
*      -->P_0801   text
*      -->P_0802   text
*----------------------------------------------------------------------*
FORM t_fieldcatlog  USING    VALUE(x)
                             VALUE(f1)
                             VALUE(f2)
                             VALUE(p5).
  t_fieldcat-col_pos = x.
  t_fieldcat-fieldname = f1.
  t_fieldcat-seltext_l = f2.
*  t_fieldcat-decimals_out = '2'.
  t_fieldcat-outputlen   = p5.

  APPEND t_fieldcat.
  CLEAR t_fieldcat.


ENDFORM.                    " T_FIELDCATLOG

FORM top-of-page.

*ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

* Title
  wa_header-typ  = 'H'.
  wa_header-info = 'BOM Component Details-New'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.

* Date
*  wa_header-typ  = 'S'.
*  wa_header-key = 'From: '.
*  concatenate wa_header-info cpudt1+6(2) '.' cpudt1+4(2) '.' cpudt1(4) into wa_header-info.
*  concatenate wa_header-info ' To' cpudt-high+6(2) into wa_header-info separated by space.
*  concatenate wa_header-info  '.' cpudt-high+4(2) '.' cpudt-high(4) into wa_header-info. " separated by space.
*  append wa_header to t_header.
*  clear: wa_header.

*  CONCATENATE  sy-datum+6(2) '.'
*               sy-datum+4(2) '.'
*   sy-datum(4) INTO wa_header-info."todays date
*  CONCATENATE  into wa_header-info separated by space.

* Total No. of Records Selected
  DESCRIBE TABLE itab LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
*       i_logo             = 'GANESH_LOGO'.
ENDFORM.                    " top-of-page
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download TABLES it_final USING p_folder.
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string.
*        lv_dat(10),
*        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_final
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

* For file headers
  PERFORM cvs_header USING hd_csv.

  lv_file = |ZBOM2| & |_| & |{ p_werks }| & |.TXT|.
*  lv_file = 'ZBOM2.TXT'.
*  CONCATENATE 'ZBOM2' p_werks INTO lv_file SEPARATED BY '_'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZBOM_REPORTS', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA lv_string_830 TYPE string.
    DATA lv_crlf_830 TYPE string.
    lv_crlf_830 = cl_abap_char_utilities=>cr_lf.
    lv_string_830 = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_string_830 lv_crlf_830 wa_csv INTO lv_string_830.
      CLEAR: wa_csv.
    ENDLOOP.
    TRANSFER lv_string_830 TO lv_fullfile.
*TRANSFER lv_string_830 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
  CLOSE DATASET lv_fullfile.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.

  CONCATENATE 'Material Code'
              'Description'
              'Plant'
              'BOM Usage'
              'ALT BOM'
              'Base qty'
              'UOM'
              'Line Item No'
              'Component'
              'Component Description'
              'QTY'
              'UOM'
              'BOM Status'
              'Created Date'
              'Created By'
              'Valid From'
              'Refresh Date'
              'Changed By'
              'Changed Date'

              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
"ENDIF.
*&---------------------------------------------------------------------*
*& Form enrich_texts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LT_MATTXT
*&---------------------------------------------------------------------*
FORM enrich_texts  CHANGING ct_mattxt TYPE tty_mattxt.
  DATA: lt_lines TYPE STANDARD TABLE OF tline,
        lv_name  TYPE thead-tdname.

  LOOP AT ct_mattxt ASSIGNING FIELD-SYMBOL(<f1>).

    CLEAR: <f1>-mattxt.
    lv_name = <f1>-matnr.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_name
        object                  = 'MATERIAL'
      TABLES
        lines                   = lt_lines
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
* Implement suitable error handling here
    ENDIF.
    IF NOT lt_lines IS INITIAL.
      LOOP AT lt_lines INTO DATA(ls_lines) WHERE tdline IS NOT INITIAL.

        CONCATENATE <f1>-mattxt ls_lines-tdline INTO <f1>-mattxt SEPARATED BY space.

      ENDLOOP.
      CONDENSE <f1>-mattxt.
    ENDIF.
    CLEAR: lv_name, lt_lines.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form date_convert
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PU_DATE
*&      <-- PC_DATE
*&---------------------------------------------------------------------*
FORM change_Date_format  USING    pu_date TYPE sy-datum
                         CHANGING pc_udate TYPE char11.
  IF pu_date  IS INITIAL.
    CLEAR: pc_udate.
    RETURN.
  ENDIF.

* To get in DDMMMYY format
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input  = pu_date
    IMPORTING
      output = pc_udate.

* To get in DD-MMM-YYYY format
  CONCATENATE  pc_udate+0(2)  pc_udate+2(3)  pc_udate+5(4)
                 INTO  pc_udate SEPARATED BY '-'.
ENDFORM.
