

DATA : T_LIFNR TYPE LIFNR.

SELECT SINGLE KNUMV FROM EKKO INTO WA_EKKO
  WHERE EBELN = GV_MSEG-EBELN.

SELECT SINGLE LIFNR FROM KONV INTO T_LIFNR
  WHERE KNUMV = WA_EKKO-KNUMV.

SELECT SINGLE NAME1 INTO GV_LFA1-NAME1
  FROM LFA1 WHERE LIFNR = T_LIFNR.
********tag no
  DATA :  TEXT_LINES1 TYPE TABLE OF TLINE,
        WA_line1 TYPE TLINE,
          OBJNAME TYPE TDOBNAME.
*  BREAK-POINT.
  clear : tag_no , lv_inspection, owner_name.
  OBJNAME = gv_mseg-mat_kdauf.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'Z039'
      language                      = 'E'
      name                          = OBJNAME
      object                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = TEXT_LINES1
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8
     .
     LOOP AT TEXT_LINES1 INTO WA_LINE1.
      CONCATENATE tag_no WA_LINE1-TDLINE INTO tag_no.
    ENDLOOP.
    refresh : text_lines1.
********incpection
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'Z999'
      language                      = 'E'
      name                          = OBJNAME
      object                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = TEXT_LINES1
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8
     .
   LOOP AT TEXT_LINES1 INTO WA_LINE1.
      CONCATENATE LV_INSPECTION WA_LINE1-TDLINE INTO LV_INSPECTION.
    ENDLOOP.
    refresh : text_lines1.
**********owner name
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = 'Z102'
      language                      = 'E'
      name                          = OBJNAME
      object                        = 'VBBK'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = TEXT_LINES1
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8
     .
   LOOP AT TEXT_LINES1 INTO WA_LINE1.
      CONCATENATE OWNER_NAME WA_LINE1-TDLINE INTO OWNER_NAME.
    ENDLOOP.
    refresh : text_lines1.





















