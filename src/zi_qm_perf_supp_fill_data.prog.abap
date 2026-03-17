*----------------------------------------------------------------------*
***INCLUDE ZI_QM_PERF_SUPP_FILL_DATA.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form fill_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FILL_DATA .
  LOOP AT LT_TEMP ASSIGNING FIELD-SYMBOL(<LFS_TEMP>).
    APPEND INITIAL LINE TO LT_MON_FINAL ASSIGNING FIELD-SYMBOL(<LFS_MON_FINAL>).
    <LFS_MON_FINAL>-LIFNR = <LFS_TEMP>-VENDOR_CODE.
    <LFS_MON_FINAL>-NAME1 = <LFS_TEMP>-VENDOR_NAME.
    <LFS_MON_FINAL>-ORT01 = <LFS_TEMP>-CITY.
    <LFS_MON_FINAL>-SUM_REC = <LFS_TEMP>-RECEIVED_QTY_101 - <LFS_TEMP>-RECEIVED_QTY_102.
    <LFS_MON_FINAL>-SUM_ACC = <LFS_TEMP>-SUM_OF_ACCEPTED_QTY.
    <LFS_MON_FINAL>-SUM_REJ = <LFS_TEMP>-SUM_OF_REJECTED_QTY.
    <LFS_MON_FINAL>-SUM_REW = <LFS_TEMP>-SUM_OF_REWORK_QTY.
    <LFS_MON_FINAL>-SUM_SRN = <LFS_TEMP>-SUM_OF_SRN_QTY.
    <LFS_MON_FINAL>-TOT_REJ = <LFS_TEMP>-SUM_OF_REJECTED_QTY + <LFS_TEMP>-SUM_OF_SRN_QTY.
    <LFS_MON_FINAL>-TOT_REW = <LFS_TEMP>-SUM_OF_REWORK_QTY + <LFS_TEMP>-SUM_OF_REJECTED_QTY + <LFS_TEMP>-SUM_OF_SRN_QTY.
    TRY.
    <LFS_MON_FINAL>-PER_SRN_REJ_QTY = ( <LFS_TEMP>-SUM_OF_REJECTED_QTY + <LFS_TEMP>-SUM_OF_SRN_QTY ) /
                                      ( <LFS_TEMP>-RECEIVED_QTY_101 - <LFS_TEMP>-RECEIVED_QTY_102 ) * 100.
    CATCH cx_sy_zerodivide INTO DATA(lx_zero_div).
      CLEAR <LFS_MON_FINAL>-PER_SRN_REJ_QTY.
      ENDTRY.
    " Handle divide-by-zero exception
      TRY.
    <LFS_MON_FINAL>-PER_REW_QTY =  <LFS_MON_FINAL>-SUM_REW  / <LFS_MON_FINAL>-SUM_REC * 100.
    CATCH cx_sy_zerodivide INTO lx_zero_div.
      endtry.
      try.
    <LFS_MON_FINAL>-PER_REW_REJ_QTY =  <LFS_MON_FINAL>-TOT_REW  / <LFS_MON_FINAL>-SUM_REC * 100.
     CATCH cx_sy_zerodivide INTO lx_zero_div.
      endtry.

    <LFS_MON_FINAL>-REJ_IN_PPM =  <LFS_MON_FINAL>-PER_REW_REJ_QTY * 10000.
    IF <LFS_MON_FINAL>-PER_REW_REJ_QTY IS NOT INITIAL.
      <LFS_MON_FINAL>-QUALITY_RATING =  100 - <LFS_MON_FINAL>-PER_REW_REJ_QTY.
    ENDIF.

  ENDLOOP.
ENDFORM.
