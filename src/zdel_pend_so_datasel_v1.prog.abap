*ITMTXT*&---------------------------------------------------------------------*
* Include           ZSD_PENDING_SO_DATASEL.
*&---------------------------------------------------------------------*
DATA:
  LS_EXCH_RATE TYPE BAPI1093_0,
  LV_POS       TYPE SY-CUROW.

DATA: LV_VBE  TYPE CHAR10,
      LV_POS1 TYPE CHAR6.

START-OF-SELECTION.

  IF OPEN_SO = 'X'.
*    *    CLASS zcl_sales_data_amdp DEFINITION LOAD.
*
*    CALL METHOD zcl_sales_data_amdp=>get_sales_data
*  EXPORTING
*    iv_date_low  = s_date-low
*    iv_date_high = s_date-high
*    it_matnr     = s_matnr[]
*    it_vbeln     = s_vbeln[]
*    it_kunnr     = S_kunnr[]
*  IMPORTING
*    et_data      =  IT_DATA
*    et_mara      =  IT1_MARA
*    et_vbak      =  IT_VBAK.


    SELECT A~VBELN
           A~POSNR
           A~MATNR
           A~LGORT
           A~LFSTA
           A~LFGSA
*           A~FKSTA
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
*    AND   b~fksta  NE 'C'
    AND   A~GBSTA  NE 'C'.
*    AND   A~WERKS  = 'PLO1'.


*    SELECT a~vbeln
*           a~posnr
*           a~matnr
*           a~lgort
*           a~lfsta
*           a~lfgsa
*           a~fksta
*           a~absta
*           a~gbsta
*    INTO TABLE it_data
*    FROM  vbap AS a
**    JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
**    JOIN  vbak AS C ON a~vbeln = c~vbeln
*    WHERE a~erdat  IN s_date
**    WHERE C~AUDAT  IN S_DATE
*    AND   a~matnr  IN s_matnr
*    AND   a~vbeln  IN s_vbeln         "SHREYAS
*    AND   a~lfsta  NE 'C'
*    AND   a~lfgsa  NE 'C'
*          AND   a~fksta  NE 'C'
*    AND   a~gbsta  NE 'C'.
**    AND   A~WERKS  = 'PLO1'.

*******ADDED BY SNEHAL RAJALE ON 29 JAN 201************
    LOOP AT IT_DATA INTO LS_DATA.
      IF LS_DATA-ABSTA = 'C'.
        IF LS_DATA-LFSTA = ' ' AND LS_DATA-LFGSA = ' ' "AND LS_DATA-FKSTA = ' ' "FR
                                                      AND LS_DATA-GBSTA = ' '.
*        IF ls_data-lfsta = ' ' AND ls_data-lfgsa = ' ' AND ls_data-gbsta = ' '.
          IF SY-SUBRC = 0.
*            delete it_data[] from ls_data.
            DELETE IT_DATA[]  WHERE VBELN = LS_DATA-VBELN AND POSNR = LS_DATA-POSNR.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

*********************
*    lv_vbeln = ls_data-vbeln.
*
*    SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
**        FOR ALL ENTRIES IN it_data
*      WHERE objectclas = 'VERKBELEG'
*      AND objectid = lv_vbeln
*      AND tcode = 'VA02'.
*
*    SORT it_cdhdr BY udate DESCENDING.
***************************

*******************        edited by PJ on 16-08-21
    SELECT MATNR ITEM_TYPE BOM ZPEN_ITEM ZRE_PEN_ITEM FROM MARA
      INTO TABLE IT1_MARA
      FOR ALL ENTRIES IN IT_DATA WHERE MATNR = IT_DATA-MATNR.

*****************        end

*******ENDED BY SNEHAL RAJALE ON 29 JAN 2021************
*        IF sy-subrc = 0.
    IF IT_DATA[] IS NOT INITIAL.
      SELECT VBELN
             ERDAT
             AUART
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
             FAKSK
             VKORG     "ADD BY SYPRIYA ON 19.08.2024
             VTWEG     "ADD BY SYPRIYA ON 19.08.2024
             SPART     "ADD BY SYPRIYA ON 19.08.2024

*             faksk
             FROM VBAK INTO TABLE IT_VBAK
             FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN AND
                                              KUNNR IN S_KUNNR.          " SHREYAS.
*      if it_vbak is not initial.
*        select spras
*               faksp
*               vtext
*          from tvfst into table it_tvfst
*          for all entries in it_vbak
*          where faksp = it_vbak-faksk
*          and spras = 'EN'.
*      endif.

      PERFORM FILL_TABLES.
      PERFORM PROCESS_FOR_OUTPUT.
      IF P_DOWN IS   INITIAL.
        PERFORM ALV_FOR_OUTPUT.

      ELSE.
        PERFORM DOWN_SET.
      ENDIF.

    ENDIF.

  ELSEIF ALL_SO = 'X'.
*******************************
*    lv_vbeln = ls_data-vbeln.
*
*    SELECT objectclas objectid udate tcode FROM cdhdr INTO CORRESPONDING FIELDS OF TABLE it_cdhdr
**        FOR ALL ENTRIES IN it_data
*      WHERE objectclas = 'VERKBELEG'
*      AND objectid = lv_vbeln
*      AND tcode = 'VA02'.
*
*    SORT it_cdhdr BY udate DESCENDING.
*********************************
    SELECT VBELN
           ERDAT
           AUART
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
           FAKSK
           VKORG     "ADD BY SYPRIYA ON 19.08.2024
           VTWEG     "ADD BY SYPRIYA ON 19.08.2024
           SPART     "ADD BY SYPRIYA ON 19.08.2024
*           faksk
           FROM VBAK INTO TABLE IT_VBAK WHERE ERDAT IN S_DATE AND
                                                VBELN IN S_VBELN AND "shreyas
                                                KUNNR IN S_KUNNR . "shreyas.
*                                                bukrs_vf = 'PL01'.

*    if it_vbak is not initial.
*      select spras
*             faksp
*             vtext
*        from tvfst into table it_tvfst
*        for all entries in it_vbak
*        where faksp = it_vbak-faksk
*        and spras = 'EN'.
*    endif.

**************************************************************************************
*      select * from vbap INTO TABLE it_vbap FOR ALL ENTRIES IN it_vbak where vbeln = it_vbak-vbeln.
**************************************************************************************
    IF SY-SUBRC = 0.
      PERFORM FILL_TABLES.
      PERFORM PROCESS_FOR_OUTPUT.
      IF P_DOWN IS   INITIAL.
        PERFORM ALV_FOR_OUTPUT.

      ELSE.
*        BREAK Primus.
        PERFORM DOWN_SET_ALL.
      ENDIF.
    ENDIF.

*  ELSE.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FILL_TABLES
*&---------------------------------------------------------------------*

FORM FILL_TABLES .

  IF OPEN_SO = 'X'.
    SELECT VBELN
           POSNR
           MATNR
           ARKTX
           ABGRU
           POSEX
           KDMAT
           WAERK
           KWMENG
           WERKS
           NTGEW                  "added by pankaj 28.01.2022
           OBJNR
           HOLDDATE
           HOLDRELDATE
           CANCELDATE
           DELDATE
           CUSTDELDATE
           ZGAD
           CTBG
           RECEIPT_DATE            "added by pankaj 28.01.2022
           REASON                   "added by pankaj 28.01.2022
           OFM_DATE               "added by pankaj 01.02.2022
           ERDAT
           ZINS_LOC
           LGORT
           ZMRP_DATE       "ADED BY JYOTI ON 02.07.2024
           ZEXP_MRP_DATE1    "ADDED BY JYOTI ON 13.11.2024
           ZHOLD_REASON_N1 "added by jyoti on 06.02.2025
           FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_DATA WHERE VBELN = IT_DATA-VBELN
                                       AND POSNR = IT_DATA-POSNR
                                       AND WERKS = 'PL01'.

***************************ADDED BY DH**************
    IF IT_VBAP IS NOT INITIAL.
      LOOP AT IT_VBAP INTO WA_VBAP.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_VBAP-VBELN
          IMPORTING
            OUTPUT = LV_VBELN.

        MOVE-CORRESPONDING WA_VBAP TO WA_VBAP2.
        WA_VBAP2-VBELN = LV_VBELN.
        APPEND WA_VBAP2 TO IT_VBAP2.

      ENDLOOP.

*      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
    ENDIF.

    LOOP AT IT_VBAP2 INTO WA_VBAP2.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = WA_VBAP2-VBELN
        IMPORTING
          OUTPUT = LV_VBELN2.

      WA_VBAP2-VBELN = LV_VBELN2.
      MODIFY IT_VBAP2 FROM WA_VBAP2.
    ENDLOOP.

    IF IT_VBAP2 IS NOT INITIAL.

      SELECT OBJECTCLAS OBJECTID UDATE TCODE FROM CDHDR INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
       FOR ALL ENTRIES IN IT_VBAP2
     WHERE OBJECTCLAS = 'VERKBELEG'
     AND OBJECTID = IT_VBAP2-VBELN             "it_vbap-vbeln
      AND TCODE = 'VA02'.
    ENDIF.

    SORT IT_CDHDR BY UDATE DESCENDING.
*******************************************

*******************        edited by PJ on 16-08-21
    SELECT MATNR ITEM_TYPE BOM ZPEN_ITEM ZRE_PEN_ITEM FROM MARA
      INTO TABLE IT1_MARA
      FOR ALL ENTRIES IN IT_VBAP WHERE MATNR = IT_VBAP-MATNR.

*****************        end


**************** Reject Service Sale Order Remove From Pending So(Radio Button)
    LOOP AT IT_VBAK INTO WA_VBAK WHERE AUART = 'ZESS' OR AUART = 'ZSER'.
      LOOP AT IT_VBAP INTO WA_VBAP WHERE VBELN = WA_VBAK-VBELN AND ABGRU NE ' '.
        DELETE IT_VBAP WHERE VBELN = WA_VBAP-VBELN AND POSNR = WA_VBAP-POSNR.
      ENDLOOP.
    ENDLOOP.
**************************************************************************



  ELSE.
    SELECT VBELN
           POSNR
           MATNR
           ARKTX
           ABGRU
           POSEX
           KDMAT
           WAERK
           KWMENG
           WERKS
           NTGEW                "added by pankaj 28.01.2022
           OBJNR
           HOLDDATE
           HOLDRELDATE
           CANCELDATE
           DELDATE
           CUSTDELDATE
           ZGAD
           CTBG
           RECEIPT_DATE            "added by pankaj 28.01.2022
           REASON                   "added by pankaj 28.01.2022
           OFM_DATE
           ERDAT
           ZINS_LOC
           LGORT
           ZMRP_DATE    "ADDED BY JYOTI ON 02.07.2024
           ZEXP_MRP_DATE1    "ADDED BY JYOTI ON 02.07.2024
            ZHOLD_REASON_N1 "added by jyoti on 06.02.2025
           FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_VBAK WHERE VBELN = IT_VBAK-VBELN
                                        AND WERKS = 'PL01'.

*      SELECT ZHOLD_KEY
*             ZHOLD_REASON_N1
*          FROM ZHOLD_REASON
*        INTO TABLE it_zhold_reason
*        FOR ALL ENTRIES IN it_vbap
*        WHERE Zhold_KEY = it_vbap-zhold_reason_n1+(1).
  ENDIF.
  IF IT_VBAP[] IS NOT INITIAL.

*****************************ADDED BY DH************
*    lv_vbeln = wa_vbap-vbeln.
    IF IT_VBAP IS NOT INITIAL.
      LOOP AT IT_VBAP INTO WA_VBAP.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_VBAP-VBELN
          IMPORTING
            OUTPUT = LV_VBELN.

        MOVE-CORRESPONDING WA_VBAP TO WA_VBAP2.
        WA_VBAP2-VBELN = LV_VBELN.
        APPEND WA_VBAP2 TO IT_VBAP2.

      ENDLOOP.
*      CLEAR: lv_vbeln, wa_vbap, wa_vbap2.
    ENDIF.

    LOOP AT IT_VBAP2 INTO WA_VBAP2.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = WA_VBAP2-VBELN
        IMPORTING
          OUTPUT = LV_VBELN2.

      WA_VBAP2-VBELN = LV_VBELN2.
      MODIFY IT_VBAP2 FROM WA_VBAP2.
    ENDLOOP.

    IF IT_VBAP2 IS NOT INITIAL.

      SELECT OBJECTCLAS OBJECTID UDATE TCODE FROM CDHDR INTO CORRESPONDING FIELDS OF TABLE IT_CDHDR
       FOR ALL ENTRIES IN IT_VBAP2
     WHERE OBJECTCLAS = 'VERKBELEG'
     AND OBJECTID = IT_VBAP2-VBELN             "it_vbap-vbeln
      AND TCODE = 'VA02'.
    ENDIF.

    SORT IT_CDHDR BY UDATE DESCENDING.

*********************************************
*******************        edited by PJ on 16-08-21
    SELECT MATNR ITEM_TYPE BOM ZPEN_ITEM ZRE_PEN_ITEM FROM MARA
      INTO TABLE IT1_MARA
      FOR ALL ENTRIES IN IT_VBAP WHERE MATNR = IT_VBAP-MATNR.

*****************        end
    SELECT VBELN
           POSNR
           PARVW
           KUNNR
           ADRNR
           LAND1
           FROM VBPA INTO TABLE LT_VBPA
           FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN.
*                                     AND  posnr = it_vbap-posnr.

    SELECT VBELN
           POSNR
           ETENR
           ETTYP
           EDATU
           FROM VBEP INTO TABLE IT_VBEP
           FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN
                                       AND  POSNR = IT_VBAP-POSNR.

    SORT IT_VBEP BY VBELN POSNR ETENR.

    SELECT VBELN
           POSNR
           ETENR
           ETTYP
           EDATU
           FROM VBEP INTO TABLE LT_VBEP
           FOR ALL ENTRIES IN IT_VBAP WHERE VBELN = IT_VBAP-VBELN
                                       AND  POSNR = IT_VBAP-POSNR
                                       AND  ETENR = '0001'
                                       AND  ETTYP = 'CP'.

    SORT LT_VBEP BY VBELN POSNR ETENR.

    SELECT VBELN
           POSNR
           INCO1
           INCO2
           ZTERM
           KTGRD       "added by 04.02.2022
           KURSK
           BSTKD
           PRSDT
           FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VBAP
           WHERE VBELN = IT_VBAP-VBELN.

    IF IT_VBKD IS NOT INITIAL.
      SELECT SPRAS
             ZTERM
             TEXT1
             FROM T052U INTO TABLE IT_T052U
             FOR ALL ENTRIES IN IT_VBKD
             WHERE SPRAS = 'EN'
             AND ZTERM = IT_VBKD-ZTERM.
    ENDIF.


*BREAK primus.
    SELECT MATNR
           WERKS
           LGORT
           VBELN
           POSNR
           KALAB
           KAINS
           FROM MSKA INTO TABLE IT_MSKA
           FOR ALL ENTRIES IN IT_VBAP
           WHERE VBELN = IT_VBAP-VBELN
             AND POSNR = IT_VBAP-POSNR
             AND MATNR = IT_VBAP-MATNR
             AND WERKS = IT_VBAP-WERKS.

    IF IT_VBAK IS NOT INITIAL.

      SELECT KNUMV
             KPOSN
             KSCHL
             KBETR
             WAERS
             KWERT
             FROM  PRCD_ELEMENTS INTO TABLE IT_KONV
             FOR ALL ENTRIES IN IT_VBAK
             WHERE KNUMV = IT_VBAK-KNUMV
             AND KSCHL IN S_KSCHL.

      SELECT KNUMV
             KPOSN
             KSCHL
             KBETR
             WAERS
             KWERT
             FROM  PRCD_ELEMENTS INTO TABLE IT_KONV1
             FOR ALL ENTRIES IN IT_VBAK
             WHERE KNUMV = IT_VBAK-KNUMV.


      SELECT VBELV
             POSNV
             VBELN
             VBTYP_N
             FROM VBFA INTO TABLE IT_VBFA
             FOR ALL ENTRIES IN IT_VBAK
             WHERE VBELV = IT_VBAK-VBELN
               AND ( VBTYP_N = 'J' OR  VBTYP_N = 'M' ).
    ENDIF.

    IF IT_VBFA IS NOT INITIAL.
      SELECT VBELN
             FKART
             FKTYP
             VKORG
             VTWEG
             FKDAT
             FKSTO
             FROM VBRK INTO TABLE IT_VBRK
             FOR ALL ENTRIES IN IT_VBFA
             WHERE VBELN = IT_VBFA-VBELN
               AND FKSTO NE 'X'.
    ENDIF.
    IF IT_VBRK IS NOT INITIAL.
      SELECT VBELN
             POSNR
             FKIMG
             AUBEL
             AUPOS
             MATNR
             WERKS
             FROM VBRP INTO TABLE IT_VBRP
             FOR ALL ENTRIES IN IT_VBRK
             WHERE VBELN = IT_VBRK-VBELN.
    ENDIF.
    IF IT_VBAP IS NOT INITIAL.
      SELECT * FROM JEST INTO TABLE IT_JEST FOR ALL ENTRIES IN IT_VBAP WHERE OBJNR = IT_VBAP-OBJNR
                                                                         AND STAT IN S_STAT
                                                                         AND INACT NE 'X'.
    ENDIF.
    IF IT_JEST IS NOT INITIAL.
      SELECT * FROM TJ30 INTO TABLE IT_TJ30T FOR ALL ENTRIES IN IT_JEST WHERE ESTAT = IT_JEST-STAT
                                                                         AND STSMA  = 'OR_ITEM'.
    ENDIF.


    SELECT AUFNR
           POSNR
           KDAUF
           KDPOS
           MATNR
           PGMNG
           PSMNG
           WEMNG
      FROM AFPO
      INTO TABLE IT_AFPO
      FOR ALL ENTRIES IN IT_VBAP
      WHERE KDAUF = IT_VBAP-VBELN
        AND KDPOS = IT_VBAP-POSNR .
    IF SY-SUBRC = 0.

      SELECT AUFNR
             OBJNR
             KDAUF
             KDPOS
             IGMNG
        FROM CAUFV
        INTO TABLE IT_CAUFV
        FOR ALL ENTRIES IN IT_AFPO
        WHERE AUFNR = IT_AFPO-AUFNR
        AND   KDAUF = IT_AFPO-KDAUF
        AND   KDPOS = IT_AFPO-KDPOS
        AND   LOEKZ = SPACE.

    ENDIF.
    """""""""""""""   END 05.05.2017         """"""""""""""""""""""""""

    SELECT VBELN
           POSNR
           ZIBR
           ZUL
           ZSL
           ZCE
           ZAPI6D
           ZAPI60
           ZATEX
           ZTRCU
           ZCRN
           ZMARINE
      FROM VBAP
      INTO TABLE IT_VBAP1
      FOR ALL ENTRIES IN IT_VBAP
      WHERE VBELN = IT_VBAP-VBELN AND
            POSNR = IT_VBAP-POSNR.

  ENDIF.

  IF LT_VBPA IS NOT INITIAL.

    SELECT * FROM ADRC INTO TABLE LT_ADRC FOR ALL ENTRIES IN LT_VBPA WHERE ADDRNUMBER = LT_VBPA-ADRNR." AND country = 'IN'.
    IF LT_ADRC IS NOT INITIAL.
      FIELD-SYMBOLS : <F1> TYPE ZGST_REGION.

      SELECT * FROM ZGST_REGION INTO TABLE LT_ZGST_REGION ."FOR ALL ENTRIES IN lt_adrc WHERE region = lt_adrc-region.
      LOOP AT LT_ZGST_REGION ASSIGNING <F1>.
        DATA(LV_STR_L) =  STRLEN( <F1>-REGION ).
        IF LV_STR_L = 1.
          CONCATENATE '0' <F1>-REGION INTO <F1>-REGION.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDIF.

  SELECT KUNNR
         NAME1
         ADRNR
         FROM KNA1 INTO TABLE IT_KNA1
         FOR ALL ENTRIES IN IT_VBAK
         WHERE KUNNR = IT_VBAK-KUNNR.

  """"""""" code added by pankaj 04.02.2022""""""""""""""

  IF IT_VBKD IS NOT INITIAL.

    SELECT KTGRD
           VTEXT FROM TVKTT INTO TABLE IT_TVKTT FOR ALL ENTRIES IN IT_VBKD WHERE KTGRD = IT_VBKD-KTGRD
                                                                           AND SPRAS = 'EN'.

  ENDIF.

*BREAK primus.
  IF  IT_VBAK IS NOT INITIAL.

    SELECT OBJNR
           STAT
           INACT FROM JEST INTO TABLE IT_JEST3 FOR ALL ENTRIES IN IT_VBAK WHERE OBJNR = IT_VBAK-OBJNR AND INACT = ' '.
  ENDIF.

  IF IT_JEST3 IS NOT INITIAL.

    SELECT STSMA
           ESTAT
           TXT04 FROM TJ30T INTO TABLE IT_TJ30 FOR ALL ENTRIES IN IT_JEST3 WHERE ESTAT = IT_JEST3-STAT AND STSMA = 'OR_HEADR'.

  ENDIF.


  """""""""""""""""""""""""""""""" ended""""""""""""""""""""""""""""


ENDFORM.                    " FILL_TABLES
*&---------------------------------------------------------------------*
*&      Form  PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*

FORM PROCESS_FOR_OUTPUT .
  DATA:
    LV_RATIO TYPE RESB-ENMNG,
    LV_QTY   TYPE RESB-ENMNG,
    LV_INDEX TYPE SY-TABIX.

  IF IT_VBAP[] IS NOT INITIAL.
    CLEAR: WA_VBAP, WA_VBAK, WA_VBEP, WA_MSKA,
           WA_VBRP, WA_KONV, WA_KNA1,WA_VBAP1.
    SORT IT_VBAP BY VBELN POSNR MATNR WERKS.
    SORT IT_MSKA BY VBELN POSNR MATNR WERKS.
    SORT IT_AFPO BY KDAUF KDPOS MATNR.
    SORT LT_RESB BY AUFNR KDAUF KDPOS.
*BREAK-POINT.
    LOOP AT IT_VBAP INTO WA_VBAP.

      WA_OUTPUT-LGORT = WA_VBAP-LGORT.   ""added by Pranit 10.06.2024
      WA_OUTPUT-ZMRP_DATE = WA_VBAP-ZMRP_DATE.   ""added by Pranit 10.06.2024
      WA_OUTPUT-ZEXP_MRP_DATE1 = WA_VBAP-ZEXP_MRP_DATE1.   ""added by JYOTI 13.11.2024
      IF WA_VBAP-ZHOLD_REASON_N1 IS NOT INITIAL.
        SELECT SINGLE ZHOLD_REASON_N1 FROM ZHOLD_REASON
          INTO WA_OUTPUT-HOLD_REASON_N1 WHERE ZHOLD_KEY = WA_VBAP-ZHOLD_REASON_N1.
*      wa_output-hold_reason_n1 = wa_vbap-zhold_reason_n1.   ""added by JYOTI 13.11.2024
      ENDIF.
**********ADDED BY DH ****************
      READ TABLE IT_VBAP2 INTO WA_VBAP2 WITH KEY VBELN = WA_VBAP-VBELN.
      READ TABLE IT_CDHDR INTO WA_CDHDR WITH KEY OBJECTCLAS = 'VERKBELEG' OBJECTID = WA_VBAP2-VBELN TCODE = 'VA02'.
      WA_OUTPUT-UDATE = WA_CDHDR-UDATE.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-UDATE
        IMPORTING
          OUTPUT = WA_OUTPUT-UDATE.

      CONCATENATE WA_OUTPUT-UDATE+0(2) WA_OUTPUT-UDATE+2(3) WA_OUTPUT-UDATE+5(4)
                      INTO WA_OUTPUT-UDATE SEPARATED BY '-'.

      IF WA_OUTPUT-UDATE = '--'.
        REPLACE ALL OCCURRENCES OF '--' IN WA_OUTPUT-UDATE WITH ' '.
      ENDIF.

      READ TABLE IT_DATA INTO LS_DATA WITH KEY VBELN = WA_VBAP-VBELN POSNR = WA_VBAP-POSNR.     """Added by Pranit 10.06.2024
      IF SY-SUBRC = 0.
        WA_OUTPUT-LGORT = LS_DATA-LGORT.
      ENDIF.
***************************************
*********************      modified by PJ on 16-08-21
      READ TABLE IT1_MARA INTO WA1_MARA WITH KEY MATNR = WA_VBAP-MATNR.
      IF SY-SUBRC = 0.

        WA_OUTPUT-ITEM_TYPE    = WA1_MARA-ITEM_TYPE.
        WA_OUTPUT-BOM    = WA1_MARA-BOM.
        WA_OUTPUT-ZPEN_ITEM    = WA1_MARA-ZPEN_ITEM.
        WA_OUTPUT-ZRE_PEN_ITEM    = WA1_MARA-ZRE_PEN_ITEM.

      ENDIF.
****************************      end

      WA_OUTPUT-HOLDDATE    = WA_VBAP-HOLDDATE.        "Statsu
      WA_OUTPUT-RELDATE     = WA_VBAP-HOLDRELDATE.     "Release date
      WA_OUTPUT-CANCELDATE  = WA_VBAP-CANCELDATE.      "Cancel date
      WA_OUTPUT-DELDATE     = WA_VBAP-DELDATE.         "delivary date
      WA_OUTPUT-CUSTDELDATE = WA_VBAP-CUSTDELDATE.         "customer del. date
      WA_OUTPUT-POSEX       = WA_VBAP-POSEX.
      WA_OUTPUT-POSEX1       = WA_VBAP-POSEX.         "ADDED BY JYOTI ON 16.04.2024
      WA_OUTPUT-MATNR       = WA_VBAP-MATNR.           "Material
      WA_OUTPUT-POSNR       = WA_VBAP-POSNR.           "item
      WA_OUTPUT-ARKTX       = WA_VBAP-ARKTX.           "item short description
      WA_OUTPUT-KWMENG      = WA_VBAP-KWMENG.          "sales order qty
      WA_OUTPUT-WERKS       = WA_VBAP-WERKS.           "PLANT
      WA_OUTPUT-WAERK       = WA_VBAP-WAERK.           "Currency
      WA_OUTPUT-KDMAT       = WA_VBAP-KDMAT.
      WA_OUTPUT-VBELN       = WA_VBAP-VBELN.           "Sales Order
      WA_OUTPUT-ZINS_LOC    = WA_VBAP-ZINS_LOC.        "Installation Location


      IF WA_VBAP-CUSTDELDATE IS NOT INITIAL .
        WA_OUTPUT-PO_DEL_DATE = WA_VBAP-CUSTDELDATE.
      ENDIF.
      IF WA_VBAP-ZGAD = '1'.
        WA_OUTPUT-GAD = 'Reference'.
      ELSEIF WA_VBAP-ZGAD = '2'.
        WA_OUTPUT-GAD = 'Approved'.
      ELSEIF WA_VBAP-ZGAD = '3'.
        WA_OUTPUT-GAD = 'Standard'.
      ENDIF.

      WA_OUTPUT-CTBG       = WA_VBAP-CTBG.               " added by ajay

      """"""""" code added by pankaj 28.01.2022""""""""""""""""""

      WA_OUTPUT-RECEIPT_DATE       = WA_VBAP-RECEIPT_DATE.               " added by pankaj 30.12.2021

      IF WA_VBAP-REASON = '1' OR WA_VBAP-REASON = '01'.
        WA_OUTPUT-REASON = 'Hold'.
      ELSEIF
        WA_VBAP-REASON = '2' OR WA_VBAP-REASON = '02'.
        WA_OUTPUT-REASON = 'Cancel'.
      ELSEIF
        WA_VBAP-REASON = '3' OR WA_VBAP-REASON = '03'.
        WA_OUTPUT-REASON = 'QTY Change'.
      ELSEIF
        WA_VBAP-REASON = '4'OR WA_VBAP-REASON = '04'.
        WA_OUTPUT-REASON = 'Quality Change'.
      ELSEIF
        WA_VBAP-REASON = '5' OR WA_VBAP-REASON = '05'.
        WA_OUTPUT-REASON = 'Technical Changes'.
      ELSEIF
        WA_VBAP-REASON = '6' OR WA_VBAP-REASON = '06'.
        WA_OUTPUT-REASON = 'New Line'.
      ELSEIF
      WA_VBAP-REASON = '07'.
        WA_OUTPUT-REASON = 'Line added against BCR'.
      ELSEIF
      WA_VBAP-REASON = '08'.
        WA_OUTPUT-REASON = 'Line added against wrong code given by sales'.
      ELSEIF
      WA_VBAP-REASON = '09'.
        WA_OUTPUT-REASON = 'Line added for split scheduling'.
      ELSEIF
      WA_VBAP-REASON = '10'.
        WA_OUTPUT-REASON = 'Clubbed line'.
      ELSEIF
    WA_VBAP-REASON = '11'.
        WA_OUTPUT-REASON = 'Validation line doesn''t show on OA'.
      ENDIF.

      WA_OUTPUT-NTGEW           = WA_VBAP-NTGEW.
      WA_OUTPUT-OFM_DATE1       = WA_VBAP-OFM_DATE.
*      break primus.              "added by pankaj 01.02.2022
      IF  WA_OUTPUT-OFM_DATE1 NE '00000000'.
        WA_OUTPUT-OFM_DATE1 = WA_OUTPUT-OFM_DATE1.
      ELSE.
        WA_OUTPUT-OFM_DATE1 = SPACE.
      ENDIF.
      WA_OUTPUT-CHANG_SO_DATE = WA_VBAP-ERDAT.
      """""""" code ended""""""""""""""""""""""""""""""'

      READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_OUTPUT-VBELN.
      IF SY-SUBRC = 0.
        WA_OUTPUT-AUART        = WA_VBAK-AUART.           "ORDER TYPE
        WA_OUTPUT-VKBUR        = WA_VBAK-VKBUR.           "Sales Office
        WA_OUTPUT-ERDAT        = WA_VBAK-ERDAT.           "Sales Order date
        WA_OUTPUT-VDATU        = WA_VBAK-VDATU.           "Req del date
        WA_OUTPUT-BSTDK        = WA_VBAK-BSTDK.
        WA_OUTPUT-LIFSK        = WA_VBAK-LIFSK.
        WA_OUTPUT-ZLDPERWEEK   = WA_VBAK-ZLDPERWEEK.  "LD per week
        WA_OUTPUT-ZLDMAX       = WA_VBAK-ZLDMAX.      "LD Max
        WA_OUTPUT-ZLDFROMDATE  = WA_VBAK-ZLDFROMDATE. "LD from date
        WA_OUTPUT-KUNNR        = WA_VBAK-KUNNR.

        WA_OUTPUT-VKORG = WA_VBAK-VKORG .  "ADD BY SUPRIYA ON 19.08.2024
        WA_OUTPUT-VTWEG = WA_VBAK-VTWEG.    "ADD BY SUPRIYA ON 19.08.2024
        WA_OUTPUT-SPART = WA_VBAK-SPART.    "ADD BY SUPRIYA ON 19.08.2024


*        wa_output-faksk        = wa_vbak-faksk.

      ENDIF.

*      read table it_tvfst into wa_tvfst with key faksp = wa_vbak-faksk spras = 'EN'.
*      if sy-subrc = 0.
*        wa_output-vtext1 = wa_tvfst-vtext.
*      endif.

      """"""""" code added by pankaj 28.01.2021"""""""""""""""""""""""""

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZPR0'  KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        WA_OUTPUT-ZPR0 = WA_KONV1-KBETR.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZPF0' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        WA_OUTPUT-ZPF0 = WA_KONV1-KWERT.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KSCHL = 'ZIN1' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        WA_OUTPUT-ZIN1 = WA_KONV1-KWERT.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KSCHL = 'ZIN2' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        WA_OUTPUT-ZIN2 = WA_KONV1-KWERT.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'JOIG' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        WA_OUTPUT-JOIG = WA_KONV1-KWERT.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'JOCG' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        WA_OUTPUT-JOCG = WA_KONV1-KWERT.
      ENDIF.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'JOSG' KPOSN = WA_VBAP-POSNR.

      IF SY-SUBRC = 0.
        WA_OUTPUT-JOSG = WA_KONV1-KWERT.
      ENDIF.

*      READ TABLE IT_KONV1 INTO DATA(WA_KONV12) WITH KEY KNUMV = WA_VBAK-KNUMV  KSCHL = 'ZDIS' KPOSN = WA_VBAP-POSNR. "ADDED BY MAHADEV HEMENT ON 10/12/2025
*
*      IF SY-SUBRC = 0.
**        WA_OUTPUT-JOSG = WA_KONV12-KWERT.
*        WA_OUTPUT-DIS_RATE = abs( WA_KONV12-KBETR ).
*        GV_KBETR2 = WA_OUTPUT-ZPR0 * WA_KONV12-KBETR / 100  . "ADDED BY MAHADEV SACHIN ON 08/12/2025
*        GV_KBETR = GV_KBETR2 - ( - WA_OUTPUT-ZPR0 ). "ADDED BY MAHADEV SACHIN ON 08/12/2025
*
*        GV_KWERT = WA_KONV12-KWERT.
**        WA_OUTPUT-DIS_AMT  = abs( WA_KONV12-KWERT ).
*        WA_OUTPUT-DIS_AMT  = abs( GV_KBETR2 ) .
*      ENDIF.
**      WA_OUTPUT-DIS_UNIT_RATE  = WA_OUTPUT-ZPR0 - ( - WA_KONV12-KWERT ).
*      WA_OUTPUT-DIS_UNIT_RATE  = GV_KBETR .


      """"""""""""" code ended""""""""""""""""""""""""""""""""""""

      READ TABLE IT_VBEP INTO WA_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-ETTYP       = WA_VBEP-ETTYP.           "So Status
        WA_OUTPUT-EDATU       = WA_VBEP-EDATU.           "delivary Date
        WA_OUTPUT-ETENR       = WA_VBEP-ETENR.           "Schedule line no.
        "wa_output-date        = wa_vbep-date.
      ENDIF.
      READ TABLE IT_VBEP INTO WA_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-DATE       = WA_VBEP-EDATU.

      ENDIF.
      READ TABLE LT_VBEP INTO LS_VBEP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR
                                               ETENR = '0001'
                                               ETTYP = 'CP'.

      READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_OUTPUT-VBELN.

*                                               posnr = wa_vbap-posnr.
      IF SY-SUBRC = 0.
        WA_OUTPUT-SO_EXC      = WA_VBKD-KURSK.           "SO Exchange Rate
        WA_OUTPUT-BSTKD       = WA_VBKD-BSTKD.           "Cust Ref No.
*        wa_output-bstkd1       = wa_vbkd-bstkd.           "ADDED BY JYOTI ON 16.04.2024"Cust Ref No.
        WA_OUTPUT-ZTERM       = WA_VBKD-ZTERM.           "payment terms
        WA_OUTPUT-INCO1       = WA_VBKD-INCO1.           "inco terms
        WA_OUTPUT-INCO2       = WA_VBKD-INCO2.           "inco terms description
        WA_OUTPUT-PRSDT       = WA_VBKD-PRSDT.

      ENDIF.
      ""assesable value
*      GV_KWERT2 = WA_OUTPUT-ZPR0 - ( - GV_KWERT ). " ADDED BY MAHADEV HEMENT ON 10/12/2025
**    LS_FINAL-ASS2_VAL = GV_Kwert2 * wa_vbkd-KURSK . " ADDED BY MAHADEV HEMENT ON 10/12/2025
*      WA_OUTPUT-ASS2_VAL = GV_KWERT2 *  WA_VBKD-KURSK . " ADDED BY MAHADEV HEMENT ON 10/12/2025
*
*      "" TOTAL assesable value
**     LS_FINAL-TOT_ASS = GV_KBETR . " ADDED BY MAHADEV HEMENT ON 10/12/2025
*      WA_OUTPUT-TOT_ASS = GV_KBETR *  WA_VBKD-KURSK . " ADDED BY MAHADEV HEMENT ON 10/12/2025

      CLEAR WA_KNA1.
      READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_OUTPUT-KUNNR.
      IF SY-SUBRC = 0.
        WA_OUTPUT-NAME1       = WA_KNA1-NAME1.           "Cust Name
      ENDIF.


      READ TABLE IT_T052U INTO WA_T052U WITH KEY ZTERM = WA_OUTPUT-ZTERM.
      IF SY-SUBRC = 0.
        WA_OUTPUT-TEXT1       = WA_T052U-TEXT1.          "payment terms description
      ENDIF.
*      BREAK primus.
      READ TABLE IT_VBAP1 INTO WA_VBAP1 WITH KEY VBELN = WA_OUTPUT-VBELN
                                                 POSNR = WA_OUTPUT-POSNR.
      IF SY-SUBRC = 0.

        IF WA_VBAP1-ZIBR = 'X'.
          CERTIF_ZIBR = 'IBR'.
*          CONCATENATE quote certif_zibr quote INTO certif_zibr.
          CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZIBR INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
        ENDIF.

        IF WA_VBAP1-ZUL = 'X'.
          CERTIF_ZUL = 'UL'.
*          CONCATENATE quote certif_zul quote INTO certif_zul.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZUL INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZUL INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZSL = 'X'.
          CERTIF_ZSL = 'SIL3'.
*           CONCATENATE quote certif_zsl quote INTO certif_zsl.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZSL INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZSL INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZCE = 'X'.
          CERTIF_ZCE = 'CE'.
*          CONCATENATE quote certif_zce quote INTO certif_zce.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCE INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCE INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZAPI6D = 'X'.
          CERTIF_ZAPI6D = 'API 6D'.
*          CONCATENATE quote certif_zapi6d quote INTO certif_zapi6d.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI6D INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI6D INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZAPI60 = 'X'.
          CERTIF_ZAPI60 = 'API 609'.
*          CONCATENATE quote certif_zapi60 quote INTO certif_zapi60.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI60 INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZAPI60 INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZATEX = 'X'.
          CERTIF_ZATEX = 'ATEX'.
*          CONCATENATE quote certif_zatex quote INTO certif_zatex.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZATEX INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZATEX INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZTRCU = 'X'.
          CERTIF_ZTRCU = 'TRCU'.
*          CONCATENATE quote certif_ztrcu quote INTO certif_ztrcu.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZTRCU INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZTRCU INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZCRN = 'X'.
          CERTIF_ZCRN = 'CRN'.
*          CONCATENATE quote certif_zcrn quote INTO certif_zcrn.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCRN INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZCRN INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        IF WA_VBAP1-ZMARINE = 'X'.
          CERTIF_ZMARINE = 'MARINE'.
*          CONCATENATE quote certif_zmarine quote INTO certif_zmarine.
          IF WA_OUTPUT-CERTIF IS INITIAL.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZMARINE INTO WA_OUTPUT-CERTIF SEPARATED BY SPACE.
          ELSE.
            CONCATENATE WA_OUTPUT-CERTIF CERTIF_ZMARINE INTO WA_OUTPUT-CERTIF SEPARATED BY ','.
          ENDIF.
        ENDIF.

        CLEAR : CERTIF_ZIBR, CERTIF_ZUL, CERTIF_ZSL, CERTIF_ZCE, CERTIF_ZAPI6D, CERTIF_ZAPI60, CERTIF_ZATEX , CERTIF_ZTRCU, CERTIF_ZCRN, CERTIF_ZMARINE.

      ENDIF.

      READ TABLE IT_VBRP INTO WA_VBRP WITH KEY VBELN = WA_OUTPUT-VBELN
                                               POSNR = WA_OUTPUT-POSNR.
**TPI TEXT

      CLEAR: LV_LINES, WA_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z999'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      READ TABLE LV_LINES INTO WA_LINES INDEX 1.

*LD Req Text
      CLEAR: LV_LINES, WA_LN_LD.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z038'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      READ TABLE LV_LINES INTO WA_LN_LD INDEX 1.

**********
*Tag Required
      CLEAR: LV_LINES, WA_TAG_RQ.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z039'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      READ TABLE LV_LINES INTO WA_TAG_RQ INDEX 1.
**********
*******************************ADDED BY JYOTI ON 04.12.2024
*************** CUSTOMER PROJECT NAME*********************
      CLEAR: LV_LINES,  WA_CUST_PROJ_NAME.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z063'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO  WA_CUST_PROJ_NAME.
          IF  WA_CUST_PROJ_NAME-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-ZCUST_PROJ_NAME  WA_CUST_PROJ_NAME-TDLINE INTO WA_OUTPUT-ZCUST_PROJ_NAME SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

*  *  *********************************ADDED BY JYOTI ON 20.01.2024**********************************
      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z064'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-AMENDMENT_HIS LS_LINES-TDLINE INTO WA_OUTPUT-AMENDMENT_HIS SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.


      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z065'
          LANGUAGE                = 'E'
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-PO_DIS LS_LINES-TDLINE INTO WA_OUTPUT-PO_DIS SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

**********************************************************

*Material text
      CLEAR: LV_LINES, LS_MATTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-MATNR.
      IF LV_NAME IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'GRUN'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'MATERIAL'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      READ TABLE LV_LINES INTO LS_MATTXT INDEX 1.

*********OFM SR. NO.
*      CLEAR: lv_lines, wa_ofm_no.
*      REFRESH lv_lines.
*      CONCATENATE wa_output-vbeln wa_output-posnr INTO lv_name.
*
*      CALL FUNCTION 'READ_TEXT'
*        EXPORTING
*          client                  = sy-mandt
*          id                      = 'Z102'
*          language                = sy-langu
*          name                    = lv_name
*          object                  = 'VBBP'
*        TABLES
*          lines                   = lv_lines
*        EXCEPTIONS
*          id                      = 1
*          language                = 2
*          name                    = 3
*          not_found               = 4
*          object                  = 5
*          reference_check         = 6
*          wrong_access_to_archive = 7
*          OTHERS                  = 8.
*      IF sy-subrc <> 0.
** Implement suitable error handling here
*      ENDIF.
*
*      READ TABLE lv_lines INTO wa_ofm_no INDEX 1.
*
*      IF lv_lines IS NOT INITIAL.
*        LOOP AT lv_lines INTO wa_ofm_no.
*          IF wa_ofm_no-tdline IS NOT INITIAL.
*            CLEAR wa_text.
*            wa_text = wa_ofm_no-tdline(20).     "ofm sr no
*            TRANSLATE wa_text TO UPPER CASE .
*            wa_output-ofm_no         = wa_text.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.

********************ADDED BY SHREYA*******************
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      IF LV_NAME IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z102'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBP'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_CTBGI.
          IF LS_CTBGI-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-OFM_NO LS_CTBGI-TDLINE INTO WA_OUTPUT-OFM_NO SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      """"""""""""""""""""""""SPECIAL COMMENTS
*      BREAK primusabap.
      CLEAR: LV_LINES, WA_LN_LD.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      IF LV_NAME IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z888'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBP'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_CTBGI.
          IF LS_CTBGI-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-SPECIAL_COMM LS_CTBGI-TDLINE INTO WA_OUTPUT-SPECIAL_COMM SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
      """"""""""""""""""""""""""""""""""""""""

**********changes by madhavi jocg joig JTC1
*konv data
      CLEAR: WA_KONV1." WA_OUTPUT.

      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KPOSN = WA_OUTPUT-POSNR KSCHL = 'JOCG'.
      IF SY-SUBRC = 0.
        CLEAR : LV_CGST,LV_CGST_TEMP.
*        lv_cgst =  wa_konv1-kbetr / 10. """  -- NC
        LV_CGST =  WA_KONV1-KBETR.   """ ++ NC
        LV_CGST_TEMP = LV_CGST.
        CONDENSE LV_CGST_TEMP.
        WA_OUTPUT-CGST = LV_CGST_TEMP.

*        wa_output-cgst_val = wa_konv1-kwert.

        WA_OUTPUT-SGST = LV_CGST_TEMP.
*        wa_output-sgst_val = wa_konv1-kwert.
      ENDIF.
      CLEAR: WA_KONV1.
      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KPOSN = WA_OUTPUT-POSNR KSCHL = 'JOIG'.
      IF SY-SUBRC = 0.
        CLEAR : LV_CGST,LV_CGST_TEMP.
*        lv_cgst =  wa_konv1-kbetr / 10.  """ --NC
        LV_CGST =  WA_KONV1-KBETR.  """" ++ NC
        LV_CGST_TEMP = LV_CGST.
        WA_OUTPUT-IGST = LV_CGST_TEMP.
*        wa_output-igst_val = wa_konv1-kwert.
      ENDIF.

      CLEAR: WA_KONV1.
      READ TABLE IT_KONV1 INTO WA_KONV1 WITH KEY KNUMV = WA_VBAK-KNUMV KPOSN = WA_VBAP-POSNR KSCHL = 'JTC1'.
      IF SY-SUBRC = 0.
*        wa_output-tcs = wa_konv1-kbetr / 10.  """ -- NC
        WA_OUTPUT-TCS = WA_KONV1-KBETR .  """ NC
        WA_OUTPUT-TCS_AMT = WA_KONV1-KWERT.
      ENDIF.

      CLEAR: WA_KONV.

      SELECT SINGLE KNUMV
                    KPOSN
                    KSCHL
                    KBETR
                    WAERS
                    KWERT
                    FROM  PRCD_ELEMENTS INTO WA_KONV WHERE  KNUMV = WA_VBAK-KNUMV
                                             AND   KPOSN = WA_OUTPUT-POSNR
                                             AND   KSCHL = 'ZPR0'.
      WA_OUTPUT-KBETR       = WA_KONV-KBETR.           "Rate

      CLEAR: WA_KONV .
      SELECT SINGLE KNUMV
                    KPOSN
                    KSCHL
                    KBETR
                    WAERS
                    KWERT
                    FROM  PRCD_ELEMENTS INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV
                                             AND   KPOSN = WA_OUTPUT-POSNR
                                             AND   KSCHL = 'VPRS'.
      IF WA_VBAP-WAERK <> 'INR'.
        IF WA_KONV-WAERS <> 'INR'.
          WA_KONV-KBETR = WA_KONV-KBETR * WA_VBKD-KURSK.
        ENDIF.
      ENDIF.

      WA_OUTPUT-IN_PRICE    = WA_KONV-KBETR.           "Internal Price

      CLEAR: WA_KONV .

      SELECT SINGLE KNUMV
                    KPOSN
                    KSCHL
                    KBETR
                    WAERS
                    KWERT
                    FROM PRCD_ELEMENTS INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV
                                             AND   KPOSN = WA_OUTPUT-POSNR
                                             AND  KSCHL = 'ZESC'.
      IF WA_VBAP-WAERK <> 'INR'.
        IF WA_KONV-WAERS <> 'INR'.
          WA_KONV-KBETR = WA_KONV-KBETR * WA_VBKD-KURSK.
        ENDIF.
      ENDIF.

      WA_OUTPUT-EST_COST    = WA_KONV-KBETR.           "Estimated cost


      CLEAR WA_JEST1.
      READ TABLE IT_JEST INTO WA_JEST1 WITH KEY OBJNR = WA_VBAP-OBJNR.

      SELECT SINGLE * FROM TJ30T INTO WA_TJ30T  WHERE ESTAT = WA_JEST1-STAT
                                                AND STSMA  = 'OR_ITEM'
                                                AND SPRAS  = 'EN'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-STATUS      = WA_TJ30T-TXT30.          "Hold/Unhold
      ENDIF.

      CLEAR : WA_MSKA.


      LOOP AT IT_MSKA INTO WA_MSKA WHERE VBELN = WA_OUTPUT-VBELN AND
                                         POSNR = WA_OUTPUT-POSNR AND
                                         MATNR = WA_OUTPUT-MATNR AND
                                         WERKS = WA_OUTPUT-WERKS.

        CASE WA_MSKA-LGORT.
          WHEN 'FG01'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
*          WHEN 'TPI1'.
*            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'PRD1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'RM01'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'RWK1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SC01'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SFG1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SPC1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SRN1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'VLD1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SLR1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KFG0'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KMCN'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KNDT'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KPLG'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KPR1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KPRD'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KRJ0'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KRM0'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KRWK'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KSC0'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KSCR'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KSFG'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KSLR'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KSPC'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KSRN'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
*          WHEN 'KTPI'.
*            wa_output-stock_qty = wa_output-stock_qty + wa_mska-kalab.
          WHEN 'KVLD'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'SUPT'.                                                      """"ADDED BY PRANIT 17.01.2024
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KUPT'.                                                        """"ADDED BY PRANIT 17.01.2024
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'KTPI'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
          WHEN 'TPI1'.
            WA_OUTPUT-STOCK_QTY = WA_OUTPUT-STOCK_QTY + WA_MSKA-KALAB.
        ENDCASE.
        IF SY-SUBRC = 0.

        ENDIF.
      ENDLOOP.

*DELIVARY QTY
      CLEAR: WA_VBFA, WA_LFIMG, WA_LFIMG_SUM.
      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_OUTPUT-VBELN
                                   AND POSNV = WA_OUTPUT-POSNR
                                   AND VBTYP_N = 'J'.

        CLEAR WA_LFIMG.
        SELECT SINGLE LFIMG FROM LIPS INTO  WA_LFIMG  WHERE VBELN = WA_VBFA-VBELN
                                                      AND   PSTYV = 'ZTAN'
                                                      AND   VGBEL = WA_OUTPUT-VBELN
                                                      AND   VGPOS = WA_OUTPUT-POSNR.
        WA_LFIMG_SUM = WA_LFIMG_SUM + WA_LFIMG .

      ENDLOOP.

*INVOICE QTY
      CLEAR: WA_VBFA, WA_FKIMG, WA_FKIMG_SUM.
      LOOP AT IT_VBFA INTO WA_VBFA WHERE VBELV = WA_OUTPUT-VBELN
                                     AND POSNV = WA_OUTPUT-POSNR
                                     AND VBTYP_N = 'M'.

        CLEAR WA_VBRK.
        READ TABLE IT_VBRK INTO WA_VBRK WITH KEY   VBELN = WA_VBFA-VBELN.

        CLEAR WA_FKIMG.
        SELECT SINGLE FKIMG FROM VBRP INTO  WA_FKIMG  WHERE VBELN = WA_VBRK-VBELN
                                                      AND   AUBEL = WA_OUTPUT-VBELN
                                                      AND   AUPOS = WA_OUTPUT-POSNR.
        WA_FKIMG_SUM = WA_FKIMG_SUM + WA_FKIMG .
      ENDLOOP.

****
      CLEAR WA_MBEW.
      SELECT SINGLE * FROM MBEW INTO WA_MBEW WHERE MATNR = WA_OUTPUT-MATNR
                                               AND BWKEY = WA_OUTPUT-WERKS.

      CLEAR WA_MARA.
      SELECT SINGLE * FROM MARA INTO WA_MARA WHERE MATNR = WA_OUTPUT-MATNR.

      """"""""""     Added By KD on 04.05.2017    """""""""""
      SELECT SINGLE DISPO FROM MARC INTO WA_OUTPUT-DISPO WHERE MATNR = WA_OUTPUT-MATNR.
      """""""""""""""""""""""""""""""""""""""""""""""""""
*currency conversion
      REFRESH LS_FR_CURR.
      CLEAR LS_FR_CURR.
      LS_FR_CURR-SIGN   = 'I'.
      LS_FR_CURR-OPTION = 'EQ'.
      LS_FR_CURR-LOW = WA_VBAK-WAERK.
      APPEND LS_FR_CURR.
      CLEAR: LS_EX_RATE,LV_EX_RATE, LS_RETURN.
      REFRESH: LS_EX_RATE, LS_RETURN.
      IF LS_TO_CURR-LOW <> LS_FR_CURR-LOW.

        CALL FUNCTION 'BAPI_EXCHRATE_GETCURRENTRATES'
          EXPORTING
            DATE             = SY-DATUM
            DATE_TYPE        = 'V'
            RATE_TYPE        = 'B'
          TABLES
            FROM_CURR_RANGE  = LS_FR_CURR
            TO_CURRNCY_RANGE = LS_TO_CURR
            EXCH_RATE_LIST   = LS_EX_RATE
            RETURN           = LS_RETURN.

        CLEAR LV_EX_RATE.
        READ TABLE LS_EX_RATE INTO LV_EX_RATE INDEX 1.
      ELSE.
        LV_EX_RATE-EXCH_RATE = 1.
      ENDIF.

*Latest Estimated cost
      REFRESH: IT_KONH.
      CLEAR:   IT_KONH.

*  FOR ZESC
      SELECT * FROM KONH INTO TABLE IT_KONH WHERE KOTABNR = '508'
                                              AND KSCHL  = 'ZESC'
                                              AND KNUMH = WA_OUTPUT-MATNR
*                                              AND vakey = wa_output-matnr
                                              AND KNUMH = WA_OUTPUT-MATNR
                                              AND DATAB <= SY-DATUM
                                              AND DATBI >= SY-DATUM .
      SORT  IT_KONH DESCENDING BY KNUMH .
      CLEAR WA_KONH.
      READ TABLE IT_KONH INTO WA_KONH INDEX 1.

      CLEAR WA_KONP.
      SELECT SINGLE * FROM KONP INTO WA_KONP WHERE KNUMH = WA_KONH-KNUMH
                                              AND KSCHL  = 'ZESC'.

      CLEAR WA_CDPOS.
      DATA TABKEY TYPE CDPOS-TABKEY.
      CONCATENATE SY-MANDT WA_VBEP-VBELN WA_VBEP-POSNR WA_VBEP-ETENR INTO TABKEY.
*--Original Code
********PJ on 01-10-21*********************************************

*     ******We dont want this code for PendinG so and all To reduce TimING OF EXECUTION OF THE PROGRAM
*            for MRP Date As disscussion with Parag and Joshi Sir.
      IF OPEN_SO = 'X' AND ALL_SO NE 'X' AND 1 = 2. "Added By Nilay B. On 06.09.2023 "1=2 added by farhan on dated 13.11.2025
*      IF .                     "commented by pankaj 05.10.2021
        SELECT * FROM CDPOS INTO TABLE IT_CDPOS WHERE TABKEY = TABKEY

**                                               AND value_new = 'CP'
**                                               AND value_old = 'CN'
                                                 AND TABNAME = 'VBEP' AND FNAME = 'ETTYP'.
*--End Original
*--Start change by CRC
        DATA : R_OBJECTCLAS TYPE RANGE OF CDPOS-OBJECTCLAS.

        SELECT *
      FROM CDPOS INTO TABLE IT_CDPOS
      WHERE OBJECTCLAS IN R_OBJECTCLAS
      AND   TABKEY  = TABKEY
      AND   TABNAME = 'VBEP'
      AND   FNAME   = 'ETTYP'.
*-- End Change
        SORT IT_CDPOS BY CHANGENR DESCENDING.
        READ TABLE IT_CDPOS INTO WA_CDPOS INDEX 1.
        IF WA_CDPOS-VALUE_NEW = 'CP' .
          SELECT SINGLE * FROM CDHDR INTO WA_CDHDR WHERE CHANGENR = WA_CDPOS-CHANGENR.

          WA_OUTPUT-MRP_DT      = WA_CDHDR-UDATE.           "MRP date EDATU to TDDAT changed by Pranav Khadatkar

        ENDIF.
        CLEAR WA_CDHDR.

*      ENDIF.                      "commented by pankaj 05.10.2021
      ENDIF.                       "Added By Nilay B. On 06.09.2023
      IF OPEN_SO = 'X' AND ALL_SO NE 'X'.
        TYPES:
          BEGIN OF ZTY_CHANGES,
            OBJECTCLAS TYPE CDOBJECTCL,
            OBJECTID   TYPE CDOBJECTV,
            CHANGENR   TYPE CDCHANGENR,
            USERNAME   TYPE CDCHANGENR,
            UDATE      TYPE CDDATUM,
            UTIME      TYPE CDUZEIT,
            TCODE      TYPE CDTCODE,
            PLANCHNGNR TYPE PLANCHNGNR,
            ACT_CHNGNO TYPE CD_CHNGNO,
            WAS_PLANND TYPE CD_PLANNED,
            CHANGE_IND TYPE CDCHNGINDH,
            LANGU      TYPE LANGU,
            VERSION    TYPE CHAR3,

            TABNAME    TYPE TABNAME,
            TABKEY     TYPE CDTABKEY,
            FNAME      TYPE FIELDNAME,
            CHNGIND    TYPE CDCHNGIND,
            TEXT_CASE  TYPE CDXFELD,
            UNIT_OLD   TYPE CDUNIT,
            UNIT_NEW   TYPE CDUNIT,
            CUKY_OLD   TYPE CDCUKY,
            CUKY_NEW   TYPE CDCUKY,
            VALUE_NEW  TYPE CDFLDVALN,
            VALUE_OLD  TYPE CDFLDVALO,

          END OF ZTY_CHANGES .
        DATA: IT_CHANGES TYPE TABLE OF  ZTY_CHANGES,
              WA_CHANGES TYPE ZTY_CHANGES.


*        CALL METHOD ZCL_CHANGE_DOC_AMDP=>GET_CHANGES
*          EXPORTING
*            TABKEY     = TABKEY
*          IMPORTING
*            ET_CHANGES = IT_CHANGES.
*        READ TABLE IT_CHANGES INTO WA_CHANGES INDEX 1.
        WA_OUTPUT-MRP_DT =   WA_CHANGES-UDATE.
      ENDIF.
*     ******We dont want this code for Pendind so and all To reduce Timn for MRP Date As disscussion with Parag and Joshi Sir.
**********end****************************
      CLEAR WA_TVAGT.
      SELECT SINGLE SPRAS
                    ABGRU
                    BEZEI
                    FROM TVAGT INTO  WA_TVAGT
                    WHERE ABGRU = WA_VBAP-ABGRU AND SPRAS = 'E'.

*Sales text
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      IF LV_NAME IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = '0001'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBP'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      READ TABLE LV_LINES INTO LS_ITMTXT INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_ITMTXT.
          IF LS_ITMTXT-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-ITMTXT LS_ITMTXT-TDLINE INTO WA_OUTPUT-ITMTXT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
*wa_output-itmtxt = ls_itmtxt-tdline.

*********CTBG Item Details     "added by SR on 03.05.2021

      CLEAR: LV_LINES, LS_CTBGI,LV_NAME.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      IF LV_NAME IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z061'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBP'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
*  ENDIF.
        READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

        IF LV_LINES IS NOT INITIAL.
          LOOP AT LV_LINES INTO LS_CTBGI.
            IF LS_CTBGI-TDLINE IS NOT INITIAL.
*            CONCATENATE wa_output-ctbgi ls_ctbgi-tdline INTO wa_output-ctbgi SEPARATED BY space.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*************
********Insurance
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z017'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

        IF LV_LINES IS NOT INITIAL.
          LOOP AT LV_LINES INTO LS_ITMTXT.
            IF LS_ITMTXT-TDLINE IS NOT INITIAL.
              CONCATENATE WA_OUTPUT-INSUR LS_ITMTXT-TDLINE INTO WA_OUTPUT-INSUR SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = '0001'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBP'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
        READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

        IF LV_LINES IS NOT INITIAL.
          LOOP AT LV_LINES INTO LS_CTBGI.
            IF LS_CTBGI-TDLINE IS NOT INITIAL.
              CONCATENATE WA_OUTPUT-MAT_TEXT LS_CTBGI-TDLINE INTO WA_OUTPUT-MAT_TEXT SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
********Insurance***********
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z047'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.

        IF LV_LINES IS NOT INITIAL.
          LOOP AT LV_LINES INTO LS_ITMTXT.
            IF LS_ITMTXT-TDLINE IS NOT INITIAL.
              CONCATENATE WA_OUTPUT-PARDEL LS_ITMTXT-TDLINE INTO WA_OUTPUT-PARDEL SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

*      BREAK primus.
      SELECT SINGLE VTEXT INTO WA_OUTPUT-VTEXT FROM TVLST WHERE LIFSP = WA_VBAK-LIFSK AND SPRAS = 'EN'.
      CLEAR WA_TEXT1.
*                                    wa_text = wa_tag_rq-tdline(20).
      WA_TEXT1 = WA_TAG_RQ-TDLINE(50).     "CHANGED BY SR ON 03.05.2021
      TRANSLATE WA_TEXT1 TO UPPER CASE .       "tag Required
*                                    wa_output-tag_req     = wa_text(1).
      WA_OUTPUT-TAG_REQ     = WA_TEXT1.      "CHANGED BY SR ON 03.05.2021

      WA_OUTPUT-LFIMG       = WA_LFIMG_SUM.                "del qty
      WA_OUTPUT-FKIMG       = WA_FKIMG_SUM.                "inv qty
      WA_OUTPUT-PND_QTY     = WA_OUTPUT-KWMENG - WA_OUTPUT-FKIMG.  "Pending Qty

      IF WA_TVAGT-ABGRU IS INITIAL.
        WA_OUTPUT-ABGRU           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        WA_OUTPUT-ABGRU           =  WA_TVAGT-ABGRU.   " avinash bhagat 20.12.2018
      ENDIF.
      IF WA_TVAGT-BEZEI IS INITIAL.
        WA_OUTPUT-BEZEI           =  '-'.   " avinash bhagat 20.12.2018
      ELSE.
        WA_OUTPUT-BEZEI           =  WA_TVAGT-BEZEI.   " avinash bhagat 20.12.2018
      ENDIF.
**      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR WA_OUTPUT-ETENR     """"""""""" --NC

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-VBELN
        IMPORTING
          OUTPUT = LV_VBE.
      .


      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-POSNR
        IMPORTING
          OUTPUT = LV_POS1.
      .

      CONCATENATE LV_VBE LV_POS1     """"""""""" ++NC
*        INTO WA_OUTPUT-SCHID(25). "commented by supriya on 2024.08.20
          INTO WA_OUTPUT-SCHID SEPARATED BY '-'.
      CLEAR : LV_POS1 ,LV_VBE .

      DATA LV_QMQTY TYPE MSKA-KAINS.
      CLEAR LV_QMQTY.

      READ TABLE IT_MSKA INTO WA_MSKA WITH KEY VBELN = WA_VBAP-VBELN
                                               POSNR = WA_VBAP-POSNR
                                               MATNR = WA_VBAP-MATNR
                                               WERKS = WA_VBAP-WERKS.
      IF SY-SUBRC IS INITIAL.
        LV_INDEX = SY-TABIX.
        LOOP AT IT_MSKA INTO WA_MSKA FROM LV_INDEX.
          IF WA_MSKA-VBELN = WA_VBAP-VBELN AND WA_MSKA-POSNR = WA_VBAP-POSNR
           AND WA_MSKA-MATNR = WA_VBAP-MATNR AND WA_MSKA-WERKS = WA_VBAP-WERKS.
*            LV_QMQTY = WA_MSKA-KAINS - LV_QMQTY.
            LV_QMQTY = WA_MSKA-KAINS + LV_QMQTY.
          ELSE.
            CLEAR LV_INDEX.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      WA_OUTPUT-QMQTY = LV_QMQTY.
      WA_OUTPUT-MATTXT = LS_MATTXT-TDLINE.

      CLEAR WA_TEXT1.
*                                    wa_text = wa_lines-tdline(20).
      WA_TEXT1 = WA_LINES-TDLINE(50).            "added by sr 0n 03.05.2021
      TRANSLATE WA_TEXT1 TO UPPER CASE .
      WA_OUTPUT-TPI         = WA_TEXT1.     "TPI Required

*      CLEAR wa_text1.
*                                    wa_text = wa_ln_ld-tdline(20).     "wa_ln_ld ld_req
      WA_TEXT1 = WA_LN_LD-TDLINE(50).     "added by sr 0n 03.05.2021
      TRANSLATE WA_TEXT1 TO UPPER CASE .
      WA_OUTPUT-LD_TXT         = WA_TEXT1.     "lD Required

*                                    CLEAR wa_text.
*                                    wa_text = wa_ofm_no-tdline(20).     "ofm sr no
*                                    TRANSLATE wa_text TO UPPER CASE .
*                                    wa_output-ofm_no         = wa_text(1).     "ofm sr no

      WA_OUTPUT-CURR_CON     = LV_EX_RATE-EXCH_RATE.    "Currency conversion

*      CATCH SYSTEM-EXCEPTIONS conversion_errors = 1
*                                          arithmetic_errors = 5.
      IF LV_EX_RATE-EXCH_RATE IS NOT INITIAL.
        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-KBETR *
                                LV_EX_RATE-EXCH_RATE.    "Amount
        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-KBETR *
                                LV_EX_RATE-EXCH_RATE.    "Ordr Amount
        CONDENSE WA_OUTPUT-ORDR_AMT.
      ELSEIF LV_EX_RATE-EXCH_RATE IS INITIAL.
        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-KBETR .
        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-KBETR .
        CONDENSE WA_OUTPUT-ORDR_AMT.
      ENDIF.

*      IF LV_EX_RATE-EXCH_RATE IS NOT INITIAL.
*        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-DIS_UNIT_RATE *  "added by mahadev hement on 11 /12/2025
*                              LV_EX_RATE-EXCH_RATE.    "Amount
*        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-DIS_UNIT_RATE *   "added by mahadev hement on 11 /12/2025
*                               LV_EX_RATE-EXCH_RATE.    "Ordr Amount
*        CONDENSE WA_OUTPUT-ORDR_AMT.
*      ELSEIF LV_EX_RATE-EXCH_RATE IS INITIAL.
*        WA_OUTPUT-AMONT       = WA_OUTPUT-PND_QTY * WA_OUTPUT-DIS_UNIT_RATE .  "added by mahadev hement on 11 /12/2025
*        WA_OUTPUT-ORDR_AMT    = WA_OUTPUT-KWMENG * WA_OUTPUT-DIS_UNIT_RATE .    "added by mahadev hement on 11 /12/2025
*        CONDENSE WA_OUTPUT-ORDR_AMT.
*      ENDIF.
*      ENDCATCH.
      WA_OUTPUT-IN_PR_DT    = WA_MBEW-LAEPR.           "Internal Price Date
      WA_OUTPUT-ST_COST     = WA_MBEW-STPRS .          "Standard Cost
*      wa_output-latst_cost   =  wa_KONV-KBETR.                    "
      WA_OUTPUT-LATST_COST    = WA_KONP-KBETR.        "LATEST EST COST
      WA_OUTPUT-ZSERIES     = WA_MARA-ZSERIES.         "series
      WA_OUTPUT-ZSIZE       = WA_MARA-ZSIZE.           "size
      WA_OUTPUT-BRAND       = WA_MARA-BRAND.           "Brand
      WA_OUTPUT-MOC         = WA_MARA-MOC.             "MOC
      WA_OUTPUT-TYPE        = WA_MARA-TYPE.            "TYPE
      WA_OUTPUT-MTART        = WA_MARA-MTART.          " Material TYPE        """" Addded by KD on 05.05.2017
      WA_OUTPUT-WRKST        = WA_MARA-WRKST.          "Basic Material(Usa Item Code)
*      wa_output-normt      = wa_mara-normt.


      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z015'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-OFM LS_LINES-TDLINE INTO WA_OUTPUT-OFM SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF .
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
*           CLIENT                  = SY-MANDT
            ID                      = 'Z016'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-OFM_DATE LS_LINES-TDLINE INTO WA_OUTPUT-OFM_DATE SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z020'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-SPL LS_LINES-TDLINE INTO WA_OUTPUT-SPL SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
*************USA CUSTOMER CODE
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-BSTKD.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'F22'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'EKKO'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-US_CUST LS_LINES-TDLINE INTO WA_OUTPUT-US_CUST SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      """"""""""""" code added by pankaj 28.01.2022"""""""""""""""""

      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z102'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-PROJ LS_LINES-TDLINE INTO WA_OUTPUT-PROJ SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z103'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-COND LS_LINES-TDLINE INTO WA_OUTPUT-COND SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      """""""""""""""" code ended"""""""""""""""""""""""""""""
      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z012'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-PACKING_TYPE LS_LINES-TDLINE INTO WA_OUTPUT-PACKING_TYPE SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      """""""""""" code added by pankaj 31.01.2022""""""""""""""""

*           infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary TYPE char25

      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z104'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-INFRA LS_LINES-TDLINE INTO WA_OUTPUT-INFRA SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z105'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-VALIDATION LS_LINES-TDLINE INTO WA_OUTPUT-VALIDATION SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF .

      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z106'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-REVIEW_DATE LS_LINES-TDLINE INTO WA_OUTPUT-REVIEW_DATE SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z107'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
              CONCATENATE WA_OUTPUT-DISS_SUMMARY LS_LINES-TDLINE INTO WA_OUTPUT-DISS_SUMMARY SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""

*****************************************************************************************************************************
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z066'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
*              CONCATENATE wa_output-ofm_received_date ls_lines-tdline INTO wa_output-ofm_received_date SEPARATED BY space.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z067'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* Implement suitable error handling here
        ENDIF.
        IF NOT LV_LINES IS INITIAL.
          LOOP AT LV_LINES INTO LS_LINES.
            IF NOT LS_LINES-TDLINE IS INITIAL.
*              CONCATENATE wa_output-oss_received_cell ls_lines-tdline INTO wa_output-oss_received_cell SEPARATED BY space.  """ nc
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
      CLEAR :LV_LINES,LS_LINES.
      REFRESH LV_LINES.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z068'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
*            CONCATENATE wa_output-source_rest ls_lines-tdline INTO wa_output-source_rest SEPARATED BY space.
          ENDIF.
        ENDLOOP.
*        CONDENSE wa_output-source_rest.
      ENDIF.
      REFRESH :LV_LINES.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z069'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBK'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
*            CONCATENATE wa_output-suppl_rest ls_lines-tdline INTO wa_output-suppl_rest SEPARATED BY space.
          ENDIF.
        ENDLOOP.
*        CONDENSE wa_output-suppl_rest.
      ENDIF.
      REFRESH :LV_LINES.
      CLEAR LV_NAME.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'Z110'
          LANGUAGE                = SY-LANGU
          NAME                    = LV_NAME
          OBJECT                  = 'VBBP'
        TABLES
          LINES                   = LV_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
*            CONCATENATE wa_output-cust_mat_desc ls_lines-tdline INTO wa_output-cust_mat_desc SEPARATED BY space.
          ENDIF.
        ENDLOOP.
*        CONDENSE wa_output-cust_mat_desc.
      ENDIF.

*********************************************************************************************************************

      REFRESH : IT_JEST2 , IT_JEST2[] .
      CLEAR : WA_AFPO , WA_CAUFV.

      LOOP AT IT_AFPO INTO WA_AFPO WHERE KDAUF = WA_VBAP-VBELN
                                     AND KDPOS = WA_VBAP-POSNR
                                     AND MATNR = WA_VBAP-MATNR.

        READ TABLE IT_CAUFV INTO WA_CAUFV WITH KEY AUFNR = WA_AFPO-AUFNR
                                                   KDAUF = WA_AFPO-KDAUF
                                                   KDPOS = WA_AFPO-KDPOS.
        IF SY-SUBRC = 0.
          SELECT OBJNR STAT FROM JEST INTO TABLE IT_JEST2
                                WHERE OBJNR = WA_CAUFV-OBJNR
                                  AND INACT = ' '.
********************************Commented by SK(22.09.17)
          CLEAR WA_JEST2 .
          READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0012' BINARY SEARCH .
          IF SY-SUBRC NE 0.
            CLEAR WA_JEST2 .
            READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0009' BINARY SEARCH .
            IF SY-SUBRC NE 0.
              CLEAR WA_JEST2 .
              READ TABLE IT_JEST2 INTO WA_JEST2 WITH KEY STAT = 'I0002' BINARY SEARCH .
              IF SY-SUBRC = 0.
                WA_OUTPUT-WIP = WA_OUTPUT-WIP + WA_AFPO-PSMNG - WA_CAUFV-IGMNG ."wa_afpo-pgmng
              ENDIF.
            ENDIF.
          ENDIF.


        ENDIF.

      ENDLOOP.

      WA_OUTPUT-REF_DT = SY-DATUM.
      """ Ship to party logic

      READ TABLE LT_VBPA INTO LS_VBPA WITH KEY VBELN = WA_VBAP-VBELN POSNR = WA_VBAP-POSNR PARVW = 'WE'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-SHIP_KUNNR = LS_VBPA-KUNNR.
        WA_OUTPUT-SHIP_LAND = LS_VBPA-LAND1.
        READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
        IF SY-SUBRC = 0.
          WA_OUTPUT-SHIP_KUNNR_N = LS_ADRC-NAME1.
          READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY REGION = LS_ADRC-REGION.
          IF SY-SUBRC = 0.
            WA_OUTPUT-SHIP_REG_N = LS_ZGST_REGION-BEZEI.
          ENDIF.
        ENDIF.
      ELSE.
        READ TABLE LT_VBPA INTO LS_VBPA WITH KEY VBELN = WA_VBAP-VBELN POSNR = ' '  PARVW = 'WE'.
        WA_OUTPUT-SHIP_KUNNR = LS_VBPA-KUNNR.
        WA_OUTPUT-SHIP_LAND = LS_VBPA-LAND1.
        READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
        IF SY-SUBRC = 0.
          WA_OUTPUT-SHIP_KUNNR_N = LS_ADRC-NAME1.
          READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY REGION = LS_ADRC-REGION.
          IF SY-SUBRC = 0.
            WA_OUTPUT-SHIP_REG_N = LS_ZGST_REGION-BEZEI.
          ENDIF.
        ENDIF.
      ENDIF.

      READ TABLE LT_VBPA INTO LS_VBPA WITH KEY VBELN = WA_VBAP-VBELN PARVW = 'AG'.
      IF SY-SUBRC = 0.
        WA_OUTPUT-SOLD_LAND = LS_VBPA-LAND1.
        READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
        IF SY-SUBRC = 0.
*          wa_output-ship_kunnr_n = ls_adrc-name1.
          READ TABLE LT_ZGST_REGION INTO LS_ZGST_REGION WITH KEY REGION = LS_ADRC-REGION.
          IF SY-SUBRC = 0.
            WA_OUTPUT-SOLD_REG_N = LS_ZGST_REGION-BEZEI.
          ENDIF.
        ENDIF.
      ENDIF.

      SELECT SINGLE LANDX50 INTO WA_OUTPUT-S_LAND_DESC FROM T005T WHERE SPRAS = 'EN' AND LAND1 = WA_OUTPUT-SHIP_LAND.

      """"""" code added by pankaj 04.02.2022"""""""""""""""""""
* Commented by Dhanashree because this field shows in downloaded excel
**      READ TABLE lt_vbpa INTO ls_vbpa WITH KEY vbeln = wa_vbap-vbeln parvw = 'PT'.
**      IF sy-subrc = 0.
**        wa_output-adrnr = ls_vbpa-adrnr.

      READ TABLE LT_ADRC INTO LS_ADRC WITH KEY ADDRNUMBER = LS_VBPA-ADRNR.
      IF SY-SUBRC = 0.
        WA_OUTPUT-PORT = LS_ADRC-NAME1.

      ENDIF.
*      ENDIF.
      """"""""""""""""""""""""""""""""""""""""""""""""
************        edited by PJ on 08-09-21

      WA_OUTPUT-REF_TIME = SY-UZEIT.

*BREAK PRIMUS.
      CONCATENATE WA_OUTPUT-REF_TIME+0(2) ':' WA_OUTPUT-REF_TIME+2(2)  INTO WA_OUTPUT-REF_TIME.

      """"""""""'''  code added by pankaj 04.02.2022""""""""""""""""""""""""

      CLEAR: LV_LINES, LS_LINES.
      REFRESH LV_LINES.
      LV_NAME = WA_VBAK-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z101'
            LANGUAGE                = 'E'
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      IF NOT LV_LINES IS INITIAL.
        LOOP AT LV_LINES INTO LS_LINES.
          IF NOT LS_LINES-TDLINE IS INITIAL.
            CONCATENATE WA_OUTPUT-FULL_PMNT LS_LINES-TDLINE INTO WA_OUTPUT-FULL_PMNT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.

      READ TABLE IT_TVKTT INTO WA_TVKTT WITH  KEY KTGRD = WA_VBKD-KTGRD .     "wa_output-ktgrd.   "04.02
      IF SY-SUBRC = 0.

        WA_OUTPUT-ACT_ASS       = WA_TVKTT-VTEXT.

      ENDIF.

*     CLEAR wa_jest1.
      READ TABLE IT_JEST3 INTO WA_JEST3 WITH KEY OBJNR = WA_VBAK-OBJNR.

      SELECT SINGLE * FROM TJ30T INTO WA_TJ30T  WHERE ESTAT = WA_JEST3-STAT AND STSMA  = 'OR_HEADR'.

      IF SY-SUBRC = 0.
*        wa_output-stsma      = wa_tj30-stsma.
        WA_OUTPUT-TXT04      = WA_TJ30T-TXT04.
      ENDIF.

      """""""""""" ended"""""""""""""""""""""""""""""""""""""
*********************ADDED BY SHREYA *********************
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME  IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z005'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.
      ENDIF.
      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_ITMTXT.
          IF LS_ITMTXT-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-FREIGHT LS_ITMTXT-TDLINE INTO WA_OUTPUT-FREIGHT SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
********************************ADDED BY JYOTI ON 19.06.2024****************
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME  IS NOT INITIAL.
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z062'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
*      READ TABLE lv_lines INTO ls_itmtxt INDEX 1.
      ENDIF.
      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_ITMTXT.
          IF LS_ITMTXT-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-QUOTA_REF LS_ITMTXT-TDLINE INTO WA_OUTPUT-QUOTA_REF SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
******************************************************************************

      REFRESH LV_LINES.
      CONCATENATE WA_OUTPUT-VBELN WA_OUTPUT-POSNR INTO LV_NAME.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z103'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBP'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF .
      READ TABLE LV_LINES INTO LS_CTBGI INDEX 1.

      IF LV_LINES IS NOT INITIAL.
        LOOP AT LV_LINES INTO LS_CTBGI.
          IF LS_CTBGI-TDLINE IS NOT INITIAL.
            CONCATENATE WA_OUTPUT-PO_SR_NO LS_CTBGI-TDLINE INTO WA_OUTPUT-PO_SR_NO SEPARATED BY SPACE.
          ENDIF.
        ENDLOOP.
      ENDIF.
**************************************** ADDED BY SHREYA**********************
*BREAK-POINT.
      IF WA_VBAP-VBELN IS NOT INITIAL.                                                          """Added by MA on 28.03.2024
        SELECT SINGLE MATNR FROM VBAP INTO @DATA(LV_MATNR) WHERE VBELN = @WA_VBAP-VBELN  AND WERKS = 'PL01'.
        SELECT SINGLE * FROM MAST INTO @DATA(LS_MAST) WHERE MATNR = @LV_MATNR AND WERKS = 'PL01'.
        IF LS_MAST IS NOT INITIAL.
          WA_OUTPUT-BOM_EXIST = 'Yes'.
        ELSEIF LS_MAST IS INITIAL.
          WA_OUTPUT-BOM_EXIST = 'No'.
        ENDIF.
      ENDIF.

************     end
      """""""""""""""""""LD REQUIRED CHANGES BY PRANIT 12.12.2024
      BREAK PRIMUSABAP.
      CLEAR: LV_LINES, LS_ITMTXT.
      REFRESH LV_LINES.
      LV_NAME = WA_OUTPUT-VBELN.
      IF LV_NAME  IS NOT INITIAL .
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            CLIENT                  = SY-MANDT
            ID                      = 'Z038'
            LANGUAGE                = SY-LANGU
            NAME                    = LV_NAME
            OBJECT                  = 'VBBK'
          TABLES
            LINES                   = LV_LINES
          EXCEPTIONS
            ID                      = 1
            LANGUAGE                = 2
            NAME                    = 3
            NOT_FOUND               = 4
            OBJECT                  = 5
            REFERENCE_CHECK         = 6
            WRONG_ACCESS_TO_ARCHIVE = 7
            OTHERS                  = 8.
        IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        IF LV_LINES IS NOT INITIAL.
          LOOP AT LV_LINES INTO LS_ITMTXT.
            IF LS_ITMTXT-TDLINE IS NOT INITIAL.
              CONCATENATE WA_OUTPUT-LD_TXT LS_ITMTXT-TDLINE INTO WA_OUTPUT-LD_TXT SEPARATED BY SPACE.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.

      """""""""""""""""""




      APPEND WA_OUTPUT TO IT_OUTPUT.
      CLEAR LS_VBEP.
      CLEAR:LV_MATNR,LS_MAST.
      CLEAR:WA_OUTPUT-WIP,WA_OUTPUT-STOCK_QTY .
      CLEAR :WA_OUTPUT,WA_VBAP.
    ENDLOOP.

  ENDIF.

  """"""""""""""""""        Added By KD on 05.05.2017                 """""""""""""
  IF IT_OUTPUT[] IS NOT INITIAL.
    REFRESH : IT_OAUTO , IT_OAUTO[] , IT_MAST , IT_MAST[] , IT_STKO , IT_STKO[] ,
              IT_STPO , IT_STPO[] , IT_MARA , IT_MARA[] , IT_MAKT , IT_MAKT[] .

    IT_OAUTO[] = IT_OUTPUT[] .
    DELETE IT_OAUTO WHERE DISPO NE 'AUT' .
    DELETE IT_OAUTO WHERE MTART NE 'FERT'.

    SELECT MATNR WERKS STLAN STLNR STLAL FROM MAST INTO TABLE IT_MAST
                                            FOR ALL ENTRIES IN IT_OAUTO
                                                  WHERE MATNR = IT_OAUTO-MATNR
                                                    AND STLAN = 1.

    SELECT STLTY STLNR STLAL STKOZ FROM STKO INTO TABLE IT_STKO
                                      FOR ALL ENTRIES IN IT_MAST
                                                  WHERE STLNR = IT_MAST-STLNR
                                                    AND STLAL = IT_MAST-STLAL.

    SELECT STLTY STLNR STLKN STPOZ IDNRK FROM STPO INTO TABLE IT_STPO
                                            FOR ALL ENTRIES IN IT_STKO
                                                        WHERE STLNR = IT_STKO-STLNR
                                                          AND STPOZ = IT_STKO-STKOZ .

    SELECT * FROM MARA INTO TABLE IT_MARA FOR ALL ENTRIES IN IT_STPO
                                                    WHERE MATNR = IT_STPO-IDNRK
                                                      AND MTART = 'FERT' .

    SELECT * FROM MAKT INTO TABLE IT_MAKT FOR ALL ENTRIES IN IT_MARA
                                                      WHERE MATNR = IT_MARA-MATNR
                                                        AND SPRAS = 'EN'.

    CLEAR WA_OUTPUT .
    LOOP AT IT_MAKT INTO WA_MAKT .
      READ TABLE IT_STPO INTO WA_STPO WITH KEY IDNRK = WA_MAKT-MATNR .
      IF SY-SUBRC = 0.
        READ TABLE IT_STKO INTO WA_STKO WITH KEY STLNR = WA_STPO-STLNR STKOZ = WA_STPO-STPOZ .
        IF SY-SUBRC = 0.
          READ TABLE IT_MAST INTO WA_MAST WITH KEY STLNR = WA_STKO-STLNR STLAL = WA_STKO-STLAL.
          IF SY-SUBRC = 0.
            WA_OUTPUT-MATNR = WA_MAST-MATNR.
*            wa_output-scmat = wa_makt-matnr.
            WA_OUTPUT-ARKTX = WA_MAKT-MAKTX.
            CLEAR: LV_LINES, LS_ITMTXT.



*            BREAK primus.

*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z012'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-packing_type ls_lines-tdline INTO wa_output-packing_type SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.

*
*            """""""""""" code added by pankaj 31.01.2022""""""""""""""""
*
**           infra        TYPE char255,         "added by pankaj 31.01.2022
**          validation   TYPE char255,         "added by pankaj 31.01.2022
**          review_date  TYPE char255,         "added by pankaj 31.01.2022
**          diss_summary TYPE char25
*
*           CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z104'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-infra ls_lines-tdline INTO wa_output-infra SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z105'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-validation ls_lines-tdline INTO wa_output-validation SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*            lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z106'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-review_date ls_lines-tdline INTO wa_output-review_date SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*
*            CLEAR: lv_lines, ls_lines.
*            REFRESH lv_lines.
*           lv_name = wa_vbak-vbeln.
*            CALL FUNCTION 'READ_TEXT'
*              EXPORTING
*                client                  = sy-mandt
*                id                      = 'Z107'
*                language                = 'E'
*                name                    = lv_name
*                object                  = 'VBBK'
*              TABLES
*                lines                   = lv_lines
*              EXCEPTIONS
*                id                      = 1
*                language                = 2
*                name                    = 3
*                not_found               = 4
*                object                  = 5
*                reference_check         = 6
*                wrong_access_to_archive = 7
*                OTHERS                  = 8.
*            IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*            ENDIF.
*
*            IF NOT lv_lines IS INITIAL.
*              LOOP AT lv_lines INTO ls_lines.
*                IF NOT ls_lines-tdline IS INITIAL.
*                  CONCATENATE wa_output-diss_summary ls_lines-tdline INTO wa_output-diss_summary SEPARATED BY space.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*
*            """""""""""""""""""""" code ended 31.01.2022"""""""""""""""""""""""""""""""""""""
            APPEND WA_OUTPUT TO IT_OUTPUT.
            CLEAR WA_OUTPUT .
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR : WA_MAST , WA_STKO , WA_STPO , WA_MAKT.
    ENDLOOP.

  ENDIF.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

ENDFORM.                    " PROCESS_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM ALV_FOR_OUTPUT .
*ADDING TOP OF PAGE FEATURE
  PERFORM STP3_EVENTTAB_BUILD   CHANGING GT_EVENTS[].
  PERFORM COMMENT_BUILD         CHANGING I_LIST_TOP_OF_PAGE[].
  PERFORM TOP_OF_PAGE.
  PERFORM LAYOUT_BUILD          CHANGING WA_LAYOUT.
****************************************************************************************

  PERFORM BUILD_FIELDCAT USING 'WERKS'          'X' '1'   'Plant'(003)                    '15'.
  PERFORM BUILD_FIELDCAT USING 'AUART'          'X' '2'   'Order Type'(004)               '15'.
  PERFORM BUILD_FIELDCAT USING 'BSTKD'          'X' '3'   'Customer Reference No'(005)    '15'.
  PERFORM BUILD_FIELDCAT USING 'NAME1'          'X' '4'   'Customer'(006)                 '15'.
  PERFORM BUILD_FIELDCAT USING 'VKBUR'          'X' '5'   'Sales Office'(007)             '15'.
  PERFORM BUILD_FIELDCAT USING 'VBELN'          'X' '6'   'Sales Doc No'(008)             '15'.
  PERFORM BUILD_FIELDCAT USING 'ERDAT'          'X' '7'   'So Date'(009)                  '15'.
  PERFORM BUILD_FIELDCAT USING 'VDATU'          'X' '8'   'Required Delivery Dt'          '15'."(010).
  PERFORM BUILD_FIELDCAT USING 'STATUS'         'X' '9'   'HOLD/UNHOLD'(011)              '15'.
  PERFORM BUILD_FIELDCAT USING 'HOLDDATE'       'X' '10'  'HOLD Date'(012)                '15'.
  PERFORM BUILD_FIELDCAT USING 'RELDATE'        'X' '11'  'Release Date'(013)             '15'.
  PERFORM BUILD_FIELDCAT USING 'CANCELDATE'     'X' '12'  'CANCELLED Date'(014)           '15'.
  PERFORM BUILD_FIELDCAT USING 'DELDATE'        'X' '13'  'Delivery Date'                 '15'. "(015)
  PERFORM BUILD_FIELDCAT USING 'TAG_REQ'        'X' '14'  'TAG Required'(049)             '50'.
  PERFORM BUILD_FIELDCAT USING 'TPI'            'X' '15'  'TPI Required'(044)             '50'.
  PERFORM BUILD_FIELDCAT USING 'LD_TXT'         'X' '16'  'LD Required'(050)              '50'.
  PERFORM BUILD_FIELDCAT USING 'ZLDPERWEEK'     'X' '17' 'LD %Per Week'(046)              '15'.
  PERFORM BUILD_FIELDCAT USING 'ZLDMAX'        'X' '18'  'LD % Max'(047)                  '15'.
  PERFORM BUILD_FIELDCAT USING 'ZLDFROMDATE'    'X' '19' 'LD From Date'(048)              '15'.
*  PERFORM BUILD_FIELDCAT USING ''                'X' '18'  ''(0).
*  PERFORM BUILD_FIELDCAT USING ''                'X' '19'  ''(0).
  PERFORM BUILD_FIELDCAT USING 'MATNR'          'X' '20'   'Item Code'(016)               '18'.
*  PERFORM build_fieldcat USING 'SCMAT'          'X' '21'   'Sub-Item Code'(053).
  PERFORM BUILD_FIELDCAT USING 'POSNR'          'X' '21'   'Line Item'(017)               '15'.
  PERFORM BUILD_FIELDCAT USING 'ARKTX'          'X' '22'   'Item Description'(018)        '20'.
  PERFORM BUILD_FIELDCAT USING 'KWMENG'         'X' '23'   'SO QTY'(019)                  '15'.
*  PERFORM build_fieldcat USING 'KALAB'          'X' '25'   'Stock Qty'(020).
  PERFORM BUILD_FIELDCAT USING 'STOCK_QTY'          'X' '24'   'Stock Qty'(020)           '15'.
  PERFORM BUILD_FIELDCAT USING 'LFIMG'          'X' '25'   'Delivary Qty'(021)            '15'.
  PERFORM BUILD_FIELDCAT USING 'FKIMG'          'X' '26'   'Invoice Quantity'(022)        '15'.
  PERFORM BUILD_FIELDCAT USING 'PND_QTY'        'X' '27'   'Pending Qty'(023)             '15'.
  PERFORM BUILD_FIELDCAT USING 'ETTYP'          'X' '28'   'SO Status'(024)               '15'.
  PERFORM BUILD_FIELDCAT USING 'MRP_DT'         'X' '29'   'MRP Date'(045)                '15'.
  PERFORM BUILD_FIELDCAT USING 'EDATU'          'X' '30'   'Production date'              '15'.   "'Posting Date'(025).
  PERFORM BUILD_FIELDCAT USING 'KBETR'          'X' '31'   'Rate'(026)                    '15'.
  PERFORM BUILD_FIELDCAT USING 'WAERK'          'X' '32'   'Currency Type'(027)           '15'.
  PERFORM BUILD_FIELDCAT USING 'CURR_CON'       'X' '33'   'Currency Conv'(028)           '15'.
  PERFORM BUILD_FIELDCAT USING 'SO_EXC'       'X' '34'   'SO Exchange Rate'(051)          '15'.
  PERFORM BUILD_FIELDCAT USING 'AMONT'          'X' '35'   'Pending SO Amount'            '15'.
  PERFORM BUILD_FIELDCAT USING 'ORDR_AMT'       'X' '36'   'Order Amount'(030)            '15'.
*  PERFORM BUILD_FIELDCAT USING 'KURSK'          'X' '34'   ''(031).
  PERFORM BUILD_FIELDCAT USING 'IN_PRICE'        'X' '37'   'Internal Price'(032)         '15'.
  PERFORM BUILD_FIELDCAT USING 'IN_PR_DT'        'X' '38'   'Internal Price Date'(033)    '15'.
  PERFORM BUILD_FIELDCAT USING 'EST_COST'        'X' '39'   'Estimated Cost'(034)         '15'.
  PERFORM BUILD_FIELDCAT USING 'LATST_COST'      'X' '40'   'Latest Estimated Cost'(035)  '15'.
  PERFORM BUILD_FIELDCAT USING 'ST_COST'         'X' '41'   'Standard Cost'(036)          '15'.
  PERFORM BUILD_FIELDCAT USING 'ZSERIES'         'X' '42'   'Series'(037)                 '15'.
  PERFORM BUILD_FIELDCAT USING 'ZSIZE'           'X' '43'   'Size'(038)                   '15'.
  PERFORM BUILD_FIELDCAT USING 'BRAND'           'X' '44'   'Brand'(039)                  '15'.
  PERFORM BUILD_FIELDCAT USING 'MOC'             'X' '45'   'MOC'(040)                    '15'.
  PERFORM BUILD_FIELDCAT USING 'TYPE'            'X' '46'   'Type'(041)                   '15'.
  """"""""""""'   Added By KD on 04.05.2017    """""""
  PERFORM BUILD_FIELDCAT USING 'DISPO'            'X' '47'   'MRP Controller'(051)        '15'.
  PERFORM BUILD_FIELDCAT USING 'WIP'              'X' '48'   'WIP'(052)                   '15'.
  PERFORM BUILD_FIELDCAT USING 'MTART'            'X' '49'   'MAT TYPE'                   '15'.
  PERFORM BUILD_FIELDCAT USING 'KDMAT'            'X' '50'   'CUST MAT NO'                '15'.
  PERFORM BUILD_FIELDCAT USING 'KUNNR'            'X' '51'   'CUSTOMER CODE'              '15'.
  PERFORM BUILD_FIELDCAT USING 'QMQTY'            'X' '52'   'QM QTY'                     '15'.
  PERFORM BUILD_FIELDCAT USING 'MATTXT'           'X' '53'   'Material Text'              '20'.
  PERFORM BUILD_FIELDCAT USING 'ITMTXT'           ' ' '54'   'Sales Text'                 '50'.
  PERFORM BUILD_FIELDCAT USING 'ETENR'            'X' '55'   'Schedule_no'                '15'.
  PERFORM BUILD_FIELDCAT USING 'SCHID'            'X' '56'   'Schedule_id'                'string'.
  PERFORM BUILD_FIELDCAT USING 'ZTERM'            'X' '57'   'Payment Terms'              '15'.
  PERFORM BUILD_FIELDCAT USING 'TEXT1'            'X' '58'   'Payment Terms Text'         '15'.
  PERFORM BUILD_FIELDCAT USING 'INCO1'            'X' '59'   'Inco Terms'                 '15'.
  PERFORM BUILD_FIELDCAT USING 'INCO2'            'X' '60'   'Inco Terms Descr'           '15'.
  PERFORM BUILD_FIELDCAT USING 'OFM'              'X' '61'   'OFM No.'                    '15'.
  PERFORM BUILD_FIELDCAT USING 'OFM_DATE'         'X' '62'   'OFM Date'                   '15'.
  PERFORM BUILD_FIELDCAT USING 'SPL'              'X' '63'   'Special Instruction'        '15'.
  PERFORM BUILD_FIELDCAT USING 'CUSTDELDATE'      'X' '64'  'Customer Delivery Dt'        '15'.   "(015).
  PERFORM BUILD_FIELDCAT USING 'ABGRU'            'X' '65'  'Rejection Reason Code'       '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM BUILD_FIELDCAT USING 'BEZEI'            'X' '66'  'Rejection Reason Description' '15'.   "   AVINASH BHAGAT 20.12.2018
  PERFORM BUILD_FIELDCAT USING 'WRKST'            'X' '67'  'USA Item Code'                '15'.
  PERFORM BUILD_FIELDCAT USING 'CGST'             'X' '68'  'CGST%'                        '15'.
*  PERFORM build_fieldcat USING 'CGST_VAL'         'X' '69'  'CGST'.
  PERFORM BUILD_FIELDCAT USING 'SGST'             'X' '70'  'SGST%'                        '15'.
*  PERFORM build_fieldcat USING 'SGST_VAL'         'X' '71'  'SGST'.
  PERFORM BUILD_FIELDCAT USING 'IGST'              'X' '72'  'IGST%'                       '15'.
*  PERFORM build_fieldcat USING 'IGST_VAL'         'X' '73'  'IGST'.
  PERFORM BUILD_FIELDCAT USING 'SHIP_KUNNR'         'X' '73'  'Ship To Party'              '15'.
  PERFORM BUILD_FIELDCAT USING 'SHIP_KUNNR_N'       'X' '74'  'Ship To Party Description'  '15'.
  PERFORM BUILD_FIELDCAT USING 'SHIP_REG_N'         'X' '75'  'Ship To Party State'        '15'.
  PERFORM BUILD_FIELDCAT USING 'SOLD_REG_N'         'X' '76'  'Sold To Party State'        '15'.
*  perform build_fieldcat using 'NORMT'              'X' '77'       'Industry Std Desc.'           '15'.
  PERFORM BUILD_FIELDCAT USING 'SHIP_LAND'          'X' '78'   'Ship To Party Country Key'    '15'.
  PERFORM BUILD_FIELDCAT USING 'S_LAND_DESC'        'X' '79'   'Ship To Party Country Desc'  '15'.
  PERFORM BUILD_FIELDCAT USING 'SOLD_LAND'          'X' '80' 'Sold To Party Country Key'     '15'.
  PERFORM BUILD_FIELDCAT USING 'POSEX'              'X' '81' 'Purchase Order Item'               '15'.
  PERFORM BUILD_FIELDCAT USING 'BSTDK'              'X' '82' 'PO Date'                        '15'.
  PERFORM BUILD_FIELDCAT USING 'LIFSK'              'X' '83' 'Delivery Block(Header Loc)'                     '15'.
  PERFORM BUILD_FIELDCAT USING 'VTEXT'              'X' '84' 'Delivery Block Txt'               '15'.
  PERFORM BUILD_FIELDCAT USING 'INSUR'              'X' '85' 'Insurance'               '15'.
  PERFORM BUILD_FIELDCAT USING 'PARDEL'             'X' '86' 'Partial Delivery'               '15'.
  PERFORM BUILD_FIELDCAT USING 'GAD'                'X' '87' 'GAD'               '15'.
  PERFORM BUILD_FIELDCAT USING 'US_CUST'            'X' '88' 'USA Customer Name'               '15'.
  PERFORM BUILD_FIELDCAT USING 'TCS'                'X' '89' 'TCS Rate'               '15'.
  PERFORM BUILD_FIELDCAT USING 'TCS_AMT'            'X' '90' 'TCS Amount'               '15'.
  PERFORM BUILD_FIELDCAT USING 'PO_DEL_DATE'        'X' '91' 'PO_Delivery_Date'               '15'.
  PERFORM BUILD_FIELDCAT USING 'OFM_NO'             'X' '92' 'OFM SR. NO.'               '15'.
  PERFORM BUILD_FIELDCAT USING 'CTBG'              'X' '93' 'CTBG Item Details'               '20'.
  PERFORM BUILD_FIELDCAT USING 'CERTIF'             'X' '94' 'Certificate Details'             '20'.
  PERFORM BUILD_FIELDCAT USING 'ITEM_TYPE'             'X' '95' 'Item Type'             '20'. "edited by PJ on16-08-21
  PERFORM BUILD_FIELDCAT USING 'REF_TIME'             'X' '96' 'Ref. Time'             '15'. "edited by PJ on 08-09-21
*  PERFORM build_fieldcat USING 'CTBG'             'X' '94' 'CTBG Details'             '10'.

  """""""""""""""" "added by pankaj 28.01.2022""""""""""""""""

  PERFORM BUILD_FIELDCAT USING 'PROJ'               'X' '97' 'Project Owner Details'             '15'. "added by pankaj 28.01.2022
  PERFORM BUILD_FIELDCAT USING 'COND'               'X' '98' 'Condition Delivery Date'             '15'. "added by pankaj 28.01.2022
  PERFORM BUILD_FIELDCAT USING 'RECEIPT_DATE'       'X' '99' 'Code Receipt Date'             '15'. "added by pankaj 28.01.2022
  PERFORM BUILD_FIELDCAT USING 'REASON'             'X' '100' 'Reason'             '15'.               "added by pankaj 28.01.2022
  PERFORM BUILD_FIELDCAT USING 'NTGEW'             'X' '101' 'New Weight'             '15'.               "added by pankaj 28.01.2022
  PERFORM BUILD_FIELDCAT USING 'ZPR0'             'X' '102' 'Condition ZPR0'           '15'.
  PERFORM BUILD_FIELDCAT USING 'ZPF0'             'X' '103' 'Condition ZPF0'           '15'.
  PERFORM BUILD_FIELDCAT USING 'ZIN1'               'X' '104' 'Condition ZIN1'           '15'.
  PERFORM BUILD_FIELDCAT USING 'ZIN2'               'X' '105' 'Condition ZIN2'           '15'.
  PERFORM BUILD_FIELDCAT USING 'JOIG'               'X' '106' 'Condition JOIG'           '15'.
  PERFORM BUILD_FIELDCAT USING 'JOCG'               'X' '107' 'Condition JOCG'           '15'.
  PERFORM BUILD_FIELDCAT USING 'JOSG'               'X' '108' 'Condition JOSG'           '15'.
  PERFORM BUILD_FIELDCAT USING 'DATE'               'X' '109' 'Schedule line del.Date'  '15'.
  PERFORM BUILD_FIELDCAT USING 'PRSDT'               'X' '110' 'Pricing Date'            '15'.
  PERFORM BUILD_FIELDCAT USING 'PACKING_TYPE'               'X' '111' 'Packing Type'            '15'.
  PERFORM BUILD_FIELDCAT USING 'OFM_DATE1'               'X' '112' 'OFM Delivery Date'            '15'.
  PERFORM BUILD_FIELDCAT USING 'MAT_TEXT'               'X' '113' 'Material Sales Text'            '15'.
  "PERFORM build_fieldcat USING 'ERDAT1'               'X' '113' 'SO Change Date '            '15'.

  """""""""""""""""""""""" ended """"""""""""""""""""""""""""""""""'
*infra        TYPE char255,         "added by pankaj 31.01.2022
*          validation   TYPE char255,         "added by pankaj 31.01.2022
*          review_date  TYPE char255,         "added by pankaj 31.01.2022
*          diss_summary
  """"""""""""""""""""""""Coded added by pankaj 31.01.2022  """"""""""""""""""""""""""""

  PERFORM BUILD_FIELDCAT USING 'INFRA'                      'X' '114' 'Infrastructure Required'            '15'.
  PERFORM BUILD_FIELDCAT USING 'VALIDATION'                 'X' '115' 'Validation Plan Refrence'            '15'.
  PERFORM BUILD_FIELDCAT USING 'REVIEW_DATE'                'X' '116' 'Review Date'            '15'.
  PERFORM BUILD_FIELDCAT USING 'DISS_SUMMARY'                'X' '117' 'Discussion Summary'            '15'.
  PERFORM BUILD_FIELDCAT USING 'CHANG_SO_DATE'                'X' '118' 'Changed SO Date'            '15'.

  """"""" added by pankaj 04.02.2022"""""""""""""""

  PERFORM BUILD_FIELDCAT USING 'PORT'                      'X'       '119' 'Port'                         '15'.
  PERFORM BUILD_FIELDCAT USING 'FULL_PMNT'                 'X'       '120' 'Full Payment Desc'            '15'.
  PERFORM BUILD_FIELDCAT USING 'ACT_ASS'                   'X'       '121' 'Act Assignments'            '15'.
  PERFORM BUILD_FIELDCAT USING 'TXT04'                     'X'       '122' 'User Status'            '15'.
*  perform build_fieldcat using 'KWERT'                     'X'       '123' 'Condition Value ZPR0'            '15'.
  PERFORM BUILD_FIELDCAT USING 'FREIGHT'                     'X'       '124' 'Freight'            '15'.
  " PERFORM build_fieldcat USING 'OFM_SR_NO'                     'X'       '125' 'OFM SR NO'            '15'.
  PERFORM BUILD_FIELDCAT USING 'PO_SR_NO'                     'X'       '126' 'PO SR NO TEXT'            '15'.

  PERFORM BUILD_FIELDCAT USING 'UDATE'                      'X'         '127' 'Last changed date'        '15'.
  PERFORM BUILD_FIELDCAT USING 'BOM'                      'X'         '128' 'BOM Status'        '15'.
  PERFORM BUILD_FIELDCAT USING 'ZPEN_ITEM'                      'X'         '129' 'Pending Items'        '15'.
  PERFORM BUILD_FIELDCAT USING 'ZRE_PEN_ITEM'                      'X'         '130' 'Reason for Pending Items'        '15'.
*  perform build_fieldcat using 'VTEXT1'                      'X'         '131' 'Billing Block'        '15'.
  PERFORM BUILD_FIELDCAT USING 'ZINS_LOC'                      'X'         '131' 'Installation Location'        '15'.
  PERFORM BUILD_FIELDCAT USING 'BOM_EXIST'                      'X'         '132' 'BOM EXISTS '        '15'.
*   perform build_fieldcat using 'BSTKD1'          'X' '133'   'Line Item Wise PO No'    '15'."ADDED BY JYOTI ON 16.04.2024
  PERFORM BUILD_FIELDCAT USING 'POSEX1'              'X' '134' 'PO Item No'               '15'."ADDED BY JYOTI ON 16.04.2024
  PERFORM BUILD_FIELDCAT USING 'LGORT'              'X' '135' 'Storage Location'               '15'."ADDED BY Pranit ON 10.04.2024
  PERFORM BUILD_FIELDCAT USING 'QUOTA_REF'              'X' '136' 'QT Reference No.'               '15'."ADDED BY jyoti ON 19.06.2024
  PERFORM BUILD_FIELDCAT USING 'ZMRP_DATE'              'X' '137' 'DV_PLMRPDATE'               '15'."ADDED BY jyoti ON 02.07.2024


*********************************************************************************
  PERFORM BUILD_FIELDCAT USING 'VKORG' 'X'  '138' 'Sales Organization'   '4'. " ADD BY SUPRIYA ON 19.08.2024
  PERFORM BUILD_FIELDCAT USING 'VTWEG' 'X' '139'  'Distribution Channel' '2'." ADD BY SUPRIYA ON 19.08.2024
  PERFORM BUILD_FIELDCAT USING 'SPART' 'X' '140'  'Division' '2'.               " ADD BY SUPRIYA ON 19.08.2024

*******************************************************************************
  PERFORM BUILD_FIELDCAT USING 'ZEXP_MRP_DATE1'              'X' '141' 'Expected MRP Date'               '15'."ADDED BY jyoti ON 02.07.2024
  PERFORM BUILD_FIELDCAT USING 'SPECIAL_COMM'                'X' '142' 'Special Comments'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM BUILD_FIELDCAT USING 'ZCUST_PROJ_NAME'                'X' '143' 'Customer Project NAme'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM BUILD_FIELDCAT USING 'AMENDMENT_HIS'                'X' '144' 'Amendment_history'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM BUILD_FIELDCAT USING 'PO_DIS'                'X' '145' 'Po Discrepancy'                '20'."ADDED BY jyoti ON 02.07.2024
  PERFORM BUILD_FIELDCAT USING 'HOLD_REASON_N1'                'X' '146' 'Hold Reason'                '20'."ADDED BY jyoti ON 02.07.2024
*  PERFORM BUILD_FIELDCAT USING 'DIS_RATE'                'X' '147' 'Dis %'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
*  PERFORM BUILD_FIELDCAT USING 'DIS_AMT'                'X' '148' 'Discount Amount'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025
*  PERFORM BUILD_FIELDCAT USING 'DIS_UNIT_RATE'                'X' '149' 'Discount Unit Rate'                '20'."ADDED BY MAHADEV HEMENT  ON 10.12.2025


  """"""" ended """"""""""""""""""""""""""""

*          dispo       TYPE marc-dispo,
*          wip         TYPE i,
*          mtart       TYPE mara-mtart,
*          kdmat       TYPE vbap-kdmat,
*          etenr       type vbep-etenr,
*          kunnr       TYPE kna1-kunnr,

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM = SY-REPID
      I_STRUCTURE_NAME   = 'OUTPUT'
      IS_LAYOUT          = WA_LAYOUT
      IT_FIELDCAT        = IT_FCAT
*     it_sort            = i_sort
*     i_default          = 'A'
*     i_save             = 'A'
      I_SAVE             = 'X'
      IT_EVENTS          = GT_EVENTS[]
    TABLES
      T_OUTTAB           = IT_OUTPUT
    EXCEPTIONS
      PROGRAM_ERROR      = 1
      OTHERS             = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  REFRESH IT_OUTPUT.
ENDFORM.                    " ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
*&      Form  STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*

FORM STP3_EVENTTAB_BUILD  CHANGING P_GT_EVENTS TYPE SLIS_T_EVENT.

  DATA: LF_EVENT TYPE SLIS_ALV_EVENT. "WORK AREA

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      I_LIST_TYPE     = 0
    IMPORTING
      ET_EVENTS       = P_GT_EVENTS
    EXCEPTIONS
      LIST_TYPE_WRONG = 1
      OTHERS          = 2.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  MOVE C_FORMNAME_TOP_OF_PAGE TO LF_EVENT-FORM.
  MODIFY P_GT_EVENTS  FROM  LF_EVENT INDEX 3 TRANSPORTING FORM."TO P_I_EVENTS .

ENDFORM.                    " STP3_EVENTTAB_BUILD
*&---------------------------------------------------------------------*
*&      Form  COMMENT_BUILD
*&---------------------------------------------------------------------*
FORM COMMENT_BUILD CHANGING I_LIST_TOP_OF_PAGE TYPE SLIS_T_LISTHEADER.
  DATA: LF_LINE       TYPE SLIS_LISTHEADER. "WORK AREA
*--LIST HEADING -  TYPE H
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_H.
  LF_LINE-INFO =  ''(042).
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.
*--HEAD INFO: TYPE S
  CLEAR LF_LINE.
  LF_LINE-TYP  = C_S.
  LF_LINE-KEY  = TEXT-043.
  LF_LINE-INFO = SY-DATUM.
  WRITE SY-DATUM TO LF_LINE-INFO USING EDIT MASK '__.__.____'.
  APPEND LF_LINE TO I_LIST_TOP_OF_PAGE.

ENDFORM.                    " COMMENT_BUILD
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP_OF_PAGE .

*** THIS FM IS USED TO CREATE ALV HEADER
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = I_LIST_TOP_OF_PAGE[]. "INTERNAL TABLE WITH


ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM LAYOUT_BUILD  CHANGING P_WA_LAYOUT TYPE SLIS_LAYOUT_ALV.

*        IT_LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  WA_LAYOUT-ZEBRA          = 'X'.
*        P_WA_LAYOUT-INFO_FIELDNAME = 'C51'.
  P_WA_LAYOUT-ZEBRA          = 'X'.
  P_WA_LAYOUT-NO_COLHEAD        = ' '.
*  WA_LAYOUT-BOX_FIELDNAME     = 'BOX'.
*  WA_LAYOUT-BOX_TABNAME       = 'IT_FINAL_ALV'.


ENDFORM.                    " LAYOUT_BUILD
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM BUILD_FIELDCAT  USING    V1  V2 V3 V4 V5.
  WA_FCAT-FIELDNAME   = V1 ." 'VBELN'.
  WA_FCAT-TABNAME     = 'IT_OUTPUT'.  "'IT_FINAL_NEW'.
* WA_FCAT-_ZEBRA      = 'X'.

*  WA_FCAT-KEY         =  V2 ."  'X'.   "Remove Key to enable scrollbar
  WA_FCAT-SELTEXT_L   =  V4.
  WA_FCAT-OUTPUTLEN   =  V5." 20.
*  wa_fcat-ddictxt     =  'L'.
***  wa_fcat-seltext_l      =  'L'.

  WA_FCAT-COL_POS     =  V3.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.

" BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWN_SET .
*  BREAK fujiabap.
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
*break primus.
  PERFORM NEW_FILE_1."added by jyoti on 26.04.2024
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_OUTPUT_NEW "it_output
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.                "added for check
  LV_FILE = 'ZDELPENDSO_1_V1.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPENDSO_1 Download started on', SY-DATUM, 'at', SY-UZEIT.
  IF OPEN_SO IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', S_DATE-LOW, 'To', S_DATE-HIGH.
  WRITE: / 'Material code   From', S_MATNR-LOW, 'To', S_MATNR-HIGH.
  WRITE: / 'Dest. File:', LV_FULLFILE.

  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1362 TYPE STRING.
    DATA LV_CRLF_1362 TYPE STRING.
    LV_CRLF_1362 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1362 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1362 LV_CRLF_1362 WA_CSV INTO LV_STRING_1362.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_1362 TO LV_FULLFILE.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
******************************************************new file zpendso **********************************
  PERFORM NEW_FILE.
*  break primus.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.       "added for check
  LV_FILE = 'ZDELPENDSO_1_V1.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPENDSO_1 Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1363 TYPE STRING.
    DATA LV_CRLF_1363 TYPE STRING.
    LV_CRLF_1363 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1363 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1363 LV_CRLF_1363 WA_CSV INTO LV_STRING_1363.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_1363 TO LV_FULLFILE.
*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
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
  CONCATENATE
           'PLANT'
           'ORDER TYPE'
           'CUST REF NO'
           'CUSTOMER NAME'
           'SALES OFFICE'
           'SALES DOC NO'
           'SO DATE'
           'REQUIRED DELIVERY DATE'
           'HOLD/UNHOLD'
           'HOLD DATE'
           'REL DATE'
           'CANCEL DATE'
           'DELV DATE'
           'TAG_REQD'
           'TPI REQD'
           'LD REQD'
           'LD PER WEEK'
           'LD MAX'
           'LD FROM DATE'
           'MAT NR'
           'POS NR'
           'DESCRIPTION'
           'SO QTY'
           'STOCK QTY'
           'DELIVARY QTY'
           'INVOICE QUANTITY'
           'PENDING QTY'
           'SO STATUS'
           'MRP DATE'
           'PRODUCTION DATE'
           'RATE'
           'CURRENCY'
           'CURRENCY CONV'
*          'SO Exchange Rate'
           'PENDING SO AMOUNT'
           'ORDER AMOUNT'
           'INTERNAL PRICE'
           'INTERNAL PRICE DATE'
           'ESTIMATED COST'
           'LATEST ESTIMATED COST'
           'STANDARD COST'
           'SERIES'
           'SIZE'
           'BRAND'
           'MOC'
           'TYPE'
           'MRP CONTROLLER'
           'WIP'
           'MAT TYPE'
           'CUST MAT NO'
           'CUSTOMER'
           'QM QTY'
           'Description Long'
           'MATTXT'              "'Sales Text'
           'SCHD NO'
           'SCHEDULE_ID'
           'SO Exchange Rate'
           'Payment Terms'
           'Payment Terms Text'
           'Inco Terms'
           'Inco Terms Descr'
           'OFM No.'
           'OFM Date'
           'CUSTOMER DEL DATE'
           'File Created Date'
           'Rejection Reason Code'
           'Rejection Reason Description'
           'USA Item Code'
           'CGST%'
*          'CGST'
           'SGST%'
*          'SGST'
           'IGST%'
*          'IGST'
           'Ship To Party'
           'Ship To Party Description'
           'Ship To Party State'
           'Sold To Party State'
           'Industry Std Desc.'
           'Ship To Party Country Key'
           'Sold To Party Country Key'
           'Purchase Order Item'
           'Ship To Party Country Desc'
           'PO Date'
           'Delivery Block(Header Loc)'
           'Delivery Block Txt'
            'Insurance'
           'Partial Delivery'
           'GAD'
           'USA Customer Name'
           'TCS Rate'
           'TCS Amount'
           'Special Instruction'
           'PO_Delivery_Date'
           'OFM SR. NO.'
           'CTBG Item Details'
           'Certificate Details'
           'Item Type' "  edited by PJ on 16-08-21
           'Ref. Time' "  edited by PJ on 08-09-21
*          'CTBG Details'
           'Project Ownwer Name'            "added by pankaj 28.01.2022
           'Condition Delivery Date'        "added by pankaj 28.01.2022
           'Code Receipt Date'              "added by pankaj 28.01.2022
           'Reason'                         "added by pankaj 28.01.2022
           'Net Weight'                         "added by pankaj 28.01.2022
           'Condition ZPR0'
           'Condition ZPF0'
           'Condition ZIN1'
           'Condition ZIN2'
           'Condition JOIG'
           'Condition JOCG'
           'Condition JOSG'
           'Schedule line del.Dat'
           'Pricing Date'
           'Packing Type'
           'OFM Delivery Date'
           'Material Sales Text'
           'Infrastructure required'        "added by pankaj 31.01.2022
           'Validation Plan Refrence'          "added by pankaj 31.01.2022
           'Review Date'                      "added by pankaj 31.01.2022
           'Discussion Summary'                "added by pankaj 31.01.2022
           'Changed SO Date'
           'Port'                                   "added by pankaj 04.02.2022
           'Full Payment Desc'                     "added by pankaj 04.02.2022
           'Act Assignments'                       "added by pankaj 04.02.2022
           'User Status'                             "added by pankaj 04.02.2022
           'Freight'
           "'OFM SR NO'
           'PO SR NO Text'
           'Last changed date'
           'BOM Status'
           'Pending Items'
           'Reason for Pending Items'
            'Installation Location'
            'BOM EXISTS '
            'Po Item No.'
*          'Billing Block'
            'Storage Location'         ""Added by Pranit 10.06.2024
            'QT Reference No.'   "added by jyoti on 19.06.2024
            'DV_PLMRPDATE'  "added by jyoti on 02.07.2024
            'Sales Organization'
            'Distribution Channel'
            'Division'
            'Expected MRP Date'
            'Special Comments'
            'Customer Project Name'
            'Amendment_history'
            'Po Discrepancy'
            'Hold Reason'  "added by jyoti on 06.02.2024
            'SO QTY KTPI'
            'SO QTY TPI1'
            'OFM Received Dt. from pre-sales'
            'OSS received fr Technical Cell'
            'Sourcing restrictions'
            'Supplier restrictions'
            'Customer Material Description'
            'Dis %'               "added by mahadev 17.12.2025
            'Discount Amount'               "added by mahadev 17.12.2025
            'Discount Unit Rate'               "added by mahadev 17.12.2025
   INTO PD_CSV
   SEPARATED BY L_FIELD_SEPERATOR.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM NEW_FILE .
  DATA:
    LS_FINAL TYPE T_FINAL.

  LOOP AT IT_OUTPUT INTO WA_OUTPUT.
    LS_FINAL-WERKS       = WA_OUTPUT-WERKS.
    LS_FINAL-AUART       = WA_OUTPUT-AUART.
    LS_FINAL-BSTKD       = WA_OUTPUT-BSTKD.
    LS_FINAL-NAME1       = WA_OUTPUT-NAME1.
    LS_FINAL-VKBUR       = WA_OUTPUT-VKBUR.
    LS_FINAL-VBELN       = WA_OUTPUT-VBELN.
    LS_FINAL-STATUS      = WA_OUTPUT-STATUS.
    LS_FINAL-TAG_REQ     = WA_OUTPUT-TAG_REQ.
    LS_FINAL-TPI         = WA_OUTPUT-TPI.
    LS_FINAL-LD_TXT      = WA_OUTPUT-LD_TXT.
    LS_FINAL-ZLDPERWEEK  = WA_OUTPUT-ZLDPERWEEK.
    LS_FINAL-ZLDMAX      = WA_OUTPUT-ZLDMAX.
    LS_FINAL-MATNR       = WA_OUTPUT-MATNR.
    LS_FINAL-POSNR       = WA_OUTPUT-POSNR.
    LS_FINAL-ARKTX       = WA_OUTPUT-ARKTX.
    LS_FINAL-KALAB       = ABS( WA_OUTPUT-STOCK_QTY ).
    LS_FINAL-KWMENG      = ABS( WA_OUTPUT-KWMENG ).
    LS_FINAL-LFIMG       = ABS( WA_OUTPUT-LFIMG ).
    LS_FINAL-FKIMG       = ABS( WA_OUTPUT-FKIMG ).
    LS_FINAL-PND_QTY     = ABS( WA_OUTPUT-PND_QTY ).
    LS_FINAL-ETTYP       = WA_OUTPUT-ETTYP.
    LS_FINAL-KBETR       = WA_OUTPUT-KBETR.
    LS_FINAL-WAERK       = WA_OUTPUT-WAERK.
    LS_FINAL-CURR_CON    = WA_OUTPUT-CURR_CON.
    LS_FINAL-SO_EXC      = WA_OUTPUT-SO_EXC."ADDED BY JYOTI ON26.04.2024
    LS_FINAL-AMONT       = ABS( WA_OUTPUT-AMONT ).
    LS_FINAL-ORDR_AMT    = ABS( WA_OUTPUT-ORDR_AMT ).
    LS_FINAL-IN_PRICE    = ABS( WA_OUTPUT-IN_PRICE ).
    LS_FINAL-EST_COST    = ABS( WA_OUTPUT-EST_COST ).
    LS_FINAL-LATST_COST  = ABS( WA_OUTPUT-LATST_COST ).
    LS_FINAL-ST_COST     = ABS( WA_OUTPUT-ST_COST ).
    LS_FINAL-ZSERIES     = WA_OUTPUT-ZSERIES.
    LS_FINAL-ZSIZE       = WA_OUTPUT-ZSIZE.
    LS_FINAL-BRAND       = WA_OUTPUT-BRAND.
    LS_FINAL-MOC         = WA_OUTPUT-MOC.
    LS_FINAL-TYPE        = WA_OUTPUT-TYPE.
    LS_FINAL-DISPO       = WA_OUTPUT-DISPO.
    LS_FINAL-WIP         = WA_OUTPUT-WIP.
    LS_FINAL-MTART       = WA_OUTPUT-MTART.
    LS_FINAL-KDMAT       = WA_OUTPUT-KDMAT.
    LS_FINAL-KUNNR       = WA_OUTPUT-KUNNR.
    LS_FINAL-QMQTY       = ABS( WA_OUTPUT-QMQTY ).
    LS_FINAL-MATTXT      = WA_OUTPUT-MATTXT.
    LS_FINAL-US_CUST      = WA_OUTPUT-US_CUST.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN LS_FINAL-MATTXT WITH ' & '.
    LS_FINAL-ITMTXT      = WA_OUTPUT-ITMTXT.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN LS_FINAL-ITMTXT WITH ' & '.
    LS_FINAL-ETENR       = WA_OUTPUT-ETENR.
    LS_FINAL-SCHID       = WA_OUTPUT-SCHID.
*    ls_final-so_exc      = wa_output-so_exc."COMMENTED BY JYOTI ON 26.04.2024
    LS_FINAL-ZTERM       = WA_OUTPUT-ZTERM.
    LS_FINAL-TEXT1       = WA_OUTPUT-TEXT1.
    LS_FINAL-INCO1       = WA_OUTPUT-INCO1.
    LS_FINAL-INCO2       = WA_OUTPUT-INCO2.
    LS_FINAL-OFM         = WA_OUTPUT-OFM.
    LS_FINAL-OFM_DATE    = WA_OUTPUT-OFM_DATE.
    LS_FINAL-SPL         = WA_OUTPUT-SPL.
    LS_FINAL-WRKST       = WA_OUTPUT-WRKST.
    LS_FINAL-ABGRU       = WA_OUTPUT-ABGRU.
    LS_FINAL-BEZEI       = WA_OUTPUT-BEZEI.
    LS_FINAL-CGST        = WA_OUTPUT-CGST.
    IF LS_FINAL-CGST IS INITIAL .
      CONCATENATE  '0' LS_FINAL-CGST INTO LS_FINAL-CGST.
    ENDIF.
    LS_FINAL-SGST        = WA_OUTPUT-SGST.
    IF LS_FINAL-SGST IS INITIAL .
      CONCATENATE  '0' LS_FINAL-SGST INTO LS_FINAL-SGST.
    ENDIF.
    LS_FINAL-IGST        = WA_OUTPUT-IGST.
    IF LS_FINAL-IGST IS INITIAL .
      CONCATENATE  '0' LS_FINAL-IGST INTO LS_FINAL-IGST.
    ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
    LS_FINAL-SHIP_KUNNR    = WA_OUTPUT-SHIP_KUNNR.
    LS_FINAL-SHIP_KUNNR_N  = WA_OUTPUT-SHIP_KUNNR_N.
    LS_FINAL-SHIP_REG_N    = WA_OUTPUT-SHIP_REG_N.
    LS_FINAL-SOLD_REG_N    = WA_OUTPUT-SOLD_REG_N.
    LS_FINAL-SHIP_LAND     = WA_OUTPUT-SHIP_LAND.
    LS_FINAL-S_LAND_DESC   = WA_OUTPUT-S_LAND_DESC.
    LS_FINAL-SOLD_LAND     =  WA_OUTPUT-SOLD_LAND.
*    ls_final-normt          = wa_output-normt.
    LS_FINAL-POSEX          = WA_OUTPUT-POSEX.

    LS_FINAL-LIFSK          = WA_OUTPUT-LIFSK.
    LS_FINAL-VTEXT          = WA_OUTPUT-VTEXT.
    LS_FINAL-INSUR          = WA_OUTPUT-INSUR .
    LS_FINAL-PARDEL         = WA_OUTPUT-PARDEL.
    LS_FINAL-GAD            = WA_OUTPUT-GAD.
    LS_FINAL-TCS            = WA_OUTPUT-TCS.
    LS_FINAL-TCS_AMT        = WA_OUTPUT-TCS_AMT.

    LS_FINAL-CTBG          = WA_OUTPUT-CTBG.
    LS_FINAL-CERTIF         = WA_OUTPUT-CERTIF.
    LS_FINAL-SPECIAL_COMM   = WA_OUTPUT-SPECIAL_COMM.
    LS_FINAL-AMENDMENT_HIS   = WA_OUTPUT-AMENDMENT_HIS.
*    ls_final-stock_qty_ktpi   = wa_output-stock_qty_ktpi.
*    ls_final-stock_qty_tpi1   = wa_output-stock_qty_tpi1.
*    ls_final-ctbg         = wa_output-ctbg.


    IF WA_OUTPUT-BSTDK IS NOT INITIAL .
      IF WA_OUTPUT-BSTDK NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-BSTDK
          IMPORTING
            OUTPUT = LS_FINAL-BSTDK.
        CONCATENATE LS_FINAL-BSTDK+0(2) LS_FINAL-BSTDK+2(3) LS_FINAL-BSTDK+5(4)
                       INTO LS_FINAL-BSTDK SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-ERDAT IS NOT INITIAL .
      IF WA_OUTPUT-ERDAT NE '00000000'..
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-ERDAT
          IMPORTING
            OUTPUT = LS_FINAL-ERDAT.
        CONCATENATE LS_FINAL-ERDAT+0(2) LS_FINAL-ERDAT+2(3) LS_FINAL-ERDAT+5(4)
                       INTO LS_FINAL-ERDAT SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-VDATU IS NOT INITIAL .
      IF WA_OUTPUT-VDATU NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-VDATU
          IMPORTING
            OUTPUT = LS_FINAL-VDATU.
        CONCATENATE LS_FINAL-VDATU+0(2) LS_FINAL-VDATU+2(3) LS_FINAL-VDATU+5(4)
                       INTO LS_FINAL-VDATU SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-HOLDDATE IS NOT INITIAL OR WA_OUTPUT-HOLDDATE NE '00000000'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-HOLDDATE
        IMPORTING
          OUTPUT = LS_FINAL-HOLDDATE.
      CONCATENATE LS_FINAL-HOLDDATE+0(2) LS_FINAL-HOLDDATE+2(3) LS_FINAL-HOLDDATE+5(4)
                     INTO LS_FINAL-HOLDDATE SEPARATED BY '-'.
    ENDIF.
*    ENDIF.

    IF WA_OUTPUT-RELDATE IS NOT INITIAL.
      IF WA_OUTPUT-RELDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-RELDATE
          IMPORTING
            OUTPUT = LS_FINAL-RELDATE.
        CONCATENATE LS_FINAL-RELDATE+0(2) LS_FINAL-RELDATE+2(3) LS_FINAL-RELDATE+5(4)
                       INTO LS_FINAL-RELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-CANCELDATE IS NOT INITIAL .
      IF  WA_OUTPUT-CANCELDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-CANCELDATE
          IMPORTING
            OUTPUT = LS_FINAL-CANCELDATE.
        CONCATENATE LS_FINAL-CANCELDATE+0(2) LS_FINAL-CANCELDATE+2(3) LS_FINAL-CANCELDATE+5(4)
                       INTO LS_FINAL-CANCELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-DELDATE IS NOT INITIAL .
      IF WA_OUTPUT-DELDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-DELDATE
          IMPORTING
            OUTPUT = LS_FINAL-DELDATE.
        CONCATENATE LS_FINAL-DELDATE+0(2) LS_FINAL-DELDATE+2(3) LS_FINAL-DELDATE+5(4)
                       INTO LS_FINAL-DELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-CUSTDELDATE IS NOT INITIAL .
      IF WA_OUTPUT-CUSTDELDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-CUSTDELDATE
          IMPORTING
            OUTPUT = LS_FINAL-CUSTDELDATE.
        CONCATENATE LS_FINAL-CUSTDELDATE+0(2) LS_FINAL-CUSTDELDATE+2(3) LS_FINAL-CUSTDELDATE+5(4)
                       INTO LS_FINAL-CUSTDELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-PO_DEL_DATE IS NOT INITIAL .
      IF WA_OUTPUT-PO_DEL_DATE NE '00000000'. "AddedBy Snehal Rajale On 28 jan 2021
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-PO_DEL_DATE
          IMPORTING
            OUTPUT = LS_FINAL-PO_DEL_DATE.
        CONCATENATE LS_FINAL-PO_DEL_DATE+0(2) LS_FINAL-PO_DEL_DATE+2(3) LS_FINAL-PO_DEL_DATE+5(4)
        INTO LS_FINAL-PO_DEL_DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-ZLDFROMDATE IS NOT INITIAL .
      IF WA_OUTPUT-ZLDFROMDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-ZLDFROMDATE
          IMPORTING
            OUTPUT = LS_FINAL-ZLDFROMDATE.
        CONCATENATE LS_FINAL-ZLDFROMDATE+0(2) LS_FINAL-ZLDFROMDATE+2(3) LS_FINAL-ZLDFROMDATE+5(4)
                       INTO LS_FINAL-ZLDFROMDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-MRP_DT IS NOT INITIAL OR WA_OUTPUT-MRP_DT NE '00000000'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-MRP_DT
        IMPORTING
          OUTPUT = LS_FINAL-MRP_DT.
      CONCATENATE LS_FINAL-MRP_DT+0(2) LS_FINAL-MRP_DT+2(3) LS_FINAL-MRP_DT+5(4)
                     INTO LS_FINAL-MRP_DT SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-EDATU IS NOT INITIAL .
      IF WA_OUTPUT-EDATU NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-EDATU
          IMPORTING
            OUTPUT = LS_FINAL-EDATU.
        CONCATENATE LS_FINAL-EDATU+0(2) LS_FINAL-EDATU+2(3) LS_FINAL-EDATU+5(4)
                       INTO LS_FINAL-EDATU SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-IN_PR_DT IS NOT INITIAL .
      IF WA_OUTPUT-IN_PR_DT NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-IN_PR_DT
          IMPORTING
            OUTPUT = LS_FINAL-IN_PR_DT.
        CONCATENATE LS_FINAL-IN_PR_DT+0(2) LS_FINAL-IN_PR_DT+2(3) LS_FINAL-IN_PR_DT+5(4)
                       INTO LS_FINAL-IN_PR_DT SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = LS_FINAL-REF_DT.
    CONCATENATE LS_FINAL-REF_DT+0(2) LS_FINAL-REF_DT+2(3) LS_FINAL-REF_DT+5(4)
                   INTO LS_FINAL-REF_DT SEPARATED BY '-'.
******************added by jyoti on 02.07.2024************************************
    IF WA_OUTPUT-ZMRP_DATE IS NOT INITIAL .
      IF WA_OUTPUT-ZMRP_DATE NE '00000000'..
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-ZMRP_DATE
          IMPORTING
            OUTPUT = LS_FINAL-ZMRP_DATE.
        CONCATENATE LS_FINAL-ZMRP_DATE+0(2) LS_FINAL-ZMRP_DATE+2(3) LS_FINAL-ZMRP_DATE+5(4)
                       INTO LS_FINAL-ZMRP_DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-ZEXP_MRP_DATE1 IS NOT INITIAL.
      IF WA_OUTPUT-ZEXP_MRP_DATE1 NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-ZEXP_MRP_DATE1
          IMPORTING
            OUTPUT = LS_FINAL-ZEXP_MRP_DATE1.
        CONCATENATE LS_FINAL-ZEXP_MRP_DATE1+0(2) LS_FINAL-ZEXP_MRP_DATE1+2(3) LS_FINAL-ZEXP_MRP_DATE1+5(4)
                       INTO LS_FINAL-ZEXP_MRP_DATE1  SEPARATED BY '-'.
      ENDIF.
    ENDIF.
*************************************************************************************
    LS_FINAL-OFM_NO = WA_OUTPUT-OFM_NO .

    CONDENSE LS_FINAL-KWMENG.
    IF WA_OUTPUT-KWMENG < 0.
      CONCATENATE '-' LS_FINAL-KWMENG INTO LS_FINAL-KWMENG.
    ENDIF.

    CONDENSE LS_FINAL-LFIMG.
    IF WA_OUTPUT-LFIMG < 0.
      CONCATENATE '-' LS_FINAL-LFIMG INTO LS_FINAL-LFIMG.
    ENDIF.

    CONDENSE LS_FINAL-FKIMG.
    IF WA_OUTPUT-FKIMG < 0.
      CONCATENATE '-' LS_FINAL-FKIMG INTO LS_FINAL-FKIMG.
    ENDIF.

    CONDENSE LS_FINAL-PND_QTY.
    IF WA_OUTPUT-PND_QTY < 0.
      CONCATENATE '-' LS_FINAL-PND_QTY INTO LS_FINAL-PND_QTY.
    ENDIF.

    CONDENSE LS_FINAL-QMQTY.
    IF WA_OUTPUT-QMQTY < 0.
      CONCATENATE '-' LS_FINAL-QMQTY INTO LS_FINAL-QMQTY.
    ENDIF.
    CONDENSE LS_FINAL-KBETR.

    IF WA_OUTPUT-KBETR < 0.
      CONCATENATE '-' LS_FINAL-KBETR INTO LS_FINAL-KBETR.
    ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

    CONDENSE LS_FINAL-AMONT.
    IF WA_OUTPUT-AMONT < 0.
      CONCATENATE '-' LS_FINAL-AMONT INTO LS_FINAL-AMONT.
    ENDIF.

    CONDENSE LS_FINAL-ORDR_AMT.
    IF WA_OUTPUT-ORDR_AMT < 0.
      CONCATENATE '-' LS_FINAL-ORDR_AMT INTO LS_FINAL-ORDR_AMT.
    ENDIF.


    CONDENSE LS_FINAL-IN_PRICE.
    IF WA_OUTPUT-IN_PRICE < 0.
      CONCATENATE '-' LS_FINAL-IN_PRICE INTO LS_FINAL-IN_PRICE.
    ENDIF.

    CONDENSE LS_FINAL-EST_COST.
    IF WA_OUTPUT-EST_COST < 0.
      CONCATENATE '-' LS_FINAL-EST_COST INTO LS_FINAL-EST_COST.
    ENDIF.

    CONDENSE LS_FINAL-LATST_COST.
    IF WA_OUTPUT-LATST_COST < 0.
      CONCATENATE '-' LS_FINAL-LATST_COST INTO LS_FINAL-LATST_COST.
    ENDIF.

    CONDENSE LS_FINAL-ST_COST.
    IF WA_OUTPUT-ST_COST < 0.
      CONCATENATE '-' LS_FINAL-ST_COST INTO LS_FINAL-ST_COST.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
    LS_FINAL-ITEM_TYPE         = WA_OUTPUT-ITEM_TYPE. "edited by PJ on 16-08-21
    LS_FINAL-REF_TIME          = WA_OUTPUT-REF_TIME. "edited by PJ on 08-09-21


    """""""""code added by pankaj 28.01.2022"""""""""""""""""""""""""""""""""""

    LS_FINAL-PROJ          = WA_OUTPUT-PROJ .

    LS_FINAL-COND          = WA_OUTPUT-COND .

    IF WA_OUTPUT-RECEIPT_DATE IS NOT INITIAL .
      IF WA_OUTPUT-RECEIPT_DATE NE '00000000'..
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-RECEIPT_DATE
          IMPORTING
            OUTPUT = LS_FINAL-RECEIPT_DATE.
        CONCATENATE LS_FINAL-RECEIPT_DATE+0(2) LS_FINAL-RECEIPT_DATE+2(3) LS_FINAL-RECEIPT_DATE+5(4)
                       INTO LS_FINAL-RECEIPT_DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    LS_FINAL-REASON      = WA_OUTPUT-REASON.

    LS_FINAL-NTGEW      = WA_OUTPUT-NTGEW.

    LS_FINAL-ZPR0        = WA_OUTPUT-ZPR0.
    LS_FINAL-ZPF0        = WA_OUTPUT-ZPF0.
    LS_FINAL-ZIN1        = WA_OUTPUT-ZIN1.
    LS_FINAL-ZIN2        = WA_OUTPUT-ZIN2.
    LS_FINAL-JOIG        = WA_OUTPUT-JOIG.
    LS_FINAL-JOCG        = WA_OUTPUT-JOCG.
    LS_FINAL-JOSG        = WA_OUTPUT-JOSG.


    IF WA_OUTPUT-DATE IS NOT INITIAL .
      IF WA_OUTPUT-DATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-DATE
          IMPORTING
            OUTPUT = LS_FINAL-DATE.
        CONCATENATE LS_FINAL-DATE+0(2) LS_FINAL-DATE+2(3) LS_FINAL-DATE+5(4)
                       INTO LS_FINAL-DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.


    IF WA_OUTPUT-PRSDT IS NOT INITIAL .
      IF  WA_OUTPUT-PRSDT NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-PRSDT
          IMPORTING
            OUTPUT = LS_FINAL-PRSDT.
        CONCATENATE LS_FINAL-PRSDT+0(2) LS_FINAL-PRSDT+2(3) LS_FINAL-PRSDT+5(4)
                       INTO LS_FINAL-PRSDT  SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    LS_FINAL-PACKING_TYPE = WA_OUTPUT-PACKING_TYPE.


    IF WA_OUTPUT-OFM_DATE1 IS NOT INITIAL.
      IF WA_OUTPUT-OFM_DATE1 NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-OFM_DATE1
          IMPORTING
            OUTPUT = LS_FINAL-OFM_DATE1.
        CONCATENATE LS_FINAL-OFM_DATE1+0(2) LS_FINAL-OFM_DATE1+2(3) LS_FINAL-OFM_DATE1+5(4)
                       INTO LS_FINAL-OFM_DATE1 SEPARATED BY '-'.
      ELSE .
        LS_FINAL-OFM_DATE1 = SPACE.
      ENDIF.
    ELSE .
      LS_FINAL-OFM_DATE1 = SPACE.
    ENDIF.

    LS_FINAL-MAT_TEXT = WA_OUTPUT-MAT_TEXT.


    """"""" code added by pankaj 31.01.2022"""""""""

    LS_FINAL-INFRA        = WA_OUTPUT-INFRA.
    LS_FINAL-VALIDATION   = WA_OUTPUT-VALIDATION.

    IF WA_OUTPUT-REVIEW_DATE IS NOT INITIAL .
      IF WA_OUTPUT-REVIEW_DATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-REVIEW_DATE
          IMPORTING
            OUTPUT = LS_FINAL-REVIEW_DATE.
        CONCATENATE LS_FINAL-REVIEW_DATE+0(2) LS_FINAL-REVIEW_DATE+2(3) LS_FINAL-REVIEW_DATE+5(4)
                       INTO LS_FINAL-REVIEW_DATE  SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    LS_FINAL-REVIEW_DATE = WA_OUTPUT-REVIEW_DATE.

    LS_FINAL-DISS_SUMMARY = WA_OUTPUT-DISS_SUMMARY .

    IF WA_OUTPUT-CHANG_SO_DATE IS NOT INITIAL .
      IF WA_OUTPUT-CHANG_SO_DATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-CHANG_SO_DATE
          IMPORTING
            OUTPUT = LS_FINAL-CHANG_SO_DATE.
        CONCATENATE LS_FINAL-CHANG_SO_DATE+0(2) LS_FINAL-CHANG_SO_DATE+2(3) LS_FINAL-CHANG_SO_DATE+5(4)
                       INTO LS_FINAL-CHANG_SO_DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    """""""""""""" code added by pankaj 04.02.2022

    LS_FINAL-PORT      = WA_OUTPUT-PORT .
    LS_FINAL-FULL_PMNT = WA_OUTPUT-FULL_PMNT .
    LS_FINAL-ACT_ASS   = WA_OUTPUT-ACT_ASS .
    LS_FINAL-TXT04     = WA_OUTPUT-TXT04 .
    LS_FINAL-FREIGHT  = WA_OUTPUT-FREIGHT.
    " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
    LS_FINAL-PO_SR_NO = WA_OUTPUT-PO_SR_NO.
    LS_FINAL-UDATE = WA_OUTPUT-UDATE.
    LS_FINAL-BOM = WA_OUTPUT-BOM.
    LS_FINAL-ZPEN_ITEM = WA_OUTPUT-ZPEN_ITEM.
    LS_FINAL-ZRE_PEN_ITEM = WA_OUTPUT-ZRE_PEN_ITEM.
    LS_FINAL-ZINS_LOC = WA_OUTPUT-ZINS_LOC. "ADDED BY PRIMUS JYOTI MAHAJAN
    LS_FINAL-BOM_EXIST = WA_OUTPUT-BOM_EXIST. "ADDED BY PRIMUS JYOTI MAHAJAN
*     ls_final-bstkd1       = wa_output-bstkd."ADDED BY PRIMUS JYOTI MAHAJAN ON 16.04.2024
    LS_FINAL-POSEX1       = WA_OUTPUT-POSEX1."ADDED BY PRIMUS JYOTI MAHAJAN ON 16.04.2024
*    ls_final-vtext1 = wa_output-vtext1.

    LS_FINAL-LGORT = WA_OUTPUT-LGORT. "Added by Pranit 10.06.2024
    LS_FINAL-QUOTA_REF = WA_OUTPUT-QUOTA_REF. "Added by jyoti  19.06.2024

    """"""" endded """""""""""""""""""
    LS_FINAL-VKORG = WA_OUTPUT-VKORG.
    LS_FINAL-VTWEG = WA_OUTPUT-VTWEG.
    LS_FINAL-SPART = WA_OUTPUT-SPART.
    LS_FINAL-ZCUST_PROJ_NAME = WA_OUTPUT-ZCUST_PROJ_NAME."Added by jyoti
    LS_FINAL-AMENDMENT_HIS = WA_OUTPUT-AMENDMENT_HIS."Added by jyoti
    LS_FINAL-PO_DIS = WA_OUTPUT-PO_DIS."Added by jyoti
    LS_FINAL-HOLD_REASON_N1 = WA_OUTPUT-HOLD_REASON_N1."Added by jyoti


    CONDENSE: LS_FINAL-KBETR,LS_FINAL-KWMENG,LS_FINAL-KALAB,LS_FINAL-AMONT,LS_FINAL-ORDR_AMT,LS_FINAL-IN_PRICE.
    APPEND LS_FINAL TO GT_FINAL.
    CLEAR:
      LS_FINAL,WA_OUTPUT.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWN_SET_ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DOWN_SET_ALL .

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
  PERFORM NEW_FILE_1."added by jyoti on 26.04.2024
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = IT_OUTPUT_NEW "it_output"added by jyoti on 26.04.2024
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
  LV_FILE = 'ZDELPENDSOALL_1.TXT'.

  CONCATENATE P_FOLDER '/' SY-DATUM SY-UZEIT LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZDELPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  IF OPEN_SO IS NOT INITIAL.
    WRITE: / 'Open Sales Orders'.
  ELSE.
    WRITE: / 'All Sales Orders'.
  ENDIF.
  WRITE: / 'Sales Order Dt. From', S_DATE-LOW, 'To', S_DATE-HIGH.
  WRITE: / 'Material code   From', S_MATNR-LOW, 'To', S_MATNR-HIGH.
  WRITE: / 'Dest. File:', LV_FULLFILE.

  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1364 TYPE STRING.
    DATA LV_CRLF_1364 TYPE STRING.
    LV_CRLF_1364 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1364 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1364 LV_CRLF_1364 WA_CSV INTO LV_STRING_1364.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_1364 TO LV_FULLFILE.

*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.


******************************************************new file zpendso **********************************
  PERFORM NEW_FILE.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      I_TAB_SAP_DATA       = GT_FINAL
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

**lv_folder = 'D:\usr\sap\DEV\D00\work'.
  LV_FILE = 'ZDELPENDSOALL_1.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
    INTO LV_FULLFILE.

  WRITE: / 'ZPENDSO Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_1365 TYPE STRING.
    DATA LV_CRLF_1365 TYPE STRING.
    LV_CRLF_1365 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_1365 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_1365 LV_CRLF_1365 WA_CSV INTO LV_STRING_1365.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_1365 TO LV_FULLFILE.

*    TRANSFER hd_csv TO lv_fullfile.
*    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NEW_FILE_1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM NEW_FILE_1 .
  "added by jyoti on 26.04.2024 for date refreshable file ****************************
*  BREAK primusabap.
  LOOP AT IT_OUTPUT INTO WA_OUTPUT.
    WA_OUTPUT_NEW-WERKS       = WA_OUTPUT-WERKS.
    WA_OUTPUT_NEW-AUART       = WA_OUTPUT-AUART.
    WA_OUTPUT_NEW-BSTKD       = WA_OUTPUT-BSTKD.
    WA_OUTPUT_NEW-NAME1       = WA_OUTPUT-NAME1.
    WA_OUTPUT_NEW-VKBUR       = WA_OUTPUT-VKBUR.
    WA_OUTPUT_NEW-VBELN       = WA_OUTPUT-VBELN.
    WA_OUTPUT_NEW-STATUS      = WA_OUTPUT-STATUS.
    WA_OUTPUT_NEW-TAG_REQ     = WA_OUTPUT-TAG_REQ.
    WA_OUTPUT_NEW-TPI         = WA_OUTPUT-TPI.
    WA_OUTPUT_NEW-LD_TXT      = WA_OUTPUT-LD_TXT.
    WA_OUTPUT_NEW-ZLDPERWEEK  = WA_OUTPUT-ZLDPERWEEK.
    WA_OUTPUT_NEW-ZLDMAX      = WA_OUTPUT-ZLDMAX.
    WA_OUTPUT_NEW-MATNR       = WA_OUTPUT-MATNR.
    WA_OUTPUT_NEW-POSNR       = WA_OUTPUT-POSNR.
    WA_OUTPUT_NEW-ARKTX       = WA_OUTPUT-ARKTX.
    WA_OUTPUT_NEW-STOCK_QTY   = ABS( WA_OUTPUT-STOCK_QTY ).
    WA_OUTPUT_NEW-KWMENG      = ABS( WA_OUTPUT-KWMENG ).
    WA_OUTPUT_NEW-LFIMG       = ABS( WA_OUTPUT-LFIMG ).
    WA_OUTPUT_NEW-FKIMG       = ABS( WA_OUTPUT-FKIMG ).
    WA_OUTPUT_NEW-PND_QTY     = ABS( WA_OUTPUT-PND_QTY ).
    WA_OUTPUT_NEW-ETTYP       = WA_OUTPUT-ETTYP.
    WA_OUTPUT_NEW-KBETR       = WA_OUTPUT-KBETR.
    CONDENSE WA_OUTPUT_NEW-KBETR.
    WA_OUTPUT_NEW-WAERK       = WA_OUTPUT-WAERK.
    WA_OUTPUT_NEW-CURR_CON    = WA_OUTPUT-CURR_CON.
    WA_OUTPUT_NEW-AMONT       = ABS( WA_OUTPUT-AMONT ).
    WA_OUTPUT_NEW-ORDR_AMT    = ABS( WA_OUTPUT-ORDR_AMT ).
    WA_OUTPUT_NEW-IN_PRICE    = ABS( WA_OUTPUT-IN_PRICE ).
    WA_OUTPUT_NEW-EST_COST    = ABS( WA_OUTPUT-EST_COST ).
    WA_OUTPUT_NEW-LATST_COST  = ABS( WA_OUTPUT-LATST_COST ).
    WA_OUTPUT_NEW-ST_COST     = ABS( WA_OUTPUT-ST_COST ).
    WA_OUTPUT_NEW-ZSERIES     = WA_OUTPUT-ZSERIES.
    WA_OUTPUT_NEW-ZSIZE       = WA_OUTPUT-ZSIZE.
    WA_OUTPUT_NEW-BRAND       = WA_OUTPUT-BRAND.
    WA_OUTPUT_NEW-MOC         = WA_OUTPUT-MOC.
    WA_OUTPUT_NEW-TYPE        = WA_OUTPUT-TYPE.
    WA_OUTPUT_NEW-DISPO       = WA_OUTPUT-DISPO.
    WA_OUTPUT_NEW-WIP         = WA_OUTPUT-WIP.
    WA_OUTPUT_NEW-MTART       = WA_OUTPUT-MTART.
    WA_OUTPUT_NEW-KDMAT       = WA_OUTPUT-KDMAT.
    WA_OUTPUT_NEW-KUNNR       = WA_OUTPUT-KUNNR.
    WA_OUTPUT_NEW-QMQTY       = ABS( WA_OUTPUT-QMQTY ).
    WA_OUTPUT_NEW-MATTXT      = WA_OUTPUT-MATTXT.
    WA_OUTPUT_NEW-US_CUST      = WA_OUTPUT-US_CUST.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN WA_OUTPUT_NEW-MATTXT WITH ' & '.
    WA_OUTPUT_NEW-ITMTXT      = WA_OUTPUT-ITMTXT.
    REPLACE ALL OCCURRENCES OF '<(>&<)>' IN WA_OUTPUT_NEW-ITMTXT WITH ' & '.
    WA_OUTPUT_NEW-ETENR       = WA_OUTPUT-ETENR.
    WA_OUTPUT_NEW-SCHID       = WA_OUTPUT-SCHID.
    WA_OUTPUT_NEW-SO_EXC      = WA_OUTPUT-SO_EXC.
    WA_OUTPUT_NEW-ZTERM       = WA_OUTPUT-ZTERM.
    WA_OUTPUT_NEW-TEXT1       = WA_OUTPUT-TEXT1.
    WA_OUTPUT_NEW-INCO1       = WA_OUTPUT-INCO1.
    WA_OUTPUT_NEW-INCO2       = WA_OUTPUT-INCO2.
    WA_OUTPUT_NEW-OFM         = WA_OUTPUT-OFM.
    WA_OUTPUT_NEW-OFM_DATE    = WA_OUTPUT-OFM_DATE.
    WA_OUTPUT_NEW-SPL         = WA_OUTPUT-SPL.
    WA_OUTPUT_NEW-WRKST       = WA_OUTPUT-WRKST.
    WA_OUTPUT_NEW-ABGRU       = WA_OUTPUT-ABGRU.
    WA_OUTPUT_NEW-BEZEI       = WA_OUTPUT-BEZEI.
    WA_OUTPUT_NEW-CGST        = WA_OUTPUT-CGST.
    IF  WA_OUTPUT_NEW-CGST IS INITIAL .
      CONCATENATE  '0'  WA_OUTPUT_NEW-CGST INTO  WA_OUTPUT_NEW-CGST.
    ENDIF.
    WA_OUTPUT_NEW-SGST        = WA_OUTPUT-SGST.
    IF  WA_OUTPUT_NEW-SGST IS INITIAL .
      CONCATENATE  '0'  WA_OUTPUT_NEW-SGST INTO  WA_OUTPUT_NEW-SGST.
    ENDIF.
    WA_OUTPUT_NEW-IGST        = WA_OUTPUT-IGST.
    IF  WA_OUTPUT_NEW-IGST IS INITIAL .
      CONCATENATE  '0'  WA_OUTPUT_NEW-IGST INTO  WA_OUTPUT_NEW-IGST.
    ENDIF.
*    ls_final-cgst_val    = wa_output-cgst_val.
*    ls_final-sgst_val    = wa_output-sgst_val.
*    ls_final-igst_val    = wa_output-igst_val.
    WA_OUTPUT_NEW-SHIP_KUNNR    = WA_OUTPUT-SHIP_KUNNR.
    WA_OUTPUT_NEW-SHIP_KUNNR_N  = WA_OUTPUT-SHIP_KUNNR_N.
    WA_OUTPUT_NEW-SHIP_REG_N    = WA_OUTPUT-SHIP_REG_N.
    WA_OUTPUT_NEW-SOLD_REG_N    = WA_OUTPUT-SOLD_REG_N.
    WA_OUTPUT_NEW-SHIP_LAND     = WA_OUTPUT-SHIP_LAND.
    WA_OUTPUT_NEW-S_LAND_DESC   = WA_OUTPUT-S_LAND_DESC.
    WA_OUTPUT_NEW-SOLD_LAND     =  WA_OUTPUT-SOLD_LAND.
    WA_OUTPUT_NEW-POSEX          = WA_OUTPUT-POSEX.
*    wa_output_new-normt          = wa_output-normt.


    WA_OUTPUT_NEW-SPECIAL_COMM   = WA_OUTPUT-SPECIAL_COMM.
    WA_OUTPUT_NEW-LIFSK          = WA_OUTPUT-LIFSK.
    WA_OUTPUT_NEW-VTEXT          = WA_OUTPUT-VTEXT.
    WA_OUTPUT_NEW-INSUR          = WA_OUTPUT-INSUR .
    WA_OUTPUT_NEW-PARDEL         = WA_OUTPUT-PARDEL.
    WA_OUTPUT_NEW-GAD            = WA_OUTPUT-GAD.
    WA_OUTPUT_NEW-TCS            = WA_OUTPUT-TCS.
    WA_OUTPUT_NEW-TCS_AMT        = WA_OUTPUT-TCS_AMT.

    WA_OUTPUT_NEW-CTBG          = WA_OUTPUT-CTBG.
    WA_OUTPUT_NEW-CERTIF         = WA_OUTPUT-CERTIF.

*    ls_final-ctbg         = wa_output-ctbg.


    IF WA_OUTPUT-BSTDK IS NOT INITIAL .
      IF  WA_OUTPUT-BSTDK NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-BSTDK
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-BSTDK.
        CONCATENATE  WA_OUTPUT_NEW-BSTDK+0(2)  WA_OUTPUT_NEW-BSTDK+2(3)  WA_OUTPUT_NEW-BSTDK+5(4)
                       INTO  WA_OUTPUT_NEW-BSTDK SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-ERDAT IS NOT INITIAL .
      IF  WA_OUTPUT-ERDAT  NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-ERDAT
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-ERDAT.
        CONCATENATE  WA_OUTPUT_NEW-ERDAT+0(2)  WA_OUTPUT_NEW-ERDAT+2(3)  WA_OUTPUT_NEW-ERDAT+5(4)
                       INTO  WA_OUTPUT_NEW-ERDAT SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-VDATU IS NOT INITIAL.
      IF WA_OUTPUT-VDATU NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-VDATU
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-VDATU.
        CONCATENATE  WA_OUTPUT_NEW-VDATU+0(2)  WA_OUTPUT_NEW-VDATU+2(3)  WA_OUTPUT_NEW-VDATU+5(4)
                       INTO  WA_OUTPUT_NEW-VDATU SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-HOLDDATE IS NOT INITIAL .
      IF WA_OUTPUT-HOLDDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-HOLDDATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-HOLDDATE.
        CONCATENATE  WA_OUTPUT_NEW-HOLDDATE+0(2)  WA_OUTPUT_NEW-HOLDDATE+2(3)  WA_OUTPUT_NEW-HOLDDATE+5(4)
                       INTO  WA_OUTPUT_NEW-HOLDDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-RELDATE IS NOT INITIAL .
      IF WA_OUTPUT-RELDATE NE '00000000' .
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-RELDATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-RELDATE.
        CONCATENATE  WA_OUTPUT_NEW-RELDATE+0(2)  WA_OUTPUT_NEW-RELDATE+2(3)  WA_OUTPUT_NEW-RELDATE+5(4)
                       INTO  WA_OUTPUT_NEW-RELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-CANCELDATE IS NOT INITIAL .
      IF WA_OUTPUT-CANCELDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-CANCELDATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-CANCELDATE.
        CONCATENATE  WA_OUTPUT_NEW-CANCELDATE+0(2)  WA_OUTPUT_NEW-CANCELDATE+2(3)  WA_OUTPUT_NEW-CANCELDATE+5(4)
                       INTO  WA_OUTPUT_NEW-CANCELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-DELDATE IS NOT INITIAL .
      IF WA_OUTPUT-DELDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-DELDATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-DELDATE.
        CONCATENATE  WA_OUTPUT_NEW-DELDATE+0(2)  WA_OUTPUT_NEW-DELDATE+2(3)  WA_OUTPUT_NEW-DELDATE+5(4)
                       INTO  WA_OUTPUT_NEW-DELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-CUSTDELDATE IS NOT INITIAL .
      IF WA_OUTPUT-CUSTDELDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-CUSTDELDATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-CUSTDELDATE.
        CONCATENATE  WA_OUTPUT_NEW-CUSTDELDATE+0(2)  WA_OUTPUT_NEW-CUSTDELDATE+2(3)  WA_OUTPUT_NEW-CUSTDELDATE+5(4)
                       INTO  WA_OUTPUT_NEW-CUSTDELDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-PO_DEL_DATE IS NOT INITIAL .
      IF WA_OUTPUT-PO_DEL_DATE NE '00000000'.                         "Added By Snehal Rajale On 28 jan 2021
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-PO_DEL_DATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-PO_DEL_DATE.
        CONCATENATE  WA_OUTPUT_NEW-PO_DEL_DATE+0(2)  WA_OUTPUT_NEW-PO_DEL_DATE+2(3)  WA_OUTPUT_NEW-PO_DEL_DATE+5(4)
        INTO  WA_OUTPUT_NEW-PO_DEL_DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-ZLDFROMDATE IS NOT INITIAL .
      IF WA_OUTPUT-ZLDFROMDATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-ZLDFROMDATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-ZLDFROMDATE.
        CONCATENATE  WA_OUTPUT_NEW-ZLDFROMDATE+0(2)  WA_OUTPUT_NEW-ZLDFROMDATE+2(3)  WA_OUTPUT_NEW-ZLDFROMDATE+5(4)
                       INTO  WA_OUTPUT_NEW-ZLDFROMDATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-MRP_DT IS NOT INITIAL .
      IF WA_OUTPUT-MRP_DT NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-MRP_DT
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-MRP_DT.
        CONCATENATE  WA_OUTPUT_NEW-MRP_DT+0(2)  WA_OUTPUT_NEW-MRP_DT+2(3)  WA_OUTPUT_NEW-MRP_DT+5(4)
                       INTO  WA_OUTPUT_NEW-MRP_DT SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-EDATU IS NOT INITIAL .
      IF WA_OUTPUT-EDATU NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-EDATU
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-EDATU.
        CONCATENATE  WA_OUTPUT_NEW-EDATU+0(2)  WA_OUTPUT_NEW-EDATU+2(3)  WA_OUTPUT_NEW-EDATU+5(4)
                       INTO  WA_OUTPUT_NEW-EDATU SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    IF WA_OUTPUT-IN_PR_DT IS NOT INITIAL .
      IF  WA_OUTPUT-IN_PR_DT NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-IN_PR_DT
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-IN_PR_DT.
        CONCATENATE  WA_OUTPUT_NEW-IN_PR_DT+0(2)  WA_OUTPUT_NEW-IN_PR_DT+2(3)  WA_OUTPUT_NEW-IN_PR_DT+5(4)
                       INTO  WA_OUTPUT_NEW-IN_PR_DT SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
      EXPORTING
        INPUT  = SY-DATUM
      IMPORTING
        OUTPUT = WA_OUTPUT_NEW-REF_DT.
    CONCATENATE  WA_OUTPUT_NEW-REF_DT+0(2)  WA_OUTPUT_NEW-REF_DT+2(3)  WA_OUTPUT_NEW-REF_DT+5(4)
                   INTO  WA_OUTPUT_NEW-REF_DT SEPARATED BY '-'.

    IF WA_OUTPUT-ZMRP_DATE IS NOT INITIAL OR WA_OUTPUT-ZMRP_DATE NE '00000000'.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-ZMRP_DATE
        IMPORTING
          OUTPUT = WA_OUTPUT_NEW-ZMRP_DATE.
      CONCATENATE  WA_OUTPUT_NEW-ZMRP_DATE+0(2)  WA_OUTPUT_NEW-ZMRP_DATE+2(3)  WA_OUTPUT_NEW-ZMRP_DATE+5(4)
                     INTO  WA_OUTPUT_NEW-ZMRP_DATE SEPARATED BY '-'.
    ENDIF.

    IF WA_OUTPUT-ZEXP_MRP_DATE1 IS NOT INITIAL .
      IF WA_OUTPUT-ZEXP_MRP_DATE1 NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-ZEXP_MRP_DATE1
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-ZEXP_MRP_DATE1.
        CONCATENATE  WA_OUTPUT_NEW-ZEXP_MRP_DATE1+0(2)  WA_OUTPUT_NEW-ZEXP_MRP_DATE1+2(3)  WA_OUTPUT_NEW-ZEXP_MRP_DATE1+5(4)
                       INTO  WA_OUTPUT_NEW-ZEXP_MRP_DATE1 SEPARATED BY '-'.
      ENDIF.
    ENDIF.
*****************************************************************************************************

    WA_OUTPUT_NEW-OFM_NO = WA_OUTPUT-OFM_NO .

    CONDENSE  WA_OUTPUT_NEW-KWMENG.
    IF WA_OUTPUT-KWMENG < 0.
      CONCATENATE '-'  WA_OUTPUT_NEW-KWMENG INTO  WA_OUTPUT_NEW-KWMENG.
    ENDIF.

    CONDENSE  WA_OUTPUT_NEW-LFIMG.
    IF WA_OUTPUT-LFIMG < 0.
      CONCATENATE '-'  WA_OUTPUT_NEW-LFIMG INTO WA_OUTPUT_NEW-LFIMG.
    ENDIF.

    CONDENSE  WA_OUTPUT_NEW-FKIMG.
    IF WA_OUTPUT-FKIMG < 0.
      CONCATENATE '-'WA_OUTPUT_NEW-FKIMG INTO WA_OUTPUT_NEW-FKIMG.
    ENDIF.

    CONDENSE WA_OUTPUT_NEW-PND_QTY.
    IF WA_OUTPUT-PND_QTY < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-PND_QTY INTO WA_OUTPUT_NEW-PND_QTY.
    ENDIF.

    CONDENSE WA_OUTPUT_NEW-QMQTY.
    IF WA_OUTPUT-QMQTY < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-QMQTY INTO WA_OUTPUT_NEW-QMQTY.
    ENDIF.

    CONDENSE WA_OUTPUT_NEW-KBETR.
    IF WA_OUTPUT-KBETR < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-KBETR INTO WA_OUTPUT_NEW-KBETR.
    ENDIF.

*    CONDENSE ls_final-kalab.
*    IF ls_final-kalab < 0.
*      CONCATENATE '-' ls_final-kalab INTO ls_final-kalab.
*    ENDIF.

*    CONDENSE ls_final-so_exc.
*    IF ls_final-so_exc < 0.
*      CONCATENATE '-' ls_final-so_exc INTO ls_final-so_exc.
*    ENDIF.

    CONDENSE WA_OUTPUT_NEW-AMONT.
    IF WA_OUTPUT-AMONT < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-AMONT INTO WA_OUTPUT_NEW-AMONT.
    ENDIF.

    CONDENSE WA_OUTPUT_NEW-ORDR_AMT.
    IF WA_OUTPUT-ORDR_AMT < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-ORDR_AMT INTO WA_OUTPUT_NEW-ORDR_AMT.
    ENDIF.


    CONDENSE WA_OUTPUT_NEW-IN_PRICE.
    IF WA_OUTPUT-IN_PRICE < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-IN_PRICE INTO WA_OUTPUT_NEW-IN_PRICE.
    ENDIF.

    CONDENSE WA_OUTPUT_NEW-EST_COST.
    IF WA_OUTPUT-EST_COST < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-EST_COST INTO WA_OUTPUT_NEW-EST_COST.
    ENDIF.

    CONDENSE WA_OUTPUT_NEW-LATST_COST.
    IF WA_OUTPUT-LATST_COST < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-LATST_COST INTO WA_OUTPUT_NEW-LATST_COST.
    ENDIF.

    CONDENSE WA_OUTPUT_NEW-ST_COST.
    IF WA_OUTPUT-ST_COST < 0.
      CONCATENATE '-' WA_OUTPUT_NEW-ST_COST INTO WA_OUTPUT_NEW-ST_COST.
    ENDIF.

*    CONDENSE ls_final-wip.
*    IF ls_final-wip < 0.
*      CONCATENATE '-' ls_final-wip INTO ls_final-wip.
*
*    ENDIF.
    WA_OUTPUT_NEW-ITEM_TYPE         = WA_OUTPUT-ITEM_TYPE. "edited by PJ on 16-08-21
    WA_OUTPUT_NEW-REF_TIME          = WA_OUTPUT-REF_TIME. "edited by PJ on 08-09-21


    """""""""code added by pankaj 28.01.2022"""""""""""""""""""""""""""""""""""

    WA_OUTPUT_NEW-PROJ          = WA_OUTPUT-PROJ .

    WA_OUTPUT_NEW-COND          = WA_OUTPUT-COND .

    IF WA_OUTPUT-RECEIPT_DATE IS NOT INITIAL .
      IF WA_OUTPUT-RECEIPT_DATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-RECEIPT_DATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-RECEIPT_DATE.
        CONCATENATE  WA_OUTPUT_NEW-RECEIPT_DATE+0(2)  WA_OUTPUT_NEW-RECEIPT_DATE+2(3)  WA_OUTPUT_NEW-RECEIPT_DATE+5(4)
                       INTO  WA_OUTPUT_NEW-RECEIPT_DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    WA_OUTPUT_NEW-REASON      = WA_OUTPUT-REASON.

    WA_OUTPUT_NEW-NTGEW      = WA_OUTPUT-NTGEW.

    WA_OUTPUT_NEW-ZPR0        = WA_OUTPUT-ZPR0.
    WA_OUTPUT_NEW-ZPF0        = WA_OUTPUT-ZPF0.
    WA_OUTPUT_NEW-ZIN1        = WA_OUTPUT-ZIN1.
    WA_OUTPUT_NEW-ZIN2        = WA_OUTPUT-ZIN2.
    WA_OUTPUT_NEW-JOIG        = WA_OUTPUT-JOIG.
    WA_OUTPUT_NEW-JOCG        = WA_OUTPUT-JOCG.
    WA_OUTPUT_NEW-JOSG        = WA_OUTPUT-JOSG.


    IF WA_OUTPUT-DATE IS NOT INITIAL .
      IF WA_OUTPUT-DATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-DATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-DATE.
        CONCATENATE WA_OUTPUT_NEW-DATE+0(2) WA_OUTPUT_NEW-DATE+2(3) WA_OUTPUT_NEW-DATE+5(4)
                       INTO WA_OUTPUT_NEW-DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.


    IF WA_OUTPUT-PRSDT IS NOT INITIAL .
      IF WA_OUTPUT-PRSDT NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-PRSDT
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-PRSDT.
        CONCATENATE WA_OUTPUT_NEW-PRSDT+0(2) WA_OUTPUT_NEW-PRSDT+2(3) WA_OUTPUT_NEW-PRSDT+5(4)
                       INTO WA_OUTPUT_NEW-PRSDT  SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    WA_OUTPUT_NEW-PACKING_TYPE = WA_OUTPUT-PACKING_TYPE.

    CONDENSE WA_OUTPUT-OFM_DATE1.
    IF WA_OUTPUT-OFM_DATE1 IS NOT INITIAL." OR WA_OUTPUT-OFM_DATE1 NE ' '.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = WA_OUTPUT-OFM_DATE1
        IMPORTING
          OUTPUT = WA_OUTPUT_NEW-OFM_DATE1.
      CONCATENATE WA_OUTPUT_NEW-OFM_DATE1+0(2) WA_OUTPUT_NEW-OFM_DATE1+2(3) WA_OUTPUT_NEW-OFM_DATE1+5(4)
                     INTO WA_OUTPUT_NEW-OFM_DATE1 SEPARATED BY '-'.
    ELSE .
      WA_OUTPUT_NEW-OFM_DATE1 = SPACE.
    ENDIF.

    WA_OUTPUT_NEW-MAT_TEXT = WA_OUTPUT-MAT_TEXT.


    """"""" code added by pankaj 31.01.2022"""""""""

    WA_OUTPUT_NEW-INFRA        = WA_OUTPUT-INFRA.
    WA_OUTPUT_NEW-VALIDATION   = WA_OUTPUT-VALIDATION.

    IF WA_OUTPUT-REVIEW_DATE IS NOT INITIAL .
      IF WA_OUTPUT-REVIEW_DATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-REVIEW_DATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-REVIEW_DATE.
        CONCATENATE WA_OUTPUT_NEW-REVIEW_DATE+0(2) WA_OUTPUT_NEW-REVIEW_DATE+2(3) WA_OUTPUT_NEW-REVIEW_DATE+5(4)
                       INTO WA_OUTPUT_NEW-REVIEW_DATE  SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    WA_OUTPUT_NEW-REVIEW_DATE = WA_OUTPUT-REVIEW_DATE.

    WA_OUTPUT_NEW-DISS_SUMMARY = WA_OUTPUT-DISS_SUMMARY .

    IF WA_OUTPUT-CHANG_SO_DATE IS NOT INITIAL .
      IF WA_OUTPUT-CHANG_SO_DATE NE '00000000'.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_OUTPUT-CHANG_SO_DATE
          IMPORTING
            OUTPUT = WA_OUTPUT_NEW-CHANG_SO_DATE.
        CONCATENATE WA_OUTPUT_NEW-CHANG_SO_DATE+0(2) WA_OUTPUT_NEW-CHANG_SO_DATE+2(3) WA_OUTPUT_NEW-CHANG_SO_DATE+5(4)
                       INTO WA_OUTPUT_NEW-CHANG_SO_DATE SEPARATED BY '-'.
      ENDIF.
    ENDIF.

    """""""""""""" code added by pankaj 04.02.2022

    WA_OUTPUT_NEW-PORT      = WA_OUTPUT-PORT .
    WA_OUTPUT_NEW-FULL_PMNT = WA_OUTPUT-FULL_PMNT .
    WA_OUTPUT_NEW-ACT_ASS   = WA_OUTPUT-ACT_ASS .
    WA_OUTPUT_NEW-TXT04     = WA_OUTPUT-TXT04 .
    WA_OUTPUT_NEW-FREIGHT  = WA_OUTPUT-FREIGHT.
    " ls_final-ofm_sr_no = wa_output-OFM_SR_NO.
    WA_OUTPUT_NEW-PO_SR_NO = WA_OUTPUT-PO_SR_NO.
    WA_OUTPUT_NEW-UDATE = WA_OUTPUT-UDATE.
    WA_OUTPUT_NEW-BOM = WA_OUTPUT-BOM.
    WA_OUTPUT_NEW-ZPEN_ITEM = WA_OUTPUT-ZPEN_ITEM.
    WA_OUTPUT_NEW-ZRE_PEN_ITEM = WA_OUTPUT-ZRE_PEN_ITEM.
    WA_OUTPUT_NEW-ZINS_LOC = WA_OUTPUT-ZINS_LOC. "ADDED BY PRIMUS MA
    WA_OUTPUT_NEW-BOM_EXIST = WA_OUTPUT-BOM_EXIST. "ADDED BY PRIMUS MA
    WA_OUTPUT_NEW-POSEX1         = WA_OUTPUT-POSEX.
    WA_OUTPUT_NEW-LGORT          = WA_OUTPUT-LGORT.  "ADDED BY Pranit 10.06.2024
    WA_OUTPUT_NEW-QUOTA_REF         = WA_OUTPUT-QUOTA_REF.  "ADDED BY jyoti 19.06.2024
*    ls_final-vtext1 = wa_output-vtext1.

    """"""" endded """""""""""""""""""

    WA_OUTPUT_NEW-VKORG = WA_OUTPUT-VKORG.    """ ADDED BY SUPRIYA 19.08.2024
    WA_OUTPUT_NEW-VTWEG = WA_OUTPUT-VTWEG.    """ ADDED BY SUPRIYA 19.08.2024
    WA_OUTPUT_NEW-SPART = WA_OUTPUT-SPART.    """ ADDED BY SUPRIYA 19.08.2024
    WA_OUTPUT_NEW-ZCUST_PROJ_NAME = WA_OUTPUT-ZCUST_PROJ_NAME.    """ ADDED BY SUPRIYA 19.08.2024
    WA_OUTPUT_NEW-PO_DIS = WA_OUTPUT-PO_DIS.    """ ADDED BY SUPRIYA 19.08.2024
    WA_OUTPUT_NEW-AMENDMENT_HIS = WA_OUTPUT-AMENDMENT_HIS.    """ ADDED BY SUPRIYA 19.08.2024
    WA_OUTPUT_NEW-HOLD_REASON_N1 = WA_OUTPUT-HOLD_REASON_N1."Added by jyoti on 06.02.2025
*     wa_output_new-stock_qty_ktpi = wa_output-stock_qty_ktpi.
*    wa_output_new-stock_qty_tpi1 = wa_output-stock_qty_tpi1.
*    wa_output_new-ofm_received_date = wa_output-ofm_received_date.
*    wa_output_new-oss_received_cell = wa_output-oss_received_cell.
*    wa_output_new-source_rest = wa_output-source_rest.
*    wa_output_new-suppl_rest = wa_output-suppl_rest.
*    wa_output_new-cust_mat_desc = wa_output-cust_mat_desc.
    APPEND WA_OUTPUT_NEW TO IT_OUTPUT_NEW.
    CLEAR:
      WA_OUTPUT_NEW,WA_OUTPUT.
  ENDLOOP.

ENDFORM.
