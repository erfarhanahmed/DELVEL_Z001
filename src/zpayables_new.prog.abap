*&---------------------------------------------------------------------*
*& Report ZPAYABLES_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPAYABLES_NEW.

**************TABLE DECLARATION
 DATA:
   TMP_LIFNR TYPE BSIK-LIFNR,
   TMP_EKORG TYPE LFM1-EKORG.
* TABLES: bsik,lfa1, bsak, lfb1,lfm1.
 TYPE-POOLS : SLIS.

**************DATA DECLARATION

 DATA : DATE1 TYPE SY-DATUM, DATE2 TYPE SY-DATUM, DATE3 TYPE I.

 DATA   FS_LAYOUT TYPE SLIS_LAYOUT_ALV.
 DATA : FM_NAME TYPE RS38L_FNAM.
 DATA : T_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE.

*Internal Table for sorting
 DATA T_SORT TYPE SLIS_T_SORTINFO_ALV WITH HEADER LINE.

 TYPES:
   BEGIN OF T_TVZBT,
     ZTERM TYPE TVZBT-ZTERM,
     VTEXT TYPE TVZBT-VTEXT,
   END OF T_TVZBT,
   TT_TVZBT TYPE STANDARD TABLE OF T_TVZBT.

 TYPES:
   BEGIN OF T_SKAT,
     SAKNR TYPE SKAT-SAKNR,
     TXT50 TYPE SKAT-TXT50,
   END OF T_SKAT,
   TT_SKAT TYPE STANDARD TABLE OF T_SKAT.

 TYPES: BEGIN OF IDATA ,
          NAME1       LIKE LFA1-NAME1,          "Vendor Name
          KTOKK       LIKE LFA1-KTOKK,          " Vendor account group
          LIFNR       LIKE BSIK-LIFNR,          "Vendor Code
          XBLNR       LIKE BKPF-XBLNR,          "Vendor Invoice No.    bkpf-xblnr                               "***************ADDED BY SP 12.05.2023
          LANDL       LIKE BSIK-LANDL,
          SHKZG       LIKE BSIK-SHKZG,          "debit/credit s/h
          BUKRS       LIKE BSIK-BUKRS,          "Company Code
          AUGBL       LIKE BSIK-AUGBL,          "Clearing Doc No
          AUGGJ       LIKE BSIK-AUGGJ,
          AUGDT       LIKE BSIK-AUGDT,          "Clearing Date
          GJAHR       LIKE BKPF-GJAHR,          "Fiscal year
          BELNR       LIKE BSIK-BELNR,          "Document no.
          UMSKZ       LIKE BSIK-UMSKZ,          "Special G/L indicator
          BUZEI       LIKE BSIK-BUZEI,          "Line item no.
          BUDAT       LIKE BSIK-BUDAT,          "Posting date in the document
          BLDAT       LIKE BSIK-BLDAT,          "Document date in document
          WAERS       LIKE BSIK-WAERS,          "Currency
          BLART       LIKE BSIK-BLART,          "Doc. Type
          DMBTR       LIKE BSIK-DMBTR,          "Amount in local curr.
          WRBTR       TYPE BSIK-WRBTR,
          REBZG       LIKE BSIK-REBZG,          "refr inv no
          REBZJ       LIKE BSIK-REBZJ,          "Fiscal year
          REBZZ       LIKE BSIK-REBZZ,          "Line Item no
          DUEDATE     LIKE BSIK-AUGDT,        "Due Date
          ZFBDT       LIKE BSIK-ZFBDT,
          ZTERM       LIKE BSIK-ZTERM,         "Payment Term
          ZBD1T       LIKE BSIK-ZBD1T,         "Cash Discount Days 1
          ZBD2T       LIKE BSIK-ZBD2T,         "Cash Discount Days 2
          ZBD3T       LIKE BSIK-ZBD3T,         "Cash Discount Days 3
          DAY         TYPE I,
          DEBIT       LIKE BSIK-DMBTR,         "Amount in local curr.
          CREDIT      LIKE BSIK-DMBTR,         "Amount in local curr.
          NOT_DUE_DB  LIKE BSIK-DMBTR,
          NOT_DUE_CR  LIKE BSIK-DMBTR,
          NOT_DUE     LIKE BSIK-DMBTR,
          NETBAL      LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT30     LIKE BSIK-DMBTR,        "Amount in local curr.
          CREDIT30    LIKE BSIK-DMBTR,       "Amount in local curr.
          NETB30      LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT60     LIKE BSIK-DMBTR,        "Amount in local curr.
          CREDIT60    LIKE BSIK-DMBTR,       "Amount in local curr.
          NETB60      LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT90     LIKE BSIK-DMBTR,        "Amount in local curr.
          CREDIT90    LIKE BSIK-DMBTR,       "Amount in local curr.
          NETB90      LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT120    LIKE BSIK-DMBTR,       "Amount in local curr.
          CREDIT120   LIKE BSIK-DMBTR,      "Amount in local curr.
          NETB120     LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT180    LIKE BSIK-DMBTR,       "Amount in local curr.
          CREDIT180   LIKE BSIK-DMBTR,      "Amount in local curr.
          NETB180     LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT360    LIKE BSIK-DMBTR,       "Amount in local curr.
          CREDIT360   LIKE BSIK-DMBTR,      "Amount in local curr.
          NETB360     LIKE BSIK-DMBTR,         "Amount in local curr.

**********************NOT DUE***********************************
          DEBIT_N60   LIKE BSIK-DMBTR,        "Amount in local curr.
          CREDIT_N60  LIKE BSIK-DMBTR,       "Amount in local curr.
          NETB_N60    LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT_N90   LIKE BSIK-DMBTR,        "Amount in local curr.
          CREDIT_N90  LIKE BSIK-DMBTR,       "Amount in local curr.
          NETB_N90    LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT_N120  LIKE BSIK-DMBTR,       "Amount in local curr.
          CREDIT_N120 LIKE BSIK-DMBTR,      "Amount in local curr.
          NETB_N120   LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT_N180  LIKE BSIK-DMBTR,       "Amount in local curr.
          CREDIT_N180 LIKE BSIK-DMBTR,      "Amount in local curr.
          NETB_N180   LIKE BSIK-DMBTR,         "Amount in local curr.
          DEBIT_N360  LIKE BSIK-DMBTR,       "Amount in local curr.
          CREDIT_N360 LIKE BSIK-DMBTR,      "Amount in local curr.
          NETB_N360   LIKE BSIK-DMBTR,         "Amount in local curr.
******************************************************************
          CURR        TYPE BSIK-DMBTR,
          TDISP       TYPE CHAR50,
          GROUP       TYPE STRING,
          AKONT       LIKE KNB1-AKONT,          "Reconciliation account in gener
          VTEXT       TYPE CHAR200,
          REC_TXT     TYPE CHAR70,     "Reconcilation Account text
          PDC         TYPE BSIK-DMBTR,
          GRN_DT      TYPE MKPF-BUDAT,
          INVOICE     TYPE BKPF-BELNR,
          STATUS      TYPE STRING,
        END OF IDATA.


 TYPES:
   BEGIN OF T_BKPF,
     BUKRS TYPE BKPF-BUKRS,
     BELNR TYPE BKPF-BELNR,
     GJAHR TYPE BKPF-GJAHR,
     XBLNR TYPE BKPF-XBLNR,                                                    "***************ADDED BY SP 09.05.2023
     AWKEY TYPE BKPF-AWKEY,
     YEAR  TYPE BKPF-GJAHR,                                   "rseg-gjahr,
     AWTYP TYPE BKPF-AWTYP,
   END OF T_BKPF,
   TT_BKPF TYPE STANDARD TABLE OF T_BKPF.

 TYPES:
   BEGIN OF T_RSEG,
     BELNR TYPE RSEG-BELNR,
     GJAHR TYPE RSEG-GJAHR,
     BUZEI TYPE RSEG-BUZEI,
     EBELN TYPE RSEG-EBELN,
     EBELP TYPE RSEG-EBELP,
     PSTYP TYPE RSEG-PSTYP,
     LFBNR TYPE RSEG-LFBNR,
     LFGJA TYPE RSEG-LFGJA,
   END OF T_RSEG,
   TT_RSEG TYPE STANDARD TABLE OF T_RSEG.

 TYPES:
   BEGIN OF T_EKBE,
     EBELN TYPE EKBE-EBELN,
     EBELP TYPE EKBE-EBELP,
     ZEKKN TYPE EKBE-ZEKKN,
     GJAHR TYPE EKBE-GJAHR,
     BELNR TYPE EKBE-BELNR,
     BUDAT TYPE EKBE-BUDAT,
     LFBNR TYPE EKBE-LFBNR,
     LFGJA TYPE EKBE-LFGJA,
   END OF T_EKBE,
   TT_EKBE TYPE STANDARD TABLE OF T_EKBE.

 TYPES:
   BEGIN OF T_MKPF,
     MBLNR TYPE MKPF-MBLNR,
     MJAHR TYPE MKPF-MJAHR,
     BUDAT TYPE MKPF-BLDAT,
     LFBNR TYPE MSEG-LFBNR,
     LFBJA TYPE MSEG-LFBJA,
   END OF T_MKPF,
   TT_MKPF TYPE STANDARD TABLE OF T_MKPF.


 DATA : BEGIN OF T_LIFNR OCCURS 0,
          LIFNR TYPE LFM1-LIFNR,
        END OF T_LIFNR.
 DATA: RP01(3) TYPE N,                                    "   0
       RP02(3) TYPE N,                                    "  20
       RP03(3) TYPE N,                                    "  40
       RP04(3) TYPE N,                                    "  80
       RP05(3) TYPE N,                                    " 100
       RP06(3) TYPE N,                                    "   1
       RP07(3) TYPE N,                                    "  21
       RP08(3) TYPE N,                                    "  41
       RP09(3) TYPE N,                                    "  81
       RP10(3) TYPE N.                                    " 101

 DATA: RC01(14) TYPE C,                                     "  0
       RC02(14) TYPE C,                                   "  20
       RC03(14) TYPE C,                                   "  40
       RC04(14) TYPE C,                                   "  80
       RC05(14) TYPE C,                                   " 100
       RC06(14) TYPE C,                                   "   1
       RC07(14) TYPE C,                                   "  21
       RC08(14) TYPE C,                                   "  41
       RC09(14) TYPE C,                                   "  81
       RC10(14) TYPE C,                                   " 101
       RC11(14) TYPE C,                                   " 101
       RC12(14) TYPE C,                                   " 101
       RC13(14) TYPE C,                                   " 101
       RC14(14) TYPE C,                                   " 101
       RC15(14) TYPE C,                                   " 101
       RC16(14) TYPE C,                                   " 101
       RC17(14) TYPE C,                                   " 101
       RC18(14) TYPE C,                                   " 101
       RC19(14) TYPE C,                                   " 101
       RC20(14) TYPE C,                                   " 101
       RC21(14) TYPE C,                                   " 101
       RC22(14) TYPE C,                                   " 101
       RC23(14) TYPE C,                                   " 101
       RC24(14) TYPE C.                                   " 101

 DATA: ITAB  TYPE IDATA OCCURS 0 WITH HEADER LINE.

 TYPES:
   BEGIN OF T_FILE,
     TDISP     TYPE CHAR50,
     REC_TXT   TYPE CHAR70,
     GROUP     TYPE CHAR10,
     XBLNR     TYPE BKPF-XBLNR,           "BSIK-XBLNR                                              "***************ADDED BY SP 12.05.2023
     BELNR     TYPE BSIK-BELNR,
     BLART     TYPE BSIK-BLART,
     BUDAT     TYPE CHAR11,
     BLDAT     TYPE CHAR11,
     DUEDATE   TYPE CHAR11,
     GRN_DT    TYPE CHAR11,
     VTEXT     TYPE CHAR120,
     CURR      TYPE CHAR15,
     WAERS     TYPE BSIK-WAERS,
     CREDIT    TYPE CHAR15,
     DEBIT     TYPE CHAR15,
     NETBAL    TYPE CHAR15,
     NETB30    TYPE CHAR15,
     NETB60    TYPE CHAR15,
     NETB90    TYPE CHAR15,
     NETB120   TYPE CHAR15,
     NETB180   TYPE CHAR15,
     NETB360   TYPE CHAR15,
     NOT_DUE   TYPE CHAR15,
     NETB_N60  TYPE CHAR15,
     NETB_N90  TYPE CHAR15,
     NETB_N120 TYPE CHAR15,
     NETB_N180 TYPE CHAR15,
     NETB_N360 TYPE CHAR15,
     DAY       TYPE CHAR10,
     PDC       TYPE CHAR15,
     CURR_DT   TYPE CHAR11,
     INVOICE   TYPE CHAR10,
     STATUS    TYPE STRING,
     ref_time     TYPE char15,

   END OF T_FILE,
   TT_FILE TYPE STANDARD TABLE OF T_FILE.

******************SELECTION SCREEN

 SELECTION-SCREEN BEGIN OF BLOCK A1 WITH FRAME TITLE TEXT-001.
 PARAMETERS: PLANT LIKE BSIK-BUKRS  OBLIGATORY DEFAULT '1000'.
 SELECT-OPTIONS: LIFNR FOR TMP_LIFNR.
*                 ekorg FOR tmp_ekorg.
*                 akont FOR lfb1-akont.
 PARAMETERS: DATE  LIKE BKPF-BUDAT DEFAULT SY-DATUM OBLIGATORY.                "no-extension obligatory.
 SELECTION-SCREEN BEGIN OF LINE.

 SELECTION-SCREEN COMMENT 01(30) TEXT-026 FOR FIELD RASTBIS1.

 SELECTION-SCREEN POSITION POS_LOW.

 PARAMETERS: RASTBIS1 LIKE RFPDO1-ALLGROGR DEFAULT '000'.
 PARAMETERS: RASTBIS2 LIKE RFPDO1-ALLGROGR DEFAULT '030'.
 PARAMETERS: RASTBIS3 LIKE RFPDO1-ALLGROGR DEFAULT '060'.
 PARAMETERS: RASTBIS4 LIKE RFPDO1-ALLGROGR DEFAULT '090'.
 PARAMETERS: RASTBIS5 LIKE RFPDO1-ALLGROGR DEFAULT '120'.

 SELECTION-SCREEN END OF LINE.

 SELECTION-SCREEN END OF BLOCK A1.

 SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME.
 PARAMETERS: R1 RADIOBUTTON GROUP ABC DEFAULT 'X',
             R2 RADIOBUTTON GROUP ABC.
 SELECTION-SCREEN: END OF BLOCK B1.

 SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-002.
 PARAMETERS P_DOWN AS CHECKBOX.
 PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'. "'E:\delval\temp'.
 SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE TEXT-005.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-075.
  SELECTION-SCREEN  COMMENT /1(70) TEXT-076.
  SELECTION-SCREEN END OF BLOCK b6.

***********************Initialization.

 INITIALIZATION.

**************************************************
 AT SELECTION-SCREEN.

   IF RASTBIS1 GT '998'
   OR RASTBIS2 GT '998'
   OR RASTBIS3 GT '998'
   OR RASTBIS4 GT '998'
   OR RASTBIS5 GT '998'.

     SET CURSOR FIELD RASTBIS5.
     MESSAGE 'Enter a consistent sorted list' TYPE 'E'.     "e381.
   ENDIF.

   IF NOT RASTBIS5 IS INITIAL.
     IF  RASTBIS5 GT RASTBIS4
     AND RASTBIS4 GT RASTBIS3
     AND RASTBIS3 GT RASTBIS2
     AND RASTBIS2 GT RASTBIS1.
     ELSE.
       MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
     ENDIF.
   ELSE.
     IF NOT RASTBIS4 IS INITIAL.
       IF  RASTBIS4 GT RASTBIS3
       AND RASTBIS3 GT RASTBIS2
       AND RASTBIS2 GT RASTBIS1.
       ELSE.
         MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
       ENDIF.
     ELSE.
       IF NOT RASTBIS3 IS INITIAL.
         IF  RASTBIS3 GT RASTBIS2
         AND RASTBIS2 GT RASTBIS1.
         ELSE.
           MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
         ENDIF.
       ELSE.
         IF NOT RASTBIS2 IS INITIAL.
           IF  RASTBIS2 GT RASTBIS1.
           ELSE.
             MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
           ENDIF.
         ELSE.
*         nichts zu tun
         ENDIF.
       ENDIF.
     ENDIF.
   ENDIF.

   RP01 = RASTBIS1.
   RP02 = RASTBIS2.
   RP03 = RASTBIS3.
   RP04 = RASTBIS4.
   RP05 = RASTBIS5.

   RP06 = RP01 + 1.
   IF NOT RP02 IS INITIAL.
     RP07 = RP02 + 1.
   ELSE.
     RP07 = ''.
   ENDIF.
   IF NOT RP03 IS INITIAL.
     RP08 = RP03 + 1.
   ELSE.
     RP08 = ''.
   ENDIF.
   IF NOT RP04 IS INITIAL.
     RP09 = RP04 + 1.
   ELSE.
     RP09 = ''.
   ENDIF.
   IF NOT RP05 IS INITIAL.
     RP10 = RP05 + 1.
   ELSE.
     RP10 = ''.
   ENDIF.

   IF NOT RP01 IS INITIAL.
     CONCATENATE 'Upto'    RP01 'Dr' INTO RC01 SEPARATED BY SPACE.
     CONCATENATE 'Upto'    RP01 'Cr' INTO RC06 SEPARATED BY SPACE.
     CONCATENATE '000 to'  RP01 'Net Bal' INTO RC13 SEPARATED BY SPACE.
     CONCATENATE '-000 to'  RP01 'Net Bal' INTO RC19 SEPARATED BY SPACE.

   ELSE.
     CONCATENATE 'Upto'    RP01 'Dr' INTO RC01 SEPARATED BY SPACE.
     CONCATENATE 'Upto'    RP01 'Cr' INTO RC06 SEPARATED BY SPACE.
     CONCATENATE RP01 'Days'  INTO RC13 SEPARATED BY SPACE.
     CONCATENATE '-'  RP01 'Days' INTO RC19 SEPARATED BY SPACE.
   ENDIF.

   IF NOT RP02 IS INITIAL.
     CONCATENATE RP06 'To' RP02 'Dr' INTO RC02 SEPARATED BY SPACE.
     CONCATENATE RP06 'To' RP02 'Cr' INTO RC07 SEPARATED BY SPACE.
     CONCATENATE RP06 'To' RP02 'Net Bal' INTO RC14 SEPARATED BY SPACE.
     CONCATENATE '-' RP06 'To -' RP02 'Net Bal' INTO RC20 SEPARATED BY SPACE.
   ELSEIF RP03 IS INITIAL.
     CONCATENATE RP06 '& Above' 'Dr' INTO RC02 SEPARATED BY SPACE.
     CONCATENATE RP06 '& Above' 'Cr' INTO RC07 SEPARATED BY SPACE.
     CONCATENATE RP06 '& Above' 'Net Bal' INTO RC14 SEPARATED BY SPACE.
     CONCATENATE '-' RP06 '& Above' 'Net Bal' INTO RC20 SEPARATED BY SPACE.
   ENDIF.

   IF NOT RP03 IS INITIAL.
     CONCATENATE RP07 'To' RP03 'Dr' INTO RC03 SEPARATED BY SPACE.
     CONCATENATE RP07 'To' RP03 'Cr' INTO RC08 SEPARATED BY SPACE.
     CONCATENATE RP07 'To' RP03 'Net Bal' INTO RC15 SEPARATED BY SPACE.
     CONCATENATE '-' RP07 'To -' RP03 'Net Bal' INTO RC21 SEPARATED BY SPACE.
   ELSEIF RP02 IS INITIAL.
     RC03 = ''.
     RC08 = ''.
     RC15 = ''.
     RC21 = ''.
   ELSEIF RP04 IS INITIAL.
     CONCATENATE RP07 '& Above' 'Dr' INTO RC03 SEPARATED BY SPACE.
     CONCATENATE RP07 '& Above' 'Cr' INTO RC08 SEPARATED BY SPACE.
     CONCATENATE RP07 '& Above' 'Net Bal' INTO RC15 SEPARATED BY SPACE.
     CONCATENATE '-' RP07 '& Above' 'Net Bal' INTO RC21 SEPARATED BY SPACE.
   ENDIF.

   IF NOT RP04 IS INITIAL .
     CONCATENATE RP08 'To' RP04 'Dr' INTO RC04 SEPARATED BY SPACE.
     CONCATENATE RP08 'To' RP04 'Cr' INTO RC09 SEPARATED BY SPACE.
     CONCATENATE RP08 'To' RP04 'Net Bal' INTO RC16 SEPARATED BY SPACE.
     CONCATENATE '-' RP08 'To -' RP04 'Net Bal' INTO RC22 SEPARATED BY SPACE.
   ELSEIF RP03 IS INITIAL.
     RC04 = ''.
     RC09 = ''.
     RC16 = ''.
     RC22 = ''.
   ELSEIF RP05 IS INITIAL.
     CONCATENATE RP08 '& Above' 'Dr' INTO RC04 SEPARATED BY SPACE.
     CONCATENATE RP08 '& Above' 'Cr' INTO RC09 SEPARATED BY SPACE.
     CONCATENATE RP08 '& Above' 'Net Bal' INTO RC16 SEPARATED BY SPACE.
     CONCATENATE '-' RP08 '& Above' 'Net Bal' INTO RC22 SEPARATED BY SPACE.
   ENDIF.

   IF NOT RP05 IS INITIAL.
     CONCATENATE RP09 'To' RP05 'Dr' INTO RC05 SEPARATED BY SPACE.
     CONCATENATE RP09 'To' RP05 'Cr' INTO RC10 SEPARATED BY SPACE.
     CONCATENATE RP09 'To' RP05 'Net Bal' INTO RC17 SEPARATED BY SPACE.
     CONCATENATE '-' RP09 'To -' RP05 'Net Bal' INTO RC23 SEPARATED BY SPACE.
   ELSEIF RP04 IS INITIAL.
     RC05 = ''.
     RC10 = ''.
     RC17 = ''.
     RC23 = ''.
   ELSE.
     CONCATENATE RP09 '& Above' 'Dr' INTO RC05 SEPARATED BY SPACE.
     CONCATENATE RP09 '& Above' 'Cr' INTO RC10 SEPARATED BY SPACE.
     CONCATENATE RP09 '& Above' 'Net Bal' INTO RC17 SEPARATED BY SPACE.
     CONCATENATE '-' RP09 '& Above' 'Net Bal' INTO RC23 SEPARATED BY SPACE.
   ENDIF.

   IF NOT RP10 IS INITIAL.
     CONCATENATE RP10 '& Above' 'Dr' INTO RC11 SEPARATED BY SPACE.
     CONCATENATE RP10 '& Above' 'Cr' INTO RC12 SEPARATED BY SPACE.
     CONCATENATE RP10 '& Above' 'Net Bal' INTO RC18 SEPARATED BY SPACE.
     CONCATENATE '-' RP10 '& Above' 'Net Bal' INTO RC24 SEPARATED BY SPACE.

   ENDIF.


*******************************************
*******************************************

***   IF lifnr IS INITIAL AND ekorg IS NOT INITIAL .
***
***     SELECT lifnr FROM lfm1 INTO TABLE t_lifnr WHERE ekorg IN ekorg.
***
***     IF t_lifnr[] IS NOT INITIAL .
***
***       LOOP AT t_lifnr .
***         lifnr-sign = 'I'.
***         lifnr-option = 'EQ'.
***         lifnr-low = t_lifnr-lifnr.
***         APPEND lifnr.
***
***       ENDLOOP.
***     ENDIF.
***   ENDIF.
*******************************************
 START-OF-SELECTION.

   PERFORM DATALIST_BSIK.

   PERFORM FILL_FIELDCATALOG.
   PERFORM SORT_LIST.
   PERFORM FILL_LAYOUT.
   PERFORM LIST_DISPLAY.

 END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  datalist_bsik
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM DATALIST_BSIK .
   DATA:
     LV_KTOPL TYPE T001-KTOPL,
     LV_INDEX TYPE SY-INDEX,
     LV_DAY   TYPE I.

   DATA:
     LS_FAEDE_I TYPE FAEDE,
     LS_FAEDE_E TYPE FAEDE,
     LT_TVZBT   TYPE TT_TVZBT,
     LS_TVZBT   TYPE T_TVZBT,
     LT_SKAT    TYPE TT_SKAT,
     LS_SKAT    TYPE T_SKAT,
     LT_BKPF    TYPE TT_BKPF,
     LS_BKPF    TYPE T_BKPF,
     LT_RSEG    TYPE TT_RSEG,
     LT_RSEG_S  TYPE TT_RSEG,
     LT_RSEG_1  TYPE TT_RSEG,
     LS_RSEG    TYPE T_RSEG,
     LT_EKBE    TYPE TT_EKBE,
     LS_EKBE    TYPE T_EKBE,
     LT_MKPF    TYPE TT_MKPF,
     LS_MKPF    TYPE T_MKPF,
     LT_CLEAR   TYPE STANDARD TABLE OF IDATA,
     LT_DATA    TYPE STANDARD TABLE OF IDATA,
     LS_DATA    TYPE IDATA,
     LT_PARTIAL TYPE STANDARD TABLE OF IDATA.


   SELECT BSIK~BUKRS
          BSIK~LIFNR
          BSIK~AUGBL
          BSIK~AUGGJ
          BSIK~AUGDT

         BSIK~XBLNR                                                             """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""added by sp 12.05.2023

          GJAHR
          BELNR
          AUGBL
          BUZEI
          BUDAT
          BLDAT
          BSIK~WAERS
          BLART
          SHKZG
          DMBTR
          BSIK~WRBTR
          REBZG
          REBZJ
          REBZZ
          UMSKZ
          BSIK~ZTERM
          ZBD1T
          ZBD2T
          ZBD3T
          ZFBDT
          LANDL
*      lfa1~name1
*      lfa1~ktokk
     LFB1~AKONT
 INTO CORRESPONDING FIELDS OF TABLE ITAB
                             FROM BSIK INNER JOIN LFB1 ON LFB1~LIFNR = BSIK~LIFNR AND LFB1~BUKRS = BSIK~BUKRS
                              WHERE BSIK~BUKRS = PLANT
                              AND   BSIK~LIFNR IN LIFNR
                              AND   UMSKZ <> 'F'
                              AND   BUDAT <= DATE.
*                              AND   lfb1~akont IN akont .
*                               and   lfa1~ktokk in ktokk.

   IF NOT ITAB[] IS INITIAL.
     SELECT BSIK~BUKRS
          BSIK~LIFNR
          BSIK~AUGBL
          BSIK~AUGGJ
          BSIK~AUGDT

         BSIK~XBLNR""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""ADDED BY SPN 12.05.2023

          GJAHR
          BELNR
          AUGBL
          BUZEI
          BUDAT
          BLDAT
          BSIK~WAERS
          BLART
          SHKZG
          DMBTR
          BSIK~WRBTR
          REBZG
          REBZJ
          REBZZ
          UMSKZ
          BSIK~ZTERM
          ZBD1T
          ZBD2T
          ZBD3T
          ZFBDT
          BLART
          LANDL
*      lfa1~name1
*      lfa1~ktokk
          LFB1~AKONT
          INTO CORRESPONDING FIELDS OF TABLE LT_PARTIAL
          FROM BSIK INNER JOIN LFB1 ON LFB1~LIFNR = BSIK~LIFNR AND LFB1~BUKRS = BSIK~BUKRS
*          FOR ALL ENTRIES IN itab[]
          WHERE BSIK~BUKRS = PLANT
          AND   BSIK~LIFNR IN LIFNR
          AND   BLART IN ('KZ','KU')
          AND   UMSKZ <> 'F'
          AND   BUDAT <= DATE.    "> DATE.
*          AND   rebzg = itab-belnr
*          AND   rebzj = itab-gjahr
*          AND   rebzz = itab-buzei.
   ENDIF.

   SELECT BSAK~BUKRS
          BSAK~LIFNR
          AUGBL
          AUGGJ
          AUGDT
          GJAHR
          BELNR
          BUZEI
          BUDAT
          BLDAT
          BSAK~WAERS
          BLART
          SHKZG
          DMBTR
          BSAK~WRBTR
          REBZG
          REBZJ
          REBZZ
          UMSKZ
          BSAK~ZTERM
          ZBD1T
          ZBD2T
          ZBD3T
          ZFBDT
          LFB1~AKONT
          APPENDING CORRESPONDING FIELDS OF TABLE ITAB
          FROM BSAK INNER JOIN LFB1 ON LFB1~LIFNR = BSAK~LIFNR AND LFB1~BUKRS = BSAK~BUKRS
          WHERE BSAK~BUKRS = PLANT
          AND   BSAK~LIFNR IN LIFNR
          AND   UMSKZ <> 'F'
          AND   BUDAT <= DATE
*          AND  augdt = ' '
*          and  augbl <> ' ' AND augbl > date
          AND   AUGDT > DATE.

   IF NOT ITAB[] IS INITIAL.

     SELECT BSAK~BUKRS
            BSAK~LIFNR
            AUGBL
            AUGGJ
            AUGDT
            GJAHR
            BELNR
            BUZEI
            BUDAT
            BLDAT
            BSAK~WAERS
            BLART
            SHKZG
            DMBTR
            BSAK~WRBTR
            REBZG
            REBZJ
            REBZZ
            UMSKZ
            BSAK~ZTERM
            ZBD1T
            ZBD2T
            ZBD3T
            ZFBDT
           INTO CORRESPONDING FIELDS OF TABLE LT_CLEAR
           FROM BSAK INNER JOIN LFB1 ON LFB1~LIFNR = BSAK~LIFNR AND LFB1~BUKRS = BSAK~BUKRS
           FOR ALL ENTRIES IN ITAB
           WHERE BSAK~BUKRS = PLANT
           AND   BSAK~LIFNR IN LIFNR
           AND   BLART IN ('KZ','KU')
           AND   UMSKZ <> 'F'
           AND   BUDAT > DATE
           AND   BELNR = ITAB-AUGBL
           AND   AUGDT > DATE.
   ENDIF.


   LT_DATA = ITAB[].

   SORT ITAB BY BELNR GJAHR BUZEI.
   SORT LT_CLEAR BY AUGBL GJAHR.
   SORT LT_PARTIAL BY REBZG REBZJ REBZZ.
   SORT LT_DATA BY REBZG REBZJ REBZZ.


   DELETE ITAB WHERE REBZG NE SPACE.

   IF NOT ITAB[] IS INITIAL.
     SELECT ZTERM
            VTEXT
       FROM TVZBT
       INTO TABLE LT_TVZBT
       FOR ALL ENTRIES IN ITAB
       WHERE ZTERM = ITAB-ZTERM
       AND   SPRAS = SY-LANGU.

     SELECT SINGLE KTOPL
                FROM  T001
                INTO  LV_KTOPL
                WHERE BUKRS = PLANT.

     SELECT SAKNR
           TXT50
      FROM SKAT
      INTO TABLE LT_SKAT
      FOR ALL ENTRIES IN ITAB
      WHERE SAKNR = ITAB-AKONT
      AND   KTOPL = LV_KTOPL
      AND   SPRAS = SY-LANGU.

     IF NOT LT_PARTIAL IS INITIAL.
       SELECT SAKNR
          TXT50
     FROM SKAT
     APPENDING TABLE LT_SKAT
     FOR ALL ENTRIES IN LT_PARTIAL
     WHERE SAKNR = LT_PARTIAL-AKONT
     AND   KTOPL = LV_KTOPL
     AND   SPRAS = SY-LANGU.

     ENDIF.

     SELECT BUKRS
            BELNR
            GJAHR
            XBLNR                                                    "***************ADDED BY SP 09.05.2023
            AWKEY
       FROM BKPF
       INTO TABLE LT_BKPF
       FOR ALL ENTRIES IN ITAB
       WHERE BUKRS = PLANT
       AND BELNR = ITAB-BELNR
       AND   GJAHR = ITAB-GJAHR
       AND  AWTYP  =  'RMRP' .


     " ------------------------ ADDED BY ANISH ON 16.05.2023 ----------------------"
* ADDED LOGIC FOR VENDOR REFERENCE DOCUMENT NOT SHOWING

     DATA LR_AWTYP TYPE RANGE OF BKPF-AWTYP.
     CLEAR: LR_AWTYP, LR_AWTYP[].

     SELECT * FROM TVARVC INTO TABLE @DATA(LT_TVARV) WHERE NAME EQ 'ZFI_VEN_AGEING'.
     IF LT_TVARV IS NOT INITIAL.

       SORT LT_TVARV BY LOW ASCENDING.
       DELETE ADJACENT DUPLICATES FROM LT_TVARV COMPARING LOW.

       LR_AWTYP = VALUE #( FOR LS_AWTYP IN LT_TVARV ( SIGN   = 'I'
                                                      OPTION = 'EQ'
                                                      LOW = LS_AWTYP-LOW ) ).
     ENDIF.

     SELECT FROM BKPF
            FIELDS BUKRS,BELNR,GJAHR,XBLNR
     FOR ALL ENTRIES IN @ITAB
     WHERE BUKRS = @PLANT
     AND   BELNR = @ITAB-BELNR
     AND   GJAHR = @ITAB-GJAHR
     AND   AWTYP IN @LR_AWTYP
     INTO TABLE @DATA(LT_BKPF_NEW).

     "-----------------------------------------------------------------------------"





**                           ***********************************commented by sp 08.05.2023*****************************************

     IF SY-SUBRC IS INITIAL.
       LOOP AT LT_BKPF INTO LS_BKPF.
         LS_BKPF-YEAR = LS_BKPF-AWKEY+10(4).
         MODIFY LT_BKPF FROM LS_BKPF TRANSPORTING YEAR.
       ENDLOOP.

       SELECT BELNR
              GJAHR
              BUZEI
              EBELN
              EBELP
              PSTYP
              LFBNR
              LFGJA
         FROM RSEG
         INTO TABLE LT_RSEG
         FOR ALL ENTRIES IN LT_BKPF
         WHERE BELNR = LT_BKPF-AWKEY+0(10)
         AND   GJAHR = LT_BKPF-YEAR
         AND   BUKRS = PLANT
         AND   LFBNR NE ''.

       IF SY-SUBRC IS INITIAL.
         SORT LT_RSEG BY BELNR GJAHR. " lfbnr lfgja.
         DELETE ADJACENT DUPLICATES FROM LT_RSEG COMPARING BELNR GJAHR.
         LT_RSEG_S[] = LT_RSEG[].
         LT_RSEG_1[] = LT_RSEG[].
         DELETE LT_RSEG_S WHERE PSTYP NE '9'.
         DELETE LT_RSEG_1 WHERE PSTYP NE '3'.

         APPEND LINES OF LT_RSEG_1 TO LT_RSEG_S.

         SELECT MBLNR
                MJAHR
                BUDAT
                LFBNR_I
                LFBJA_I
           FROM WB2_V_MKPF_MSEG2
           INTO TABLE LT_MKPF
           FOR ALL ENTRIES IN LT_RSEG
           WHERE MBLNR = LT_RSEG-LFBNR
           AND   MJAHR = LT_RSEG-LFGJA
           AND   BUKRS_I = PLANT.

         IF NOT LT_RSEG_S IS INITIAL.
*****
*****           SELECT mblnr
*****                mjahr
*****                budat
*****                lfbnr_i
*****                lfbja_i
*****           FROM wb2_v_mkpf_mseg2
*****           APPENDING TABLE lt_mkpf
*****           FOR ALL ENTRIES IN lt_rseg_s
*****           WHERE lfbnr_i = lt_rseg_s-lfbnr
*****           AND   lfbja_i = lt_rseg_s-lfgja
*****           AND   bwart_i = '101'
*****           AND   bukrs_i = plant  .

           SELECT A~MBLNR
                  A~MJAHR
                  A~BUDAT
                  B~LFBNR
                  B~LFBJA
           FROM MSEG AS B INNER JOIN MKPF AS A  ON A~MBLNR = B~MBLNR AND A~MJAHR = B~MJAHR
           APPENDING TABLE LT_MKPF
           FOR ALL ENTRIES IN LT_RSEG_S
           WHERE BWART = '101'
           AND  LFBNR = LT_RSEG_S-LFBNR
           AND  LFBJA = LT_RSEG_S-LFGJA
           AND  BUKRS = PLANT  .





         ENDIF.
         SORT LT_MKPF BY MBLNR MJAHR.
         DELETE ADJACENT DUPLICATES FROM LT_MKPF COMPARING MBLNR MJAHR.

**         SELECT ebeln
**              ebelp
**              zekkn
**              gjahr
**              belnr
**              budat
**              lfbnr
**              lfgja
**         FROM ekbe
**         INTO TABLE lt_ekbe
**         FOR ALL ENTRIES IN lt_rseg
**         WHERE belnr = lt_rseg-lfbnr
**         AND   gjahr = lt_rseg-lfgja
**         AND   bewtp ='E'
**         AND   bwart = '101'.
**
**         SELECT ebeln
**             ebelp
**             zekkn
**             gjahr
**             belnr
**             budat
**             lfbnr
**             lfgja
**        FROM ekbe
**        APPENDING TABLE lt_ekbe
**        FOR ALL ENTRIES IN lt_rseg
**        WHERE lfbnr = lt_rseg-lfbnr
**        AND   lfgja = lt_rseg-lfgja
**        AND   bewtp ='E'
**        AND   bwart = '101'.
       ENDIF.
     ENDIF.
   ENDIF.
**   SORT lt_ekbe BY belnr gjahr.
**   DELETE ADJACENT DUPLICATES FROM lt_ekbe COMPARING belnr gjahr.
   LOOP AT ITAB.

     READ TABLE LT_DATA INTO LS_DATA WITH KEY REBZG = ITAB-BELNR
                                        REBZJ = ITAB-GJAHR
                                        REBZZ = ITAB-BUZEI.
     IF SY-SUBRC IS INITIAL.
       LV_INDEX = SY-TABIX.
       LOOP AT LT_DATA INTO LS_DATA FROM LV_INDEX.
         IF LS_DATA-REBZG = ITAB-BELNR AND LS_DATA-REBZJ = ITAB-GJAHR AND LS_DATA-REBZZ = ITAB-BUZEI.
           IF LS_DATA-SHKZG = 'H'.
             ITAB-DEBIT = ITAB-DEBIT - LS_DATA-DMBTR.
           ELSE.
             ITAB-DEBIT = ITAB-DEBIT + LS_DATA-DMBTR.
           ENDIF.

         ELSE.
           EXIT.
         ENDIF.
       ENDLOOP.
     ENDIF.
     MODIFY ITAB TRANSPORTING DEBIT.

   ENDLOOP.

   LOOP AT ITAB.

***********Calculating DEBIT and CREDIT
     IF ITAB-SHKZG  = 'S'.
       ITAB-DEBIT  = ITAB-DEBIT + ITAB-DMBTR.
     ELSE.
       ITAB-CREDIT = ITAB-DMBTR.
     ENDIF.

     IF ITAB-UMSKZ  = ''.
       ITAB-GROUP  = 'Normal'.
     ELSE.
       ITAB-GROUP  = 'Special G/L'.
     ENDIF.
*added by  ganesh primus to add payment days in doc date for due date
*     itab-duedate = itab-bldat + itab-zbd1t.       "+ itab-zbd1t.  "itab-zfbdt

     LS_FAEDE_I-KOART = 'K'.
     LS_FAEDE_I-ZFBDT = ITAB-ZFBDT.
     LS_FAEDE_I-ZBD1T = ITAB-ZBD1T.
     LS_FAEDE_I-ZBD2T = ITAB-ZBD2T.
     LS_FAEDE_I-ZBD3T = ITAB-ZBD3T.

     CALL FUNCTION 'DETERMINE_DUE_DATE'
       EXPORTING
         I_FAEDE                    = LS_FAEDE_I
*        I_GL_FAEDE                 =
       IMPORTING
         E_FAEDE                    = LS_FAEDE_E
       EXCEPTIONS
         ACCOUNT_TYPE_NOT_SUPPORTED = 1
         OTHERS                     = 2.
     IF SY-SUBRC <> 0.
* Implement suitable error handling here
     ENDIF.

     ITAB-DUEDATE = LS_FAEDE_E-NETDT.


     IF R1 = 'X'.
       IF ITAB-BLDAT >= DATE.
         ITAB-DAY  = 0.
       ELSE.
         ITAB-DAY     = DATE - ITAB-BLDAT.
       ENDIF.
       IF ITAB-DAY < 0.
         ITAB-NOT_DUE_DB = ITAB-DEBIT.
         ITAB-NOT_DUE_CR = ITAB-CREDIT.
         ITAB-NOT_DUE    = ITAB-NOT_DUE_DB - ITAB-NOT_DUE_CR.
       ELSEIF ITAB-DAY <= RASTBIS1.

         ITAB-DEBIT30  = ITAB-DEBIT.
         ITAB-CREDIT30 = ITAB-CREDIT.
         ITAB-NETB30 = ITAB-DEBIT30 - ITAB-CREDIT30.
       ELSEIF RASTBIS2 IS INITIAL.
         ITAB-DEBIT60  = ITAB-DEBIT.
         ITAB-CREDIT60 = ITAB-CREDIT.
         ITAB-NETB60   = ITAB-DEBIT60 - ITAB-CREDIT60.
       ELSE.
         IF ITAB-DAY > RASTBIS1 AND ITAB-DAY <= RASTBIS2.
           ITAB-DEBIT60  = ITAB-DEBIT.
           ITAB-CREDIT60 = ITAB-CREDIT.
           ITAB-NETB60   = ITAB-DEBIT60 - ITAB-CREDIT60.
         ELSEIF RASTBIS3 IS INITIAL.
           ITAB-DEBIT90  = ITAB-DEBIT.
           ITAB-CREDIT90 = ITAB-CREDIT.
           ITAB-NETB90   = ITAB-DEBIT90 - ITAB-CREDIT90.
         ELSE.
           IF ITAB-DAY > RASTBIS2 AND ITAB-DAY <= RASTBIS3.
             ITAB-DEBIT90  = ITAB-DEBIT.
             ITAB-CREDIT90 = ITAB-CREDIT.
             ITAB-NETB90   = ITAB-DEBIT90 - ITAB-CREDIT90.
           ELSEIF RASTBIS4 IS INITIAL.
             ITAB-DEBIT120  = ITAB-DEBIT.
             ITAB-CREDIT120 = ITAB-CREDIT.
             ITAB-NETB120   = ITAB-DEBIT120 - ITAB-CREDIT120.
           ELSE.
             IF ITAB-DAY > RASTBIS3 AND ITAB-DAY <= RASTBIS4.
               ITAB-DEBIT120  = ITAB-DEBIT.
               ITAB-CREDIT120 = ITAB-CREDIT.
               ITAB-NETB120   = ITAB-DEBIT120 - ITAB-CREDIT120.
             ELSEIF RASTBIS5 IS INITIAL.
               ITAB-DEBIT180  = ITAB-DEBIT.
               ITAB-CREDIT180 = ITAB-CREDIT.
               ITAB-NETB180   = ITAB-DEBIT180 - ITAB-CREDIT180.
             ELSE.
               IF ITAB-DAY > RASTBIS4 AND ITAB-DAY <= RASTBIS5.
                 ITAB-DEBIT180  = ITAB-DEBIT.
                 ITAB-CREDIT180 = ITAB-CREDIT.
                 ITAB-NETB180   = ITAB-DEBIT180 - ITAB-CREDIT180.
               ELSE.
                 IF ITAB-DAY > RASTBIS5.
                   ITAB-DEBIT360  = ITAB-DEBIT.
                   ITAB-CREDIT360 = ITAB-CREDIT.
                   ITAB-NETB360   = ITAB-DEBIT360 - ITAB-CREDIT360.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
     ELSE.
       IF ITAB-DUEDATE = DATE.
         ITAB-DAY  = 0.
       ELSE.
         ITAB-DAY     = DATE - ITAB-DUEDATE.
       ENDIF.

       IF ITAB-DAY >= 0  .
         IF ITAB-DAY <= RASTBIS1.
           ITAB-DEBIT30  = ITAB-DEBIT.
           ITAB-CREDIT30 = ITAB-CREDIT.
           ITAB-NETB30 = ITAB-DEBIT30 - ITAB-CREDIT30.
         ELSEIF RASTBIS2 IS INITIAL.
           ITAB-DEBIT60  = ITAB-DEBIT.
           ITAB-CREDIT60 = ITAB-CREDIT.
           ITAB-NETB60   = ITAB-DEBIT60 - ITAB-CREDIT60.
         ELSE.
           IF ITAB-DAY > RASTBIS1 AND ITAB-DAY <= RASTBIS2.
             ITAB-DEBIT60  = ITAB-DEBIT.
             ITAB-CREDIT60 = ITAB-CREDIT.
             ITAB-NETB60   = ITAB-DEBIT60 - ITAB-CREDIT60.
           ELSEIF RASTBIS3 IS INITIAL.
             ITAB-DEBIT90  = ITAB-DEBIT.
             ITAB-CREDIT90 = ITAB-CREDIT.
             ITAB-NETB90   = ITAB-DEBIT90 - ITAB-CREDIT90.
           ELSE.
             IF ITAB-DAY > RASTBIS2 AND ITAB-DAY <= RASTBIS3.
               ITAB-DEBIT90  = ITAB-DEBIT.
               ITAB-CREDIT90 = ITAB-CREDIT.
               ITAB-NETB90   = ITAB-DEBIT90 - ITAB-CREDIT90.
             ELSEIF RASTBIS4 IS INITIAL.
               ITAB-DEBIT120  = ITAB-DEBIT.
               ITAB-CREDIT120 = ITAB-CREDIT.
               ITAB-NETB120   = ITAB-DEBIT120 - ITAB-CREDIT120.
             ELSE.
               IF ITAB-DAY > RASTBIS3 AND ITAB-DAY <= RASTBIS4.
                 ITAB-DEBIT120  = ITAB-DEBIT.
                 ITAB-CREDIT120 = ITAB-CREDIT.
                 ITAB-NETB120   = ITAB-DEBIT120 - ITAB-CREDIT120.
               ELSEIF RASTBIS5 IS INITIAL.
                 ITAB-DEBIT180  = ITAB-DEBIT.
                 ITAB-CREDIT180 = ITAB-CREDIT.
                 ITAB-NETB180   = ITAB-DEBIT180 - ITAB-CREDIT180.
               ELSE.
                 IF ITAB-DAY > RASTBIS4 AND ITAB-DAY <= RASTBIS5.
                   ITAB-DEBIT180  = ITAB-DEBIT.
                   ITAB-CREDIT180 = ITAB-CREDIT.
                   ITAB-NETB180   = ITAB-DEBIT180 - ITAB-CREDIT180.
                 ELSE.
                   IF ITAB-DAY > RASTBIS5.
                     ITAB-DEBIT360  = ITAB-DEBIT.
                     ITAB-CREDIT360 = ITAB-CREDIT.
                     ITAB-NETB360   = ITAB-DEBIT360 - ITAB-CREDIT360.
                   ENDIF.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ELSE.
         LV_DAY = ITAB-DAY * -1.
         ITAB-NOT_DUE_DB = ITAB-DEBIT.
         ITAB-NOT_DUE_CR = ITAB-CREDIT.
         ITAB-NOT_DUE    = ITAB-NOT_DUE_DB - ITAB-NOT_DUE_CR.

**         IF lv_day <= rastbis1.
**
**           itab-debit_n30  = itab-debit.
**           itab-credit_n30 = itab-credit.
**           itab-netb_n30 = itab-debit_n30 - itab-credit_n30.
         IF RASTBIS2 IS INITIAL.
           ITAB-DEBIT_N60  = ITAB-DEBIT.
           ITAB-CREDIT_N60 = ITAB-CREDIT.
           ITAB-NETB_N60   = ITAB-DEBIT_N60 - ITAB-CREDIT_N60.
         ELSE.
           IF LV_DAY > RASTBIS1 AND LV_DAY <= RASTBIS2.
             ITAB-DEBIT_N60  = ITAB-DEBIT.
             ITAB-CREDIT_N60 = ITAB-CREDIT.
             ITAB-NETB_N60   = ITAB-DEBIT_N60 - ITAB-CREDIT_N60.
           ELSEIF RASTBIS3 IS INITIAL.
             ITAB-DEBIT_N90  = ITAB-DEBIT.
             ITAB-CREDIT_N90 = ITAB-CREDIT.
             ITAB-NETB_N90   = ITAB-DEBIT_N90 - ITAB-CREDIT_N90.
           ELSE.
             IF LV_DAY > RASTBIS2 AND LV_DAY <= RASTBIS3.
               ITAB-DEBIT_N90  = ITAB-DEBIT.
               ITAB-CREDIT_N90 = ITAB-CREDIT.
               ITAB-NETB_N90   = ITAB-DEBIT_N90 - ITAB-CREDIT_N90.
             ELSEIF RASTBIS4 IS INITIAL.
               ITAB-DEBIT_N120  = ITAB-DEBIT.
               ITAB-CREDIT_N120 = ITAB-CREDIT.
               ITAB-NETB_N120   = ITAB-DEBIT_N120 - ITAB-CREDIT_N120.
             ELSE.
               IF LV_DAY > RASTBIS3 AND LV_DAY <= RASTBIS4.
                 ITAB-DEBIT_N120  = ITAB-DEBIT.
                 ITAB-CREDIT_N120 = ITAB-CREDIT.
                 ITAB-NETB_N120   = ITAB-DEBIT_N120 - ITAB-CREDIT_N120.
               ELSEIF RASTBIS5 IS INITIAL.
                 ITAB-DEBIT_N180  = ITAB-DEBIT.
                 ITAB-CREDIT_N180 = ITAB-CREDIT.
                 ITAB-NETB_N180   = ITAB-DEBIT_N180 - ITAB-CREDIT_N180.
               ELSE.
                 IF LV_DAY > RASTBIS4 AND LV_DAY <= RASTBIS5.
                   ITAB-DEBIT_N180  = ITAB-DEBIT.
                   ITAB-CREDIT_N180 = ITAB-CREDIT.
                   ITAB-NETB_N180   = ITAB-DEBIT_N180 - ITAB-CREDIT_N180.
                 ELSE.
                   IF LV_DAY > RASTBIS5.
                     ITAB-DEBIT_N360  = ITAB-DEBIT.
                     ITAB-CREDIT_N360 = ITAB-CREDIT.
                     ITAB-NETB_N360   = ITAB-DEBIT_N360 - ITAB-CREDIT_N360.
                   ENDIF.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.

**     IF itab-duedate >= date.
**       itab-day = 0.
**     ELSE.
**       itab-day = date - itab-duedate.
**     ENDIF.
***********Net Balance
     ITAB-NETBAL = ITAB-DEBIT - ITAB-CREDIT.


*   ENDIF.
*     READ TABLE lt_data INTO ls_data
     READ TABLE LT_TVZBT INTO LS_TVZBT WITH KEY ZTERM = ITAB-ZTERM.
     IF SY-SUBRC IS INITIAL.
       CONCATENATE LS_TVZBT-ZTERM LS_TVZBT-VTEXT INTO ITAB-VTEXT SEPARATED BY SPACE.
     ENDIF.
     SELECT SINGLE NAME1 INTO ITAB-NAME1 FROM LFA1 WHERE LIFNR = ITAB-LIFNR.
     CONCATENATE ITAB-LIFNR ITAB-NAME1 INTO ITAB-TDISP SEPARATED BY SPACE."itab-umskz

     DATA :LV_STATUS TYPE J_1IMOVEND-J_1ISSIST.
     CLEAR LV_STATUS.
     SELECT SINGLE J_1ISSIST INTO LV_STATUS FROM J_1IMOVEND WHERE LIFNR = ITAB-LIFNR.
     IF LV_STATUS = '1'.
       ITAB-STATUS = 'Micro'.
     ELSEIF LV_STATUS = '2'.
       ITAB-STATUS = 'Small'.
     ELSEIF LV_STATUS = '3'.
       ITAB-STATUS = 'Medium'.
     ELSEIF LV_STATUS = '4'.
       ITAB-STATUS = 'NA'.
     ENDIF.

     READ TABLE LT_SKAT INTO LS_SKAT WITH KEY SAKNR = ITAB-AKONT.
     IF SY-SUBRC IS INITIAL.
       CONCATENATE ITAB-AKONT LS_SKAT-TXT50 INTO ITAB-REC_TXT SEPARATED BY SPACE.
     ELSE.
       ITAB-REC_TXT = ITAB-AKONT.
     ENDIF.
     SHIFT ITAB-REC_TXT LEFT DELETING LEADING '0'.
     SHIFT ITAB-TDISP LEFT DELETING LEADING '0'.

     READ TABLE LT_CLEAR INTO LS_DATA WITH KEY BELNR = ITAB-AUGBL.
     IF SY-SUBRC IS INITIAL.
       ITAB-PDC = ITAB-NETBAL * -1.
     ELSE.
       READ TABLE LT_PARTIAL INTO LS_DATA WITH KEY REBZG = ITAB-BELNR
                                                   REBZJ = ITAB-GJAHR
                                                   REBZZ = ITAB-BUZEI.
       IF SY-SUBRC IS INITIAL.
         LV_INDEX = SY-TABIX.
         LOOP AT LT_PARTIAL INTO LS_DATA FROM LV_INDEX.
           IF LS_DATA-REBZG = ITAB-BELNR AND LS_DATA-REBZJ = ITAB-GJAHR AND LS_DATA-REBZZ = ITAB-BUZEI.
             ITAB-PDC = ITAB-PDC + LS_DATA-DMBTR.
           ELSE.
             EXIT.
           ENDIF.
         ENDLOOP.
       ENDIF.
     ENDIF.
     READ TABLE LT_BKPF INTO LS_BKPF WITH KEY BELNR = ITAB-BELNR
                                              GJAHR = ITAB-GJAHR .
     IF SY-SUBRC IS INITIAL.
       ITAB-INVOICE =  LS_BKPF-AWKEY+0(10).
       ITAB-XBLNR =  LS_BKPF-XBLNR.                                                            "***************ADDED BY SP 09.05.2023

     READ TABLE LT_RSEG INTO LS_RSEG WITH KEY BELNR = LS_BKPF-AWKEY+0(10)
                                              GJAHR = LS_BKPF-YEAR.
     IF SY-SUBRC IS INITIAL.
       READ TABLE LT_MKPF INTO LS_MKPF WITH KEY MBLNR = LS_RSEG-LFBNR
                                                MJAHR = LS_RSEG-LFGJA.
       IF SY-SUBRC IS INITIAL.
         ITAB-GRN_DT = LS_MKPF-BUDAT.
       ELSE.
         READ TABLE LT_MKPF INTO LS_MKPF WITH KEY LFBNR = LS_RSEG-LFBNR
                                                  LFBJA = LS_RSEG-LFGJA.
         IF SY-SUBRC IS INITIAL.
           ITAB-GRN_DT = LS_MKPF-BUDAT.
         ENDIF.
       ENDIF.
     ENDIF.
     ELSE.
      " -------------------------- added by anish on 16.05.2023 ------------------------------------------"
      if ITAB-XBLNR is initial.
        if LINE_EXISTS( LT_BKPF_NEW[ BUKRS = ITAB-BUKRS BELNR = ITAB-BELNR GJAHR = ITAB-GJAHR ] ).
          data(LV_XBLNR) = LT_BKPF_NEW[ BUKRS = ITAB-BUKRS BELNR = ITAB-BELNR GJAHR = ITAB-GJAHR ]-XBLNR.
          ITAB-XBLNR = LV_XBLNR.
          clear LV_XBLNR.
        endif.
      endif.

      "---------------------------------------------------------------------------------------------------"
     ENDIF.

     IF ITAB-WAERS = 'INR'.

       IF NOT ITAB-DEBIT IS INITIAL.
         ITAB-CURR = ITAB-DMBTR.
       ELSEIF NOT ITAB-CREDIT IS INITIAL.
         ITAB-CURR = ITAB-DMBTR * -1.
       ENDIF.
     ELSE.

       IF NOT ITAB-DEBIT IS INITIAL.
         ITAB-CURR = ITAB-WRBTR.
       ELSEIF NOT ITAB-CREDIT IS INITIAL.
         ITAB-CURR = ITAB-WRBTR * -1.
       ENDIF.
     ENDIF.
     MODIFY ITAB.

     CLEAR:
       LS_DATA,LS_SKAT,LS_TVZBT,LS_EKBE,LS_RSEG,LS_BKPF,ITAB,LS_MKPF.
   ENDLOOP.

   LOOP AT LT_PARTIAL INTO LS_DATA WHERE REBZG IS INITIAL.
     READ TABLE ITAB WITH KEY BELNR = LS_DATA-BELNR.
     IF NOT SY-SUBRC IS INITIAL.
       CLEAR ITAB.
       ITAB-GJAHR = LS_DATA-GJAHR.
       ITAB-XBLNR = LS_DATA-XBLNR.                                                               "***************ADDED BY SP 09.05.2023
       ITAB-BELNR = LS_DATA-BELNR.
       ITAB-BUDAT = LS_DATA-BUDAT.
       ITAB-BLDAT = LS_DATA-BLDAT.
       ITAB-DUEDATE = LS_DATA-ZFBDT.
       ITAB-WAERS = LS_DATA-WAERS.
       ITAB-BLART = LS_DATA-BLART.
       ITAB-PDC = LS_DATA-DMBTR.
       ITAB-LIFNR = LS_DATA-LIFNR.
       ITAB-AKONT = LS_DATA-AKONT.

       SELECT SINGLE NAME1 INTO ITAB-NAME1 FROM LFA1 WHERE LIFNR = ITAB-LIFNR.

       CONCATENATE ITAB-LIFNR ITAB-NAME1 INTO ITAB-TDISP SEPARATED BY SPACE.

       READ TABLE LT_SKAT INTO LS_SKAT WITH KEY SAKNR = ITAB-AKONT.
       IF SY-SUBRC IS INITIAL.
         CONCATENATE ITAB-AKONT LS_SKAT-TXT50 INTO ITAB-REC_TXT SEPARATED BY SPACE.
       ELSE.
         ITAB-REC_TXT = ITAB-AKONT.
       ENDIF.
       SHIFT ITAB-REC_TXT LEFT DELETING LEADING '0'.
       SHIFT ITAB-TDISP LEFT DELETING LEADING '0'.

       IF LS_DATA-UMSKZ  = ''.
         ITAB-GROUP  = 'Normal'.
       ELSE.
         ITAB-GROUP  = 'Special G/L'.
       ENDIF.








       APPEND ITAB.
     ENDIF.
   ENDLOOP.

   REFRESH LT_BKPF_NEW.
 ENDFORM.                    " DATALIST_Bsak


*&---------------------------------------------------------------------*
*&      Form  fill_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM FILL_FIELDCATALOG.

   PERFORM F_FIELDCATALOG USING '1'   'TDISP'     'Vendor Name'.
   PERFORM F_FIELDCATALOG USING '2'   'REC_TXT'     'Reconciliation Account '.
   PERFORM F_FIELDCATALOG USING '3'   'GROUP'     'GL Type'.
*   PERFORM f_fieldcatalog USING '2'   'LIFNR'     'Vendor code '.
   PERFORM F_FIELDCATALOG USING '4'   'XBLNR'     'Vendor Invoice No.'.
   PERFORM F_FIELDCATALOG USING '5'   'BELNR'     'Doc No.'.
   PERFORM F_FIELDCATALOG USING '6'   'BLART'     'Doc Type'.
   PERFORM F_FIELDCATALOG USING '7'   'BUDAT'     'Posting Date'.
   PERFORM F_FIELDCATALOG USING '8'   'BLDAT'     'Doc Date'.
   PERFORM F_FIELDCATALOG USING '9'   'DUEDATE'   'Due Date'.
   PERFORM F_FIELDCATALOG USING '10'   'GRN_DT'    'GRN Date'.
   PERFORM F_FIELDCATALOG USING '11'   'VTEXT'    'Payment Terms'.
   PERFORM F_FIELDCATALOG USING '12'   'CURR'     'Amt Document Currency'.
   PERFORM F_FIELDCATALOG USING '13'   'WAERS'    'Currency Key'.
   PERFORM F_FIELDCATALOG USING '14'   'CREDIT'    'Invoice Amt.'.
   PERFORM F_FIELDCATALOG USING '15'   'DEBIT'    'Payment/Debit Memo Amt'.
   PERFORM F_FIELDCATALOG USING '16'  'NETBAL'    'Net Pending'.
   PERFORM F_FIELDCATALOG USING '17'  'NETB30'    RC13. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '18'  'NETB60'    RC14. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '19'  'NETB90'    RC15. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '20'  'NETB120'   RC16. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '21'  'NETB180'   RC17. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '22'  'NETB360'   RC18. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '23'  'NOT_DUE'   'Not Due'. "'Net Balance'.
*   PERFORM f_fieldcatalog USING '23'  'NETB_N30'   rc19. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '24'  'NETB_N60'   RC20. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '25'  'NETB_N90'   RC21. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '26'  'NETB_N120'  RC22. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '27'  'NETB_N180'  RC23. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '28'  'NETB_N360'  RC24. "'Net Balance'.
   PERFORM F_FIELDCATALOG USING '29'  'DAY'       'Over Due Days'.
   PERFORM F_FIELDCATALOG USING '30'  'PDC'       'PDC Amt.'.
   PERFORM F_FIELDCATALOG USING '31'  'INVOICE'       'Invoice No.'.
   PERFORM F_FIELDCATALOG USING '32'  'STATUS'       'MSME Status'.


 ENDFORM.                    " FILL_FIELDCATALOG

*&---------------------------------------------------------------------*
*&      Form  top-of-page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM TOP-OF-PAGE.

*  ALV Header declarations
   DATA: T_HEADER      TYPE SLIS_T_LISTHEADER,
         WA_HEADER     TYPE SLIS_LISTHEADER,
         T_LINE        LIKE WA_HEADER-INFO,
         LD_LINES      TYPE I,
         LD_LINESC(10) TYPE C.

*  Title
   WA_HEADER-TYP  = 'H'.
   WA_HEADER-INFO = 'Payables Report'.
   APPEND WA_HEADER TO T_HEADER.
   CLEAR WA_HEADER.

*  Date
   WA_HEADER-TYP  = 'S'.
   WA_HEADER-KEY  = 'As on: '.
   CONCATENATE WA_HEADER-INFO DATE+6(2) '.' DATE+4(2) '.' DATE(4) INTO WA_HEADER-INFO.
   APPEND WA_HEADER TO T_HEADER.
   CLEAR: WA_HEADER.

*   Total No. of Records Selected

   DESCRIBE TABLE ITAB LINES LD_LINES.
   LD_LINESC = LD_LINES.

   CONCATENATE 'Total No. of Records Selected: ' LD_LINESC
      INTO T_LINE SEPARATED BY SPACE.

   WA_HEADER-TYP  = 'A'.
   WA_HEADER-INFO = T_LINE.
   APPEND WA_HEADER TO T_HEADER.
   CLEAR: WA_HEADER, T_LINE.

   CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
     EXPORTING
       IT_LIST_COMMENTARY = T_HEADER.
 ENDFORM.                    " top-of-page

*&---------------------------------------------------------------------*
*&      Form  sort_list
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM SORT_LIST.
   T_SORT-SPOS      = '1'.
   T_SORT-FIELDNAME = 'TDISP'.
   T_SORT-TABNAME   = 'ITAB'.
   T_SORT-UP        = 'X'.
   APPEND T_SORT.

   T_SORT-SPOS      = '3'.
   T_SORT-FIELDNAME = 'GROUP'.
   T_SORT-TABNAME   = 'ITAB'.
   T_SORT-UP        = 'X'.
   APPEND T_SORT.


*   t_sort-spos      = '3'.
*   t_sort-fieldname = 'NAME1'.
*   t_sort-tabname   = 'ITAB'.
*   t_sort-up        = 'X'.
*
*   APPEND t_sort.


 ENDFORM.                    " sort_list

*&---------------------------------------------------------------------*
*&      Form  fill_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM FILL_LAYOUT.
   FS_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
   FS_LAYOUT-ZEBRA             = 'X'.
   FS_LAYOUT-DETAIL_POPUP      = 'X'.
   FS_LAYOUT-SUBTOTALS_TEXT    = 'DR'.

 ENDFORM.                    " fill_layout

*&---------------------------------------------------------------------*
*&      Form  f_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->VALUE(X)   text
*      -->VALUE(F1)  text
*      -->VALUE(F2)  text
*----------------------------------------------------------------------*
 FORM F_FIELDCATALOG  USING   VALUE(X)
                              VALUE(F1)
                              VALUE(F2).
   T_FIELDCAT-COL_POS      = X.
   T_FIELDCAT-FIELDNAME    = F1.
   T_FIELDCAT-SELTEXT_L    = F2.
*  t_fieldcat-decimals_out = '2'.

   IF F1 = 'DEBIT'    OR F1 = 'CREDIT'    OR F1 = 'DEBIT30'  OR F1 = 'CREDIT30'  OR
      F1 = 'DEBIT60'  OR F1 = 'CREDIT60'  OR F1 = 'DEBIT90'  OR F1 = 'CREDIT90'  OR
      F1 = 'DEBIT120' OR F1 = 'CREDIT120' OR F1 = 'DEBIT180' OR F1 = 'CREDIT180' OR
      F1 = 'DEBIT360' OR F1 = 'CREDIT360' OR F1 = 'NETBAL'   OR F1 = 'NETB30'    OR
      F1 = 'NETB60'   OR F1 = 'NETB90'    OR F1 = 'NETB120'  OR F1 = 'NETB180'   OR
      F1 = 'NETB360'  OR F1 = 'PDC'       OR F1 = 'NOT_DUE'  OR F1 = 'NETB_N60' OR
      F1 = 'NETB_N90' OR F1 = 'NETB_N120' OR F1 = 'NETB_N180'  OR F1 = 'NETB_N360'.

     T_FIELDCAT-DO_SUM = 'X'.
   ENDIF.

   IF F1 = 'TDISP'.
     T_FIELDCAT-KEY = 'X'.
   ENDIF.

   IF  F1 = 'NETB_N60'  OR F1 = 'NETB_N120' OR F1 = 'NETB_N90'
    OR F1 = 'NETB_N180' OR F1 = 'NETB_N360' OR F1 = 'NOT_DUE'.
     T_FIELDCAT-EMPHASIZE = 'C510'.
   ENDIF.

   IF F1 = 'BELNR'.
     T_FIELDCAT-HOTSPOT = 'X'.
   ENDIF.
   APPEND T_FIELDCAT.
   CLEAR T_FIELDCAT.

 ENDFORM.                    " f_fieldcatalog

*&---------------------------------------------------------------------*
*&      Form  list_display
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM LIST_DISPLAY.

   CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
     EXPORTING
       I_CALLBACK_PROGRAM      = SY-REPID
       I_CALLBACK_USER_COMMAND = 'USER_CMD'
       IS_LAYOUT               = FS_LAYOUT
       I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'
       IT_FIELDCAT             = T_FIELDCAT[]
       IT_SORT                 = T_SORT[]
       I_SAVE                  = 'X'
     TABLES
       T_OUTTAB                = ITAB[]
     EXCEPTIONS
       PROGRAM_ERROR           = 1
       OTHERS                  = 2.
   IF SY-SUBRC <> 0.
     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
             WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
   ENDIF.


   IF P_DOWN = 'X'.
     PERFORM DOWNLOAD.
   ENDIF.
 ENDFORM.                    " list_display


*&---------------------------------------------------------------------*
*&      Form  USER_CMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

 FORM USER_CMD USING R_UCOMM LIKE SY-UCOMM
                     RS_SELFIELD TYPE SLIS_SELFIELD.
   IF R_UCOMM = '&IC1'.
     IF RS_SELFIELD-FIELDNAME = 'BELNR'.
       READ TABLE ITAB INDEX RS_SELFIELD-TABINDEX .            "WITH"KEY belnr = rs_selfield-value.     ADDED BY SP 12.05.2023
       IF SY-SUBRC = 0.                                            "********************************************ADDED BY SP 12.05.2023
         SET PARAMETER ID 'BLN' FIELD RS_SELFIELD-VALUE.
         SET PARAMETER ID 'BUK' FIELD PLANT.
         SET PARAMETER ID 'GJR' FIELD ITAB-GJAHR.
*       SET PARAMETER ID 'AWT' FIELD transaction.
         CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
       ENDIF.                                                    "********************************************ADDED BY SP 12.05.2023
     ENDIF.
   ENDIF.
 ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
 FORM DOWNLOAD .
   TYPE-POOLS TRUXS.
   DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
         WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
         HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

   DATA:
     LT_FINAL TYPE TT_FILE,
     LS_FINAL TYPE T_FILE.

*  DATA: lv_folder(150).
   DATA: LV_FILE(30).
   DATA: LV_FULLFILE TYPE STRING,
         LV_DAT(10),
         LV_TIM(4).
   DATA: LV_MSG(80).

   LOOP AT ITAB.
     LS_FINAL-TDISP   = ITAB-TDISP.
     LS_FINAL-REC_TXT = ITAB-REC_TXT.
     LS_FINAL-GROUP   = ITAB-GROUP.
     LS_FINAL-XBLNR   = ITAB-XBLNR.                                                "***************ADDED BY SP 09.05.2023
     LS_FINAL-BELNR   = ITAB-BELNR.
     LS_FINAL-BLART   = ITAB-BLART.
     LS_FINAL-VTEXT   = ITAB-VTEXT.
     LS_FINAL-WAERS   = ITAB-WAERS.
     LS_FINAL-INVOICE = ITAB-INVOICE.
     LS_FINAL-STATUS  = ITAB-STATUS.

     IF NOT ITAB-BUDAT IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           INPUT  = ITAB-BUDAT
         IMPORTING
           OUTPUT = LS_FINAL-BUDAT.
       CONCATENATE LS_FINAL-BUDAT+0(2) LS_FINAL-BUDAT+2(3) LS_FINAL-BUDAT+5(4)
                      INTO LS_FINAL-BUDAT SEPARATED BY '-'.
     ENDIF.

     IF NOT ITAB-BLDAT IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           INPUT  = ITAB-BLDAT
         IMPORTING
           OUTPUT = LS_FINAL-BLDAT.
       CONCATENATE LS_FINAL-BLDAT+0(2) LS_FINAL-BLDAT+2(3) LS_FINAL-BLDAT+5(4)
                      INTO LS_FINAL-BLDAT SEPARATED BY '-'.
     ENDIF.

     IF NOT ITAB-DUEDATE IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           INPUT  = ITAB-DUEDATE
         IMPORTING
           OUTPUT = LS_FINAL-DUEDATE.
       CONCATENATE LS_FINAL-DUEDATE+0(2) LS_FINAL-DUEDATE+2(3) LS_FINAL-DUEDATE+5(4)
                      INTO LS_FINAL-DUEDATE SEPARATED BY '-'.
     ENDIF.

     IF NOT ITAB-GRN_DT IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           INPUT  = ITAB-GRN_DT
         IMPORTING
           OUTPUT = LS_FINAL-GRN_DT.
       CONCATENATE LS_FINAL-GRN_DT+0(2) LS_FINAL-GRN_DT+2(3) LS_FINAL-GRN_DT+5(4)
                      INTO LS_FINAL-GRN_DT SEPARATED BY '-'.
     ENDIF.


     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
       EXPORTING
         INPUT  = SY-DATUM
       IMPORTING
         OUTPUT = LS_FINAL-CURR_DT.
     CONCATENATE LS_FINAL-CURR_DT+0(2) LS_FINAL-CURR_DT+2(3) LS_FINAL-CURR_DT+5(4)
                    INTO LS_FINAL-CURR_DT SEPARATED BY '-'.

     LS_FINAL-CURR           = ABS( ITAB-CURR ).
     IF ITAB-CURR < 0.
       CONDENSE LS_FINAL-CURR.
       CONCATENATE '-' LS_FINAL-CURR INTO LS_FINAL-CURR.
     ENDIF.

     LS_FINAL-CREDIT           = ABS( ITAB-CREDIT ).
     IF ITAB-CREDIT < 0.
       CONDENSE LS_FINAL-CREDIT.
       CONCATENATE '-' LS_FINAL-CREDIT INTO LS_FINAL-CREDIT.
     ENDIF.

     LS_FINAL-DEBIT           = ABS( ITAB-DEBIT ).
     IF ITAB-DEBIT < 0.
       CONDENSE LS_FINAL-DEBIT.
       CONCATENATE '-' LS_FINAL-DEBIT INTO LS_FINAL-DEBIT.
     ENDIF.

     LS_FINAL-NETBAL           = ABS( ITAB-NETBAL ).
     IF ITAB-NETBAL < 0.
       CONDENSE LS_FINAL-NETBAL.
       CONCATENATE '-' LS_FINAL-NETBAL INTO LS_FINAL-NETBAL.
     ENDIF.

     LS_FINAL-NETB30           = ABS( ITAB-NETB30 ).
     IF ITAB-NETB30 < 0.
       CONDENSE LS_FINAL-NETB30.
       CONCATENATE '-' LS_FINAL-NETB30 INTO LS_FINAL-NETB30.
     ENDIF.

     LS_FINAL-NETB60           = ABS( ITAB-NETB60 ).
     IF ITAB-NETB60 < 0.
       CONDENSE LS_FINAL-NETB60.
       CONCATENATE '-' LS_FINAL-NETB60 INTO LS_FINAL-NETB60.
     ENDIF.

     LS_FINAL-NETB90           = ABS( ITAB-NETB90 ).
     IF ITAB-NETB90 < 0.
       CONDENSE LS_FINAL-NETB90.
       CONCATENATE '-' LS_FINAL-NETB90 INTO LS_FINAL-NETB90.
     ENDIF.

     LS_FINAL-NETB120           = ABS( ITAB-NETB120 ).
     IF ITAB-NETB120 < 0.
       CONDENSE LS_FINAL-NETB120.
       CONCATENATE '-' LS_FINAL-NETB120 INTO LS_FINAL-NETB120.
     ENDIF.

     LS_FINAL-NETB180           = ABS( ITAB-NETB180 ).
     IF ITAB-NETB180 < 0.
       CONDENSE LS_FINAL-NETB180.
       CONCATENATE '-' LS_FINAL-NETB180 INTO LS_FINAL-NETB180.
     ENDIF.

     LS_FINAL-NETB360           = ABS( ITAB-NETB360 ).
     IF ITAB-NETB360 < 0.
       CONDENSE LS_FINAL-NETB360.
       CONCATENATE '-' LS_FINAL-NETB360 INTO LS_FINAL-NETB360.
     ENDIF.

     LS_FINAL-NOT_DUE           = ABS( ITAB-NOT_DUE ).
     IF ITAB-NOT_DUE < 0.
       CONDENSE LS_FINAL-NOT_DUE.
       CONCATENATE '-' LS_FINAL-NOT_DUE INTO LS_FINAL-NOT_DUE.
     ENDIF.

     LS_FINAL-NETB_N60           = ABS( ITAB-NETB_N60 ).
     IF ITAB-NETB_N60 < 0.
       CONDENSE LS_FINAL-NETB_N60.
       CONCATENATE '-' LS_FINAL-NETB_N60 INTO LS_FINAL-NETB_N60.
     ENDIF.

     LS_FINAL-NETB_N90           = ABS( ITAB-NETB_N90 ).
     IF ITAB-NETB_N90 < 0.
       CONDENSE LS_FINAL-NETB_N90.
       CONCATENATE '-' LS_FINAL-NETB_N90 INTO LS_FINAL-NETB_N90.
     ENDIF.

     LS_FINAL-NETB_N120           = ABS( ITAB-NETB_N120 ).
     IF ITAB-NETB_N120 < 0.
       CONDENSE LS_FINAL-NETB_N120.
       CONCATENATE '-' LS_FINAL-NETB_N120 INTO LS_FINAL-NETB_N120.
     ENDIF.

     LS_FINAL-NETB_N180           = ABS( ITAB-NETB_N180 ).
     IF ITAB-NETB_N180 < 0.
       CONDENSE LS_FINAL-NETB_N180.
       CONCATENATE '-' LS_FINAL-NETB_N180 INTO LS_FINAL-NETB_N180.
     ENDIF.

     LS_FINAL-NETB_N360           = ABS( ITAB-NETB_N360 ).
     IF ITAB-NETB_N360 < 0.
       CONDENSE LS_FINAL-NETB_N360.
       CONCATENATE '-' LS_FINAL-NETB_N360 INTO LS_FINAL-NETB_N360.
     ENDIF.

     LS_FINAL-PDC           = ABS( ITAB-PDC ).
     IF ITAB-PDC < 0.
       CONDENSE LS_FINAL-PDC.
       CONCATENATE '-' LS_FINAL-PDC INTO LS_FINAL-PDC.
     ENDIF.

     LS_FINAL-DAY           = ABS( ITAB-DAY ).
     IF ITAB-DAY < 0.
       CONDENSE LS_FINAL-DAY.
       CONCATENATE '-' LS_FINAL-DAY INTO LS_FINAL-DAY.
     ENDIF.

     CONCATENATE sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2)  INTO ls_final-ref_time.

     APPEND LS_FINAL TO LT_FINAL.
     CLEAR:
       LS_FINAL,ITAB.

   ENDLOOP.
   CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
     TABLES
       I_TAB_SAP_DATA       = LT_FINAL
     CHANGING
       I_TAB_CONVERTED_DATA = IT_CSV
     EXCEPTIONS
       CONVERSION_FAILED    = 1
       OTHERS               = 2.
   IF SY-SUBRC <> 0.
* Implement suitable error handling here
   ENDIF.

   PERFORM CVS_HEADER USING HD_CSV.

   IF R1 = 'X'.
*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
     LV_FILE = 'ZPAYABLES_DOC_DT.TXT'.

     CONCATENATE P_FOLDER '/' LV_FILE
       INTO LV_FULLFILE.

     WRITE: / 'ZPAYABLES for Document date Download started on', SY-DATUM, 'at', SY-UZEIT.
   ELSE.
     LV_FILE = 'ZPAYABLES_DUE_DT.TXT'.

     CONCATENATE P_FOLDER '/' LV_FILE
       INTO LV_FULLFILE.

     WRITE: / 'ZPAYABLES for Due date Download started on', SY-DATUM, 'at', SY-UZEIT.
   ENDIF.

   OPEN DATASET LV_FULLFILE
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
   IF SY-SUBRC = 0.
DATA lv_string_1775 TYPE string.
DATA lv_crlf_1775 TYPE string.
lv_crlf_1775 = cl_abap_char_utilities=>cr_lf.
lv_string_1775 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_1775 lv_crlf_1775 wa_csv INTO lv_string_1775.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_1775 TO lv_fullfile.
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
   CONCATENATE 'Vendor Name'
               'Reconciliation Account'
               'GL Type'
               'Vendor Invoice No.'
               'Doc No.'
               'Doc Type'
               'Posting Date'
               'Doc Date'
               'Due Date'
               'GRN Date'
               'Payment Terms'
               'Amt Document Currency'
               'Currency Key'
               'Invoice Amt.'
               'Payment/Debit Memo Amt'
               'Net Pending'
               RC13
               RC14
               RC15
               RC16
               RC17
               RC18
               'Not Due'
               RC20
               RC21
               RC22
               RC23
               RC24
               'Over Due Days'
               'PDC Amt.'
               'File Run Dt'
               'Invoice No.'
               'MSME Status'
               'Refreshable Time'
          INTO PD_CSV
          SEPARATED BY L_FIELD_SEPERATOR.


 ENDFORM.
