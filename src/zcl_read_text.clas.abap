class ZCL_READ_TEXT definition
  public
  create public .

public section.

  data IT_LINES type LOP_T_TLINE .
  data I_TEXTSTREAM type WCB_TDLINE_TAB .

  methods READ_TEXT_STRING_S
    importing
      value(ID) type TDID
      value(NAME) type TDOBNAME
      value(OBJECT) type TDOBJECT
    exporting
      value(LV_LINES) type STRING .
  methods READ_TEXT_STRING
    importing
      value(ID) type TDID
      value(NAME) type TDOBNAME
      value(OBJECT) type TDOBJECT
    exporting
      value(LV_LINES) type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_READ_TEXT IMPLEMENTATION.


  METHOD read_text_string.
    DATA tabix TYPE sy-tabix.
    DATA lv_char(1).
    DATA: lv_len           TYPE i,
          lv_index         TYPE i VALUE 0.
    SELECT SINGLE *
                    FROM stxh
                    INTO @DATA(wa_STXH)
                    WHERE tdobject = @object
                     AND tdname    = @name
                     AND tdid      = @id
                     AND tdspras   = 'E'.
    IF sy-subrc = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = id
          language                = wa_STXH-tdspras
          name                    = name
          object                  = object
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*         USE_OLD_PERSISTENCE     = ABAP_FALSE
* IMPORTING
*         HEADER                  =
*         OLD_LINE_COUNTER        =
        TABLES
          lines                   = it_lines
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
LOOP AT IT_LINES ASSIGNING FIELD-SYMBOL(<wa_LINES>).
lv_len = STRLEN( <wa_LINES> ) - 1.
      DO lv_len TIMES.

          lv_char = <wa_LINES>+sy-index(1).
          DATA(index) = sy-index.
          IF lv_char CO ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,./;''[]\-=_+(){}|: "<>?!@#$%^&*~`‘’  '.
*            lv_cleaned_text = lv_cleaned_text && lv_char.
          ELSE.
            <wa_LINES>+index(1) = space.
          ENDIF.
        ENDDO.

ENDLOOP.

      CALL FUNCTION 'CONVERT_ITF_TO_STREAM_TEXT'
        EXPORTING
          language    = sy-langu
        TABLES
          itf_text    = it_lines
          text_stream = i_textstream.

      LOOP AT i_textstream INTO DATA(wa_textstream).
         IF sy-tabix = 1.
          lv_lines = wa_textstream.
        ELSE.
          CONCATENATE lv_lines wa_TEXTSTREAM INTO lv_lines SEPARATED BY ' '.
        ENDIF.
        CLEAR:wa_textstream.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD READ_TEXT_STRING_S.
    DATA tabix TYPE sy-tabix.
    DATA lv_char(1).
    DATA: lv_len           TYPE i,
          lv_index         TYPE i VALUE 0.
    SELECT SINGLE *
                    FROM stxh
                    INTO @DATA(wa_STXH)
                    WHERE tdobject = @object
                     AND tdname    = @name
                     AND tdid      = @id
                     AND tdspras   = 'S'.
    IF sy-subrc = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = id
          language                = wa_STXH-tdspras
          name                    = name
          object                  = object
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*         USE_OLD_PERSISTENCE     = ABAP_FALSE
* IMPORTING
*         HEADER                  =
*         OLD_LINE_COUNTER        =
        TABLES
          lines                   = it_lines
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
LOOP AT IT_LINES ASSIGNING FIELD-SYMBOL(<wa_LINES>).
lv_len = STRLEN( <wa_LINES> ) - 1.
      DO lv_len TIMES.

          lv_char = <wa_LINES>+sy-index(1).
          DATA(index) = sy-index.
          IF lv_char CO ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,./;''[]\-=_+(){}|: "<>?!@#$%^&*~`‘’  '.
*            lv_cleaned_text = lv_cleaned_text && lv_char.
          ELSE.
            <wa_LINES>+index(1) = space.
          ENDIF.
        ENDDO.

ENDLOOP.

      CALL FUNCTION 'CONVERT_ITF_TO_STREAM_TEXT'
        EXPORTING
          language    = sy-langu
        TABLES
          itf_text    = it_lines
          text_stream = i_textstream.

      LOOP AT i_textstream INTO DATA(wa_textstream).
         IF sy-tabix = 1.
          lv_lines = wa_textstream.
        ELSE.
          CONCATENATE lv_lines wa_TEXTSTREAM INTO lv_lines SEPARATED BY ' '.
        ENDIF.
        CLEAR:wa_textstream.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
