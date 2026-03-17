*BREAK KANKIT.

    DATA:      objname       TYPE          tdobname.
*BREAK KANKIT.

*  OBJNAME = WA_ITEM-MATNR.

*  IF LANG IS INITIAL.
*    LANG = 'E'.
*  ENDIF.
    REFRESH : text_lines1 , text_lines1[] ,
              text_lines2 , text_lines2[] .

    CLEAR : objname .

    objname = wa_gr_item-matnr.

* BREAK fujiabap.
    """""""""""""""""""Added by Pranit 24.07.2024

    SELECT SINGLE stlnr FROM mast INTO @DATA(wa_mast) WHERE matnr = @wa_gr_item-matnr.

    objname = wa_gr_item-matnr.
    IF objname IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          id                      = 'GRUN'
          language                = sy-langu
          name                    = objname
          object                  = 'MATERIAL'
        TABLES
          lines                   = text_lines1
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          id                      = 'GRUN'
          language                = 'S'
          name                    = objname
          object                  = 'MATERIAL'
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*   IMPORTING
*         HEADER                  =
        TABLES
          lines                   = text_lines2
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
    ENDIF.
*    BREAK primusabap.

    SELECT SINGLE a~idnrk
          INTO @DATA(gs_main)
          FROM stpo AS a
          JOIN mast AS b ON b~stlnr EQ a~stlnr
          WHERE b~matnr = @wa_gr_item-matnr.

    SELECT SINGLE mtart FROM mara INTO @DATA(gs_main_n)
       WHERE matnr = @gs_main.

    IF gs_main IS NOT INITIAL.
      IF gs_main_n EQ 'ROH'.
        objname = gs_main.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
*           CLIENT                  = SY-MANDT
            id                      = 'GRUN'
            language                = 'S'
            name                    = objname
            object                  = 'MATERIAL'
          TABLES
            lines                   = text_lines2
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.
      ENDIF.
    ENDIF.
    SELECT SINGLE a~idnrk
       INTO @DATA(gs_main1)
       FROM stpo AS a
       JOIN mast AS b ON b~stlnr EQ a~stlnr
       WHERE b~matnr = @gs_main.

    SELECT SINGLE mtart FROM mara INTO @DATA(gs_main1_n)
WHERE matnr = @gs_main1.

    IF gs_main1_n EQ 'ROH'.
      objname = gs_main1.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          id                      = 'GRUN'
          language                = 'S'
          name                    = objname
          object                  = 'MATERIAL'
        TABLES
          lines                   = text_lines2
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
    ENDIF.

    SELECT SINGLE a~idnrk
           INTO @DATA(gs_main2)
           FROM stpo AS a
          INNER JOIN mast AS b ON b~stlnr EQ a~stlnr
           WHERE b~matnr = @gs_main1.

    SELECT SINGLE mtart FROM mara INTO @DATA(gs_main2_n)
      WHERE matnr = @gs_main2.

    IF gs_main2_n EQ 'ROH'.
      objname = gs_main2.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
*         CLIENT                  = SY-MANDT
          id                      = 'GRUN'
          language                = 'S'
          name                    = objname
          object                  = 'MATERIAL'
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*   IMPORTING
*         HEADER                  =
        TABLES
          lines                   = text_lines2
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
                                    OTHERS.
    ENDIF.
    DATA : lv_word TYPE string VALUE 'OXYGEN CLEANING'.
    DATA : lv_lines2 TYPE string.
*    BREAK-POINT.
    LOOP AT text_lines1 INTO DATA(wa_text).
      lv_lines2 = wa_text-tdline.
      FIND lv_word IN lv_lines2.
      IF sy-subrc = 0.
        lv_oxy = 'YES'.
        EXIT.
      ELSE  .
        lv_oxy = 'NO'.
        LOOP AT  text_lines2 INTO wa_text.
          lv_lines2 = wa_text-tdline.
          FIND lv_word IN lv_lines2.
          IF sy-subrc = 0.
            lv_oxy = 'YES'.
          ELSE  .
            lv_oxy = 'NO'.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
