*----------------------------------------------------------------------*
***INCLUDE ZINCL_BOM_CS12_AMDP_GETDATAF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form Get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .
  CLEAR:IT_STLAN,IT_STLAL.
*IF 1 = 2.
*
*  IF pm_stlan IS NOT INITIAL.
*    wa_zst_stlan_range-sign = 'I'.
*    wa_zst_stlan_range-option  = 'EQ'.
*    wa_zst_stlan_range-low  = pm_stlan.
*    APPEND wa_zst_stlan_range TO it_stlan.
*  ENDIF.
*
*IF PM_STLAL IS NOT INITIAL.
*  wa_stlal-sign = 'I'.
*  wa_stlal-option  = 'EQ'.
*  wa_stlal-low =  PM_STLAL.
*APPEND wa_stlal to it_stlal.
*ENDIF.
*
*select *
*         FROM MAST
*         INTO TABLE @Data(IT_MAST)
*         where MATNR in  @S_MATNR
*           and WERKS = @PM_WERKS
*           and stlan in @it_stlan
*           and stlal in @it_stlal.
*
*LOOP AT IT_MAST INTO DATA(wa_MAST).
* p_matnr = wa_MAST-matnr.
* p_werks = wa_MAST-werks.
*  TRY.
*      zcl_bom_explosion=>explode_bom_with_text(
*        EXPORTING
*          iv_matnr  = p_matnr
*          iv_werks  = p_werks
*        IMPORTING
*          et_result = lt_bom ).
**      APPEND LINES OF  lt_bom TO  lt_bom_final.
*    CATCH cx_amdp_error INTO lx_amdp.
*      MESSAGE lx_amdp->get_text( ) TYPE 'E'.
*  ENDTRY.
*
*clear: wa_MAST, lt_bom.
*ENDLOOP.
*ENDIF.
***--------------------------------------------------------------------------
  "=== Original BOM type (AMDP output) =================================
  TYPES:
    BEGIN OF TY_BOM_ITEM,
      ROOT_MATNR   TYPE ABOMITEMS-BILLOFMATERIALCOMPONENT,
      PARENT_MATNR TYPE ABOMITEMS-BILLOFMATERIALCOMPONENT,
      MATNR        TYPE ABOMITEMS-BILLOFMATERIALCOMPONENT,
      BOM          TYPE MAST-STLNR,
      BOM_LEVEL    TYPE I,
      ISASSEMBLY   TYPE ABOMITEMS-ISASSEMBLY,
      POSNR        TYPE STPO-POSNR,
      ZEINR        TYPE MARA-ZEINR,
      MEINS        TYPE STPO-MEINS,
      MENGE        TYPE STPO-MENGE,
      MTART        TYPE MARA-MTART,
      VERPR        TYPE MBEW-VERPR,
    END OF TY_BOM_ITEM,
    TT_BOM_ITEM TYPE STANDARD TABLE OF TY_BOM_ITEM
                WITH EMPTY KEY.
  DATA: IT_BOMT TYPE TT_BOM_ITEM.
  TYPES:
    BEGIN OF TY_MATNR_KEY,
      MATNR TYPE MAST-MATNR,  "elementary
    END OF TY_MATNR_KEY,
    TT_MATNR TYPE STANDARD TABLE OF TY_MATNR_KEY WITH EMPTY KEY.
  DATA: IT_MATNR TYPE TT_MATNR.


  IT_MATNR = VALUE TT_MATNR(
                FOR LS_MATNR IN S_MATNR
                ( MATNR = LS_MATNR-LOW )
  ).
  ZCL_BOM_EXPLOSION_NEW=>EXPLODE_BOM_MASS_WITH_TEXT(
    EXPORTING
      IV_USE_OPEN_SO = P_BG
      IT_MATNR       = IT_MATNR
      IV_WERKS       = PM_WERKS
      IV_ANDAT       = PM_DATUV
    IMPORTING
      ET_RESULT      = LT_BOM_FINAL
  ).



*CATCH cx_amdp_error. " Exceptions when calling AMDP methods
ENDFORM.
*&---------------------------------------------------------------------*
*& Form Display_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV.

  DATA: GS_VARIANT TYPE DISVARIANT.
  GS_VARIANT-REPORT  = SY-REPID.
  GS_VARIANT-VARIANT = P_VAR.     "PARAMETER p_var TYPE disvariant-variant


*   PERFORM fcat USING pos 'BOM_LEVEL' 'BOM Level'.
  PERFORM FCAT USING POS 'BOM_LEVEL_V' 'BOM Level'.
  PERFORM FCAT USING POS 'POSNR' 'BOM item number'.
  PERFORM FCAT USING POS 'MATNR' 'Component material number'.
  PERFORM FCAT USING POS 'ZEINR' 'Drawing number'.
  PERFORM FCAT USING POS 'MENGE' 'Component quantity'.
  PERFORM FCAT USING POS 'MEINS' 'Base UoM'.
  PERFORM FCAT USING POS 'BILLOFMATERIALITEMCATEGORY' 'Item Category'.
  PERFORM FCAT USING POS 'AUSNM' 'Exception'.
  PERFORM FCAT USING POS 'SGT_RCAT' 'Requirement Segment'.
  PERFORM FCAT USING POS 'SGT_SCAT' 'Stock Segment'.
  PERFORM FCAT USING POS 'VERPR' 'Moving average price'.
  PERFORM FCAT USING POS 'MTART' 'Material type'.
  PERFORM FCAT USING POS 'MATERIAL_TEXT' 'material long text'.
  PERFORM FCAT USING POS 'MATERIAL_TEXT_ES' 'material long text Spanish'.
  PERFORM FCAT USING POS 'REFRESH_DATE' 'Refresh Date'.
*   PERFORM fcat USING pos '' ''.

*  PERFORM fcat USING pos 'ROOT_MATNR' 'Root material'.
*  PERFORM fcat USING pos 'PARENT_MATNR' 'Direct parent material in BOM'.
*  PERFORM fcat USING pos 'BOM' 'Bill of material number'.
*  PERFORM fcat USING pos 'BOM_LEVEL' 'Explosion BOM level (0,1,2,...)'.
*  PERFORM fcat USING pos 'ISASSEMBLY' 'Assembly indicator (X = assembly)'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET = 'STANDARD'
*     IS_LAYOUT          = ALVLO_STB
*     is_variant         = gs_variant
*     I_DEFAULT          = 'X'
*     i_save             = 'A'
*     I_STRUCTURE_NAME   = 'STPOX_ALV'
      IT_FIELDCAT        = IT_FCAT
    TABLES
*     t_outtab           = lt_bom_final
      T_OUTTAB           = IT_FINAL1
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.


ENDFORM.


FORM FCAT USING POS S_FIELDNAME S_SELTEXT.
  POS = POS + 1.
  WA_FCAT-COL_POS = POS.
  WA_FCAT-FIELDNAME = S_FIELDNAME.
  WA_FCAT-TABNAME = 'IT_FINAL'.
  WA_FCAT-SELTEXT_M = S_SELTEXT.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
ENDFORM."FCAT
*&---------------------------------------------------------------------*
*& Form DOWNLOAD
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DOWNLOAD .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  PERFORM FILL_FTP_STR.
*IT_FINAL_DOWNLOAD = CORRESPONDING #( lt_bom_final  ).

  LOOP AT LT_BOM_FINAL  INTO DATA(WA_BOM_FINAL).
    MOVE-CORRESPONDING WA_BOM_FINAL TO WA_FINAL_DOWNLOAD.
   WA_FINAL_DOWNLOAD-MTART = WA_BOM_FINAL-MATERIAL_TEXT.
    CONDENSE WA_FINAL_DOWNLOAD-VERPR.
    APPEND WA_FINAL_DOWNLOAD  TO IT_FINAL_DOWNLOAD.
    CLEAR: WA_FINAL_DOWNLOAD.
  ENDLOOP.


  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
*     I_TAB_SAP_DATA       = lt_bom_final
      I_TAB_SAP_DATA       = IT_FINAL_DOWNLOAD
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Bom 1'.
    PERFORM CVS_HEADER USING HD_CSV.
  ENDIF.
  LV_FILE = |ZCS12_NEW{ SY-DATUM }.TXT|.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZCS12 Download started on', SY-DATUM, 'at', SY-UZEIT.

  IF P_HIDDEN IS INITIAL OR P_HIDDEN = 'Bom 1'.
    OPEN DATASET LV_FULLFILE
      FOR OUTPUT IN TEXT MODE ENCODING DEFAULT MESSAGE LV_MSG.   "NON-UNICODE.
    IF SY-SUBRC = 0.
      DATA LV_STRING_878 TYPE STRING.
      DATA LV_CRLF_878 TYPE STRING.
      LV_CRLF_878 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
      LV_STRING_878 = HD_CSV.
      LOOP AT IT_CSV INTO WA_CSV.
        CONCATENATE LV_STRING_878 LV_CRLF_878 WA_CSV INTO LV_STRING_878.
        CLEAR: WA_CSV.
      ENDLOOP.
    ENDIF.
  ELSE.
    OPEN DATASET LV_FULLFILE
          FOR APPENDING IN TEXT MODE ENCODING DEFAULT MESSAGE LV_MSG.  "NON-UNICODE.
    IF SY-SUBRC = 0.
*      DATA LV_STRING_878 TYPE STRING.
*      DATA LV_CRLF_878 TYPE STRING.
      LV_CRLF_878 = CL_ABAP_CHAR_UTILITIES=>CR_LF.

      DESCRIBE TABLE IT_CSV LINES DATA(LV_LINETEM).
      LOOP AT IT_CSV INTO WA_CSV.
        IF LV_LINETEM > 1.
          IF SY-TABIX = 1.
            LV_STRING_878 = WA_CSV.
          ELSE.
            CONCATENATE LV_STRING_878 LV_CRLF_878 WA_CSV INTO LV_STRING_878.
          ENDIF.
        ELSE.
          CONCATENATE  WA_CSV LV_CRLF_878 INTO LV_STRING_878.
          LV_STRING_878 =  WA_CSV.
        ENDIF.
        CLEAR: WA_CSV.
      ENDLOOP.

    ENDIF.
  ENDIF.
*TRANSFER lv_string_1648 TO lv_fullfile.
  TRANSFER LV_STRING_878 TO LV_FULLFILE.
  CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
  MESSAGE LV_MSG TYPE 'S'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form FILL_FTP_STR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FILL_FTP_STR .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form cvs_header
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> HD_CSV
*&---------------------------------------------------------------------*
FORM CVS_HEADER  USING   PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
*   PERFORM fcat USING pos 'BOM_LEVEL' 'BOM Level'.
*   PERFORM fcat USING pos 'POSNR' 'BOM item number'.
*   PERFORM fcat USING pos 'MATNR' 'Component material number'.
*   PERFORM fcat USING pos 'MATERIAL_TEXT' 'material long text'.
*   PERFORM fcat USING pos 'ZEINR' 'Drawing number'.
*   PERFORM fcat USING pos 'MEINS' 'Base UoM'.
*   PERFORM fcat USING pos 'MENGE' 'Component quantity'.
  PERFORM FCAT USING POS 'MTART' 'Material type'.
  PERFORM FCAT USING POS 'VERPR' 'Moving average price'.
  CONCATENATE
  'Explosion Level'
  'Item Number'
*  'Objects'
  'Component NO.'
  'Object Discription'
  'Overflow Indicator'
  'Comp. Qty(CUn)'
  'Component Unit'
  'Item Category'
  'Exception'
  'Requirement Segment'
  'Stock Segment'
  'Moving Average price'
  'Material Long Text EN'
  'Refreshed On'
  'Material Long Text SP'
  INTO PD_CSV
  SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
