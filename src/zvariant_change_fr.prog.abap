*&---------------------------------------------------------------------*
*& Report ZCUSTOM_PROGRAM_CORRECTION_FR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvariant_change_fr.
TYPES:  BEGIN OF ty_st,
        progname TYPE progname,
        VARIANT  TYPE VARIANT,
        path     TYPE char100,
        END OF ty_st.
DATA: BEGIN OF t_it  OCCURS 0,
        progname TYPE progname,
        VARIANT  TYPE VARIANT,
        path     TYPE char100,
      END OF t_it.
DATA:
      lt_programs     TYPE STANDARD TABLE OF ty_st,
      lt_source       TYPE STANDARD TABLE OF string,
      lt_source_final TYPE STANDARD TABLE OF string,
      lt_new_code     TYPE STANDARD TABLE OF string,
      lt_new_code1    TYPE string,
      lv_progname     TYPE progname,
      lv_index        TYPE sy-tabix,
      lv_index_to     TYPE sy-tabix,
      lv_varline      TYPE sy-tabix,
      lv_found        TYPE abap_bool.



DATA ls_backup TYPE zprog_backup.

DATA: u_file1   TYPE string.
DATA lv_len TYPE i.
DATA lv_len1 TYPE i.
DATA lv_offset TYPE i.
DATA:  it_excel TYPE TABLE OF alsmex_tabline.

PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY.
*            p_path TYPE char100 DEFAULT 'D:\Delvel_Backup\'.

* Fill your list of programs
*APPEND 'ZMM_VENDOR_UPLOAD_REPORT3' TO lt_programs.
*APPEND 'ZMM_VENDOR_UPLOAD_REPORT7' TO lt_programs.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = sy-repid
      dynpro_number = sy-dynnr
      field_name    = 'P_FILE'
    IMPORTING
      file_name     = p_file.


START-OF-SELECTION.


  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = 1
      i_begin_row             = 2
      i_end_col               = 3
      i_end_row               = 9999

    TABLES
      intern                  = it_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.



  LOOP AT it_excel INTO DATA(wa_excel).

    CASE wa_excel-col.
      WHEN '0001'. t_it-progname = wa_excel-value.
      WHEN '0002'. t_it-variant = wa_excel-value.
      WHEN '0003'. t_it-path = wa_excel-value.
    ENDCASE.
    AT END OF row.
      APPEND t_it TO lt_programs.
      CLEAR t_it.
    ENDAT.

  ENDLOOP.


DATA: CURR_REPORT  TYPE RSVAR-REPORT,
      CURR_VARIANT TYPE RSVAR-VARIANT,
      it_valutab  TYPE TABLE of RSPARAMS.

  LOOP AT lt_programs INTO DATA(wa_programs).
      CURR_REPORT  = wa_programs-progname.
      CURR_VARIANT = wa_programs-variant.
select SINGLE * FROM VARID INTO @DATA(wa_VARID) WHERE REPORT = @CURR_REPORT AND variant = @CURR_VARIANT.
  IF sy-subrc = 0.
 CALL FUNCTION 'RS_VARIANT_CONTENTS'
   EXPORTING
     report                      = CURR_REPORT
     variant                     = CURR_VARIANT
*    MOVE_OR_WRITE               = 'W'
*    NO_IMPORT                   = ' '
*    EXECUTE_DIRECT              = ' '
*    GET_P_XML_TAB               =
*  IMPORTING
*    SP                          =
*    P_XML_TAB                   =
   TABLES
*    L_PARAMS                    =
*    L_PARAMS_NONV               =
*    L_SELOP                     =
*    L_SELOP_NONV                =
     valutab                     = it_valutab
*    VALUTABL                    =
*    OBJECTS                     =
*    VARIVDATS                   =
*    FREE_SELECTIONS_DESC        =
*    FREE_SELECTIONS_VALUE       =
*    FREE_SELECTIONS_OBJ         =
*  EXCEPTIONS
*    VARIANT_NON_EXISTENT        = 1
*    VARIANT_OBSOLETE            = 2
*    OTHERS                      = 3
           .
 IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
 LOOP AT it_valutab ASSIGNING FIELD-SYMBOL(<wa_valutab>) .
   TRANSLATE <wa_valutab>-low TO UPPER CASE.
IF <wa_valutab>-low CP '*DELVAL*'.
<wa_valutab>-low = wa_programs-path.
ENDIF.
 ENDLOOP.

  CALL FUNCTION 'RS_CHANGE_CREATED_VARIANT'
   EXPORTING
     curr_report                     = CURR_REPORT
     curr_variant                    = CURR_VARIANT
     vari_desc                       = wa_VARID
*    ONLY_CONTENTS                   =
*    P_XML_TAB                       =
*    SUPPRESS_AUTHORITY_CHECK        =
   TABLES
     vari_contents                   = it_valutab
*    VARI_CONTENTS_L                 =
*    VARI_TEXT                       =
*    VARI_SEL_DESC                   =
*    OBJECTS                         =
*    FREE_SELECTIONS_VALUE           =
*    FREE_SELECTIONS_OBJ             =
*    VARIVDATS                       =
*  EXCEPTIONS
*    ILLEGAL_REPORT_OR_VARIANT       = 1
*    ILLEGAL_VARIANTNAME             = 2
*    NOT_AUTHORIZED                  = 3
*    NOT_EXECUTED                    = 4
*    REPORT_NOT_EXISTENT             = 5
*    REPORT_NOT_SUPPLIED             = 6
*    VARIANT_DOESNT_EXIST            = 7
*    VARIANT_LOCKED                  = 8
*    SELECTIONS_NO_MATCH             = 9
*    OTHERS                          = 10
           .
 IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
  ENDIF.

  CLEAR:wa_programs,
        CURR_REPORT,
        CURR_VARIANT,
        it_valutab.
  ENDLOOP.
