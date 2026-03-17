DATA: lv_name   TYPE thead-tdname.
DATA: I_TLINE TYPE STANDARD TABLE OF tline.
 lv_name = wa_final-matnr.
 CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'GRUN'
          language                = sy-langu
          name                    = lv_name  "4410LE00027EB001'
          object                  = 'MATERIAL'
        TABLES
          lines                   = i_tline
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.


  IF NOT i_tline IS INITIAL.
      LOOP AT i_tline INTO DATA(wa_lines).
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE LV_STRING wa_lines-tdline INTO LV_STRING SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE LV_STRING.
    ENDIF.



















