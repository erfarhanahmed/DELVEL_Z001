*&---------------------------------------------------------------------*
*& Report ZAXIS_MAN_PAY_RUN_TCI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAXIS_MAN_PAY_RUN_TCI.


TABLES : RFCDES,
         T012K.

TYPE-POOLS : VRM.

CONSTANTS: C_DEST(20)             VALUE 'AXISBANK',
           C_ZERO(1)              VALUE '0',
           C_MANIND(4)            VALUE 'MANP',
           C_CHEQUE(1)            VALUE 'C',
           C_DD(1)                VALUE 'D',
           C_NEFT(1)              VALUE 'N',
           C_RTGS(1)              VALUE 'R',
           C_ACC(1)               VALUE 'I',
           C_HDF(3)               VALUE 'HDF',
           C_PAYMETHOD(2)         VALUE 'PM',
           C_MINRTGS(7)           VALUE 'MINRTGS',
           C_BRANCH(6)            VALUE 'BRANCH',
           C_PRINT(5)             VALUE 'PRINT',
           C_HKONTGL(7)           VALUE 'HKONTGL',
           C_VENDNOR(2)           VALUE '25',
           C_VENDADV(2)           VALUE '29',
           C_CUSTNOR(2)           VALUE '05',
           C_CUSTADV(2)           VALUE '09',
           C_BANKLINE(2)          VALUE '50',
           C_H(1)                 VALUE 'H',
           C_S(1)                 VALUE 'S',
           C_RFCNOTFOUND(50)      VALUE
           'RFC destination is not created',
           C_RECORDSNOTFOUND(100) VALUE
           'No suitable entries found. Kindly check your input.'.

DATA : LV_EMPFB     TYPE BSEG-EMPFB,                       " +DD02
       LV_FISCAL    TYPE BSEG-GJAHR,                       " +DD02
       C_ENCRYPT    TYPE STRING VALUE 'encryptdaemon.bat',    "An006
       C_DEFUALT    TYPE STRING VALUE 'D:\GenericEncryption_Client\', "an006
       C_SOURCE(50) VALUE 'D:\GenericEncryption_Client\datafiles\clearfiles\', "An006
       C_DESTI(50)  VALUE 'D:\GenericEncryption_Client\datafiles\encfiles\'. "an006"TO ACTIVATE/DE-ACTIVATE ALTERNATE PAYEE

DATA : LV_ERROR TYPE  CHAR1 .

TYPES : BEGIN OF TY_WITHITEM,
          BUKRS    LIKE WITH_ITEM-BUKRS,
          BELNR    LIKE WITH_ITEM-BELNR,
          GJAHR    LIKE WITH_ITEM-GJAHR,
          BUZEI    LIKE WITH_ITEM-BUZEI,
          WT_QBSHH LIKE WITH_ITEM-WT_QBSHH,
        END OF TY_WITHITEM.

TYPES : BEGIN OF TY_PAID_AMT,
          BUKRS         LIKE BSEG-BUKRS,
          BELNR         LIKE BSEG-BELNR,
          GJAHR         LIKE BSEG-GJAHR,
          DMBTR         LIKE BSEG-DMBTR,
          HKONT         LIKE BSEG-HKONT,
          HOUSEBANK     LIKE T012-HBKID,
          ALREADY_EX(1),
          DELETEFLAG(1),
        END OF TY_PAID_AMT.

TYPES : BEGIN OF TY_CLOSEDLINES,
          BUKRS LIKE BSAK-BUKRS,
          BELNR LIKE BSAK-BELNR,
          GJAHR LIKE BSAK-GJAHR,
          AUGBL LIKE BSAK-AUGBL,
          AUGGJ LIKE BSAK-AUGGJ,
          AUGDT LIKE BSAK-AUGDT,                            "rj01
          BUZEI LIKE BSAK-BUZEI,                            "rj01
          CPUDT LIKE BSAK-CPUDT,                            "aaded on 23.03.2023
        END OF TY_CLOSEDLINES.

TYPES : BEGIN OF TY_OPENLINES,
          BUKRS LIKE BSIK-BUKRS,
          BELNR LIKE BSIK-BELNR,
          GJAHR LIKE BSIK-GJAHR,
          REBZG LIKE BSIK-REBZG,
          REBZJ LIKE BSIK-REBZJ,
          REBZZ LIKE BSIK-REBZZ,
          DMBTR LIKE BSIK-DMBTR,
        END OF TY_OPENLINES.

TYPES : BEGIN OF TY_ALT_VEN,
          LNRZA LIKE LFA1-LNRZA,
        END OF TY_ALT_VEN.

TYPES : BEGIN OF TY_BKPF,
          BUKRS   LIKE BKPF-BUKRS,
          BELNR   LIKE BKPF-BELNR,
          GJAHR   LIKE BKPF-GJAHR,
          BLDAT   LIKE BKPF-BLDAT,
          BUDAT   LIKE BKPF-BUDAT,
          XBLNR   LIKE BKPF-XBLNR,
          STBLG   LIKE BKPF-STBLG,
          VMUL(1) TYPE C,
        END OF TY_BKPF.

TYPES : BEGIN OF TY_TCIEG,
          BUKRS LIKE BSEG-BUKRS,
          BELNR LIKE BSEG-BELNR,
          GJAHR LIKE BSEG-GJAHR,
          BUZEI LIKE BSEG-BUZEI,
          LIFNR LIKE BSEG-LIFNR,
          KUNNR LIKE BSEG-KUNNR,
          VALUT LIKE BSEG-VALUT,
          BSCHL LIKE BSEG-BSCHL,
          UMSKZ LIKE BSEG-UMSKZ,
          SHKZG LIKE BSEG-SHKZG,
          DMBTR LIKE BSEG-DMBTR,
          PSWSL LIKE BSEG-PSWSL,
          GSBER LIKE BSEG-GSBER,
          SKFBT LIKE BSEG-SKFBT,
          QSSHB LIKE BSEG-QSSHB,
          QSSKZ LIKE BSEG-QSSKZ,
          HBKID LIKE BSEG-HBKID,
          ZLSCH LIKE BSEG-ZLSCH,
          HKONT LIKE BSEG-HKONT,
          AUGBL LIKE BSEG-AUGBL,                            "rj01
          AUGDT LIKE BSEG-AUGDT,                            "rj01
          BVTYP LIKE BSEG-BVTYP,
        END OF TY_TCIEG.

TYPES : BEGIN OF TY_TCIEC,
          BUKRS LIKE BSEC-BUKRS,
          BELNR LIKE BSEC-BELNR,
          GJAHR LIKE BSEC-GJAHR,
          BUZEI LIKE BSEC-BUZEI,
          ANRED LIKE BSEC-ANRED,
          NAME1 LIKE BSEC-NAME1,
          NAME2 LIKE BSEC-NAME2,
          NAME3 LIKE BSEC-NAME3,
          NAME4 LIKE BSEC-NAME4,
          ORT01 LIKE BSEC-ORT01,
          PSTLZ LIKE BSEC-PSTLZ,
          ADRNR LIKE BSEC-ADRNR,
        END OF TY_TCIEC.

TYPES : BEGIN OF TY_LFA1,
          LIFNR LIKE LFA1-LIFNR,
          NAME1 LIKE LFA1-NAME1,
          NAME2 LIKE LFA1-NAME2,
          ADRNR LIKE LFA1-ADRNR,
          LNRZA LIKE LFA1-LNRZA,
          SORTL LIKE LFA1-SORTL,
          STRAS LIKE LFA1-STRAS,
          MCOD3 LIKE LFA1-MCOD3,
          PSTLZ LIKE LFA1-PSTLZ,
          LAND1 LIKE LFA1-LAND1,
          ORT01 LIKE LFA1-ORT01,
          ORT02 LIKE LFA1-ORT02,
        END OF TY_LFA1.

TYPES : BEGIN OF TY_LFBK,
          LIFNR LIKE LFBK-LIFNR,
          BANKS LIKE LFBK-BANKS,
          BANKL LIKE LFBK-BANKL,
          BANKN LIKE LFBK-BANKN,
          BKREF LIKE LFBK-BKREF,
          BVTYP LIKE LFBK-BVTYP,
          KOINH LIKE LFBK-KOINH,
        END OF TY_LFBK.

TYPES : BEGIN OF TY_LFB1,
          LIFNR LIKE LFB1-LIFNR,
          BUKRS LIKE LFB1-BUKRS,
          ZAHLS LIKE LFB1-ZAHLS,
          TLFXS LIKE LFB1-TLFXS,
        END OF TY_LFB1.

TYPES : BEGIN OF TY_KNA1,
          KUNNR LIKE KNA1-KUNNR,
          NAME1 LIKE KNA1-NAME1,
          NAME2 LIKE KNA1-NAME2,
          ADRNR LIKE KNA1-ADRNR,
          SORTL LIKE KNA1-SORTL,
          STRAS LIKE KNA1-STRAS,
          MCOD3 LIKE KNA1-MCOD3,
          PSTLZ LIKE KNA1-PSTLZ,
          LAND1 LIKE KNA1-LAND1,
          ORT01 LIKE KNA1-ORT01,
          TELF1 LIKE KNA1-TELF1,
          TELFX LIKE KNA1-TELFX,
          REGIO LIKE KNA1-REGIO,
        END OF TY_KNA1.

TYPES : BEGIN OF TY_KNBK,
          KUNNR LIKE KNBK-KUNNR,
          BANKS LIKE KNBK-BANKS,
          BANKL LIKE KNBK-BANKL,
          BANKN LIKE KNBK-BANKN,
          BKREF LIKE KNBK-BKREF,
          BVTYP LIKE KNBK-BVTYP,
          KOINH LIKE KNBK-KOINH,
        END OF TY_KNBK.

TYPES : BEGIN OF TY_KNB1,
          KUNNR LIKE KNB1-KUNNR,
          BUKRS LIKE KNB1-BUKRS,
          ZAHLS LIKE KNB1-ZAHLS,
        END OF TY_KNB1.

TYPES : BEGIN OF TY_BNKA,
          BANKS LIKE BNKA-BANKS,
          BANKL LIKE BNKA-BANKL,
          BANKA LIKE BNKA-BANKA,
          SWIFT LIKE BNKA-SWIFT,
          BNKLZ LIKE BNKA-BNKLZ,
          BRNCH LIKE BNKA-BRNCH,
        END OF TY_BNKA.

TYPES : BEGIN OF TY_ADRC,
          ADDRNUMBER LIKE ADRC-ADDRNUMBER,
          STREET     LIKE ADRC-STREET,
          HOUSE_NUM1 LIKE ADRC-HOUSE_NUM1,
          STR_SUPPL1 LIKE ADRC-STR_SUPPL1,
          STR_SUPPL2 LIKE ADRC-STR_SUPPL2,
          STR_SUPPL3 LIKE ADRC-STR_SUPPL3,
          CITY1      LIKE ADRC-CITY1,
          POST_CODE1 LIKE ADRC-POST_CODE1,
          LOCATION   LIKE ADRC-LOCATION,
          REGION     LIKE ADRC-REGION,
          TEL_NUMBER LIKE ADRC-TEL_NUMBER,
        END OF TY_ADRC.

TYPES : BEGIN OF TY_ADR6,
          ADDRNUMBER LIKE ADR6-ADDRNUMBER,
          SMTP_ADDR  LIKE ADR6-SMTP_ADDR,
          FLGDEFAULT TYPE ADR6-FLGDEFAULT,
        END OF TY_ADR6.

TYPES : BEGIN OF TY_PAYR,
          ZBUKR LIKE PAYR-ZBUKR,
          HBKID LIKE PAYR-HBKID,
          HKTID LIKE PAYR-HKTID,
          CHECT LIKE PAYR-CHECT,
          VBLNR LIKE PAYR-VBLNR,
          GJAHR LIKE PAYR-GJAHR,
          LIFNR LIKE PAYR-LIFNR,
          KUNNR LIKE PAYR-KUNNR,
        END OF TY_PAYR.

TYPES : BEGIN OF TY_T012,
          BUKRS LIKE T012-BUKRS,
          HBKID LIKE T012-HBKID,
          BANKL LIKE T012-BANKL,
        END OF TY_T012.

TYPES: BEGIN OF TY_ALV_DISPLAY,
         STATUS(12)      TYPE C,
         REMARKS(100)    TYPE C,
         LIFNR           LIKE BSEG-LIFNR,
         KUNNR           LIKE BSEG-KUNNR,
         BELNR           LIKE BSEG-BELNR,
         RWBTR(30)       TYPE  C,
*         RWBTR          TYPE p LENGTH 13 DECIMALS 2,
         VEND_NAME(140)  TYPE C,
         VEND_CODE       TYPE LIFNR,
         LINE_COLOR(4)   TYPE C,
         PAY_TYPE(10)    TYPE C,
         NO_OF_INVOICES  TYPE I,
         DD_PAY_LOC(35)  TYPE C,
         PRINT_LOC(35)   TYPE C,
         FIS_YR          LIKE BSEG-GJAHR,
         BENE_ACC_NO(25),
         IFSC_CODE(15),
         BENE_NAME(100),
         VENDOR_CODE(10),
         ERR_TYPE        TYPE I,
         MESSAGE(255)    TYPE C,
       END OF TY_ALV_DISPLAY.

TYPES: BEGIN OF TY_CLR,
         BUKRS_CLR TYPE BSE_CLR-BUKRS_CLR,
         BELNR_CLR TYPE BSE_CLR-BELNR_CLR,
         GJAHR_CLR TYPE BSE_CLR-GJAHR,
         INDEX_CLR TYPE BSE_CLR-INDEX_CLR,
         BELNR     TYPE BSE_CLR-BELNR,
         BUKRS     TYPE BSE_CLR-BUKRS,
         GJAHR     TYPE BSE_CLR-GJAHR,
         SHKZG     TYPE BSE_CLR-SHKZG,
         DMBTR     TYPE BSE_CLR-DMBTR,
         DIFHW     TYPE BSE_CLR-DIFHW,
       END OF TY_CLR.

TYPES: BEGIN OF TY_CLR_TEMP,
         BUKRS_CLR TYPE BSE_CLR-BUKRS_CLR,
         BELNR_CLR TYPE BSE_CLR-BELNR_CLR,
         GJAHR_CLR TYPE BSE_CLR-GJAHR,
         SHKZG     TYPE BSE_CLR-SHKZG,
         DMBTR     TYPE BSE_CLR-DMBTR,
         DIFHW     TYPE BSE_CLR-DIFHW,
       END OF TY_CLR_TEMP.

TYPES : BEGIN OF TY_SKB1,
          BUKRS TYPE BUKRS,
          SAKNR TYPE SAKNR,
          HBKID	TYPE HBKID,
          HKTID	TYPE HKTID,
        END OF TY_SKB1.

DATA : IT_SKB1         TYPE TY_SKB1 OCCURS 0 WITH HEADER LINE,
       IT_TCIEG_PAY_GL TYPE TY_TCIEG OCCURS 0 WITH HEADER LINE .  "04.10.2022

DATA : IT_BKPF          TYPE TY_BKPF OCCURS 0 WITH HEADER LINE,
       IT_BKPF_INV_DOC  TYPE TY_BKPF OCCURS 0 WITH HEADER LINE,
       IT_TCIEG_PAY_DOC TYPE TY_TCIEG OCCURS 0 WITH HEADER LINE,
       IT_TCIEG_TMP     TYPE TY_TCIEG OCCURS 0 WITH HEADER LINE,
       IT_TCIEG_INV_DOC TYPE TY_TCIEG OCCURS 0 WITH HEADER LINE,
       IT_INVOICES      TYPE TY_TCIEG OCCURS 0 WITH HEADER LINE,
       IT_TCIEG         TYPE TY_TCIEG  OCCURS 0 WITH HEADER LINE,
       IT_TCIEG_TEMP    TYPE TY_TCIEG  OCCURS 0 WITH HEADER LINE,
       IT_TCIEC         TYPE TY_TCIEC  OCCURS 0 WITH HEADER LINE,
       IT_LFA1          TYPE TY_LFA1  OCCURS 0 WITH HEADER LINE,
       IT_KNA1          TYPE TY_KNA1  OCCURS 0 WITH HEADER LINE,
       IT_ADRC          TYPE TY_ADRC  OCCURS 0 WITH HEADER LINE,
       IT_ADR6          TYPE TY_ADR6  OCCURS 0 WITH HEADER LINE,
       IT_LFBK          TYPE TY_LFBK  OCCURS 0 WITH HEADER LINE,
       IT_LFB1          TYPE TY_LFB1 OCCURS 0 WITH HEADER LINE,
       IT_KNBK          TYPE TY_KNBK  OCCURS 0 WITH HEADER LINE,
       IT_KNB1          TYPE TY_KNB1 OCCURS 0 WITH HEADER LINE,
       IT_BNKA          TYPE TY_BNKA  OCCURS 0 WITH HEADER LINE,
       IT_PAYR          TYPE TY_PAYR  OCCURS 0 WITH HEADER LINE,
       IT_WITHITEM      TYPE TY_WITHITEM OCCURS 0 WITH HEADER LINE,
       IT_PAID_AMT      TYPE TY_PAID_AMT OCCURS 0 WITH HEADER LINE,
       IT_CLOSEDLINES   TYPE TY_CLOSEDLINES OCCURS 0 WITH HEADER LINE,
       IT_OPENLINES     TYPE TY_OPENLINES OCCURS 0 WITH HEADER LINE,
       IT_PAD           TYPE TY_OPENLINES OCCURS 0 WITH HEADER LINE, "rj01
       IT_ALT_VEN       TYPE TY_ALT_VEN OCCURS 0 WITH HEADER LINE,
       IT_T012          TYPE TY_T012  OCCURS 0 WITH HEADER LINE,
       IT_PAYMETHODS    LIKE ZAXISMAP_TCI OCCURS 0 WITH HEADER LINE,
       IT_ZAXISLOG      LIKE ZAXISLOG1_TCI OCCURS 0 WITH HEADER LINE,
       IT_ZAXISMAP_TCI  LIKE ZAXISMAP_TCI OCCURS 0 WITH HEADER LINE,
       IT_INFO(200)     OCCURS 0 WITH HEADER LINE,
       ITAB1(800)       OCCURS 0 WITH HEADER LINE,
       ITAB(800)        OCCURS 0 WITH HEADER LINE,
       WA_ZAXISLOG      LIKE ZAXISLOG1_TCI,
       IT_CLR           TYPE TABLE OF TY_CLR,
       IT_CLR_TEMP      TYPE  TY_CLR_TEMP OCCURS 0 WITH HEADER LINE, "rj02
       WA_CLR           TYPE TY_CLR,
       IT_ZAXISLOG_TCI  LIKE ZAXISLOG_TCI OCCURS 0 WITH HEADER LINE. " auto mapping

DATA: X_BKPF LIKE LINE OF IT_BKPF.

DATA: BEGIN OF IT_ERROR OCCURS 0,
        VBLNR   LIKE REGUH-VBLNR,
        RMK(70),
      END OF IT_ERROR.

DATA: BEGIN OF ZITAB1 OCCURS 0,
        FLD_STR(1000) TYPE C,
      END OF ZITAB1.
DATA: ZITAB2 LIKE TABLE OF ZITAB1 WITH HEADER LINE.

DATA: BEGIN OF AXISHEADER1,
        PAY_DOC_IND_START,    "~
        PROGRAM_RUN_DATE(10), "DD/MM/YYYY,
        RUN_IDENTIFIER(6),                                  "UVR3
        PAY_CO_CODE(4),       "TICI
        PAY_DOC_NO(12),       "420000000613
        PAY_AMOUNT(15),       "13.2 1234567890123.12-
        CURRENCY(5),          "INR
        PMT_METHOD,           "Payment Method C,D,B
        VENDOR_CODE(10),                                    "0000010000
        VENDOR_TITLE(15),     "M/S
        VENDOR_NAME1(70),                                   "Name1
        VENDOR_NAME2(70),                                   "Name2
        VENDOR_ADDR1(35),     "Address - 1
        VENDOR_ADDR2(35),     "Address - 2
        VENDOR_ADDR3(35),     "Address - 3
        VENDOR_ADDR4(35),     "District
        VENDOR_ADDR5(35),      "City Name
        VENDOR_ADDR6(10), "Postal Code
        HOUSE_BANK(5),        "House Bank in SAP - HBKID
        HOUSEBANK_ACID(5),    "House bank Account ID in SAP -HKTID
        VALUE_DATE(10),       "DD/MM/YYYY
        INSTRUCTION_DATE(10), "DD/MM/YYYY
        MODE_OF_DELIVERY(12), "Cheque Delivery Options
        CHEQUE_NO(13),        "Cheque number
        CHEQUE_DATE(10),        "Cheque number
        DD_DREW_LOC(35),       "DD Payable location
        DD_PAY_LOC(35),       "DD Payable location
        PRINTING_LOC(35),     "Printing Location
        IFSC_CODE(15),        "ifsc code
        BENE_BNK_NAME(100),   "bank name
        BENE_BNK_BRNCH(100),  "bank barnch
        BENE_ACC_NO(25),      "beneficiary account number
        BENE_ACC_TYP(3),      "beneficiary account type
        BENE_EMAIL(100),      "email id of beneficiary
        INSR_REF_NO(31),      "insruction Ref NO.
        CUST_REF_NO(10),      "Customer Ref NO.
        PAYMENT_DETAIL1(10),   "payment detail1
        PAYMENT_DETAIL2(10),   "payment detail2
        PAYMENT_DETAIL3(10),   "payment detail3
        PAYMENT_DETAIL4(10),   "payment detail4
        PAYMENT_DETAIL5(10),   "payment detail5
        PAYMENT_DETAIL6(10),   "payment detail6
        PAYMENT_DETAIL7(10),   "payment detail7
        MICR_NO(15),           "MICR no
        GJAHR(5),               "Year
      END OF AXISHEADER1.

DATA : H1 LIKE TABLE OF AXISHEADER1 WITH HEADER LINE.

DATA: BEGIN OF AXISHEADER2,
        H2_START_IND(2), "Payment document Indicator ~H
        COMPANY_CODE(4),       "Company code
        PAY_DOC_NO(12),       "420000000613
        DOC_DATE(10),     "DD/MM/YYYY
      END OF AXISHEADER2.


DATA: BEGIN OF AXISDETAIL OCCURS 0,
        ADV_START_IND(2),       "Advice document Indicator ~D
        TITLE1(41),       "Invoice Number 0000012345
        TITLE2(41),
        TITLE3(41),
        TITLE4(41),
        TITLE5(41),
        TITLE6(41),
        TITLE7(41),
        TITLE8(41),
        TAX_DETAIL1(70),     "Invoice Tax details
        TAX_DETAIL2(70),     "Invoice Tax details
        TAX_DETAIL3(70),     "Invoice Tax details
        TAX_DETAIL4(70),     "Invoice Tax details
        TAX_DETAIL5(70),     "Invoice Tax details
        TAX_DETAIL6(70),     "Invoice Tax details
        TAX_DETAIL7(70),     "Invoice Tax details
      END OF AXISDETAIL.

***rj03 - start
DATA : H1_TEMP         LIKE TABLE OF AXISHEADER1 WITH HEADER LINE,
       ZITAB1_TEMP     LIKE TABLE OF ZITAB1 WITH HEADER LINE,
       ITAB1_TEMP(800) OCCURS 0 WITH HEADER LINE.
***rj03 - end

DATA : V_SOURCE           LIKE RLGRAP-FILENAME,
       V_DESTINATION      LIKE RLGRAP-FILENAME,
       V_TCIEG_LINES      TYPE I,
       V_NUMDOC           TYPE I,
       V_NUMINV           TYPE I,
       V_LIFNR            LIKE LFA1-LIFNR,
       V_ONETIMEVENDOR(1),
       X_INFO(200),
       V_PAYAMOUNT        LIKE BSEG-DMBTR,
       V_DOCS             TYPE I,
       V_INVOICES         TYPE I,
       V_AMOUNT           LIKE REGUP-DMBTR,
       V_TDS              LIKE BSEG-DMBTR,
       V_TTDS(20),
       V_NET              LIKE REGUP-DMBTR,
       V_LINES            TYPE I,
       V_OUTPUT_FILE(128),
       M_MESSAGE(200),                              "An001
       V_USER_EMAIL       LIKE ADR6-SMTP_ADDR,
       V_PARTIAL_FLAG(1),
       V_NOENTRIES(1),
       V_RFCDEST          LIKE RFCDES-RFCDEST,
       WA_RAPI            TYPE ZAXIS_RES_API.

*type pools for alv declarations
TYPE-POOLS: SLIS.

* Internal table and workarea declarations for tstc
DATA: IT_ALV_DISPLAY TYPE STANDARD TABLE OF TY_ALV_DISPLAY,
      WA_ALV_DISPLAY TYPE TY_ALV_DISPLAY.

*data declarations for ALV
DATA: IT_LAYOUT   TYPE SLIS_LAYOUT_ALV,
      WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV,
      IT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV.

DATA : IT_SORT TYPE SLIS_T_SORTINFO_ALV, "internal table for sorting
       "field
       WA_SORT TYPE SLIS_SORTINFO_ALV. "work area for sorting field

*ALV data declarations
DATA: FIELDCATALOG  TYPE SLIS_T_FIELDCAT_ALV WITH HEADER LINE,
      GD_PRNTPARAMS TYPE SLIS_PRINT_ALV.

"TO ACTIVATE/DE-ACTIVATE ALTERNATE PAYEE

DATA: LV_ADDRESS   TYPE ADRC,
      LV_NAME(140)."LV_ADDRESS(210)
DATA:  LV_NAME_VRM TYPE VRM_ID.
DATA:  LV_ACCOUNT_NUM(25) TYPE C."en001 25-09-2018
CONSTANTS: C_EMAIL(100)    VALUE 'TEST_SAPEXTRACTOR@AXISBANK.COM',
           C_FG_EMAIL(100) VALUE 'ap.india@flintgrp.com',
           C_PM_CHK(6)     TYPE C VALUE 'CHEQUE',
           C_PM_DD(2)      TYPE C  VALUE 'DD',
           C_PM_NEFT(10)   TYPE C VALUE 'NEFT',
           C_PM_IFT(10)    TYPE C VALUE 'IFT',
           C_PM_RTGS(4)    TYPE C VALUE 'RTGS',

           C_ERROR(5)      TYPE C VALUE 'ERROR',
           C_SUCCESS(7)    TYPE C VALUE 'SUCCESS',
           C_INFO(11)      TYPE C VALUE 'INFORMATION',
           C_INR(3)        TYPE C VALUE 'INR'.

DATA       LV_FLD_NAME(30) TYPE C.
DATA: LV_SUC_CNT(4) TYPE C VALUE 0,
      LV_ERR_CNT(4) TYPE C VALUE 0,
      LV_INF_CNT(4) TYPE C VALUE 0.
DATA       LV_SUMMARY TYPE STRING.
DATA       LV_LINES TYPE I.
DATA       LV_COUNT_RECRD TYPE I.
DATA       LV_PERC TYPE P.
DATA       LV_TEXT(80) TYPE C.
DATA       LV_GJAHR LIKE BSEG-GJAHR.
DATA       LV_PERIV LIKE T001-PERIV.
DATA       LV_VEND_CUST TYPE LIFNR.
DATA       LV_PM(10) TYPE C.
DATA: LV_MESSAGE(100) TYPE C,
      LV_F4_BUKRS     TYPE T012K-BUKRS,
      LV_F4_HBKID     TYPE T012K-HBKID.

DATA: IT_EXCLUDING TYPE SLIS_T_EXTAB.
DATA I_EVENTS TYPE SLIS_T_EVENT.

DATA: I_END_OF_PAGE TYPE SLIS_T_LISTHEADER.

DATA: W_EVENTS TYPE SLIS_ALV_EVENT.

DATA: V_REPID LIKE SY-REPID.
DATA: LV_ET_TOTAL  TYPE RWBTR VALUE 0,
      LV_CHK_TOTAL TYPE RWBTR VALUE 0,
      LV_DD_TOTAL  TYPE RWBTR VALUE 0,
      LV_TOT_AMT   TYPE RWBTR VALUE 0.

DATA: LV_ET_TOTAL_C(15)  TYPE C,                            "an001
      LV_CHK_TOTAL_C(15) TYPE C,                           "An001
      LV_DD_TOTAL_C(15)  TYPE C,                            "an001
      LV_TOT_AMT_C(15)   TYPE C.                             "an001

DATA  LV_ALREADY_EX TYPE C.
*DATA:     OUTPUT_FILE1(80).
DATA: I_INFO(200)  OCCURS 0 WITH HEADER LINE,
      I_INFO1(200) OCCURS 0 WITH HEADER LINE.

DATA : T_BDCDATA TYPE TABLE OF BDCDATA,
       W_BDCDATA TYPE BDCDATA.


TYPES: BEGIN OF TY_PM,
         ZLSCH TYPE BSEG-ZLSCH,
         TEXT1 TYPE T042Z-TEXT1,
       END OF TY_PM.
TYPES: BEGIN OF TY_HBKID,
         HKTID TYPE T012K-HKTID,
       END OF TY_HBKID.

CONSTANTS: C_X          TYPE C VALUE 'X',
           C_PAYLOC(50) TYPE C     VALUE 'P_PAYLOC',
           C_PRTLOC(50) TYPE C     VALUE 'P_PRTLOC',
           C_BUKRS(7)   TYPE C     VALUE 'S_BUKRS',
           C_HKTID(7)   TYPE C     VALUE  'S_HKTID',
           C_HBKID(7)   TYPE C    VALUE 'S_HBKID',
           C_PAY(3)     TYPE C     VALUE 'PAY'.


DATA  LV_TEXT_OUTPUT(100) TYPE C.
DATA: IT_PM     TYPE TABLE OF  TY_PM,
      IT_HKTID  TYPE TABLE OF  TY_HBKID,
      IT_RETURN LIKE DDSHRETVAL OCCURS 0 WITH HEADER LINE,
      DYNFIELDS TYPE DYNPREAD OCCURS 0 WITH HEADER LINE,
      IT_VALUES TYPE VRM_VALUES,
      LV_NO(2)  TYPE   C.

DATA : LV_HBK(5)   TYPE C,
       LV_HB_AC(5) TYPE C.

CONSTANTS : C_GL TYPE STRING VALUE '2450201' . "28.06.2022
CONSTANTS : C_SET1  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ', "space is included
            C_SET2  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ',
            C_SET3  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,/-?:().+''',
            C_SET4  TYPE STRING VALUE '0123456789 ',
            C_SET5  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789  :/-.',
            C_SET6  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ,/-?().+''', "An002 "will be used for text fields
            C_SET7  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789  -@._',
            C_SET8  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ,/.-&()\#@''', "space is included."An002
            C_SET9  TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-/ ', "space is included "an002
            C_SET10 TYPE STRING VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,()'. "An002
DATA : V_ERR_FLG TYPE C.

TYPES: BEGIN OF TY_SPLIT ,                                  "MJ001
         SPLIT_FILE(60),
         SPLIT_COUNT(5),
         SPLIT_AMOUNT(20),
       END OF TY_SPLIT.

DATA :IT_SPLIT     TYPE STANDARD TABLE OF TY_SPLIT,             "MJ001
      WA_SPLIT     TYPE TY_SPLIT,
      SPLIT_COUNT  TYPE I,
      SPLIT_AMOUNT TYPE REGUH-RWBTR.
DATA WA_TT-VENDOR_CODE.


DEFINE FIELD_CAT.

  CLEAR wa_fieldcat.
  wa_fieldcat-row_pos   = &1 .
  wa_fieldcat-col_pos   = &2 .
  wa_fieldcat-fieldname = &3 .
  wa_fieldcat-tabname   = &4 .
  wa_fieldcat-seltext_m = &5 .

  APPEND wa_fieldcat TO it_fieldcat.

END-OF-DEFINITION.


DEFINE ALV_POP1.

  wa_alv_display-status = &1 .
  wa_alv_display-remarks = &2 .
  wa_alv_display-belnr =  &3 .
  wa_alv_display-fis_yr = &4 .
  wa_alv_display-vend_name = &5 .
  wa_alv_display-vend_code = &6 .

END-OF-DEFINITION.

DEFINE ALV_POP2.

  wa_alv_display-no_of_invoices = &1 .
  wa_alv_display-rwbtr = &2 .
  wa_alv_display-pay_type = &3 .
  wa_alv_display-print_loc = &4 .
  wa_alv_display-dd_pay_loc = &5 .
  wa_alv_display-err_type = &6 .

  APPEND wa_alv_display TO it_alv_display.
  CLEAR wa_alv_display.

END-OF-DEFINITION.

DATA: WA_ZAXISMAP_TCI LIKE LINE OF IT_ZAXISMAP_TCI,
      X_VALUES        LIKE LINE OF IT_VALUES.


********************************************
*to activate or deactivate
********************************************
DATA  LV_CHKBYSAP TYPE C VALUE 'X'.

DATA  LV_ALV_DISPLAY TYPE C VALUE 'X'.

DATA  LV_ALTPAY_ACTIVE TYPE C VALUE 'X'.
DATA  LV_OTV_ACTIVE TYPE C VALUE 'X'.
DATA  LV_CUSTOMER_ACTIVE TYPE C VALUE 'X'.

DATA  LV_PRINTLOC_DD TYPE C VALUE ''.
DATA  LV_DDLOC_DD TYPE C VALUE ''.

DATA  LV_CITYMAP_PRINTLOC_ACTIVE TYPE C VALUE ''.
DATA  LV_DEF_PLOC_ACTIVE TYPE C VALUE ''.
DATA  LV_DEF_PLOC(4) TYPE C VALUE ''.

DATA  LV_CENTRALIZED_PL_ACT TYPE C VALUE 'X'.
DATA  LV_CPRINT_LOC(4) TYPE C VALUE '0000'. "MUMBAI

DATA  LV_SERVER_ENCRYPT TYPE C VALUE 'X'.
DATA  H2H TYPE C VALUE 'X'.                                  "
DATA  C_DOMAIN(20) TYPE C.
DATA: USER(30)        TYPE C,
      PWD(30)         TYPE C,
      HOST(64)        TYPE C,
      RFDEST          TYPE RFCDES-RFCDEST,
      SLEN            TYPE I,
      FTP_HANDLE      TYPE I,
      CMD(100)        TYPE C,
      LV_FTPPATH(100) TYPE C.
DATA: L_CMD(100) TYPE C.
DATA: CMD_C(100) TYPE C.
DATA: BEGIN OF RESULTS OCCURS 0,
        LINE(120),
      END OF RESULTS.
DATA  LV_PATH(100) TYPE C VALUE 'AXIS'.
DATA  C_CMD(100) TYPE C.                                  "
DATA : C_EXTRACT TYPE STRING." VALUE 'D:\GenericEncryption_Client\datafiles\clearfiles\'.       "clearfiles
DATA : LV_SERVER_ENCRYPT_SRC_PATH TYPE STRING." VALUE 'D:\GenericEncryption_Client\datafiles\encfiles\'.  "encfiles
DATA : LV_ENCRYPT_DWNLD_DEST_PATH TYPE STRING VALUE 'C:\AXISBANK\IMPORT\'.
DATA : LV_SERVER_ENCRYPT_SRC TYPE STRING.                   "MJ003
DATA : LV_ENCRYPT_DWNLD_DEST TYPE STRING.                   "MJ003

*DATA  : LV_PATH(100) TYPE C VALUE 'AXIS'. "
********************************************
*to activate or deactivate
********************************************


SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: S_BUKRS LIKE T012K-BUKRS MEMORY ID BUK OBLIGATORY,
*              S_HBKID LIKE T012K-HBKID MEMORY ID HBK OBLIGATORY DEFAULT 'AXI77',
              S_HBKID LIKE T012K-HBKID MEMORY ID HBK OBLIGATORY DEFAULT 'AXI98',
              S_HKTID LIKE T012K-HKTID OBLIGATORY DEFAULT 'AXI98'.
  SELECT-OPTIONS: S_GJAHR FOR IT_BKPF-GJAHR OBLIGATORY,
                  S_BELNR FOR IT_BKPF-BELNR OBLIGATORY.
*                s_budat for it_bkpf-budat.
  PARAMETERS:     P_PM LIKE IT_TCIEG-ZLSCH OBLIGATORY DEFAULT 'N' MODIF ID GRP.
  PARAMETERS: P_PAYLOC(15) AS LISTBOX VISIBLE LENGTH 40 OBLIGATORY,
              P_PRTLOC(15) AS LISTBOX VISIBLE LENGTH 40 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK B1.
SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME.
  PARAMETERS: P_TEST AS CHECKBOX TYPE C MODIF ID EXT DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK B2.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.

    IF SCREEN-NAME = 'P_PM' OR SCREEN-GROUP1 = 'GRP'..
      SCREEN-ACTIVE = '0'.     " Makes the field inactive
      SCREEN-INVISIBLE = '1'.  " Hides the field
      MODIFY SCREEN.
    ENDIF.

  ENDLOOP.


***Display selection screen based on the settings defined on Admin screen

  IF LV_DDLOC_DD EQ ''.
    LOOP AT SCREEN .
      IF SCREEN-NAME = C_PAYLOC OR SCREEN-NAME = '%_P_PAYLOC_%_APP_%-TEXT'.
        SCREEN-ACTIVE = 0 .
      ENDIF .
      MODIFY SCREEN .
    ENDLOOP .
  ENDIF.

  IF LV_PRINTLOC_DD EQ ''.
    LOOP AT SCREEN .
      IF SCREEN-NAME = C_PRTLOC OR SCREEN-NAME = '%_P_PRTLOC_%_APP_%-TEXT'.
        SCREEN-ACTIVE = 0 .
      ENDIF .
      MODIFY SCREEN .
    ENDLOOP .
  ENDIF.

  IF LV_PRINTLOC_DD EQ 'X'.
*********Instrument Printing locations
    REFRESH :IT_ZAXISMAP_TCI,
               IT_VALUES.
    CLEAR  : WA_ZAXISMAP_TCI,
             X_VALUES,
             LV_NO.


*    SELECT * FROM ZAXISMAP_TCI
    SELECT * FROM   ZAXISMAP_TCI
             INTO TABLE IT_ZAXISMAP_TCI WHERE ZFIELD_REF = C_PRINT.

    LOOP AT IT_ZAXISMAP_TCI INTO WA_ZAXISMAP_TCI.

      MOVE WA_ZAXISMAP_TCI-ZSAP_VALUE TO P_PRTLOC.
      MOVE P_PRTLOC TO X_VALUES.


      APPEND X_VALUES TO  IT_VALUES.
      CLEAR  : WA_ZAXISMAP_TCI,
               X_VALUES.
    ENDLOOP.

    CLEAR: LV_NAME_VRM.
    MOVE C_PRTLOC TO LV_NAME_VRM.

    READ TABLE IT_ZAXISMAP_TCI INTO WA_ZAXISMAP_TCI WITH KEY P_PRTLOC.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        ID              = LV_NAME_VRM
        VALUES          = IT_VALUES
      EXCEPTIONS
        ID_ILLEGAL_NAME = 1
        OTHERS          = 2.
    IF SY-SUBRC <> 0.

    ENDIF.
  ENDIF.

  IF LV_DDLOC_DD EQ 'X'.
*********Instrument Printing locations
    REFRESH :IT_ZAXISMAP_TCI,
               IT_VALUES.
    CLEAR  : WA_ZAXISMAP_TCI,
             X_VALUES,
             LV_NO.

*    SELECT * FROM ZAXISMAP_TCI
    SELECT * FROM ZAXISMAP_TCI
             INTO TABLE IT_ZAXISMAP_TCI WHERE ZFIELD_REF = C_BRANCH.
    SORT IT_ZAXISMAP_TCI.

    LOOP AT IT_ZAXISMAP_TCI INTO WA_ZAXISMAP_TCI.

      MOVE WA_ZAXISMAP_TCI-ZSAP_VALUE TO P_PAYLOC.
      MOVE P_PAYLOC TO X_VALUES.


      APPEND X_VALUES TO  IT_VALUES.
      CLEAR  : WA_ZAXISMAP_TCI,
               X_VALUES.
    ENDLOOP.

    CLEAR: LV_NAME_VRM.
    MOVE C_PAYLOC TO LV_NAME_VRM.

    READ TABLE IT_ZAXISMAP_TCI INTO WA_ZAXISMAP_TCI WITH KEY P_PAYLOC.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        ID              = LV_NAME_VRM
        VALUES          = IT_VALUES
      EXCEPTIONS
        ID_ILLEGAL_NAME = 1
        OTHERS          = 2.
    IF SY-SUBRC <> 0.

    ENDIF.

  ENDIF.



  LOOP AT SCREEN.
    IF SCREEN-NAME = 'S_HBKID' OR  SCREEN-NAME = 'S_HKTID'.
      IF SY-UNAME = 'ADMIN_USER'.
        SCREEN-INPUT = 1.
      ELSE.
        SCREEN-INPUT = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
*************************************************************************
**AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_ernam.
*************************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_PM.

  SELECT ZLSCH TEXT1 FROM T042Z INTO TABLE IT_PM WHERE LAND1 = 'IN'.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD   = 'p_pm'
      VALUE_ORG  = 'S'
    TABLES
      VALUE_TAB  = IT_PM
      RETURN_TAB = IT_RETURN.

  IF SY-SUBRC = 0.
    P_PM = IT_RETURN-FIELDVAL.
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR S_HKTID.

  MOVE C_BUKRS TO DYNFIELDS-FIELDNAME.
  APPEND DYNFIELDS.
  MOVE C_HBKID TO DYNFIELDS-FIELDNAME.
  APPEND DYNFIELDS.


  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      DYNAME             = SY-CPROG
      DYNUMB             = SY-DYNNR
      TRANSLATE_TO_UPPER = C_X
    TABLES
      DYNPFIELDS         = DYNFIELDS.
  IF SY-SUBRC = 0.
    READ TABLE DYNFIELDS WITH KEY FIELDNAME = C_BUKRS.
    LV_F4_BUKRS = DYNFIELDS-FIELDVALUE.
    READ TABLE DYNFIELDS WITH KEY FIELDNAME = C_HBKID.
    LV_F4_HBKID = DYNFIELDS-FIELDVALUE.

    SELECT HKTID FROM T012K INTO TABLE IT_HKTID WHERE BUKRS = LV_F4_BUKRS AND
                                                      HBKID = LV_F4_HBKID.
    DELETE ADJACENT DUPLICATES FROM IT_HKTID COMPARING HKTID.
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        RETFIELD   = 's_hktid'
        VALUE_ORG  = 'S'
      TABLES
        VALUE_TAB  = IT_HKTID
        RETURN_TAB = IT_RETURN.
  ENDIF.
  IF SY-SUBRC = 0.
    S_HKTID = IT_RETURN-FIELDVAL.
  ENDIF.



*----------------------------------------------------------------------
START-OF-SELECTION.
*----------------------------------------------------------------------

  SELECTION-SCREEN SKIP 3.
  SELECTION-SCREEN COMMENT 1(83) TEXT-010.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN COMMENT 7(65) TEXT-011.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN COMMENT 7(65) TEXT-012.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN COMMENT 7(65) TEXT-013.

  SELECTION-SCREEN SKIP 2.
  SELECTION-SCREEN COMMENT 1(83) TEXT-014.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN COMMENT 7(65) TEXT-015.
*  SELECTION-SCREEN SKIP 1.
*  SELECTION-SCREEN COMMENT 7(65) TEXT-016.
  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN COMMENT 7(83) TEXT-017.
*  SELECTION-SCREEN SKIP 1.
*  SELECTION-SCREEN COMMENT 7(65) TEXT-018.
*
*  SELECTION-SCREEN SKIP 2.
*  SELECTION-SCREEN COMMENT 1(83) TEXT-019.

* Moving files from IMPORT to PROCESSED, if final run
  IF P_TEST IS INITIAL.
    PERFORM MOVING_FILES.
  ENDIF.
* Fetch all details into internal tables
  CLEAR : V_NOENTRIES,LV_ALREADY_EX.
  PERFORM FETCH_DETAILS.
* Populate file contents
  IF V_NOENTRIES IS INITIAL OR LV_ALREADY_EX IS NOT INITIAL.
    PERFORM PAYMENT_DETAILS_CONSTRUCT.
  ELSE.
    FORMAT INTENSIFIED OFF INVERSE OFF INPUT OFF COLOR 6.
    WRITE :/ C_RECORDSNOTFOUND.
    FORMAT COLOR OFF.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  moving_files
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM MOVING_FILES.
  DATA: V_FILE_COUNT  TYPE I,
        V_DIR_COUNT   TYPE I,
        IT_FILE_TABLE LIKE SDOKPATH OCCURS 0 WITH HEADER LINE,
        IT_DIR_TABLE  LIKE SDOKPATH OCCURS 0 WITH HEADER LINE,
        V_RETURN      TYPE I.

  CONSTANTS : C_IMPORT(50) VALUE 'C:\AXISBANK\IMPORT\',
              C_FILTER(4)  VALUE '*.*'.

  CALL FUNCTION 'TMP_GUI_DIRECTORY_LIST_FILES'
    EXPORTING
      DIRECTORY  = C_IMPORT
      FILTER     = C_FILTER
    IMPORTING
      FILE_COUNT = V_FILE_COUNT
      DIR_COUNT  = V_DIR_COUNT
    TABLES
      FILE_TABLE = IT_FILE_TABLE
      DIR_TABLE  = IT_DIR_TABLE
    EXCEPTIONS
      CNTL_ERROR = 1
      OTHERS     = 2.

  IF SY-SUBRC = 0.
    LOOP AT IT_FILE_TABLE.
      CLEAR: V_SOURCE, V_DESTINATION.
      CONCATENATE C_SOURCE  IT_FILE_TABLE-PATHNAME
             INTO V_SOURCE.
      CONCATENATE C_DESTI   IT_FILE_TABLE-PATHNAME
             INTO V_DESTINATION.

      CALL FUNCTION 'WS_FILE_COPY'
        EXPORTING
          DESTINATION = V_DESTINATION
          SOURCE      = V_SOURCE
        IMPORTING
          RETURN      = V_RETURN.

      CALL FUNCTION 'WS_FILE_DELETE'
        EXPORTING
          FILE   = V_SOURCE
        IMPORTING
          RETURN = V_RETURN.
    ENDLOOP.

    CALL FUNCTION 'TMP_GUI_DIRECTORY_LIST_FILES'
      EXPORTING
        DIRECTORY  = V_SOURCE
        FILTER     = C_FILTER
      IMPORTING
        FILE_COUNT = V_FILE_COUNT
        DIR_COUNT  = V_DIR_COUNT
      TABLES
        FILE_TABLE = IT_FILE_TABLE
        DIR_TABLE  = IT_DIR_TABLE
      EXCEPTIONS
        CNTL_ERROR = 1
        OTHERS     = 2.
    IF V_FILE_COUNT > 0.
      CLEAR LV_MESSAGE.

      CONCATENATE 'Error copying files from C:\AXISBANK\IMPORT'
                  'to C:\AXISBANK\PROCESSED folder'
                  INTO LV_MESSAGE SEPARATED BY SPACE.
      ALV_POP1     C_ERROR
                 LV_MESSAGE
                 ''
                 ''
                 ''
                 ''.

      ALV_POP2     ''
                   ''
                   ''
                   ''
                   ''
                    1.
    ENDIF.
  ENDIF.

ENDFORM.                    "moving_files

*&---------------------------------------------------------------------*
*&      Form  fetch_details
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FETCH_DETAILS.
* Fetch payment document header details
  REFRESH : IT_BKPF.
  CLEAR : IT_BKPF.
  SELECT BUKRS BELNR GJAHR BLDAT BUDAT XBLNR STBLG FROM BKPF
  INTO TABLE IT_BKPF
  WHERE BUKRS = S_BUKRS AND
        BELNR IN S_BELNR AND
        GJAHR IN S_GJAHR. " and
*        budat in s_budat.

  SORT IT_BKPF BY BUKRS BELNR GJAHR.
  DELETE ADJACENT DUPLICATES FROM IT_BKPF COMPARING BELNR.

  IF IT_BKPF[] IS INITIAL.
    V_NOENTRIES = 'X'.
  ELSE.
*   Fetch AXIS log and mapping details
    REFRESH : IT_ZAXISLOG, IT_ZAXISMAP_TCI.
    CLEAR : IT_ZAXISLOG, IT_ZAXISMAP_TCI.
    SELECT * INTO TABLE IT_ZAXISLOG FROM ZAXISLOG1_TCI.
*    SELECT * INTO TABLE IT_ZAXISMAP_TCI FROM ZAXISMAP_TCI.
    SELECT * INTO TABLE IT_ZAXISMAP_TCI FROM ZAXISMAP_TCI.

******* Mapping table for automatic
    SELECT * INTO TABLE IT_ZAXISLOG_TCI FROM ZAXISLOG_TCI.
*    SELECT * INTO TABLE IT_ZAXISMAP_TCI FROM ZAXISMAP_TCI.
    SELECT * INTO TABLE IT_ZAXISMAP_TCI FROM ZAXISMAP_TCI.
*   Fetch payment document line item details
    REFRESH : IT_TCIEG_PAY_DOC.
    CLEAR : IT_TCIEG_PAY_DOC.
    SELECT BUKRS BELNR GJAHR BUZEI LIFNR KUNNR
           VALUT BSCHL UMSKZ SHKZG DMBTR PSWSL
           GSBER SKFBT QSSHB QSSKZ HBKID ZLSCH HKONT AUGBL AUGDT BVTYP   "rj01 augbl and augdt added   "gp001 BVTYP added 20022017
    FROM BSEG INTO TABLE IT_TCIEG_PAY_DOC
    FOR ALL ENTRIES IN IT_BKPF
    WHERE BUKRS = IT_BKPF-BUKRS AND
          BELNR = IT_BKPF-BELNR AND
          GJAHR = IT_BKPF-GJAHR.

    IT_TCIEG_TMP[] = IT_TCIEG_PAY_DOC[].
    DELETE IT_TCIEG_TMP WHERE LIFNR IS   INITIAL.
    DELETE ADJACENT DUPLICATES FROM IT_TCIEG_TMP COMPARING LIFNR.

    SORT IT_TCIEG_TMP BY BUKRS BELNR LIFNR.
    DATA LV_CNT TYPE I.
    LOOP AT IT_BKPF.
      CLEAR LV_CNT.
      LOOP AT IT_TCIEG_TMP WHERE BELNR EQ IT_BKPF-BELNR.
        LV_CNT = LV_CNT + 1.
        IF LV_CNT GT 1.
          IT_BKPF-VMUL = 'X'.
          MODIFY IT_BKPF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

*05.07.2022
    SELECT BUKRS SAKNR HBKID HKTID FROM SKB1 INTO  TABLE IT_SKB1
          WHERE  BUKRS = S_BUKRS
          AND    HKTID = S_HKTID
          AND    HBKID = S_HBKID.
*          AND    SAKNR = '0002450201' .

    DATA : LV_ROWCNT TYPE I .
    LOOP AT IT_TCIEG_PAY_DOC.
      IF IT_TCIEG_PAY_DOC-BSCHL NE C_BANKLINE.
        CLEAR : IT_TCIEG.
        MOVE IT_TCIEG_PAY_DOC TO IT_TCIEG.
        APPEND IT_TCIEG.
      ENDIF.


*     Populate IT_PAID_AMT table with bank line item details
      IF IT_TCIEG_PAY_DOC-BSCHL = C_BANKLINE AND
         IT_TCIEG_PAY_DOC-QSSKZ IS INITIAL.
        CLEAR : IT_PAID_AMT.
        MOVE-CORRESPONDING IT_TCIEG_PAY_DOC TO IT_PAID_AMT.
        MOVE-CORRESPONDING IT_TCIEG_PAY_DOC TO IT_TCIEG_PAY_GL .   "04.10.2022
        APPEND IT_PAID_AMT.
        APPEND IT_TCIEG_PAY_GL .  "04.10.2022

      ENDIF.

    ENDLOOP.
    "04.10.2022

    DATA: LV_MSG TYPE CHAR1 .
    CLEAR : LV_MSG .
    LOOP AT IT_TCIEG_PAY_GL .
      READ TABLE IT_SKB1 INTO DATA(WA_B1) WITH KEY SAKNR = IT_TCIEG_PAY_GL-HKONT .
*      IF IT_SKB1-SAKNR NE IT_TCIEG_PAY_GL-HKONT.
      IF SY-SUBRC NE 0 .

        LV_MSG  = 'X' .
        CLEAR LV_MESSAGE..
        DELETE IT_TCIEG WHERE BUKRS = IT_TCIEG_PAY_GL-BUKRS AND        """"  Cmt By NC
                            BELNR = IT_TCIEG_PAY_GL-BELNR AND
                            GJAHR = IT_TCIEG_PAY_GL-GJAHR.
*
        CONCATENATE 'Invalid' 'document'
               INTO LV_MESSAGE SEPARATED BY SPACE.
        ALV_POP1     C_ERROR
                     LV_MESSAGE
                     IT_TCIEG-BELNR
                     IT_TCIEG-GJAHR
                     LV_NAME
                     LV_VEND_CUST.

        ALV_POP2     ''
                     V_PAYAMOUNT
                     ''
                     ''
                     ''
                     2.
        """"""""""""""""""""""""""""""""""""""""""""""""""""""" End Of NC
        CONTINUE.
      ENDIF.
    ENDLOOP.
    "04.10.2022
*    IF LV_MSG NE 'X' .
    LOOP AT IT_PAID_AMT.
      CLEAR : IT_ZAXISMAP_TCI.
      READ TABLE IT_ZAXISLOG WITH KEY BUKRS = IT_PAID_AMT-BUKRS BELNR = IT_PAID_AMT-BELNR
                                      GJAHR = IT_PAID_AMT-GJAHR.
      IF SY-SUBRC = 0.
        IT_PAID_AMT-ALREADY_EX = 'X'.
        LV_ALREADY_EX = 'X'.
        CLEAR LV_MESSAGE.
        DELETE IT_TCIEG WHERE BUKRS = IT_PAID_AMT-BUKRS AND
                             BELNR = IT_PAID_AMT-BELNR AND
                             GJAHR = IT_PAID_AMT-GJAHR.

        CONCATENATE 'already extracted to' IT_ZAXISLOG-FILENAME
                    'on' IT_ZAXISLOG-DATUM
                    'at' IT_ZAXISLOG-UZEIT
               INTO LV_MESSAGE SEPARATED BY SPACE.
        ALV_POP1     C_ERROR
                     LV_MESSAGE
                     IT_TCIEG-BELNR
                     IT_TCIEG-GJAHR
                     LV_NAME
                     LV_VEND_CUST.

        ALV_POP2     ''
                     V_PAYAMOUNT
                     ''
                     ''
                     ''
                     2.

        CONTINUE.
      ENDIF.

*04.10.2022-restrict bank entries

*04.10.2022
      "start of en001
      READ TABLE IT_ZAXISLOG_TCI WITH KEY
      PAYDOCNO = IT_PAID_AMT-BELNR.

      IF SY-SUBRC = 0.
        IT_PAID_AMT-ALREADY_EX = 'X'.
        LV_ALREADY_EX = 'X'.
        CLEAR LV_MESSAGE.
        DELETE IT_TCIEG WHERE BUKRS = IT_PAID_AMT-BUKRS AND
                             BELNR = IT_PAID_AMT-BELNR AND
                             GJAHR = IT_PAID_AMT-GJAHR.

        CONCATENATE 'already extracted to' IT_ZAXISLOG_TCI-FILENAME
                    'on' IT_ZAXISLOG_TCI-DATUM
                    'at' IT_ZAXISLOG_TCI-UZEIT
                    'using automatic payment method'
               INTO LV_MESSAGE SEPARATED BY SPACE.
        ALV_POP1     C_ERROR
                     LV_MESSAGE
                     IT_PAID_AMT-BELNR
                     IT_PAID_AMT-GJAHR
                     LV_NAME
                     LV_VEND_CUST.

        ALV_POP2     ''
                     V_PAYAMOUNT
                     ''
                     ''
                     ''
                     2.

        CONTINUE.
      ENDIF.

    ENDLOOP.
*   ENDIF.
    DELETE IT_PAID_AMT WHERE DELETEFLAG = 'X' OR
                        ALREADY_EX = 'X'.

    IF IT_PAID_AMT[] IS NOT INITIAL.
      SORT IT_PAID_AMT BY BUKRS BELNR GJAHR.

      SELECT BUKRS HBKID BANKL FROM T012
      INTO TABLE IT_T012
      FOR ALL ENTRIES IN IT_PAID_AMT
      WHERE BUKRS = IT_PAID_AMT-BUKRS AND
            HBKID = IT_PAID_AMT-HOUSEBANK.
    ENDIF.

    SORT IT_TCIEG BY BUKRS BELNR GJAHR BUZEI.
    DELETE ADJACENT DUPLICATES FROM IT_TCIEG COMPARING BELNR.

    IF IT_TCIEG[] IS INITIAL.
      V_NOENTRIES = 'X'.
    ELSE.

***chk for the entrieds in BSE_CLR   "rj02
      REFRESH IT_CLR_TEMP.
      CLEAR IT_CLR_TEMP.

      SELECT BUKRS_CLR BELNR_CLR GJAHR_CLR SHKZG DMBTR DIFHW
                    APPENDING TABLE IT_CLR_TEMP
                    FROM BSE_CLR
                    FOR ALL ENTRIES IN IT_TCIEG
                    WHERE BUKRS_CLR = IT_TCIEG-BUKRS
                          AND BELNR_CLR = IT_TCIEG-BELNR
                          AND GJAHR_CLR = IT_TCIEG-GJAHR.
***rj02 - end

*     Fetch closed line items related to payment document
      REFRESH : IT_CLOSEDLINES.
      CLEAR : IT_CLOSEDLINES.
      SELECT BUKRS BELNR GJAHR AUGBL AUGGJ AUGDT  BUZEI CPUDT FROM BSAK    "rj01, added augdt buzei to query
      APPENDING TABLE IT_CLOSEDLINES
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE BUKRS = IT_TCIEG-BUKRS AND
            AUGBL = IT_TCIEG-BELNR AND
            AUGGJ = IT_TCIEG-GJAHR AND
            LIFNR = IT_TCIEG-LIFNR.

      SELECT BUKRS BELNR GJAHR AUGBL AUGGJ AUGDT BUZEI FROM BSAD    "rj01, added augdt buzei to query
      APPENDING TABLE IT_CLOSEDLINES
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE BUKRS = IT_TCIEG-BUKRS AND
            AUGBL = IT_TCIEG-BELNR AND
            AUGGJ = IT_TCIEG-GJAHR AND
            KUNNR = IT_TCIEG-KUNNR.

      LOOP AT IT_TCIEG.
        DELETE IT_CLOSEDLINES WHERE BUKRS = IT_TCIEG-BUKRS AND
                                    BELNR = IT_TCIEG-BELNR AND
                                    GJAHR = IT_TCIEG-GJAHR.
      ENDLOOP.

*     Fetch open line items related to payment document
      REFRESH : IT_OPENLINES.
      CLEAR : IT_OPENLINES.
      SELECT BUKRS BELNR GJAHR REBZG REBZJ REBZZ DMBTR FROM BSIK
      APPENDING TABLE IT_OPENLINES
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE BUKRS = IT_TCIEG-BUKRS AND
            BELNR = IT_TCIEG-BELNR AND
            GJAHR = IT_TCIEG-GJAHR AND
            LIFNR = IT_TCIEG-LIFNR.

***rj01 - start, partial with advance payment
      REFRESH : IT_PAD.
      CLEAR : IT_PAD.
      IT_PAD[] = IT_OPENLINES[].
***rj01 - end, partial with advance payment

      SELECT BUKRS BELNR GJAHR REBZG REBZJ REBZZ DMBTR FROM BSID
      APPENDING TABLE IT_OPENLINES
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE BUKRS = IT_TCIEG-BUKRS AND
            BELNR = IT_TCIEG-BELNR AND
            GJAHR = IT_TCIEG-GJAHR AND
            KUNNR = IT_TCIEG-KUNNR.

      DELETE IT_OPENLINES WHERE REBZG IS INITIAL.


      LOOP AT IT_OPENLINES.
        DELETE IT_CLOSEDLINES WHERE BUKRS = IT_OPENLINES-BUKRS AND
                                    BELNR = IT_OPENLINES-REBZG AND
                                    GJAHR = IT_OPENLINES-REBZZ.
      ENDLOOP.

*     Fetch BSEG details for all open and closed line items
      REFRESH : IT_TCIEG_INV_DOC.
      CLEAR : IT_TCIEG_INV_DOC.

      IF IT_CLOSEDLINES[] IS NOT INITIAL.
        SELECT BUKRS BELNR GJAHR BUZEI LIFNR KUNNR
               VALUT BSCHL UMSKZ SHKZG DMBTR PSWSL
               GSBER SKFBT QSSHB QSSKZ HBKID ZLSCH HKONT AUGBL AUGDT  "rj01  "added augbl and augdt in query
        FROM BSEG APPENDING TABLE IT_TCIEG_INV_DOC
        FOR ALL ENTRIES IN IT_CLOSEDLINES
        WHERE BUKRS = IT_CLOSEDLINES-BUKRS AND
              GJAHR = IT_CLOSEDLINES-GJAHR AND
              BELNR = IT_CLOSEDLINES-BELNR AND
              AUGBL = IT_CLOSEDLINES-AUGBL AND   "rj01,  augbl NE '' AND
              AUGDT = IT_CLOSEDLINES-AUGDT.      "rj01,  added augdt to query
*              umskz EQ ''.                      "rj01,  commented
      ENDIF.

      IF IT_OPENLINES[] IS NOT INITIAL.
        SELECT BUKRS BELNR GJAHR BUZEI LIFNR KUNNR
               VALUT BSCHL UMSKZ SHKZG DMBTR PSWSL
               GSBER SKFBT QSSHB QSSKZ HBKID ZLSCH HKONT
        FROM BSEG APPENDING TABLE IT_TCIEG_INV_DOC
        FOR ALL ENTRIES IN IT_OPENLINES
        WHERE BUKRS = IT_OPENLINES-BUKRS AND
              GJAHR = IT_OPENLINES-REBZJ AND
              BELNR = IT_OPENLINES-REBZG AND
              BUZEI = IT_OPENLINES-REBZZ.
      ENDIF.

      SORT IT_TCIEG_INV_DOC BY BUKRS BELNR GJAHR BUZEI AUGBL AUGDT. "rj01
*      DELETE ADJACENT DUPLICATES FROM it_TCIeg_inv_doc COMPARING belnr. "rj01, commented

*     Fetch invoice header details
      IF IT_TCIEG_INV_DOC[] IS NOT INITIAL.
        SELECT BUKRS BELNR GJAHR BLDAT BUDAT XBLNR STBLG FROM BKPF
        INTO TABLE IT_BKPF_INV_DOC
        FOR ALL ENTRIES IN IT_TCIEG_INV_DOC
        WHERE BUKRS = IT_TCIEG_INV_DOC-BUKRS AND
              BELNR = IT_TCIEG_INV_DOC-BELNR AND
              GJAHR = IT_TCIEG_INV_DOC-GJAHR.
      ENDIF.

*     Fetch cheque details generated for payment document
      REFRESH : IT_PAYR.
      CLEAR : IT_PAYR.

      SELECT ZBUKR HBKID HKTID CHECT VBLNR GJAHR LIFNR KUNNR
      FROM PAYR INTO TABLE IT_PAYR
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE ZBUKR = IT_TCIEG-BUKRS   AND
            HBKID = S_HBKID         AND
            HKTID = S_HKTID         AND
            ( LIFNR = IT_TCIEG-LIFNR OR
            KUNNR = IT_TCIEG-KUNNR ) AND
            VBLNR = IT_TCIEG-BELNR   AND
            GJAHR = IT_TCIEG-GJAHR.

*     Fetch one-time vendor payment details
      REFRESH : IT_TCIEC.
      CLEAR : IT_TCIEC.

      SELECT BUKRS BELNR GJAHR BUZEI ANRED NAME1
             NAME2 NAME3 NAME4 ORT01 PSTLZ ADRNR
      FROM BSEC INTO TABLE IT_TCIEC
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE BELNR = IT_TCIEG-BELNR AND
            GJAHR = IT_TCIEG-GJAHR AND
            BUKRS = IT_TCIEG-BUKRS.
      IF SY-SUBRC = 0.
        SORT IT_TCIEC BY BUKRS BELNR GJAHR BUZEI.
      ENDIF.

*     Fetch Vendor details
      REFRESH : IT_LFA1, IT_ALT_VEN, IT_KNA1, IT_ADRC, IT_ADR6,
                IT_LFBK, IT_KNBK, IT_BNKA.
      CLEAR: IT_LFA1, IT_ALT_VEN, IT_KNA1, IT_ADRC, IT_ADR6,
             IT_LFBK, IT_KNBK, IT_BNKA.

      SELECT LIFNR NAME1 NAME2 ADRNR LNRZA SORTL
             STRAS MCOD3 PSTLZ LAND1 ORT01
             ORT02
      FROM LFA1 INTO TABLE IT_LFA1
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE LIFNR = IT_TCIEG-LIFNR.

      IF SY-SUBRC = 0.
        LOOP AT IT_LFA1 WHERE LNRZA IS NOT INITIAL.
          CLEAR : IT_ALT_VEN.
          IT_ALT_VEN-LNRZA = IT_LFA1-LNRZA.
          APPEND IT_ALT_VEN.
        ENDLOOP.

        IF IT_ALT_VEN[] IS NOT INITIAL.
          SELECT LIFNR NAME1 NAME2 ADRNR LNRZA SORTL
                 STRAS MCOD3 PSTLZ LAND1 ORT01
                 ORT02
          FROM LFA1 APPENDING TABLE IT_LFA1
          FOR ALL ENTRIES IN IT_ALT_VEN
          WHERE LIFNR = IT_ALT_VEN-LNRZA.
        ENDIF.
      ENDIF.

      IF IT_LFA1[] IS NOT INITIAL.
        SELECT ADDRNUMBER STREET HOUSE_NUM1 STR_SUPPL1 STR_SUPPL2
             STR_SUPPL3 CITY1 POST_CODE1 LOCATION REGION TEL_NUMBER
        APPENDING TABLE IT_ADRC FROM ADRC
        FOR ALL ENTRIES IN IT_LFA1
        WHERE ADDRNUMBER = IT_LFA1-ADRNR.

        SELECT ADDRNUMBER SMTP_ADDR
        APPENDING TABLE IT_ADR6 FROM ADR6
        FOR ALL ENTRIES IN IT_LFA1
        WHERE ADDRNUMBER = IT_LFA1-ADRNR.

        SELECT LIFNR BANKS BANKL BANKN
             BKREF BVTYP KOINH
        INTO TABLE IT_LFBK FROM LFBK
        FOR ALL ENTRIES IN IT_LFA1
        WHERE LIFNR = IT_LFA1-LIFNR."en001 01-10-2018
*        AND   bvtyp = it_TCIeg-bvtyp. "en001 01-10-2018                                                    "gp001
        IF IT_LFBK[] IS NOT INITIAL.
          SELECT BANKS BANKL BANKA SWIFT BNKLZ BRNCH
          APPENDING TABLE IT_BNKA FROM BNKA
          FOR ALL ENTRIES IN IT_LFBK
          WHERE BANKS = IT_LFBK-BANKS AND
                BANKL = IT_LFBK-BANKL.
        ENDIF.



        SELECT LIFNR BUKRS ZAHLS TLFXS FROM LFB1
        INTO TABLE IT_LFB1
        FOR ALL ENTRIES IN IT_LFA1
        WHERE LIFNR = IT_LFA1-LIFNR AND
              BUKRS = S_BUKRS.
      ENDIF.
*      RESTRICT OTHER BANK ENTRIES.
**      IF IT_LFBK-BKREF IS NOT INITIAL.
**         axisheader1-IFSC_CODE+0(4) = 'AXIS'.
**          IF SY-SUBRC = 0.
**           MESSAGE 'AXIS Document number' TYPE 'I' DISPLAY LIKE 'S'.
**          ELSE.
**            MESSAGE 'Please enter AXIS Document number' TYPE 'E' DISPLAY LIKE 'E'.
**          ENDIF.
**          ENDIF.

*     Fetch Customer details
      SELECT KUNNR NAME1 NAME2 ADRNR SORTL
             STRAS MCOD3 PSTLZ LAND1
             ORT01 TELF1 TELFX REGIO
      FROM KNA1 INTO TABLE IT_KNA1
      FOR ALL ENTRIES IN IT_TCIEG
      WHERE KUNNR = IT_TCIEG-KUNNR.
      IF IT_KNA1[] IS NOT INITIAL.
        SELECT ADDRNUMBER STREET HOUSE_NUM1 STR_SUPPL1 STR_SUPPL2
             STR_SUPPL3 CITY1 POST_CODE1 LOCATION REGION TEL_NUMBER
        APPENDING TABLE IT_ADRC FROM ADRC
        FOR ALL ENTRIES IN IT_KNA1
        WHERE ADDRNUMBER = IT_KNA1-ADRNR.

        SELECT ADDRNUMBER SMTP_ADDR
        APPENDING TABLE IT_ADR6 FROM ADR6
        FOR ALL ENTRIES IN IT_KNA1
        WHERE ADDRNUMBER = IT_KNA1-ADRNR.

        SELECT KUNNR BANKS BANKL BANKN
             BKREF BVTYP KOINH
        INTO TABLE IT_KNBK FROM KNBK
        FOR ALL ENTRIES IN IT_KNA1
        WHERE KUNNR = IT_KNA1-KUNNR.
*        AND   BVTYP = IT_TCIEG-BVTYP.
        IF IT_KNBK[] IS NOT INITIAL.
          SELECT BANKS BANKL BANKA SWIFT BNKLZ BRNCH
          APPENDING TABLE IT_BNKA FROM BNKA
          FOR ALL ENTRIES IN IT_KNBK
          WHERE BANKS = IT_KNBK-BANKS AND
                BANKL = IT_KNBK-BANKL.
        ENDIF.

        SELECT KUNNR BUKRS ZAHLS FROM KNB1
        INTO TABLE IT_KNB1
        FOR ALL ENTRIES IN IT_KNA1
        WHERE KUNNR = IT_KNA1-KUNNR AND
              BUKRS = S_BUKRS.
      ENDIF.
    ENDIF.

*   Fetching TDS details
    REFRESH : IT_WITHITEM.
    CLEAR : IT_WITHITEM.
    SELECT BUKRS BELNR GJAHR BUZEI WT_QBSHH FROM WITH_ITEM
    APPENDING TABLE IT_WITHITEM
    FOR ALL ENTRIES IN IT_BKPF
    WHERE BUKRS = IT_BKPF-BUKRS AND
          BELNR = IT_BKPF-BELNR AND
          GJAHR = IT_BKPF-GJAHR AND
          WT_QBSHH NE 0.

    IF IT_TCIEG_INV_DOC[] IS NOT INITIAL.
      SELECT BUKRS BELNR GJAHR BUZEI WT_QBSHH FROM WITH_ITEM
      APPENDING TABLE IT_WITHITEM
      FOR ALL ENTRIES IN IT_TCIEG_INV_DOC
      WHERE BUKRS = IT_TCIEG_INV_DOC-BUKRS AND
            BELNR = IT_TCIEG_INV_DOC-BELNR AND
            GJAHR = IT_TCIEG_INV_DOC-GJAHR AND
            BUZEI = IT_TCIEG_INV_DOC-BUZEI AND
            WT_QBSHH NE 0.
    ENDIF.
  ENDIF.

**fetching data for the house bank and account id
  CLEAR: LV_HBK,
         LV_HB_AC.

  SELECT SINGLE ZBANK_VALUE
*   FROM ZAXISMAP_TCI
   FROM ZAXISMAP_TCI
   INTO LV_HBK
   WHERE ZFIELD_REF = 'HBAC'
     AND ZSAP_VALUE = S_HBKID.

  SELECT SINGLE ZBANK_VALUE
*  FROM ZAXISMAP_TCI
  FROM ZAXISMAP_TCI
  INTO LV_HB_AC
  WHERE ZFIELD_REF = 'HBID'
    AND ZSAP_VALUE = S_HKTID.


ENDFORM.                    "fetch_details

*&---------------------------------------------------------------------*
*&      Form  payment_details_construct
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM PAYMENT_DETAILS_CONSTRUCT.
  SET COUNTRY 'IN'.
  IF IT_TCIEG[] IS NOT INITIAL.
    IT_TCIEG_TEMP[] = IT_TCIEG[].
    REFRESH : IT_TCIEG.
    V_TCIEG_LINES = 1.
    WHILE V_TCIEG_LINES > 0.
      CLEAR : V_NUMDOC, V_NUMINV.
      CLEAR: WA_SPLIT, SPLIT_COUNT, SPLIT_AMOUNT.           "MJ001
      LOOP AT IT_TCIEG_TEMP.
        CLEAR : V_TCIEG_LINES.
        V_NUMINV = V_NUMINV + IT_TCIEG_TEMP-BUZEI.
        V_NUMDOC = V_NUMDOC + 1.
        IF V_NUMINV > 1100.
          V_NUMDOC = V_NUMDOC - 1.
          EXIT.
        ENDIF.
      ENDLOOP.

      REFRESH : ZITAB1, IT_ERROR, H1, IT_TCIEG.
      CLEAR : IT_TCIEG, ZITAB1, IT_ERROR, H1.

***rj03 - start
      REFRESH : ZITAB1_TEMP, ITAB1_TEMP, H1_TEMP.
      CLEAR : ZITAB1_TEMP, ITAB1_TEMP, H1_TEMP.
***rj03 - end


      IF V_NUMDOC = 0.
        EXIT.
      ENDIF.

      APPEND LINES OF IT_TCIEG_TEMP FROM 1 TO V_NUMDOC TO IT_TCIEG.
      DELETE IT_TCIEG_TEMP FROM 1 TO V_NUMDOC.


      SELECT * " CUSTUNIQREF,BELNR,GJAHR,BUKRS,REQUESTUUID,STATUS,RESPONCE
       FROM ZAXIS_RES_API
         FOR ALL ENTRIES IN @IT_TCIEG
           WHERE  BELNR = @IT_TCIEG-BELNR
            AND   GJAHR = @IT_TCIEG-GJAHR
             AND   BUKRS = @S_BUKRS
*              AND STATUS = 'S'
               INTO TABLE @DATA(IT_RES_API).



     SELECT * from lfbk
       INTO TABLE @DATA(it_lfbk_nr)
        FOR ALL ENTRIES IN @IT_TCIEG
          where LIFNR = @IT_TCIEG-LIFNR .

      LOOP AT IT_TCIEG.
        CLEAR : IT_PAYR, AXISHEADER1, AXISHEADER2, H1, IT_ZAXISLOG ,WA_RAPI.

        CLEAR : IT_BKPF, IT_LFA1, IT_KNA1, IT_ADRC,
                IT_ADR6, IT_TCIEC, V_LIFNR,LV_VEND_CUST,LV_NAME,LV_ADDRESS,
                V_INVOICES,LV_PM,LV_MESSAGE,V_PAYAMOUNT.
        CLEAR : AXISHEADER1, AXISHEADER2, H1.
        CLEAR IT_PAD.                                       "rj01

***rj03 - start
        REFRESH : ZITAB1_TEMP, ITAB1_TEMP, H1_TEMP.
        CLEAR : ZITAB1_TEMP, ITAB1_TEMP, H1_TEMP.
***rj03 - end
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        READ TABLE it_lfbk_nr INTO DATA(wa_lfbk_nr) WITH key LIFNR = IT_TCIEG-LIFNR .
        if wa_lfbk_nr-KOINH is INITIAL .

          CLEAR : LV_MESSAGE.

          CONCATENATE 'Beneficary'  IT_TCIEG-LIFNR
                      'Name is blank'
                      INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     ''
                       V_PAYAMOUNT
                       ''
                       ''
                       ''
                       3.
          LV_ERROR  = 'X' .

          CONTINUE.
          ENDIF.
          CLEAR:  wa_lfbk_nr .

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""




        READ TABLE IT_BKPF WITH KEY BUKRS = IT_TCIEG-BUKRS
                                    BELNR = IT_TCIEG-BELNR BINARY SEARCH.

        IF IT_BKPF-VMUL IS NOT INITIAL.

          CLEAR : LV_MESSAGE.

          CONCATENATE 'Vendor' IT_LFA1-LIFNR
                      'blocked for multiple payment'
                      INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     ''
                       V_PAYAMOUNT
                       ''
                       ''
                       ''
                       3.
          LV_ERROR  = 'X' .
          CONTINUE.
        ENDIF.


        IF IT_TCIEG-LIFNR IS NOT INITIAL.
          LV_VEND_CUST = IT_TCIEG-LIFNR.
        ELSEIF IT_TCIEG-KUNNR IS NOT INITIAL AND LV_CUSTOMER_ACTIVE EQ C_X.
          LV_VEND_CUST = IT_TCIEG-KUNNR.
        ENDIF.

* Read vendor details
        IF IT_TCIEG-LIFNR IS NOT INITIAL.
          READ TABLE IT_LFA1 WITH KEY LIFNR = IT_TCIEG-LIFNR.
          IF SY-SUBRC = 0.
*           Check for Alternate payee
            V_LIFNR = IT_TCIEG-LIFNR.
            IF IT_LFA1-LNRZA IS NOT INITIAL AND LV_ALTPAY_ACTIVE EQ 'X'.
              V_LIFNR = IT_LFA1-LNRZA.
              CLEAR : IT_LFA1.
              READ TABLE IT_LFA1 WITH KEY LIFNR = V_LIFNR.
            ENDIF.

            READ TABLE IT_LFB1 WITH KEY LIFNR = IT_LFA1-LIFNR.
            IF SY-SUBRC = 0.
*           Validation on vendor block for payment
              IF IT_LFB1-ZAHLS IS NOT INITIAL.
                CLEAR : LV_MESSAGE.

                CONCATENATE 'Vendor' IT_LFA1-LIFNR
                            'blocked for payment'
                            INTO LV_MESSAGE SEPARATED BY SPACE.

                ALV_POP1     C_ERROR
                             LV_MESSAGE
                             IT_TCIEG-BELNR
                             IT_TCIEG-GJAHR
                             LV_NAME
                             LV_VEND_CUST.

                ALV_POP2     ''
                             V_PAYAMOUNT
                             ''
                             ''
                             ''
                             3.
                LV_ERROR  = 'X' .
                CONTINUE.
              ENDIF.
            ENDIF.


            READ TABLE IT_ADRC WITH KEY ADDRNUMBER = IT_LFA1-ADRNR.
            READ TABLE IT_ADR6 WITH KEY ADDRNUMBER = IT_LFA1-ADRNR.


          ENDIF.
        ENDIF.

        """""""""""""""""""""""""""""""""""""  Added By NC """"""""""""""""""""""""""""""""""""""""""""""""""
        READ TABLE IT_RES_API INTO WA_RAPI WITH KEY  BELNR = IT_TCIEG-BELNR
                                                   GJAHR = IT_TCIEG-GJAHR .
        IF WA_RAPI-STATUS = 'S'.
          CLEAR : LV_MESSAGE.

          CONCATENATE 'Document'  IT_TCIEG-BELNR
                      'already posted'
                      INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     ''
                        V_PAYAMOUNT
                       ''
                       ''
                       ''
                       '' . "3.
          LV_ERROR  = 'X' .
          CONTINUE.
        ENDIF.
        """""""""""""""""""""""""""""""""""""  END By NC """"""""""""""""""""""""""""""""""""""""""""""""""

* Read customer details
        IF IT_TCIEG-KUNNR IS NOT INITIAL AND LV_CUSTOMER_ACTIVE EQ C_X.
          READ TABLE IT_KNA1 WITH KEY KUNNR = IT_TCIEG-KUNNR.
          IF SY-SUBRC = 0.
            READ TABLE IT_KNB1 WITH KEY KUNNR = IT_KNA1-KUNNR.
            IF SY-SUBRC = 0.
*           Validation on customer block for payment
              IF IT_KNB1-ZAHLS IS NOT INITIAL.
                CLEAR : LV_MESSAGE.

                CONCATENATE 'Customer' IT_KNA1-KUNNR
                            'blocked for payment'
                            INTO LV_MESSAGE SEPARATED BY SPACE.
                ALV_POP1     C_ERROR
                             LV_MESSAGE
                             IT_TCIEG-BELNR
                             IT_TCIEG-GJAHR
                             LV_NAME
                             LV_VEND_CUST.

                ALV_POP2     ''
                             V_PAYAMOUNT
                             ''
                             ''
                             ''
                             4.
                LV_ERROR  = 'X' .
                CONTINUE.
              ENDIF.
            ENDIF.

            READ TABLE IT_ADRC WITH KEY ADDRNUMBER = IT_KNA1-ADRNR.
            READ TABLE IT_ADR6 WITH KEY ADDRNUMBER = IT_KNA1-ADRNR.

          ENDIF.
        ENDIF.


* One-time vendor
        IF LV_OTV_ACTIVE EQ 'X'.
          CLEAR : V_ONETIMEVENDOR.
          READ TABLE IT_TCIEC WITH KEY BUKRS = IT_TCIEG-BUKRS
                                      BELNR = IT_TCIEG-BELNR
                                      GJAHR = IT_TCIEG-GJAHR
                                      BINARY SEARCH.
          IF SY-SUBRC = 0.
            V_ONETIMEVENDOR = 'X'.
          ENDIF.
        ENDIF.


**vendor/customer name populate
        IF V_ONETIMEVENDOR = 'X'.
          CONCATENATE IT_TCIEC-NAME1 IT_TCIEC-NAME2
                 INTO LV_NAME SEPARATED BY SPACE.

        ELSEIF NOT IT_TCIEG-KUNNR IS INITIAL AND LV_CUSTOMER_ACTIVE EQ C_X.
          CONCATENATE IT_KNA1-NAME1 IT_KNA1-NAME2
               INTO LV_NAME SEPARATED BY SPACE.

        ELSE.
          CONCATENATE IT_LFA1-NAME1 IT_LFA1-NAME2
               INTO LV_NAME SEPARATED BY SPACE.
        ENDIF.

*        PERFORM validate_character_set USING lv_name.

* Read payment document header details
        READ TABLE IT_BKPF WITH KEY BUKRS = IT_TCIEG-BUKRS
                                    BELNR = IT_TCIEG-BELNR
                                    GJAHR = IT_TCIEG-GJAHR
                                    BINARY SEARCH.

        IF SY-SUBRC = 0.
*       Validation on document reversal
          IF IT_BKPF-STBLG IS NOT INITIAL.
            CLEAR : LV_MESSAGE.
            MOVE 'Document reversed' TO LV_MESSAGE.


            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     ''
                         V_PAYAMOUNT
                         ''
                         ''
                         ''
                         5.
            LV_ERROR  = 'X' .
            CONTINUE.
          ENDIF.
        ENDIF.

***rj01 - start
        DATA V_PARTIAL_ADV TYPE C.
        CLEAR  V_PARTIAL_ADV.
        READ TABLE IT_PAD WITH KEY BELNR = IT_TCIEG-BELNR GJAHR = IT_TCIEG-GJAHR.
        IF  SY-SUBRC = 0.
          IF IT_PAD-REBZG IS  NOT INITIAL.  "partial payment with adjustment of advance amount
            V_PARTIAL_ADV = 'X'.
            SELECT BUKRS_CLR BELNR_CLR GJAHR_CLR INDEX_CLR BELNR BUKRS GJAHR SHKZG DMBTR DIFHW
              FROM BSE_CLR
              INTO TABLE IT_CLR
              WHERE BUKRS_CLR = IT_TCIEG-BUKRS
                    AND BELNR_CLR = IT_TCIEG-BELNR
                    AND GJAHR_CLR = IT_TCIEG-GJAHR.
          ENDIF.
        ENDIF.
***rj01 - end

******1 Payment Document start Indicator
        AXISHEADER1-PAY_DOC_IND_START = '~'.    "Header1 Start indicator

******2 Program Run Date
        CLEAR X_BKPF.
        READ TABLE IT_BKPF INTO X_BKPF WITH KEY BUKRS = IT_TCIEG-BUKRS
                                                BELNR = IT_TCIEG-BELNR
                                                GJAHR = IT_TCIEG-GJAHR.
        CONCATENATE X_BKPF-BLDAT+0(4)
                    X_BKPF-BLDAT+4(2)
                    X_BKPF-BLDAT+6(2)
               INTO AXISHEADER1-PROGRAM_RUN_DATE
                    SEPARATED BY '-'.

        IF AXISHEADER1-PROGRAM_RUN_DATE  IS INITIAL.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Program run date is blank'
                      P_PM INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       7.
          LV_ERROR  = 'X' .
          CONTINUE.
        ENDIF.

******3 Payment Run Identifier
        AXISHEADER1-RUN_IDENTIFIER = C_MANIND.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-RUN_IDENTIFIER 'Run identifider' C_SET1 CHANGING V_ERR_FLG.
        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.

          CONTINUE.
        ENDIF.

******4 Paying company code
        AXISHEADER1-PAY_CO_CODE = IT_TCIEG-BUKRS.

        IF AXISHEADER1-PAY_CO_CODE  IS INITIAL.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Paying company code is blank'
                      P_PM INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       7.
          LV_ERROR  = 'X' .
          CONTINUE.

        ELSE.
          CLEAR V_ERR_FLG.
          PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-PAY_CO_CODE 'Paying Company Code' C_SET1 CHANGING V_ERR_FLG.

          IF V_ERR_FLG EQ 'X'.
            CLEAR LV_MESSAGE.
            CONTINUE.
          ENDIF.
        ENDIF.

******5 Payment Document Number
        AXISHEADER1-PAY_DOC_NO = IT_TCIEG-BELNR.

        IF AXISHEADER1-PAY_DOC_NO  IS INITIAL.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Payment document number is blank'
                      P_PM INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       7.
          LV_ERROR  = 'X' .
          CONTINUE.
        ELSE.
          CLEAR V_ERR_FLG.
          PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-PAY_DOC_NO 'Payment Document Number' C_SET1 CHANGING V_ERR_FLG.
          IF V_ERR_FLG EQ 'X'.
            CLEAR LV_MESSAGE.
            CONTINUE.
          ENDIF.
        ENDIF.

******6 Payment Amount

        CLEAR : IT_PAID_AMT.

*        READ TABLE IT_lfa1 WITH KEY BUKRS = IT_TCIEG-BUKRS
        READ TABLE IT_PAID_AMT WITH KEY BUKRS = IT_TCIEG-BUKRS
                                        BELNR = IT_TCIEG-BELNR
                                        GJAHR = IT_TCIEG-GJAHR
                                        BINARY SEARCH.
        IF SY-SUBRC = 0.
          WRITE IT_PAID_AMT-DMBTR TO AXISHEADER1-PAY_AMOUNT  """"""""""" cmt by nc
                DECIMALS 2 NO-GROUPING.
          SHIFT AXISHEADER1-PAY_AMOUNT LEFT DELETING LEADING SPACE. """ add by NC
        ENDIF.
*         added on 12.09.2022
**          WRITE IT_TCIEG-DMBTR TO axisheader1-PAY_AMOUNT
**                DECIMALS 2 NO-GROUPING.
**          SHIFT axisheader1-PAY_AMOUNT LEFT DELETING LEADING SPACE.
*      ended on 12.09.2022
        IF AXISHEADER1-PAY_AMOUNT IS INITIAL.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Payment Amount is 0(ZERO)'
                      P_PM INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       7.
          LV_ERROR  = 'X' .
          CONTINUE.
        ENDIF.


******7 Payment Currency
        AXISHEADER1-CURRENCY = IT_TCIEG-PSWSL.

        IF AXISHEADER1-CURRENCY IS INITIAL.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Payment currency is blank'
                      P_PM INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       7.
          LV_ERROR  = 'X' .
          CONTINUE.
        ELSE.
          CLEAR V_ERR_FLG.
          PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-CURRENCY 'Payment Currency' C_SET2 CHANGING V_ERR_FLG.

          IF V_ERR_FLG EQ 'X'.
            CLEAR LV_MESSAGE.
            CONTINUE.
          ENDIF.
        ENDIF.


******8 Payment Method
*********************************mv
        CLEAR : IT_ZAXISMAP_TCI.
        READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_PAYMETHOD
                                        ZSAP_VALUE = P_PM.
        IF SY-SUBRC = 0.
          AXISHEADER1-PMT_METHOD = IT_ZAXISMAP_TCI-ZBANK_VALUE.

          CLEAR V_ERR_FLG.
          PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-PMT_METHOD  'Payment Method' C_SET2 CHANGING V_ERR_FLG.

          IF V_ERR_FLG EQ 'X'.
            CLEAR LV_MESSAGE.
            CONTINUE.
          ENDIF.
        ELSE.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Maintain Payment Method(PM) in table ZAXISMAP_TCI for'
                      P_PM INTO LV_MESSAGE SEPARATED BY SPACE.

          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       7.
          LV_ERROR  = 'X' .
          CONTINUE.
        ENDIF.
**************************************mv************************
*       Validation on Amount for RTGS payments
*        CLEAR : v_payamount.

        DATA V_LEN TYPE I.
        CLEAR V_LEN.
        V_LEN = STRLEN( AXISHEADER1-PAY_AMOUNT ).
        V_LEN = V_LEN - 3.
        IF AXISHEADER1-PAY_AMOUNT+V_LEN(1) EQ ','.
          AXISHEADER1-PAY_AMOUNT+V_LEN(1) = '.'.
        ENDIF.


        V_PAYAMOUNT = AXISHEADER1-PAY_AMOUNT.

        READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_MINRTGS.

        IF  1 = 2 .
          IF SY-SUBRC = 0 AND IT_ZAXISMAP_TCI-ZSAP_VALUE IS NOT INITIAL  .
*            DATA V_LEN TYPE I.
            CLEAR V_LEN.
            """"""""" cmt by nc """"""""""""
            V_LEN = STRLEN( AXISHEADER1-PAY_AMOUNT ).
            V_LEN = V_LEN - 3.
            IF AXISHEADER1-PAY_AMOUNT+V_LEN(1) EQ ','.
              AXISHEADER1-PAY_AMOUNT+V_LEN(1) = '.'.
            ENDIF.
            """""""""" end of nc """"""""""""""
            V_PAYAMOUNT = AXISHEADER1-PAY_AMOUNT.

            IF AXISHEADER1-PMT_METHOD EQ C_RTGS.
              IF V_PAYAMOUNT LE IT_ZAXISMAP_TCI-ZSAP_VALUE.
                AXISHEADER1-PMT_METHOD = C_NEFT.
              ENDIF.
            ENDIF.
          ELSE.
            CLEAR: LV_MESSAGE.
            CONCATENATE 'Maintain Minimum RTGS Limit in table ZAXISMAP_TCI'
                        ' ' INTO LV_MESSAGE SEPARATED BY SPACE.
            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     V_INVOICES
                         V_PAYAMOUNT
                         LV_PM
                         AXISHEADER1-PRINTING_LOC
                         AXISHEADER1-DD_PAY_LOC
                         8.
            LV_ERROR  = 'X' .
            CONTINUE.
          ENDIF.
        ENDIF.

******9 Vendor Code
        IF IT_TCIEG-KUNNR IS INITIAL.
          AXISHEADER1-VENDOR_CODE = IT_TCIEG-LIFNR.
        ELSEIF LV_CUSTOMER_ACTIVE EQ C_X.
          AXISHEADER1-VENDOR_CODE = IT_TCIEG-KUNNR.
        ENDIF.
        SHIFT AXISHEADER1-VENDOR_CODE LEFT DELETING LEADING C_ZERO.

        IF AXISHEADER1-VENDOR_CODE IS INITIAL.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Vendor code is blank'
                      ' ' INTO LV_MESSAGE SEPARATED BY SPACE.
          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       8.
          LV_ERROR  = 'X' .
          CONTINUE.

        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-VENDOR_CODE 'Vendor Code' C_SET3 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

*****10 Vendor Title

        IF V_ONETIMEVENDOR = 'X'.
          AXISHEADER1-VENDOR_TITLE = IT_TCIEC-ANRED.
        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-VENDOR_TITLE 'Vendor Title' C_SET3 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

*****11 Vendor Name1, Name2

        IF AXISHEADER1-PMT_METHOD EQ C_NEFT OR
           AXISHEADER1-PMT_METHOD EQ C_RTGS.

          AXISHEADER1-VENDOR_NAME1 = LV_NAME(35).
          AXISHEADER1-VENDOR_NAME2 = LV_NAME+35(70).
        ELSE.
          AXISHEADER1-VENDOR_NAME1 = LV_NAME(70).
          AXISHEADER1-VENDOR_NAME2 = LV_NAME+70(70).
        ENDIF.

        IF AXISHEADER1-PMT_METHOD = C_DD OR AXISHEADER1-PMT_METHOD = C_CHEQUE.
          IF AXISHEADER1-VENDOR_NAME1 IS NOT INITIAL.

            CLEAR V_ERR_FLG.
            PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-VENDOR_NAME1 'Vendor Name1' C_SET8 CHANGING V_ERR_FLG.

            IF V_ERR_FLG EQ 'X'.
              CLEAR LV_MESSAGE.
              CONTINUE.
            ENDIF.

          ELSE.
            CLEAR LV_MESSAGE.
            CONCATENATE 'Maintain the Name of Payee ' '' INTO LV_MESSAGE SEPARATED BY SPACE.
            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     V_INVOICES
                         V_PAYAMOUNT
                         LV_PM
                         AXISHEADER1-PRINTING_LOC
                         AXISHEADER1-DD_PAY_LOC
                         8.
            LV_ERROR  = 'X' .
            CONTINUE.
          ENDIF.
        ELSE.
          PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISHEADER1-VENDOR_NAME1 C_SET1.

        ENDIF.
**rj01
        IF AXISHEADER1-PMT_METHOD = C_DD OR AXISHEADER1-PMT_METHOD = C_CHEQUE.
          CLEAR V_ERR_FLG.

          PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-VENDOR_NAME2 'Vendor Name2' C_SET8 CHANGING V_ERR_FLG.
          IF V_ERR_FLG EQ 'X'.
            CLEAR LV_MESSAGE.
            CONTINUE.
          ENDIF.

        ELSE.
          PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISHEADER1-VENDOR_NAME2 C_SET1.
        ENDIF.

**** 13 to 18 (vendor address)
** One time vendor
        IF V_ONETIMEVENDOR = 'X'.

          SELECT SINGLE * FROM ADRC INTO LV_ADDRESS WHERE ADDRNUMBER = IT_TCIEC-ADRNR.
** Customer
        ELSEIF IT_TCIEG-KUNNR IS NOT INITIAL AND LV_CUSTOMER_ACTIVE EQ C_X.

          SELECT SINGLE * FROM ADRC INTO LV_ADDRESS WHERE ADDRNUMBER = IT_KNA1-ADRNR.
          AXISHEADER1-CUST_REF_NO = IT_KNA1-SORTL. " added by surabhi 06.06.2023
        ELSEIF IT_LFA1 IS NOT INITIAL.

          SELECT SINGLE * FROM ADRC INTO LV_ADDRESS WHERE ADDRNUMBER = IT_LFA1-ADRNR.
          AXISHEADER1-CUST_REF_NO = IT_LFA1-SORTL.
*          axisheader1-INSR_REF_NO = IT_LFB1-TLFXS.
          AXISHEADER1-INSR_REF_NO = ''.  "
        ENDIF.
*******************************commented on 24.03.2023
*        axisheader1-VENDOR_ADDR1 = LV_ADDRESS-STREET.
*        axisheader1-VENDOR_ADDR2 = LV_ADDRESS-STR_SUPPL1.
*        axisheader1-VENDOR_ADDR3 = LV_ADDRESS-STR_SUPPL2.
*        axisheader1-VENDOR_ADDR4 = LV_ADDRESS-STR_SUPPL3.
*        axisheader1-VENDOR_ADDR5 = LV_ADDRESS-CITY1.
*        axisheader1-VENDOR_ADDR6 = LV_ADDRESS-POST_CODE1.
*******************************************************


*****19 Vendor House Bank (AXIS)
        AXISHEADER1-HOUSE_BANK = LV_HBK.
        IF 1 = 2 .
          IF AXISHEADER1-HOUSE_BANK IS INITIAL .
            CLEAR: LV_MESSAGE.
            CONCATENATE 'House bank is blank'
                          ' ' INTO LV_MESSAGE SEPARATED BY SPACE.
            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     V_INVOICES
                         V_PAYAMOUNT
                         LV_PM
                         AXISHEADER1-PRINTING_LOC
                         AXISHEADER1-DD_PAY_LOC
                         8.
            LV_ERROR  = 'X' .
            CONTINUE.
          ENDIF.
        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-HOUSE_BANK 'House Bank' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

*****20 Vendor A/C id of the House Bank (A/C Number)
        AXISHEADER1-HOUSEBANK_ACID = LV_HB_AC.
        IF  1 = 2 .
          IF AXISHEADER1-HOUSEBANK_ACID IS INITIAL .
            CLEAR: LV_MESSAGE.
            CONCATENATE 'Account id is blank'
                          ' ' INTO LV_MESSAGE SEPARATED BY SPACE.
            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     V_INVOICES
                         V_PAYAMOUNT
                         LV_PM
                         AXISHEADER1-PRINTING_LOC
                         AXISHEADER1-DD_PAY_LOC
                         8.
            LV_ERROR  = 'X' .
            CONTINUE.
          ENDIF.
        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-HOUSEBANK_ACID 'Account ID' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

*****21 Value Date
*        IF IT_TCIEG-VALUT < SY-DATUM.
        IT_TCIEG-VALUT = SY-DATUM.
*        ENDIF.
        CONCATENATE IT_TCIEG-VALUT+0(4)
                    IT_TCIEG-VALUT+4(2)
                    IT_TCIEG-VALUT+6(2)
               INTO AXISHEADER1-VALUE_DATE
                    SEPARATED BY '-'.
*                    SEPARATED BY '/'.

*        IF axisheader1-VALUE_DATE IS INITIAL.
*          CLEAR: LV_MESSAGE.
*          CONCATENATE 'Value date is blank'
*                        ' ' INTO LV_MESSAGE SEPARATED BY SPACE.
*          ALV_POP1     C_ERROR
*                       LV_MESSAGE
*                       IT_TCIEG-BELNR
*                       IT_TCIEG-GJAHR
*                       LV_NAME
*                       LV_VEND_CUST.
*
*          ALV_POP2     V_INVOICES
*                       V_PAYAMOUNT
*                       LV_PM
*                       axisheader1-PRINTING_LOC
*                       axisheader1-DD_PAY_LOC
*                       8.
*          CONTINUE.
*        ENDIF.

*****22 Instruction date
        CONCATENATE SY-DATUM+0(4)
                    SY-DATUM+4(2)
                    SY-DATUM+6(2)
               INTO AXISHEADER1-INSTRUCTION_DATE
                    SEPARATED BY '-'.

        IF AXISHEADER1-INSTRUCTION_DATE IS INITIAL.
          CLEAR: LV_MESSAGE.
          CONCATENATE 'Instruction date is blank'
                        ' ' INTO LV_MESSAGE SEPARATED BY SPACE.
          ALV_POP1     C_ERROR
                       LV_MESSAGE
                       IT_TCIEG-BELNR
                       IT_TCIEG-GJAHR
                       LV_NAME
                       LV_VEND_CUST.

          ALV_POP2     V_INVOICES
                       V_PAYAMOUNT
                       LV_PM
                       AXISHEADER1-PRINTING_LOC
                       AXISHEADER1-DD_PAY_LOC
                       8.
          LV_ERROR  = 'X' .
          CONTINUE.
        ENDIF.

*****23 Mode of delivery of the cheque/DD

        IF AXISHEADER1-PMT_METHOD = C_CHEQUE OR
           AXISHEADER1-PMT_METHOD = C_DD.
          AXISHEADER1-MODE_OF_DELIVERY = 'B'.
        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-MODE_OF_DELIVERY 'Mode Of Delivery' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

*****24 Cheque No

        IF AXISHEADER1-PMT_METHOD = C_CHEQUE.
          CLEAR IT_PAYR.
          READ TABLE IT_PAYR WITH KEY ZBUKR = IT_TCIEG-BUKRS
                                      VBLNR = IT_TCIEG-BELNR
                                      GJAHR = IT_TCIEG-GJAHR
                                      HBKID = S_HBKID
                                      HKTID = S_HKTID
                                      LIFNR = IT_TCIEG-LIFNR
                                      KUNNR = IT_TCIEG-KUNNR.
          IF SY-SUBRC = 0.
            AXISHEADER1-CHEQUE_NO = IT_PAYR-CHECT.
            CLEAR V_ERR_FLG.
            PERFORM VALIDATE_CHARACTER_SET_NEW USING  AXISHEADER1-CHEQUE_NO 'Cheque number' C_SET4 CHANGING V_ERR_FLG.

            IF V_ERR_FLG EQ 'X'.
              CLEAR LV_MESSAGE.
              CONTINUE.
            ENDIF.
          ELSE.
            CLEAR : LV_MESSAGE.

            CONCATENATE 'Cheque Number Blank'
                        '' INTO LV_MESSAGE
                        SEPARATED BY SPACE.
            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     V_INVOICES
                         V_PAYAMOUNT
                         LV_PM
                         AXISHEADER1-PRINTING_LOC
                         AXISHEADER1-DD_PAY_LOC
                         9.
            LV_ERROR  = 'X' .
            CONTINUE.
          ENDIF.
        ENDIF.
********************cheq date
        READ TABLE IT_CLOSEDLINES WITH KEY BUKRS = IT_TCIEG-BUKRS
                                              AUGBL = IT_TCIEG-BELNR
                                              AUGGJ = IT_TCIEG-GJAHR.
        CONCATENATE IT_CLOSEDLINES-CPUDT+0(4)
                    IT_CLOSEDLINES-CPUDT+4(2)
                    IT_CLOSEDLINES-CPUDT+6(2)
               INTO AXISHEADER1-CHEQUE_DATE
                    SEPARATED BY '-'.

*        IF axisheader1-CHEQUE_DATE IS INITIAL.
*          CLEAR: LV_MESSAGE.
*          CONCATENATE 'Value date is blank'
*                        ' ' INTO LV_MESSAGE SEPARATED BY SPACE.
*          ALV_POP1     C_ERROR
*                       LV_MESSAGE
*                       IT_TCIEG-BELNR
*                       IT_TCIEG-GJAHR
*                       LV_NAME
*                       LV_VEND_CUST.
*
*          ALV_POP2     V_INVOICES
*                       V_PAYAMOUNT
*                       LV_PM
*                       axisheader1-PRINTING_LOC
*                       axisheader1-DD_PAY_LOC
*                       8.
*          CONTINUE.
*        ENDIF.
*****25 DD Payable Location
        IF AXISHEADER1-PMT_METHOD = C_DD.
          CLEAR : IT_ZAXISMAP_TCI.
          IF LV_DDLOC_DD EQ 'X'.
            CLEAR : IT_ZAXISMAP_TCI.
            TRANSLATE P_PAYLOC TO UPPER CASE.
            READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_BRANCH
                                               ZSAP_VALUE = P_PAYLOC.
            IF SY-SUBRC = 0.
              AXISHEADER1-DD_PAY_LOC = IT_ZAXISMAP_TCI-ZBANK_VALUE.
            ENDIF. "from drop-down list
          ELSE.
            TRANSLATE IT_ADRC-CITY1 TO UPPER CASE.
            READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_BRANCH
                                            ZSAP_VALUE = IT_ADRC-CITY1.
            IF SY-SUBRC = 0.
              AXISHEADER1-DD_PAY_LOC = IT_ZAXISMAP_TCI-ZBANK_VALUE.
            ELSE.
              CLEAR : LV_MESSAGE.

              CONCATENATE 'Maintain DD Paylocation in '
                          'ZAXISMAP_TCI for City : '
                          IT_ADRC-CITY1 INTO LV_MESSAGE
                          SEPARATED BY SPACE.
              ALV_POP1     C_ERROR
                           LV_MESSAGE
                           IT_TCIEG-BELNR
                           IT_TCIEG-GJAHR
                           LV_NAME
                           LV_VEND_CUST.

              ALV_POP2     V_INVOICES
                           V_PAYAMOUNT
                           LV_PM
                           AXISHEADER1-PRINTING_LOC
                           AXISHEADER1-DD_PAY_LOC
                           10.
              LV_ERROR  = 'X' .
              CONTINUE.
            ENDIF.
          ENDIF.
        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-DD_PAY_LOC 'DD Paylocation' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

*****26 Printing location
        IF AXISHEADER1-PMT_METHOD = C_CHEQUE OR
           AXISHEADER1-PMT_METHOD = C_DD.
          CLEAR : IT_ZAXISMAP_TCI.
          IF LV_PRINTLOC_DD EQ 'X'.
            CLEAR : IT_ZAXISMAP_TCI.
            TRANSLATE P_PRTLOC TO UPPER CASE.
            READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_PRINT
                                               ZSAP_VALUE = P_PRTLOC.
            IF SY-SUBRC = 0.
              AXISHEADER1-PRINTING_LOC = IT_ZAXISMAP_TCI-ZBANK_VALUE.
            ENDIF. "from drop-down list
          ELSEIF LV_CITYMAP_PRINTLOC_ACTIVE EQ C_X.
            TRANSLATE IT_ADRC-CITY1 TO UPPER CASE.
            READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_PRINT
                                            ZSAP_VALUE = IT_ADRC-CITY1.
            IF SY-SUBRC = 0.
              AXISHEADER1-PRINTING_LOC = IT_ZAXISMAP_TCI-ZBANK_VALUE.
            ELSEIF LV_DEF_PLOC_ACTIVE EQ C_X.
              AXISHEADER1-PRINTING_LOC = LV_DEF_PLOC.
            ELSE.
              CLEAR : LV_MESSAGE.

              CONCATENATE 'Maintain printing location in '
                          'ZAXISMAP_TCI for City : '
                          IT_ADRC-CITY1 INTO LV_MESSAGE
                          SEPARATED BY SPACE.
              ALV_POP1     C_ERROR
                           LV_MESSAGE
                           IT_TCIEG-BELNR
                           IT_TCIEG-GJAHR
                           LV_NAME
                           LV_VEND_CUST.

              ALV_POP2     V_INVOICES
                           V_PAYAMOUNT
                           LV_PM
                           AXISHEADER1-PRINTING_LOC
                           AXISHEADER1-DD_PAY_LOC
                           11.
              LV_ERROR  = 'X' .
              CONTINUE.
            ENDIF.
          ELSEIF LV_CENTRALIZED_PL_ACT EQ C_X.
            AXISHEADER1-PRINTING_LOC = LV_CPRINT_LOC.
          ENDIF.
        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-PRINTING_LOC  'Print Location' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

*******27 to 30 Bank details

        IF AXISHEADER1-PMT_METHOD = C_RTGS OR
           AXISHEADER1-PMT_METHOD = C_NEFT OR
           AXISHEADER1-PMT_METHOD = C_ACC.

          IF IT_TCIEG-KUNNR IS NOT INITIAL AND LV_CUSTOMER_ACTIVE EQ C_X.
            IF IT_TCIEG-BVTYP IS NOT INITIAL.
              CLEAR : IT_KNBK, IT_BNKA.
              READ TABLE IT_KNBK WITH KEY KUNNR = IT_TCIEG-KUNNR
                                          BANKS = 'IN'
                                          BVTYP = IT_TCIEG-BVTYP.
              IF SY-SUBRC = 0.
                READ TABLE IT_BNKA WITH KEY BANKS = IT_KNBK-BANKS
                                            BANKL = IT_KNBK-BANKL.
              ENDIF.
            ELSE.
              CLEAR : IT_KNBK, IT_BNKA.
              READ TABLE IT_KNBK WITH KEY KUNNR = IT_TCIEG-KUNNR
                                          BANKS = 'IN'.
              IF SY-SUBRC = 0.
                READ TABLE IT_BNKA WITH KEY BANKS = IT_KNBK-BANKS
                                            BANKL = IT_KNBK-BANKL.
              ENDIF.
            ENDIF.

*****27 beneficiary account number
*            axisheader1-bene_acc_no = it_knbk-bankn.
            "start of en001 to increase bank account number length
            IF IT_KNBK-BKREF IS NOT INITIAL.
              CONCATENATE IT_KNBK-BANKN IT_KNBK-BKREF
                      INTO LV_ACCOUNT_NUM." SEPARATED BY space.
              AXISHEADER1-BENE_ACC_NO = LV_ACCOUNT_NUM.
            ELSE.
              "end of en001 to increase bank account number length
              AXISHEADER1-BENE_ACC_NO = IT_KNBK-BANKN.
            ENDIF.

*****28 IFSC code
*            axisheader1-ifsc_code = it_knbk-bkref."en001 25-09-2018
            AXISHEADER1-IFSC_CODE = IT_KNBK-BANKL."en001 25-09-2018
*********************************************
*            IF axisheader1-IFSC_CODE+0(6) = 'AXIS0C'."axisheader1-ifsc_code CP 'AXIS0C*'.
*              axisheader1-PMT_METHOD = 'N'.
*            ELSEIF axisheader1-IFSC_CODE+0(4) = 'AXIS'." CP 'AXIS*'.
*              axisheader1-PMT_METHOD = 'I'.
*            ENDIF.
**************************            commented as per Narayan
*            IF  axisheader1-PMT_METHOD = 'I'.       "Comm by MJ002 as per Bank Confirmation
*              IF STRLEN( axisheader1-BENE_ACC_NO ) <> 14.
*                CONCATENATE 'Invalid bank account length for' IT_TCIEG-BELNR
*                INTO LV_MESSAGE SEPARATED BY SPACE.
*                ALV_POP1     C_ERROR
*                             LV_MESSAGE
*                             IT_TCIEG-BELNR
*                             IT_TCIEG-GJAHR
*                             LV_NAME
*                             LV_VEND_CUST.
*
*                ALV_POP2     ''
*                             V_PAYAMOUNT
*                             ''
*                             ''
*                             ''
*                             2
*                             .
*                CONTINUE.
*              ENDIF.
*            ENDIF.

*****29 beneficiary bank name.
            AXISHEADER1-BENE_BNK_NAME = IT_BNKA-BANKA.  "" added by NC
*            axisheader1-BENE_BNK_BRNCH = IT_BNKA-BRNCH.  "" added by NC

*****30 beneficiary account type
            AXISHEADER1-BENE_ACC_TYP = ''.
          ELSE.

            IF IT_TCIEG-BVTYP IS NOT INITIAL.
              CLEAR : IT_LFBK, IT_BNKA.
              READ TABLE IT_LFBK WITH KEY LIFNR = IT_LFA1-LIFNR
                                          BANKS = 'IN'
                                          BVTYP = IT_TCIEG-BVTYP.

              IF SY-SUBRC = 0.
                READ TABLE IT_BNKA WITH KEY BANKS = IT_LFBK-BANKS
                                            BANKL = IT_LFBK-BANKL.
                AXISHEADER1-BENE_BNK_NAME = IT_BNKA-BANKA.
              ENDIF.
            ELSE.
              CLEAR : IT_LFBK, IT_BNKA.
              READ TABLE IT_LFBK WITH KEY LIFNR = IT_LFA1-LIFNR
                                          BANKS = 'IN'.
              IF SY-SUBRC = 0.
                READ TABLE IT_BNKA WITH KEY BANKS = IT_LFBK-BANKS
                                            BANKL = IT_LFBK-BANKL.
                AXISHEADER1-BENE_BNK_NAME = IT_BNKA-BANKA.
              ENDIF.
            ENDIF.
*****27 beneficiary account number
*            axisheader1-bene_acc_no = it_lfbk-bankn.
            "start of en001 to increase bank account number length
            IF IT_LFBK-BKREF IS NOT INITIAL.
              CONCATENATE IT_LFBK-BANKN IT_LFBK-BKREF
                      INTO LV_ACCOUNT_NUM."SEPARATED BY space.
              AXISHEADER1-BENE_ACC_NO = LV_ACCOUNT_NUM.
            ELSE.
              "end of en001 to increase bank account number length
              AXISHEADER1-BENE_ACC_NO = IT_LFBK-BANKN.
            ENDIF.

*****28 IFSC code
*            axisheader1-ifsc_code = it_lfbk-bkref."en001 25-09-2018
            AXISHEADER1-IFSC_CODE = IT_LFBK-BANKL."en001 25-09-2018
**************************************************************************

*            IF axisheader1-IFSC_CODE+0(6) = 'AXIS0C'."axisheader1-ifsc_code CP 'AXIS0C*'.
*              axisheader1-PMT_METHOD = 'N'.
*            ELSEIF axisheader1-IFSC_CODE+0(4) = 'AXIS'." CP 'AXIS*'.
*              axisheader1-PMT_METHOD = 'I'.
***              ELSE.
***             MESSAGE 'Please enter AXIS Document number' TYPE 'I' DISPLAY LIKE 'E'.
*            ENDIF.
*******************************************as per narayan req commented
*            IF  axisheader1-PMT_METHOD = 'I'.     "Comm by MJ002 as per Bank confirmation
*              IF STRLEN( axisheader1-BENE_ACC_NO ) <> 14.
*                CONCATENATE 'Invalid bank account length for' IT_TCIEG-BELNR
*                INTO LV_MESSAGE SEPARATED BY SPACE.
*                ALV_POP1     C_ERROR
*                             LV_MESSAGE
*                             IT_TCIEG-BELNR
*                             IT_TCIEG-GJAHR
*                             LV_NAME
*                             LV_VEND_CUST.
*
*                ALV_POP2     ''
*                             V_PAYAMOUNT
*                             ''
*                             ''
*                             ''
*                             2
*                             .
*                CONTINUE.
*              ENDIF.
*            ENDIF.

*****29 beneficiary bank name.
*            axisheader1-BENE_BNK_NAME = IT_BNKA-BANKA.
*            axisheader1-BENE_BNK_BRNCH = IT_BNKA-BRNCH.

*****30 beneficiary account type
            AXISHEADER1-BENE_ACC_TYP = ''.
          ENDIF.


*         Validation on IFSC code
          IF AXISHEADER1-IFSC_CODE IS INITIAL.
            CLEAR : LV_MESSAGE.

            CONCATENATE
                  'Suitable IFSC code missing for Beneficiary :'
                  AXISHEADER1-VENDOR_CODE INTO LV_MESSAGE
                  SEPARATED BY SPACE.
            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     V_INVOICES
                         V_PAYAMOUNT
                         LV_PM
                         AXISHEADER1-PRINTING_LOC
                         AXISHEADER1-DD_PAY_LOC
                         12.
            CONTINUE.
          ENDIF.

*         Validation on bank account number
          IF AXISHEADER1-BENE_ACC_NO IS INITIAL.
            CLEAR : LV_MESSAGE.
            CONCATENATE
                  'Suitable bank account number missing for Beneficiary :'
                  AXISHEADER1-VENDOR_CODE INTO LV_MESSAGE
                  SEPARATED BY SPACE.
            ALV_POP1     C_ERROR
                         LV_MESSAGE
                         IT_TCIEG-BELNR
                         IT_TCIEG-GJAHR
                         LV_NAME
                         LV_VEND_CUST.

            ALV_POP2     V_INVOICES
                         V_PAYAMOUNT
                         LV_PM
                         AXISHEADER1-PRINTING_LOC
                         AXISHEADER1-DD_PAY_LOC
                         13.
            CONTINUE.
          ENDIF.

**         Checking IFSC code for AXIS account holders
*          IF axisheader1-ifsc_code IS NOT INITIAL AND
*           ( axisheader1-pmt_method = c_rtgs OR
*             axisheader1-pmt_method = c_neft ).
*            IF axisheader1-ifsc_code+0(3) = c_hdf.
*              axisheader1-pmt_method = c_acc.
*            ENDIF.
*          ENDIF.

        ELSE.
*****27 beneficiary account number
          AXISHEADER1-BENE_ACC_NO = ''.
*****28 IFSC code
          AXISHEADER1-IFSC_CODE = ''.
*****29 beneficiary bank name.
          AXISHEADER1-BENE_BNK_NAME = ''.
          AXISHEADER1-BENE_BNK_BRNCH = ''.
*****30 beneficiary account type
          AXISHEADER1-BENE_ACC_TYP = ''.
        ENDIF.

        CASE AXISHEADER1-PMT_METHOD.
          WHEN 'C'.
            LV_PM = C_PM_CHK.
          WHEN 'D'.
            LV_PM = C_PM_DD.
          WHEN 'R'.
            LV_PM = C_PM_RTGS.
          WHEN 'N'.
            LV_PM = C_PM_NEFT.
          WHEN 'I'.
            LV_PM = C_PM_IFT.
        ENDCASE.
        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-BENE_ACC_NO  'Beneficiary Account Number' C_SET9 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-IFSC_CODE  'IFSC Code' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

        CLEAR V_ERR_FLG.

*        PERFORM VALIDATE_CHARACTER_SET_NEW USING axisheader1-BENE_BNK_NAME  'Beneficiary Bank Name' C_SET10 CHANGING V_ERR_FLG. "An002
*
*        IF V_ERR_FLG EQ 'X'.
*          CLEAR LV_MESSAGE.
*          CONTINUE.
*        ENDIF.   """""""""""""""" cmt by NC

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER1-BENE_ACC_TYP  'Beneficiary Account Type' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.
*****31 beneficiary Email id.
*        axisheader1-BENE_EMAIL = IT_ADR6-SMTP_ADDR.
        DATA : W_SMTP_ADDR LIKE ADR6-SMTP_ADDR.
        CLEAR W_SMTP_ADDR.
        SELECT  ADDRNUMBER SMTP_ADDR FLGDEFAULT INTO TABLE IT_ADR6
                 FROM ADR6
                WHERE ADDRNUMBER = IT_LFA1-ADRNR.
        IF SY-SUBRC = 0.
          SORT IT_ADR6 BY FLGDEFAULT DESCENDING.
*          loop at it_adr6.
*            if axisheader1-bene_email is not initial.
*              concatenate  axisheader1-bene_email ',' it_adr6-smtp_addr into axisheader1-bene_email.
*            else.
*              move it_adr6-smtp_addr to axisheader1-bene_email.
*            endif.
*          endloop.

          "start of changes for flint group
*          MOVE C_FG_EMAIL TO axisheader1-BENE_EMAIL.
          LOOP AT IT_ADR6.
            IF AXISHEADER1-BENE_EMAIL IS NOT INITIAL.
              CONCATENATE  AXISHEADER1-BENE_EMAIL ',' IT_ADR6-SMTP_ADDR INTO AXISHEADER1-BENE_EMAIL.
*              concatenate 'ap.india@flintgrp.com' ',' axisheader1-bene_email ',' it_adr6-smtp_addr into axisheader1-bene_email.
            ELSE.
              MOVE IT_ADR6-SMTP_ADDR TO AXISHEADER1-BENE_EMAIL.
            ENDIF.
          ENDLOOP.
          "end of changes for flint group

          DATA : MAIL_LENGTH  TYPE I,
                 MAIL_LENGTH1 TYPE I,
                 TOTAL_LENGTH TYPE I.
          DATA : I TYPE I.
          MAIL_LENGTH = STRLEN( AXISHEADER1-BENE_EMAIL ).
          IF MAIL_LENGTH GT 99.
            I = 99.
          ELSE.
            I = 0.
          ENDIF.
          WHILE I NE 0.
            IF AXISHEADER1-BENE_EMAIL+I(1) = ','.
              AXISHEADER1-BENE_EMAIL = AXISHEADER1-BENE_EMAIL+0(I).
              I = 0.
            ELSE.
              I = I - 1.
            ENDIF.
          ENDWHILE.
        ENDIF.

*        IF axisheader1-BENE_EMAIL IS INITIAL.
*          axisheader1-BENE_EMAIL = C_EMAIL.
*        ENDIF.

        CONDENSE AXISHEADER1-BENE_EMAIL NO-GAPS.

        MOVE-CORRESPONDING AXISHEADER1 TO H1_TEMP.
        APPEND H1_TEMP.

*        PERFORM API_SEND .

*=====================HEADER1====(END)=======================

*------------------------------------------------------------
* Routine to put payment header & Invoice details
*------------------------------------------------------------

******1 Payment Header-2 Start Indicator

        ZITAB1_TEMP-FLD_STR = '~'.
        APPEND ZITAB1_TEMP.

        ZITAB1_TEMP-FLD_STR = '  '.
        APPEND ZITAB1_TEMP.

        ZITAB1_TEMP-FLD_STR = '~H'.
        APPEND ZITAB1_TEMP.

******2 Payment Header-2 Paying company code
        AXISHEADER2-COMPANY_CODE = IT_TCIEG-BUKRS.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER2-COMPANY_CODE 'Paying Company Code' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

        ZITAB1_TEMP-FLD_STR = AXISHEADER2-COMPANY_CODE.
        APPEND ZITAB1_TEMP.

******3 Payment Header-2 Payment Document No
        AXISHEADER2-PAY_DOC_NO = IT_TCIEG-BELNR.

        CLEAR V_ERR_FLG.
        PERFORM VALIDATE_CHARACTER_SET_NEW USING AXISHEADER2-PAY_DOC_NO 'Payment Document Number' C_SET1 CHANGING V_ERR_FLG.

        IF V_ERR_FLG EQ 'X'.
          CLEAR LV_MESSAGE.
          CONTINUE.
        ENDIF.

        ZITAB1_TEMP-FLD_STR = AXISHEADER2-PAY_DOC_NO.
        APPEND ZITAB1_TEMP.

******4 Payment Header-2 Payment Document Date
        CONCATENATE SY-DATUM+0(4)
                    SY-DATUM+4(2)
                    SY-DATUM+6(2)
               INTO AXISHEADER2-DOC_DATE
                    SEPARATED BY '-'.
        ZITAB1_TEMP-FLD_STR = AXISHEADER2-DOC_DATE.
        APPEND ZITAB1_TEMP.

        MOVE AXISHEADER2 TO ITAB1_TEMP.
        APPEND ITAB1_TEMP.
        CLEAR ITAB1_TEMP.

*------------------------------------------------------------
* Invoice detail
*------------------------------------------------------------

        CLEAR:   AXISDETAIL.

        REFRESH : IT_INVOICES.
        CLEAR : IT_INVOICES.

        READ TABLE IT_CLOSEDLINES WITH KEY BUKRS = IT_TCIEG-BUKRS
                                           AUGBL = IT_TCIEG-BELNR
                                           AUGGJ = IT_TCIEG-GJAHR.
        IF SY-SUBRC = 0.
          LOOP AT IT_CLOSEDLINES WHERE BUKRS = IT_TCIEG-BUKRS AND
                                       AUGBL = IT_TCIEG-BELNR AND
                                       AUGGJ = IT_TCIEG-GJAHR.
            READ TABLE IT_TCIEG_INV_DOC WITH KEY BUKRS = IT_CLOSEDLINES-BUKRS
                                                BELNR = IT_CLOSEDLINES-BELNR
                                                GJAHR = IT_CLOSEDLINES-GJAHR
                                                AUGBL = IT_CLOSEDLINES-AUGBL "rj01
                                                AUGDT = IT_CLOSEDLINES-AUGDT "rj01
                                                BUZEI = IT_CLOSEDLINES-BUZEI. "rj01
            IF SY-SUBRC = 0.
              MOVE IT_TCIEG_INV_DOC TO IT_INVOICES.
              APPEND IT_INVOICES.
            ENDIF.
*            ELSE.
*              EXIT.
*            ENDIF.
          ENDLOOP.
        ENDIF.

        READ TABLE IT_OPENLINES WITH KEY BUKRS = IT_TCIEG-BUKRS
                                         BELNR = IT_TCIEG-BELNR
                                         GJAHR = IT_TCIEG-GJAHR.
        IF SY-SUBRC = 0.
          LOOP AT IT_OPENLINES WHERE BUKRS = IT_TCIEG-BUKRS AND
                                     BELNR = IT_TCIEG-BELNR AND
                                     GJAHR = IT_TCIEG-GJAHR.
            READ TABLE IT_TCIEG_INV_DOC WITH KEY BUKRS = IT_OPENLINES-BUKRS
                                                BELNR = IT_OPENLINES-REBZG
                                                GJAHR = IT_OPENLINES-REBZJ.
            IF SY-SUBRC = 0.
              MOVE IT_TCIEG_INV_DOC TO IT_INVOICES.
              APPEND IT_INVOICES.
            ENDIF.
*            ELSE.
*              EXIT.
*            ENDIF.
          ENDLOOP.
        ENDIF.

        DATA : V_NET_TOTAL LIKE BSEG-DMBTR.

        CLEAR : V_NET_TOTAL.

**** logic for the on account payment " rj02

        READ TABLE IT_CLR_TEMP WITH KEY BUKRS_CLR = IT_TCIEG-BUKRS
                                        BELNR_CLR = IT_TCIEG-BELNR
                                        GJAHR_CLR = IT_TCIEG-GJAHR.

        IF SY-SUBRC NE 0.
****** Advise document indicator
          AXISDETAIL-ADV_START_IND = '~D'.
          ZITAB1_TEMP-FLD_STR = '~D'.
          APPEND ZITAB1_TEMP.

******1 Invoice Document Reference Number

          IF IT_BKPF-XBLNR <> ''.
            REPLACE ALL OCCURRENCES OF ':' IN IT_BKPF-XBLNR  WITH ' '.
            CONCATENATE 'Invoice Number:' IT_BKPF-XBLNR INTO
                         AXISDETAIL-TITLE1.
            PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE1 C_SET5.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
            APPEND ZITAB1_TEMP.
          ELSE.
            CONCATENATE 'Invoice Number:' '' INTO
                         AXISDETAIL-TITLE1.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
            APPEND ZITAB1_TEMP.
          ENDIF.


******2 SAP Invoice Number

          IF IT_TCIEG-BELNR IS NOT INITIAL.
            REPLACE ALL OCCURRENCES OF ':' IN IT_TCIEG-BELNR  WITH ' '.
            CONCATENATE 'Document Number:' IT_TCIEG-BELNR INTO
                         AXISDETAIL-TITLE2.

            PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE2 C_SET5.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
            APPEND ZITAB1_TEMP.
          ELSE.
            CONCATENATE 'Document Number:' '' INTO
                         AXISDETAIL-TITLE2.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
            APPEND ZITAB1_TEMP.
          ENDIF.

******3 Invoice Date

          CONCATENATE IT_BKPF-BLDAT+0(4)
                      IT_BKPF-BLDAT+4(2)
                      IT_BKPF-BLDAT+6(2)
                      INTO AXISDETAIL-TITLE3
                      SEPARATED BY '-'.
          IF NOT AXISDETAIL-TITLE3 IS INITIAL.
            REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE3 WITH ' '.
            CONCATENATE 'Document date:' AXISDETAIL-TITLE3
                         INTO AXISDETAIL-TITLE3.
          ELSE.
            CONCATENATE 'Document date:' '' INTO
                         AXISDETAIL-TITLE3.
          ENDIF.
          PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE3 C_SET5.
          ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE3.
          APPEND ZITAB1_TEMP.

******4 Posting Date

          CONCATENATE IT_BKPF-BUDAT+0(4)
                      IT_BKPF-BUDAT+4(2)
                      IT_BKPF-BUDAT+6(2)
                      INTO AXISDETAIL-TITLE4
                      SEPARATED BY '-'.
          IF NOT AXISDETAIL-TITLE4 IS INITIAL.
            REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE4 WITH ' '.
            CONCATENATE 'Posting date:' AXISDETAIL-TITLE4
                         INTO AXISDETAIL-TITLE4.
          ELSE.
            CONCATENATE 'Posting date:' '' INTO
                         AXISDETAIL-TITLE4.
          ENDIF.
          PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE4 C_SET5.
          ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE4.
          APPEND ZITAB1_TEMP.

******5 Invoice Amount
          CLEAR: V_AMOUNT.
          IF NOT IT_TCIEG-DMBTR IS INITIAL.
            V_AMOUNT = IT_TCIEG-DMBTR.         "Invoice without TDS
          ELSEIF NOT IT_TCIEG-SKFBT IS INITIAL.
            V_AMOUNT = IT_TCIEG-SKFBT.         "TDS at Invoice Level
          ELSE.
            V_AMOUNT = IT_TCIEG-QSSHB.         "TDS at Payment Level
          ENDIF.

          V_INVOICES = V_INVOICES + 1.

          CLEAR : V_TDS, V_TTDS.
          LOOP AT IT_WITHITEM WHERE BUKRS = IT_TCIEG-BUKRS AND
                                    BELNR = IT_TCIEG-BELNR AND
                                    GJAHR = IT_TCIEG-GJAHR.
            V_TDS = V_TDS + IT_WITHITEM-WT_QBSHH.
          ENDLOOP.

          IF IT_TCIEG-SHKZG = C_H.
            V_AMOUNT = V_AMOUNT * -1.
          ENDIF.

          WRITE V_AMOUNT TO AXISDETAIL-TITLE5
                         DECIMALS 2 NO-GROUPING.
          SHIFT AXISDETAIL-TITLE5 LEFT DELETING LEADING SPACE.
          REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE5 WITH ''.
          CONCATENATE 'Invoice Amount:' AXISDETAIL-TITLE5 INTO
                      AXISDETAIL-TITLE5.
          REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE5 WITH '.'.
          PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE5 C_SET5.
          ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE5.
          APPEND ZITAB1_TEMP.

******6 TDS amount
          V_TTDS = V_TDS.
          IF V_TTDS IS NOT INITIAL.
            SHIFT V_TTDS LEFT DELETING LEADING SPACE.
            REPLACE ALL OCCURRENCES OF ':' IN V_TTDS WITH ''.
            CONCATENATE 'Deductions:' V_TTDS INTO
                        AXISDETAIL-TITLE6. " SEPARATED BY space.
          ELSE.
            CONCATENATE 'Deductions:' ''  INTO
                        AXISDETAIL-TITLE6. " SEPARATED BY space.
          ENDIF.
          REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE6 WITH '.'.
          PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE6 C_SET5.
          ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE6.
          APPEND ZITAB1_TEMP.

*******7 Paid Amount
          CLEAR : V_NET.
          V_NET = V_AMOUNT - V_TDS.
          V_NET_TOTAL = V_NET_TOTAL + V_NET.                "rj01
          WRITE V_NET TO AXISDETAIL-TITLE7 DECIMALS 2 NO-GROUPING.
          SHIFT AXISDETAIL-TITLE7 LEFT DELETING LEADING SPACE.
          REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE7 WITH ''.
          IF AXISDETAIL-TITLE7 <> ''.
            CONCATENATE 'Net Amount :' AXISDETAIL-TITLE7 INTO
                        AXISDETAIL-TITLE7.  " SEPARATED BY space.
            REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE7 WITH '.'.
            PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE7 C_SET5.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
            APPEND ZITAB1_TEMP.
          ELSE.
            CONCATENATE 'Net Amount :' '0.00' INTO
                        AXISDETAIL-TITLE7.  " SEPARATED BY space.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
            APPEND ZITAB1_TEMP.
          ENDIF.

          MOVE AXISDETAIL TO ITAB1_TEMP.
          CLEAR AXISDETAIL.
          APPEND ITAB1_TEMP.
          CLEAR ITAB1_TEMP.


        ELSE.  "it_clr_temp
* Advice part for Advance payments
          IF IT_TCIEG-UMSKZ IS NOT INITIAL AND IT_TCIEG-BSCHL = C_VENDADV AND IT_INVOICES[] IS INITIAL.    "rj01, commented = 'A'
            REFRESH : IT_INVOICES.

******1 Advise document indicator
            AXISDETAIL-ADV_START_IND = '~D'.
            ZITAB1_TEMP-FLD_STR = '~D'.
            APPEND ZITAB1_TEMP.

******2 Invoice Document Reference Number
            IF IT_BKPF-XBLNR <> ''.
              REPLACE ALL OCCURRENCES OF ':' IN IT_BKPF-XBLNR WITH ' '.
              CONCATENATE 'Invoice Number:' IT_BKPF-XBLNR INTO
                           AXISDETAIL-TITLE1.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE1 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
              APPEND ZITAB1_TEMP.
            ELSE.
              CONCATENATE 'Invoice Number:' '' INTO
                           AXISDETAIL-TITLE1.
*                           SEPARATED BY space.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
              APPEND ZITAB1_TEMP.
            ENDIF.


******4 SAP Invoice Number
            IF IT_TCIEG-BELNR IS NOT INITIAL.
              REPLACE ALL OCCURRENCES OF ':' IN IT_TCIEG-BELNR WITH ' '.
              CONCATENATE 'Document Number:' IT_TCIEG-BELNR INTO
                           AXISDETAIL-TITLE2.
*                           SEPARATED BY space.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE2 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
              APPEND ZITAB1_TEMP.
            ELSE.
              CONCATENATE 'Document Number:' '' INTO
                           AXISDETAIL-TITLE2.
*                           SEPARATED BY space.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
              APPEND ZITAB1_TEMP.
            ENDIF.

******3 Invoice Date
            CONCATENATE IT_BKPF-BLDAT+0(4)
                        IT_BKPF-BLDAT+4(2)
                        IT_BKPF-BLDAT+6(2)
                        INTO AXISDETAIL-TITLE3
                        SEPARATED BY '-'.
            IF NOT AXISDETAIL-TITLE3 IS INITIAL.
              REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE3 WITH ' '.
              CONCATENATE 'Document date:' AXISDETAIL-TITLE3
                           INTO AXISDETAIL-TITLE3.
*                           SEPARATED BY space.
            ELSE.
              CONCATENATE 'Document date:' '' INTO
                           AXISDETAIL-TITLE3.
*                           SEPARATED BY space.
            ENDIF.
            PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE3 C_SET5.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE3.
            APPEND ZITAB1_TEMP.


******4 Posting Date
            CONCATENATE IT_BKPF-BUDAT+0(4)
                        IT_BKPF-BUDAT+4(2)
                        IT_BKPF-BUDAT+6(2)
                        INTO AXISDETAIL-TITLE4
                        SEPARATED BY '-'.
            IF NOT AXISDETAIL-TITLE4 IS INITIAL.
              REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE4 WITH ' '.
              CONCATENATE 'Posting date:' AXISDETAIL-TITLE4
                           INTO AXISDETAIL-TITLE4.
*                           SEPARATED BY space.
            ELSE.
              CONCATENATE 'Posting date:' '' INTO
                           AXISDETAIL-TITLE4.
*                           SEPARATED BY space.
            ENDIF.
            PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE4 C_SET5.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE4.
            APPEND ZITAB1_TEMP.

******5 Invoice Amount
            CLEAR: V_AMOUNT.
            IF NOT IT_TCIEG-DMBTR IS INITIAL.
              V_AMOUNT = IT_TCIEG-DMBTR.         "Invoice without TDS
            ELSEIF NOT IT_TCIEG-SKFBT IS INITIAL.
              V_AMOUNT = IT_TCIEG-SKFBT.         "TDS at Invoice Level
            ELSE.
              V_AMOUNT = IT_TCIEG-QSSHB.         "TDS at Payment Level
            ENDIF.

            V_INVOICES = V_INVOICES + 1.

            CLEAR : V_TDS, V_TTDS.
            LOOP AT IT_WITHITEM WHERE BUKRS = IT_TCIEG-BUKRS AND
                                      BELNR = IT_TCIEG-BELNR AND
                                      GJAHR = IT_TCIEG-GJAHR.
              V_TDS = V_TDS + IT_WITHITEM-WT_QBSHH.
            ENDLOOP.

            IF IT_TCIEG-SHKZG = C_H.
              V_AMOUNT = V_AMOUNT * -1.
            ENDIF.

            WRITE V_AMOUNT TO AXISDETAIL-TITLE5
                           DECIMALS 2 NO-GROUPING.
            SHIFT AXISDETAIL-TITLE5 LEFT DELETING LEADING SPACE.
            REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE5 WITH ''.
            CONCATENATE 'Invoice Amount:' AXISDETAIL-TITLE5 INTO
                        AXISDETAIL-TITLE5.
            REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE5 WITH '.'.
            PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE5 C_SET5.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE5.
            APPEND ZITAB1_TEMP.

******6 TDS amount
            V_TTDS = V_TDS.
            IF V_TTDS IS NOT INITIAL.
              SHIFT V_TTDS LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ':' IN V_TTDS WITH ' '.
              CONCATENATE 'Deductions:' V_TTDS INTO
                          AXISDETAIL-TITLE6.  " SEPARATED BY space.
            ELSE.
              CONCATENATE 'Deductions:' ''  INTO
                          AXISDETAIL-TITLE6.  " SEPARATED BY space.
            ENDIF.
            REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE6 WITH '.'.
            PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE6 C_SET5.
            ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE6.
            APPEND ZITAB1_TEMP.

*******7 Paid Amount
            CLEAR : V_NET.
            V_NET = V_AMOUNT - V_TDS.
            V_NET_TOTAL = V_NET_TOTAL + V_NET.              "rj01
            WRITE V_NET TO AXISDETAIL-TITLE7 DECIMALS 2 NO-GROUPING.
            SHIFT AXISDETAIL-TITLE7 LEFT DELETING LEADING SPACE.
            REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE7 WITH ''.
            IF AXISDETAIL-TITLE7 <> ''.
              CONCATENATE 'Net Amount :' AXISDETAIL-TITLE7 INTO
                          AXISDETAIL-TITLE7.
              REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE7 WITH '.'.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE7 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
              APPEND ZITAB1_TEMP.
            ELSE.
              CONCATENATE 'Net Amount :' '0.00' INTO
                          AXISDETAIL-TITLE7.  " SEPARATED BY space.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
              APPEND ZITAB1_TEMP.
            ENDIF.

            MOVE AXISDETAIL TO ITAB1_TEMP.
            CLEAR AXISDETAIL.
            APPEND ITAB1_TEMP.
            CLEAR ITAB1_TEMP.
          ENDIF.

* Advice part for Normal and Partial payments

***rj01 - start - configuration of adv with partial adj
          IF V_PARTIAL_ADV = 'X'.
            SORT IT_CLR BY INDEX_CLR.
            CLEAR WA_CLR.
            LOOP AT IT_CLR INTO WA_CLR.
* Read invoice header details
              CLEAR : IT_BKPF_INV_DOC.
              READ TABLE IT_BKPF_INV_DOC WITH KEY BUKRS = WA_CLR-BUKRS_CLR
                                                  BELNR = WA_CLR-BELNR
                                                  GJAHR = WA_CLR-GJAHR.


****** Advise document indicator
              AXISDETAIL-ADV_START_IND = '~D'.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-ADV_START_IND.
              APPEND ZITAB1_TEMP.

******1 Invoice Document Reference Number
              IF IT_BKPF_INV_DOC-XBLNR <> ''.
                REPLACE ALL OCCURRENCES OF ':' IN IT_BKPF_INV_DOC-XBLNR WITH ' '.
                CONCATENATE 'Invoice Number:' IT_BKPF_INV_DOC-XBLNR INTO
                             AXISDETAIL-TITLE1.
                PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE1 C_SET5.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
                APPEND ZITAB1_TEMP.
              ELSE.
                CONCATENATE 'Invoice Number:' '' INTO
                             AXISDETAIL-TITLE1.
*                             SEPARATED BY space.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
                APPEND ZITAB1_TEMP.
              ENDIF.

******2 SAP Invoice document Number
              IF IT_INVOICES-BELNR IS NOT INITIAL.
                REPLACE ALL OCCURRENCES OF ':' IN WA_CLR-BELNR WITH ' '.
                CONCATENATE 'Document Number:' WA_CLR-BELNR INTO
                             AXISDETAIL-TITLE2.
                PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE2 C_SET5.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
                APPEND ZITAB1_TEMP.
              ELSE.
                CONCATENATE 'Document Number:' '' INTO
                             AXISDETAIL-TITLE2.
*                             SEPARATED BY space.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
                APPEND ZITAB1_TEMP.
              ENDIF.


******3 Invoice Date
              CONCATENATE IT_BKPF_INV_DOC-BLDAT+0(4)
                          IT_BKPF_INV_DOC-BLDAT+4(2)
                          IT_BKPF_INV_DOC-BLDAT+6(2)
                          INTO AXISDETAIL-TITLE3
                          SEPARATED BY '-'.
              IF NOT AXISDETAIL-TITLE3 IS INITIAL.
                REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE3 WITH ' '.
                CONCATENATE 'Document date:' AXISDETAIL-TITLE3
                             INTO AXISDETAIL-TITLE3.

              ELSE.
                CONCATENATE 'Document date:' '' INTO
                             AXISDETAIL-TITLE3.

              ENDIF.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE3 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE3.
              APPEND ZITAB1_TEMP.


******4 Posting Date
              CONCATENATE IT_BKPF_INV_DOC-BUDAT+0(4)
                          IT_BKPF_INV_DOC-BUDAT+4(2)
                          IT_BKPF_INV_DOC-BUDAT+6(2)
                          INTO AXISDETAIL-TITLE4
                          SEPARATED BY '-'.
              IF NOT AXISDETAIL-TITLE4 IS INITIAL.
                REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE4 WITH ' '.
                CONCATENATE 'Posting date:' AXISDETAIL-TITLE4
                             INTO AXISDETAIL-TITLE4.
*                             SEPARATED BY space.
              ELSE.
                CONCATENATE 'Posting date:' '' INTO
                             AXISDETAIL-TITLE4.
*                             SEPARATED BY space.
              ENDIF.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE4 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE4.
              APPEND ZITAB1_TEMP.

******6 Invoice Amount
              CLEAR: V_AMOUNT,
                     V_TDS.

              IF WA_CLR-SHKZG = 'S'.
                WA_CLR-DMBTR = WA_CLR-DMBTR * -1.
                V_AMOUNT = V_AMOUNT + ( WA_CLR-DMBTR + WA_CLR-DIFHW ).
              ELSE.
                V_AMOUNT = V_AMOUNT + ( WA_CLR-DMBTR + WA_CLR-DIFHW ).
              ENDIF.

              V_TDS = ''.

              WRITE V_AMOUNT TO AXISDETAIL-TITLE5
                             DECIMALS 2 NO-GROUPING.
              SHIFT AXISDETAIL-TITLE5 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE5 WITH ''.
              CONCATENATE 'Invoice Amount:' AXISDETAIL-TITLE5 INTO
                          AXISDETAIL-TITLE5.
              REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE5 WITH '.'.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE5 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE5.
              APPEND ZITAB1_TEMP.

******7 TDS amount
              V_TTDS = V_TDS.
              IF V_TTDS IS NOT INITIAL.
                SHIFT V_TTDS LEFT DELETING LEADING SPACE.
                REPLACE ALL OCCURRENCES OF ':' IN V_TTDS WITH ''.
                CONCATENATE 'Deductions:' V_TTDS INTO
                            AXISDETAIL-TITLE6. " SEPARATED BY space.
              ELSE.
                CONCATENATE 'Deductions:' ''  INTO
                            AXISDETAIL-TITLE6. " SEPARATED BY space.
              ENDIF.
              REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE6 WITH '.'.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE6 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE6.
              APPEND ZITAB1_TEMP.

******* 8 Paid Amount
              CLEAR : V_NET.
              V_NET = V_AMOUNT - V_TDS.
              V_NET_TOTAL = V_NET_TOTAL + V_NET.            "rj01
              WRITE V_NET TO AXISDETAIL-TITLE7 DECIMALS 2 NO-GROUPING.
              SHIFT AXISDETAIL-TITLE7 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE7 WITH ''.
              IF AXISDETAIL-TITLE7 <> ''.
                CONCATENATE 'Net Amount :' AXISDETAIL-TITLE7 INTO
                            AXISDETAIL-TITLE7.
                REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE7 WITH '.'.
                PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE7 C_SET5.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
                APPEND ZITAB1_TEMP.
              ELSE.
                CONCATENATE 'Net Amount :' '0.00' INTO
                            AXISDETAIL-TITLE7. " SEPARATED BY space.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
                APPEND ZITAB1_TEMP.
              ENDIF.


              MOVE AXISDETAIL TO ITAB1_TEMP.
              CLEAR AXISDETAIL.
              APPEND ITAB1_TEMP.
              CLEAR ITAB1_TEMP.

            ENDLOOP. "it_clr

          ELSE.
            LOOP AT IT_INVOICES.

* Check for partial payment
              CLEAR : V_PARTIAL_FLAG, IT_OPENLINES.
              READ TABLE IT_OPENLINES WITH KEY BUKRS = IT_INVOICES-BUKRS
                                               REBZG = IT_INVOICES-BELNR
                                               REBZJ = IT_INVOICES-GJAHR.
              IF SY-SUBRC = 0.
                V_PARTIAL_FLAG = 'X'.
              ENDIF.

* Read invoice header details
              CLEAR : IT_BKPF_INV_DOC.
              READ TABLE IT_BKPF_INV_DOC WITH KEY BUKRS = IT_INVOICES-BUKRS
                                                  BELNR = IT_INVOICES-BELNR
                                                  GJAHR = IT_INVOICES-GJAHR.

******1 Advise document indicator
              AXISDETAIL-ADV_START_IND = '~D'.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-ADV_START_IND.
              APPEND ZITAB1_TEMP.

******2 Invoice Document Reference Number
              IF IT_BKPF_INV_DOC-XBLNR <> ''.
                REPLACE ALL OCCURRENCES OF ':' IN IT_BKPF_INV_DOC-XBLNR WITH ' '.
                CONCATENATE 'Invoice Number:' IT_BKPF_INV_DOC-XBLNR INTO
                             AXISDETAIL-TITLE1.
                PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE1 C_SET5.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
                APPEND ZITAB1_TEMP.
              ELSE.
                CONCATENATE 'Invoice Number:' '' INTO
                             AXISDETAIL-TITLE1.
*                             SEPARATED BY space.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE1.
                APPEND ZITAB1_TEMP.
              ENDIF.

******4 SAP Invoice Number

              IF IT_INVOICES-BELNR IS NOT INITIAL.
                REPLACE ALL OCCURRENCES OF ':' IN IT_INVOICES-BELNR WITH ' '.
                CONCATENATE 'Document Number:' IT_INVOICES-BELNR INTO
                             AXISDETAIL-TITLE2.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
                APPEND ZITAB1_TEMP.
              ELSE.
                CONCATENATE 'Document Number:' '' INTO
                             AXISDETAIL-TITLE2.

                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE2.
                APPEND ZITAB1_TEMP.
              ENDIF.


******3 Invoice Date
              CONCATENATE IT_BKPF_INV_DOC-BLDAT+0(4)
                          IT_BKPF_INV_DOC-BLDAT+4(2)
                          IT_BKPF_INV_DOC-BLDAT+6(2)
                          INTO AXISDETAIL-TITLE3
                          SEPARATED BY '-'.
              IF NOT AXISDETAIL-TITLE3 IS INITIAL.
                REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE3 WITH ' '.
                CONCATENATE 'Document date:' AXISDETAIL-TITLE3
                             INTO AXISDETAIL-TITLE3.

              ELSE.
                CONCATENATE 'Document date:' '' INTO
                             AXISDETAIL-TITLE3.

              ENDIF.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE3 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE3.
              APPEND ZITAB1_TEMP.


******5 Posting Date
              CONCATENATE IT_BKPF_INV_DOC-BUDAT+0(4)
                          IT_BKPF_INV_DOC-BUDAT+4(2)
                          IT_BKPF_INV_DOC-BUDAT+6(2)
                          INTO AXISDETAIL-TITLE4
                          SEPARATED BY '-'.
              IF NOT AXISDETAIL-TITLE4 IS INITIAL.
                REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE4 WITH ' '.
                CONCATENATE 'Posting date:' AXISDETAIL-TITLE4
                             INTO AXISDETAIL-TITLE4.
              ELSE.
                CONCATENATE 'Posting date:' '' INTO
                             AXISDETAIL-TITLE4.
              ENDIF.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE4 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE4.
              APPEND ZITAB1_TEMP.

******6 Invoice Amount
              CLEAR: V_AMOUNT.
              IF NOT IT_INVOICES-DMBTR IS INITIAL.
                V_AMOUNT = IT_INVOICES-DMBTR.         "Invoice without TDS
              ELSEIF NOT IT_INVOICES-SKFBT IS INITIAL.
                V_AMOUNT = IT_INVOICES-SKFBT.         "TDS at Invoice Level
              ELSE.
                V_AMOUNT = IT_INVOICES-QSSHB.         "TDS at Payment Level
              ENDIF.

              V_INVOICES = V_INVOICES + 1.

              CLEAR : V_TDS, V_TTDS.
              LOOP AT IT_WITHITEM WHERE BUKRS = IT_INVOICES-BUKRS AND
                                        BELNR = IT_INVOICES-BELNR AND
                                        GJAHR = IT_INVOICES-GJAHR AND
                                        BUZEI = IT_INVOICES-BUZEI.
                V_TDS = V_TDS + ( IT_WITHITEM-WT_QBSHH * -1 ).
              ENDLOOP.

              IF IT_INVOICES-SHKZG = C_S.
                V_AMOUNT = V_AMOUNT * -1.
              ENDIF.
              V_AMOUNT = V_AMOUNT + V_TDS.

              WRITE V_AMOUNT TO AXISDETAIL-TITLE5
                             DECIMALS 2 NO-GROUPING.
              SHIFT AXISDETAIL-TITLE5 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE5 WITH ''.
              CONCATENATE 'Invoice Amount:' AXISDETAIL-TITLE5 INTO
                          AXISDETAIL-TITLE5.
              REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE5 WITH '.'.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE5 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE5.
              APPEND ZITAB1_TEMP.

******7 TDS amount
              V_TTDS = V_TDS.
              IF V_TTDS IS NOT INITIAL.
                SHIFT V_TTDS LEFT DELETING LEADING SPACE.
                REPLACE ALL OCCURRENCES OF ':' IN V_TTDS WITH ''.
                CONCATENATE 'Deductions:' V_TTDS INTO
                            AXISDETAIL-TITLE6.
              ELSE.
                CONCATENATE 'Deductions:' ''  INTO
                            AXISDETAIL-TITLE6.
              ENDIF.
              REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE6 WITH '.'.
              PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE6 C_SET5.
              ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE6.
              APPEND ZITAB1_TEMP.

******* 8 Paid Amount
              CLEAR : V_NET.
              V_NET = V_AMOUNT - V_TDS.
              V_NET_TOTAL = V_NET_TOTAL + V_NET.            "rj01
              IF V_PARTIAL_FLAG IS NOT INITIAL.
                V_NET = IT_OPENLINES-DMBTR.
              ENDIF.
              WRITE V_NET TO AXISDETAIL-TITLE7 DECIMALS 2 NO-GROUPING.
              SHIFT AXISDETAIL-TITLE7 LEFT DELETING LEADING SPACE.
              REPLACE ALL OCCURRENCES OF ':' IN AXISDETAIL-TITLE7 WITH ''.
              IF AXISDETAIL-TITLE7 <> ''.
                CONCATENATE 'Net Amount :' AXISDETAIL-TITLE7 INTO
                            AXISDETAIL-TITLE7.
                REPLACE ALL OCCURRENCES OF ',' IN AXISDETAIL-TITLE7 WITH '.'.
                PERFORM VALIDATE_CHARACTER_SET_SPACE USING AXISDETAIL-TITLE7 C_SET5.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
                APPEND ZITAB1_TEMP.
              ELSE.
                CONCATENATE 'Net Amount :' '0.00' INTO
                            AXISDETAIL-TITLE7.
                ZITAB1_TEMP-FLD_STR = AXISDETAIL-TITLE7.
                APPEND ZITAB1_TEMP.
              ENDIF.


              MOVE AXISDETAIL TO ITAB1_TEMP.
              CLEAR AXISDETAIL.
              APPEND ITAB1_TEMP.
              CLEAR ITAB1_TEMP.

            ENDLOOP.    " it_invoices
          ENDIF.      "it_clr
        ENDIF.  "it_clr_temp


***rj03 - start, validation for the payment document total amount
**************** and invoice documents net amount
        DATA : V_NET_TEMP TYPE BSEG-DMBTR."I.

        CLEAR V_NET_TEMP.
        MOVE V_NET_TOTAL TO V_NET_TEMP.

        IF V_NET_TEMP < 0.
          V_NET_TEMP = V_NET_TEMP * -1.
        ENDIF.

*        IF V_NET_TEMP <> H1_TEMP-PAY_AMOUNT .
*          REFRESH : H1_TEMP, ITAB1_TEMP, ZITAB1_TEMP.
*          CLEAR :  H1_TEMP, ITAB1_TEMP, ZITAB1_TEMP.
*          CLEAR : LV_MESSAGE.
*
*          MOVE 'Total amount did not match'
*                      TO LV_MESSAGE.
*
*          ALV_POP1     C_ERROR
*                       LV_MESSAGE
*                       IT_TCIEG-BELNR
*                       IT_TCIEG-GJAHR
*                       LV_NAME
*                       LV_VEND_CUST.
*
*          ALV_POP2     ''
*                       '' "v_payamount
*                       ''
*                       ''
*                       ''
*                       3.
*
*          CONTINUE.
*        ELSE.
        H1_TEMP-GJAHR = IT_TCIEG-GJAHR .  """""""""""" added by NC .
*        APPEND LINES OF H1_TEMP TO H1..
        APPEND   H1_TEMP TO H1..
        APPEND LINES OF ITAB1_TEMP TO ITAB1.
        APPEND LINES OF ZITAB1_TEMP TO ZITAB1..
        REFRESH : H1_TEMP, ITAB1_TEMP, ZITAB1_TEMP.
        CLEAR :  H1_TEMP, ITAB1_TEMP, ZITAB1_TEMP.
*        ENDIF.
**rj03 - end


        IF P_TEST IS INITIAL.
          LV_MESSAGE = 'Extracted'.
        ELSE.
          LV_MESSAGE = '--'.
        ENDIF.

        ALV_POP1     C_SUCCESS
                     LV_MESSAGE
                     IT_TCIEG-BELNR
                     IT_TCIEG-GJAHR
                     LV_NAME
                     LV_VEND_CUST.

        ALV_POP2     V_INVOICES
                     V_PAYAMOUNT
                     LV_PM
                     AXISHEADER1-PRINTING_LOC
                     AXISHEADER1-DD_PAY_LOC
                     0 .

        SPLIT_COUNT = SPLIT_COUNT + 1.                      "MJ001
        SPLIT_AMOUNT = SPLIT_AMOUNT + V_PAYAMOUNT.          "MJ001
        CLEAR : WA_RAPI.
      ENDLOOP.    " it_TCIeg

      DATA: LV_LF TYPE LFBK-LIFNR .
      LOOP AT IT_ALV_DISPLAY INTO DATA(WA_DIS).
        READ TABLE H1 INTO DATA(WA_H) WITH KEY PAY_DOC_NO = WA_DIS-BELNR .
        WA_DIS-BENE_ACC_NO   = WA_H-BENE_ACC_NO .
        WA_DIS-IFSC_CODE     = WA_H-IFSC_CODE   .
        WA_DIS-VENDOR_CODE   = WA_H-VENDOR_CODE  .

        LV_LF  =   WA_DIS-VENDOR_CODE .
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = LV_LF
          IMPORTING
            OUTPUT = LV_LF.


        READ TABLE  IT_LFBK INTO DATA(WA_LFBK) WITH KEY LIFNR =  LV_LF .
        IF SY-SUBRC EQ 0 .
          WA_DIS-BENE_NAME     = WA_LFBK-KOINH .
        ENDIF.
        MODIFY IT_ALV_DISPLAY FROM WA_DIS TRANSPORTING BENE_ACC_NO IFSC_CODE VENDOR_CODE   BENE_NAME .

        CLEAR : WA_DIS,WA_H.
      ENDLOOP.


*      PERFORM API_SEND .

      CLEAR: WA_SPLIT.
      WA_SPLIT-SPLIT_COUNT = SPLIT_COUNT.                   "MJ001
      WA_SPLIT-SPLIT_AMOUNT = SPLIT_AMOUNT.                 "MJ001

      IF P_TEST = 'X' AND IT_TCIEG_TEMP[] IS INITIAL.        "an001
*subroutine for output display
        PERFORM ALV_OUTPUT.

      ELSEIF P_TEST = ' '."An001  " p_test
        CLEAR ZITAB2.
        REFRESH ZITAB2.
**********************        added on 16/03/2023
        CLEAR ZITAB1.
        REFRESH ZITAB1.
        DATA : VAR1 TYPE STRING.
************************
        APPEND LINES OF ITAB1 TO ITAB.
        DATA : COUNT TYPE I.
        CLEAR : COUNT.
        LOOP AT H1.
*          ZITAB2-FLD_STR = H1-PAY_DOC_IND_START."~
*          APPEND ZITAB2.

          COUNT = COUNT + 1.
          ZITAB2-FLD_STR = H1-PMT_METHOD.       "Payment Method C,D,B
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VENDOR_CODE.                  "0000010000
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-BENE_ACC_NO.      "beneficiary account number
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAY_AMOUNT.       "13.2 1234567890123.12-
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VENDOR_NAME1.     "Name1
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-DD_DREW_LOC.      "Drew location
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-DD_PAY_LOC.       "DD Payable location
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VENDOR_ADDR1.     "Address - 1
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VENDOR_ADDR2.     "Address - 2
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VENDOR_ADDR3.     "Address -3
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VENDOR_ADDR5.     "City Name
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VENDOR_ADDR6.     "Postal Code
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-INSR_REF_NO.      "Instrction ref no
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-CUST_REF_NO.      "Cust ref no
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAY_DOC_NO.  "Payment detail 1
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAYMENT_DETAIL2.  "Payment detail 2
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAYMENT_DETAIL3.  "Payment detail 3
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAYMENT_DETAIL4.  "Payment detail 4
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAYMENT_DETAIL5.  "Payment detail 5
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAYMENT_DETAIL6.  "Payment detail 6
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-PAYMENT_DETAIL7.  "Payment detail 7
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-CHEQUE_NO.        "Printing Location
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-VALUE_DATE.       "DD/MM/YYYY
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-MICR_NO.          "MICR no
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-IFSC_CODE.        "IFSC code
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-BENE_BNK_NAME.    "bank name
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-BENE_BNK_BRNCH.   "branch name
          APPEND ZITAB2.

          ZITAB2-FLD_STR = H1-BENE_EMAIL.       "beneficiary email id
          APPEND ZITAB2.

          CONDENSE: H1-PMT_METHOD,H1-VENDOR_CODE,H1-BENE_ACC_NO,H1-PAY_AMOUNT,
                    H1-VENDOR_NAME1,H1-DD_DREW_LOC,H1-DD_PAY_LOC,H1-VENDOR_ADDR1,
                    H1-VENDOR_ADDR2,H1-VENDOR_ADDR3,H1-VENDOR_ADDR5,H1-VENDOR_ADDR6,
                    H1-INSR_REF_NO,H1-CUST_REF_NO,H1-PAY_DOC_NO,H1-PAYMENT_DETAIL2,
                    H1-PAYMENT_DETAIL3,H1-PAYMENT_DETAIL4,H1-PAYMENT_DETAIL5,
                    H1-PAYMENT_DETAIL6,H1-PAYMENT_DETAIL7,H1-CHEQUE_NO,H1-VALUE_DATE,
                    H1-MICR_NO,H1-IFSC_CODE,H1-BENE_BNK_NAME,H1-BENE_BNK_BRNCH,H1-BENE_EMAIL.

          DATA : LV_AMT TYPE STRING .

          LV_AMT   = H1-PAY_AMOUNT .




          CONCATENATE H1-PMT_METHOD
                      H1-VENDOR_CODE
                      H1-BENE_ACC_NO
                      H1-PAY_AMOUNT
                      H1-VENDOR_NAME1
                      H1-DD_DREW_LOC
                      H1-DD_PAY_LOC
                      H1-VENDOR_ADDR1
                      H1-VENDOR_ADDR2
                      H1-VENDOR_ADDR3
                      H1-VENDOR_ADDR5
                      H1-VENDOR_ADDR6
                      H1-INSR_REF_NO
                      H1-CUST_REF_NO
                      H1-PAY_DOC_NO
                      H1-PAYMENT_DETAIL2
                      H1-PAYMENT_DETAIL3
                      H1-PAYMENT_DETAIL4
                      H1-PAYMENT_DETAIL5
                      H1-PAYMENT_DETAIL6
                      H1-PAYMENT_DETAIL7
                      H1-CHEQUE_NO
                      H1-VALUE_DATE
                      H1-MICR_NO
                      H1-IFSC_CODE
                      H1-BENE_BNK_NAME
                      H1-BENE_BNK_BRNCH
                      H1-BENE_EMAIL
                      INTO VAR1 SEPARATED BY ','.
          APPEND VAR1 TO ZITAB1.
          CLEAR : VAR1,LV_AMT.

        ENDLOOP.

*        INSERT LINES OF ZITAB2  INTO ZITAB1 INDEX 1.
        IF 1 = 2  .
          IF ZITAB1[] IS NOT INITIAL.
            IF LV_SERVER_ENCRYPT EQ 'X'.
              PERFORM PAYMENT_FILE_ENCRYPT_SERVER.
            ELSE.
              PERFORM PAYMENT_FILE_ENCRYPT_DESKTOP.
            ENDIF.
          ELSE.
            CLEAR : X_INFO.
            X_INFO = 'File not generated.'.
          ENDIF.
        ENDIF.
*subroutine for output display

        IF IT_TCIEG_TEMP[] IS INITIAL.                       "An001
*subroutine for output display
          PERFORM ALV_OUTPUT.
        ENDIF.


      ENDIF.  " p_test
      DESCRIBE TABLE IT_TCIEG_TEMP LINES V_TCIEG_LINES.       "An001
    ENDWHILE.
  ELSEIF IT_ALV_DISPLAY[] IS NOT INITIAL.
*subroutine for output display
    PERFORM ALV_OUTPUT.

  ENDIF.
ENDFORM.                    "payment_details_construct

***&---------------------------------------------------------------------*
***&      Form  validate_character_set
***&---------------------------------------------------------------------*
***       text
***----------------------------------------------------------------------*
**FORM VALIDATE_CHARACTER_SET USING X TYPE ANY.
**  DATA: M_CHAR   TYPE C,
**        M_POS    TYPE I,
**        M_STRLEN TYPE I,
**        M_VALID(100).
**
**
**  MOVE '-:;' TO M_VALID.
**
**  M_STRLEN = STRLEN( X ).
**
**  DO M_STRLEN TIMES.
**    M_CHAR = X+M_POS(1).
**    IF NOT M_VALID NS M_CHAR.
**      X+M_POS(1) = ' '.
**    ENDIF.
**    M_POS = M_POS + 1.
**  ENDDO.
**ENDFORM.                    "VALIDATE_CHARACTER_SET


*&---------------------------------------------------------------------*
*&      Form  payment_file_encrypt
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM PAYMENT_FILE_ENCRYPT_DESKTOP.
*------------------------------------------------------------
* The following routine will call the C++ routine to encrypt
* the file generated for AXIS.
*------------------------------------------------------------
  DATA : INPUT_FILE(70)  TYPE C,
         OUTPUT_FILE(70) TYPE C,
         RESULT          LIKE SY-SUBRC,
         RETURN          TYPE I,
         TEMP(6),
         DT_TEMP(4),
         TEMP1(7),
         VAR(4).

  DT_TEMP = SY-DATUM+4(4).
  SHIFT DT_TEMP CIRCULAR BY 2 PLACES.

  REFRESH IT_ZAXISMAP_TCI[].                                 "An001
*  SELECT * FROM ZAXISMAP_TCI INTO TABLE IT_ZAXISMAP_TCI.      "An001
  SELECT * FROM ZAXISMAP_TCI INTO TABLE IT_ZAXISMAP_TCI.      "An001
  CLEAR : IT_ZAXISMAP_TCI.
  READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = 'DATE_CHK'.
  IF IT_ZAXISMAP_TCI-ZREMARKS IS INITIAL.
    CONCATENATE DT_TEMP
              '001'
              INTO IT_ZAXISMAP_TCI-ZREMARKS.
    MODIFY ZAXISMAP_TCI FROM IT_ZAXISMAP_TCI.
    TEMP1 = IT_ZAXISMAP_TCI-ZREMARKS.
  ELSE.
    IF IT_ZAXISMAP_TCI-ZREMARKS(4) = DT_TEMP.
      CLEAR : VAR.
      VAR = ( IT_ZAXISMAP_TCI-ZREMARKS+4 ) + 1.
      PERFORM PAD_FIELD_WITH_ZEROS USING VAR.
      CONCATENATE IT_ZAXISMAP_TCI-ZREMARKS(4)
                VAR
                INTO IT_ZAXISMAP_TCI-ZREMARKS.
      TEMP1 = IT_ZAXISMAP_TCI-ZREMARKS.
      MODIFY ZAXISMAP_TCI FROM IT_ZAXISMAP_TCI.
    ELSE.
      CONCATENATE DT_TEMP
              '001'
              INTO IT_ZAXISMAP_TCI-ZREMARKS.
      TEMP1 = IT_ZAXISMAP_TCI-ZREMARKS.
      MODIFY ZAXISMAP_TCI FROM IT_ZAXISMAP_TCI.
    ENDIF.
  ENDIF.
*  Start of An001

  READ TABLE IT_ZAXISMAP_TCI  WITH KEY ZFIELD_REF = 'HBAC'
                                  ZSAP_VALUE = S_HBKID  .
  IF SY-SUBRC = 0.
    LV_HBK = IT_ZAXISMAP_TCI-ZBANK_VALUE.
  ENDIF.

  READ TABLE IT_ZAXISMAP_TCI  WITH KEY ZFIELD_REF = 'HBID'
                                 ZSAP_VALUE = S_HBKID  .
  IF SY-SUBRC = 0.
    LV_HB_AC = IT_ZAXISMAP_TCI-ZBANK_VALUE.
  ENDIF.

*End of An001

  CONCATENATE LV_HBK LV_HB_AC
                TEMP1(4)
                INTO OUTPUT_FILE.
  CONCATENATE OUTPUT_FILE
              TEMP1+4
              INTO OUTPUT_FILE SEPARATED BY '.'.

  WA_SPLIT-SPLIT_FILE = OUTPUT_FILE.                        "MJ001
  APPEND WA_SPLIT TO IT_SPLIT.                              "MJ001

  CONCATENATE C_SOURCE
              OUTPUT_FILE INTO V_OUTPUT_FILE.

  CLEAR : IT_ZAXISMAP_TCI.
  READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = 'FLAG_ENCRY'.
  DATA : ENCRYPTIONFLAG TYPE C.
  IF IT_ZAXISMAP_TCI-ZSAP_VALUE IS INITIAL.
    ENCRYPTIONFLAG = SPACE.
  ELSE.
    ENCRYPTIONFLAG = IT_ZAXISMAP_TCI-ZSAP_VALUE.
  ENDIF.

  CALL FUNCTION 'ENCRYPTFILE' DESTINATION C_DEST
    EXPORTING
      FILE_IN   = 'C:\AXISBANK\IMPORT\AXIS_IN.txt'
      FILE_OUT  = V_OUTPUT_FILE
    IMPORTING
      RETURN_NO = RESULT
    TABLES
      HEADER1   = ZITAB1[].

  IF RESULT <> 0.
    MESSAGE I000(E4) WITH 'Error while Creating File' OUTPUT_FILE.
    STOP.
  ELSE .
    CLEAR LV_MESSAGE.
    CONCATENATE 'File'" successfully written to'
                 V_OUTPUT_FILE
                INTO LV_MESSAGE
                SEPARATED BY SPACE.

*    ALV_POP1     C_INFO
*                 LV_MESSAGE
*                 ''
*                 ''
*                 ''
*                 ''.
*
*    ALV_POP2     ''
*                 ''
*                 ''
*                 ''
*                 ''
*                 20.


  ENDIF.

  CLEAR X_INFO.
ENDFORM.                    "payment_file_encrypt

*&---------------------------------------------------------------------*
*&      Form  zAXISbank_insert_log
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM ZAXISBANK_INSERT_LOG.
  DATA V_COUNT TYPE I.
  CLEAR V_COUNT.
  V_COUNT = 1.

  LOOP AT IT_ALV_DISPLAY INTO WA_ALV_DISPLAY.
    IF WA_ALV_DISPLAY-STATUS EQ C_SUCCESS.
      WA_ZAXISLOG-LAUFD = SY-DATUM.
      WA_ZAXISLOG-GJAHR = WA_ALV_DISPLAY-FIS_YR.
      WA_ZAXISLOG-BUKRS = S_BUKRS.
      WA_ZAXISLOG-LIFNR = WA_ALV_DISPLAY-VEND_CODE.
      WA_ZAXISLOG-ID = V_COUNT.
      WA_ZAXISLOG-BELNR = WA_ALV_DISPLAY-BELNR.
      WA_ZAXISLOG-DATUM = SY-DATUM.
      WA_ZAXISLOG-UZEIT = SY-UZEIT.
      WA_ZAXISLOG-UNAME = SY-UNAME.
      WA_ZAXISLOG-FILENAME = V_OUTPUT_FILE.
      INSERT ZAXISLOG1_TCI FROM WA_ZAXISLOG.
      IF SY-SUBRC <> 0.
        ROLLBACK WORK.
        MESSAGE I000(E4) WITH 'Error inserting into ZAXISLOG2 log table'.
        STOP.
      ENDIF.
      V_COUNT = V_COUNT + 1.
    ENDIF.
  ENDLOOP.
ENDFORM.                    "zAXISbank_insert_log

*&---------------------------------------------------------------------*
*&      Form  pad_field_with_zeros
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FIELD_VALUE  text
*----------------------------------------------------------------------*
FORM PAD_FIELD_WITH_ZEROS USING FIELD_VALUE.
  DATA: V_CHAR   TYPE C,
        V_POS    TYPE I,
        V_STRLEN TYPE I.
  V_STRLEN = STRLEN( FIELD_VALUE ).
  DO V_STRLEN TIMES.
    V_CHAR = FIELD_VALUE+V_POS(1).
    IF V_CHAR = ' '.
      FIELD_VALUE+V_POS(1) = '0'.
    ENDIF.
    V_POS = V_POS + 1.
  ENDDO.
ENDFORM.                    "pad_field_with_zeros

*&---------------------------------------------------------------------*
*&      Form  ALV_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_OUTPUT .

  IF LV_ALV_DISPLAY EQ 'X'.

*          hiding ALV buttons
    PERFORM EXCLUDING_BUTTONS.
*          Layout for alv
    PERFORM BUILD_LAYOUT.

*          perform build_events.
    PERFORM BUILD_PRINT_PARAMS.

*          perform sorting.
    PERFORM SORT_FIELD.

*          perform color rows based on logic
    PERFORM COLOR_ROWS.

*          field catalogue
    PERFORM BUILD_FIELDCAT.

*          perform below event to display footer
    PERFORM POPULATE_ALV_EVENT.
    PERFORM COMMENT_BUILD USING I_END_OF_PAGE[].

    IF P_TEST IS INITIAL AND 1 = 2 .
*          INSERTING LOG
      PERFORM ZAXISBANK_INSERT_LOG.
    ENDIF.
*          output display
    PERFORM ALV_DISPLAY.
  ELSE.
*perform color rows based on logic
    PERFORM COLOR_ROWS.

    IF P_TEST IS INITIAL AND 1 = 2 .
*            INSERTING LOG
      PERFORM ZAXISBANK_INSERT_LOG.
      PERFORM SUMMARY_OUTPUT.   ""  added by nc
    ENDIF.
*    PERFORM SUMMARY_OUTPUT.   cmt by nc

  ENDIF.

ENDFORM.                    " ALV_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_FIELDCAT .
  FIELD_CAT '1' '1' 'STATUS' 'it_alv_display' 'Status'.
  IF LV_ERR_CNT IS NOT INITIAL AND LV_ERR_CNT NE 0.
    FIELD_CAT '1' '2' 'REMARKS' 'it_alv_display' 'Remarks'.
  ENDIF.
  FIELD_CAT '1' '3' 'BELNR' 'IT_ALV_DISPLAY' 'Document Number'.
  FIELD_CAT '1' '4' 'FIS_YR' 'IT_ALV_DISPLAY' 'Fis. Year'.
  FIELD_CAT '1' '5' 'VEND_NAME' 'IT_ALV_DISPLAY' 'Vendor Name'.
  FIELD_CAT '1' '6' 'NO_OF_INVOICES' 'IT_ALV_DISPLAY' 'Invoices'.
  FIELD_CAT '1' '7' 'RWBTR' 'IT_ALV_DISPLAY' 'Amount'.
  FIELD_CAT '1' '8' 'PAY_TYPE' 'IT_ALV_DISPLAY' 'Payment Method'.
  FIELD_CAT '1' '9' 'PRINT_LOC' 'IT_ALV_DISPLAY' 'Print Location'.
  FIELD_CAT '1' '10' 'DD_PAY_LOC' 'IT_ALV_DISPLAY' 'DD Pay. Loc.'.
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  FIELD_CAT '1' '10' 'BENE_ACC_NO' 'IT_ALV_DISPLAY' 'Bank A/C no'.
  FIELD_CAT '1' '10' 'IFSC_CODE' 'IT_ALV_DISPLAY' 'IFSC Code'.
  FIELD_CAT '1' '10' 'BENE_NAME' 'IT_ALV_DISPLAY' 'Beneficiary Name'.
  FIELD_CAT '1' '10' 'VENDOR_CODE' 'IT_ALV_DISPLAY' 'Supplier Code'.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  FIELD_CAT '1' '11' 'MESSAGE'     'IT_ALV_DISPLAY' 'API Response'.
ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  EXCLUDING_BUTTONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EXCLUDING_BUTTONS .
  APPEND '&ABC' TO IT_EXCLUDING.
*  APPEND '&UMC' TO it_excluding.
  APPEND '&EB9' TO IT_EXCLUDING.
  APPEND '&REFRESH' TO IT_EXCLUDING.
  APPEND '&VEXCEL' TO IT_EXCLUDING.
  APPEND '&AQW' TO IT_EXCLUDING.
  APPEND '%SL' TO IT_EXCLUDING.
  APPEND '&GRAPH' TO IT_EXCLUDING.
  APPEND '&AVE' TO IT_EXCLUDING.
  APPEND '&OAD' TO IT_EXCLUDING.
*  APPEND '&OL0' TO it_excluding.
  APPEND '&INFO' TO IT_EXCLUDING.

ENDFORM.                    " EXCLUDING_BUTTONS
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_LAYOUT .
  IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  IT_LAYOUT-INFO_FIELDNAME = 'LINE_COLOR'.
ENDFORM.                    " BUILD_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  BUILD_PRINT_PARAMS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BUILD_PRINT_PARAMS .
  GD_PRNTPARAMS-RESERVE_LINES = '3'. "Lines reserved for footer
  GD_PRNTPARAMS-NO_COVERPAGE = 'X'.
ENDFORM.                    " BUILD_PRINT_PARAMS
*&---------------------------------------------------------------------*
*&      Form  SORT_FIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_FIELD .
  WA_SORT-SPOS = 1.             " sort priority
  WA_SORT-FIELDNAME = 'STATUS'.  " field on which records sorted
  WA_SORT-TABNAME = 'it_alv_display'. " internal table name
  WA_SORT-UP = 'x'.           " sort ascending
  APPEND WA_SORT TO IT_SORT.    " append sort info internal table
  CLEAR WA_SORT.                " clear sort info work area

  WA_SORT-SPOS = 2.             " sort priority
  WA_SORT-FIELDNAME = 'BELNR'.  " field on which records sorted
  WA_SORT-TABNAME = 'it_alv_display'. " internal table name
  WA_SORT-UP = 'x'.           " sort ascending
  APPEND WA_SORT TO IT_SORT.    " append sort info internal table
  CLEAR WA_SORT.                " clear sort info work area
ENDFORM.                    " SORT_FIELD
*&---------------------------------------------------------------------*
*&      Form  COLOR_ROWS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM COLOR_ROWS .
*  CLEAR: lv_err_cnt, lv_inf_cnt, lv_SUC_cnt.
  SORT IT_ALV_DISPLAY BY PAY_TYPE.
  CLEAR: LV_ET_TOTAL,LV_DD_TOTAL,LV_CHK_TOTAL.

  LOOP AT IT_ALV_DISPLAY INTO WA_ALV_DISPLAY.

    CASE WA_ALV_DISPLAY-STATUS.
      WHEN C_ERROR.
        WA_ALV_DISPLAY-RWBTR = 0.
        LV_ERR_CNT = LV_ERR_CNT + 1.
        WA_ALV_DISPLAY-LINE_COLOR = 'C600'.
      WHEN C_INFO.
        LV_INF_CNT = LV_INF_CNT + 1.
        WA_ALV_DISPLAY-LINE_COLOR = 'C300'.
      WHEN C_SUCCESS.
        LV_SUC_CNT = LV_SUC_CNT + 1.
        WA_ALV_DISPLAY-LINE_COLOR = 'C500'.
    ENDCASE.

    IF WA_ALV_DISPLAY-STATUS EQ C_SUCCESS.
      CASE WA_ALV_DISPLAY-PAY_TYPE.
        WHEN C_PM_CHK.
          LV_CHK_TOTAL = LV_CHK_TOTAL + WA_ALV_DISPLAY-RWBTR.
        WHEN C_PM_DD.
          LV_DD_TOTAL = LV_DD_TOTAL + WA_ALV_DISPLAY-RWBTR.
        WHEN C_PM_RTGS OR C_PM_NEFT OR C_PM_IFT .
          LV_ET_TOTAL = LV_ET_TOTAL + WA_ALV_DISPLAY-RWBTR.
      ENDCASE.
    ENDIF.

    IF WA_ALV_DISPLAY-DD_PAY_LOC IS NOT INITIAL.
      READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_BRANCH
                                      ZBANK_VALUE =  WA_ALV_DISPLAY-DD_PAY_LOC.

      WA_ALV_DISPLAY-DD_PAY_LOC = IT_ZAXISMAP_TCI-ZBANK_VALUE.

    ENDIF.

    IF WA_ALV_DISPLAY-PRINT_LOC IS NOT INITIAL.
      READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = C_PRINT
                                      ZBANK_VALUE = WA_ALV_DISPLAY-PRINT_LOC.

      WA_ALV_DISPLAY-PRINT_LOC = IT_ZAXISMAP_TCI-ZSAP_VALUE.
    ENDIF.

    MODIFY IT_ALV_DISPLAY FROM WA_ALV_DISPLAY.
  ENDLOOP.

  CLEAR WA_ALV_DISPLAY.
  IF LV_ALV_DISPLAY EQ 'X'.
    READ TABLE IT_ALV_DISPLAY INTO WA_ALV_DISPLAY WITH KEY STATUS = C_INFO.
    IF SY-SUBRC EQ 0.
*      DELETE TABLE it_alv_display FROM wa_alv_display.
      DELETE IT_ALV_DISPLAY INDEX SY-TABIX.
    ENDIF.
  ENDIF.

ENDFORM.                    " COLOR_ROWS
*-------------------------------------------------------------------*
* Form TOP-OF-PAGE *
*-------------------------------------------------------------------*
* ALV Report Header *
*-------------------------------------------------------------------*
FORM TOP-OF-PAGE.
*ALV Header declarations
  DATA: T_HEADER  TYPE SLIS_T_LISTHEADER,
        WA_HEADER TYPE SLIS_LISTHEADER,
        T_LINE    LIKE WA_HEADER-INFO.
  CLEAR: LV_MESSAGE.
** Title
*  wa_header-typ = 'H'.
*  wa_header-info = 'Reverse Upload Report'.
*  append wa_header to t_header.
*  clear wa_header.

* Date
  WA_HEADER-TYP = 'S'.
  WA_HEADER-KEY = 'Date: '.
  CONCATENATE SY-DATUM+6(2) '.'
  SY-DATUM+4(2) '.'
  SY-DATUM(4) INTO WA_HEADER-INFO. "todays date
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

  CONCATENATE 'Company Code:' S_BUKRS
              ' _ House Bank:' S_HBKID
              ' _ Account ID:' S_HKTID
              INTO LV_MESSAGE SEPARATED BY SPACE.

  WA_HEADER-TYP = 'S'.
  WA_HEADER-KEY = 'Information:'.
  WA_HEADER-INFO = LV_MESSAGE.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

  CONCATENATE 'Success: ' LV_SUC_CNT ',' SPACE SPACE
              'Errors: ' LV_ERR_CNT " ',' space space
*              'Information: ' lv_inf_cnt
         INTO LV_SUMMARY
  SEPARATED BY SPACE.


  WA_HEADER-TYP = 'A'.
  WA_HEADER-INFO = LV_SUMMARY.
  APPEND WA_HEADER TO T_HEADER.
  CLEAR: WA_HEADER.

*data: x_test type bds_typeid VALUE 'ZAXISLOGO'.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = T_HEADER.
* i_logo = x_test.

ENDFORM.                    "top-of-page
*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*User actions on ALV
FORM USER_COMMAND USING R_UCOMM TYPE SY-UCOMM
                        RS_SELFIELD TYPE SLIS_SELFIELD.
  CASE R_UCOMM.
*User clicks a transaction code and that tcode is called from ALV
    WHEN '&IC1'.
      READ TABLE IT_ALV_DISPLAY INDEX RS_SELFIELD-TABINDEX
                                 INTO WA_ALV_DISPLAY.
      IF SY-SUBRC = 0.
        IF WA_ALV_DISPLAY-ERR_TYPE EQ 0.
* Set parameter ID for transaction screen field
          SET PARAMETER ID 'BLN' FIELD WA_ALV_DISPLAY-BELNR.
          SET PARAMETER ID 'BUK' FIELD S_BUKRS.
          SET PARAMETER ID 'GJR' FIELD WA_ALV_DISPLAY-FIS_YR.

          CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

        ELSEIF WA_ALV_DISPLAY-ERR_TYPE EQ 12 OR
               WA_ALV_DISPLAY-ERR_TYPE EQ 13.

          SET PARAMETER ID 'LIF' FIELD WA_ALV_DISPLAY-VEND_CODE.
          SET PARAMETER ID 'BUK' FIELD S_BUKRS.

          CALL TRANSACTION 'XK03' AND SKIP FIRST SCREEN.

        ELSEIF WA_ALV_DISPLAY-ERR_TYPE EQ 3.

          SET PARAMETER ID 'LIF' FIELD WA_ALV_DISPLAY-VEND_CODE.
          SET PARAMETER ID 'BUK' FIELD S_BUKRS.

          CALL TRANSACTION 'XK05' AND SKIP FIRST SCREEN.

        ELSEIF WA_ALV_DISPLAY-ERR_TYPE EQ 4.

          SET PARAMETER ID 'KUN' FIELD WA_ALV_DISPLAY-VEND_CODE.
          SET PARAMETER ID 'BUK' FIELD S_BUKRS.

          CALL TRANSACTION 'XD05' AND SKIP FIRST SCREEN.

        ELSEIF WA_ALV_DISPLAY-ERR_TYPE EQ 2.
          MESSAGE 'Document already extracted.' TYPE 'E' DISPLAY LIKE 'I'.
        ENDIF.
      ENDIF.

  ENDCASE.
ENDFORM.                    "user_command

*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_DISPLAY .

  IF P_TEST NE 'X' .
    PERFORM API_SEND .
  ELSE.
    LOOP AT IT_ALV_DISPLAY INTO DATA(WA_DD).
      IF WA_DD-RWBTR  > 0 .
        IF WA_DD-RWBTR <= 200000.
          WA_DD-PAY_TYPE = 'NEFT'.
        ELSE.
          WA_DD-PAY_TYPE = 'RTGS'.
        ENDIF.
        MODIFY IT_ALV_DISPLAY FROM WA_DD TRANSPORTING PAY_TYPE .
      ENDIF.
      CLEAR : WA_DD .
    ENDLOOP.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = SY-REPID
      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE' "see FORM
      I_CALLBACK_USER_COMMAND = 'USER_COMMAND'
      IT_FIELDCAT             = IT_FIELDCAT
      IT_EVENTS               = I_EVENTS
      IS_LAYOUT               = IT_LAYOUT
      IS_PRINT                = GD_PRNTPARAMS
      IT_EXCLUDING            = IT_EXCLUDING
      IT_SORT                 = IT_SORT        " sort info
    TABLES
      T_OUTTAB                = IT_ALV_DISPLAY.
ENDFORM.                    " ALV_DISPLAY

*&---------------------------------------------------------------------*

*& Form POPULATE_ALV_EVENT

*&---------------------------------------------------------------------*

FORM POPULATE_ALV_EVENT .

* Populate event table

  W_EVENTS-NAME = 'END_OF_LIST'.

  W_EVENTS-FORM = 'END_OF_LIST'.

  APPEND W_EVENTS TO I_EVENTS.

ENDFORM. " POPULATE_ALV_EVENT


*&---------------------------------------------------------------------*

*& Form COMMENT_BUILD

*&---------------------------------------------------------------------*

FORM COMMENT_BUILD USING P_I_END_OF_PAGE TYPE SLIS_T_LISTHEADER.

  DATA: LS_LINE TYPE SLIS_LISTHEADER.

  REFRESH P_I_END_OF_PAGE.

  CLEAR: LS_LINE,LV_MESSAGE.

  LV_CHK_TOTAL_C = LV_CHK_TOTAL.
  LV_DD_TOTAL_C = LV_DD_TOTAL.
  LV_ET_TOTAL_C = LV_ET_TOTAL.
  LV_TOT_AMT = LV_CHK_TOTAL + LV_DD_TOTAL + LV_ET_TOTAL.

  CONDENSE LV_CHK_TOTAL_C.
  CONDENSE LV_DD_TOTAL_C.
  CONDENSE LV_ET_TOTAL_C.

  LV_TOT_AMT_C =  LV_TOT_AMT.
  CONDENSE LV_TOT_AMT_C.

  CLEAR: LV_MESSAGE.


  IF P_TEST IS INITIAL.                                     "MJ001
    CLEAR WA_SPLIT.
    LOOP AT IT_SPLIT INTO WA_SPLIT.
      CONDENSE WA_SPLIT-SPLIT_FILE.
      CONDENSE WA_SPLIT-SPLIT_COUNT.
      CONDENSE WA_SPLIT-SPLIT_AMOUNT.
      CLEAR: LV_MESSAGE.
      LV_MESSAGE =  WA_SPLIT-SPLIT_FILE.
      LS_LINE-TYP = 'S'.
      LS_LINE-KEY = 'File Extracted:'.
      LS_LINE-INFO = LV_MESSAGE.

      APPEND LS_LINE TO P_I_END_OF_PAGE.

      CLEAR LV_MESSAGE.
      CONCATENATE 'Count:' '  ' WA_SPLIT-SPLIT_COUNT ',' 'Amount:' '  ' WA_SPLIT-SPLIT_AMOUNT INTO LV_MESSAGE SEPARATED BY SPACE.
      LS_LINE-TYP = 'S'.
      LS_LINE-KEY = ' '.
      LS_LINE-INFO = LV_MESSAGE.
      APPEND LS_LINE TO P_I_END_OF_PAGE.
    ENDLOOP.

    CLEAR:LV_MESSAGE.
    MOVE LV_TOT_AMT_C TO LV_MESSAGE.
    LS_LINE-TYP = 'S'.
    LS_LINE-KEY = 'Total Payment:'.
    LS_LINE-INFO = LV_MESSAGE.

    APPEND LS_LINE TO P_I_END_OF_PAGE.

  ELSE.                                                     "MJ001

    MOVE LV_TOT_AMT_C TO LV_MESSAGE.


    LS_LINE-TYP = 'S'.
    LS_LINE-KEY = 'Total Payment:'.
    LS_LINE-INFO = LV_MESSAGE.

    APPEND LS_LINE TO P_I_END_OF_PAGE.
  ENDIF.                                                    "MJ001

  CLEAR LV_MESSAGE.



**CONCATENATE 'Cheque Amt.:' LV_CHK_TOTAL_c
**            ' _ DD Amt.:' LV_DD_TOTAL_c
**            ' _ E-Transfer Amt.:' LV_et_TOTAL_c
**            into lv_message SEPARATED BY space.
**
*  IF P_TEST IS INITIAL.
*    LS_LINE-TYP = 'S'.
*    LS_LINE-KEY = 'File Extracted:'.
*    LS_LINE-INFO = X_INFO.
*
*    APPEND LS_LINE TO P_I_END_OF_PAGE.
*  ENDIF.


ENDFORM. " COMMENT_BUILD


*&---------------------------------------------------------------------*

*& Form end_of_list

*&---------------------------------------------------------------------*

FORM END_OF_LIST.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = I_END_OF_PAGE.

ENDFORM. "end_of_list
*&---------------------------------------------------------------------*
*&      Form  SUMMARY_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SUMMARY_OUTPUT .
  DATA: LV_TOTAL_INVOICE  TYPE I,
        LV_TOTAL_RWBTR    TYPE REGUH-RWBTR,
        LV_PAYMETHODS(15) TYPE C VALUE '',
        LV_POSITION       TYPE SY-COLNO,
        LV_TOTAL_DOCS     TYPE I.

  CLEAR: LV_TOTAL_INVOICE, LV_TOTAL_RWBTR.

  FORMAT INTENSIFIED OFF INVERSE OFF INPUT OFF COLOR 5.
  IF P_TEST = C_X.
    WRITE :/ 'TEST RUN'. "TEST RUN.
    ULINE.
  ENDIF.

  WRITE : /01 'Preview'. "Preview
  FORMAT COLOR OFF.
  SKIP.

***Error Messages
  IF IT_ALV_DISPLAY[] IS NOT INITIAL.
    ULINE.
    FORMAT INTENSIFIED OFF INVERSE OFF INPUT OFF COLOR 6.
    WRITE :/ 'Error Messages'. "Error Messages.
    ULINE.

    LOOP AT IT_ALV_DISPLAY INTO WA_ALV_DISPLAY.
      IF WA_ALV_DISPLAY-STATUS EQ C_ERROR.
        CONCATENATE 'Document Number:' WA_ALV_DISPLAY-BELNR WA_ALV_DISPLAY-REMARKS INTO
        LV_TEXT_OUTPUT SEPARATED BY SPACE.
        WRITE :/  LV_TEXT_OUTPUT.
      ENDIF.
      IF WA_ALV_DISPLAY-STATUS EQ C_INFO.
        ULINE.
        FORMAT INTENSIFIED OFF INVERSE OFF INPUT OFF COLOR 3.
        WRITE :/ 'Information Messages'. "Error Messages.
        ULINE.

        CONCATENATE WA_ALV_DISPLAY-REMARKS '' INTO
        LV_TEXT_OUTPUT SEPARATED BY SPACE.
        WRITE :/  LV_TEXT_OUTPUT.
      ENDIF.
    ENDLOOP.

  ENDIF.
  ULINE.
  SKIP 1.

  FORMAT RESET.
  FORMAT COLOR OFF.
  LV_POSITION = 100.

  WRITE:   /1 'Company Code'   , 35 S_BUKRS.
  WRITE:   /1 'House Bank'  , 35 S_HBKID,
           /1 'Account ID'   , 35 S_HKTID.
  ULINE.

  SKIP 1.
  WRITE: 'Payment Details.'.
  ULINE.
  FORMAT COLOR 1.
  WRITE: /  'Vendor Code', "'Vendor Code
         14 'Vendor', "'Vendor
         48 'Pay Doc', "'Pay Doc
         64 'Year',
         74 'Invoices', "'Invoices
         84 'Pay Mode', "'Pay Mode
         100 'Pay Amount'. "Pay Amount
  ULINE.
  FORMAT RESET.

  LOOP AT IT_ALV_DISPLAY INTO WA_ALV_DISPLAY.
    IF WA_ALV_DISPLAY-STATUS EQ 'ERROR'.
      CONTINUE.
    ENDIF.
    WRITE: / WA_ALV_DISPLAY-VEND_CODE(10) LEFT-JUSTIFIED,
             WA_ALV_DISPLAY-VEND_NAME(35) LEFT-JUSTIFIED,
             WA_ALV_DISPLAY-BELNR(10) LEFT-JUSTIFIED,
           64 WA_ALV_DISPLAY-FIS_YR LEFT-JUSTIFIED,
           74 WA_ALV_DISPLAY-NO_OF_INVOICES CENTERED,
           84 WA_ALV_DISPLAY-PAY_TYPE CENTERED,
           94 WA_ALV_DISPLAY-RWBTR RIGHT-JUSTIFIED.

    LV_TOTAL_INVOICE = LV_TOTAL_INVOICE + WA_ALV_DISPLAY-NO_OF_INVOICES.
    LV_TOTAL_RWBTR   = LV_TOTAL_RWBTR + WA_ALV_DISPLAY-RWBTR.
    LV_TOTAL_DOCS    = LV_TOTAL_DOCS + 1.
  ENDLOOP.

  ULINE.
  FORMAT INTENSIFIED OFF INVERSE OFF INPUT OFF COLOR 5.
  WRITE: /13 'Total', "'Total
          74 LV_TOTAL_INVOICE CENTERED,
          92 LV_TOTAL_RWBTR RIGHT-JUSTIFIED,
          50 LV_TOTAL_DOCS LEFT-JUSTIFIED.
  ULINE.

  FORMAT RESET.
  NEW-PAGE PRINT OFF.

  IF SY-SPONO GT 0.
    FORMAT COLOR 3.
    WRITE:/1 'Spool No. :', SY-SPONO.   "Spool No. :
  ENDIF.
  FORMAT COLOR OFF.
ENDFORM.                    " SUMMARY_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  PAYMENT_FILE_ENCRYPT_SERVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PAYMENT_FILE_ENCRYPT_SERVER .


  DATA : INPUT_FILE(70)  TYPE C,
         OUTPUT_FILE(70) TYPE C,
         RESULT          LIKE SY-SUBRC,
         M_RETURN        TYPE I,
         TEMP(6),
         DT_TEMP(4),
         TEMP1(7),
         VAR(4).

  DT_TEMP = SY-DATUM+4(4).
  SHIFT DT_TEMP CIRCULAR BY 2 PLACES.


  REFRESH IT_ZAXISMAP_TCI[].                                 "An003
*  SELECT * FROM ZAXISMAP_TCI INTO TABLE IT_ZAXISMAP_TCI.      "An003
  SELECT * FROM ZAXISMAP_TCI INTO TABLE IT_ZAXISMAP_TCI.      "An003
  CLEAR : IT_ZAXISMAP_TCI.
  READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = 'DATE_CHK'.
  IF IT_ZAXISMAP_TCI-ZREMARKS IS INITIAL.
    CONCATENATE DT_TEMP
              '001'
              INTO IT_ZAXISMAP_TCI-ZREMARKS.
    MODIFY ZAXISMAP_TCI FROM IT_ZAXISMAP_TCI.
    TEMP1 = IT_ZAXISMAP_TCI-ZREMARKS.
    COMMIT WORK.
  ELSE.
    IF IT_ZAXISMAP_TCI-ZREMARKS(4) = DT_TEMP.
      CLEAR : VAR.
      VAR = ( IT_ZAXISMAP_TCI-ZREMARKS+4 ) + 1.
      PERFORM PAD_FIELD_WITH_ZEROS USING VAR.
      CONCATENATE IT_ZAXISMAP_TCI-ZREMARKS(4)
                VAR
                INTO IT_ZAXISMAP_TCI-ZREMARKS.
      TEMP1 = IT_ZAXISMAP_TCI-ZREMARKS.
      MODIFY ZAXISMAP_TCI FROM IT_ZAXISMAP_TCI.
      COMMIT WORK.
    ELSE.
      CONCATENATE DT_TEMP
              '001'
              INTO IT_ZAXISMAP_TCI-ZREMARKS.
      TEMP1 = IT_ZAXISMAP_TCI-ZREMARKS.
      MODIFY ZAXISMAP_TCI FROM IT_ZAXISMAP_TCI.
      COMMIT WORK.
    ENDIF.
  ENDIF.
*  Start of An003

  READ TABLE IT_ZAXISMAP_TCI  WITH KEY ZFIELD_REF = 'HBAC'
                                  ZSAP_VALUE = S_HBKID  .
  IF SY-SUBRC = 0.
    LV_HBK = IT_ZAXISMAP_TCI-ZBANK_VALUE.
  ENDIF.

  READ TABLE IT_ZAXISMAP_TCI  WITH KEY ZFIELD_REF = 'HBID'
                                 ZSAP_VALUE = S_HBKID  .
  IF SY-SUBRC = 0.
    LV_HB_AC = IT_ZAXISMAP_TCI-ZBANK_VALUE.
  ENDIF.

  READ TABLE IT_ZAXISMAP_TCI WITH KEY ZFIELD_REF = 'DOMAIN'. "
  IF SY-SUBRC = 0.
    C_DOMAIN = IT_ZAXISMAP_TCI-ZREMARKS.
  ENDIF.
  "25.05.2022
**  read table it_ZAXISMAP_TCI with key zfield_ref = 'CLEARFILES'. "
**  if sy-subrc = 0.
**    c_extract = it_ZAXISMAP_TCI-zremarks.
**  endif.
**
**  read table it_ZAXISMAP_TCI with key zfield_ref = 'ENCFILES'. "
**  if sy-subrc = 0.
**    lv_server_encrypt_src_path = it_ZAXISMAP_TCI-zremarks.
**  endif.
  "25.05.2022
  CONCATENATE LV_HBK '_' LV_HB_AC
                TEMP1(4)
                INTO OUTPUT_FILE.
  CONCATENATE OUTPUT_FILE
              TEMP1+4
              INTO OUTPUT_FILE SEPARATED BY '.'.

  IF H2H = 'X'.                                             "
    CONCATENATE C_DOMAIN '_' OUTPUT_FILE INTO OUTPUT_FILE.
  ENDIF.

  WA_SPLIT-SPLIT_FILE = OUTPUT_FILE.                        "MJ001
  APPEND WA_SPLIT TO IT_SPLIT.                              "MJ001


  DATA: W_SOURCE1(200)      TYPE C,
        LV_OUTPUT_FILE(150) TYPE C.


  DATA: USER(30)       TYPE C,
        PWD(30)        TYPE C,
        HOST(64)       TYPE C,
        RFDEST         TYPE RFCDES-RFCDEST,
        W_FTPDEST(100) TYPE C.

  DATA: SLEN       TYPE I,
        FTP_HANDLE TYPE I.

  DATA: BEGIN OF RESULTS OCCURS 0,
          LINE(120),
        END OF RESULTS.

  DATA: BEGIN OF CMD OCCURS 0,
          LINE(225),
        END OF CMD.
****************        decode password
  DATA: UTILITY TYPE REF TO CL_HTTP_UTILITY.
  DATA: MYSAPSSO2 TYPE STRING.
  DATA: COOKIE TYPE STRING.
  CREATE OBJECT UTILITY.
*************************************

  CONSTANTS KEY TYPE I VALUE 26101957.

** fetch the FTP details from Y table
*  SELECT SINGLE ZREMARKS INTO W_FTPDEST FROM ZAXISMAP_TCI
  SELECT SINGLE ZREMARKS INTO W_FTPDEST FROM ZAXISMAP_TCI
                      WHERE ZFIELD_REF = 'PATH'
                      AND ZSAP_VALUE = 'FTP'
                      AND ZBANK_VALUE = ' ' .

*  SELECT SINGLE ZREMARKS INTO USER FROM ZAXISMAP_TCI
  SELECT SINGLE ZREMARKS INTO USER FROM ZAXISMAP_TCI
                         WHERE ZFIELD_REF = 'FTPUNAME'
                         AND ZSAP_VALUE = 'UNAME'
                         AND ZBANK_VALUE = ' ' .

*  SELECT SINGLE ZREMARKS INTO PWD FROM ZAXISMAP_TCI
  SELECT SINGLE ZREMARKS INTO PWD FROM ZAXISMAP_TCI
                         WHERE ZFIELD_REF = 'FTPPWD'
                         AND ZSAP_VALUE = 'PASSWORD'
                         AND ZBANK_VALUE = ' ' .
**************    decode password
  IF PWD IS NOT INITIAL.
    MYSAPSSO2 = PWD.
    CALL METHOD UTILITY->DECODE_BASE64
      EXPORTING
        ENCODED = MYSAPSSO2
      RECEIVING
        DECODED = COOKIE.
    CONDENSE: COOKIE.
    PWD = COOKIE.
  ENDIF.
************************************

*  SELECT SINGLE ZREMARKS INTO HOST FROM ZAXISMAP_TCI
  SELECT SINGLE ZREMARKS INTO HOST FROM ZAXISMAP_TCI
                         WHERE ZFIELD_REF = 'FTPHOST'
                         AND ZSAP_VALUE = 'HNAME'
                         AND ZBANK_VALUE = ' ' .

* RFC Destination for FTP
  RFDEST = 'SAPFTP'.  "'SAPFTPA'.

  CLEAR CMD.
  DATA : OUTPUT_FILE3(125) TYPE C.

*Encrypt password
  CLEAR SLEN.
  SLEN = STRLEN( PWD ).

  CALL FUNCTION 'HTTP_SCRAMBLE'
    EXPORTING
      SOURCE      = PWD
      SOURCELEN   = SLEN
      KEY         = KEY
    IMPORTING
      DESTINATION = PWD.

*Establish FTP connection
  CLEAR FTP_HANDLE.
  CALL FUNCTION 'FTP_CONNECT'
    EXPORTING
      USER            = USER
      PASSWORD        = PWD
      HOST            = HOST
      RFC_DESTINATION = RFDEST
    IMPORTING
      HANDLE          = FTP_HANDLE
    EXCEPTIONS
      NOT_CONNECTED   = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*Process FTP
  DATA FNAME(120) TYPE C.
  CLEAR :CMD[],L_CMD.
  CONCATENATE 'cd' W_FTPDEST INTO L_CMD SEPARATED BY SPACE.
  CLEAR RESULTS[].
  CMD = L_CMD.
  APPEND CMD.
  CMD = 'ls'.
  APPEND CMD.
  CALL FUNCTION 'FTP_COMMAND_LIST'
    EXPORTING
      HANDLE        = FTP_HANDLE
    TABLES
      DATA          = RESULTS
      COMMANDS      = CMD
    EXCEPTIONS
      TCPIP_ERROR   = 1
      COMMAND_ERROR = 2
      DATA_ERROR    = 3
      OTHERS        = 4.
  IF SY-SUBRC <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*  *  endded-"25.05.2022
*atart of add -25.05.2022
  CALL FUNCTION 'FTP_R3_TO_SERVER'
    EXPORTING
      HANDLE         = FTP_HANDLE
      FNAME          = OUTPUT_FILE  "output_file3
*     BLOB_LENGTH    =
      CHARACTER_MODE = 'X'
    TABLES
*     BLOB           =
      TEXT           = ZITAB1
*   EXCEPTIONS
*     TCPIP_ERROR    = 1
*     COMMAND_ERROR  = 2
*     DATA_ERROR     = 3
*     OTHERS         = 4
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  CALL FUNCTION 'FTP_COMMAND_LIST'
    EXPORTING
      HANDLE        = FTP_HANDLE
    TABLES
      DATA          = RESULTS
      COMMANDS      = CMD
    EXCEPTIONS
      TCPIP_ERROR   = 1
      COMMAND_ERROR = 2
      DATA_ERROR    = 3
      OTHERS        = 4.
  IF SY-SUBRC <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*Close FTP connection

  CALL FUNCTION 'FTP_DISCONNECT'
    EXPORTING
      HANDLE = FTP_HANDLE.

  IF SY-SUBRC = 0.
    CLEAR I_INFO1.
    CONCATENATE 'File successfully written to'(010) LV_OUTPUT_FILE INTO I_INFO1 SEPARATED BY SPACE.
  ELSE.
    MESSAGE I000(E4) WITH 'Error while Creating File'(011) LV_OUTPUT_FILE.
    STOP.
  ENDIF.

  CLEAR: LV_MESSAGE,X_INFO.
  CONCATENATE 'File'" successfully written to'
               V_OUTPUT_FILE
              INTO LV_MESSAGE
              SEPARATED BY SPACE.
  CONCATENATE 'File'" successfully written to'
               V_OUTPUT_FILE
              INTO X_INFO
              SEPARATED BY SPACE.

*    ALV_POP1     C_INFO
*                 LV_MESSAGE
*                 ''
*                 ''
*                 ''
*                 ''
*                 ''.
*
*    ALV_POP2     ''
*                 ''
*                 ''
*                 ''
*                 ''
*                 ''
*                 20
*                 ''.


**  else.
**    message i000(e4) with 'UNABLE TO RUN ENCRYPTION UTILITY'.
**    stop.
**  endif.

ENDFORM.                    " PAYMENT_FILE_ENCRYPT_SERVER

*&---------------------------------------------------------------------*
*&      Form  VALIDATE_CHARACTER_SET_NEW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_axisheader1_RUN_IDENTIFIER  text
*      -->P_4758   text
*      -->P_C_SET1  text
*      <--P_V_ERR_FLG  text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  validate_character_set_new
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->STR        text
*      -->FIELDNAME  text
*      -->M_VALID    text
*      -->ERR_FLG    text
*----------------------------------------------------------------------*
FORM VALIDATE_CHARACTER_SET_NEW  USING  STR TYPE ANY FIELDNAME TYPE ANY M_VALID TYPE STRING CHANGING ERR_FLG TYPE C.
  .

  DATA: M_CHAR   TYPE C,
        M_POS    TYPE I,
        M_STRLEN TYPE I.
*        M_VALID(100).

*   CONCATENATE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
*  '0123456789,/-?:().+''' INTO M_VALID SEPARATED BY SPACE.


  M_STRLEN = STRLEN( STR ).

  DO M_STRLEN TIMES.
    CLEAR : M_CHAR.
    M_CHAR = STR+M_POS(1).
    IF M_VALID NS M_CHAR.
*      str+M_POS(1) = ' '.  " enable to replce with space for error message set flag. "jd01
      ERR_FLG = 'X'.
      CLEAR LV_MESSAGE.
      CONCATENATE 'Special character is not allowed in field ' FIELDNAME INTO LV_MESSAGE SEPARATED BY SPACE.

      ALV_POP1     C_ERROR
                   LV_MESSAGE
                   IT_TCIEG-BELNR
                   IT_TCIEG-GJAHR
                   LV_NAME
                   LV_VEND_CUST.

      ALV_POP2    V_INVOICES
                  V_PAYAMOUNT
                  LV_PM
                  AXISHEADER1-PRINTING_LOC
                  AXISHEADER1-DD_PAY_LOC
                  7
                  .

      EXIT.
    ENDIF.
    M_POS = M_POS + 1.
  ENDDO.
ENDFORM.                    " VALIDATE_CHARACTER_SET_new
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_CHARACTER_SET_SPACE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->STR        text
*      -->M_VALID    text
*----------------------------------------------------------------------*
FORM VALIDATE_CHARACTER_SET_SPACE  USING  STR TYPE ANY M_VALID TYPE STRING .
  .

  DATA: M_CHAR   TYPE C,
        M_POS    TYPE I,
        M_STRLEN TYPE I.

  M_STRLEN = STRLEN( STR ).

  DO M_STRLEN TIMES.
    CLEAR : M_CHAR.
    M_CHAR = STR+M_POS(1).
    IF M_VALID NS M_CHAR.
      STR+M_POS(1) = ' '.  " enable to replce with space
    ENDIF.
    M_POS = M_POS + 1.
  ENDDO.
ENDFORM.                    " VALIDATE_CHARACTER_SET_space

*&---------------------------------------------------------------------*
*& Form API_SEND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM API_SEND .



  TYPES: BEGIN OF TY_SUBHEADER,
           REQUESTUUID           TYPE STRING,
           SERVICEREQUESTID      TYPE STRING,
           SERVICEREQUESTVERSION TYPE STRING,
           CHANNELID             TYPE STRING,
         END OF  TY_SUBHEADER.



  TYPES: BEGIN OF TY_REQUESTBODYENCRYPTED,
           CHANNELID      TYPE STRING,
           CORPCODE       TYPE STRING,
           PAYMENTDETAILS TYPE ZTTPAYMENTDETAILS,
           CHECKSUM       TYPE STRING,
         END OF TY_REQUESTBODYENCRYPTED.

*  TYPES: BEGIN OF TY_TRAPAYREQ,
*           SUBHEADER     TYPE TY_SUBHEADER,
*           BODYENCRYPTED TYPE TY_REQUESTBODYENCRYPTED,
*         END OF TY_TRAPAYREQ.

  TYPES : BEGIN OF TY_RISK,
            RISK TYPE STRING,
          END OF TY_RISK .

  TYPES: BEGIN OF TY_TRAPAYREQ,
*           SUBHEADER     TYPE TY_SUBHEADER,
           DATA TYPE TY_REQUESTBODYENCRYPTED,
           RISK TYPE  TY_RISK, " JSON has empty object {}
         END OF TY_TRAPAYREQ.

  TYPES: BEGIN OF TY_API_RES,
           REQUESTUUID TYPE CHAR20,
           MESSAGE     TYPE STRING,
           STATUS      TYPE STRING,
           LOG         TYPE STRING,
         END OF TY_API_RES.

  TYPES : BEGIN OF TY_FINAL,
            DATA TYPE TY_TRAPAYREQ,
          END OF TY_FINAL.


*  DATA: WA_FINAL   TYPE TY_FINAL,
  DATA: WA_FINAL   TYPE TY_TRAPAYREQ,
        LV_JSON    TYPE /UI2/CL_JSON=>JSON,
        WA_RES_API TYPE TY_API_RES.

  DATA: WA_PAY            TYPE ZPAYMENTDETAILS,
        IT_PAY            TYPE ZTTPAYMENTDETAILS,
        WA_INV_DET        TYPE ZINVOICEDETAILS,
        IT_INV_DET        TYPE ZTTINVOICEDETAILS,
        WA_BODY_ENC       TYPE TY_REQUESTBODYENCRYPTED,
        WA_SUBHEADER      TYPE TY_SUBHEADER,
        WA_HEADER         TYPE  TY_TRAPAYREQ,
        WA_PAYMENTREQUEST TYPE  TY_TRAPAYREQ,
        LO_CLIENT         TYPE REF TO IF_HTTP_CLIENT,
        RESULT            TYPE STRING,
        WA_RES            TYPE ZAXIS_RES_API,
        RESULT_TAB        TYPE TABLE OF STRING.



  DATA: LO_HTTP_TOKEN    TYPE REF TO IF_HTTP_CLIENT,
        L_RESPONSE_TOKEN TYPE STRING.
  DATA: L_STATUS_CODE   TYPE I.
  DATA: LV_BAS64ENC TYPE STRING.
  DATA: WA_URL        TYPE STRING,
        WA_GRANT      TYPE STRING,
        CLIENT_SECRET TYPE STRING,
        USERNAME      TYPE STRING,
        PASSWORD      TYPE STRING,
        REFRESH_TOKEN TYPE STRING,
        LV_TOKEN      TYPE STRING,
        LV_CLIENT_ID  TYPE STRING.
  DATA: LO_ROOT TYPE REF TO CX_ROOT.

  DATA: BEGIN OF TS_TOKEN OCCURS 0,
          TOKEN TYPE STRING,
*          ACCESS_TOKEN TYPE STRING,
*          EXPIRES_IN   TYPE STRING,
        END OF TS_TOKEN .



  TRY.

      DATA URL TYPE STRING.
      URL = 'http://49.248.197.67:8080/auth/token'.
      TRANSLATE  URL TO LOWER CASE.

      CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_URL
        EXPORTING
          URL                = URL
*         SSL_ID             = 'UATSKY' "'DFAULT'
        IMPORTING
          CLIENT             = LO_HTTP_TOKEN
        EXCEPTIONS
          ARGUMENT_NOT_FOUND = 1
          PLUGIN_NOT_ACTIVE  = 2
          INTERNAL_ERROR     = 3
          OTHERS             = 4.
      IF SY-SUBRC <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*Close the client in case of Error
        LO_HTTP_TOKEN->CLOSE( ).
      ENDIF.


      IF LO_HTTP_TOKEN IS BOUND.
        LO_HTTP_TOKEN->REQUEST->SET_METHOD( IF_HTTP_ENTITY=>CO_REQUEST_METHOD_POST ).
      ENDIF.


*       CL_HTTP_UTILITY=>ENCODE_BASE64( EXPORTING
*                                    UNENCODED = LV_BAS64ENC
*                                  RECEIVING
*                                    ENCODED   = LV_BAS64ENC ).
*
*        CONCATENATE 'Inherit Auth from parent' LV_BAS64ENC INTO LV_BAS64ENC RESPECTING BLANKS.
*
*        LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
*           EXPORTING
*           NAME =  'Authorization'
*           VALUE =  LV_BAS64ENC ).

*
*LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
*                     EXPORTING
*                     NAME = 'Content-Type'
*                     VALUE = 'multipart/form-data; boundary=<calculated when request is sent>'
*                                                ).
*      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
*        EXPORTING
*          NAME  = 'Accept'
*          VALUE = '*/*'
*      ).


* READ TABLE IT_TOKEN WITH KEY CONTENT = 'CLIENT_ID' INTO DATA(LV_CLIENT).
* LV_CLIENT_ID = LV_CLIENT-VALUE.
*      LV_CLIENT_ID = 'Q3/jSm+sjfM3MfygSboT69QucC0Bqvt5hJb9OIB/z7Q='.
*
*      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
*        EXPORTING
*          NAME  = 'X-Client-Id'
*          VALUE = LV_CLIENT_ID
*      ).

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'X-Client-Id'
        VALUE = 'Q3/jSm+sjfM3MfygSboT69QucC0Bqvt5hJb9OIB/z7Q=' ).   """"""""" NC

**   READ TABLE IT_TOKEN WITH KEY CONTENT = 'CLIENT_SECRET' INTO data(CLIENT_SEC).
**CLIENT_SECRET = CLIENT_SEC-VALUE.
*      CLIENT_SECRET = 'Q3/jSm+sjfM3MfygSboT68Cy0hyOFti/TfYEJ/NwvHQ='.
**      TRANSLATE CLIENT_SECRET TO LOWER CASE.
**CLIENT_SECRET = 'bf113e2d2fa0d2ba184fdc530aae95e0e5d65ea7c6'.
*      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
*        EXPORTING
*          NAME  = 'X-Client-Secret'
*          VALUE = CLIENT_SECRET ).

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(   """""""" NC
        NAME  = 'X-Client-Secret'
        VALUE = 'Q3/jSm+sjfM3MfygSboT68Cy0hyOFti/TfYEJ/NwvHQ=' ).

*      USERNAME = 'm+75t+W8AAJmVsbUgo97KxsLwz4ruMTuIl7837ZFT2w='.
**      TRANSLATE CLIENT_SECRET TO LOWER CASE.
**CLIENT_SECRET = 'bf113e2d2fa0d2ba184fdc530aae95e0e5d65ea7c6'.
*      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
*        EXPORTING
*          NAME  = 'X-Username'
*          VALUE = USERNAME ).

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'X-Username'
        VALUE = 'm+75t+W8AAJmVsbUgo97KxsLwz4ruMTuIl7837ZFT2w=' ).


*      PASSWORD = 'p7ZybLacnZ9tXqhakWA1fnrWa7mliAFrSpPcM4JtTxU='.
**      TRANSLATE CLIENT_SECRET TO LOWER CASE.
**CLIENT_SECRET = 'bf113e2d2fa0d2ba184fdc530aae95e0e5d65ea7c6'.
*      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
*        EXPORTING
*          NAME  = 'X-Password'
*          VALUE = PASSWORD ).

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'X-Password'
        VALUE = 'p7ZybLacnZ9tXqhakWA1fnrWa7mliAFrSpPcM4JtTxU=' ).


      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'Content-Type'
        VALUE = 'application/json' ).


      LO_HTTP_TOKEN->PROPERTYTYPE_LOGON_POPUP = 0.

* Send / Receive Token Request
      CALL METHOD LO_HTTP_TOKEN->SEND
        EXCEPTIONS
          HTTP_COMMUNICATION_FAILURE = 1
          HTTP_INVALID_STATE         = 2
          HTTP_PROCESSING_FAILED     = 3
          HTTP_INVALID_TIMEOUT       = 4
          OTHERS                     = 5.
      IF SY-SUBRC <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL METHOD LO_HTTP_TOKEN->RECEIVE
        EXCEPTIONS
          HTTP_COMMUNICATION_FAILURE = 1
          HTTP_INVALID_STATE         = 2
          HTTP_PROCESSING_FAILED     = 3
          OTHERS                     = 4.
      IF SY-SUBRC <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*      ENDIF.

*
*      CALL METHOD LO_HTTP_TOKEN->SEND
*        EXCEPTIONS
*          HTTP_COMMUNICATION_FAILURE = 1
*          HTTP_INVALID_STATE         = 2
*          HTTP_PROCESSING_FAILED     = 3
*          OTHERS                     = 4.


*      IF 1 = 2 .
      CALL METHOD LO_HTTP_TOKEN->RESPONSE->GET_STATUS
        IMPORTING
          CODE = L_STATUS_CODE.

*Json response needs to be converted to abap readable format
      CALL METHOD LO_HTTP_TOKEN->RESPONSE->GET_CDATA
        RECEIVING
          DATA = L_RESPONSE_TOKEN.
*      ENDIF.

*      CALL METHOD LO_HTTP_TOKEN->RECEIVE
*        EXCEPTIONS
*          HTTP_COMMUNICATION_FAILURE = 1
*          HTTP_INVALID_STATE         = 2
*          HTTP_PROCESSING_FAILED     = 3
*          OTHERS                     = 4.
*
*      IF SY-SUBRC <> 0.
*        MESSAGE 'HTTP receive failed' TYPE 'E'.
*      ENDIF.
*
*BREAK-POINT.
*DATA: lv_status_code TYPE i,
*      lv_reason      TYPE string.
*
*      LO_HTTP_TOKEN->RESPONSE->GET_STATUS(
*        IMPORTING
*          CODE   = LV_STATUS_CODE
*          REASON = LV_REASON ).

      /UI2/CL_JSON=>DESERIALIZE(
        EXPORTING
          JSON = L_RESPONSE_TOKEN
        CHANGING
          DATA = TS_TOKEN  "Token will be stored in the instance structure, for retrieval in other methods.
      ).

      LV_TOKEN = TS_TOKEN-TOKEN.


      LO_HTTP_TOKEN->CLOSE( ).
    CATCH CX_ROOT INTO LO_ROOT.
  ENDTRY.


*******************************************************************

*  DATA : lv_url TYPE string VALUE 'http://172.16.1.38:443/api/service2' .  """" dev
*  DATA : LV_URL TYPE STRING VALUE 'http://172.16.1.38:443/api' .
  DATA : LV_URL TYPE STRING VALUE 'http://49.248.197.67:8080/api/v1/dev/payment' .

*  SELECT SINGLE END_POINT FROM  ZAXIS_ENDPT INTO @DATA(LV_ZAXIS_ENDPT) .
*  IF LV_ZAXIS_ENDPT IS NOT INITIAL  .
*    CONCATENATE LV_URL LV_ZAXIS_ENDPT INTO LV_URL SEPARATED BY '/'.
*  ELSE .
*    MESSAGE 'Please Maintain The End-Point First' TYPE 'E'.
*  ENDIF.
*  DATA : lv_url TYPE string VALUE 'http://172.16.1.38:443/api/TransferPaymentPrd' .  """" prd

  LOOP AT H1 INTO DATA(WA_TT).

    READ TABLE IT_ALV_DISPLAY INTO DATA(WA_AL) WITH KEY BELNR = WA_TT-PAY_DOC_NO
                                                        FIS_YR       = WA_TT-GJAHR.
    IF WA_AL-STATUS = 'SUCCESS' .
*    WA_INV_DET-INVOICEAMOUNT = '200001'         .
*    WA_INV_DET-INVOICENUMBER = 'SI-000748518'   .
*    WA_INV_DET-INVOICEDATE   = '2022-09-28'     .
*    WA_INV_DET-CASHDISCOUNT  = '0.00'           .
*    WA_INV_DET-TAX           = '0.00'           .
*    WA_INV_DET-NETAMOUNT     = '0.00'           .
*    WA_INV_DET-INVOICEINFO1  = ''               .
*    WA_INV_DET-INVOICEINFO2  = ''               .
*    WA_INV_DET-INVOICEINFO3  = ''               .
*    WA_INV_DET-INVOICEINFO4  = ''               .
*    WA_INV_DET-INVOICEINFO5  = ''               .

      APPEND WA_INV_DET TO IT_INV_DET .
*      CASE LV_PM .
*        WHEN 'NEFT'  .
*          WA_PAY-TXNPAYMODE = 'NE'.
*
*      ENDCASE.

*      = LV_PM . " WA_TT-PMT_METHOD ."'RT'.
      CONCATENATE  WA_TT-GJAHR WA_TT-PAY_DOC_NO WA_TT-PAY_CO_CODE   INTO  WA_PAY-CUSTUNIQREF.  "  =  'RTGSTESTTRANSACTION'.
*      wa_pay-corpaccnum     = '917020068438686'.  """" DEV
*      WA_PAY-CORPACCNUM     = '917030085315239'.  """""""" PRD   """""""""""" Check
      WA_PAY-VALUEDATE      = WA_TT-VALUE_DATE . " '2022-09-28'.

      WA_PAY-TXNAMOUNT      = WA_TT-PAY_AMOUNT .            "'200001'.
      IF WA_TT-PAY_AMOUNT <=  200000  .
        WA_PAY-TXNPAYMODE = 'NE'.
      ELSE.
        WA_PAY-TXNPAYMODE = 'RT'.
      ENDIF.
*     WA_PAY-BENELEI        = '21380068NOA8WMH89Z35'.
      WA_PAY-BENENAME       = WA_AL-BENE_NAME   . " wa_tt-vendor_name1 ."'GAURAV KALE'.
      WA_PAY-BENECODE       = WA_TT-VENDOR_CODE .           "'195133'.
      WA_PAY-BENEACCNUM     = WA_TT-BENE_ACC_NO ." '160190919920'.
      WA_PAY-BENEACTYPE     = WA_TT-BENE_ACC_TYP. " '11'.
*     WA_PAY-BENEADDR1      = 'WADIA INTERNATIONAL'.
*     WA_PAY-BENEADDR2      = 'BHUDKAR MARG'.
*     WA_PAY-BENEADDR3      = 'WORLI'.`
*     WA_PAY-BENECITY       = 'MUMBAI'.
*     WA_PAY-BENESTATE      = 'MAHARASHTRA'.
*     WA_PAY-BENEPINCODE    = '400102'.
      WA_PAY-BENEIFSCCODE   =  WA_TT-IFSC_CODE ."'INDB0000028'.
      WA_PAY-BENEBANKNAME   =  WA_TT-BENE_BNK_NAME . "'INDUSIND BANK'.
*     WA_PAY-BASECODE       = ''.
*     WA_PAY-CHEQUENUMBER   = ''.
*     WA_PAY-CHEQUEDATE     = ''.
*     WA_PAY-PAYABLELOCATION = ''.
*     WA_PAY-PRINTLOCATION  = ''.
      WA_PAY-BENEEMAILADDR1 = WA_TT-BENE_EMAIL. "'gaurav.kale@axisbank.com'.
*     WA_PAY-BENEMOBILENO   = '02243253689I'.
*     WA_PAY-PRODUCTCODE    = ''.
*     WA_PAY-TXNTYPE        = 'VEND'.
      WA_PAY-INVOICEDETAILS = IT_INV_DET .
*     WA_PAY-ENRICHMENT1    = ''.
*     WA_PAY-ENRICHMENT2    = ''.
*     WA_PAY-ENRICHMENT3    = ''.
*     WA_PAY-ENRICHMENT4    = ''.
*     WA_PAY-ENRICHMENT5    = ''.
*     WA_PAY-SENDERTORECEIVERINFO =  'RTGS TEST TRANSACTION' .

      APPEND WA_PAY TO IT_PAY .

*    WA_BODY_ENC-CHANNELID         = 'TXB'.
*      WA_BODY_ENC-CHECKSUM          = 'eb0ef722f84aa7826cdf473c8ba49d14' .
*    WA_BODY_ENC-CORPCODE          = 'DEMOCORP87'.
      WA_BODY_ENC-PAYMENTDETAILS    = IT_PAY .

      CONCATENATE  WA_TT-GJAHR WA_TT-PAY_DOC_NO WA_TT-PAY_CO_CODE   INTO   WA_SUBHEADER-REQUESTUUID  .    "'ABC123' .

      WA_SUBHEADER-SERVICEREQUESTID = 'OpenAPI' .
      WA_SUBHEADER-SERVICEREQUESTVERSION  = '1.0'.
      WA_SUBHEADER-CHANNELID = 'TXB' .


*      WA_PAYMENTREQUEST-SUBHEADER      = WA_SUBHEADER .
*      WA_PAYMENTREQUEST-BODYENCRYPTED  = WA_BODY_ENC .


*      WA_FINAL-TRANSFERPAYMENTREQUES-BODYENCRYPTED = WA_BODY_ENC.
      WA_FINAL-DATA = WA_BODY_ENC.

*      WA_FINAL-TRANSFERPAYMENTREQUES-SUBHEADER = WA_SUBHEADER.


      LV_JSON = /UI2/CL_JSON=>SERIALIZE( DATA        = WA_FINAL
                                         COMPRESS    = ABAP_FALSE
                                         PRETTY_NAME = /UI2/CL_JSON=>PRETTY_MODE-CAMEL_CASE ).
      REPLACE ALL OCCURRENCES OF  '"data"' IN LV_JSON WITH '"Data"'.
      REPLACE ALL OCCURRENCES OF  '"transferpaymentreques"' IN LV_JSON WITH '"TransferPaymentRequest"'.
      REPLACE ALL OCCURRENCES OF  '"subheader"' IN LV_JSON WITH '"SubHeader"'.
      REPLACE ALL OCCURRENCES OF  '"requestuuid"' IN LV_JSON WITH '"requestUUID"'.
      REPLACE ALL OCCURRENCES OF  '"servicerequestid"' IN LV_JSON WITH '"serviceRequestId"'.
      REPLACE ALL OCCURRENCES OF  '"servicerequestversion"' IN LV_JSON WITH '"serviceRequestVersion"'.
      REPLACE ALL OCCURRENCES OF  '"channelid"' IN LV_JSON WITH '"channelId"'.
      REPLACE ALL OCCURRENCES OF  '"bodyencrypted"' IN LV_JSON WITH '"TransferPaymentRequestBodyEncrypted"'.
      REPLACE ALL OCCURRENCES OF  '"channelid"' IN LV_JSON WITH '"channelId"'.
      REPLACE ALL OCCURRENCES OF  '"corpcode"' IN LV_JSON WITH '"corpCode"'.
      REPLACE ALL OCCURRENCES OF  '"paymentdetails"' IN LV_JSON WITH '"paymentDetails"'.
      REPLACE ALL OCCURRENCES OF  '"txnpaymode"' IN LV_JSON WITH '"txnPaymode"'.
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      REPLACE ALL OCCURRENCES OF  '"custuniqref"' IN LV_JSON WITH '"custUniqRef"'.
      REPLACE ALL OCCURRENCES OF  '"corpaccnum"' IN LV_JSON WITH '"corpAccNum"'.
      REPLACE ALL OCCURRENCES OF  '"valuedate"' IN LV_JSON WITH '"valueDate"'.
      REPLACE ALL OCCURRENCES OF  '"txnamount"' IN LV_JSON WITH '"txnAmount"'.
      REPLACE ALL OCCURRENCES OF  '"benelei"' IN LV_JSON WITH '"beneLEI"'.
      REPLACE ALL OCCURRENCES OF  '"benename"' IN LV_JSON WITH '"beneName"'.
      REPLACE ALL OCCURRENCES OF  '"benecode"' IN LV_JSON WITH '"beneCode"'.
      REPLACE ALL OCCURRENCES OF  '"beneaccnum"' IN LV_JSON WITH '"beneAccNum"'.
      REPLACE ALL OCCURRENCES OF  '"beneactype"' IN LV_JSON WITH '"beneAcType"'.
      REPLACE ALL OCCURRENCES OF  '"beneaddr1"' IN LV_JSON WITH '"beneAddr1"'.
      REPLACE ALL OCCURRENCES OF  '"beneaddr2"' IN LV_JSON WITH '"beneAddr2"'.
      REPLACE ALL OCCURRENCES OF  '"beneaddr3"' IN LV_JSON WITH '"beneAddr3"'.

      REPLACE ALL OCCURRENCES OF  '"benecity"' IN LV_JSON WITH '"beneCity"'.
      REPLACE ALL OCCURRENCES OF  '"benestate"' IN LV_JSON WITH '"beneState"'.
      REPLACE ALL OCCURRENCES OF  '"benepincode"' IN LV_JSON WITH '"benePincode"'.
      REPLACE ALL OCCURRENCES OF  '"beneifsccode"' IN LV_JSON WITH '"beneIfscCode"'.
      REPLACE ALL OCCURRENCES OF  '"benebankname"' IN LV_JSON WITH '"beneBankName"'.
      REPLACE ALL OCCURRENCES OF  '"basecode"' IN LV_JSON WITH '"baseCode"'.


      REPLACE ALL OCCURRENCES OF  '"chequenumber"' IN LV_JSON WITH '"chequeNumber"'.
      REPLACE ALL OCCURRENCES OF  '"chequedate"' IN LV_JSON WITH '"chequeDate"'.
      REPLACE ALL OCCURRENCES OF  '"payablelocation"' IN LV_JSON WITH '"payableLocation"'.
      REPLACE ALL OCCURRENCES OF  '"printlocation"' IN LV_JSON WITH '"printLocation"'.
      REPLACE ALL OCCURRENCES OF  '"beneemailaddr1"' IN LV_JSON WITH '"beneEmailAddr1"'.
      REPLACE ALL OCCURRENCES OF  '"benemobileno"' IN LV_JSON WITH '"beneMobileNo"'.
      REPLACE ALL OCCURRENCES OF  '"productcode"' IN LV_JSON WITH '"productCode"'.
      REPLACE ALL OCCURRENCES OF  '"txntype"' IN LV_JSON WITH '"txnType"'.
      REPLACE ALL OCCURRENCES OF  '"invoicedetails"' IN LV_JSON WITH '"invoiceDetails"'.


      REPLACE ALL OCCURRENCES OF  '"invoiceamount"' IN LV_JSON WITH '"invoiceAmount"'.
      REPLACE ALL OCCURRENCES OF  '"invoicenumber"' IN LV_JSON WITH '"invoiceNumber"'.
      REPLACE ALL OCCURRENCES OF  '"invoicedate"'   IN LV_JSON WITH '"invoiceDate"'.
      REPLACE ALL OCCURRENCES OF  '"cashdiscount"'  IN LV_JSON WITH '"cashDiscount"'.
      REPLACE ALL OCCURRENCES OF  '"tax"'           IN LV_JSON WITH '"tax"'.
      REPLACE ALL OCCURRENCES OF  '"netamount"'     IN LV_JSON WITH '"netAmount"'.
      REPLACE ALL OCCURRENCES OF  '"invoiceinfo1"'  IN LV_JSON WITH '"invoiceInfo1"'.
      REPLACE ALL OCCURRENCES OF  '"invoiceinfo2"'  IN LV_JSON WITH '"invoiceInfo2"'.
      REPLACE ALL OCCURRENCES OF  '"invoiceinfo3"'  IN LV_JSON WITH '"invoiceInfo3"'.
      REPLACE ALL OCCURRENCES OF  '"invoiceinfo4"'  IN LV_JSON WITH '"invoiceInfo4"'.
      REPLACE ALL OCCURRENCES OF  '"invoiceinfo5"'  IN LV_JSON WITH '"invoiceInfo5"'.



      REPLACE ALL OCCURRENCES OF  '"enrichment1"' IN LV_JSON WITH '"enrichment1"'.
      REPLACE ALL OCCURRENCES OF  '"enrichment2"' IN LV_JSON WITH '"enrichment2"'.
      REPLACE ALL OCCURRENCES OF  '"enrichment3"' IN LV_JSON WITH '"enrichment3"'.
      REPLACE ALL OCCURRENCES OF  '"enrichment4"' IN LV_JSON WITH '"enrichment4"'.
      REPLACE ALL OCCURRENCES OF  '"enrichment5"' IN LV_JSON WITH '"enrichment5"'.

      REPLACE ALL OCCURRENCES OF  '"sendertoreceiverinfo"' IN LV_JSON WITH '"senderToReceiverInfo"'.
      REPLACE ALL OCCURRENCES OF  '"checksum"' IN LV_JSON WITH '"checksum"'.
      REPLACE ALL OCCURRENCES OF  '"risk"' IN LV_JSON WITH '"Risk"'.
      REPLACE ALL OCCURRENCES OF  '{"Risk":""}' IN LV_JSON WITH '{ }'.

      CONDENSE LV_URL NO-GAPS.
      TRY.
          CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_URL
            EXPORTING
              URL                = LV_URL
            IMPORTING
              CLIENT             = LO_CLIENT
            EXCEPTIONS
              ARGUMENT_NOT_FOUND = 1
              PLUGIN_NOT_ACTIVE  = 2
              INTERNAL_ERROR     = 3
              OTHERS             = 4.
          IF SY-SUBRC <> 0.
            LO_CLIENT->CLOSE( ).
          ENDIF.
          IF LO_CLIENT IS BOUND.
            LO_CLIENT->REQUEST->SET_METHOD( IF_HTTP_REQUEST=>CO_REQUEST_METHOD_POST ).
            LO_CLIENT->REQUEST->SET_HEADER_FIELD( NAME = 'Content-Type' VALUE = 'application/json' ).



            LO_CLIENT->REQUEST->SET_HEADER_FIELD(        """"""""" NC
              NAME  = 'Authorization'
              VALUE = |Bearer { LV_TOKEN }| ).

            LO_CLIENT->REQUEST->APPEND_CDATA(
              EXPORTING
                DATA = LV_JSON              " Character data
            ).

            LO_CLIENT->SEND( TIMEOUT = IF_HTTP_CLIENT=>CO_TIMEOUT_DEFAULT ).

            CALL METHOD LO_CLIENT->RECEIVE
              EXCEPTIONS
                HTTP_COMMUNICATION_FAILURE = 1
                HTTP_INVALID_STATE         = 2
                HTTP_PROCESSING_FAILED     = 3.

            IF SY-SUBRC = 0.
              RESULT = LO_CLIENT->RESPONSE->GET_CDATA( ).

              /UI2/CL_JSON=>DESERIALIZE(
                EXPORTING
                  JSON = RESULT              " JSON string
                CHANGING
                  DATA = WA_RES_API                 " Data to serialize
              ).
            ELSE.
              RESULT = LO_CLIENT->RESPONSE->GET_CDATA( ).
              REFRESH RESULT_TAB .
              SPLIT RESULT AT CL_ABAP_CHAR_UTILITIES=>CR_LF INTO TABLE RESULT_TAB .
            ENDIF.
          ENDIF.
*        CALL FUNCTION 'ECATT_CONV_XSTRING_TO_STRING'
*          EXPORTING
*            IM_XSTRING = GV_RESULT
**           IM_ENCODING       = 'UTF-8'
*          IMPORTING
*            EX_STRING  = LV_RESULT.
*        EXPORT LW_FINAL FROM LW_FINAL TO   MEMORY ID 'LW_FINAL'.
          LO_CLIENT->CLOSE( ).
        CATCH CX_ROOT INTO DATA(E_TEXT).
          WRITE E_TEXT->GET_TEXT( ).
      ENDTRY.

*
      WA_RES-MANDT             = SY-MANDT                 .
      WA_RES-CUSTUNIQREF       = WA_PAY-CUSTUNIQREF       .
      WA_RES-REQUESTUUID       = WA_RES_API-REQUESTUUID   .
      WA_RES-STATUS            = WA_RES_API-STATUS        .
      WA_RES-CRE_DATE          = SY-DATUM                 .
      WA_RES-CRE_TIME          = SY-TIMLO                 .
      WA_RES-USER_ID           = SY-UNAME                 .
      WA_RES-BELNR             = WA_AL-BELNR              .
      WA_RES-GJAHR             = WA_AL-FIS_YR             .
      WA_RES-BUKRS             = S_BUKRS                  .

      WA_RES-CUSTUNIQREF       = WA_PAY-CUSTUNIQREF       .
      WA_RES-VALUEDATE         = WA_PAY-VALUEDATE         .
      WA_RES-TXNAMOUNT         = WA_PAY-TXNAMOUNT         .
      WA_RES-BENENAME          = WA_PAY-BENENAME          .
      WA_RES-BENECODE          = WA_PAY-BENECODE          .
      WA_RES-BENEACCNUM        = WA_PAY-BENEACCNUM        .
      WA_RES-BENEIFSCCODE      = WA_PAY-BENEACTYPE        .
      WA_RES-BENEBANKNAME      = WA_PAY-BENEBANKNAME      .                .
      WA_RES-BENEEMAILADDR1    = WA_PAY-BENEEMAILADDR1    .

      WA_RES-BENEIFSCCODE      = WA_PAY-BENEIFSCCODE      .
      WA_RES-BENEMOBILENO      = WA_PAY-BENEMOBILENO      .
      WA_RES-MESSAGE           = WA_RES_API-MESSAGE       .

      IF WA_RES-MESSAGE IS INITIAL .
        WA_RES-MESSAGE   = RESULT .
      ENDIF.

*      wa_res-statusDescription    = WA_PAY-     .
*      wa_res-batchNo              = WA_PAY-     .
*      wa_res-utrNo                = WA_PAY-r   .
*      wa_res-processingDate       = WA_PAY-     .
*      wa_res-responseCode         = WA_PAY-     .
*      wa_res-crn                  = WA_PAY-     .


      IF WA_RES-STATUS NE 'S'.

        CONDENSE WA_RES-STATUS NO-GAPS.

        CASE WA_RES-STATUS.
          WHEN '400'.
            WA_AL-STATUS = '400' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Bad Request' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.

          WHEN '401'.
            WA_AL-STATUS = '401' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Unauthorised Request' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.

          WHEN '403'.
            WA_AL-STATUS = '403' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Forbidden/Authentication Failed' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.

          WHEN '404'.
            WA_AL-STATUS = '404' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Not Found' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.

          WHEN '429'.
            WA_AL-STATUS = '429' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Too Many Request' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.

          WHEN '500'.
            WA_AL-STATUS = '500' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Internal Server Error' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.

          WHEN '502'.
            WA_AL-STATUS = '502' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Bad Gateway' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.


          WHEN '503'.
            WA_AL-STATUS = '503' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Service Unavailable ' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.

          WHEN '504'.
            WA_AL-STATUS = '504' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = 'Gateway Timeout' .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.


          WHEN OTHERS.
            WA_AL-STATUS = 'ERROR' .
            WA_AL-LINE_COLOR = 'C600' .
            WA_AL-MESSAGE = WA_RES_API-MESSAGE .
            MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE
                                               WHERE BELNR   = WA_TT-PAY_DOC_NO
                                                AND  FIS_YR  = WA_TT-GJAHR.
        ENDCASE.


      ELSEIF   WA_RES-STATUS  = 'S'.
        WA_AL-STATUS = 'SUCCESS' .
        WA_AL-MESSAGE = WA_RES_API-MESSAGE .

        IF  WA_PAY-TXNAMOUNT =< 200000.
          WA_AL-PAY_TYPE = 'NEFT' .
        ELSE.
          WA_AL-PAY_TYPE = 'RTGS' .
        ENDIF .

        MODIFY  IT_ALV_DISPLAY FROM WA_AL TRANSPORTING STATUS LINE_COLOR MESSAGE PAY_TYPE
                                             WHERE BELNR   = WA_TT-PAY_DOC_NO
                                              AND  FIS_YR  = WA_TT-GJAHR.
      ENDIF.



      MODIFY ZAXIS_RES_API  FROM WA_RES .

      CLEAR : WA_RES , WA_RES_API , WA_TT , WA_FINAL , LV_JSON, WA_AL,WA_PAY,
              WA_SUBHEADER,WA_PAYMENTREQUEST,WA_BODY_ENC, WA_BODY_ENC-PAYMENTDETAILS .
      REFRESH :  WA_BODY_ENC-PAYMENTDETAILS , IT_PAY ,IT_INV_DET.
    ENDIF.
  ENDLOOP .


ENDFORM.
