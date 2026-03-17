*READ TABLE TEXT_LINES1 INTO WA_TEXT_LINE1 INDEX 1.
*READ TABLE TEXT_LINES2 INTO WA_TEXT_LINE2 INDEX 1.


CLEAR : wa_text_line1 , wa_text_line2 .
IF text_lines2[] IS NOT INITIAL.
  LOOP AT text_lines2 INTO wa_text_line2.
    APPEND wa_text_line2 TO text_lines1 .
    CLEAR wa_text_line2 .
  ENDLOOP.
ENDIF.





















