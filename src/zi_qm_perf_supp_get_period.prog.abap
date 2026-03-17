*----------------------------------------------------------------------*
***INCLUDE ZI_QM_PERF_SUPP_GET_PERIOD.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_period
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_PERIOD .
  IF P_MONTH IS NOT INITIAL.
    IF P_YEAR IS INITIAL.
      P_YEAR = SY-DATUM+0(4).
    ENDIF.
    DATA(LV_START_DT) = SY-DATUM.
    DATA(LV_END_DT) = SY-DATUM.
    LV_START_DT = |{ P_YEAR }| && |{ P_MONTH+4(2) }| && |01|.

    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        DAY_IN            = LV_START_DT
      IMPORTING
        LAST_DAY_OF_MONTH = LV_END_DT
      EXCEPTIONS
        DAY_IN_NO_DATE    = 1
        OTHERS            = 2.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    LS_PERIOD-START_DT = LV_START_DT.
    LS_PERIOD-END_DT = LV_END_DT.
    APPEND LS_PERIOD TO LT_PERIOD.

  ENDIF.

  IF LV_YEAR_FLAG = ABAP_TRUE AND LV_MON_FLAG = ABAP_FALSE.
    P_MONTH+4(2) = '000004'.
    LV_START_DT = |{ P_YEAR }| && |{ P_MONTH+4(2) }| && |01|.
  ENDIF.

  IF LV_YEAR_FLAG = ABAP_TRUE AND LV_MON_FLAG = ABAP_FALSE.
    DO 12 TIMES.

      CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
        EXPORTING
          DAY_IN            = LV_START_DT
        IMPORTING
          LAST_DAY_OF_MONTH = LV_END_DT
        EXCEPTIONS
          DAY_IN_NO_DATE    = 1
          OTHERS            = 2.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.

      LS_PERIOD-START_DT = LV_START_DT.
      LS_PERIOD-END_DT = LV_END_DT.
      APPEND LS_PERIOD TO LT_PERIOD.

      IF P_MONTH+4(2) < 12.
        P_MONTH+4(2) = P_MONTH+4(2) + 1.
      ELSE.
        P_MONTH+4(2) = '01'.
        P_YEAR = P_YEAR + 1.
      ENDIF.
      LV_START_DT = |{ P_YEAR }| && |{ P_MONTH+4(2) }| && |01|.
    ENDDO.
  ENDIF.
  CLEAR P_MONTH.


ENDFORM.
