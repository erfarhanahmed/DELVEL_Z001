
DATA: lv_name          TYPE thead-tdname,
      lv_lines         TYPE STANDARD TABLE OF tline,
      wa_final_text_es TYPE tline,
      wa_lines         LIKE tline.

if wa_FINAL-matnr is NOT INITIAL.
   CLEAR: lv_lines, lv_name,wa_lines.
   lv_name = wa_final-matnr.

     CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = 'E'
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


    DATA: lv_string TYPE string.

    lv_string = REDUCE #( INIT lv_str TYPE string FOR ls_tline IN lv_lines
     NEXT lv_str =  lv_str && ls_tline-tdline && | | ).

    TEXT_ES =  lv_string.
endif.





















