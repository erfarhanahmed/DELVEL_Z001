*----------------------------------------------------------------------*
***INCLUDE ZI_QM_PERF_SUPP_AVG_CAL.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form Avg_calc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM AVG_CALC .
  data : lv_sum TYPE ZDE_QTY,
         lv_cnt TYPE i.
Loop at lt_yr_final ASSIGNING FIELD-SYMBOL(<lfs_yr_final>).
  if <lfs_yr_final>-period1 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period1.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period2 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period2.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period3 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period3.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period4 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period4.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period5 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period5.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period6 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period6.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period7 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period7.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period8 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period8.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period9 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period9.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period10 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period10.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period11 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period11.
    lv_cnt = lv_cnt + 1.
    endif.
    IF <lfs_yr_final>-period12 is not INITIAL.
    lv_sum = lv_sum + <lfs_yr_final>-period12.
    lv_cnt = lv_cnt + 1.
    endif.
    <lfs_yr_final>-avg = lv_sum / lv_cnt.
    clear : lv_sum , lv_cnt.
  ENDLOOP.
ENDFORM.
