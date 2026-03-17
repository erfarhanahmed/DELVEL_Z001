FUNCTION ZAERABIC_NUMBER_CONVERSION.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_NUM) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     VALUE(EV_RESULT) TYPE  STRING
*"----------------------------------------------------------------------

DATA LV_LENGTH TYPE NUM4 .
CONDENSE iv_num.
DATA: LV_NO TYPE i .
DATA: LV_FNO TYPE char1 .
data: lv_var type string.
*data

LV_length = strlen( iv_num ).
DO LV_length TIMES.

LV_FNO = IV_NUM+LV_NO(1).
*DATA(LV_B_NO) = LV_NO - 1 .
*
*DATA(LV_FNO) = iv_num+LV_B_NO(LV_NO) .
CASE LV_FNO.



  WHEN 1.
   LV_VAR = 'واحد'.
  WHEN 2.
   lv_var = 'إثنان'.
when 3.
 lv_var = 'ثلاثة'.
when 4.
    lv_var = 'أربعة'.
when 5.

 lv_var = 'خمسة' .

when 6.
 lv_var = 'ستة'.
when 7.
  lv_var =   'سبعة' .
when 8.
 lv_var = 'ثمانية' .

when 9.
 lv_var = 'تسعة' .

 when 0.
   lv_var = 'صفر'.

ENDCASE.

CONCATENATE EV_RESULT lv_var INTO EV_RESULT.
CONDENSE EV_RESULT.
LV_NO = LV_NO + 1 .
ENDDO.








ENDFUNCTION.
