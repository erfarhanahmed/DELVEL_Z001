*&---------------------------------------------------------------------*
*& Report ZCUSTOM_PROGRAM_CORRECTION_FR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcustom_program_correction_fr2.


DATA: BEGIN OF t_it  OCCURS 0,
        progname TYPE progname,
        country   TYPE string,
      END OF t_it.
TYPES:  BEGIN OF ty_it,
        progname TYPE progname,
        country   TYPE string,
      END OF ty_it.
DATA: path TYPE string.
DATA ls_backup TYPE zprog_backup.

DATA: u_file1   TYPE string.
DATA lv_len TYPE i.
DATA lv_len1 TYPE i.
DATA lv_offset TYPE i.
DATA:  it_excel TYPE TABLE OF alsmex_tabline.

DATA: lt_programs     TYPE STANDARD TABLE OF ty_it, "progname,
      wa_programs     TYPE ty_it, "progname,
      lt_source       TYPE STANDARD TABLE OF string,
      lt_source_final TYPE STANDARD TABLE OF string,
      lt_new_code     TYPE STANDARD TABLE OF string,
      lt_new_code1    TYPE string,
      lv_progname     TYPE progname,
      lv_index        TYPE sy-tabix,
      lv_index_to     TYPE sy-tabix,
      lv_varline      TYPE sy-tabix,
      lv_found        TYPE abap_bool.

PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY,
            p_path TYPE char100 DEFAULT 'D:\Delvel_Backup1\'.

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
      WHEN '0002'. t_it-progname = wa_excel-value.
      WHEN '0003'. t_it-country = wa_excel-value.
    ENDCASE.
    AT END OF row.
      APPEND t_it TO lt_programs.
      CLEAR t_it.
    ENDAT.

  ENDLOOP.




  LOOP AT lt_programs INTO wa_programs.
    CLEAR: lt_source, lv_found,lt_new_code1,lt_new_code.

    READ REPORT wa_programs-progname INTO lt_source.


    CONCATENATE p_path   wa_programs-progname INTO u_file1 .

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename = u_file1
        filetype = 'ASC'
*       has_field_separator = 'X'
      TABLES
        data_tab = lt_source.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    LOOP AT lt_source INTO DATA(line).
      CLEAR:ls_backup.
      ls_backup-program_name = wa_programs-progname.
      ls_backup-line_num     = sy-tabix.
      ls_backup-source_line  = line.
      ls_backup-backup_date  = sy-datum.
      INSERT ztab_prog_backup FROM ls_backup.
      IF line CP '*PARAMETERS*'.
        IF line+0(1) <> '*'.
          lv_varline = sy-tabix.

          FIND '/Delval/' IN line.
          IF sy-subrc = 0.
            IF wa_programs-country = 'INDIA'.
            path = |/Delval/India| & |'."|.
            ELSEIF wa_programs-country = 'USA'.
            path = |/Delval/USA| & |'."|.
            ELSEIF wa_programs-country = 'SAUDI'.
             path =  |/Delval/Saudi| & |'."|.
            ENDIF.

            REPLACE FIRST OCCURRENCE OF '/Delval/' IN line WITH path.
            CLEAR:path.
          ENDIF.

          APPEND line TO lt_source_final.
          CLEAR: line.
        ELSE.
          APPEND line TO lt_source_final.
          CLEAR: line.
        ENDIF.

      ELSE.
        APPEND line TO lt_source_final.
      ENDIF.
      CLEAR:line.
    ENDLOOP.
  INSERT REPORT wa_programs-progname FROM lt_source_final.
    CLEAR:lt_source_final,line.
  ENDLOOP.
