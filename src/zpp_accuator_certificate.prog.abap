*&---------------------------------------------------------------------*
*& Report ZPP_ACCUATOR_CERTIFICATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPP_ACCUATOR_CERTIFICATE.

TYPES: BEGIN OF T_OBJK,
         OBKNR TYPE OBJK-OBKNR,
         SERNR TYPE OBJK-SERNR,
       END OF T_OBJK.

TYPES: BEGIN OF T_MARA,
         MATNR   TYPE MARA-MATNR,
         V_EXTWG TYPE MARA-EXTWG,
       END OF T_MARA.

TYPES: BEGIN OF T_MAKT,
         MATNR TYPE MAKT-MATNR,
         MAKTX TYPE MAKT-MAKTX,
       END OF T_MAKT,

       BEGIN OF T_AFRU,
         AUFNR TYPE AFRU-AUFNR,
         BUDAT TYPE AFRU-BUDAT,
       END OF T_AFRU.

TYPES: BEGIN OF T_MSEG,
         AUFNR TYPE MSEG-AUFNR,
         MATNR TYPE MSEG-MATNR,
         BWART TYPE MSEG-BWART,
         MENGE TYPE MSEG-MENGE,
         EBELN TYPE MSEG-EBELN,
         EBELP TYPE MSEG-EBELP,
       END OF T_MSEG. "vk

DATA:IT_MSEG TYPE STANDARD TABLE OF T_MSEG,
     WA_MSEG TYPE T_MSEG.

DATA:V_KUNAG        TYPE LIKP-KUNAG,
     V_POSNV        TYPE VBFA-POSNV, "coument by vk
     V_EBELP        TYPE EBELP, "vk
     V_AUFNR        TYPE AFPO-AUFNR,
     V_OBKNR        TYPE SER05-OBKNR,
     V_BRAND        TYPE MARA-BRAND,
     V_EXTWG        TYPE MARA-EXTWG,
     V_VBELN        TYPE LIKP-VBELN,
     V_POSNR        TYPE LIPS-POSNR,
     V_WERKS        TYPE LIPS-WERKS,
     V_NAME1        TYPE KNA1-NAME1,
     V_NAME2        TYPE KNA1-NAME2,
     V_BSTNK        TYPE VBAK-BSTNK,
     V_BSTDK        TYPE VBAK-BSTDK,
     V_FSERNR       TYPE OBJK-SERNR,
     V_FSERNR1      TYPE CHAR20,
     V_LSERNR1      TYPE CHAR20,
     V_LSERNR       TYPE OBJK-SERNR,
     V_LFIMG        TYPE LIPS-LFIMG,
     V_ZSIZE        TYPE MARA-ZSIZE,
     V_KDMAT        TYPE VBAP-KDMAT,
     V_ZEINR        TYPE MARA-ZEINR,
     V_VBELV        TYPE VBFA-VBELV,
     V_BODY         TYPE CHAR30,
     V_VALVE        TYPE CHAR30,
     V_STEM         TYPE CHAR30,
     V_SEAT         TYPE CHAR30,
     V_CLASS        TYPE CHAR30,
     V_ASUPPLY      TYPE CHAR30,
     V_AFAIL        TYPE CHAR30,
     V_SEAT_LEAKAGE TYPE CHAR30,
     V_SHELL_TEST   TYPE CHAR30,
     V_SEAT_TEST    TYPE CHAR30,
     V_PNEUMATIC    TYPE CHAR30,
     V_ACTUATOR     TYPE CHAR40,
     V_SOV          TYPE CHAR40,
     V_LSB          TYPE CHAR40,
     V_AFR          TYPE CHAR40,
     V_MOR          TYPE CHAR40,
     V_POS          TYPE CHAR40,
     V_MATNR        TYPE LIPS-MATNR,
     V_MAKTX        TYPE MAKT-MAKTX,
     V_ADRNR        TYPE T001W-ADRNR,
     V1_NAME1       TYPE ADRC-NAME1,
     V1_NAME2       TYPE ADRC-NAME2,
     V_NAME_CO      TYPE ADRC-NAME_CO,
     V_STR_SUPPL1   TYPE ADRC-STR_SUPPL1,
     V_STR_SUPPL2   TYPE ADRC-STR_SUPPL2,
     V_STREET       TYPE ADRC-STREET,
     V_CITY1        TYPE ADRC-CITY1,
     V_POST_CODE1   TYPE ADRC-POST_CODE1,
     V_TIME_ZONE    TYPE ADRC-TIME_ZONE,
     V_TEL_NUMBER   TYPE ADRC-TEL_NUMBER,
     V_FAX_NUMBER   TYPE ADRC-FAX_NUMBER,
     V_BUDAT        TYPE AFRU-BUDAT,
     V_LGORT        TYPE AFPO-LGORT,
     V_SERIES       TYPE MARA-ZSERIES.  " ADD ON 25/06/2024 BY SA
.

DATA:IT_OBJK TYPE STANDARD TABLE OF T_OBJK,
     WA_OBJK TYPE T_OBJK.

DATA:IT_MARA TYPE STANDARD TABLE OF T_MARA,
     WA_MARA TYPE T_MARA.

DATA:IT_MAKT TYPE STANDARD TABLE OF T_MAKT,
     WA_MAKT TYPE T_MAKT.

DATA:IT_AFRU TYPE STANDARD TABLE OF T_AFRU,
     WA_AFRU TYPE T_AFRU.

DATA:IT_FINAL TYPE STANDARD TABLE OF ZPP_COMPLIANCE,
     WA_FINAL TYPE ZPP_COMPLIANCE.

DATA: IT_STB TYPE STANDARD TABLE OF STPOX,
      WA_STB TYPE STPOX.

DATA : LWA_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS,
         LF_FM_NAME       TYPE FUNCNAME,
         LV_SFPDOCPARAMS  TYPE FPFORMOUTPUT,
         LWA_RESULT       TYPE SFPJOBOUTPUT,
         LT_PDFDATA       TYPE TABLE OF SOLIX.

DATA:FORMNAME TYPE TDSFNAME,
     CONTROL  TYPE SSFCTRLOP,        "CONTROL PARAMETERS
     OUT_OPT  TYPE SSFCOMPOP,
     RETURN1  TYPE SSFCRESCL,
     LENGTH   TYPE I,
     OTF1     TYPE TABLE OF ITCOO,
     LINES1   TYPE TABLE OF TLINE,
     F_PATH   TYPE IBIPPARMS-PATH.
DATA: V_FILE TYPE STRING,
      V_PATH TYPE STRING.

DATA: ALLOCVALUESNUM     TYPE STANDARD TABLE OF BAPI1003_ALLOC_VALUES_NUM,
      ALLOCVALUESCHAR    TYPE STANDARD TABLE OF BAPI1003_ALLOC_VALUES_CHAR,
      ALLOCVALUESCURR    TYPE STANDARD TABLE OF BAPI1003_ALLOC_VALUES_CURR,
      RETURN             TYPE STANDARD TABLE OF BAPIRET2,
      OBJECTKEY          TYPE BAPI1003_KEY-OBJECT,
      WA_ALLOCVALUESCHAR TYPE BAPI1003_ALLOC_VALUES_CHAR,
      CLASSNUM           LIKE BAPI1003_KEY-CLASSNUM.

***SELECTION SCREEN

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: P_VBELN TYPE LIPS-VBELN MODIF ID DEL NO-DISPLAY,
              R_PRD   RADIOBUTTON GROUP RAD1,
              P_AUFNR TYPE AFPO-AUFNR MODIF ID PRO,
              R_PO    RADIOBUTTON GROUP RAD1,
              P_PORDR TYPE MSEG-EBELN MODIF ID PO,
              P_POSNR TYPE MSEG-EBELP MODIF ID PO. "Vk
SELECTION-SCREEN : END OF BLOCK B1.

SELECTION-SCREEN: BEGIN OF BLOCK A WITH FRAME TITLE TEXT-001.
  PARAMETERS :P_ZDELSR TYPE ZPP_COMPLIANCE-ZDELSRNO.
  PARAMETERS: P_PATH   TYPE STRING.
SELECTION-SCREEN: END OF BLOCK A.



AT SELECTION-SCREEN OUTPUT.


  IF R_PRD = 'X'.
    LOOP AT SCREEN.
      CASE SCREEN-GROUP1.
        WHEN 'PRO'.
          SCREEN-INPUT = '1'.
          SCREEN-OUTPUT = '1'.
          SCREEN-INVISIBLE = '0'.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE SCREEN-GROUP1.
        WHEN 'DEL'.
          SCREEN-INPUT = '0'.
          SCREEN-OUTPUT = '0'.
          SCREEN-INVISIBLE = '1'.
          MODIFY SCREEN.

          CLEAR : P_PATH.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE SCREEN-GROUP1.
        WHEN 'PO'.
          SCREEN-INPUT = '0'.
          SCREEN-OUTPUT = '0'.
          SCREEN-INVISIBLE = '1'.
          MODIFY SCREEN.
          CLEAR :  P_PATH ,P_PORDR.
      ENDCASE.
    ENDLOOP.

  ENDIF.

  IF R_PO = 'X'.                                         "Addition Of logic for Purchase order Radio Button By Snehal Rajale on 4.02.2021

    LOOP AT SCREEN.
      CASE SCREEN-GROUP1.
        WHEN 'PO'.
          SCREEN-INPUT = '1'.
          SCREEN-OUTPUT = '1'.
          SCREEN-INVISIBLE = '0'.
          MODIFY SCREEN.
*          CLEAR :  p_path ,p_pordr.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE SCREEN-GROUP1.
        WHEN 'PRO'.
          SCREEN-INPUT = '0'.
          SCREEN-OUTPUT = '0'.
          SCREEN-INVISIBLE = '1'.
          CLEAR : P_AUFNR , P_PATH.
          MODIFY SCREEN.
      ENDCASE.
    ENDLOOP.

    LOOP AT SCREEN.
      CASE SCREEN-GROUP1.
        WHEN 'DEL'.
          SCREEN-INPUT = '0'.
          SCREEN-OUTPUT = '0'.
          SCREEN-INVISIBLE = '1'.
          MODIFY SCREEN.

          CLEAR : P_PATH.
      ENDCASE.
    ENDLOOP.

  ENDIF.

***********************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_PATH.
  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_SAVE_DIALOG
    EXPORTING
      DEFAULT_EXTENSION    = 'PDF'
      DEFAULT_FILE_NAME    = 'DOWNLOAD'
    CHANGING
      FILENAME             = V_FILE
      PATH                 = V_PATH
      FULLPATH             = P_PATH
    EXCEPTIONS
      CNTL_ERROR           = 1
      ERROR_NO_GUI         = 2
      NOT_SUPPORTED_BY_GUI = 3
      OTHERS               = 4.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
***********************************************************************
START-OF-SELECTION.
  IF P_AUFNR IS NOT INITIAL.
    PERFORM GET_DATA.
    PERFORM PROCESS_DATA.
    PERFORM DISPLAY_DATA.
  ELSEIF P_PORDR IS NOT INITIAL.
    PERFORM GET_DATA.
    PERFORM PROCESS_DATA.
    PERFORM DISPLAY_DATA.
  ELSE.
    MESSAGE 'Please Enter the valid input' TYPE 'E'.
  ENDIF.

***********************************************************************
FORM GET_DATA .

  IF P_AUFNR IS NOT INITIAL.
    SELECT SINGLE * FROM AUFK INTO @DATA(LV_AUFK) WHERE AUFNR = @P_AUFNR AND AUART IN ('ACT1','KACT','HDA1','KHDA' ).
    IF SY-SUBRC NE 0.
      MESSAGE 'This production order does not contain actuator' TYPE 'E'.
    ENDIF.
    SELECT SINGLE KDAUF KDPOS LGORT FROM AFPO INTO ( V_VBELV , V_POSNV , V_LGORT )
                                          WHERE AUFNR = P_AUFNR .
    IF SY-SUBRC NE 0.
      MESSAGE 'SALES ORDER NOT CREATED' TYPE 'E'.
    ENDIF.
    P_POSNR = V_EBELP .

    SELECT SINGLE BUDAT FROM AFRU INTO V_BUDAT
           WHERE AUFNR = P_AUFNR.

    " Selecting material and quantity from MSEG where movement type is 101
    DATA: V_MATNR_MSEG TYPE MSEG-MATNR,
          V_MENGE_MSEG TYPE MENGE_D,
          V_BUDAT_MSEG TYPE MSEG-BUDAT_MKPF.


    SELECT  MENGE , MATNR , BUDAT_MKPF , CPUDT_MKPF , CPUTM_MKPF FROM MSEG INTO TABLE @DATA(IT_MSEG)
              WHERE AUFNR = @P_AUFNR
              AND BWART = '101'.
    IF SY-SUBRC = 0.
      SORT IT_MSEG DESCENDING BY  BUDAT_MKPF  CPUDT_MKPF  CPUTM_MKPF.
      READ TABLE IT_MSEG INTO DATA(WA_MSEG) INDEX 1.
*    IF wa_mseg-menge = 0.
*      MESSAGE 'Production order not confirmed' TYPE 'E'.
*    ENDIF.
*    SELECT SINGLE * FROM mara INTO @DATA(wa_mara) WHERE matnr = @wa_mseg-matnr AND brand = 'ACT'.
*    IF sy-subrc NE 0.
*      MESSAGE 'WRONG BRAND' TYPE 'E'.
*    ENDIF.
      V_LFIMG = WA_MSEG-MENGE .
      V_MATNR = WA_MSEG-MATNR .
      V_BUDAT = WA_MSEG-BUDAT_MKPF .
    ELSE.
      SELECT SINGLE PLNBEZ FROM AFKO INTO V_MATNR WHERE AUFNR = P_AUFNR.
    ENDIF.
  ELSEIF P_PORDR IS NOT INITIAL.

****SELECTING SALES ORDER AND ITEM NO FROM VBFA
    IF  P_POSNR IS INITIAL.
      MESSAGE 'LINE ITEM EMPTY' TYPE 'E'.
    ENDIF.
    SELECT SINGLE VBELN VBELP
    FROM EKKN
    INTO (V_VBELV,
*    v_posnv)
    V_EBELP)
    WHERE EBELN = P_PORDR
      AND EBELP = P_POSNR. "vk
    IF SY-SUBRC NE 0.
      MESSAGE 'SALES ORDER NOT CREATED' TYPE 'E'.
    ENDIF.
*    p_posnr = v_ebelp .
*    p_posnr = v_posnv . "VK
    SELECT SINGLE BEDAT FROM EKKO INTO V_BUDAT
              WHERE EBELN = P_PORDR.

    SELECT  MENGE , MATNR , BUDAT_MKPF , CPUDT_MKPF , CPUTM_MKPF FROM MSEG INTO TABLE @IT_MSEG
           WHERE EBELN = @P_PORDR
           AND EBELP = @P_POSNR
           AND BWART = '101'.
    IF IT_MSEG IS NOT INITIAL.
      SORT IT_MSEG DESCENDING BY  BUDAT_MKPF  CPUDT_MKPF  CPUTM_MKPF.
      READ TABLE IT_MSEG INTO WA_MSEG INDEX 1.
      IF WA_MSEG-MENGE = 0.
        MESSAGE 'Purchase order not confirmed' TYPE 'E'.
      ENDIF.
      SELECT SINGLE * FROM MARA INTO @DATA(WA_MARA) WHERE MATNR = @WA_MSEG-MATNR AND BRAND = 'ACT'.
      IF SY-SUBRC NE 0.
        MESSAGE 'This purchase order & line item does not contain actuator' TYPE 'E'.
      ENDIF.
      V_LFIMG = WA_MSEG-MENGE .
      V_MATNR = WA_MSEG-MATNR .
      V_BUDAT = WA_MSEG-BUDAT_MKPF .
    ENDIF.

  ENDIF.
  SELECT SINGLE MAKTX
       FROM MAKT
       INTO V_MAKTX
       WHERE MATNR = V_MATNR
         AND SPRAS  = SY-LANGU.
  V_MATNR_MSEG = V_MATNR.



  SELECT SINGLE ZSIZE BRAND ZEINR ZSERIES AIR_PRESSURE AIR_FAIL
    FROM MARA
    INTO (V_ZSIZE,
          V_BRAND,
          V_ZEINR,
          V_SERIES,
          V_ASUPPLY,
          V_AFAIL)
    WHERE MATNR = V_MATNR_MSEG."v_matnr.
****SELECTING CUSTOMER PURCHASE ORDER NUMBER,CUSTOMER PURCHASE ORDER DATE
****FROM VBAK.
  IF V_VBELV IS NOT INITIAL.  " AND v_posnv IS NOT INITIAL.
*  IF v_vbelv IS NOT INITIAL AND v_ebelp IS NOT INITIAL. "vk
    SELECT SINGLE BSTNK BSTDK KUNNR
      FROM VBAK
      INTO (V_BSTNK,
            V_BSTDK,
            V_KUNAG)
      WHERE VBELN = V_VBELV.

***SELECTING  NAME OF SOLD-TO PARTY NO FROM KNA1
    IF SY-SUBRC = 0.
      SELECT SINGLE NAME1 NAME2
        FROM KNA1
        INTO (V_NAME1, V_NAME2)
        WHERE KUNNR = V_KUNAG.
    ENDIF.


  ENDIF.


ENDFORM.                    " GET_DATA
***********************************************************************
FORM PROCESS_DATA .
*****POPULATING DATA INTO IT_FINAL.
  CONDENSE V_MAKTX.
  WA_FINAL-NAME1 = V_NAME1.
  WA_FINAL-NAME2 = V_NAME2.
  WA_FINAL-BSTNK = V_BSTNK.
  WA_FINAL-BSTDK = V_BSTDK.
  WA_FINAL-FSERNR = V_FSERNR1.
  WA_FINAL-LSERNR = V_LSERNR1.
  WA_FINAL-LFIMG = V_LFIMG.
  WA_FINAL-ZSIZE = V_ZSIZE.
  WA_FINAL-KDMAT = V_KDMAT.
  WA_FINAL-ZEINR = V_ZEINR.
  WA_FINAL-VBELV = V_VBELV.
  WA_FINAL-POSNR = P_POSNR.
  WA_FINAL-BODY = V_BODY.
  WA_FINAL-VALVE = V_VALVE.
  WA_FINAL-STEM = V_STEM.
  WA_FINAL-SEAT = V_SEAT.
  WA_FINAL-CLASS = V_CLASS.
  WA_FINAL-ASUPPLY = V_ASUPPLY.
  WA_FINAL-AFAIL = V_AFAIL.
  WA_FINAL-SEAT_LEAKAGE = V_SEAT_LEAKAGE.
  WA_FINAL-SHELL_TEST = V_SHELL_TEST.
  WA_FINAL-SEAT_TEST = V_SEAT_TEST.
  WA_FINAL-PNEUMATIC = V_PNEUMATIC.
  WA_FINAL-ACTUATOR = V_ACTUATOR.
  WA_FINAL-SOV = V_SOV.
  WA_FINAL-LSB = V_LSB.
  WA_FINAL-AFR = V_AFR.
  WA_FINAL-MOR = V_MOR.
  WA_FINAL-POS = V_POS.
  WA_FINAL-MATNR = V_MATNR.
  WA_FINAL-MAKTX = V_MAKTX.
  WA_FINAL-V1_NAME1 = V1_NAME1.
  WA_FINAL-V_NAME_CO = V_NAME_CO.
  WA_FINAL-V_STR_SUPPL1 = V_STR_SUPPL1.
  WA_FINAL-V_STR_SUPPL2 = V_STR_SUPPL2.
  WA_FINAL-V_STREET = V_STREET.
  WA_FINAL-V_CITY1 = V_CITY1.
  WA_FINAL-V_POST_CODE1 = V_POST_CODE1.
  WA_FINAL-V_TIME_ZONE = V_TIME_ZONE.
  WA_FINAL-V_TEL_NUMBER = V_TEL_NUMBER.
  WA_FINAL-V_FAX_NUMBER = V_FAX_NUMBER.
  WA_FINAL-ZDELSRNO = P_ZDELSR.
*  wa_final-ztagno = p_ztagno.
*  wa_final-v_ebelp = v_ebelp.
  WA_FINAL-BUDAT = V_BUDAT.
  WA_FINAL-LGORT = V_LGORT.     " ADD ON 25/06/2024 BY SA
  WA_FINAL-V_SERIES = V_SERIES.     " ADD ON 14/05/2025 by Laxmi
  APPEND WA_FINAL TO IT_FINAL.

  CLEAR: WA_FINAL,WA_OBJK,WA_ALLOCVALUESCHAR,WA_MARA,WA_MAKT,WA_STB.
  CLEAR : V_KUNAG,V_POSNV,V_EBELP,V_AUFNR,V_OBKNR,V_MATNR,V_BRAND,V_EXTWG,V_VBELN,V_POSNR,V_NAME1,V_WERKS,V_BSTNK,
          V_BSTDK,V_FSERNR, V_LSERNR,V_LFIMG,V_ZSIZE,V_KDMAT,V_ZEINR,V_VBELV,V_BODY,V_VALVE,V_STEM,
          V_SEAT,V_CLASS,V_ASUPPLY,V_AFAIL,V_SEAT_LEAKAGE,V_SHELL_TEST,V_SEAT_TEST,V_PNEUMATIC,
          V_ACTUATOR,V_SOV,V_LSB,V_AFR,V_MOR.
  CLEAR:LF_FM_NAME,FORMNAME,OBJECTKEY,CLASSNUM.

ENDFORM.                    " PROCESS_DATA
***********************************************************************
FORM DISPLAY_DATA .

  FORMNAME = TEXT-002.

  IF P_PATH IS INITIAL.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        IE_OUTPUTPARAMS = LWA_OUTPUTPARAMS
      EXCEPTIONS
        CANCEL          = 1
        USAGE_ERROR     = 2
        SYSTEM_ERROR    = 3
        INTERNAL_ERROR  = 4
        OTHERS          = 5.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        I_NAME     = FORMNAME
      IMPORTING
        E_FUNCNAME = LF_FM_NAME
*       E_INTERFACE_TYPE           =
*       EV_FUNCNAME_INBOUND        =
      .
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    CALL FUNCTION LF_FM_NAME         "'/1BCDWB/SM00000166'
      EXPORTING
*       /1BCDWB/DOCPARAMS  =
        P_VBELN            = P_VBELN
        P_POSNR            = P_POSNR
        P_PORDR            = P_PORDR
        P_AUFNR            = P_AUFNR
        IT_FINAL           = IT_FINAL[]
      IMPORTING
        /1BCDWB/FORMOUTPUT = LV_SFPDOCPARAMS
      EXCEPTIONS
        USAGE_ERROR        = 1
        SYSTEM_ERROR       = 2
        INTERNAL_ERROR     = 3
        OTHERS             = 4.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


    CALL FUNCTION 'FP_JOB_CLOSE'
      IMPORTING
        E_RESULT       = LWA_RESULT
      EXCEPTIONS
        USAGE_ERROR    = 1
        SYSTEM_ERROR   = 2
        INTERNAL_ERROR = 3
        OTHERS         = 4.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

*********************************************************************************************************
  ELSE.

    LWA_OUTPUTPARAMS-NODIALOG = 'X'.
    LWA_OUTPUTPARAMS-GETPDF = ABAP_TRUE.
    LWA_OUTPUTPARAMS-GETXML = ABAP_FALSE.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        IE_OUTPUTPARAMS = LWA_OUTPUTPARAMS
      EXCEPTIONS
        CANCEL          = 1
        USAGE_ERROR     = 2
        SYSTEM_ERROR    = 3
        INTERNAL_ERROR  = 4
        OTHERS          = 5.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        I_NAME     = FORMNAME
      IMPORTING
        E_FUNCNAME = LF_FM_NAME
*       E_INTERFACE_TYPE           =
*       EV_FUNCNAME_INBOUND        =
      .
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    CALL FUNCTION LF_FM_NAME           "'/1BCDWB/SM00000166'
      EXPORTING
*       /1BCDWB/DOCPARAMS  =
        P_VBELN            = P_VBELN
        P_POSNR            = P_POSNR
        P_PORDR            = P_PORDR
        P_AUFNR            = P_AUFNR
        IT_FINAL           = IT_FINAL[]
      IMPORTING
        /1BCDWB/FORMOUTPUT = LV_SFPDOCPARAMS
      EXCEPTIONS
        USAGE_ERROR        = 1
        SYSTEM_ERROR       = 2
        INTERNAL_ERROR     = 3
        OTHERS             = 4.
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        BUFFER     = LV_SFPDOCPARAMS-PDF
*       APPEND_TO_TABLE       = ' '
*     IMPORTING
*       OUTPUT_LENGTH         =
      TABLES
        BINARY_TAB = LT_PDFDATA.

    CALL METHOD CL_GUI_FRONTEND_SERVICES=>GUI_DOWNLOAD
      EXPORTING
*       bin_filesize            =                   " File length for binary files
        FILENAME                = P_PATH                   " Name of file
        FILETYPE                = 'BIN'                " File type (ASCII, binary ...)
      CHANGING
        DATA_TAB                = LT_PDFDATA                    " Transfer table
      EXCEPTIONS
        FILE_WRITE_ERROR        = 1                    " Cannot write to file
        NO_BATCH                = 2                    " Front-End Function Cannot Be Executed in Backgrnd
        GUI_REFUSE_FILETRANSFER = 3                    " Incorrect Front End
        INVALID_TYPE            = 4                    " Invalid value for parameter FILETYPE
        NO_AUTHORITY            = 5                    " No Download Authorization
        UNKNOWN_ERROR           = 6                    " Unknown error
        HEADER_NOT_ALLOWED      = 7                    " Invalid header
        SEPARATOR_NOT_ALLOWED   = 8                    " Invalid separator
        FILESIZE_NOT_ALLOWED    = 9                    " Invalid file size
        HEADER_TOO_LONG         = 10                   " Header information currently restricted to 1023 bytes
        DP_ERROR_CREATE         = 11                   " Cannot create DataProvider
        DP_ERROR_SEND           = 12                   " Error Sending Data with DataProvider
        DP_ERROR_WRITE          = 13                   " Error Writing Data with DataProvider
        UNKNOWN_DP_ERROR        = 14                   " Error when calling data provider
        ACCESS_DENIED           = 15                   " Access to File Denied
        DP_OUT_OF_MEMORY        = 16                   " Not Enough Memory in DataProvider
        DISK_FULL               = 17                   " Storage Medium full
        DP_TIMEOUT              = 18                   " Timeout of DataProvider
        FILE_NOT_FOUND          = 19                   " Could not find file
        DATAPROVIDER_EXCEPTION  = 20                   " General Exception Error in DataProvider
        CONTROL_FLUSH_ERROR     = 21                   " Error in Control Framework
        NOT_SUPPORTED_BY_GUI    = 22                   " GUI does not support this
        ERROR_NO_GUI            = 23                   " GUI not available
        OTHERS                  = 24.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


    CALL FUNCTION 'FP_JOB_CLOSE'
      IMPORTING
        E_RESULT       = LWA_RESULT
      EXCEPTIONS
        USAGE_ERROR    = 1
        SYSTEM_ERROR   = 2
        INTERNAL_ERROR = 3
        OTHERS         = 4.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.


  ENDIF.   "p_path

********************************************************************************************
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      FORMNAME           = FORMNAME
*    IMPORTING
*      FM_NAME            = LF_FM_NAME
*    EXCEPTIONS
*      NO_FORM            = 1
*      NO_FUNCTION_MODULE = 2
*      OTHERS             = 3.
*  IF SY-SUBRC <> 0.
*    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*
*  IF P_PATH IS INITIAL.
*    CALL FUNCTION LF_FM_NAME
*      EXPORTING
**       control_parameters = control
*        OUTPUT_OPTIONS   = OUT_OPT
*        USER_SETTINGS    = 'X'
*        P_VBELN          = P_VBELN
*        P_POSNR          = P_POSNR
*        P_PORDR          = P_PORDR
*        P_AUFNR          = P_AUFNR
*      IMPORTING
*        JOB_OUTPUT_INFO  = RETURN1
*      TABLES
*        IT_FINAL         = IT_FINAL[]
*      EXCEPTIONS
*        FORMATTING_ERROR = 1
*        INTERNAL_ERROR   = 2
*        SEND_ERROR       = 3
*        USER_CANCELED    = 4
*        OTHERS           = 5.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
******************************************************************
*  ELSE.
*    CONTROL-GETOTF = 'X'.
*    CONTROL-NO_DIALOG = 'X'.
*
*    CALL FUNCTION LF_FM_NAME
*      EXPORTING
*        CONTROL_PARAMETERS = CONTROL
*        OUTPUT_OPTIONS     = OUT_OPT
*        USER_SETTINGS      = 'X'
*        P_VBELN            = P_VBELN
*        P_POSNR            = P_POSNR
*        P_PORDR            = P_PORDR
*        P_AUFNR            = P_AUFNR
*      IMPORTING
*        JOB_OUTPUT_INFO    = RETURN1
*      TABLES
*        IT_FINAL           = IT_FINAL[]
*      EXCEPTIONS
*        FORMATTING_ERROR   = 1
*        INTERNAL_ERROR     = 2
*        SEND_ERROR         = 3
*        USER_CANCELED      = 4
*        OTHERS             = 5.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*    OTF1[] =  RETURN1-OTFDATA[].
*    CALL FUNCTION 'CONVERT_OTF'
*      EXPORTING
*        FORMAT                = 'PDF'
*        MAX_LINEWIDTH         = 132
*      IMPORTING
*        BIN_FILESIZE          = LENGTH
*      TABLES
*        OTF                   = OTF1
*        LINES                 = LINES1
*      EXCEPTIONS
*        ERR_MAX_LINEWIDTH     = 1
*        ERR_FORMAT            = 2
*        ERR_CONV_NOT_POSSIBLE = 3
*        ERR_BAD_OTF           = 4
*        OTHERS                = 5.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*
*    CALL FUNCTION 'GUI_DOWNLOAD'
*      EXPORTING
*        BIN_FILESIZE            = LENGTH
*        FILENAME                = P_PATH
*        FILETYPE                = 'BIN'
*      TABLES
*        DATA_TAB                = LINES1
*      EXCEPTIONS
*        FILE_WRITE_ERROR        = 1
*        NO_BATCH                = 2
*        GUI_REFUSE_FILETRANSFER = 3
*        INVALID_TYPE            = 4
*        NO_AUTHORITY            = 5
*        UNKNOWN_ERROR           = 6
*        HEADER_NOT_ALLOWED      = 7
*        SEPARATOR_NOT_ALLOWED   = 8
*        FILESIZE_NOT_ALLOWED    = 9
*        HEADER_TOO_LONG         = 10
*        DP_ERROR_CREATE         = 11
*        DP_ERROR_SEND           = 12
*        DP_ERROR_WRITE          = 13
*        UNKNOWN_DP_ERROR        = 14
*        ACCESS_DENIED           = 15
*        DP_OUT_OF_MEMORY        = 16
*        DISK_FULL               = 17
*        DP_TIMEOUT              = 18
*        FILE_NOT_FOUND          = 19
*        DATAPROVIDER_EXCEPTION  = 20
*        CONTROL_FLUSH_ERROR     = 21
*        OTHERS                  = 22.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*  ENDIF.

  REFRESH:IT_FINAL,IT_OBJK,ALLOCVALUESNUM,ALLOCVALUESCHAR,ALLOCVALUESCURR,RETURN,IT_MARA,IT_MAKT,IT_STB,
          OTF1,LINES1.
  CLEAR:F_PATH,V_FILE,V_PATH,LENGTH,CONTROL,OUT_OPT,RETURN1.
ENDFORM.                    " DISPLAY_DATA
*&---------------------------------------------------------------------*
