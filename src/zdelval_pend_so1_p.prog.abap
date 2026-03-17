*&---------------------------------------------------------------------*
*& Report ZDELVAL_PEND_SO1_P
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDELVAL_PEND_SO1_P.


TYPES : BEGIN OF TY_VBAK,
          VBELN       TYPE VBAK-VBELN,
          ERDAT       TYPE VBAK-ERDAT,
          AUART       TYPE VBAK-AUART,
          VKORG       TYPE VBAK-VKORG,      "ADDED BY AAKASHK 19.08.2024
          VTWEG       TYPE VBAK-VTWEG,      "ADDED BY AAKASHK 19.08.2024
          SPART       TYPE VBAK-SPART,      "ADDED BY AAKASHK 19.08.2024
          LIFSK       TYPE VBAK-LIFSK,
          WAERK       TYPE VBAK-WAERK,
          VKBUR       TYPE VBAK-VKBUR,
          KNUMV       TYPE VBAK-KNUMV,
          VDATU       TYPE VBAK-VDATU,
          BSTDK       TYPE VBAK-BSTDK,
          KUNNR       TYPE VBAK-KUNNR,
          OBJNR       TYPE VBAK-OBJNR,            "added by pankaj 04.02.2022
          ZLDFROMDATE TYPE VBAK-ZLDFROMDATE,
          ZLDPERWEEK  TYPE VBAK-ZLDPERWEEK,
          ZLDMAX      TYPE VBAK-ZLDMAX,
          FAKSK       TYPE VBAK-FAKSK,
        END OF TY_VBAK,
        BEGIN OF TY_VBAP,
          VBELN           TYPE VBAP-VBELN,
          POSNR           TYPE VBAP-POSNR,
          MATNR           TYPE VBAP-MATNR,
          ARKTX           TYPE VBAP-ARKTX,
          ABGRU           TYPE VBAP-ABGRU,
          POSEX           TYPE VBAP-POSEX,
          KDMAT           TYPE VBAP-KDMAT,
          WAERK           TYPE VBAP-WAERK,
          KWMENG          TYPE VBAP-KWMENG,
          WERKS           TYPE VBAP-WERKS,
          NTGEW           TYPE VBAP-NTGEW,          "added by pankaj 28.01.2022
          OBJNR           TYPE VBAP-OBJNR,
          HOLDDATE        TYPE VBAP-HOLDDATE,
          HOLDRELDATE     TYPE VBAP-HOLDRELDATE,
          CANCELDATE      TYPE VBAP-CANCELDATE,
          DELDATE         TYPE VBAP-DELDATE,
          CUSTDELDATE     TYPE VBAP-CUSTDELDATE,
          ZGAD            TYPE VBAP-ZGAD,
          CTBG            TYPE VBAP-CTBG,  " ADDED BY AJAY
          RECEIPT_DATE    TYPE VBAP-RECEIPT_DATE,          "added by pankaj 28.01.2022
          REASON          TYPE VBAP-REASON,                "added by pankaj 28.01.2022
          OFM_DATE        TYPE VBAP-OFM_DATE,                "added by pankaj 01.02.2022
          ERDAT           TYPE VBAP-ERDAT,
          ZINS_LOC        TYPE VBAP-ZINS_LOC,                   ""ADDED  BY MA ON 27.03.2024
          LGORT           TYPE VBAP-LGORT,
          ZMRP_DATE       TYPE VBAP-ZMRP_DATE, "added b yjyoti on 02.07.2024
          ZEXP_MRP_DATE1  TYPE VBAP-ZEXP_MRP_DATE1, "Added by jyoti on 13.11.2024
          ZHOLD_REASON_N1 TYPE VBAP-ZHOLD_REASON_N1, "added by jyoti on 06.02.2025
        END OF TY_VBAP,

        BEGIN OF TY_KONV,
          KNUMV TYPE  PRCD_ELEMENTS-KNUMV,
          KPOSN TYPE  PRCD_ELEMENTS-KPOSN,
          KSCHL TYPE  PRCD_ELEMENTS-KSCHL,
          KBETR TYPE  PRCD_ELEMENTS-KBETR,
          WAERS TYPE  PRCD_ELEMENTS-WAERS,
          KWERT TYPE  PRCD_ELEMENTS-KWERT,
        END OF TY_KONV.

TYPES: BEGIN OF TY_DATA,
         VBELN TYPE VBELN,
         POSNR TYPE POSNR,
         MATNR TYPE MATNR,    "edited by PJ 16-08-21
         LGORT TYPE VBAP-LGORT,    "edited by pranit 10.06.2024
         LFSTA TYPE VBUP-LFSTA,
         LFGSA TYPE VBUP-LFGSA,
         FKSTA TYPE VBUP-FKSTA,
         ABSTA TYPE VBUP-ABSTA,
         GBSTA TYPE VBUP-GBSTA,
*         WERKS TYPE WERKS,
       END OF TY_DATA.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
TYPES : BEGIN OF OUTPUT,
          WERKS           TYPE WERKS_EXT,
          AUART           TYPE VBAK-AUART,
*          vkorg         type vbak-vkorg,      "added by aakashk 19.08.2024    eveng
*          vtweg         type vbak-vtweg,      "added by aakashk 19.08.2024
*          spart         type vbak-spart,      "added by aakashk 19.08.2024
          BSTKD           TYPE VBKD-BSTKD,
          NAME1           TYPE KNA1-NAME1,
          VKBUR           TYPE VBAK-VKBUR,
          VBELN           TYPE VBAK-VBELN,
          ERDAT           TYPE VBAK-ERDAT,
          VDATU           TYPE VBAK-VDATU,
          STATUS          TYPE TEXT30,
          HOLDDATE        TYPE VBAP-HOLDDATE,
          RELDATE         TYPE VBAP-HOLDRELDATE,
          CANCELDATE      TYPE VBAP-CANCELDATE,
          DELDATE         TYPE VBAP-DELDATE,
*          tag_req      TYPE char20,
          TAG_REQ         TYPE CHAR50,          "changed by sr on 03.05.2021
*         ld 5 fields
*          tpi          TYPE char20,
          TPI             TYPE CHAR50,           "changed by sr on 03.05.2021
*          ld_txt       TYPE char20,
          LD_TXT          TYPE CHAR50,           "changed by sr on 03.05.2021
          ZLDPERWEEK      TYPE ZLDPERWEEK1,
          ZLDMAX          TYPE VBAK-ZLDMAX,
          ZLDFROMDATE     TYPE VBAK-ZLDFROMDATE,

********
          MATNR           TYPE VBAP-MATNR,
          POSNR           TYPE VBAP-POSNR,
          ARKTX           TYPE VBAP-ARKTX,
          KWMENG          TYPE VBAP-KWMENG,
          STOCK_QTY       TYPE MSKA-KALAB,
*          kalab       TYPE mska-kalab,
          LFIMG           TYPE LIPS-LFIMG,
          FKIMG           TYPE VBRP-FKIMG,
          PND_QTY         LIKE VBRP-FKIMG,
          ETTYP           TYPE VBEP-ETTYP,
          MRP_DT          TYPE UDATE,
          EDATU           TYPE VBEP-EDATU,
*          kbetr         TYPE prcd_elements-kbetr,
          KBETR           TYPE  P DECIMALS 2,
          WAERK           TYPE VBAP-WAERK,
          CURR_CON        TYPE P DECIMALS 2,
*          curr_con      TYPE ukursp,
*          amont         TYPE char250,             "kbetr,
          AMONT           TYPE CHAR70,             "kbetr,
*          ordr_amt      TYPE char250,             "kbetr,
          ORDR_AMT        TYPE CHAR70,             "kbetr,
*          in_price      TYPE prcd_elements-kbetr,
          IN_PRICE        TYPE P DECIMALS 2,
          IN_PR_DT        TYPE VBAP-ZEXP_MRP_DATE1,
*          in_pr_dt      TYPE prcd_elements-kdatu,
          EST_COST        TYPE PRCD_ELEMENTS-KBETR,
          LATST_COST      TYPE PRCD_ELEMENTS-KBETR,
          ST_COST         TYPE MBEW-STPRS,
          ZSERIES         TYPE MARA-ZSERIES,
          ZSIZE           TYPE MARA-ZSIZE,
          BRAND           TYPE MARA-BRAND,
          MOC             TYPE MARA-MOC,
          TYPE            TYPE MARA-TYPE,

          """"""""   Added By KD 04.05.2017    """""""
          DISPO           TYPE MARC-DISPO,
          WIP             TYPE VBRP-FKIMG,
          MTART           TYPE MARA-MTART,
          KDMAT           TYPE VBAP-KDMAT,
          KUNNR           TYPE KNA1-KUNNR,
          QMQTY           TYPE MSKA-KAINS,
          MATTXT          TYPE TEXT100,
          ITMTXT          TYPE CHAR255,
          ETENR           TYPE VBEP-ETENR,
          SCHID           TYPE STRING,       "added by aakashk 20.08.2024
*          schid(25),
*          so_exc        TYPE ukursp,
          SO_EXC          TYPE P DECIMALS 2,
          ZTERM           TYPE VBKD-ZTERM,
          TEXT1           TYPE T052U-TEXT1,
          INCO1           TYPE VBKD-INCO1,
          INCO2           TYPE VBKD-INCO2,
          OFM             TYPE CHAR50,
          OFM_DATE        TYPE CHAR50,
          CUSTDELDATE     TYPE VBAP-CUSTDELDATE,
          REF_DT          TYPE SY-DATUM,

          """"""""""""""""""""""""""""""""""""""""""""
          ABGRU           TYPE  VBAP-ABGRU,            " avinash bhagat 20.12.2018
          BEZEI           TYPE  TVAGT-BEZEI,         " avinash bhagat 20.12.2018
          WRKST           TYPE  MARA-WRKST,
          CGST            TYPE  CHAR4,
          SGST            TYPE  CHAR4,
          IGST            TYPE  CHAR4,
          SHIP_KUNNR      TYPE KUNNR,            "ship to party code
          SHIP_KUNNR_N    TYPE AD_NAME1,         "ship to party desctiption
          SHIP_REG_N      TYPE BEZEI,            ""ship to party gst region description
          SOLD_REG_N      TYPE BEZEI,             "sold to party gst region description
          NORMT           TYPE MARA-NORMT,
          SHIP_LAND       TYPE VBPA-LAND1,
          S_LAND_DESC     TYPE T005T-LANDX50,
          SOLD_LAND       TYPE VBPA-LAND1,
          POSEX           TYPE VBAP-POSEX,
          BSTDK           TYPE CHAR11, "vbap-ZEXP_MRP_DATE1,"vbak-bstdk,
          LIFSK           TYPE VBAK-LIFSK,
          VTEXT           TYPE TVLST-VTEXT,
          INSUR           TYPE CHAR250,
          PARDEL          TYPE CHAR250,
          GAD             TYPE CHAR250,
          US_CUST         TYPE CHAR250,
          TCS(11)         TYPE P DECIMALS 3,
          TCS_AMT         TYPE PRCD_ELEMENTS-KWERT,
          SPL             TYPE CHAR255,
          PO_DEL_DATE     TYPE CHAR11, "vbap-ZEXP_MRP_DATE1,",vbap-custdeldate,
          OFM_NO          TYPE CHAR128,
          CTBG            TYPE CHAR10,            "added by sr on 03.05.2021 ctbgi details
          CERTIF          TYPE CHAR255,             "added by sr on 03.05.2021 certification details
          ITEM_TYPE       TYPE MARA-ITEM_TYPE, " edited by PJ on 16-08-21
          REF_TIME        TYPE CHAR10,          " edited by PJ on 08-09-21
          PROJ            TYPE CHAR255,                         "added by pankaj 28.01.2022
          COND            TYPE CHAR255,                       "added by pankaj 28.01.2022
          RECEIPT_DATE    TYPE VBAP-RECEIPT_DATE,          "added by pankaj 28.01.2022
          REASON          TYPE CHAR50,                "added by pankaj 28.01.2022
          NTGEW           TYPE VBAP-NTGEW,          "added by pankaj 28.01.2022
          ZPR0            TYPE P DECIMALS 2, "kwert,              "added by pankaj 28.01.2022
          ZPF0            TYPE KWERT,              "added by pankaj 28.01.2022
          ZIN1            TYPE KWERT,              "added by pankaj 28.01.2022
          ZIN2            TYPE KWERT,             "added by pankaj 28.01.2022
          JOIG            TYPE KWERT,              "added by pankaj 28.01.2022
          JOCG            TYPE KWERT,              "added by pankaj 28.01.2022
          JOSG            TYPE KWERT,                "added by pankaj 28.01.2022
          DATE            TYPE VBEP-EDATU,
          PRSDT           TYPE VBKD-PRSDT,
          PACKING_TYPE    TYPE CHAR255,
*          ofm_date1     TYPE char250,  "vbap-ofm_date,
          OFM_DATE1       TYPE CHAR50, "vbap-ZEXP_MRP_DATE1,  "vbap-ofm_date,
          MAT_TEXT        TYPE CHAR15,
          INFRA           TYPE CHAR255,         "added by pankaj 31.01.2022
          VALIDATION      TYPE CHAR255,         "added by pankaj 31.01.2022
          REVIEW_DATE     TYPE CHAR255,         "added by pankaj 31.01.2022   b
          DISS_SUMMARY    TYPE CHAR255,        "added by pankaj 31.01.2022
          CHANG_SO_DATE   TYPE VBAP-ERDAT,
          """""""" added by pankaj 04.02.2022
          PORT            TYPE ADRC-NAME1,
          FULL_PMNT       TYPE CHAR255,
          ACT_ASS         TYPE TVKTT-VTEXT,
          TXT04           TYPE TJ30T-TXT04,
          FREIGHT         TYPE CHAR128,
          PO_SR_NO        TYPE CHAR128,
          UDATE           TYPE CHAR15,            "cdhdr-udate,
          BOM             TYPE MARA-BOM,
          ZPEN_ITEM       TYPE MARA-ZPEN_ITEM,
          ZRE_PEN_ITEM    TYPE MARA-ZRE_PEN_ITEM,
          ZINS_LOC        TYPE VBAP-ZINS_LOC,
          BOM_EXIST       TYPE CHAR5,
          POSEX1          TYPE VBAP-POSEX, "adde by jyoti on 16.04.2024
          LGORT           TYPE VBAP-LGORT, "aded by jyoti 11.06.2024
          QUOTA_REF       TYPE CHAR128, "added by jyoti on19.06.2024
          ZMRP_DATE       TYPE VBAP-ZMRP_DATE, "Added by jyoti on 02.07.2024
          VKORG           TYPE VBAK-VKORG,    "ADDED BY AAKASHK 19.08.2024
          VTWEG           TYPE VBAK-VTWEG,    "ADDED BY AAKASHK 19.08.2024
          SPART           TYPE VBAK-SPART,     "ADDED BY AAKASHK 19.08.2024
          ZEXP_MRP_DATE1  TYPE VBAP-ZEXP_MRP_DATE1, "Added by jyoti on 13.11.2024
          SPECIAL_COMM    TYPE CHAR250,
          ZCUST_PROJ_NAME TYPE CHAR250, "added by jyoti on 04.12.2024
          AMENDMENT_HIS   TYPE CHAR250, "added by jyoti on 20.01.2025
          PO_DIS          TYPE CHAR250, "added by jyoti on 20.01.2025
          ZHOLD_REASON_N1 TYPE VBAP-ZHOLD_REASON_N1, "added by jyoti on 06.02.2025
          STOCK_QTY_KTPI  TYPE MSKA-KALAB, "ADDED BY JYOTI ON 28.03.2025
          STOCK_QTY_TPI1  TYPE MSKA-KALAB,   "ADDED BY JYOTI ON 28.03.2025
          KURST           TYPE KNVV-KURST, "added by jypoti on 31.03.2025
          OFM_REC_DATE    TYPE CHAR255,
          OSS_REC_DATE    TYPE CHAR255,
          SOURCE_REST     TYPE CHAR255,
          SUPPL_REST      TYPE CHAR255,
          CUST_MAT_DESC   TYPE CHAR255,
        END OF OUTPUT.


DATA: IT_VBAK     TYPE TABLE OF TY_VBAK,
      WA_VBAK     TYPE TY_VBAK,
      IT_DATA     TYPE STANDARD TABLE OF TY_DATA,
      IT_VBAP     TYPE TABLE OF TY_VBAP,
      WA_VBAP     TYPE TY_VBAP,
      IT_KONV     TYPE TABLE OF TY_KONV,
      WA_KONV     TYPE  TY_KONV,
      WA_JEST1    TYPE JEST,
      WA_OUTPUT   TYPE OUTPUT,
      LS_DATA     TYPE TY_DATA,
      WA_DATA     TYPE TY_DATA,
      SND_JOBS    TYPE I,
      RCV_JOBS    TYPE I,
      IT_OUTPUT   TYPE  TABLE OF OUTPUT,
      IT_OUTPUT1  TYPE  TABLE OF OUTPUT,
      TASKNAME(8) TYPE C.

DATA: LV_PER_CHUNK TYPE I,
      LV_INDEX     TYPE I VALUE 0,
      LV_REMAINDER TYPE I,
      MESS         TYPE C LENGTH 80,
      EXC_FLAG     TYPE I,
      LV_XML       TYPE  STRING.

DATA: S_VBE TYPE TABLE OF RANGE_VBELN WITH HEADER LINE.
DATA: S_KUN TYPE TABLE OF VDKUNNR_RANGE WITH HEADER LINE.
DATA: S_MAT TYPE TABLE OF RSMATNR WITH HEADER LINE.
CONSTANTS: DONE(1) TYPE C VALUE 'X'.
DATA: FUNCTIONCALL1(1) TYPE C.

FIELD-SYMBOLS:<FTABLE> TYPE TABLE.

DATA: IT_WPINFO TYPE TABLE OF  WPINFO .



SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .
    SELECT-OPTIONS   :  S_DATE FOR WA_VBAK-ERDAT OBLIGATORY ,
                        S_MATNR FOR WA_VBAP-MATNR,
                        S_KUNNR FOR WA_VBAK-KUNNR,
                        S_VBELN FOR WA_VBAP-VBELN.
  SELECTION-SCREEN END OF BLOCK B2.
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-002.
  PARAMETERS OPEN_SO  RADIOBUTTON GROUP CODE DEFAULT 'X' USER-COMMAND CODEGEN.
  PARAMETERS ALL_SO  RADIOBUTTON GROUP CODE.
SELECTION-SCREEN END OF BLOCK B3.

SELECT-OPTIONS:  S_KSCHL   FOR  WA_KONV-KSCHL NO-DISPLAY .
SELECT-OPTIONS:  S_STAT   FOR  WA_JEST1-STAT NO-DISPLAY .

SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B4 WITH FRAME TITLE TEXT-075.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN COMMENT /1(70) TEXT-077.
  SELECTION-SCREEN COMMENT /1(70) TEXT-078.
  SELECTION-SCREEN COMMENT /1(70) TEXT-079.
SELECTION-SCREEN: END OF BLOCK B4.


DATA WA_KSCHL LIKE S_KSCHL.
DATA: WA_JEST  LIKE S_STAT,
      INDEX(3) TYPE C.

DATA : SYSTEM      TYPE RZLLI_APCL.

START-OF-SELECTION.
  CLEAR: WA_KSCHL , WA_JEST.
  IF OPEN_SO = 'X'.

    SELECT   A~VBELN
             A~POSNR
             A~MATNR
             A~LGORT
             A~LFSTA
             A~LFGSA
*             a~fksta
             A~FKSAA
             A~ABSTA
             A~GBSTA
      INTO TABLE IT_DATA
      FROM  VBAP AS A
*    JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
*    JOIN  vbak AS C ON a~vbeln = c~vbeln
      WHERE A~ERDAT  IN S_DATE
*    WHERE C~AUDAT  IN S_DATE
      AND   A~MATNR  IN S_MATNR
      AND   A~VBELN  IN S_VBELN         "SHREYAS
      AND   A~LFSTA  NE 'C'
      AND   A~LFGSA  NE 'C'
*    AND   a~fksta  NE 'C'
    AND   A~FKSAA  NE 'C'
      AND   A~GBSTA  NE 'C'.

*    LOOP AT it_data INTO ls_data.
*      IF ls_data-absta = 'C'.
*        IF ls_data-lfsta = ' ' AND ls_data-lfgsa = ' ' AND ls_data-fksta = ' ' AND ls_data-gbsta = ' '.
*          IF sy-subrc = 0.
**            delete it_data[] from ls_data.
*            DELETE it_data[]  WHERE vbeln = ls_data-vbeln AND posnr = ls_data-posnr.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.


  ELSEIF ALL_SO = 'X'.

    SELECT  VBELN
            ERDAT
            AUART
            VKORG "ADDED BY AAKASHK 19.08.2024
            VTWEG  "ADDED BY AAKASHK 19.08.2024
            SPART "ADDED BY AAKASHK 19.08.2024
            LIFSK
            WAERK
            VKBUR
            KNUMV
            VDATU
            BSTDK
            KUNNR
            OBJNR              "added by pankaj 04.02.2022
            ZLDFROMDATE
            ZLDPERWEEK
            ZLDMAX
*           faksk

            FROM VBAK INTO TABLE IT_VBAK
                                           WHERE ERDAT IN S_DATE AND
                                                 VBELN IN S_VBELN AND "shreyas
                                                 KUNNR IN S_KUNNR . "shreyas.
*                                                bukrs_vf = 'PL01'.


  ENDIF.


  IF OPEN_SO = 'X'.

    DESCRIBE TABLE IT_DATA LINES DATA(LV_LINES).

    LV_PER_CHUNK = LV_LINES DIV 10.
    LV_REMAINDER = LV_LINES MOD 10.
    IF LV_PER_CHUNK = 0.
      LV_PER_CHUNK = 1.
    ENDIF.

    SYSTEM = 'parallel_generators'.
    CLEAR : WA_DATA .


    DELETE ADJACENT DUPLICATES FROM IT_DATA  COMPARING VBELN .

    LOOP AT  IT_DATA INTO   WA_DATA .
      LV_INDEX =  LV_INDEX + 1.
      S_VBE-SIGN = 'I'.
      S_VBE-OPTION = 'EQ'.
      S_VBE-LOW = WA_DATA-VBELN.
      APPEND S_VBE.

*      S_MAT-SIGN = 'I'.
*      S_MAT-OPTION = 'EQ'.
*      S_MAT-LOW = WA_DATA-MATNR.
*      APPEND S_MAT.

      IF ( LV_INDEX MOD LV_PER_CHUNK = 0 AND LV_INDEX < LV_LINES )  OR ( LV_INDEX = LV_LINES ).
        INDEX = INDEX + 1.
        CONCATENATE 'Task' INDEX INTO TASKNAME. " Generate Unique Task Name

        CALL FUNCTION 'ZFM_DELVAL_PEND_SO1'
          STARTING NEW TASK TASKNAME
          DESTINATION 'NONE'
          PERFORMING PROCESS_PARALLEL ON END OF TASK
          EXPORTING
            P_HIDDEN              = TASKNAME
            P_ALL_SO              = ALL_SO
            P_OPEN_SO             = OPEN_SO
          TABLES
            VBELN                 = S_VBE
            KUNNR                 = S_KUN
            ERDAT                 = S_DATE
            MATNR                 = S_MAT
          EXCEPTIONS
            SYSTEM_FAILURE        = 1 MESSAGE MESS
            COMMUNICATION_FAILURE = 2 MESSAGE MESS
            RESOURCE_FAILURE      = 3.
        CASE SY-SUBRC.
          WHEN 0.
            SND_JOBS = SND_JOBS + 1.
          WHEN 1 OR 2.
            MESSAGE MESS TYPE 'I'.
          WHEN 3.
            IF SND_JOBS >= 1 AND
            EXC_FLAG = 0.
              EXC_FLAG = 1.
              WAIT UNTIL RCV_JOBS >= SND_JOBS UP TO 10 SECONDS.
            ENDIF.

            IF SY-SUBRC = 0.
              EXC_FLAG = 0.
            ELSE.
              MESSAGE 'Resource failure' TYPE 'I'.
            ENDIF.
          WHEN OTHERS.
            MESSAGE 'Other error' TYPE 'I'.
        ENDCASE.

        CLEAR : WA_VBAK, S_VBE, S_VBE[],   S_KUN , S_KUN[],S_MAT[] .
      ENDIF.
    ENDLOOP .

  ELSE.
    CLEAR : LV_LINES .
    DESCRIBE TABLE IT_VBAK LINES  LV_LINES .

    LV_PER_CHUNK = LV_LINES DIV 10.
    LV_REMAINDER = LV_LINES MOD 10.
    IF LV_PER_CHUNK = 0.
      LV_PER_CHUNK = 1.
    ENDIF.

**********************************************************************************
* RFC Server Group created from transaction RZ12
* It will be the config for Parallel processing.
* We can keep it as DEFAULT. In our case it is 'parallel_generators'
**********************************************************************************

    SYSTEM = 'parallel_generators'.

    LOOP AT IT_VBAK INTO WA_VBAK .

      LV_INDEX =  LV_INDEX + 1.
      S_VBE-SIGN = 'I'.
      S_VBE-OPTION = 'EQ'.
      S_VBE-LOW = WA_VBAK-VBELN.
      APPEND S_VBE.

      S_KUN-SIGN = 'I'.
      S_KUN-OPTION = 'EQ'.
      S_KUN-LOW = WA_VBAK-KUNNR.
      APPEND S_KUN.

      IF ( LV_INDEX MOD LV_PER_CHUNK = 0 AND LV_INDEX < LV_LINES )  OR ( LV_INDEX = LV_LINES ).
        INDEX = INDEX + 1.
        CONCATENATE 'Task' INDEX INTO TASKNAME. " Generate Unique Task Name

        CALL FUNCTION 'ZFM_DELVAL_PEND_SO1'
          STARTING NEW TASK TASKNAME
*          DESTINATION IN GROUP system
*          DESTINATION IN GROUP 390
          DESTINATION 'NONE'
          PERFORMING PROCESS_PARALLEL ON END OF TASK
          EXPORTING
            P_HIDDEN              = TASKNAME
            P_ALL_SO              = ALL_SO
            P_OPEN_SO             = OPEN_SO
          TABLES
            VBELN                 = S_VBE
            KUNNR                 = S_KUN
            ERDAT                 = S_DATE
          EXCEPTIONS
            SYSTEM_FAILURE        = 1 MESSAGE MESS
            COMMUNICATION_FAILURE = 2 MESSAGE MESS
            RESOURCE_FAILURE      = 3.
        CASE SY-SUBRC.
          WHEN 0.
            SND_JOBS = SND_JOBS + 1.
          WHEN 1 OR 2.
            MESSAGE MESS TYPE 'I'.
          WHEN 3.
            IF SND_JOBS >= 1 AND
            EXC_FLAG = 0.
              EXC_FLAG = 1.
              WAIT UNTIL RCV_JOBS >= SND_JOBS UP TO 10 SECONDS.
            ENDIF.

            IF SY-SUBRC = 0.
              EXC_FLAG = 0.
            ELSE.
              MESSAGE 'Resource failure' TYPE 'I'.
            ENDIF.
          WHEN OTHERS.
            MESSAGE 'Other error' TYPE 'I'.
        ENDCASE.

        CLEAR : WA_VBAK, S_VBE,S_VBE[] , S_KUN , S_KUN[] .
      ENDIF.
    ENDLOOP.
  ENDIF .

  WAIT UNTIL RCV_JOBS >= SND_JOBS .

*  DATA: U_FILE1   TYPE STRING.
*  U_FILE1 = 'C:\Users\CAZ-MUM-STOCK02\OneDrive - Castaliaz Technologies Private Limited\Desktop\iteeem.XLS'.
*
*  CALL FUNCTION 'GUI_FILE_SAVE_DIALOG'
*    EXPORTING
*      WINDOW_TITLE      = 'STATUS RECORD FILE(.XLS OR .TXT)'
*      DEFAULT_EXTENSION = '.xls'
*    IMPORTING
*      FULLPATH          = U_FILE1.
*
*  CALL FUNCTION 'GUI_DOWNLOAD'
*    EXPORTING
*      FILENAME = U_FILE1
*      FILETYPE = 'ASC'
**     has_field_separator = 'X'
*    TABLES
*      DATA_TAB = IT_OUTPUT
*    EXCEPTIONS
*      OTHERS   = 22.
  IF OPEN_SO = 'X'.
    PERFORM DOWN_SET      IN PROGRAM ZDELVAL_PEND_SO1 TABLES IT_OUTPUT1  USING P_FOLDER.
  ELSEIF ALL_SO = 'X'.
    PERFORM DOWN_SET_ALL  IN PROGRAM ZDELVAL_PEND_SO1 TABLES IT_OUTPUT1  USING P_FOLDER.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  process_parallel
*&---------------------------------------------------------------------*
* Each task will execute “process_parallel” in a separate work process.
*----------------------------------------------------------------------
FORM PROCESS_PARALLEL USING TASKNAME.


  RCV_JOBS = RCV_JOBS + 1.

  RECEIVE RESULTS FROM FUNCTION 'ZFM_DELVAL_PEND_SO1'
    IMPORTING
     LV_JSON         = LV_XML
            .
  FUNCTIONCALL1 = DONE.

  IF LV_XML IS NOT INITIAL.
    CALL TRANSFORMATION ID
    SOURCE XML LV_XML
    RESULT MY_TABLE = IT_OUTPUT  .


    APPEND LINES OF IT_OUTPUT  TO IT_OUTPUT1 .
    CLEAR:IT_OUTPUT,LV_XML.
  ENDIF.
ENDFORM.
