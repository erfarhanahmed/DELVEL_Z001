*&---------------------------------------------------------------------*
*& Report ZPP_BOM_ROUTING_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_BOM_ROUTING_REPORT
       NO STANDARD PAGE HEADING LINE-SIZE 255.
*&*--------------------------------------------------------------------*
*&* TABLES
*&*--------------------------------------------------------------------*
TABLES: MARA.
*&*--------------------------------------------------------------------*
*&* STRUCTURE & INTERNAL TABLE DECLERATION
*&*--------------------------------------------------------------------*

DATA: BEGIN OF ALV_STB OCCURS 100.
        INCLUDE STRUCTURE STPOX_ALV.
DATA : LV_CNT(3).
DATA: INFO(3) TYPE C,
      END OF ALV_STB.

DATA: BEGIN OF DSP_SEL OCCURS 20,                           "YHG139715
        TEXT(30),                                           "YHG139715
        FILLER(2) VALUE '_ ',                               "YHG139715
        WERT(32),                                           "YHG139715
      END OF DSP_SEL.                                       "YHG139715

DATA: BEGIN OF ALV_STB1 OCCURS 0.
        INCLUDE STRUCTURE STPOX_ALV.

DATA : LV_CNT(3).
DATA: INFO(3) TYPE C.
DATA: LINE_COLOR(4) TYPE C,     "Used to store row color attributes
      END OF ALV_STB1.
DATA : CNT        TYPE SY-TABIX.
DATA: BEGIN OF ALV_STB2 OCCURS 0.
        INCLUDE STRUCTURE STPOX_ALV.
DATA : LV_CNT(3).
DATA: INFO(3) TYPE C.
DATA: LINE_COLOR(4) TYPE C,     "Used to store row color attributes
      END OF ALV_STB2.
DATA: BEGIN OF FTAB OCCURS 200.
        INCLUDE STRUCTURE DFIES.
DATA: END   OF FTAB.

TYPES: BEGIN OF FINAL ,
*      INCLUDE STRUCTURE stpox_alv.
         DGLVL     TYPE DGLVL,
         POSNR     TYPE POSNR,
         OBJIC     TYPE STRING,
         DOBJT     TYPE SOBJID,
         HEADER    TYPE SOBJID,
         OJTXP     TYPE OJTXP,
         OVFLS     TYPE OVFLS,
         MNGKO     TYPE CS_E_MNGKO,
         MEINS     TYPE MEINS,
         POSTP     TYPE POSTP,
         AUSNM     TYPE AUSNM,
         WERKS     TYPE WERKS_D,
         MTART     TYPE MTART,
         VPRSV     TYPE VPRSV,
         STPRS     TYPE STPRS,
         SBDKZ     TYPE SBDKZ,
         DISMM     TYPE DISMM,
         SOBSL     TYPE SOBSL,
         SOBSK     TYPE CK_SOBSL,
         FBSKZ     TYPE FBSKZ,
         PRCTR     TYPE PRCTR,
         IDNRK     TYPE IDNRK,
         MENGE     TYPE CS_KMPMG,
         DATUV     TYPE DATUV,
         ANDAT     TYPE ANDAT,
         DATUB     TYPE DTBIS,
         STKKZ     TYPE STKKZ,
         BOMFL     TYPE CSBFL,
         SGT_RCAT  TYPE SGT_RCAT,
         SGT_SCAT  TYPE SGT_SCAT,
         VERPR     TYPE CHAR15,
         ZZTEXT_EN TYPE CHAR250,
         ZZTEXT_SP TYPE CHAR250,
         MATNR     TYPE MAPL-MATNR,
*     WERKS TYPE MAPL-WERKS,
         PLNTY     TYPE MAPL-PLNTY,
         PLNNR     TYPE MAPL-PLNNR,
         PLNAL     TYPE MAPL-PLNAL,
         ZAEHL     TYPE MAPL-ZAEHL,
         VERWE     TYPE PLKO-VERWE,
         STATU     TYPE PLKO-STATU,
         VORNR     TYPE PLPO-VORNR,
         STEUS     TYPE PLPO-STEUS,
         ARBID     TYPE PLPO-ARBID,
         OBJTY     TYPE PLPO-OBJTY,
         LTXA1     TYPE PLPO-LTXA1,
         LAR01     TYPE PLPO-LAR01,
         VGE01     TYPE PLPO-VGE01,
         VGW01     TYPE PLPO-VGW01,
         OBJID     TYPE CRHD-OBJID,
         ARBPL     TYPE CRHD-ARBPL,
         KOSTL     TYPE CRCO-KOSTL,
         VALID     TYPE MAPL-DATUV,
*     VPRSV TYPE MBEW-VPRSV,
*     VERPR TYPE MBEW-VERPR,
*     STPRS TYPE MBEW-STPRS,
         BESKZ     TYPE MARC-BESKZ,
         ACT_TYPE  TYPE STRING, "COST-TKG001,
         ACT_COST  TYPE STRING, "COST-TKG001,

       END OF FINAL.
DATA: I_FINAL TYPE TABLE OF FINAL,
      W_FINAL TYPE FINAL.
TYPES: BEGIN OF TY_MBEW,
         MATNR TYPE MBEW-MATNR,
         BWKEY TYPE MBEW-BWKEY,
         BWTAR TYPE MBEW-BWTAR,
         VPRSV TYPE MBEW-VPRSV,
         VERPR TYPE MBEW-VERPR,
         STPRS TYPE MBEW-STPRS,
       END OF TY_MBEW.

DATA: LT_MBEW TYPE TABLE OF TY_MBEW,
      LS_MBEW TYPE TY_MBEW.

TYPES : BEGIN OF TY_MBEW1,
          MATNR TYPE MBEW-MATNR,
          WERKS TYPE MBEW-BWKEY,
        END OF TY_MBEW1.
DATA : LT_MBEW1 TYPE TABLE OF TY_MBEW1,
       LS_MBEW1 TYPE TY_MBEW1.

TYPES : BEGIN OF TY_MAKT,
          MANDT TYPE MAKT-MANDT,
          MATNR TYPE MAKT-MATNR,
          SPRAS TYPE MAKT-SPRAS,
          MAKTX TYPE MAKT-MAKTX,
        END OF TY_MAKT.

DATA : LT_MAKT TYPE TABLE OF TY_MAKT,
       LS_MAKT TYPE TY_MAKT.

DATA:
  WA_STB_FIELDS_TB TYPE SLIS_FIELDCAT_ALV,
  STB_FIELDS_TB    TYPE SLIS_T_FIELDCAT_ALV,
  REPORT_NAME      LIKE SY-REPID,
  ALVLO_STB        TYPE SLIS_LAYOUT_ALV,
  BDCDATA          TYPE TABLE OF BDCDATA WITH HEADER LINE,
  LT_BDCMSG        TYPE TABLE OF BDCMSGCOLL,
  LS_BDCMSG        TYPE BDCMSGCOLL,
  LV_MATNR         TYPE MARA-MATNR.
DATA:
  ALVVR_SAV_ALL    TYPE C VALUE 'A',
  ALVVR_SAV_NO_USR TYPE C VALUE 'X'.
DATA:LV_DAY(2),
     LV_MONTH(2),
     LV_YEAR(4),
     LV_DATE(10).
DATA : LV_CNT(3) VALUE 1.
DATA : CNT3      TYPE SY-TABIX.
DATA : CNT1     TYPE SY-TABIX.
DATA : LV_TABIX TYPE SY-TABIX.

TYPES : BEGIN OF TY_DOWN_FTP,
          DGLVL     TYPE DGLVL,
          POSNR     TYPE POSNR,
          OBJIC     TYPE STRING,
          DOBJT     TYPE STRING,
          HEADER    TYPE STRING,
          OJTXP     TYPE CHAR50,
          OVFLS     TYPE CHAR10,
          MNGKO     TYPE CHAR15,
          MEINS     TYPE CHAR15,
          POSTP     TYPE CHAR10,
          AUSNM     TYPE CHAR10,
          WERKS     TYPE CHAR10,
          MTART     TYPE CHAR10,
          VPRSV     TYPE CHAR10,
          STPRS     TYPE CHAR15,
          VERPR     TYPE CHAR15,
          SBDKZ     TYPE CHAR10,
          DISMM     TYPE CHAR10,
          SOBSL     TYPE CHAR10,
          SOBSK     TYPE CHAR10,
          FBSKZ     TYPE CHAR10,
          PRCTR     TYPE CHAR15,
          IDNRK     TYPE CHAR20,
          MENGE     TYPE CHAR15,
          DATUV     TYPE CHAR15,
          ANDAT     TYPE CHAR15,
          DATUB     TYPE CHAR15,
          BOMFL     TYPE CHAR10,
          SGT_RCAT  TYPE CHAR20,
          SGT_SCAT  TYPE CHAR20,
          ZZTEXT_EN TYPE CHAR255,
*        ZZTEXT_SP TYPE char255,
          MATNR     TYPE CHAR20,
          PLNTY     TYPE CHAR10,
          PLNNR     TYPE CHAR10,
          PLNAL     TYPE CHAR10,
          ZAEHL     TYPE CHAR10,
          VERWE     TYPE CHAR10,
          STATU     TYPE CHAR10,
          VORNR     TYPE CHAR10,
          STEUS     TYPE CHAR10,
          OBJTY     TYPE CHAR10,
          LTXA1     TYPE CHAR50,
          LAR01     TYPE CHAR10,
          VGE01     TYPE CHAR10,
          VGW01     TYPE CHAR10,
          OBJID     TYPE CHAR10,
          ARBPL     TYPE CHAR10,
          KOSTL     TYPE CHAR10,
          VALID     TYPE CHAR15,
          BESKZ     TYPE CHAR10,
          REF       TYPE CHAR15,
          ACT_TYPE  TYPE CHAR15,
          ACT_COST  TYPE CHAR15,
        END OF TY_DOWN_FTP.

DATA : GT_DOWN TYPE TABLE OF TY_DOWN_FTP,
       GS_DOWN TYPE TY_DOWN_FTP.

"------------------------------------------------------
DATA :I_TLINE TYPE STANDARD TABLE OF TLINE WITH HEADER LINE.
DATA :I_TLINE1 TYPE STANDARD TABLE OF TLINE WITH HEADER LINE.
DATA : LV_EBELN(70) TYPE C.
DATA : LV_TEXT(20000) TYPE C.
DATA : LV_TEXT1(20000) TYPE C.

DATA : LT_STXH TYPE TABLE OF STXH,
       LS_STXH TYPE STXH.

DATA : LT_STXH1 TYPE TABLE OF STXH,
       LS_STXH1 TYPE STXH.

CONSTANTS : LV_SPRAS(01) TYPE C VALUE 'S'.      "stxh-tdspras

TYPES: BEGIN OF TY_MAPL,
         MATNR TYPE MAPL-MATNR,
         WERKS TYPE MAPL-WERKS,
         PLNTY TYPE MAPL-PLNTY,
         PLNNR TYPE MAPL-PLNNR,
         PLNAL TYPE MAPL-PLNAL,
         ZAEHL TYPE MAPL-ZAEHL,
         ANDAT TYPE MAPL-ANDAT,
         DATUV TYPE MAPL-DATUV,
       END OF TY_MAPL.

TYPES: BEGIN OF TY_PLKO,
         PLNTY TYPE PLKO-PLNTY,
         PLNNR TYPE PLKO-PLNNR,
         PLNAL TYPE PLKO-PLNAL,
         ZAEHL TYPE PLKO-ZAEHL,
         VERWE TYPE PLKO-VERWE,
         WERKS TYPE PLKO-WERKS,
         STATU TYPE PLKO-STATU,
       END OF TY_PLKO.

TYPES: BEGIN OF TY_PLPO,
         PLNTY TYPE PLPO-PLNTY,
         PLNNR TYPE PLPO-PLNNR,
         ZAEHL TYPE PLPO-ZAEHL,
         VORNR TYPE PLPO-VORNR,
         STEUS TYPE PLPO-STEUS,
         ARBID TYPE PLPO-ARBID,
         OBJTY TYPE PLPO-OBJTY,
         WERKS TYPE PLPO-WERKS,
         LTXA1 TYPE PLPO-LTXA1,
         LAR01 TYPE PLPO-LAR01,
         VGE01 TYPE PLPO-VGE01,
         VGW01 TYPE PLPO-VGW01,
         "ARBTY TYPE PLPO-ARBTY,
         "NETID TYPE PLPO-NETID,
       END OF TY_PLPO.

TYPES: BEGIN OF TY_CRHD,
         OBJTY TYPE CRHD-OBJTY,
         OBJID TYPE CRHD-OBJID,
         ARBPL TYPE CRHD-ARBPL,
         WERKS TYPE CRHD-WERKS,
*        KOSTL TYPE CRHD-KOSTL,
       END OF TY_CRHD.
TYPES : BEGIN OF TY_CRCO,
          OBJID TYPE CRHD-OBJID,
          KOSTL TYPE CRCO-KOSTL,
        END OF TY_CRCO.

TYPES: BEGIN OF TY_FINAL,
         MATNR    TYPE MAPL-MATNR,
         WERKS    TYPE MAPL-WERKS,
         PLNTY    TYPE MAPL-PLNTY,
         PLNNR    TYPE MAPL-PLNNR,
         PLNAL    TYPE MAPL-PLNAL,
         ZAEHL    TYPE MAPL-ZAEHL,
         ANDAT    TYPE MAPL-ANDAT,
         DATUV    TYPE MAPL-DATUV,

         VERWE    TYPE PLKO-VERWE,
         STATU    TYPE PLKO-STATU,
         VORNR    TYPE PLPO-VORNR,
         STEUS    TYPE PLPO-STEUS,
         ARBID    TYPE PLPO-ARBID,
         OBJTY    TYPE PLPO-OBJTY,
         LTXA1    TYPE PLPO-LTXA1,
         LAR01    TYPE PLPO-LAR01,
         VGE01    TYPE PLPO-VGE01,
         VGW01    TYPE PLPO-VGW01,
         OBJID    TYPE CRHD-OBJID,
         ARBPL    TYPE CRHD-ARBPL,
         KOSTL    TYPE CRCO-KOSTL,
         ACT_TYPE TYPE DMBTR,   "ADDED BY DHANASHREE
         ACT_COST TYPE DMBTR,   "ADDED BY DHANASHREE
       END OF TY_FINAL.

DATA: LT_MAPL TYPE TABLE OF TY_MAPL,
      LS_MAPL TYPE TY_MAPL.
DATA: LT_PLKO TYPE TABLE OF TY_PLKO,
      LS_PLKO TYPE TY_PLKO.
DATA: LT_CRHD TYPE TABLE OF TY_CRHD,
      LS_CRHD TYPE TY_CRHD.
DATA: LT_CRCO TYPE TABLE OF TY_CRCO,
      LS_CRCO TYPE TY_CRCO.
DATA: LT_PLPO TYPE TABLE OF TY_PLPO,
      LS_PLPO TYPE TY_PLPO.
DATA: WA_MBEW TYPE MBEW,
      WA_MARC TYPE MARC.

DATA : IT_COST  TYPE TABLE OF COST,
       WA_COST  TYPE COST,
       ACT_TYPE TYPE STRING.

DATA: LT_FINAL TYPE TABLE OF TY_FINAL,
      LS_FINAL TYPE TY_FINAL.

DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.


*&*--------------------------------------------------------------------*
*&* SELECTION SCREEN
*&*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
  SELECT-OPTIONS : S_MATNR  FOR MARA-MATNR  NO INTERVALS.
  PARAMETERS     : PM_WERKS LIKE MARC-WERKS,
                   PM_DATUV LIKE STKO-DATUV DEFAULT SY-DATUM,
                   PM_STLAN LIKE STZU-STLAN,
                   PM_STLAL LIKE STKO-STLAL,
                   PM_CAPID LIKE TC04-CAPID,
************ added by dhanashree req by Atul Sir ************
                   S_GJAHR  TYPE COST-GJAHR,
                   S_PERIOD TYPE ZPERIOD,
********** ended ***************
                   CTU_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'N' NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK B1.

**Added By Sarika Thange 06.03.2019
SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India' . "'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-006.
SELECTION-SCREEN END OF LINE.


*&*--------------------------------------------------------------------*
*&* START OF SELECTION
*&*--------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM FETCH_DATA.         "Fetch Data

  PERFORM ROUTING.
  PERFORM SORT.
  PERFORM DATA_RETRIEVAL.     "Color Rows in report
*    PERFORM stb_fields_tb_prep. "Field Catlog
  PERFORM GET_FCAT.
  PERFORM GET_DISPLAY.




*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
FORM FETCH_DATA.
**Current Date
  CLEAR:LV_DAY,LV_MONTH,LV_YEAR,LV_DATE.
  LV_DAY   = PM_DATUV+6(2).
  LV_MONTH = PM_DATUV+4(2).
  LV_YEAR  = PM_DATUV+0(4).

  CONCATENATE LV_DAY LV_MONTH LV_YEAR INTO LV_DATE SEPARATED BY '.'.


  SELECT MANDT
         MATNR
         SPRAS
         MAKTX
    FROM MAKT
    INTO TABLE LT_MAKT
    WHERE MATNR IN S_MATNR
    AND   SPRAS EQ 'E'.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  LOOP AT S_MATNR.
*    cnt1 = sy-tabix.
    "Report:ZCS11

    PERFORM BDC.
    "Import From "Report-ZCS11"
    IMPORT ALV_STB[] FROM MEMORY ID 'ALV_STB'.

"code add for running in background
    IF ALV_STB[] IS INITIAL.
      DATA REFERENCE TYPE REF TO DATA.
      FIELD-SYMBOLS:<FTABLE> TYPE  TABLE.

      CL_SALV_BS_RUNTIME_INFO=>SET( DISPLAY = ABAP_FALSE METADATA = ABAP_TRUE DATA = ABAP_TRUE ).

"call of program for getting data of an internal table data
      SUBMIT ZCS12
             WITH PM_MTNRV = S_MATNR-LOW
             WITH PM_WERKS = PM_WERKS
             WITH PM_CAPID = PM_CAPID
             WITH PM_DATUV = PM_DATUV
             WITH PM_EHNDL = '1'
             WITH PM_STLAN = PM_STLAN
             WITH PM_STLAL = PM_STLAL
             AND RETURN.

      TRY.
          CL_SALV_BS_RUNTIME_INFO=>GET_DATA_REF( IMPORTING R_DATA = REFERENCE ).
          ASSIGN REFERENCE->* TO <FTABLE>.
*        er_entity = <ftable>.
*        APPEND reference to et_entityset.
        CATCH CX_SALV_BS_SC_RUNTIME_INFO.
      ENDTRY.
      CL_SALV_BS_RUNTIME_INFO=>SET( DISPLAY = ABAP_TRUE METADATA = ABAP_FALSE DATA = ABAP_TRUE ).

      MOVE-CORRESPONDING <FTABLE>[] TO ALV_STB[].

    ENDIF.
"end of code

    IF ALV_STB[] IS NOT INITIAL.
      "GET MATERIAL DESCRIPTION         """""""""""""""""""""ADDED ON 16.042019 BY MRUNALEE
      READ TABLE LT_MAKT INTO LS_MAKT WITH KEY MATNR = S_MATNR-LOW.
      IF SY-SUBRC = 0.
        ALV_STB-OJTXP = LS_MAKT-MAKTX.
      ENDIF.
      "GET MATERIAL NUMBER
      ALV_STB-DOBJT = S_MATNR-LOW.
      INSERT ALV_STB INTO ALV_STB[] INDEX 1. "
      APPEND LINES OF ALV_STB[] TO ALV_STB1[] .
    ENDIF.

    REFRESH ALV_STB[].
    FREE MEMORY ID 'ALV_STB'.
    CLEAR:S_MATNR,CNT1.
  ENDLOOP.

*  LOOP AT alv_stb1 INTO alv_stb1.
*    ls_mbew1-matnr = alv_stb1-dobjt.
*    ls_mbew1-werks = alv_stb1-werks.
*    APPEND ls_mbew1 TO lt_mbew1.
*    CLEAR : ls_mbew1 , alv_stb1.
*  ENDLOOP.
*
*  SELECT   matnr
*           bwkey
*           bwtar
*           vprsv
*           verpr
*           stprs
*    FROM mbew
*    INTO TABLE lt_mbew
*    FOR ALL ENTRIES IN lt_mbew1
*    WHERE matnr = lt_mbew1-matnr
*    AND   bwkey = lt_mbew1-werks.
*
*  LOOP AT alv_stb1 INTO alv_stb1.
*    cnt3 = sy-tabix.
*    READ TABLE lt_mbew1 INTO ls_mbew1 WITH KEY matnr = alv_stb1-dobjt werks = alv_stb1-werks.
*    IF sy-subrc = 0..
*      READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_mbew1-matnr bwkey = ls_mbew1-werks.
*      IF sy-subrc = 0.
*        alv_stb1-verpr = ls_mbew-verpr.
*        MODIFY alv_stb1 FROM alv_stb1 INDEX cnt3 TRANSPORTING verpr.
*      ENDIF.
*    ENDIF.
*
*    CLEAR : ls_mbew,alv_stb1,cnt3,ls_mbew.
*  ENDLOOP.


  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""to get the long text
  LOOP AT ALV_STB1.

    LV_EBELN = ALV_STB1-DOBJT.

    SELECT *
      FROM STXH
      INTO TABLE LT_STXH
    WHERE TDOBJECT = 'MATERIAL'
      AND TDNAME   = LV_EBELN
      AND  TDSPRAS = 'EN'
      AND TDID     = 'GRUN'.

    SELECT *
     FROM STXH
     INTO TABLE LT_STXH1
   WHERE TDOBJECT = 'MATERIAL'
     AND TDNAME   = LV_EBELN
     AND  TDSPRAS = LV_SPRAS
     AND TDID     = 'GRUN'.


*    LOOP AT lt_stxh INTO ls_stxh.

    READ TABLE LT_STXH INTO LS_STXH INDEX 1.
    IF SY-SUBRC = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          ID                      = LS_STXH-TDID    "GRUN
          LANGUAGE                = LS_STXH-TDSPRAS "sy-langu
          NAME                    = LS_STXH-TDNAME  "4410LE00027EB001'
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = I_TLINE
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
    ENDIF.

    READ TABLE LT_STXH1 INTO LS_STXH1 INDEX 1.
    IF SY-SUBRC = 0.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          ID                      = LS_STXH1-TDID    "GRUN
          LANGUAGE                = LS_STXH1-TDSPRAS "sy-langu
          NAME                    = LS_STXH1-TDNAME  "4410LE00027EB001'
          OBJECT                  = 'MATERIAL'
        TABLES
          LINES                   = I_TLINE1
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
    ENDIF.

    LOOP AT I_TLINE.
      CONCATENATE LV_TEXT I_TLINE-TDLINE INTO LV_TEXT SEPARATED BY SPACE.
      CLEAR: I_TLINE.
    ENDLOOP.

    LOOP AT I_TLINE1.
      CONCATENATE LV_TEXT1 I_TLINE1-TDLINE INTO LV_TEXT1 SEPARATED BY SPACE.
      CLEAR: I_TLINE1.
    ENDLOOP.


    "get Material Long Text EN
    ALV_STB1-ZZTEXT_EN = LV_TEXT. """""""""""""""""""""""""""""""""""""""""added ON 26.042019 BY MRUNALEE
    ALV_STB1-ZZTEXT_SP = LV_TEXT1.

    MODIFY ALV_STB1 TRANSPORTING ZZTEXT_EN ZZTEXT_SP.

    CLEAR : LV_TEXT,ALV_STB1-ZZTEXT_EN,ALV_STB1-ZZTEXT_SP,LV_TEXT1.

  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  BDC
*&---------------------------------------------------------------------*
FORM BDC.
  REFRESH BDCDATA[].
  REFRESH LT_BDCMSG[].

  PERFORM BDC_DYNPRO      USING 'ZCS12' '1000'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'PM_MTNRV'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=ONLI'.
  PERFORM BDC_FIELD       USING 'PM_MTNRV'
                                 S_MATNR-LOW.    "'A5003C-20001426-02'.
  PERFORM BDC_FIELD       USING 'PM_WERKS'
                                PM_WERKS.        "'PL01'.
  PERFORM BDC_FIELD       USING 'PM_CAPID'
                                PM_CAPID.        "'PP01'.
  PERFORM BDC_FIELD       USING 'PM_DATUV'
                                LV_DATE.         "'02.04.2019'.
  PERFORM BDC_FIELD       USING 'PM_EHNDL'
                                '1'.
  PERFORM BDC_DYNPRO      USING 'SAPMSSY0' '0120'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=&F03'.
  PERFORM BDC_DYNPRO      USING 'ZCS12' '1000'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '/EENDE'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'PM_MTNRV'.


  CALL TRANSACTION 'ZCS12_NEW'
          USING BDCDATA
                MODE CTU_MODE
                UPDATE 'S'
                MESSAGES INTO LT_BDCMSG.

ENDFORM.


FORM DATA_RETRIEVAL.
  DATA: LD_COLOR(1) TYPE C.
*Populate field with color attributes
  LOOP AT ALV_STB1.
    IF ALV_STB1-POSNR IS INITIAL AND ALV_STB1-DSTUF IS NOT INITIAL.
* Populate color variable with colour properties("alv_stb1-line_color")
* Char 1 = C (This is a color property)
* Char 2 = 3 (Color codes: 1 - 7)
* Char 3 = Intensified on/off ( 1 or 0 )
* Char 4 = Inverse display on/off ( 1 or 0 )
      "Yellow
      LD_COLOR = 3.

      CONCATENATE 'C' LD_COLOR '00' INTO ALV_STB1-LINE_COLOR.
      MODIFY ALV_STB1 TRANSPORTING LINE_COLOR.
    ELSEIF ALV_STB1-POSNR IS INITIAL AND ALV_STB1-DSTUF IS INITIAL.
      "Red
      LD_COLOR = 6.

      CONCATENATE 'C' LD_COLOR '00' INTO ALV_STB1-LINE_COLOR.
      MODIFY ALV_STB1 TRANSPORTING LINE_COLOR.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " DATA_RETRIEVAL
*----------------------------------------------------------------------*
*        START NEW SCREEN                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        INSERT FIELD                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
  CLEAR BDCDATA.
  BDCDATA-FNAM = FNAM.
  BDCDATA-FVAL = FVAL.
  APPEND BDCDATA.
*  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  ROUTING
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ROUTING .


  SELECT MATNR
         WERKS
         PLNTY
         PLNNR
         PLNAL
         ZAEHL
         ANDAT
         DATUV FROM MAPL
               INTO TABLE LT_MAPL
               FOR ALL ENTRIES IN ALV_STB1
               WHERE MATNR = ALV_STB1-DOBJT+0(40)"IN P_MATNR
*                 AND ANDAT IN P_ANDAT
                 AND WERKS EQ 'PL01'
                 AND PLNTY = 'N'.

  SELECT PLNTY
         PLNNR
         PLNAL
         ZAEHL
         VERWE
         WERKS
         STATU FROM PLKO
               INTO TABLE LT_PLKO
               FOR ALL ENTRIES IN LT_MAPL
               WHERE PLNTY = LT_MAPL-PLNTY
                 AND PLNNR = LT_MAPL-PLNNR
                 AND WERKS = LT_MAPL-WERKS
                 AND PLNAL = LT_MAPL-PLNAL
                 AND ZAEHL = LT_MAPL-ZAEHL.
  .
  IF LT_PLKO IS NOT INITIAL.

    SELECT PLNTY
           PLNNR
           ZAEHL
           VORNR
           STEUS
           ARBID
           OBJTY
           WERKS
           LTXA1
           LAR01
           VGE01
           VGW01 FROM PLPO
                 INTO TABLE LT_PLPO
                 FOR ALL ENTRIES IN LT_MAPL
                 WHERE PLNTY = LT_MAPL-PLNTY
                   AND PLNNR = LT_MAPL-PLNNR
                   AND ZAEHL = LT_MAPL-ZAEHL.
  ENDIF.
  IF LT_PLPO IS NOT INITIAL.
    SELECT OBJTY
           OBJID
           ARBPL
           WERKS

                 FROM CRHD INTO TABLE LT_CRHD
                 FOR ALL ENTRIES IN LT_PLPO
                 WHERE OBJID = LT_PLPO-ARBID.
    "AND OBJID = LT_PLPO-NETID.

    SELECT OBJID
           KOSTL FROM CRCO INTO TABLE LT_CRCO
           FOR ALL ENTRIES IN LT_PLPO
           WHERE OBJID = LT_PLPO-ARBID.
  ENDIF.

****************** ADDED BY DHANASHREE REQ BY ATUL SIR***************
  SELECT OBJNR
         GJAHR
         TKG001
         TKG002
         TKG003
         TKG004
         TKG005
         TKG006
         TKG007
         TKG008
         TKG009
         TKG010
         TKG011
         TKG012
         TKG013
         TKG014
         TKG015
         TKG016
     FROM COST
     INTO CORRESPONDING FIELDS OF TABLE IT_COST
     WHERE GJAHR = S_GJAHR.

******************** ENDED *******************

  LOOP AT LT_MAPL INTO LS_MAPL.
    LS_FINAL-MATNR = LS_MAPL-MATNR.
    LS_FINAL-WERKS = LS_MAPL-WERKS.
    LS_FINAL-PLNTY = LS_MAPL-PLNTY.
    LS_FINAL-PLNNR = LS_MAPL-PLNNR.
    LS_FINAL-PLNAL = LS_MAPL-PLNAL.
    LS_FINAL-ZAEHL = LS_MAPL-ZAEHL.
    LS_FINAL-ANDAT = LS_MAPL-ANDAT.
    LS_FINAL-DATUV = LS_MAPL-DATUV.


    READ TABLE LT_PLKO INTO LS_PLKO WITH KEY PLNTY = LS_MAPL-PLNTY PLNNR = LS_MAPL-PLNNR WERKS = LS_MAPL-WERKS ZAEHL = LS_MAPL-ZAEHL.
    IF SY-SUBRC = 0.
*  LS_FINAL-PLNTY = LS_PLKO-PLNTY.
*  LS_FINAL-PLNNR = LS_PLKO-PLNNR.
*  LS_FINAL-PLNAL = LS_PLKO-PLNAL.
*  LS_FINAL-ZAEHL = LS_PLKO-ZAEHL.
      LS_FINAL-VERWE = LS_PLKO-VERWE.
*  LS_FINAL-WERKS = LS_PLKO-WERKS.
      LS_FINAL-STATU = LS_PLKO-STATU.
    ENDIF.

    READ TABLE LT_PLPO INTO LS_PLPO WITH KEY PLNTY = LS_MAPL-PLNTY PLNNR = LS_MAPL-PLNNR ZAEHL = LS_MAPL-ZAEHL.
    IF SY-SUBRC = 0.
*  LS_FINAL-PLNTY = LS_PLPO-PLNTY.
*  LS_FINAL-PLNNR = LS_PLPO-PLNNR.
*  LS_FINAL-ZAEHL = LS_PLPO-ZAEHL.
      LS_FINAL-VORNR = LS_PLPO-VORNR.
      LS_FINAL-STEUS = LS_PLPO-STEUS.
*  LS_FINAL-ARBID = LS_PLPO-ARBID.
*  LS_FINAL-OBJTY = LS_PLPO-OBJTY.
*  LS_FINAL-WERKS = LS_PLPO-WERKS.
      LS_FINAL-LTXA1 = LS_PLPO-LTXA1.
      LS_FINAL-LAR01 = LS_PLPO-LAR01.
      LS_FINAL-VGE01 = LS_PLPO-VGE01.
      LS_FINAL-VGW01 = LS_PLPO-VGW01.
    ENDIF.

    READ TABLE LT_CRHD INTO LS_CRHD WITH KEY OBJID = LS_PLPO-ARBID.
    IF SY-SUBRC = 0.
      LS_FINAL-OBJID = LS_CRHD-OBJID.
      LS_FINAL-OBJTY = LS_CRHD-OBJTY.
      LS_FINAL-ARBPL = LS_CRHD-ARBPL.
*  LS_FINAL-KOSTL = LS_CRHD-KOSTL.
    ENDIF.

    READ TABLE LT_CRCO INTO LS_CRCO WITH KEY OBJID = LS_PLPO-ARBID.
    IF SY-SUBRC = 0.
      LS_FINAL-KOSTL = LS_CRCO-KOSTL.
    ENDIF.

*************** ADDED BY DHANASHREE REQ BY ATUL SIR **************
    CONCATENATE 'KLDL00' LS_FINAL-KOSTL LS_FINAL-LAR01 INTO ACT_TYPE.
    DATA : PER  TYPE CHAR2,
           TKG1 TYPE STRING.

    READ TABLE IT_COST INTO WA_COST WITH KEY OBJNR = ACT_TYPE.
    IF SY-SUBRC = 0.
      CASE S_PERIOD.
        WHEN '1'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG001.
        WHEN '2'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG002.
        WHEN '3'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG003.
        WHEN '4'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG004.
        WHEN '5'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG005.
        WHEN '6'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG006.
        WHEN '7'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG007.
        WHEN '8'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG008.
        WHEN '9'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG009.
        WHEN '10'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG010.
        WHEN '11'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG011.
        WHEN '12'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG012.
        WHEN '13'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG013.
        WHEN '14'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG014.
        WHEN '15'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG015.
        WHEN '16'.
          LS_FINAL-ACT_TYPE = WA_COST-TKG016.
      ENDCASE.
    ENDIF.

    LS_FINAL-ACT_COST = LS_FINAL-VGW01 * LS_FINAL-ACT_TYPE.

************ ENDED **************************

    APPEND LS_FINAL TO LT_FINAL.
    CLEAR LS_FINAL.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT .
  DATA:INDEX TYPE SY-INDEX.
  DATA:HEADER TYPE MARA-MATNR.
*SORT alv_stb1 by dobjt.
  SORT LT_FINAL BY MATNR.
*BREAK primus.
  LOOP AT ALV_STB1.
    W_FINAL-DGLVL     = ALV_STB1-DGLVL    .
    W_FINAL-POSNR     = ALV_STB1-POSNR    .
    IF W_FINAL-POSNR IS INITIAL.
      HEADER  = ALV_STB1-DOBJT.
    ENDIF.
    W_FINAL-HEADER    = HEADER.
    W_FINAL-OBJIC     = ALV_STB1-OBJIC    .
    W_FINAL-DOBJT     = ALV_STB1-DOBJT    .
    W_FINAL-OJTXP     = ALV_STB1-OJTXP    .
    W_FINAL-OVFLS     = ALV_STB1-OVFLS    .
    W_FINAL-MNGKO     = ALV_STB1-MNGKO    .
    W_FINAL-MEINS     = ALV_STB1-MEINS    .
    W_FINAL-POSTP     = ALV_STB1-POSTP    .
    W_FINAL-AUSNM     = ALV_STB1-AUSNM    .
    W_FINAL-SGT_RCAT  = ALV_STB1-SGT_RCAT .
    W_FINAL-SGT_SCAT  = ALV_STB1-SGT_SCAT .
*w_final-verpr     = alv_stb1-verpr    .
    W_FINAL-ZZTEXT_EN = ALV_STB1-ZZTEXT_EN.
    W_FINAL-ZZTEXT_SP = ALV_STB1-ZZTEXT_SP.

    W_FINAL-WERKS = ALV_STB1-WERKS.
    W_FINAL-MTART = ALV_STB1-MTART.
*w_final-VPRSV = alv_stb1-VPRSV.
*w_final-STPRS = alv_stb1-STPRS.
    W_FINAL-SBDKZ = ALV_STB1-SBDKZ.
    W_FINAL-DISMM = ALV_STB1-DISMM.
    W_FINAL-SOBSL = ALV_STB1-SOBSL.
    W_FINAL-SOBSK = ALV_STB1-SOBSK.
    W_FINAL-FBSKZ = ALV_STB1-FBSKZ.
    W_FINAL-PRCTR = ALV_STB1-PRCTR.
    W_FINAL-IDNRK = ALV_STB1-IDNRK.
    W_FINAL-MENGE = ALV_STB1-MENGE.
    W_FINAL-DATUV = ALV_STB1-DATUV.
    W_FINAL-ANDAT = ALV_STB1-ANDAT.
    W_FINAL-DATUB = ALV_STB1-DATUB.
    W_FINAL-STKKZ = ALV_STB1-STKKZ.
    W_FINAL-BOMFL = ALV_STB1-BOMFL.

    SELECT SINGLE * FROM MBEW INTO WA_MBEW WHERE MATNR = W_FINAL-DOBJT AND BWKEY = W_FINAL-WERKS.

    SELECT SINGLE * FROM MARC INTO WA_MARC WHERE MATNR = W_FINAL-DOBJT AND WERKS = W_FINAL-WERKS.

    W_FINAL-VPRSV = WA_MBEW-VPRSV.
    W_FINAL-VERPR = WA_MBEW-VERPR.
    W_FINAL-STPRS = WA_MBEW-STPRS.
    W_FINAL-BESKZ = WA_MARC-BESKZ.

    LOOP AT LT_FINAL INTO LS_FINAL WHERE MATNR = ALV_STB1-DOBJT+0(40).

      W_FINAL-MATNR   = LS_FINAL-MATNR.
*w_final-WERKS   = ls_final-WERKS.
      W_FINAL-PLNTY   = LS_FINAL-PLNTY.
      W_FINAL-PLNNR   = LS_FINAL-PLNNR.
      W_FINAL-PLNAL   = LS_FINAL-PLNAL.
      W_FINAL-ZAEHL   = LS_FINAL-ZAEHL.
      W_FINAL-VERWE   = LS_FINAL-VERWE.
      W_FINAL-STATU   = LS_FINAL-STATU.
      W_FINAL-VORNR   = LS_FINAL-VORNR.
      W_FINAL-STEUS   = LS_FINAL-STEUS.
      W_FINAL-ARBID   = LS_FINAL-ARBID.
      W_FINAL-OBJTY   = LS_FINAL-OBJTY.
      W_FINAL-LTXA1   = LS_FINAL-LTXA1.
      W_FINAL-LAR01   = LS_FINAL-LAR01.
      W_FINAL-VGE01   = LS_FINAL-VGE01.
      W_FINAL-VGW01   = LS_FINAL-VGW01.
      W_FINAL-OBJID   = LS_FINAL-OBJID.
      W_FINAL-ARBPL   = LS_FINAL-ARBPL.
      W_FINAL-KOSTL   = LS_FINAL-KOSTL.
      W_FINAL-VALID   = LS_FINAL-DATUV.
      W_FINAL-ACT_TYPE   = LS_FINAL-ACT_TYPE.
      W_FINAL-ACT_COST   = LS_FINAL-ACT_COST.

      APPEND W_FINAL TO I_FINAL.

    ENDLOOP.
    IF W_FINAL-MATNR IS INITIAL.
      APPEND W_FINAL TO I_FINAL.
    ENDIF.

    CLEAR: W_FINAL,WA_MBEW,WA_MARC.
  ENDLOOP.

*  DELETE I_FINAL WHERE VGE01 IS INITIAL AND VGW01 IS INITIAL. " commented by mahadev shrini on 11/02/2026
  DELETE I_FINAL WHERE VGE01 IS INITIAL AND VGW01 IS INITIAL .
  DELETE I_FINAL where BESKZ = 'F'. " Added by mahadev shrini on 11/02/2026
  DELETE I_FINAL where SOBSL IS NOT INITIAL. " Added by mahadev shrini on 11/02/2026
*BREAK primus.
  IF P_DOWN = 'X'.
    LOOP AT I_FINAL INTO W_FINAL.
      GS_DOWN-DGLVL  = W_FINAL-DGLVL .
      GS_DOWN-POSNR  = W_FINAL-POSNR .
      GS_DOWN-OBJIC  = W_FINAL-OBJIC .
      GS_DOWN-DOBJT  = W_FINAL-DOBJT .
      GS_DOWN-HEADER = W_FINAL-HEADER.
      GS_DOWN-OJTXP  = W_FINAL-OJTXP .
      GS_DOWN-OVFLS  = W_FINAL-OVFLS .
      GS_DOWN-MNGKO  = W_FINAL-MNGKO .
      GS_DOWN-MEINS  = W_FINAL-MEINS .
      GS_DOWN-POSTP  = W_FINAL-POSTP .
      GS_DOWN-AUSNM  = W_FINAL-AUSNM .
      GS_DOWN-WERKS  = W_FINAL-WERKS .
      GS_DOWN-MTART  = W_FINAL-MTART .
      GS_DOWN-VPRSV  = W_FINAL-VPRSV .
      GS_DOWN-STPRS  = W_FINAL-STPRS .
      GS_DOWN-VERPR  = W_FINAL-VERPR .
      GS_DOWN-SBDKZ  = W_FINAL-SBDKZ .
      GS_DOWN-DISMM  = W_FINAL-DISMM .
      GS_DOWN-SOBSL  = W_FINAL-SOBSL .
      GS_DOWN-SOBSK  = W_FINAL-SOBSK .
      GS_DOWN-FBSKZ  = W_FINAL-FBSKZ .
      GS_DOWN-PRCTR  = W_FINAL-PRCTR .

      GS_DOWN-IDNRK      = W_FINAL-IDNRK     .
      GS_DOWN-MENGE      = W_FINAL-MENGE     .
*   gs_down-DATUV      = w_final-DATUV     .

      IF W_FINAL-DATUV IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = W_FINAL-DATUV
          IMPORTING
            OUTPUT = GS_DOWN-DATUV.

        CONCATENATE GS_DOWN-DATUV+0(2) GS_DOWN-DATUV+2(3) GS_DOWN-DATUV+5(4)
                        INTO GS_DOWN-DATUV SEPARATED BY '-'.
      ENDIF.


*   gs_down-ANDAT      = w_final-ANDAT     .
      IF W_FINAL-ANDAT IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = W_FINAL-ANDAT
          IMPORTING
            OUTPUT = GS_DOWN-ANDAT.

        CONCATENATE GS_DOWN-ANDAT+0(2) GS_DOWN-ANDAT+2(3) GS_DOWN-ANDAT+5(4)
                        INTO GS_DOWN-ANDAT SEPARATED BY '-'.
      ENDIF.

*   gs_down-DATUB      = w_final-DATUB     .
      IF W_FINAL-DATUB IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = W_FINAL-DATUB
          IMPORTING
            OUTPUT = GS_DOWN-DATUB.

        CONCATENATE GS_DOWN-DATUB+0(2) GS_DOWN-DATUB+2(3) GS_DOWN-DATUB+5(4)
                        INTO GS_DOWN-DATUB SEPARATED BY '-'.
      ENDIF.

      GS_DOWN-BOMFL      = W_FINAL-BOMFL     .
      GS_DOWN-SGT_RCAT   = W_FINAL-SGT_RCAT  .
      GS_DOWN-SGT_SCAT   = W_FINAL-SGT_SCAT  .
      GS_DOWN-ZZTEXT_EN  = W_FINAL-ZZTEXT_EN .
*   gs_down-ZZTEXT_SP  = w_final-ZZTEXT_SP .
      GS_DOWN-MATNR      = W_FINAL-MATNR     .
      GS_DOWN-PLNTY      = W_FINAL-PLNTY     .
      GS_DOWN-PLNNR      = W_FINAL-PLNNR     .
      GS_DOWN-PLNAL      = W_FINAL-PLNAL     .
      GS_DOWN-ZAEHL      = W_FINAL-ZAEHL     .
      GS_DOWN-VERWE      = W_FINAL-VERWE     .
      GS_DOWN-STATU      = W_FINAL-STATU     .
      GS_DOWN-VORNR      = W_FINAL-VORNR     .
      GS_DOWN-STEUS      = W_FINAL-STEUS     .
      GS_DOWN-OBJTY      = W_FINAL-OBJTY     .
      GS_DOWN-LTXA1      = W_FINAL-LTXA1     .
      GS_DOWN-LAR01      = W_FINAL-LAR01     .
      GS_DOWN-VGE01      = W_FINAL-VGE01     .

      GS_DOWN-VGW01      = W_FINAL-VGW01     .
      GS_DOWN-OBJID      = W_FINAL-OBJID     .
      GS_DOWN-ARBPL      = W_FINAL-ARBPL     .
      GS_DOWN-KOSTL      = W_FINAL-KOSTL     .
*   gs_down-VALID      = w_final-VALID     .
      GS_DOWN-BESKZ      = W_FINAL-BESKZ     .
      GS_DOWN-ACT_TYPE      = W_FINAL-ACT_TYPE     .
      GS_DOWN-ACT_COST      = W_FINAL-ACT_COST     .

      IF W_FINAL-VALID IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = W_FINAL-VALID
          IMPORTING
            OUTPUT = GS_DOWN-VALID.

        CONCATENATE GS_DOWN-VALID+0(2) GS_DOWN-VALID+2(3) GS_DOWN-VALID+5(4)
                        INTO GS_DOWN-VALID SEPARATED BY '-'.
      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = GS_DOWN-REF.

      CONCATENATE GS_DOWN-REF+0(2) GS_DOWN-REF+2(3) GS_DOWN-REF+5(4)
                      INTO GS_DOWN-REF SEPARATED BY '-'.
      APPEND GS_DOWN TO GT_DOWN.
      CLEAR GS_DOWN.
    ENDLOOP.


  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
  PERFORM FCAT USING :     '1'   'DGLVL'           'IT_FINAL'      'Explosion level '                            '10' ,
                           '2'   'POSNR'           'IT_FINAL'      'BOM Item Number'                             '10' ,
                           '3'   'OBJIC'           'IT_FINAL'      'Object Type'                                 '10',
                           '4'   'DOBJT'           'IT_FINAL'      'Object ID'                                   '20',
                           '5'   'HEADER'          'IT_FINAL'      'Header Material'                             '20',
                           '6'   'OJTXP'           'IT_FINAL'      'Object description '                         '20',
                           '7'   'OVFLS'           'IT_FINAL'      'Indicator: value exceeds maximum length'     '20',
                           '8'   'MNGKO'           'IT_FINAL'      'Comp.Qty(CUn)'                               '20',
                           '9'   'MEINS'           'IT_FINAL'      'Base Unit of Measure'                        '20',
                          '10'   'POSTP'           'IT_FINAL'      'Item category'                               '10',
                          '11'   'AUSNM'           'IT_FINAL'      'Exception'                                   '20',

                          '12'   'WERKS'           'IT_FINAL'      'Plant'                                       '10',
                          '13'   'MTART'           'IT_FINAL'      'Material Type'                               '10',
                          '14'   'VPRSV'           'IT_FINAL'      'Price control indicator'                     '10',
                          '15'   'STPRS'           'IT_FINAL'      'Standard price'                              '10',
                          '16'   'VERPR'           'IT_FINAL'      'Moving Price'                                '10',
                          '17'   'SBDKZ'           'IT_FINAL'      'Individual /Collective Indicator'            '10',
                          '18'   'DISMM'           'IT_FINAL'      'MRP Type'                                    '10',
                          '19'   'SOBSL'           'IT_FINAL'      'Special procurement type'                    '10',
                          '20'   'SOBSK'           'IT_FINAL'      'Special Procurement Type for Costing'        '10',
                          '21'   'FBSKZ'           'IT_FINAL'      'Indicator: procured externally'              '10',
                          '22'   'PRCTR'           'IT_FINAL'      'Profit Center'                               '10',
                          '23'   'IDNRK'           'IT_FINAL'      'Component'                                   '20',
                          '24'   'MENGE'           'IT_FINAL'      'Component quantity'                          '10',
                          '25'   'DATUV'           'IT_FINAL'      'Valid-from'                                  '10',
                          '26'   'ANDAT'           'IT_FINAL'      'Created on'                                  '10',
                          '27'   'DATUB'           'IT_FINAL'      'Valid-to date'                               '10',
                          '28'   'BOMFL'           'IT_FINAL'      'Assembly indicator'                          '10',

                          '29'   'SGT_RCAT'        'IT_FINAL'      'Requirement Segment'                         '10',
                          '30'   'SGT_SCAT'        'IT_FINAL'      'Stock Segment'                               '10',
                          '31'   'ZZTEXT_EN'       'IT_FINAL'      'Material Long Text EN'                       '20',
                          '32'   'ZZTEXT_SP'       'IT_FINAL'      'Material Long Text SP'                       '20',
                          '33'   'MATNR'           'IT_FINAL'      'Material Number'                             '20',

                          '34'   'PLNTY'           'IT_FINAL'      'Task List Type'                              '10',
                          '35'   'PLNNR'           'IT_FINAL'      'Group'                                       '10',
                          '36'   'PLNAL'           'IT_FINAL'      'Group Counter'                               '10',
                          '37'   'ZAEHL'           'IT_FINAL'      'Counter'                                     '10',
                          '38'   'VERWE'           'IT_FINAL'      'Task list usage'                             '10',
                          '39'   'STATU'           'IT_FINAL'      'Status'                                      '10',
                          '40'   'VORNR'           'IT_FINAL'      'Activity Number'                             '10',
                          '41'   'STEUS'           'IT_FINAL'      'Control key'                                 '10',
                          '42'   'OBJTY'           'IT_FINAL'      'Object Type'                                 '10',
                          '43'   'LTXA1'           'IT_FINAL'      'Operation short text'                        '20',
                          '44'   'LAR01'           'IT_FINAL'      'Description of standard value 1'             '20',
                          '45'   'VGE01'           'IT_FINAL'      'Unit of Measurement of Standard Value'       '10',
                          '46'   'VGW01'           'IT_FINAL'      'Std.Value'                                   '10',
                          '47'   'OBJID'           'IT_FINAL'      'Object ID'                                   '10',
                          '48'   'ARBPL'           'IT_FINAL'      'Work center'                                 '10',
                          '49'   'KOSTL'           'IT_FINAL'      'Cost center'                                 '10',
                          '50'   'VALID'           'IT_FINAL'      'Valid From'                                  '10',
                          '51'   'BESKZ'           'IT_FINAL'      'Procurement Type'                            '10',
                          '52'   'ACT_TYPE'           'IT_FINAL'      'Activity Rate'                          '10' , " added by Dhanashree
                          '53'   'ACT_COST'           'IT_FINAL'      'Activity Cost'                          '10'.  " added by Dhanashree
*                        '50'   'VPRSV'           'IT_FINAL'      'Price indicator'                  '10',
*
*                        '52'   'STPRS'           'IT_FINAL'      'Standard price'                   '10',


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = I_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  IF P_DOWN = 'X'.

    PERFORM DOWN.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_2194   text
*      -->P_2195   text
*      -->P_2196   text
*      -->P_2197   text
*      -->P_2198   text
*----------------------------------------------------------------------*
FORM FCAT  USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWN .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

*  DATA: lv_folder(150).
  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZBOM_ROUTING1.TXT'.


*  CONCATENATE P_FOLDER '\' SY-DATUM SY-UZEIT LV_FILE
  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZBOM_ROUTING REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.

    DATA LV_STRING_3793 TYPE STRING.
    DATA LV_CRLF_3793 TYPE STRING.
    LV_CRLF_3793 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_3793 = HD_CSV.


    "TRANSFER HD_CSV TO LV_FULLFILE.          "Commented by prathmesh to avoid duplicate headers 17.02.2026
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_3793 LV_CRLF_3793 WA_CSV INTO LV_STRING_3793.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_3793 TO LV_FULLFILE.


    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

********************************Second File**********************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  "PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  LV_FILE = 'ZBOM_ROUTING1.TXT'.


*  CONCATENATE P_FOLDER '\' LV_FILE
  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZBOM_ROUTING REPORT started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.

    DATA LV_STRING_3794 TYPE STRING.
    DATA LV_CRLF_3794 TYPE STRING.
    LV_CRLF_3794 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_3794 = HD_CSV.


    "TRANSFER HD_CSV TO LV_FULLFILE.           "Commented by prathmesh to avoid duplicate headers 17.02.2026
*    LOOP AT IT_CSV INTO WA_CSV.
*      IF SY-SUBRC = 0.
*        TRANSFER WA_CSV TO LV_FULLFILE.
*
*      ENDIF.
*    ENDLOOP.

    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_3794 LV_CRLF_3794 WA_CSV INTO LV_STRING_3794.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_3794 TO LV_FULLFILE.

    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    PD_CSV.
  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE 'Explosion level '
              'BOM Item Number'
              'Object Type'
              'Object ID'
              'Header Material'
              'Object description '
              'Indicator: value exceeds maximum length'
              'Comp.Qty(CUn)'
              'Base Unit of Measure'
              'Item category'
              'Exception'
              'Plant'
              'Material Type'
              'Price control indicator'
              'Standard price'
              'Moving Price'
              'Individual /Collective Indicator'
              'MRP Type'
              'Special procurement type'
              'Special Procurement Type for Costing'
              'Indicator: procured externally'
              'Profit Center'
              'Component'
              'Component quantity'
              'Valid-from'
              'Created on'
              'Valid-to date'
              'Assembly indicator'
              'Requirement Segment'
              'Stock Segment'
              'Material Long Text EN'
*              'Material Long Text SP'
              'Material Number'
              'Task List Type'
              'Group'
              'Group Counter'
              'Counter'
              'Task list usage'
              'Status'
              'Activity Number'
              'Control key'
              'Object Type'
              'Operation short text'
              'Description of standard value 1'
              'Unit of Measurement of Standard Value'
              'Std.Value'
              'Object ID'
              'Work center'
              'Cost center'
              'Valid From'
              'Procurement Type'
              'Refresh Date'
              'Activity Rate'
              'Activity Cost'
               INTO PD_CSV
               SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
