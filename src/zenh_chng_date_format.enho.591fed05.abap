"Name: \PR:SAPLBUD0\FO:SHOW_DATE\SE:BEGIN\EI
ENHANCEMENT 0 ZENH_CHNG_DATE_FORMAT.
DATA: lv_date_char TYPE string,
        lv_time_char TYPE string,
        lv_date1      TYPE dats,
        lv_time      TYPE tims,
        lv_timestamp TYPE timestamp.

  " Only handle date+time formatted values
  IF p_old CS '.' AND p_old CS ':'.

    SPLIT p_old AT space INTO lv_date_char lv_time_char.

    " DD.MM.YYYY -> YYYYMMDD
    lv_date1 = lv_date_char+6(4) &&
              lv_date_char+3(2) &&
              lv_date_char+0(2).

    " hh:mm:ss -> hhmmss
    lv_time = lv_time_char+0(2) &&
              lv_time_char+3(2) &&
              lv_time_char+6(2).

    CONVERT DATE lv_date1 TIME lv_time
           INTO TIME STAMP lv_timestamp
           TIME ZONE gv_tzone.

    WRITE lv_date1 TO p_old DD/MM/YYYY.

    EXIT. " ⬅ Prevent standard code from executing
  ENDIF.
ENDENHANCEMENT.
