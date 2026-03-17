*&---------------------------------------------------------------------*
*& Report ZORDER_CONFIRM_PROG                                                *
*&*&* 1.PROGRAM OWNER       : PRIMUS TECHSYSTEMS PVT LTD.              *
* 2.PROJECT                 : SMARTFROM DEVLOPMENT
* 3.PROGRAM NAME            : ZORDER_CONFIRM_PROG.                           *
* 4.TRANS CODE              : ZORDER                                   *
* 5.MODULE NAME             : SD.                                 *
* 6.REQUEST NO              : DEVK904851 PRIMUS:ABAP:AB:NEW SMARTFORM DEVELOPMENT:15/09/2018                               *
* 7.CREATION DATE           : 20.09.2018.                              *
* 8.CREATED BY              : AVINASH BHAGAT.                          *
* 9.FUNCTIONAL CONSULTANT   : ANUJ DESHPANDE.                                   *
* 10.BUSINESS OWNER         : DELVAL.                                *
*&---------------------------------------------------------------------*
REPORT ZORD_CONF_UAE1.
TABLES: NAST,                          "Messages
        *NAST,                         "Messages
        TNAPR,                         "Programs & Forms
        ITCPO,                         "Communicationarea for Spool
        ARC_PARAMS,                    "Archive parameters
        TOA_DARA,                      "Archive parameters
        ADDR_KEY,                      "Adressnumber for ADDRESS
        VBAK.

INCLUDE ZORDER_CONF_UAE.
*INCLUDE zorder_confirm.

DATA : SO_CODE LIKE VBAK-VBELN.
DATA : BASIC_AMT TYPE P DECIMALS 2.
DATA : TOTAL TYPE P DECIMALS 2.
DATA : ZKBETR TYPE KONV-KBETR.
DATA : HTEXT(40) TYPE C.
DATA : LV_LINES1 TYPE TLINE.
DATA : LV_MEMO TYPE TLINE.
DATA : LV_INSURANCE TYPE TLINE.
DATA : LV_MOD TYPE TLINE.
DATA : LV_DOCT TYPE TLINE.           " DOCUMENTS THROUGH
DATA : LV_SINST TYPE TLINE.          " SPECIAL INSTRUCTION
DATA : LV_LDDATE TYPE TLINE.
DATA : V_AMT TYPE CHAR100.
DATA : GRAND_TOTAL  TYPE P DECIMALS 2.
DATA : JOIG TYPE STRING.
DATA : TOT_QTY TYPE VBAP-KWMENG.
DATA : JOCG_AMT TYPE P DECIMALS 2.
DATA : JOSG_AMT TYPE P DECIMALS 2.

DATA : GS_CTRLOP  TYPE SSFCTRLOP,
       GS_OUTOPT  TYPE SSFCOMPOP,
       GS_OTFDATA TYPE SSFCRESCL.

DATA : CONTROL         TYPE SSFCTRLOP.
DATA : OUTPUT_OPTIONS  TYPE SSFCOMPOP.
DATA:   RETCODE   LIKE SY-SUBRC.         "Returncode
DATA:   XSCREEN(1) TYPE C.               "Output on printer or screen
DATA:   REPEAT(1) TYPE C.
DATA: NAST_ANZAL LIKE NAST-ANZAL.      "Number of outputs (Orig. + Cop.)
DATA: NAST_TDARMOD LIKE NAST-TDARMOD.  "Archiving only one time

DATA: GF_LANGUAGE LIKE SY-LANGU.
DATA: SO_DOC_EXP    LIKE     VBCO3.

DATA: LF_FORMNAME TYPE TDSFNAME,
      LF_FM_NAME  TYPE RS38L_FNAM,
      E_FUNCNAME  TYPE FUNCNAME.
DATA  : LV_OUTPUT_PARAMS TYPE SFPOUTPUTPARAMS.

*DATA : gs_ctrlop  TYPE ssfctrlop,
*       gs_outopt  TYPE ssfcompop,
*       gs_otfdata TYPE ssfcrescl.

*DATA : so_code LIKE vbak-vbeln,
*       v_amt TYPE char100.
FORM ENTRY  USING RETURN_CODE US_SCREEN.
*  break primus.
  CLEAR RETCODE.
  XSCREEN = US_SCREEN.

  PERFORM PROCESSING USING US_SCREEN.
  CASE RETCODE.
    WHEN 0.
      RETURN_CODE = 0.
    WHEN 3.
      RETURN_CODE = 3.
    WHEN OTHERS.
      RETURN_CODE = 1.
  ENDCASE.
ENDFORM.

FORM PROCESSING USING US_SCREEN.

  SO_DOC_EXP-SPRAS = 'E'.
  SO_DOC_EXP-VBELN = NAST-OBJKY.

  SO_CODE = NAST-OBJKY.
  PERFORM CLEAR.
  PERFORM GET_DATA.         "SELECT QUERIES
  PERFORM PROCESS_DATA.
  PERFORM GRANDWORDS.
  PERFORM GET_OFMDATE.
  PERFORM GET_MEMO.
  PERFORM GET_INSURANCE.
  PERFORM GET_MOD.
  PERFORM GET_DOCT.
  PERFORM GET_SINST.
  PERFORM GET_LDDATE.
  PERFORM SMARTFROM_DATA.

ENDFORM.

FORM GET_DATA .

  SELECT
    VBELN
    KUNNR
    ERDAT
    VDATU
    WAERK
    AUART
    KNUMV
    ZLDFROMDATE
    FROM VBAK
    INTO TABLE IT_VBAK
    WHERE VBELN = SO_CODE.
*break primus.
*  IF it_vbak IS NOT INITIAL.
  SELECT
    VBELN
    KUNNR
    PARVW
    FROM VBPA
    INTO TABLE IT_VBPA
    FOR ALL ENTRIES IN IT_VBAK
    WHERE VBELN EQ IT_VBAK-VBELN AND PARVW = 'WE'.
*  ENDIF.
*BREAK PRIMUS.
*  IF it_vbak IS NOT INITIAL.
  SELECT
    VBELN
    KUNNR
    PARVW
    FROM VBPA
    INTO TABLE IT_VBPA1
    FOR ALL ENTRIES IN IT_VBAK
    WHERE VBELN EQ IT_VBAK-VBELN AND PARVW = 'AG'.
*  ENDIF.
*break primus.
  IF IT_VBPA IS NOT INITIAL.
    SELECT
      KUNNR
      NAME1
      TELF1
      PSTLZ
      STRAS
      ORT01
      STCD3
      FROM KNA1
      INTO TABLE IT_KNA12
      FOR ALL ENTRIES IN IT_VBPA
      WHERE KUNNR EQ IT_VBPA-KUNNR1.


  ENDIF.

  IF IT_VBPA1 IS NOT INITIAL.

    SELECT
      KUNNR
      NAME1
      NAME2
      TELF1
      PSTLZ
      STRAS
      ORT01
      STCD3
      FROM KNA1
      INTO TABLE IT_KNA1
*      FOR ALL ENTRIES IN it_vbak
*      WHERE kunnr EQ it_vbak-kunnr.
      FOR ALL ENTRIES IN IT_VBPA1
      WHERE KUNNR EQ IT_VBPA1-KUNNR3.
  ENDIF.

  IF IT_KNA1 IS NOT INITIAL.
    SELECT
      VBELN
      BSTKD
      BSTDK
      FROM VBKD
      INTO  TABLE IT_VBKD
      FOR ALL ENTRIES IN IT_VBAK
      WHERE VBELN EQ IT_VBAK-VBELN.
  ENDIF.

  IF IT_VBAK IS NOT INITIAL.
    SELECT
      VBELN
      POSNR
      MATNR
      ARKTX
      MEINS
      KWMENG
      ZMENG
      DELDATE
      NETPR
      NETWR
      ABGRU
      POSEX
      FROM VBAP
      INTO TABLE IT_VBAP
      FOR ALL ENTRIES IN IT_VBAK
      WHERE VBELN EQ IT_VBAK-VBELN.
  ENDIF.

  SELECT
    VBELN
    ZTERM
    FROM VBKD
    INTO TABLE IT_VBKD1
    FOR ALL ENTRIES IN IT_VBAP
    WHERE VBELN EQ IT_VBAP-VBELN.

  SELECT
    ZTERM
    VTEXT
    SPRAS
    FROM TVZBT
    INTO TABLE IT_TVZBT
    FOR ALL ENTRIES IN IT_VBKD1
    WHERE ZTERM EQ IT_VBKD1-ZTERM AND
    SPRAS = 'E'.

  SELECT
    VBELV
    VBELN
    VBTYP_N
    FROM VBFA
    INTO TABLE IT_VBFA
    FOR ALL ENTRIES IN IT_VBAK
    WHERE VBELV EQ IT_VBAK-VBELN AND VBTYP_N = 'M'.

  SELECT
    KNUMV
    KPOSN
    KSCHL
    KBETR
    KNTYP
    KWERT
*    FROM konv
    FROM PRCD_ELEMENTS
    INTO TABLE IT_KONV
    FOR ALL ENTRIES IN IT_VBAK
    WHERE KNUMV EQ IT_VBAK-KNUMV.

  SELECT
  KNUMV
*  kbetr
*    kschl
  KNTYP
*  kwert
*  FROM konv
  FROM PRCD_ELEMENTS
  INTO TABLE IT_KONV1
  FOR ALL ENTRIES IN IT_VBAK
  WHERE KNUMV EQ IT_VBAK-KNUMV AND KNTYP = 'D' .
ENDFORM.

FORM PROCESS_DATA .

  LOOP AT IT_VBAP INTO WA_VBAP.
    WA_FINAL-VBELN   = WA_VBAP-VBELN.
    WA_FINAL-POSNR   = WA_VBAP-POSNR.
    WA_FINAL-MATNR   = WA_VBAP-MATNR.
    WA_FINAL-ARKTX   = WA_VBAP-ARKTX .
    WA_FINAL-MEINS   = WA_VBAP-MEINS  .
    WA_FINAL-KWMENG  = WA_VBAP-KWMENG .
    WA_FINAL-ZMENG  = WA_VBAP-ZMENG .
    WA_FINAL-DELDATE = WA_VBAP-DELDATE.
    WA_FINAL-NETPR   = WA_VBAP-NETPR  .
    WA_FINAL-NETWR   = WA_VBAP-NETWR  .

    WA_FINAL-POSEX   = WA_VBAP-POSEX.

    WA_FINAL-ABGRU   = WA_VBAP-ABGRU.
    IF WA_VBAP-ABGRU IS NOT INITIAL.
      DELETE IT_VBAP WHERE ABGRU IS NOT INITIAL.
      CONTINUE.
      WA_FINAL-ABGRU   = WA_VBAP-ABGRU.
    ENDIF.

    READ TABLE IT_VBPA1 INTO WA_VBPA1 WITH KEY VBELN = WA_FINAL-VBELN." wa_final
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_VBPA1-KUNNR3.
      CLEAR WA_VBPA1.
    ENDIF.
    """"""added by md
    IF WA_FINAL-KWMENG IS NOT INITIAL.
      WA_FINAL-TOT_QTY =  WA_FINAL-TOT_QTY +  WA_FINAL-KWMENG.
    ELSE.
      WA_FINAL-TOT_QTY =  WA_FINAL-TOT_QTY +  WA_FINAL-ZMENG.
    ENDIF.

    READ TABLE IT_VBPA INTO WA_VBPA WITH KEY VBELN = WA_FINAL-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELN = WA_VBPA-VBELN.
      WA_FINAL-KUNNR1 = WA_VBPA-KUNNR1.
      WA_FINAL-PARVW = WA_VBPA-PARVW.
    ENDIF.
    READ TABLE IT_KNA12 INTO WA_KNA12 WITH KEY KUNNR1 = WA_FINAL-KUNNR1 BINARY SEARCH.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR1 = WA_KNA12-KUNNR1.
      WA_FINAL-NAME12 = WA_KNA12-NAME12.
      WA_FINAL-TELF12 = WA_KNA12-TELF12.
      WA_FINAL-PSTLZ1 = WA_KNA12-PSTLZ1.
      WA_FINAL-STRAS1 = WA_KNA12-STRAS1.
      WA_FINAL-ORT012 = WA_KNA12-ORT012.
      WA_FINAL-STCD31 = WA_KNA12-STCD31.
    ENDIF.

    READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_FINAL-KUNNR.
    IF SY-SUBRC EQ 0 .
      WA_FINAL-KUNNR = WA_KNA1-KUNNR.
      WA_FINAL-NAME1 = WA_KNA1-NAME1.
      WA_FINAL-NAME2 = WA_KNA1-NAME2.
      WA_FINAL-TELF1 = WA_KNA1-TELF1.
      WA_FINAL-PSTLZ = WA_KNA1-PSTLZ.
      WA_FINAL-STRAS = WA_KNA1-STRAS.
      WA_FINAL-ORT01 = WA_KNA1-ORT01.
      WA_FINAL-STCD3 = WA_KNA1-STCD3.
    ENDIF.

    READ TABLE IT_VBKD INTO WA_VBKD WITH  KEY VBELN = WA_FINAL-VBELN BINARY SEARCH.
    IF SY-SUBRC EQ 0 .
      WA_FINAL-VBELN = WA_VBKD-VBELN.
      WA_FINAL-BSTKD = WA_VBKD-BSTKD.
      WA_FINAL-BSTDK = WA_VBKD-BSTDK.
    ENDIF.

    READ TABLE IT_VBAK INTO WA_VBAK WITH  KEY VBELN = WA_FINAL-VBELN BINARY SEARCH.
* LOOP AT IT_VBAP INTO WA_VBAP.
    IF SY-SUBRC EQ 0.
      WA_FINAL-VBELN = WA_VBAK-VBELN.
      WA_FINAL-KUNNR = WA_VBAK-KUNNR.
      WA_FINAL-ERDAT = WA_VBAK-ERDAT.
      WA_FINAL-VDATU = WA_VBAK-VDATU.
      WA_FINAL-WAERK = WA_VBAK-WAERK.
      WA_FINAL-AUART = WA_VBAK-AUART.
      WA_FINAL-KNUMV = WA_VBAK-KNUMV.
      WA_FINAL-ZLDFROMDATE = WA_VBAK-ZLDFROMDATE.

      WA_FINAL-BASIC_AMT = WA_FINAL-BASIC_AMT + WA_FINAL-NETWR .
    ENDIF.

    READ TABLE IT_VBFA INTO WA_VBFA WITH KEY VBELV = WA_FINAL-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELV = WA_VBFA-VBELV.
      WA_FINAL-VBELN1 = WA_VBFA-VBELN1.
      WA_FINAL-VBTYP_N = WA_VBFA-VBTYP_N.
    ENDIF.

    LOOP AT IT_KONV INTO WA_KONV WHERE KNUMV = WA_VBAK-KNUMV AND KPOSN = WA_VBAP-POSNR .
      IF WA_KONV-KSCHL = 'ZPR0'.

        WA_FINAL-NETPR   = WA_KONV-KBETR.
        IF WA_FINAL-KWMENG IS NOT INITIAL.
          WA_FINAL-NETWR   = WA_FINAL-NETPR * WA_FINAL-KWMENG  .
        ELSE.
          WA_FINAL-NETWR   = WA_FINAL-NETPR * WA_FINAL-ZMENG  ." added by md
        ENDIF.
      ENDIF.
      IF WA_KONV-KSCHL = 'ZDC1'.
        WA_FINAL-ZKBETR_DC1 = WA_KONV-KBETR.
      ENDIF.

      IF WA_KONV-KSCHL = 'ZOTH'.
        WA_FINAL-ZKBETR_OTH = WA_KONV-KBETR.
      ENDIF.

      IF WA_KONV-KSCHL = 'ZPFO'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR =  WA_KONV-KBETR.
        WA_FINAL-KWERT =  WA_KONV-KWERT.

      ELSEIF WA_KONV-KSCHL = 'K005' .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kbetr7 =  wa_konv-kbetr. "WA_KONV-KBETR.
        WA_FINAL-KBETR8 =  WA_KONV-KWERT.

      ELSEIF WA_KONV-KSCHL = 'K007' .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kbetr7 =  wa_konv-kbetr. "WA_KONV-KBETR.
        WA_FINAL-KBETR7 =  WA_KONV-KWERT.

      ELSEIF WA_KONV-KSCHL = 'ZIN1' .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR1 =  WA_KONV-KBETR.

      ELSEIF WA_KONV-KSCHL = 'ZFR1'  .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR2 =  WA_KONV-KBETR.

      ELSEIF WA_KONV-KSCHL = 'ZTE1'  .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR3 =  WA_KONV-KBETR.

      ELSEIF WA_KONV-KSCHL = 'ZTCS' .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
        WA_FINAL-KBETR4 =  WA_KONV-KBETR. "WA_KONV-KBETR.
        WA_FINAL-KBETR4 =  WA_KONV-KWERT.
*      ENDIF.
*endloop.
*LOOP AT it_konv1 INTO wa_konv1. .
      ELSEIF WA_KONV-KSCHL = 'JOIG' AND WA_KONV-KNTYP = 'D'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-JOIG = WA_KONV-KBETR / 10 .

*  CONCATENATE 'IGST' WA_FINAL-JOIG '%' INTO JOIG SEPARATED BY ' '.

      ELSEIF WA_KONV-KSCHL = 'JOCG' AND WA_KONV-KNTYP = 'D'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-JOCG = WA_KONV-KBETR / 10 .

      ELSEIF WA_KONV-KSCHL = 'JOSG' AND WA_KONV-KNTYP = 'D'.
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-JOSG = WA_KONV-KBETR / 10 .

      ELSEIF WA_KONV-KSCHL = 'MWAS' AND WA_KONV-KNTYP = 'D'.
*        wa_final-knumv = wa_konv-knumv.
*        wa_final-kbetr6 = wa_konv-kbetr / 10 .
        WA_FINAL-KNUMV = WA_KONV-KNUMV.
        WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kbetr6 =  wa_konv-kbetr. "WA_KONV-KBETR.
        WA_FINAL-KBETR6 = WA_KONV-KBETR / 10 .
        WA_FINAL-ZSATAXAMT =  WA_KONV-KWERT.





      ENDIF.
*endloop.

    ENDLOOP.


*    ON CHANGE OF wa_vbap-vbeln .
*on CHANGE OF wa_vbak-vbeln.
    IF WA_FINAL-JOIG IS NOT INITIAL.
      LOOP AT IT_KONV1 INTO WA_KONV1.
        WA_FINAL-KNUMV = WA_KONV1-KNUMV.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        WA_FINAL-TOTAL1 = ( WA_FINAL-BASIC_AMT * WA_FINAL-JOIG ) / 100.
      ENDLOOP.
    ENDIF.
    "Added By Nilay B. on 21.02.2023
    IF WA_FINAL-JOIG IS NOT INITIAL AND WA_FINAL-AUART = 'ZFRE' OR WA_FINAL-AUART = 'ZREP'.
      LOOP AT IT_KONV1 INTO WA_KONV1.
        WA_FINAL-KNUMV = WA_KONV1-KNUMV.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
*        wa_final-total1 = ( wa_final-basic_amt * wa_final-joig ) / 100.
        WA_FINAL-TOTAL1 = ( WA_FINAL-NETWR * WA_FINAL-JOIG ) / 100.
      ENDLOOP.
    ENDIF.
    "Ended By Nilay On 21.02.2023
    IF  WA_FINAL-JOCG IS NOT INITIAL AND WA_FINAL-JOSG IS NOT INITIAL .
      LOOP AT IT_KONV1 INTO WA_KONV1.
        WA_FINAL-KNUMV = WA_KONV1-KNUMV.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        WA_FINAL-JOCG_AMT = ( WA_FINAL-BASIC_AMT * WA_FINAL-JOCG ) / 100 .
        WA_FINAL-JOSG_AMT = ( WA_FINAL-BASIC_AMT * WA_FINAL-JOSG ) / 100 .
*wa_final-total1 = wa_final-jocg_amt + wa_final-josg_amt.

      ENDLOOP.
    ENDIF.
    "Added By Nilay On 21.02.2023
    IF  WA_FINAL-JOCG IS NOT INITIAL AND WA_FINAL-JOSG IS NOT INITIAL AND WA_FINAL-AUART = 'ZFRE' OR WA_FINAL-AUART = 'ZREP'. "Added By Nilay B. on 21.02.2023.
      LOOP AT IT_KONV1 INTO WA_KONV1.
        WA_FINAL-KNUMV = WA_KONV1-KNUMV.
*  WA_FINAL-KSCHL = WA_KONV-KSCHL.
*        wa_final-kwert =  wa_konv1-kwert.
*        wa_final-total1 =  wa_final-total1 + wa_final-kwert .
        WA_FINAL-JOCG_AMT = ( WA_FINAL-NETWR * WA_FINAL-JOCG ) / 100 .
        WA_FINAL-JOSG_AMT = ( WA_FINAL-NETWR * WA_FINAL-JOSG ) / 100 .
*wa_final-total1 = wa_final-jocg_amt + wa_final-josg_amt.

      ENDLOOP.
    ENDIF.
    "Ended By Nilay On 21.02.2023


    "Added by Sanjay on 29.02.2023
*    IF  wa_final-KBETR6 IS NOT INITIAL .
*       LOOP AT it_konv1 INTO wa_konv1.
*        wa_final-knumv = wa_konv1-knumv.
*        wa_final-ZSATAXAMT = ( wa_final-netwr * wa_final-KBETR6 ) / 100 .
*      ENDLOOP.
*    ENDIF.
*    wa_final-ZSATAXAMT = wa_final-KBETR6.
    "Ended By Sanjay on 29.02.2023

    WA_FINAL-TOTAL =  WA_FINAL-BASIC_AMT + WA_FINAL-KBETR + WA_FINAL-KBETR1 + WA_FINAL-KBETR2 + WA_FINAL-KBETR3 + WA_FINAL-KBETR4.
    IF WA_FINAL-JOIG IS NOT INITIAL.
      WA_FINAL-GRAND =  WA_FINAL-TOTAL + WA_FINAL-TOTAL1.
    ENDIF.
    IF  WA_FINAL-JOCG IS NOT INITIAL AND WA_FINAL-JOSG IS NOT INITIAL.
      WA_FINAL-GRAND =  WA_FINAL-TOTAL + WA_FINAL-JOCG_AMT + WA_FINAL-JOSG_AMT.
    ENDIF.
    IF WA_FINAL-AUART = 'ZDEX' OR WA_FINAL-AUART = 'ZEXP'.
      WA_FINAL-GRAND =  WA_FINAL-TOTAL.
    ENDIF.
    GRAND_TOTAL = WA_FINAL-BASIC_AMT.

    READ TABLE IT_VBKD1 INTO WA_VBKD1 WITH KEY VBELN = WA_FINAL-VBELN BINARY SEARCH.
    IF SY-SUBRC = 0.
      WA_FINAL-VBELN = WA_VBKD1-VBELN.
      WA_FINAL-ZTERM = WA_VBKD1-ZTERM.
    ENDIF.

    READ TABLE IT_TVZBT INTO WA_TVZBT WITH KEY ZTERM = WA_FINAL-ZTERM.
    IF SY-SUBRC = 0.
      WA_FINAL-ZTERM = WA_TVZBT-ZTERM.
      WA_FINAL-VTEXT = WA_TVZBT-VTEXT.
    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
*delete it_final where abgru is NOT INITIAL.
    CLEAR WA_FINAL.
  ENDLOOP.

*  clear wa_final-total1.
ENDFORM.

FORM GRANDWORDS.
  CALL FUNCTION 'HR_IN_CHG_INR_WRDS'
    EXPORTING
      AMT_IN_NUM         = GRAND_TOTAL
    IMPORTING
      AMT_IN_WORDS       = V_AMT
    EXCEPTIONS
      DATA_TYPE_MISMATCH = 1
      OTHERS             = 2.

*  CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
  CALL FUNCTION 'FI_CONVERT_FIRSTCHARS_TOUPPER'
    EXPORTING
      INPUT_STRING  = V_AMT
      SEPARATORS    = ' '
    IMPORTING
      OUTPUT_STRING = V_AMT.

ENDFORM.

FORM GET_OFMDATE.

DATA(lo_text_reader) = NEW zcl_read_text( ).
 DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

 LOOP AT IT_FINAL INTO WA_FINAL.
   CLEAR VBELN_1.
    VBELN_1 = WA_FINAL-VBELN.
 lo_text_reader->read_text_string( EXPORTING id = 'Z016' name = VBELN_1 object = 'VBBK'
                                   IMPORTING lv_lines = DATA(lv_lines1) ).

      WA_FINAL-LV_LINES1 = LV_LINES1 .
 "'1023170052'.

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z016'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      LV_LINES1 = LS_LINES-TDLINE.
*      WA_FINAL-LV_LINES1 = LV_LINES1 .
*
*    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_LINES1.
    CLEAR : LV_LINES1 ,WA_FINAL.
  ENDLOOP.
ENDFORM.

FORM GET_MEMO.
  DATA(lo_text_reader) = NEW zcl_read_text( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

lo_text_reader->read_text_string( EXPORTING id = 'Z015' name = VBELN_1 object = 'VBBK'
                                   IMPORTING lv_lines = DATA(lv_lines1) ).

 LV_MEMO = lv_lines1.
 WA_FINAL-LV_MEMO  = LV_MEMO  .

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z015'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      LV_MEMO = LS_LINES-TDLINE.
*      WA_FINAL-LV_MEMO  = LV_MEMO  .
*
*    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_MEMO .
    CLEAR: LV_MEMO ,WA_FINAL, VBELN_1 .
  ENDLOOP.
ENDFORM.

FORM GET_INSURANCE.
  DATA(lo_text_reader) = NEW zcl_read_text( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

    lo_text_reader->read_text_string( EXPORTING id = 'Z017' name = VBELN_1 object = 'VBBK'
                                   IMPORTING lv_lines = DATA(lv_lines1) ).

      LV_INSURANCE = lv_lines1.
      WA_FINAL-LV_INSURANCE  = LV_INSURANCE  .


*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z017'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      LV_INSURANCE = LS_LINES-TDLINE.
*      WA_FINAL-LV_INSURANCE  = LV_INSURANCE  .
*
*    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_INSURANCE .
    CLEAR : LV_INSURANCE ,WA_FINAL, VBELN_1 .
  ENDLOOP.

ENDFORM.

FORM GET_MOD.

  DATA(lo_text_reader) = NEW zcl_read_text( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

 lo_text_reader->read_text_string( EXPORTING id = 'Z018' name = VBELN_1 object = 'VBBK'
                                   IMPORTING lv_lines = DATA(lv_lines1) ).

      LV_MOD = lv_lines1.
      WA_FINAL-LV_MOD  = LV_MOD  .

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z018'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      LV_MOD = LS_LINES-TDLINE.
*      WA_FINAL-LV_MOD  = LV_MOD  .
*
*    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_MOD .
    CLEAR: LV_MOD ,WA_FINAL .
  ENDLOOP.

ENDFORM.

FORM GET_DOCT.
    DATA(lo_text_reader) = NEW zcl_read_text( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

lo_text_reader->read_text_string( EXPORTING id = 'Z019' name = VBELN_1 object = 'VBBK'
                                   IMPORTING lv_lines = DATA(lv_lines1) ).

      LV_DOCT = lv_lines1.
      WA_FINAL-LV_DOCT  = LV_DOCT  .

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z019'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      LV_DOCT = LS_LINES-TDLINE.
*      WA_FINAL-LV_DOCT  = LV_DOCT  .
*
*    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_DOCT .
    CLEAR: LV_DOCT ,WA_FINAL .
  ENDLOOP.

ENDFORM.

FORM GET_SINST.
   DATA(lo_text_reader) = NEW zcl_read_text( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

lo_text_reader->read_text_string( EXPORTING id = 'Z020' name = VBELN_1 object = 'VBBK'
                                   IMPORTING lv_lines = DATA(lv_lines1) ).
 LV_SINST = lv_lines1.
 WA_FINAL-LV_SINST  = LV_SINST  .


*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z020'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      LV_SINST = LS_LINES-TDLINE.
*      REPLACE ALL OCCURRENCES OF '<(>&<)>' IN LV_SINST WITH '&'.
*      WA_FINAL-LV_SINST  = LV_SINST  .
*
*    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_SINST .
    CLEAR: LV_SINST ,WA_FINAL .
  ENDLOOP.

ENDFORM.
FORM GET_LDDATE.
    DATA(lo_text_reader) = NEW zcl_read_text( ).
  DATA : VBELN_1  TYPE THEAD-TDNAME,
         LV_LINES TYPE TLINE.

  LOOP AT IT_FINAL INTO WA_FINAL.
    VBELN_1 = WA_FINAL-VBELN. "'1023170052'.

 lo_text_reader->read_text_string( EXPORTING id = 'Z038' name = VBELN_1 object = 'VBBK'
                                   IMPORTING lv_lines = DATA(lv_lines1) ).

    LV_LDDATE = lv_lines1.
      WA_FINAL-LV_LDDATE  = LV_LDDATE  .

*    CALL FUNCTION 'READ_TEXT'
*      EXPORTING
*        CLIENT                  = SY-MANDT
*        ID                      = 'Z038'
*        LANGUAGE                = 'E'
*        NAME                    = VBELN_1
*        OBJECT                  = 'VBBK'
*      TABLES
*        LINES                   = GT_LINES
*      EXCEPTIONS
*        ID                      = 1
*        LANGUAGE                = 2
*        NAME                    = 3
*        NOT_FOUND               = 4
*        OBJECT                  = 5
*        REFERENCE_CHECK         = 6
*        WRONG_ACCESS_TO_ARCHIVE = 7
*        OTHERS                  = 8.
*    IF SY-SUBRC <> 0.
** IMPLEMENT SUITABLE ERROR HANDLING HERE
*    ENDIF.
*
*    LOOP AT GT_LINES INTO LS_LINES.
*      LV_LDDATE = LS_LINES-TDLINE.
*      WA_FINAL-LV_LDDATE  = LV_LDDATE  .
*    ENDLOOP.
    MODIFY IT_FINAL FROM WA_FINAL TRANSPORTING LV_LDDATE .
    CLEAR WA_FINAL.
    CLEAR LV_LDDATE  .
  ENDLOOP.

ENDFORM.
FORM SMARTFROM_DATA .

*  gs_ctrlop-getotf = 'X'.
*  gs_ctrlop-device = 'PRINTER'.
*  gs_ctrlop-preview = ''.
*  gs_ctrlop-no_dialog = 'X'.
*  gs_outopt-tddest = 'LOCL'.
*
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname = sf_name
**     VARIANT  = ' '
**     DIRECT_CALL              = ' '
*    IMPORTING
*      fm_name  = fm_name
** EXCEPTIONS
**     NO_FORM  = 1
**     NO_FUNCTION_MODULE       = 2
**     OTHERS   = 3
*    .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.

LV_OUTPUT_PARAMS-DEVICE = 'PRINTER'.
LV_OUTPUT_PARAMS-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
LV_OUTPUT_PARAMS-NODIALOG = 'X'.
LV_OUTPUT_PARAMS-PREVIEW = ''.
LV_OUTPUT_PARAMS-REQIMM = 'X'.
ELSE.
LV_OUTPUT_PARAMS-NODIALOG = ''.
LV_OUTPUT_PARAMS-PREVIEW = 'X'.
ENDIF.




  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS = LV_OUTPUT_PARAMS
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.

  IF SY-SUBRC <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.

  LF_FORMNAME  = 'ZSD_SO_UA1'.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = LF_FORMNAME
    IMPORTING
      E_FUNCNAME = LF_FM_NAME
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
    .







*CALL FUNCTION  lf_fm_name                         "'/1BCDWB/SM00000118'
*  EXPORTING
**   /1BCDWB/DOCPARAMS        =
**   ARCHIVE_INDEX            =
**   ARCHIVE_INDEX_TAB        =
**   ARCHIVE_PARAMETERS       =
*   CONTROL_PARAMETERS       = gs_ctrlop
**   MAIL_APPL_OBJ            =
**   MAIL_RECIPIENT           =
**   MAIL_SENDER              =
*   OUTPUT_OPTIONS           = gs_outopt
*   USER_SETTINGS            = space
*   lv_vbeln                 = so_code
*   v_amt                    = v_amt
** IMPORTING
**   /1BCDWB/FORMOUTPUT       =
* EXCEPTIONS
*   USAGE_ERROR              = 1
*   SYSTEM_ERROR             = 2
*   INTERNAL_ERROR           = 3
*   OTHERS                   = 4
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.



  CALL FUNCTION LF_FM_NAME                   " '/1BCDWB/SM00000117'
    EXPORTING
*     /1BCDWB/DOCPARAMS        =
*     ARCHIVE_INDEX  =
*     ARCHIVE_INDEX_TAB        =
*     ARCHIVE_PARAMETERS       =
*     CONTROL_PARAMETERS       =
*     MAIL_APPL_OBJ  =
*     MAIL_RECIPIENT =
*     MAIL_SENDER    =
*     OUTPUT_OPTIONS =
*     USER_SETTINGS  =
      LV_VBELN       = SO_CODE
      V_AMT          = V_AMT
      IT_FINAL       = IT_FINAL
      LT_TLINE1      = GT_LINES
* IMPORTING
*     /1BCDWB/FORMOUTPUT       =
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
  CLEAR : SO_CODE,V_AMT.
  REFRESH:       IT_FINAL, GT_LINES.



  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.

  IF SY-SUBRC <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.



*
*  DATA : ls_dlv-land LIKE vbrk-land1 VALUE 'IN'.
*  DATA: ls_composer_param     TYPE ssfcompop.
*  PERFORM set_print_param USING    "ls_addr_key
*                                   ls_dlv-land
*                          CHANGING gs_ctrlop
*                                   gs_outopt.
*
*CALL FUNCTION                      fm_name"'/1BCDWB/SF00000090'
*  EXPORTING
**   ARCHIVE_INDEX              =
**   ARCHIVE_INDEX_TAB          =
**   ARCHIVE_PARAMETERS         =
*   control_parameters         = gs_ctrlop
**   MAIL_APPL_OBJ              =
**   MAIL_RECIPIENT             =
**   MAIL_SENDER                =
*   output_options             = gs_outopt
*   user_settings              = space"'X'
*    lv_vbeln                   = so_code
*    v_amt                      = v_amt
* IMPORTING
**   DOCUMENT_OUTPUT_INFO       =
*   job_output_info            = gs_otfdata
**   JOB_OUTPUT_OPTIONS         =
*  TABLES
*    it_final                   = it_final
*    it_lines                   = gt_lines
* EXCEPTIONS
*   formatting_error           = 1
*   internal_error             = 2
*   send_error                 = 3
*   user_canceled              = 4
*   OTHERS                     = 5.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.
*
**  CALL FUNCTION fm_name
**    EXPORTING
**      lv_vbeln           = so_code
**      v_amt              = v_amt
**      control_parameters = gs_ctrlop
**      output_options     = gs_outopt
**      user_settings      = space
**    IMPORTING
**      job_output_info    = gs_otfdata
**    TABLES
**      it_final           = it_final
***     it_lines           = GT_LINES
**    EXCEPTIONS
**      formatting_error   = 1
**      internal_error     = 2
**      send_error         = 3
**      user_canceled      = 4
**      OTHERS             = 5.
**  IF sy-subrc <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**  ENDIF.
*
*  REFRESH it_final.






















  CLEAR WA_FINAL.
ENDFORM.


FORM SET_PRINT_PARAM USING    "IS_ADDR_KEY LIKE ADDR_KEY
                              IS_DLV-LAND LIKE VBRK-LAND1
                     CHANGING GS_CTRLOP TYPE SSFCTRLOP
                              GS_OUTOPT TYPE SSFCOMPOP.

  DATA: LS_ITCPO     TYPE ITCPO.
  DATA: LF_REPID     TYPE SY-REPID.
  DATA: LF_DEVICE    TYPE TDDEVICE.
  DATA: LS_RECIPIENT TYPE SWOTOBJID.
  DATA: LS_SENDER    TYPE SWOTOBJID.

  LF_REPID = SY-REPID.

  CALL FUNCTION 'WFMC_PREPARE_SMART_FORM'
    EXPORTING
      PI_NAST    = NAST
      PI_COUNTRY = IS_DLV-LAND
*     PI_ADDR_KEY   = IS_ADDR_KEY
      PI_REPID   = LF_REPID
      PI_SCREEN  = XSCREEN
    IMPORTING
*     PE_RETURNCODE = CF_RETCODE
      PE_ITCPO   = LS_ITCPO
      PE_DEVICE  = LF_DEVICE.
*            PE_RECIPIENT  = CS_RECIPIENT
*            PE_SENDER     = CS_SENDER.

  MOVE-CORRESPONDING LS_ITCPO TO GS_OUTOPT.
  GS_CTRLOP-DEVICE      = LF_DEVICE.
  GS_CTRLOP-NO_DIALOG   = 'X'.
  GS_CTRLOP-PREVIEW     = XSCREEN.
  GS_CTRLOP-GETOTF      = LS_ITCPO-TDGETOTF.
  GS_CTRLOP-LANGU       = NAST-SPRAS.
ENDFORM.                               " SET_PRINT_PARAM
*&---------------------------------------------------------------------*
*&      Form  CLEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLEAR .
  REFRESH IT_VBAK.
  REFRESH IT_VBPA.
  REFRESH IT_KNA1.
  REFRESH IT_VBKD.
  REFRESH IT_VBAP.
  REFRESH IT_TVZBT.
  REFRESH IT_VBFA.
  REFRESH IT_KONV.
ENDFORM.
