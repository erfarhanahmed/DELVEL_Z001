* BREAK-POINT.
 refresh : text_lines1 , text_lines1[] ,
          text_lines2 , text_lines2[] .
     data:      objname       type          tdobname.
     clear : objname .

objname = wa_final-matnr.
 call function 'READ_TEXT'
    exporting
*     CLIENT                        = SY-MANDT
      id                            = 'GRUN'
      language                      = SY-LANGU
      name                          = objname
      object                        = 'MATERIAL'
    tables
      lines                         = text_lines2
   exceptions
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     others                        = 8.
CLEAR : wa_text_line2 .
DELETE text_lines2 WHERE TDLINE IS INITIAL.
*BREAK-POINT.
data : lv_lines2 TYPE string.
data : lv_word type string VALUE 'OXYGEN CLEANING'.
IF text_lines2[] IS NOT INITIAL.
  LOOP AT text_lines2 INTO wa_text_line2.
*    CONCATENATE wa_text_line2-TDLINE '' INTO wa_text_line2-TDLINE SEPARATED BY SPACE.
    APPEND wa_text_line2-TDLINE TO text_lines1  .
    CLEAR wa_text_line2 .
  ENDLOOP.
IF LV_OXY =  'NO'.
    LOOP AT text_lines2 INTO wa_text_line2.
     lv_lines2 = wa_text_line2-TDLINE.
FIND lv_word in lv_lines2.
IF SY-SUBRC = 0.
  LV_OXY = 'YES'.
  EXIT.
ELSE.
   LV_OXY = 'NO'.
ENDIF.
*    CONCATENATE wa_text_line2-TDLINE '' INTO wa_text_line2-TDLINE SEPARATED BY SPACE.
  ENDLOOP.
  ENDIF.
ENDIF.


















