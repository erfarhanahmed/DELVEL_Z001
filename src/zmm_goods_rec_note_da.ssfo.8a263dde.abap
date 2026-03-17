DATA: lv_vbeln     TYPE vbeln,
      lt_lines     TYPE TABLE OF tline,
      ls_lines     TYPE tline.
*      lv_proj_name TYPE string.

READ TABLE lt_afpo INTO wa_afpo INDEX 1.
READ TABLE it_konv INTO wa_konv WITH KEY kschl = 'JOCM'.
IF sy-subrc = 0.
  v_octroi1 = wa_konv-kwert.
ENDIF.

READ TABLE it_konv INTO wa_konv WITH KEY kschl = 'FRA1'.
IF sy-subrc = 0.
  v_kwert = wa_konv-kwert.
ENDIF.
SELECT knumv FROM ekko INTO TABLE it_ekko
  WHERE ebeln = gv_MSEG-ebeln.

oct_amt = v_octroi1.
trnsprt_amt = v_kwert.

CONDENSE : oct_amt , trnsprt_amt.


**--- Get Customer Project Name from SO Header Text
IF wa_afpo-kdauF IS NOT INITIAL.

 lv_vbeln = wa_afpo-kdauF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      id       = 'Z063'        " <-- Change if needed
      language = sy-langu
      name     = lv_vbeln
      object   = 'VBBK'
    TABLES
      lines    = lt_lines
    EXCEPTIONS
      OTHERS   = 1.

  IF sy-subrc = 0.
    LOOP AT lt_lines INTO ls_lines.
      CONCATENATE lv_proj_name ls_lines-tdline
        INTO lv_proj_name SEPARATED BY space.
    ENDLOOP.
  ENDIF.
*
ENDIF.
