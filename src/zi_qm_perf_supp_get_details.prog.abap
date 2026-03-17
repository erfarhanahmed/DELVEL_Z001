*----------------------------------------------------------------------*
***INCLUDE ZI_QM_PERF_SUPP_GET_DETAILS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_details
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DETAILS .
  SELECT *
        FROM ZZ_QM_SUPP_MON_CONSUME_CDS( P_STARTDT = @LS_PERIOD-START_DT , P_ENDDT = @LS_PERIOD-END_DT )
        WHERE VENDOR_CODE IN @S_LIFNR
        INTO TABLE @LT_TEMP.

  IF SY-SUBRC <> 0.
    CLEAR LT_TEMP.
  ENDIF.


ENDFORM.
