*----------------------------------------------------------------------*
***INCLUDE ZI_QM_PERF_SUPP_F4_YEARS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_years
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM F4_YEARS .

  TYPES: BEGIN OF p_date,
    pdate TYPE APYEAR,
  END OF p_date.

  DATA: it_p_date TYPE STANDARD TABLE OF p_date WITH HEADER LINE,
        pmy TYPE spmon.
  DATA: i_return TYPE ddshretval OCCURS 0 WITH HEADER LINE,
      c TYPE c VALUE 'S'.

 it_p_date-pdate = '1950'. " you Can Start From 1900 here.
  DO 100 TIMES.  "You can Increase Or Decrease The Number of year using this Value But I think it will Display MAX 5000 Values
    APPEND it_p_date to it_p_date.
    add 1 to it_p_date-pdate.
  ENDDO.
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield    = 'PDATE'
      dynpprog    = sy-repid
      dynpnr      = sy-dynnr
      dynprofield = 'crid'
      value_org   = c
    TABLES
      value_tab   = it_p_date
      return_tab  = i_return.

ENDFORM.
