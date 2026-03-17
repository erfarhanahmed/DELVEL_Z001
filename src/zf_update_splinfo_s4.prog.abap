*&---------------------------------------------------------------------*
*& Report ZF_UPDATE_SPLINFO_S4
*&---------------------------------------------------------------------*
*& Open items were posted with wrong/missing split information. The
*& report will identify affected items and rebuild the FAGL_SPLINFO and
*& FAGL_SPLINFO_VAL directly from ACDOCA. Old data is written to RFDT.
*&---------------------------------------------------------------------*
*& Version: 16
*&---------------------------------------------------------------------*
*& Change log:
*& UD220721 - add tax items into process in case of BSTAT = space
*& UD131021 - add non-integrated currencies from non-leading ledgers
*&            into processing
*& UD141021 - BSTAT 'L' is using BSEG_ADD
*& UD031121 - changed table determination related to BSTAT, delete
*&            docs from list that are not relevant
*& UD290322 - revised output for case 'Only missing SPLINFO'
*& UD240622 - allow restriction to HKONT
*& UD041122 - revised output RFDT key
*& UD191222 - special case: CURTPK = '10' => ignore, '10' is already
*&            covered by HSL
*& UD201222 - add option for identifying documents via ACDOCA-SPLITMOD
*& UD100123 - exclude systems with online payment update in FM
*& UD060223 - XSPLITMOD selection extended for P_MISS case
*& UD120523 - BELNR fixed column in output
*&          - special case: SPLINFO missing, VAL existing: avoid dump
*& UD190523 - changed ALV output
*& UD180823 - validate SIS migration date: do not create SPLINFO data
*&            prior to activation data
*& UD250124 - add missing checks for PSM, JVA and NGL migration
*&---------------------------------------------------------------------*
*& Report in ERX
*& Author: d033001
*&---------------------------------------------------------------------*
REPORT zf_update_splinfo_s4.

TABLES: bkpf, t001.
TABLES: bseg.                                               "UD240622
TYPE-POOLS: abap.
TYPES: BEGIN OF doctab,
         bukrs     TYPE bkpf-bukrs,
         belnr     TYPE bkpf-belnr,
         gjahr     TYPE bkpf-gjahr,
         bstat     TYPE bkpf-bstat,
         ldgrp     TYPE bkpf-ldgrp,
         error(1)  TYPE c,
         mess(100) TYPE c,
       END OF doctab.
TYPES: BEGIN OF item,                                       "UD240622
         bukrs TYPE bseg_add-bukrs,                         "UD240622
         belnr TYPE bseg_add-belnr,                         "UD240622
         gjahr TYPE bseg_add-gjahr,                         "UD240622
         buzei TYPE bseg_add-buzei,                         "UD240622
         bstat TYPE bkpf-bstat,                             "UD240622
         ldgrp TYPE bkpf-ldgrp,                             "UD240622
       END OF item.                                         "UD240622
TYPES: BEGIN OF curtp_ld,
         bukrs TYPE finsc_ld_cmp-bukrs,
         rldnr TYPE finsc_ld_cmp-rldnr,
         curtp TYPE finsc_ld_cmp-curtph,
         field TYPE dd03l-fieldname,
       END OF curtp_ld.
TYPES: BEGIN OF curr_bk,
         bukrs TYPE finsc_ld_cmp-bukrs,
         curtp TYPE finsc_ld_cmp-curtph,
       END OF curr_bk.
TYPES: BEGIN OF acd_amt,
         rldnr TYPE acdoca-rldnr,
         buzei TYPE acdoca-buzei,
         tsl   TYPE acdoca-tsl,
         hsl   TYPE acdoca-hsl,
         ksl   TYPE acdoca-ksl,
         osl   TYPE acdoca-osl,
         vsl   TYPE acdoca-vsl,
         bsl   TYPE acdoca-bsl,
         csl   TYPE acdoca-csl,
         dsl   TYPE acdoca-dsl,
         esl   TYPE acdoca-esl,
         fsl   TYPE acdoca-fsl,
         gsl   TYPE acdoca-gsl,
       END OF acd_amt.
TYPES: BEGIN OF spl_coll,
         buzei TYPE bseg-buzei,
         pswbt TYPE bseg-pswbt,
         curtp TYPE curtp,
         wrbtr TYPE bseg-dmbtr,
       END OF spl_coll.
DATA: gt_curtp_ld       TYPE TABLE OF curtp_ld.
DATA: gt_curr_bk        TYPE TABLE OF curr_bk.
DATA: gt_doctab         TYPE TABLE OF doctab.
DATA: gt_finsc_ld_cmp   TYPE TABLE OF finsc_ld_cmp.
DATA: gt_ldgrp_map      TYPE TABLE OF fagl_tldgrp_map.
DATA: gt_splinfo_ins    TYPE TABLE OF fagl_splinfo.
DATA: gt_spl_val_ins    TYPE TABLE OF fagl_splinfo_val.
DATA: gt_splinfo_del    TYPE TABLE OF fagl_splinfo.
DATA: gt_spl_val_del    TYPE TABLE OF fagl_splinfo_val.
DATA: lead_ld           TYPE rldnr.
DATA: exp               TYPE c.
DATA: table             TYPE dd02l-tabname.
DATA: exp_key(22)       TYPE c.
DATA: idx               TYPE i.
DATA: sis_act_date      TYPE fins_sis_proj-act_date.        "UD180823
FIELD-SYMBOLS: <doctab> TYPE doctab.
FIELD-SYMBOLS: <ld_cmp> TYPE finsc_ld_cmp.
FIELD-SYMBOLS: <bseg>   TYPE bseg.


SELECTION-SCREEN BEGIN OF BLOCK 001 WITH FRAME TITLE text_hdr.

  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) text_bkr FOR FIELD p_bukrs.
    SELECTION-SCREEN POSITION 33.
    PARAMETERS: p_bukrs TYPE bkpf-bukrs OBLIGATORY.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
*    SELECTION-SCREEN COMMENT 1(31) text_gjr FOR FIELD p_gjahr. "UD24
*    SELECTION-SCREEN POSITION 33.                          "UD240622
*    PARAMETERS: p_gjahr TYPE bkpf-gjahr OBLIGATORY.        "UD240622
    SELECTION-SCREEN COMMENT 1(28) text_gjr FOR FIELD s_gjahr. "UD240
    SELECTION-SCREEN POSITION 30.                           "UD240622
    SELECT-OPTIONS: s_gjahr FOR bkpf-gjahr.                 "UD240622
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(28) text_bln FOR FIELD s_belnr.
    SELECTION-SCREEN POSITION 30.
    SELECT-OPTIONS: s_belnr FOR bkpf-belnr.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.                           "UD240622
    SELECTION-SCREEN COMMENT 1(28) text_hko FOR FIELD s_hkont. "UD240
    SELECTION-SCREEN POSITION 30.                           "UD240622
    SELECT-OPTIONS: s_hkont FOR bseg-hkont.                 "UD240622
  SELECTION-SCREEN END OF LINE.                             "UD240622

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(28) text_bdt FOR FIELD s_budat.
    SELECTION-SCREEN POSITION 30.
    SELECT-OPTIONS: s_budat FOR bkpf-budat.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(28) text_ent FOR FIELD s_cpudt.
    SELECTION-SCREEN POSITION 30.
    SELECT-OPTIONS: s_cpudt FOR bkpf-cpudt.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.                                    "UD201222
  SELECTION-SCREEN BEGIN OF LINE.                           "UD201222
    SELECTION-SCREEN COMMENT 1(31) text_mod FOR FIELD p_splmod. "UD20
    SELECTION-SCREEN POSITION 34.                           "UD201222
    PARAMETERS: p_splmod AS CHECKBOX.                       "UD201222
  SELECTION-SCREEN END OF LINE.                             "UD201222

  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) text_det FOR FIELD p_detail.
    SELECTION-SCREEN POSITION 34.
    PARAMETERS: p_detail AS CHECKBOX DEFAULT 'X'.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) text_mis FOR FIELD p_miss.
    SELECTION-SCREEN POSITION 34.
    PARAMETERS: p_miss AS CHECKBOX.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) text_tst FOR FIELD p_test
      MODIF ID inc.
    SELECTION-SCREEN POSITION 34.
    PARAMETERS: p_test AS CHECKBOX DEFAULT 'X' MODIF ID inc.
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK 001.

INITIALIZATION.

  text_hdr = 'Items With Differences Between Entry View And Split'.
  text_bkr = 'Company Code'.
  text_gjr = 'Fiscal Year'.
  text_bln = 'Document Number'.
  text_hko = 'G/L Account'.                                 "UD240622
  text_bdt = 'Posting Date'.
  text_ent = 'Entry Date'.
  text_mis = 'Only missing FAGL_SPLINFO'.
  text_det = 'Detailed Output'.
  text_tst = 'Test Run'.
  text_mod = 'Select via SPLITMOD'.                         "UD201222

AT SELECTION-SCREEN.
  PERFORM check_input.

AT SELECTION-SCREEN OUTPUT.
  PERFORM screen.

START-OF-SELECTION.
*** get currency customizing
  PERFORM get_finsc_ld_cmp.
*** identify affected clearing documents for analysis
  PERFORM select_docs.
*** search for items with wrong split and rebuild FAG
  PERFORM proc_split.
*** in update mode: write to RFDT
  PERFORM write_rfdt.
*** output results
  PERFORM output.


*&---------------------------------------------------------------------*
*& Form get_finsc_ld_cmp
*&---------------------------------------------------------------------*
FORM get_finsc_ld_cmp .
  DATA: ls_ledger_info TYPE glx_org_info.
  DATA: ls_curtp_ld    TYPE curtp_ld.
  DATA: ls_curr_bk     TYPE curr_bk.

  CALL FUNCTION 'FAGL_GET_LEADING_LEDGER'
    IMPORTING
      e_rldnr = lead_ld.
*** G/L currencies
  SELECT * FROM finsc_ld_cmp INTO TABLE gt_finsc_ld_cmp
    WHERE bukrs EQ t001-bukrs.
*** ledger groups
  SELECT * FROM fagl_tldgrp_map INTO TABLE gt_ldgrp_map.
*************************************************
*** create CURTP matrix
*************************************************
  LOOP AT gt_finsc_ld_cmp ASSIGNING <ld_cmp>.
    CALL FUNCTION 'G_GET_ORGANIZATIONAL_DATA'
      EXPORTING
        i_rldnr                     = <ld_cmp>-rldnr
        i_orgunit                   = <ld_cmp>-bukrs
        ib_acdoc_compatibility_mode = abap_false
      IMPORTING
        organizational_info         = ls_ledger_info.
    ls_curtp_ld-bukrs = <ld_cmp>-bukrs.
    ls_curtp_ld-rldnr = <ld_cmp>-rldnr.
    ls_curtp_ld-curtp = '00'.
    ls_curtp_ld-field = 'TSL'.
    APPEND ls_curtp_ld TO gt_curtp_ld.
    ls_curr_bk-bukrs = <ld_cmp>-bukrs.
    ls_curr_bk-curtp = '00'.
    COLLECT ls_curr_bk INTO gt_curr_bk.
    IF ls_ledger_info-curr1 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt1.
      ls_curtp_ld-field = ls_ledger_info-fg_curt1.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt1.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr2 NE space.
      IF NOT ( ls_ledger_info-curt2 EQ '10' AND             "UD191222
               ls_ledger_info-fg_curt2 EQ 'KSL' ).          "UD191222
        ls_curtp_ld-curtp = ls_ledger_info-curt2.
        ls_curtp_ld-field = ls_ledger_info-fg_curt2.
        APPEND ls_curtp_ld TO gt_curtp_ld.
        ls_curr_bk-curtp = ls_ledger_info-curt2.
        COLLECT ls_curr_bk INTO gt_curr_bk.
      ENDIF.                                                "UD191222
    ENDIF.
    IF ls_ledger_info-curr3 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt3.
      ls_curtp_ld-field = ls_ledger_info-fg_curt3.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt3.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr4 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt4.
      ls_curtp_ld-field = ls_ledger_info-fg_curt4.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt4.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr5 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt5.
      ls_curtp_ld-field = ls_ledger_info-fg_curt5.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt5.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr6 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt6.
      ls_curtp_ld-field = ls_ledger_info-fg_curt6.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt6.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr7 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt7.
      ls_curtp_ld-field = ls_ledger_info-fg_curt7.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt7.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr8 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt8.
      ls_curtp_ld-field = ls_ledger_info-fg_curt8.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt8.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr9 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt9.
      ls_curtp_ld-field = ls_ledger_info-fg_curt9.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt9.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
    IF ls_ledger_info-curr10 NE space.
      ls_curtp_ld-curtp = ls_ledger_info-curt10.
      ls_curtp_ld-field = ls_ledger_info-fg_curt10.
      APPEND ls_curtp_ld TO gt_curtp_ld.
      ls_curr_bk-curtp = ls_ledger_info-curt10.
      COLLECT ls_curr_bk INTO gt_curr_bk.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form select_docs
*&---------------------------------------------------------------------*
FORM select_docs .

  IF p_splmod IS INITIAL.                                   "UD201222
    IF p_miss EQ space.                                     "UD240622
*** BSTAT = SPACE cases
      SELECT b~bukrs AS bukrs
             b~belnr AS belnr
             b~gjahr AS gjahr
             b~bstat AS bstat
             b~ldgrp AS ldgrp
      INTO CORRESPONDING FIELDS OF TABLE gt_doctab
      FROM bkpf AS b INNER JOIN bseg AS i
                      ON b~bukrs EQ i~bukrs
                     AND b~belnr EQ i~belnr
                     AND b~gjahr EQ i~gjahr
      WHERE   b~bukrs  EQ p_bukrs
        AND   b~belnr  IN s_belnr
*      AND   b~gjahr  EQ p_gjahr                            "UD240622
        AND   b~gjahr  IN s_gjahr                           "UD240622
        AND   b~budat  IN s_budat
*** check SIS key date                                      "UD180823
        AND   b~budat  GE sis_act_date                      "UD180823
        AND   b~cpudt  IN s_cpudt
        AND   b~bstat  EQ space
        AND   i~hkont  IN s_hkont                           "UD240622
        AND ( i~xopvw  EQ 'X' OR
              i~xlgclr EQ 'X' ).
*** postings with ledger group
      SELECT b~bukrs AS bukrs
             b~belnr AS belnr
             b~gjahr AS gjahr
             b~bstat AS bstat
             b~ldgrp AS ldgrp
      APPENDING CORRESPONDING FIELDS OF TABLE gt_doctab
*************************************************************UD141021
*  FROM bkpf AS b INNER JOIN bseg AS i                      "UD141021
      FROM bkpf AS b INNER JOIN bseg_add AS i               "UD141021
*************************************************************UD141021
                      ON b~bukrs EQ i~bukrs
                     AND b~belnr EQ i~belnr
                     AND b~gjahr EQ i~gjahr
      WHERE b~bukrs  EQ p_bukrs
        AND b~belnr  IN s_belnr
*      AND b~gjahr  EQ p_gjahr                              "UD240622
        AND b~gjahr  IN s_gjahr                             "UD240622
        AND b~budat  IN s_budat
*** check SIS key date                                      "UD180823
        AND b~budat  GE sis_act_date                        "UD180823
        AND b~cpudt  IN s_cpudt
        AND b~bstat  EQ 'L'
        AND i~hkont  IN s_hkont                             "UD240622
        AND i~xlgclr EQ 'X'.
    ELSE.                                                   "UD240622
*** BSTAT = SPACE cases                                     "UD240622
      SELECT b~bukrs AS bukrs,                              "UD240622
             b~belnr AS belnr,                              "UD240622
             b~gjahr AS gjahr,                              "UD240622
             b~bstat AS bstat,                              "UD240622
             b~ldgrp AS ldgrp                               "UD240622
      INTO CORRESPONDING FIELDS OF TABLE @gt_doctab         "UD240622
      FROM bkpf AS b INNER JOIN bseg AS i                   "UD240622
                      ON b~bukrs EQ i~bukrs                 "UD240622
                     AND b~belnr EQ i~belnr                 "UD240622
                     AND b~gjahr EQ i~gjahr                 "UD240622
                     LEFT OUTER JOIN fagl_splinfo AS s      "UD240622
                      ON i~belnr EQ s~belnr                 "UD240622
                     AND i~gjahr EQ s~gjahr                 "UD240622
                     AND i~bukrs EQ s~bukrs                 "UD240622
                     AND i~buzei EQ s~buzei                 "UD240622
      WHERE   b~bukrs  EQ @p_bukrs                          "UD240622
        AND   b~belnr  IN @s_belnr                          "UD240622
        AND   b~gjahr  IN @s_gjahr                          "UD240622
        AND   b~budat  IN @s_budat                          "UD240622
*** check SIS key date                                      "UD180823
        AND   b~budat  GE @sis_act_date                     "UD180823
        AND   b~cpudt  IN @s_cpudt                          "UD240622
        AND   b~bstat  EQ @space                            "UD240622
        AND   i~hkont  IN @s_hkont                          "UD240622
*** error case: no FAGL_SPLINFO                             "UD240622
        AND   s~spl_no IS NULL                              "UD240622
        AND ( i~xopvw  EQ 'X' OR                            "UD240622
              i~xlgclr EQ 'X' ).                            "UD240622
*** postings with ledger group                              "UD240622
*** no OUTER JOIN possible: different BUZEI in SPL and BSEG_ADD "UD24
      DATA: ls_item   TYPE item.                            "UD240622
      DATA: ls_doctab TYPE doctab.                          "UD240622
      SELECT b~bukrs AS bukrs                               "UD240622
             b~belnr AS belnr                               "UD240622
             b~gjahr AS gjahr                               "UD240622
             i~buzei AS buzei                               "UD240622
             b~bstat AS bstat                               "UD240622
             b~ldgrp AS ldgrp                               "UD240622
      INTO CORRESPONDING FIELDS OF ls_item                  "UD240622
      FROM bkpf AS b INNER JOIN bseg_add AS i               "UD240622
                      ON b~bukrs EQ i~bukrs                 "UD240622
                     AND b~belnr EQ i~belnr                 "UD240622
                     AND b~gjahr EQ i~gjahr                 "UD240622
      WHERE b~bukrs  EQ p_bukrs                             "UD240622
        AND b~belnr  IN s_belnr                             "UD240622
        AND b~gjahr  IN s_gjahr                             "UD240622
        AND b~budat  IN s_budat                             "UD240622
*** check SIS key date                                      "UD180823
        AND b~budat  GE sis_act_date                        "UD180823
        AND b~cpudt  IN s_cpudt                             "UD240622
        AND b~bstat  EQ 'L'                                 "UD240622
        AND i~hkont  IN s_hkont                             "UD240622
        AND i~xlgclr EQ 'X'.                                "UD240622
        SELECT COUNT(*) FROM fagl_splinfo                   "UD240622
          WHERE belnr EQ ls_item-belnr                      "UD240622
            AND gjahr EQ ls_item-gjahr                      "UD240622
            AND bukrs EQ ls_item-bukrs                      "UD240622
            AND buzei EQ ls_item-buzei.                     "UD240622
        CHECK NOT sy-subrc EQ 0.                            "UD240622
        MOVE-CORRESPONDING ls_item TO ls_doctab.            "UD240622
        APPEND ls_doctab TO gt_doctab.                      "UD240622
      ENDSELECT.                                            "UD240622
    ENDIF.                                                  "UD240622
*** special case: no OIM, no tax but other split            "UD201222
  ELSE.                                                     "UD201222
    IF p_miss EQ space.                                     "UD060223
      SELECT b~bukrs AS bukrs                               "UD201222
             b~belnr AS belnr                               "UD201222
             b~gjahr AS gjahr                               "UD201222
             b~bstat AS bstat                               "UD201222
             b~ldgrp AS ldgrp                               "UD201222
      APPENDING CORRESPONDING FIELDS OF TABLE gt_doctab     "UD201222
      FROM bkpf AS b INNER JOIN acdoca AS a                 "UD201222
                      ON b~bukrs EQ a~rbukrs                "UD201222
                     AND b~belnr EQ a~belnr                 "UD201222
                     AND b~gjahr EQ a~gjahr                 "UD201222
      WHERE   b~bukrs     EQ p_bukrs                        "UD201222
        AND   b~belnr     IN s_belnr                        "UD201222
        AND   b~gjahr     IN s_gjahr                        "UD201222
        AND   b~budat     IN s_budat                        "UD201222
*** check SIS key date                                      "UD180823
        AND   b~budat     GE sis_act_date                   "UD180823
        AND   b~cpudt     IN s_cpudt                        "UD201222
        AND   b~bstat     EQ space                          "UD201222
        AND   a~racct     IN s_hkont                        "UD201222
        AND   a~xsplitmod EQ 'X'.                           "UD201222
    ELSE.                                                   "UD060223
      SELECT b~bukrs AS bukrs,                              "UD201222
             b~belnr AS belnr,                              "UD201222
             b~gjahr AS gjahr,                              "UD201222
             b~bstat AS bstat,                              "UD201222
             b~ldgrp AS ldgrp                               "UD201222
      APPENDING CORRESPONDING FIELDS OF TABLE @gt_doctab    "UD201222
      FROM bkpf AS b INNER JOIN acdoca AS a                 "UD201222
                      ON b~bukrs EQ a~rbukrs                "UD201222
                     AND b~belnr EQ a~belnr                 "UD201222
                     AND b~gjahr EQ a~gjahr                 "UD201222
                     LEFT OUTER JOIN fagl_splinfo AS s      "UD060223
                      ON a~belnr  EQ s~belnr                "UD060223
                     AND a~gjahr  EQ s~gjahr                "UD060223
                     AND a~rbukrs EQ s~bukrs                "UD060223
                     AND a~buzei  EQ s~buzei                "UD060223
      WHERE   b~bukrs     EQ @p_bukrs                       "UD201222
        AND   b~belnr     IN @s_belnr                       "UD201222
        AND   b~gjahr     IN @s_gjahr                       "UD201222
        AND   b~budat     IN @s_budat                       "UD201222
*** check SIS key date                                      "UD180823
        AND   b~budat     GE @sis_act_date                  "UD180823
        AND   b~cpudt     IN @s_cpudt                       "UD201222
        AND   b~bstat     EQ @space                         "UD201222
        AND   a~racct     IN @s_hkont                       "UD201222
        AND   s~spl_no    IS NULL                           "UD060223
        AND   a~xsplitmod EQ 'X'.                           "UD201222
    ENDIF.                                                  "UD060223
  ENDIF.                                                    "UD201222
*** delete duplicates
  SORT gt_doctab BY bukrs belnr gjahr.
  DELETE ADJACENT DUPLICATES FROM gt_doctab COMPARING bukrs belnr gjahr.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form proc_split
*&---------------------------------------------------------------------*
FORM proc_split .
  DATA: lt_bseg             TYPE TABLE OF bseg.
  DATA: lt_spl              TYPE TABLE OF fagl_splinfo.
  DATA: lt_val              TYPE TABLE OF fagl_splinfo_val.
  DATA: lt_spl_del          TYPE TABLE OF fagl_splinfo.
  DATA: lt_val_del          TYPE TABLE OF fagl_splinfo_val.
  DATA: lt_spl_coll         TYPE TABLE OF spl_coll.
  DATA: lt_acd_coll         TYPE TABLE OF spl_coll.
  DATA: lt_acd_amt          TYPE TABLE OF acd_amt.
  DATA: ls_ldgrp_map        TYPE fagl_tldgrp_map.
  DATA: ls_spl_coll         TYPE spl_coll.
  DATA: ls_acd_coll         TYPE spl_coll.
  DATA: ls_acd_amt          TYPE acd_amt.
  DATA: ls_coll             TYPE acdoca-hsl.
  DATA: x_error             TYPE c.
  DATA: error_string        TYPE string.
  DATA: cnt_spl             TYPE i.
  FIELD-SYMBOLS: <curtp_ld> TYPE curtp_ld.
  FIELD-SYMBOLS: <amount>   TYPE acdoca-hsl.
  FIELD-SYMBOLS: <curr_bk>  TYPE curr_bk.

  LOOP AT gt_doctab ASSIGNING <doctab>.
    CLEAR x_error.
*** select entry view
    CLEAR lt_bseg.
*** special handling XSPLITMOD                              "UD201222
    IF p_splmod IS INITIAL.                                 "UD201222
*************************************************************UD031121
*** use DOCTAB-BSTAT                                        "UD031121
*    IF table EQ 'BSEG'.                                    "UD031121
      IF <doctab>-bstat EQ space.                           "UD031121
        SELECT * FROM bseg INTO TABLE lt_bseg
          WHERE   bukrs  EQ <doctab>-bukrs
            AND   belnr  EQ <doctab>-belnr
            AND   gjahr  EQ <doctab>-gjahr
*** include the tax items in case of BSEG
            AND ( mwart  EQ 'A' OR
                  mwart  EQ 'V' OR
                  xopvw  EQ 'X' OR
                  xlgclr EQ 'X' ).
      ELSE.
        SELECT * FROM bseg_add
        INTO CORRESPONDING FIELDS OF TABLE lt_bseg
          WHERE bukrs  EQ <doctab>-bukrs
            AND belnr  EQ <doctab>-belnr
            AND gjahr  EQ <doctab>-gjahr
            AND xlgclr EQ 'X'.
      ENDIF.
    ELSE.                                                   "UD201222
      DATA: lt_acdoca TYPE TABLE OF acdoca.                 "UD201222
      DATA: ls_bseg   TYPE bseg.                            "UD201222
      SELECT * FROM acdoca INTO TABLE lt_acdoca             "UD201222
        WHERE rbukrs EQ <doctab>-bukrs                      "UD201222
          AND gjahr EQ <doctab>-gjahr                       "UD201222
          AND belnr EQ <doctab>-belnr                       "UD201222
          AND xsplitmod EQ 'X'.                             "UD201222
      LOOP AT lt_acdoca ASSIGNING FIELD-SYMBOL(<acd>).      "UD201222
        READ TABLE lt_bseg TRANSPORTING NO FIELDS           "UD201222
        WITH KEY buzei = <acd>-buzei.                       "UD201222
        CHECK NOT sy-subrc EQ 0.                            "UD201222
        IF <doctab>-bstat EQ space.                         "UD201222
          SELECT SINGLE * FROM bseg INTO ls_bseg            "UD201222
            WHERE bukrs EQ <acd>-rbukrs                     "UD201222
              AND belnr EQ <acd>-belnr                      "UD201222
              AND gjahr EQ <acd>-gjahr                      "UD201222
              AND buzei EQ <acd>-buzei                      "UD201222
              AND hkont EQ <acd>-racct.                     "UD201222
          IF sy-subrc EQ 0.                                 "UD201222
            APPEND ls_bseg TO lt_bseg.                      "UD201222
          ENDIF.                                            "UD201222
        ELSE.                                               "UD201222
          SELECT SINGLE * FROM bseg_add                     "UD201222
          INTO CORRESPONDING FIELDS OF ls_bseg              "UD201222
            WHERE bukrs EQ <acd>-rbukrs                     "UD201222
              AND belnr EQ <acd>-belnr                      "UD201222
              AND gjahr EQ <acd>-gjahr                      "UD201222
              AND buzei EQ <acd>-buzei                      "UD201222
              AND hkont EQ <acd>-racct.                     "UD201222
          IF sy-subrc EQ 0.                                 "UD201222
            APPEND ls_bseg TO lt_bseg.                      "UD201222
          ENDIF.                                            "UD201222
        ENDIF.                                              "UD201222
      ENDLOOP.                                              "UD201222
    ENDIF.                                                  "UD201222
*** one error per doc is sufficient for exclusion
    CLEAR error_string.
    CLEAR x_error.
*** use counter for classifying document as relevant        "UD290322
    DATA: cnt_corr TYPE i.                                  "UD290322
    CLEAR cnt_corr.                                         "UD290322
    LOOP AT lt_bseg ASSIGNING <bseg>.
***************************************************************
*** 1: does FAGL_SPLINFO exist?
      SELECT COUNT(*) FROM fagl_splinfo INTO cnt_spl
        WHERE belnr EQ <bseg>-belnr
          AND gjahr EQ <bseg>-gjahr
          AND bukrs EQ <bseg>-bukrs
          AND buzei EQ <bseg>-buzei.
      IF p_miss EQ 'X'.
        CHECK cnt_spl EQ 0.
      ENDIF.
      IF cnt_spl GT 0.
***************************************************************
*** 2: collect SPLINFO and VAL data to compare with ACDOCA
        CLEAR lt_spl_coll.
        SELECT belnr        AS belnr
               gjahr        AS gjahr
               bukrs        AS bukrs
               buzei        AS buzei
               SUM( pswbt ) AS pswbt
         FROM fagl_splinfo INTO CORRESPONDING FIELDS OF ls_spl_coll
           WHERE belnr EQ <bseg>-belnr
             AND gjahr EQ <bseg>-gjahr
             AND bukrs EQ <bseg>-bukrs
             AND buzei EQ <bseg>-buzei
         GROUP BY belnr gjahr bukrs buzei.
          ls_spl_coll-curtp = '00'.
          COLLECT ls_spl_coll INTO lt_spl_coll.
        ENDSELECT.
        SELECT belnr        AS belnr
               gjahr        AS gjahr
               bukrs        AS bukrs
               buzei        AS buzei
               curtp        AS curtp
               SUM( wrbtr ) AS wrbtr
        FROM fagl_splinfo_val INTO CORRESPONDING FIELDS OF ls_spl_coll
          WHERE belnr EQ <bseg>-belnr
            AND gjahr EQ <bseg>-gjahr
            AND bukrs EQ <bseg>-bukrs
            AND buzei EQ <bseg>-buzei
*** CURTP '00' is not relevant because already used for PSWBT
            AND curtp NE '00'
        GROUP BY belnr gjahr bukrs buzei curtp.
          COLLECT ls_spl_coll INTO lt_spl_coll.
        ENDSELECT.
****************************************************************
*** 3: derive G/L view data
        CLEAR: lt_acd_coll, lt_acd_amt.
*** collect all ledgers for catching all freely defined currencies
        LOOP AT gt_finsc_ld_cmp ASSIGNING <ld_cmp>.
          SELECT rldnr
                 buzei
                 SUM( tsl ) AS tsl
                 SUM( hsl ) AS hsl
                 SUM( ksl ) AS ksl
                 SUM( osl ) AS osl
                 SUM( vsl ) AS vsl
                 SUM( bsl ) AS bsl
                 SUM( csl ) AS csl
                 SUM( dsl ) AS dsl
                 SUM( esl ) AS esl
                 SUM( fsl ) AS fsl
                 SUM( gsl ) AS gsl
          FROM acdoca INTO CORRESPONDING FIELDS OF ls_acd_amt
            WHERE  rldnr EQ <ld_cmp>-rldnr
              AND rbukrs EQ <bseg>-bukrs
              AND  gjahr EQ <bseg>-gjahr
              AND  belnr EQ <bseg>-belnr
              AND  buzei EQ <bseg>-buzei
          GROUP BY rldnr buzei.
            APPEND ls_acd_amt TO lt_acd_amt.
          ENDSELECT.
        ENDLOOP.
*** for BSTAT = space: use leading ledger
        IF <doctab>-bstat EQ space.
          READ TABLE gt_finsc_ld_cmp ASSIGNING <ld_cmp> WITH KEY
            rldnr = lead_ld.
*** for BSTAT = 'L': use representative ledger
        ELSE.
          READ TABLE gt_ldgrp_map INTO ls_ldgrp_map WITH KEY
            ldgrp     = <doctab>-ldgrp
            represent = 'X'.
          READ TABLE gt_finsc_ld_cmp ASSIGNING <ld_cmp> WITH KEY
            rldnr = ls_ldgrp_map-rldnr.
        ENDIF.
*** use representative ledgers for first fill of table
        READ TABLE lt_acd_amt WITH KEY rldnr = <ld_cmp>-rldnr
          INTO ls_acd_amt.
        LOOP AT gt_curtp_ld ASSIGNING <curtp_ld>
          WHERE rldnr EQ <ld_cmp>-rldnr.
          ASSIGN COMPONENT <curtp_ld>-field OF STRUCTURE ls_acd_amt TO <amount>.
          CLEAR ls_acd_coll.
          ls_acd_coll-buzei = ls_acd_amt-buzei.
          ls_acd_coll-curtp = <curtp_ld>-curtp.
          ls_acd_coll-wrbtr = <amount>.
          ls_acd_coll-pswbt = ls_acd_amt-tsl.
          APPEND ls_acd_coll TO lt_acd_coll.
        ENDLOOP.
*** check if additional currencies are required
        LOOP AT gt_curr_bk ASSIGNING <curr_bk>.
          READ TABLE lt_acd_coll WITH KEY curtp = <curr_bk>-curtp
            TRANSPORTING NO FIELDS.
*** currency missing: search in other ledger of LDGRP
          IF NOT sy-subrc EQ 0.
            LOOP AT gt_curtp_ld ASSIGNING <curtp_ld>
             WHERE curtp EQ <curr_bk>-curtp.
              IF <doctab>-ldgrp NE space.
                READ TABLE gt_ldgrp_map WITH KEY
                  ldgrp = <doctab>-ldgrp
                  rldnr = <curtp_ld>-rldnr
                TRANSPORTING NO FIELDS.
*** ledger with required CURTP assigned => verify existing item
                IF sy-subrc EQ 0.
                  READ TABLE lt_acd_amt WITH KEY rldnr = <curtp_ld>-rldnr
                    TRANSPORTING NO FIELDS.
                  IF sy-subrc EQ 0.
                    EXIT.
                  ELSE.
                    CONTINUE.
                  ENDIF.
                ELSE.
                  CONTINUE.
                ENDIF.
              ELSE.
                READ TABLE lt_acd_amt WITH KEY rldnr = <curtp_ld>-rldnr
                    TRANSPORTING NO FIELDS.
                IF sy-subrc EQ 0.
                  EXIT.
                ELSE.
                  CONTINUE.
                ENDIF.
              ENDIF.
            ENDLOOP.
            IF sy-subrc EQ 0.
              READ TABLE lt_acd_amt WITH KEY rldnr = <curtp_ld>-rldnr
                INTO ls_acd_amt.
              IF sy-subrc EQ 0.
                ASSIGN COMPONENT <curtp_ld>-field OF STRUCTURE
                  ls_acd_amt TO <amount>.
                IF sy-subrc EQ 0.
                  CLEAR ls_acd_coll.
                  ls_acd_coll-buzei = <bseg>-buzei.
                  ls_acd_coll-curtp = <curtp_ld>-curtp.
                  ls_acd_coll-wrbtr = <amount>.
                  ls_acd_coll-pswbt = ls_acd_amt-tsl.
                  APPEND ls_acd_coll TO lt_acd_coll.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
****************************************************************
*** 4: compare FAGL_SPLINFO amounts with ACDOCA amounts
        CLEAR ls_coll.
        LOOP AT lt_spl_coll INTO ls_spl_coll.
          IF ls_spl_coll-curtp EQ '00'.
            ADD ls_spl_coll-pswbt TO ls_coll.
          ELSE.
            ADD ls_spl_coll-wrbtr TO ls_coll.
          ENDIF.
        ENDLOOP.
        LOOP AT lt_acd_coll INTO ls_acd_coll.
          SUBTRACT ls_acd_coll-wrbtr FROM ls_coll.
        ENDLOOP.
*** balance = 0 => no correction required
        IF ls_coll EQ 0.
*** if split is correct => item not relevant                "UD031121
*          <doctab>-mess = 'Not relevant'.                  "UD290322
          CONTINUE.
        ENDIF.
      ENDIF.
*** split is inconsistent => go on with rebuild             "UD031121
      CLEAR <doctab>-mess.                                  "UD031121
      ADD 1 TO cnt_corr.                                    "UD290322
****************************************************************
*** error case: imbalance between SPLINFO and ACDOCA
****************************************************************
      REFRESH: lt_spl, lt_val.
      PERFORM build_spl TABLES   lt_spl
                                 lt_val
                        CHANGING x_error
                                 error_string.
      IF x_error EQ space.
*** in case of existing SPLINFO backup old data
        IF p_miss EQ space.
          SELECT * FROM fagl_splinfo INTO TABLE lt_spl_del
            WHERE belnr EQ <bseg>-belnr
              AND gjahr EQ <bseg>-gjahr
              AND bukrs EQ <bseg>-bukrs
              AND buzei EQ <bseg>-buzei.
*          IF sy-subrc EQ 0.                                "UD120523
          SELECT * FROM fagl_splinfo_val INTO TABLE lt_val_del
            WHERE belnr EQ <bseg>-belnr
              AND gjahr EQ <bseg>-gjahr
              AND bukrs EQ <bseg>-bukrs
              AND buzei EQ <bseg>-buzei.
          APPEND LINES OF lt_spl_del TO gt_splinfo_del.
          APPEND LINES OF lt_val_del TO gt_spl_val_del.
*          ENDIF.                                           "UD120523
        ENDIF.
        IF p_test EQ space.
          DELETE fagl_splinfo FROM TABLE lt_spl_del.
          DELETE fagl_splinfo_val FROM TABLE lt_val_del.
          INSERT fagl_splinfo FROM TABLE lt_spl.
          INSERT fagl_splinfo_val FROM TABLE lt_val.
          <doctab>-mess = 'Successfully updated'.           "UD190523
        ELSE.                                               "UD190523
          <doctab>-mess = 'Successfully simulated'.         "UD190523
        ENDIF.                                              "UD190523
      ELSE.
        <doctab>-error = 'X'.
        <doctab>-mess = error_string.
        EXIT.
      ENDIF.
    ENDLOOP.
*** no correction detected => not relevant => delete DOCTAB "UD290322
    IF cnt_corr EQ 0.                                       "UD290322
      <doctab>-mess = 'Not relevant'.                       "UD290322
      CONTINUE.                                             "UD290322
    ENDIF.                                                  "UD290322
*** one COMMIT WORK per document
    IF p_test EQ space.
      IF x_error EQ 'X'.
        ROLLBACK WORK.
      ELSE.
        COMMIT WORK.
      ENDIF.
    ENDIF.
  ENDLOOP.
*** delete documents without inconsistent split             "UD031121
  LOOP AT gt_doctab TRANSPORTING NO FIELDS                  "UD031121
    WHERE error EQ space                                    "UD031121
      AND mess  EQ 'Not relevant'.                          "UD031121
    DELETE gt_doctab INDEX sy-tabix.                        "UD031121
  ENDLOOP.                                                  "UD031121
*************************************************************UD031121
ENDFORM.

*&---------------------------------------------------------------------*
*& Form output
*&---------------------------------------------------------------------*
FORM output .
*** begin of change "UD190523
*  DATA: count       TYPE i.
*  DATA: ld_title    TYPE lvc_title.
*  DATA: ld_mode     TYPE string.
*  DATA: ld_string   TYPE string.
*  DATA: lt_fieldcat TYPE slis_t_fieldcat_alv.
*  DATA: ls_fieldcat TYPE slis_fieldcat_alv.
*  DATA: lt_sort     TYPE slis_t_sortinfo_alv.
*  DATA: ls_sort     TYPE slis_sortinfo_alv.
*  DATA: ls_doctab   TYPE doctab.
*
**** build field catalouge
*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'BUKRS'.
*  ls_fieldcat-seltext_l = 'Company Code'.
*  ls_fieldcat-seltext_m = 'CoCode'.
*  ls_fieldcat-seltext_s = 'CoCd'.
*  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-col_pos = 0.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'BELNR'.
*  ls_fieldcat-seltext_l = 'Document No'.
*  ls_fieldcat-seltext_m = 'Doc.No'.
*  ls_fieldcat-seltext_s = 'BELNR'.
*  ls_fieldcat-outputlen = '15'.                             "UD120523
*  ls_fieldcat-fix_column = 'X'.
*  ls_fieldcat-col_pos = 1.
*  ls_fieldcat-hotspot = 'X'.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'GJAHR'.
*  ls_fieldcat-seltext_l = 'Fiscal Year'.
*  ls_fieldcat-seltext_m = 'FYear'.
*  ls_fieldcat-seltext_s = 'FYr'.
*  ls_fieldcat-outputlen = '10'.
*  ls_fieldcat-col_pos = 2.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'BSTAT'.
*  ls_fieldcat-seltext_l = 'Document Status'.
*  ls_fieldcat-seltext_m = 'Status'.
*  ls_fieldcat-seltext_s = 'Stat'.
*  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-col_pos = 3.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'LDGRP'.
*  ls_fieldcat-seltext_l = 'Ledger Group'.
*  ls_fieldcat-seltext_m = 'LedGrp'.
*  ls_fieldcat-seltext_s = 'LdGrp'.
*  ls_fieldcat-outputlen = '8'.
*  ls_fieldcat-col_pos = 4.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'ERROR'.
*  ls_fieldcat-seltext_l = 'Error'.
*  ls_fieldcat-seltext_m = 'Error'.
*  ls_fieldcat-seltext_s = 'Err'.
*  ls_fieldcat-outputlen = '50'.
*  ls_fieldcat-col_pos = 5.
*  APPEND ls_fieldcat TO lt_fieldcat.
*  CLEAR ls_fieldcat.
*  ls_fieldcat-fieldname = 'MESS'.
*  ls_fieldcat-seltext_l = 'Message'.
*  ls_fieldcat-seltext_m = 'Mess.'.
*  ls_fieldcat-seltext_s = 'Msg'.
*  ls_fieldcat-outputlen = '100'.
*  ls_fieldcat-col_pos = 6.
*  APPEND ls_fieldcat TO lt_fieldcat.
**** define sort order
*  CLEAR ls_sort.
*  ls_sort-fieldname = 'ERROR'.
*  ls_sort-spos = 1.
*  ls_sort-down = abap_true.
*  APPEND ls_sort TO lt_sort.
*  CLEAR ls_sort.
*  ls_sort-fieldname = 'BUKRS'.
*  ls_sort-spos = 2.
*  ls_sort-up = abap_true.
*  APPEND ls_sort TO lt_sort.
*  CLEAR ls_sort.
*  ls_sort-fieldname = 'GJAHR'.
*  ls_sort-spos = 3.
*  ls_sort-up = abap_true.
*  APPEND ls_sort TO lt_sort.
*  CLEAR ls_sort.
*  ls_sort-fieldname = 'BELNR'.
*  ls_sort-spos = 4.
*  ls_sort-up = abap_true.
*  APPEND ls_sort TO lt_sort.
**** put count into headline
*  count = lines( gt_doctab ).
*  ld_string = count.
*  IF p_test EQ space.
*    ld_mode = 'UPDATE'.
*  ELSE.
*    ld_mode = 'TEST'.
*  ENDIF.
*  CONCATENATE
*    ld_mode
**    'MODE: Number of affected documents:'                  "UD041122
*    'MODE: No of docs:'                                     "UD041122
*    ld_string
*  INTO ld_title SEPARATED BY space.
*  IF p_test EQ space.
*    CONCATENATE
*      ld_title
*      'RFDT Key:'
*      exp_key
*    INTO ld_title SEPARATED BY space.
*  ENDIF.
**** no detailed output
*  IF p_detail EQ space.
*    CLEAR gt_doctab.
*    CLEAR ls_doctab.
*    ls_doctab-bukrs = p_bukrs.
**    ls_doctab-gjahr = p_gjahr.                             "UD240622
*    ls_doctab-error = 'No Details'.
*    APPEND ls_doctab TO gt_doctab.
*  ENDIF.
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
*      i_grid_title            = ld_title
*      i_callback_program      = sy-repid
*      i_callback_user_command = 'DRILL_DOWN'
*      it_fieldcat             = lt_fieldcat
*      it_sort                 = lt_sort
*    TABLES
*      t_outtab                = gt_doctab.
*  IF sy-subrc NE 0.
**   Implement suitable error handling here
*  ENDIF.
  DATA: lo_alv               TYPE REF TO cl_salv_table.
  DATA: lex_message          TYPE REF TO cx_salv_msg.
  DATA: lo_layout_settings   TYPE REF TO cl_salv_layout.
  DATA: lo_layout_key        TYPE        salv_s_layout_key.
  DATA: lo_columns           TYPE REF TO cl_salv_columns_table.
  DATA: lo_column            TYPE REF TO cl_salv_column.
  DATA: lex_not_found        TYPE REF TO cx_salv_not_found.
  DATA: lo_functions         TYPE REF TO cl_salv_functions_list.
  DATA: lo_display_settings  TYPE REF TO cl_salv_display_settings.
  DATA: ls_header            TYPE lvc_title.
  DATA: count                TYPE i.
  DATA: number(10)           TYPE c.
  DATA: ls_doctab            TYPE doctab.

  SORT gt_doctab BY error DESCENDING.
  count = lines( gt_doctab ).
  WRITE count TO number LEFT-JUSTIFIED.
  IF p_detail EQ space.
    CLEAR gt_doctab.
    CLEAR ls_doctab.
    ls_doctab-bukrs = p_bukrs.
    CONCATENATE 'No Details:' number 'Documents processed' INTO ls_doctab-mess SEPARATED BY space.
    APPEND ls_doctab TO gt_doctab.
  ENDIF.
  IF p_test IS INITIAL.
    CLEAR ls_doctab.
    CONCATENATE 'RFDT Key:' exp_key INTO ls_doctab-mess SEPARATED BY space.
    APPEND ls_doctab TO gt_doctab.
    SORT gt_doctab BY bukrs ASCENDING error DESCENDING.
  ENDIF.
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = lo_alv
        CHANGING
          t_table      = gt_doctab[] ).
    CATCH cx_salv_msg INTO lex_message.
  ENDTRY.
*** set the ALV layout
  lo_layout_settings   = lo_alv->get_layout( ).
  lo_layout_key-report = sy-repid.
  lo_layout_settings->set_key( lo_layout_key ).
  lo_layout_settings->set_save_restriction( if_salv_c_layout=>restrict_none ).
*** set the ALV toolbar
  lo_functions = lo_alv->get_functions( ).
  lo_functions->set_all( ).
*** optimize ALV columns size
  lo_columns = lo_alv->get_columns( ).
  lo_columns->set_optimize( ).
*** set column names manually
  TRY.
      lo_column = lo_columns->get_column( 'ERROR' ).
    CATCH cx_salv_not_found.
  ENDTRY.
  lo_column->set_long_text( 'Error' ).
  lo_column->set_medium_text( 'Error' ).
  lo_column->set_short_text( 'Err' ).
  TRY.
      lo_column = lo_columns->get_column( 'MESS' ).
    CATCH cx_salv_not_found.
  ENDTRY.
  lo_column->set_long_text( 'Message' ).
  lo_column->set_medium_text( 'Mess.' ).
  lo_column->set_short_text( 'Msg' ).
*** set zebra display
  lo_display_settings = lo_alv->get_display_settings( ).
  lo_display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
*** set ALV header title
  IF p_test EQ 'X'.
    CONCATENATE 'TEST Mode: No. of Docs:' number
      INTO ls_header SEPARATED BY space.
  ELSE.
    CONCATENATE 'UPDATE Mode: No. of Docs:' number
      INTO ls_header SEPARATED BY space.
  ENDIF.
  lo_display_settings->set_list_header( ls_header ).
*** display the ALV
  lo_alv->display( ).
*** end of change "UD190523
ENDFORM.

*---------------------------------------------------------------------*
*      Form  USER_COMMAND
*---------------------------------------------------------------------*
*FORM drill_down USING r_ucomm     LIKE sy-ucomm
*                      rs_selfield TYPE slis_selfield.
*  CASE r_ucomm.
*    WHEN '&IC1'.
*      CASE rs_selfield-fieldname.
*        WHEN 'BELNR'.
*          READ TABLE gt_doctab INDEX rs_selfield-tabindex
*          ASSIGNING <doctab>.
*          CHECK sy-subrc EQ 0.
*          SET PARAMETER ID 'BUK' FIELD <doctab>-bukrs.
*          SET PARAMETER ID 'BLN' FIELD <doctab>-belnr.
*          SET PARAMETER ID 'GJR' FIELD <doctab>-gjahr.
*          CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
*      ENDCASE.
*  ENDCASE.
*ENDFORM.

*&---------------------------------------------------------------------*
*& Form check_input
*&---------------------------------------------------------------------*
FORM check_input .
  DATA: ls_cvers   TYPE cvers.
  DATA: lt_bukrs   TYPE fagl_t_bukrs.
  DATA: spl_active TYPE c.

*** verify S/4
  SELECT SINGLE * FROM cvers INTO ls_cvers
    WHERE component EQ 'S4CORE'.
  IF NOT sy-subrc EQ 0.
    MESSAGE e016(gu)
    WITH 'No S4CORE release found'.
  ENDIF.
  IF ls_cvers-release LT '101'.
    MESSAGE e016(gu)
    WITH 'Report not valid for release'
         ls_cvers-component ls_cvers-release.
  ENDIF.
  SELECT SINGLE * FROM t001
    WHERE bukrs EQ p_bukrs.
  IF NOT sy-subrc EQ 0.
    MESSAGE e016(gu)
    WITH 'Company code' p_bukrs 'does not exist'.
  ENDIF.
*** verify document split
  REFRESH lt_bukrs.
  APPEND t001-bukrs TO lt_bukrs.
  spl_active = cl_fagl_split_services=>check_activity( lt_bukrs ).
  IF spl_active NE 'X'.
    MESSAGE e016(gu)
    WITH 'Split not active in company code' t001-bukrs.
  ENDIF.
*** exclude systems with online payment update              "UD100123
  SELECT COUNT(*) FROM fagl_split_field                     "UD100123
*    WHERE field EQ 'VOBELNR'.                              "UD250124
    WHERE field EQ 'VOBELNR'                                "UD250124
       OR field EQ 'KNBELNR'.                               "UD250124
  IF sy-subrc EQ 0.                                         "UD100123
    MESSAGE e016(gu)                                        "UD100123
    WITH 'PSM Online Payment Update active, no processing'. "UD100123
  ENDIF.                                                    "UD100123
*** exclude JVA systems with VNAME since missing in ACDOCA  "UD250124
  SELECT COUNT(*) FROM fagl_split_field                     "UD250124
    WHERE field EQ 'VNAME'.                                 "UD250124
  IF sy-subrc EQ 0.                                         "UD100123
    MESSAGE e016(gu)                                        "UD100123
    WITH 'JVA with VNAME as split field active, no processing'. "UD100123
  ENDIF.                                                    "UD100123
*** verify fiscal year matching SIS activation date         "UD180823
  SELECT COUNT(*) FROM fagl_split_actc                      "UD180823
    WHERE bukrs EQ t001-bukrs                               "UD180823
      AND project_id NE space.                              "UD180823
  IF sy-subrc EQ 0.                                         "UD180823
    SELECT SINGLE s~act_date                                "UD180823
    FROM fins_sis_proj AS s INNER JOIN fagl_split_actc AS f "UD180823
                            ON s~project_id EQ f~project_id "UD180823
    WHERE f~bukrs EQ @t001-bukrs                            "UD180823
    INTO @sis_act_date.                                     "UD180823
    IF NOT sy-subrc EQ 0.                                   "UD180823
      CLEAR sis_act_date.                                   "UD180823
    ENDIF.                                                  "UD180823
  ELSE.                                                     "UD180823
    CLEAR sis_act_date.                                     "UD180823
  ENDIF.                                                    "UD180823
*** derive youngest NGL migration date and check with SIS   "UD250124
  DATA: max_migdt TYPE budat.                               "UD250124
  SELECT MAX( 1~migdt ) INTO max_migdt                      "UD250124
  FROM fagl_mig_001 AS 1 INNER JOIN fagl_mig_002 AS 2       "UD250124
                                 ON 1~mgpln EQ 2~mgpln      "UD250124
    WHERE 2~bukrs EQ t001-bukrs.                            "UD250124
*** SIS_ACT_DATE is already part of selection and MIGDT is  "UD250124
*** only relevant if SIS_ACT_DATE is initial                "UD250124
  IF max_migdt GT sis_act_date.                             "UD250124
    sis_act_date = max_migdt.                               "UD250124
  ENDIF.                                                    "UD250124
  IF sy-ucomm EQ 'SAPONLY'.
    exp = 'X'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form screen
*&---------------------------------------------------------------------*
FORM screen .

  LOOP AT SCREEN.
    IF screen-group1 = 'INC'.
      IF exp = 'X'.
        screen-invisible = 0.
        screen-active = 1.
      ELSE.
        screen-invisible = 1.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form write_rfdt
*&---------------------------------------------------------------------*
FORM write_rfdt .
  DATA: time_stamp TYPE timestamp.

  CHECK p_test EQ space.
  GET TIME STAMP FIELD time_stamp.
  exp_key(3)    = 'SPL'.
  exp_key+3(4)  = t001-bukrs.
  exp_key+7(15) = time_stamp.
  EXPORT
    gt_doctab
    gt_splinfo_del
    gt_spl_val_del
  TO DATABASE rfdt(zz) ID exp_key.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form build_spl
*&---------------------------------------------------------------------*
FORM build_spl  TABLES   lt_spl STRUCTURE fagl_splinfo
                         lt_val STRUCTURE fagl_splinfo_val
                CHANGING x_error
                         error_string.
  DATA: lt_acdoca        TYPE TABLE OF acdoca.
  DATA: lt_glu1          TYPE TABLE OF glu1.
  DATA: lt_acchd         TYPE acchd_t.
  DATA: lt_accit         TYPE accit_t.
  DATA: lt_acccr         TYPE acccr_t.
  DATA: ls_acdoca        TYPE acdoca.
  DATA: ls_glu1          TYPE glu1.
  DATA: ls_spl           TYPE fagl_splinfo.
  DATA: ls_val           TYPE fagl_splinfo_val.
  DATA: ls_spl_no        TYPE fagl_splinfo-spl_no.
  DATA: cycle_no         TYPE i.
  FIELD-SYMBOLS: <accit> TYPE accit.
  FIELD-SYMBOLS: <acccr> TYPE acccr.

*** create the FAGL_SPLINFO data ledger-wise
  CLEAR cycle_no.
  LOOP AT gt_finsc_ld_cmp ASSIGNING <ld_cmp>.
    REFRESH: lt_acdoca, lt_glu1.
    SELECT * FROM acdoca INTO TABLE lt_acdoca
      WHERE rldnr  EQ <ld_cmp>-rldnr
        AND rbukrs EQ <bseg>-bukrs
        AND gjahr  EQ <bseg>-gjahr
        AND belnr  EQ <bseg>-belnr
        AND buzei  EQ <bseg>-buzei.
    CHECK sy-subrc EQ 0.
    ADD 1 TO cycle_no.
    CLEAR ls_spl_no.
*** ensure to always have same SPL_NO order
    SORT lt_acdoca BY docln.
    LOOP AT lt_acdoca INTO ls_acdoca.
      CLEAR ls_glu1.
      REFRESH lt_glu1.
      MOVE-CORRESPONDING ls_acdoca TO ls_glu1.
      APPEND ls_glu1 TO lt_glu1.
*** transform a single ACDOCA into interface structures
      REFRESH: lt_acchd, lt_accit, lt_acccr.
      CALL FUNCTION 'G_GLU1_TO_AC_DOC_TRANSFORM'
        EXPORTING
          ib_acdoc_compatibility_mode = abap_false
        TABLES
          t_glu1                      = lt_glu1
          t_acchd                     = lt_acchd
          t_accit                     = lt_accit
          t_acccr                     = lt_acccr
        EXCEPTIONS
          overflow_occured            = 1
          OTHERS                      = 2.
      IF NOT sy-subrc EQ 0.
        CONCATENATE
          <bseg>-buzei
          ': Error in GLU1 transformation'
        INTO error_string SEPARATED BY space.
        x_error = 'X'.
        EXIT.
      ENDIF.
*** build FAGL_SPLINFO
      READ TABLE lt_accit ASSIGNING <accit> INDEX 1.
      MOVE-CORRESPONDING <accit> TO ls_spl.
      ADD 1 TO ls_spl_no.
      ls_spl-spl_no = ls_spl_no.
      IF cycle_no EQ 1.
        APPEND ls_spl TO lt_spl.
      ENDIF.
*** build FAGL_SPLINFO_VAL
      MOVE-CORRESPONDING ls_spl TO ls_val.
      LOOP AT lt_acccr ASSIGNING <acccr>.
        MOVE-CORRESPONDING <acccr> TO ls_val.
        CLEAR ls_val-currtyp.
*** add SPLINFO_VAL only if CURTP is missing yet
        IF cycle_no EQ 1.
          APPEND ls_val TO lt_val.
        ELSE.
          READ TABLE lt_val WITH KEY
            buzei  = ls_val-buzei
            spl_no = ls_val-spl_no
            curtp  = ls_val-curtp
          TRANSPORTING NO FIELDS.
          IF NOT sy-subrc EQ 0.
            APPEND ls_val TO lt_val.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDLOOP.
  IF x_error EQ 'X'.
    REFRESH: lt_spl, lt_val.
  ENDIF.
ENDFORM.
