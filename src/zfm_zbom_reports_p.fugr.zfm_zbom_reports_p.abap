FUNCTION ZFM_ZBOM_REPORTS_P.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(LV_JSON) TYPE  STRING
*"  TABLES
*"      WERKS STRUCTURE  RSWERKS OPTIONAL
*"      STLAN STRUCTURE  ZRSSTLAN OPTIONAL
*"      STLST STRUCTURE  ZRSSTLST OPTIONAL
*"      MATNR STRUCTURE  RSMATNR OPTIONAL
*"----------------------------------------------------------------------

  DATA: lt_list   TYPE TABLE OF abaplist,
        lv_output TYPE string,
        lt_lines  TYPE STANDARD TABLE OF string,
        lv_line   TYPE string.
*  RANGES so_date FOR mara-ersda.

  SUBMIT ZBOM_REPORTS
    WITH s_WERKS  IN WERKS[]
    WITH s_STLAN  IN STLAN[]
    WITH s_STLST  IN STLST[]
    WITH s_matnr  IN MATNR[]
    AND RETURN
   EXPORTING LIST TO MEMORY.
  IMPORT it_final FROM MEMORY ID 'ZBOM1'.
  FREE MEMORY ID 'ZBOM1'.
  CALL TRANSFORMATION id SOURCE my_table = it_final[] RESULT XML lv_json.



ENDFUNCTION.
