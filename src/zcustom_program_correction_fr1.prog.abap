*&---------------------------------------------------------------------*
*& Report ZCUSTOM_PROGRAM_CORRECTION_FR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcustom_program_correction_fr1.
DATA: lt_programs     TYPE STANDARD TABLE OF progname,
      lt_source       TYPE STANDARD TABLE OF string,
      lt_source_final TYPE STANDARD TABLE OF string,
      lt_new_code     TYPE STANDARD TABLE OF string,
      lt_new_code1    TYPE string,
      lv_progname     TYPE progname,
      lv_index        TYPE sy-tabix,
      lv_index_to     TYPE sy-tabix,
      lv_varline      TYPE sy-tabix,
      lv_found        TYPE abap_bool.

DATA: BEGIN OF t_it  OCCURS 0,
        progname TYPE progname,
      END OF t_it.

DATA ls_backup TYPE zprog_backup.

DATA: u_file1   TYPE string.
DATA lv_len TYPE i.
DATA lv_len1 TYPE i.
DATA lv_offset TYPE i.
DATA:  it_excel TYPE TABLE OF alsmex_tabline.

PARAMETERS: p_file TYPE rlgrap-filename OBLIGATORY,
            p_path TYPE char100 DEFAULT 'D:\Delvel_Backup\'.

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
      i_end_col               = 1
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
    ENDCASE.
    AT END OF row.
      APPEND t_it TO lt_programs.
      CLEAR t_it.
    ENDAT.

  ENDLOOP.




  LOOP AT lt_programs INTO lv_progname.
    CLEAR: lt_source, lv_found,lt_new_code1,lt_new_code.

    READ REPORT lv_progname INTO lt_source.


    CONCATENATE p_path   lv_progname INTO u_file1 .

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
      ls_backup-program_name = lv_progname.
      ls_backup-line_num     = sy-tabix.
      ls_backup-source_line  = line.
      ls_backup-backup_date  = sy-datum.
      INSERT ztab_prog_backup FROM ls_backup.
      IF line CP '*E:\delval*'.
        IF line+0(1) <> '*'.
          lv_varline = sy-tabix.

          FIND 'E:' IN line.
          IF sy-subrc = 0.
            REPLACE FIRST OCCURRENCE OF 'E:' IN line WITH ''.
          ENDIF.

          FIND '\' IN line.
          IF sy-subrc = 0.
            REPLACE ALL OCCURRENCES OF '\' IN line WITH '/'.
          ENDIF.

          lv_len = strlen( line ).
          CLEAR:lv_len1.
          DO lv_len TIMES.
            lv_len1 = lv_len1 + 1.
            lv_offset = lv_len - sy-index.
            IF lv_offset < 0.
              EXIT.
            ENDIF.

            IF line+lv_offset(1) CO '0123456789'.
              REPLACE SECTION OFFSET lv_offset LENGTH 1 OF line WITH ''.
            ELSE.
              IF lv_len1 > lv_len.
                EXIT.
              ENDIF.
            ENDIF.
          ENDDO.

          APPEND line TO lt_source_final.
          CLEAR: line.
        ELSE.
          APPEND line TO lt_source_final.
          CLEAR: line.
        ENDIF.

      ELSEIF  line CP '*CONCATENATE*'.
        FIND '\' IN line.
        IF sy-subrc = 0.
          IF line+0(1) <> '*'.
            lv_varline = sy-tabix.
            REPLACE ALL OCCURRENCES OF '\' IN line WITH '/'.
            APPEND line TO lt_source_final.
            CLEAR: line.
           ELSE.
              APPEND line TO lt_source_final.
          CLEAR: line.
          ENDIF.
        else.
           APPEND line TO lt_source_final.
          CLEAR: line.
        ENDIF.
     ELSEIF  line CP '*E:/delval*'.
       FIND 'E:' IN line.
          IF sy-subrc = 0.
            REPLACE FIRST OCCURRENCE OF 'E:' IN line WITH ''.
          ENDIF.
          CLEAR:lv_len, lv_len1.
           lv_len = strlen( line ).
          DO lv_len TIMES.
            lv_len1 = lv_len1 + 1.
            lv_offset = lv_len - sy-index.
            IF lv_offset < 0.
              EXIT.
            ENDIF.

            IF line+lv_offset(1) CO '0123456789'.
              REPLACE SECTION OFFSET lv_offset LENGTH 1 OF line WITH ''.
            ELSE.
              IF lv_len1 > lv_len.
                EXIT.
              ENDIF.
            ENDIF.
          ENDDO.

          APPEND line TO lt_source_final.
          CLEAR: line.
      ELSE.
        APPEND line TO lt_source_final.
      ENDIF.
    ENDLOOP.
    INSERT REPORT lv_progname FROM lt_source_final.
    CLEAR:lt_source_final.
  ENDLOOP.
