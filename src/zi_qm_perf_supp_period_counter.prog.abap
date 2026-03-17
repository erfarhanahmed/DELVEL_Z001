*----------------------------------------------------------------------*
***INCLUDE ZI_QM_PERF_SUPP_PERIOD_COUNTER.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form period_counter
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PERIOD_COUNTER .
  IF LV_FLAG1 = ABAP_FALSE.
    LV_FLAG1 = ABAP_TRUE.
  ELSEIF LV_FLAG2 = ABAP_FALSE.
    LV_FLAG2 = ABAP_TRUE.
  ELSEIF LV_FLAG3 = ABAP_FALSE.
    LV_FLAG3 = ABAP_TRUE.
  ELSEIF LV_FLAG4 = ABAP_FALSE.
    LV_FLAG4 = ABAP_TRUE.
  ELSEIF LV_FLAG5 = ABAP_FALSE.
    LV_FLAG5 = ABAP_TRUE.
  ELSEIF LV_FLAG6 = ABAP_FALSE.
    LV_FLAG6 = ABAP_TRUE.
  ELSEIF LV_FLAG7 = ABAP_FALSE.
    LV_FLAG7 = ABAP_TRUE.
  ELSEIF LV_FLAG8 = ABAP_FALSE.
    LV_FLAG8 = ABAP_TRUE.
  ELSEIF LV_FLAG9 = ABAP_FALSE.
    LV_FLAG9 = ABAP_TRUE.
  ELSEIF LV_FLAG10 = ABAP_FALSE.
    LV_FLAG10 = ABAP_TRUE.
  ELSEIF LV_FLAG11 = ABAP_FALSE.
    LV_FLAG11 = ABAP_TRUE.
  ELSEIF LV_FLAG12 = ABAP_FALSE.
    LV_FLAG12 = ABAP_TRUE.
  ENDIF.
ENDFORM.
