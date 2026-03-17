READ TABLE gt_mkpf INTO wa_mkpf INDEX 1.
*BREAK-POINT.
DATA :lv_date1 TYPE sy-datum VALUE '20250416'.
SELECT SINGLE budat_mkpf FROM mseg INTO @DATA(lv_date)
  WHERE mblnr = @wa_mkpf-mblnr
  AND budat_mkpf >= @lv_date1.
IF sy-subrc = 0.
  lv_date_cond = 'X'.
ELSE.
  lv_date_cond = ''.
ENDIF.


















