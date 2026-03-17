*&---------------------------------------------------------------------*
*& Report  ZFINS_CORR_FAGLSPLINFO_VAL
*&
*&---------------------------------------------------------------------*
*& The report will idendify and correct the inconsistent splitting
*& amounts for freely defined currencies
*&
*& The report is also detecting cleared documents posted after migration
*& (MIG_SOUREC = space).
*&---------------------------------------------------------------------*
*& Version 1 : Correction of inconsistent splitting amounts
*&---------------------------------------------------------------------*
*& Version 2 : Check buzei balance between fagl_splinfo_val vs acdoca
*&---------------------------------------------------------------------*
*& Report in ER9
*& Author: I340977
*&---------------------------------------------------------------------*
*& PLEAE DO'NOT GIVE THIS REPORT TO ANY CUSTOMER UNTIL TESTED THROUGHLY
*&---------------------------------------------------------------------*

REPORT zfins_corr_faglsplinfo_val.
TABLES: bkpf,fagl_splinfo_val.

*-------- Main processing tables----------------------------------------*
TYPES: BEGIN OF ty_corr,
         belnr      TYPE belnr_d,
         gjahr      TYPE gjahr,
         bukrs      TYPE bukrs,
         buzei      TYPE buzei,
         spl_no     TYPE fagl_index,
         curtp      TYPE curtp,
         old_wrbtr  TYPE fins_vwcur12,
         new_wrbtr  TYPE fins_vwcur12,
         backup     TYPE boole_d,
         update     TYPE boole_d,
       END OF ty_corr.
TYPES: BEGIN OF ty_clr,
         bukrs_clr TYPE bukrs,
         gjahr_clr TYPE gjahr,
         belnr_clr TYPE belnr_d,
       END OF ty_clr.
DATA lt_faglsplinfo_val       TYPE SORTED TABLE OF fagl_splinfo_val WITH UNIQUE KEY belnr gjahr bukrs buzei spl_no curtp .
DATA lt_bkpf                  TYPE SORTED TABLE OF bkpf WITH UNIQUE KEY belnr gjahr bukrs.
DATA ls_faglsplinfo_val       TYPE fagl_splinfo_val.
DATA ls_splinfo_tmp           TYPE fagl_splinfo_val.
DATA gt_corr                  TYPE TABLE OF ty_corr.
DATA gs_corr                  TYPE ty_corr.
DATA lt_clr                   TYPE TABLE OF ty_clr.
DATA ls_clr                   TYPE ty_clr.
DATA lt_bukrs                 TYPE TABLE OF t001 WITH HEADER LINE.
DATA lv_leading_ledger        TYPE rldnr.
DATA ls_ld_cmp                TYPE finsc_ld_cmp.
DATA lt_src_tgt_curr          TYPE TABLE OF cl_fins_new_curr_util=>gtys_rule_to_fill_curr.
DATA ls_rule_to_fill_curr     TYPE cl_fins_new_curr_util=>gtys_rule_to_fill_curr.
DATA lv_tmp                   TYPE fagl_splinfo_val.
DATA lv_wrbtr_old             TYPE string.
DATA lv_wrbtr_new             TYPE string.
DATA lv_rate_type             TYPE kurst.
DATA go_log                   TYPE REF TO cl_fins_fi_log.
DATA go_muj                   TYPE REF TO cl_fins_mig_uj_doc.
DATA gv_bal_extnum            TYPE balnrext.
DATA go_log1                  TYPE REF TO cl_fins_fi_log.
DATA go_muj1                  TYPE REF TO cl_fins_mig_uj_doc.
DATA gv_bal_extnum1           TYPE balnrext.
DATA gs_msg                   TYPE string.
DATA gs_msg1                  TYPE string.
DATA gs_doc                   TYPE string.
DATA gv_type                  TYPE c.
DATA io_appl_log              TYPE REF TO cl_fins_fi_log.
DATA exp                      TYPE c.
DATA lv_count_corr            TYPE i.
DATA lv_cnt_corr              TYPE string VALUE '0'.
DATA lv_pck                   TYPE i.
DATA lv_count                 TYPE i.
DATA lv_cnt                   TYPE string.
DATA ld_cursor                TYPE cursor.
DATA lv_tmstmp                TYPE timestamp.
DATA lv_muj_date              TYPE sy-datum.
DATA lv_runid                 TYPE fins_mass_run_id.
DATA lv_active                TYPE boole_d.
DATA lt_bukrs_tmp             TYPE fagl_t_bukrs.

CONSTANTS:
  con_bal_subobj TYPE balsubobj VALUE 'FINS_MIG'.

*--- Selection screen -------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK 001 WITH FRAME TITLE text_100.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(16) text_005 FOR FIELD s_belnr.
SELECTION-SCREEN POSITION 21.
SELECT-OPTIONS: s_belnr FOR bkpf-belnr.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(16) text_003 FOR FIELD s_bukrs.
SELECTION-SCREEN POSITION 21.
SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(18) text_002 FOR FIELD s_gjahr.
SELECTION-SCREEN POSITION 21.
SELECT-OPTIONS: s_gjahr FOR bkpf-gjahr.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) text_004 FOR FIELD s_curtp.
SELECTION-SCREEN POSITION 21.
SELECT-OPTIONS: s_curtp FOR fagl_splinfo_val-curtp.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK 001.

SELECTION-SCREEN BEGIN OF BLOCK 002 WITH FRAME TITLE text_200.

PARAMETERS p_backup AS CHECKBOX USER-COMMAND bck.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 24.
PARAMETERS p_bck    TYPE mandt MODIF ID g1 .
SELECTION-SCREEN END OF LINE.
PARAMETERS p_clear  AS CHECKBOX DEFAULT abap_true.
PARAMETERS p_update AS CHECKBOX DEFAULT space MODIF ID upd.

SELECTION-SCREEN END OF BLOCK 002.

***Initialization
INITIALIZATION.
  text_002                = 'Fiscal Year'.
  text_003                = 'Company Code'.
  text_004                = 'Currency Type'.
  text_005                = 'Document Number'.
  text_100                = 'Select Options'.
  text_200                = 'Control Parameters'.
  %_p_backup_%_app_%-text = 'Data BackUp In Client'.
  %_p_clear_%_app_%-text  = 'Post Migration Clearing Doc.'.
  %_p_bck_%_app_%-text    = 'Client'.
*----------------------------------------------------------------------*

***At Selection Screen
AT SELECTION-SCREEN.
 IF sy-ucomm EQ 'SAPONLY'. exp = 'X'. ENDIF.
***At Selection Screen output
AT SELECTION-SCREEN OUTPUT.
  IF sy-batch EQ space.
    p_update = ' '.
  ENDIF.
  LOOP AT SCREEN.
    IF screen-group1 = 'UPD'.
      IF exp = 'X'.
        screen-invisible = 0.
      ELSE.
        screen-invisible = 1.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

  IF p_backup = ' '.
    LOOP AT SCREEN.
      IF screen-group1 = 'G1'.
        screen-invisible = '1'.
        screen-input = 0 .
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

START-OF-SELECTION.
***init application log
  CONCATENATE sy-cprog '_' sy-datum sy-uzeit INTO gv_bal_extnum.
  go_log  = cl_fins_fi_log=>get_log( iv_subobject = con_bal_subobj iv_extnum = gv_bal_extnum ).
  CREATE OBJECT go_muj.

  CONCATENATE sy-cprog '_' sy-datum sy-uzeit INTO gv_bal_extnum1.
  go_log1 = cl_fins_fi_log=>get_log( iv_subobject = con_bal_subobj iv_extnum = gv_bal_extnum1 ).
  CREATE OBJECT go_muj1.

  IF p_update = 'X'.
    MESSAGE s048(fins_fi_mig) INTO gs_msg. "***** Productive Run ******
  ELSE.
    MESSAGE w047(fins_fi_mig) INTO gs_msg. "***** Test Run ******
  ENDIF.
  go_log->add_current_sy_message( iv_probclass = '1' ).
  go_log1->add_current_sy_message( iv_probclass = '1' ).

***Read leading ledger
CALL FUNCTION 'FAGL_GET_LEADING_LEDGER'
    IMPORTING
      e_rldnr       = lv_leading_ledger
    EXCEPTIONS
      not_found     = 1
      more_than_one = 2
      OTHERS        = 3.

***Read migration details
SELECT SINGLE start_processing MAX( run_id ) FROM fins_masspackage INTO ( lv_tmstmp ,lv_runid )
                               WHERE set_id  = 'MUJ' AND step_id = 'MIG_UJ_DOC'
                               GROUP BY start_processing run_id.

CONVERT TIME STAMP lv_tmstmp TIME ZONE sy-zonlo
        INTO DATE lv_muj_date TIME sy-zonlo.
***Read exchange rate type
SELECT SINGLE rate_type INTO lv_rate_type FROM finsc_mig_curr.
***Get Valid Company codes
SELECT * FROM t001 INTO TABLE lt_bukrs WHERE bukrs IN s_bukrs.

***Processing per company code
  LOOP AT lt_bukrs.
***Check document splitting per company code
    APPEND lt_bukrs-bukrs TO lt_bukrs_tmp.
    lv_active = cl_fagl_split_services=>check_activity( it_bukrs = lt_bukrs_tmp ).
    IF lv_active IS INITIAL. "company code not active for splitting
          CONCATENATE  'Company code is not active for splitting' lt_bukrs-bukrs INTO gs_msg SEPARATED BY space.
          go_log->add_message(
            iv_msg_type    = 'I'
            iv_msg_id      = 'FINS_ACDOC_POST'
            iv_msg_number  = 000
            iv_msg_v2      = gs_msg  ).
      CONTINUE.
    ELSE.                    "Company code active for splitting
***Fill ledger/company code information for currency handling
     SELECT SINGLE * INTO ls_ld_cmp FROM finsc_ld_cmp WHERE rldnr EQ lv_leading_ledger
                                                      AND   bukrs EQ lt_bukrs-bukrs.
***Get exchange rate for only input currencies in selection screen

***Controlling area currency
      IF ( ls_ld_cmp-curtpk IS NOT INITIAL AND ls_ld_cmp-curposk IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpk
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Freely defined currency1
      IF ( ls_ld_cmp-curtpo IS NOT INITIAL AND ls_ld_cmp-curposo IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpo
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Freely defined currency2
      IF ( ls_ld_cmp-curtpv IS NOT INITIAL AND ls_ld_cmp-curposv IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpv
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
**Freely defined currency3
      IF ( ls_ld_cmp-curtpb IS NOT INITIAL AND ls_ld_cmp-curposb IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpb
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Freely defined currency4
      IF ( ls_ld_cmp-curtpc IS NOT INITIAL AND ls_ld_cmp-curposc IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpc
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Freely defined currency5
      IF ( ls_ld_cmp-curtpd IS NOT INITIAL AND ls_ld_cmp-curposd IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpd
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Freely defined currency6
      IF ( ls_ld_cmp-curtpe IS NOT INITIAL AND ls_ld_cmp-curpose IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpe
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Freely defined currency7
      IF ( ls_ld_cmp-curtpf IS NOT INITIAL AND ls_ld_cmp-curposf IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpf
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Freely defined currency8
      IF ( ls_ld_cmp-curtpg IS NOT INITIAL AND ls_ld_cmp-curposg IS INITIAL ).
           ls_rule_to_fill_curr = cl_fins_new_curr_util=>set_base_rule_to_fill_curr(
                                         is_finsc_ld_cmp   = ls_ld_cmp
                                         iv_curtp          = ls_ld_cmp-curtpg
                                         iv_umdtm          = lv_muj_date     "Migration date
                                         iv_kurst          = lv_rate_type ). "Exchange rate
           APPEND ls_rule_to_fill_curr TO lt_src_tgt_curr.
           CLEAR ls_rule_to_fill_curr.
      ENDIF.
***Process only if company code has non FI integrated currency
      IF lt_src_tgt_curr[] IS INITIAL.
           CONCATENATE  'Non FI currencies not maintained for company code' lt_bukrs-bukrs INTO gs_msg SEPARATED BY space.
           go_log->add_message(
             iv_msg_type    = 'I'
             iv_msg_id      = 'FINS_ACDOC_POST'
             iv_msg_number  = 000
             iv_msg_v2      = gs_msg  ).
      ELSE.
        IF lt_src_tgt_curr[] IS NOT INITIAL AND s_curtp[] IS NOT INITIAL.
           DELETE lt_src_tgt_curr WHERE target_curtp NOT IN s_curtp.
        ENDIF.
      ENDIF.
***Get items from fagl_splinfo_val posted before migration
    OPEN CURSOR WITH HOLD @ld_cursor
    FOR SELECT * FROM bkpf WHERE bukrs EQ @lt_bukrs-bukrs
                           AND   belnr IN @s_belnr
                           AND   gjahr IN @s_gjahr
                           AND   cpudt <  @lv_muj_date.
     DO.
      REFRESH: lt_faglsplinfo_val,gt_corr,lt_bkpf.
      CLEAR:   gs_corr.

        FETCH NEXT CURSOR ld_cursor
        INTO CORRESPONDING FIELDS OF lt_bkpf
        PACKAGE SIZE 10000.

        IF sy-subrc NE 0.
          CLOSE CURSOR ld_cursor.
          EXIT.
        ENDIF.

        CLEAR: lv_cnt_corr.
        lv_pck = lv_pck + 1.

        IF lt_bkpf IS NOT INITIAL.
          SELECT DISTINCT * FROM fagl_splinfo_val INTO TABLE lt_faglsplinfo_val
                            FOR ALL ENTRIES IN lt_bkpf
                            WHERE bukrs EQ lt_bkpf-bukrs
                            AND   belnr EQ lt_bkpf-belnr
                            AND   gjahr EQ lt_bkpf-gjahr.
        ENDIF.

    LOOP AT lt_faglsplinfo_val INTO ls_faglsplinfo_val.
***Correction for freely defined currency
       READ TABLE lt_src_tgt_curr INTO ls_rule_to_fill_curr WITH KEY target_curtp = ls_faglsplinfo_val-curtp.
        IF sy-subrc IS INITIAL.
***Read source currency details
            READ TABLE lt_faglsplinfo_val INTO ls_splinfo_tmp WITH KEY  belnr  = ls_faglsplinfo_val-belnr
                                                                        gjahr  = ls_faglsplinfo_val-gjahr
                                                                        bukrs  = ls_faglsplinfo_val-bukrs
                                                                        buzei  = ls_faglsplinfo_val-buzei
                                                                        spl_no = ls_faglsplinfo_val-spl_no
                                                                        curtp  = ls_rule_to_fill_curr-source_curtp.
            IF sy-subrc IS INITIAL.
               ls_splinfo_tmp-wrbtr = ls_splinfo_tmp-wrbtr * ls_rule_to_fill_curr-db_conversion_rate.
                IF ls_splinfo_tmp-wrbtr EQ ls_faglsplinfo_val-wrbtr.
                   CONTINUE.
                ELSE.
                   MOVE-CORRESPONDING ls_faglsplinfo_val TO gs_corr.
                   gs_corr-old_wrbtr = ls_faglsplinfo_val-wrbtr.
                   gs_corr-new_wrbtr = ls_splinfo_tmp-wrbtr.
                   APPEND gs_corr TO gt_corr.
                   CLEAR gs_corr.
                   lv_cnt_corr   = lv_cnt_corr + 1.
                   lv_count_corr = lv_cnt_corr.
                ENDIF.
            ENDIF.
         CLEAR: ls_faglsplinfo_val,ls_splinfo_tmp.
        ENDIF.
    ENDLOOP.

***Get cleared documents posted after migration
     IF p_clear = 'X' AND gt_corr[] IS NOT INITIAL.
       SELECT DISTINCT bukrs_clr,gjahr_clr,belnr_clr INTO TABLE @lt_clr  FROM bse_clr AS c
           INNER JOIN bkpf AS a ON  c~bukrs_clr = a~bukrs AND c~gjahr_clr = a~gjahr
                                AND c~belnr_clr = a~belnr
           FOR ALL ENTRIES IN @gt_corr WHERE c~bukrs = @gt_corr-bukrs
                                       AND   c~gjahr = @gt_corr-gjahr
                                       AND   c~belnr = @gt_corr-belnr
                                       AND   a~cpudt > @lv_muj_date.
          DESCRIBE TABLE lt_clr LINES lv_count.
            IF lv_count NE '0'.
              lv_cnt = lv_count.
                  CONCATENATE 'List Of Documents Cleared After Migration:' lv_cnt INTO gs_msg SEPARATED BY space.
                  go_log1->add_message(
                    iv_msg_type    = 'I'
                    iv_msg_id      = 'FINS_ACDOC_POST'
                    iv_msg_number  = 000
                    iv_msg_v2      = gs_msg ).
                LOOP AT lt_clr INTO ls_clr.
***Create Application Log
                  CONCATENATE  'Fiscal Year:' ls_clr-gjahr_clr INTO gs_doc SEPARATED BY space.
                  CONCATENATE  'Document:' ls_clr-belnr_clr 'Company Code:' ls_clr-bukrs_clr  INTO gs_msg SEPARATED BY space.
                  CLEAR  gs_corr.
                   go_log1->add_message(
                     iv_msg_type    = 'I'
                     iv_msg_id      = 'FINS_ACDOC_POST'
                     iv_msg_number  = 000
                     iv_msg_v2      = gs_msg
                     iv_msg_v3      = gs_doc ).
                ENDLOOP.
                CLEAR: gs_msg,gs_doc.
            ENDIF.
     ENDIF.
***Validate splitting amounts for clearing documents
     IF lt_clr IS NOT INITIAL.
       PERFORM get_faglsplinfo.
     ENDIF.
***Number of corrected line items
     IF lv_count_corr NE '0'.
       IF p_update = 'X'.
        CONCATENATE  'Number of Corrected Docuemnts:' lv_cnt_corr INTO gs_msg SEPARATED BY space.
       ELSE.
        CONCATENATE  'Number of documents to be corrected:' lv_cnt_corr INTO gs_msg SEPARATED BY space.
       ENDIF.
       go_log->add_message(
         iv_msg_type    = 'I'
         iv_msg_id      = 'FINS_ACDOC_POST'
         iv_msg_number  = 000
         iv_msg_v2      = gs_msg  ).
       CLEAR: gs_msg.
     ENDIF.
***Check per line item balance between acdoca vs fagl_splinfor_val
     PERFORM check_buzei_bal.
***Correction in update run
      IF sy-batch EQ 'X' AND p_update EQ 'X'.
         LOOP AT gt_corr INTO gs_corr.
            CLEAR: lv_wrbtr_old, lv_wrbtr_new.
            lv_wrbtr_old = gs_corr-old_wrbtr.
            lv_wrbtr_new = gs_corr-new_wrbtr.
          IF p_backup = 'X'.
           MOVE-CORRESPONDING gs_corr TO lv_tmp.
           lv_tmp-mandt = p_bck.
           lv_tmp-wrbtr = gs_corr-old_wrbtr.
           INSERT fagl_splinfo_val CLIENT SPECIFIED FROM lv_tmp.
            IF sy-subrc IS INITIAL.
               gs_corr-backup = 'X'.
             UPDATE fagl_splinfo_val SET   wrbtr  = gs_corr-new_wrbtr
                                     WHERE belnr  = gs_corr-belnr
                                     AND   gjahr  = gs_corr-gjahr
                                     AND   bukrs  = gs_corr-bukrs
                                     AND   buzei  = gs_corr-buzei
                                     AND   spl_no = gs_corr-spl_no
                                     AND   curtp  = gs_corr-curtp.
                 IF sy-subrc IS INITIAL.
                    gs_corr-update = 'X'.
                 ENDIF.
                MODIFY gt_corr FROM gs_corr.
            ENDIF.
          ELSE.
             UPDATE fagl_splinfo_val SET   wrbtr  = gs_corr-new_wrbtr
                                     WHERE belnr  = gs_corr-belnr
                                     AND   gjahr  = gs_corr-gjahr
                                     AND   bukrs  = gs_corr-bukrs
                                     AND   buzei  = gs_corr-buzei
                                     AND   spl_no = gs_corr-spl_no
                                     AND   curtp  = gs_corr-curtp.
          ENDIF.
***Create Application Log
            CONCATENATE  'Old Val:' lv_wrbtr_old 'New Val:' lv_wrbtr_new 'Back Up:'
            INTO gs_doc SEPARATED BY space.
            CONCATENATE gs_corr-backup 'Update:' gs_corr-update INTO gs_msg1 SEPARATED BY space.
            CONCATENATE  gs_corr-belnr gs_corr-bukrs gs_corr-gjahr gs_corr-buzei gs_corr-spl_no gs_corr-curtp
            INTO gs_msg SEPARATED BY space.
            CLEAR  gs_corr.
            go_log->add_message(
              iv_msg_type    = 'I'
              iv_msg_id      = 'FINS_ACDOC_POST'
              iv_msg_number  = 000
              iv_msg_v2      = gs_msg
              iv_msg_v3      = gs_doc
              iv_msg_v4      = gs_msg1 ).
       CLEAR: lv_tmp,gs_corr.
       ENDLOOP.
      ELSE.
***Test Run
        LOOP AT gt_corr INTO gs_corr.
            CLEAR: lv_wrbtr_old, lv_wrbtr_new.
            lv_wrbtr_old = gs_corr-old_wrbtr.
            lv_wrbtr_new = gs_corr-new_wrbtr.
***Create Application Log
              CONCATENATE  'Old Val:' lv_wrbtr_old  'New Val:' lv_wrbtr_new INTO gs_doc SEPARATED BY space.
              CONCATENATE  gs_corr-belnr gs_corr-bukrs gs_corr-gjahr gs_corr-buzei gs_corr-spl_no gs_corr-curtp
              INTO gs_msg SEPARATED BY space.
              CLEAR  gs_corr.
              go_log->add_message(
                iv_msg_type    = 'I'
                iv_msg_id      = 'FINS_ACDOC_POST'
                iv_msg_number  = 000
                iv_msg_v2      = gs_msg
                iv_msg_v3      = gs_doc ).
          CLEAR gs_corr.
        ENDLOOP.
      ENDIF.
       CALL FUNCTION 'DB_COMMIT'.
     ENDDO.
    ENDIF.
  ENDLOOP.

  IF lv_pck > 1 AND lv_cnt_corr EQ 0.
    gs_msg  = 'No Inconsistent Records Found'.
    gv_type = 'W'.
    PERFORM status_msg USING gs_msg gv_type.
  ENDIF.

***Save application log
  PERFORM save_application_log USING go_log go_log1 gv_bal_extnum.
***display application log
  PERFORM display_log USING go_log go_log1.

*&---------------------------------------------------------------------*
*& Form SAVE_APPLICATION_LOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_LOG
*&      --> GV_BAL_EXTNUM
*&---------------------------------------------------------------------*
FORM save_application_log  USING io_appl_log   TYPE REF TO cl_fins_fi_log
                                 io_appl_log1  TYPE REF TO cl_fins_fi_log
                                 iv_bal_extnum TYPE balnrext.
  io_appl_log->save_log( ).
  io_appl_log1->save_log( ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_LOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GO_LOG
*&---------------------------------------------------------------------*
FORM display_log  USING io_appl_log  TYPE REF TO cl_fins_fi_log
                        io_appl_log1 TYPE REF TO cl_fins_fi_log.
  IF io_appl_log IS INITIAL.
    MESSAGE s223(bl).
    EXIT.
  ENDIF.
  io_appl_log->show_current_log( i_xpopup = abap_false ).
  io_appl_log1->show_current_log( i_xpopup = abap_false ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form STATUS_MSG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_MSG
*&      --> GV_TYPE
*&---------------------------------------------------------------------*
FORM status_msg USING ls_msg TYPE string ls_type TYPE c.
  IF ls_type IS INITIAL.
    ls_type = 'I'.
  ENDIF.
  go_log->add_message(
      iv_msg_type    = ls_type
      iv_msg_id      = 'FINS_ACDOC_POST'
      iv_msg_number  = 000
      iv_msg_v3      = ls_msg ).
  go_log1->add_message(
      iv_msg_type    = ls_type
      iv_msg_id      = 'FINS_ACDOC_POST'
      iv_msg_number  = 000
      iv_msg_v3      = ls_msg ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_FAGLSPLINFO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_faglsplinfo .
  REFRESH lt_faglsplinfo_val.
  SELECT DISTINCT * FROM fagl_splinfo_val INTO TABLE lt_faglsplinfo_val
                    FOR ALL ENTRIES IN lt_clr
                    WHERE bukrs EQ lt_clr-bukrs_clr
                    AND   belnr EQ lt_clr-belnr_clr
                    AND   gjahr EQ lt_clr-gjahr_clr.
    IF sy-subrc IS INITIAL.
      LOOP AT lt_faglsplinfo_val INTO ls_faglsplinfo_val.
*  **Correction for freely defined currency
         READ TABLE lt_src_tgt_curr INTO ls_rule_to_fill_curr WITH KEY target_curtp = ls_faglsplinfo_val-curtp.
          IF sy-subrc IS INITIAL.
*  **Read source currency details
              READ TABLE lt_faglsplinfo_val INTO ls_splinfo_tmp WITH KEY  belnr  = ls_faglsplinfo_val-belnr
                                                                          gjahr  = ls_faglsplinfo_val-gjahr
                                                                          bukrs  = ls_faglsplinfo_val-bukrs
                                                                          buzei  = ls_faglsplinfo_val-buzei
                                                                          spl_no = ls_faglsplinfo_val-spl_no
                                                                          curtp  = ls_rule_to_fill_curr-source_curtp.
              IF sy-subrc IS INITIAL.
                 ls_splinfo_tmp-wrbtr = ls_splinfo_tmp-wrbtr * ls_rule_to_fill_curr-db_conversion_rate.
                  IF ls_splinfo_tmp-wrbtr EQ ls_faglsplinfo_val-wrbtr.
                     CONTINUE.
                  ELSE.
                     MOVE-CORRESPONDING ls_faglsplinfo_val TO gs_corr.
                     gs_corr-old_wrbtr = ls_faglsplinfo_val-wrbtr.
                     gs_corr-new_wrbtr = ls_splinfo_tmp-wrbtr.
                     APPEND gs_corr TO gt_corr.
                     CLEAR gs_corr.
                     lv_cnt_corr   = lv_cnt_corr + 1.
                     lv_count_corr = lv_cnt_corr.
                  ENDIF.
              ENDIF.
           CLEAR: ls_faglsplinfo_val,ls_splinfo_tmp.
          ENDIF.
      ENDLOOP.
    ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_buzei_bal
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_buzei_bal .
  CHECK gt_corr[] IS NOT INITIAL.
  TYPES:
    BEGIN OF ty_splinfo,
      belnr     TYPE belnr_d,
      gjahr     TYPE gjahr,
      bukrs     TYPE bukrs,
      buzei     TYPE buzei,
      spl_no    TYPE fagl_index,
      curtp     TYPE curtp,
      wrbtr     TYPE fins_vwcur12,
      wrbtr_new TYPE fins_vwcur12,
    END OF ty_splinfo.
  TYPES:
    BEGIN OF ty_acdoca,
      rbukrs TYPE acdoca-rbukrs,
      belnr  TYPE acdoca-belnr,
      gjahr  TYPE acdoca-gjahr,
      buzei  TYPE acdoca-buzei,
      ksl    TYPE acdoca-ksl,
      osl    TYPE acdoca-osl,
      vsl    TYPE acdoca-vsl,
      bsl    TYPE acdoca-bsl,
      csl    TYPE acdoca-csl,
      dsl    TYPE acdoca-dsl,
      esl    TYPE acdoca-esl,
      fsl    TYPE acdoca-fsl,
      gsl    TYPE acdoca-gsl,
    END OF ty_acdoca.
DATA:
  lt_acdoca_db      TYPE STANDARD TABLE OF ty_acdoca,
  ls_acdoca_db      TYPE ty_acdoca,
  lt_acdoca_build   TYPE STANDARD TABLE OF ty_acdoca,
  lt_zsplinfo_build TYPE STANDARD TABLE OF fagl_splinfo_val,
  ls_zsplinfo_build TYPE fagl_splinfo_val,
  lt_splinfo_val    TYPE TABLE OF fagl_splinfo_val.

DATA:
  ls_tmp_wrbtr  TYPE acbtr,
  ls_zsplinfo   TYPE fagl_splinfo_val,
  gs_corr_tmp   TYPE ty_corr,
  ls_wrbtr_diff TYPE acbtr,
  lv_wrbtr      TYPE acbtr,
  lv_spl_no     TYPE fagl_index,
  lv_curtp      TYPE curtp,
  ls_ksl_tmp    TYPE fins_vkcur12,
  ls_osl_tmp    TYPE fins_vocur12,
  ls_vsl_tmp    TYPE fins_vvcur12,
  ls_bsl_tmp    TYPE fins_vbcur12,
  ls_csl_tmp    TYPE fins_vccur12,
  ls_dsl_tmp    TYPE fins_vdcur12,
  ls_esl_tmp    TYPE fins_vecur12,
  ls_fsl_tmp    TYPE fins_vfcUR12,
  ls_gsl_tmp    TYPE fins_vgcUR12.

  SORT gt_corr BY belnr gjahr bukrs buzei spl_no curtp.
  LOOP AT gt_corr INTO gs_corr.
    REFRESH: lt_acdoca_db, lt_acdoca_build, lt_zsplinfo_build.
* Select from ACDOCA
    SELECT rbukrs gjahr
           belnr
           buzei
           ksl
           osl
           vsl
           bsl
           csl
           dsl
           esl
           fsl
           gsl
      FROM  acdoca INTO CORRESPONDING FIELDS OF TABLE lt_acdoca_db
      WHERE rldnr  = lv_leading_ledger
      AND   rbukrs = gs_corr-bukrs
      AND   gjahr  = gs_corr-gjahr
      AND   belnr  = gs_corr-belnr
      AND   buzei  = gs_corr-buzei.

**** Per buzei sum in gt_corr before update
      IF sy-subrc IS INITIAL.
        REFRESH lt_splinfo_val.
        CLEAR ls_tmp_wrbtr.
        SELECT * FROM fagl_splinfo_val INTO TABLE lt_splinfo_val
                  WHERE bukrs  = gs_corr-bukrs
                  AND   belnr  = gs_corr-belnr
                  AND   gjahr  = gs_corr-gjahr
                  AND   buzei  = gs_corr-buzei
                  AND   curtp  = gs_corr-curtp.
*        SORT gt_corr BY belnr gjahr bukrs buzei spl_no curtp.
*        LOOP AT gt_corr INTO gs_corr.
*          IF sy-subrc IS INITIAL.
            lv_spl_no =  gs_corr-spl_no.
            lv_curtp  =  gs_corr-curtp.
*          ENDIF.
          LOOP AT lt_splinfo_val INTO DATA(ls_splinfo_val).
            IF ls_splinfo_val-spl_no = gs_corr-spl_no.
              ls_tmp_wrbtr = gs_corr-new_wrbtr + ls_tmp_wrbtr.
            ELSE.
              ls_tmp_wrbtr = ls_splinfo_val-wrbtr + ls_tmp_wrbtr.
            ENDIF.
          ENDLOOP.
*          AT END OF buzei.
            gs_corr_tmp  = gs_corr.
            MOVE-CORRESPONDING  gs_corr_tmp TO ls_zsplinfo.
            ls_zsplinfo-spl_no = lv_spl_no.
            ls_zsplinfo-curtp  = lv_curtp.
            ls_zsplinfo-wrbtr  = ls_tmp_wrbtr.
            APPEND ls_zsplinfo TO lt_zsplinfo_build.
            CLEAR: ls_zsplinfo, ls_tmp_wrbtr.
*          ENDAT.
        CLEAR: gs_corr,ls_zsplinfo.
*        ENDLOOP.
      ENDIF.

* Per buzei sum for ACDOCA
    IF lt_zsplinfo_build[] IS NOT INITIAL.
      LOOP AT lt_acdoca_db INTO ls_acdoca_db.
        ls_ksl_tmp = ls_ksl_tmp + ls_acdoca_db-ksl.
        ls_osl_tmp = ls_osl_tmp + ls_acdoca_db-osl.
        ls_vsl_tmp = ls_vsl_tmp + ls_acdoca_db-vsl.
        ls_bsl_tmp = ls_bsl_tmp + ls_acdoca_db-bsl.
        ls_csl_tmp = ls_csl_tmp + ls_acdoca_db-csl.
        ls_dsl_tmp = ls_dsl_tmp + ls_acdoca_db-dsl.
        ls_esl_tmp = ls_esl_tmp + ls_acdoca_db-esl.
        ls_fsl_tmp = ls_fsl_tmp + ls_acdoca_db-fsl.
        ls_gsl_tmp = ls_gsl_tmp + ls_acdoca_db-gsl.
        AT END OF buzei.
          ls_acdoca_db-ksl = ls_ksl_tmp.
          ls_acdoca_db-osl = ls_osl_tmp.
          ls_acdoca_db-vsl = ls_vsl_tmp.
          ls_acdoca_db-bsl = ls_bsl_tmp.
          ls_acdoca_db-csl = ls_csl_tmp.
          ls_acdoca_db-dsl = ls_dsl_tmp.
          ls_acdoca_db-esl = ls_esl_tmp.
          ls_acdoca_db-fsl = ls_fsl_tmp.
          ls_acdoca_db-gsl = ls_gsl_tmp.
          APPEND ls_acdoca_db TO lt_acdoca_build.
          CLEAR: ls_acdoca_db,ls_ksl_tmp,ls_osl_tmp,ls_vsl_tmp,ls_bsl_tmp,
                              ls_csl_tmp,ls_dsl_tmp,ls_esl_tmp,ls_fsl_tmp,ls_gsl_tmp.
        ENDAT.
        CLEAR ls_acdoca_db.
      ENDLOOP.
    ENDIF.

* Compare difference amounts between ACDOCA and FAGL_SPLINFO_VAl per buzei
    CHECK lt_zsplinfo_build IS NOT INITIAL AND
          lt_acdoca_build IS NOT INITIAL.
    SORT lt_zsplinfo_build BY belnr gjahr bukrs buzei spl_no curtp.
    LOOP AT lt_zsplinfo_build INTO ls_zsplinfo_build.
       CLEAR: lv_spl_no,lv_curtp.
            lv_spl_no =  ls_zsplinfo_build-spl_no.
            lv_curtp  =  ls_zsplinfo_build-curtp.
            lv_wrbtr  =  ls_zsplinfo_build-wrbtr.
       AT NEW buzei.
        MOVE-CORRESPONDING ls_zsplinfo_build TO ls_zsplinfo.
        ls_zsplinfo-spl_no = lv_spl_no.
        ls_zsplinfo-curtp  = lv_curtp.
        ls_zsplinfo-wrbtr  = lv_wrbtr.
        READ TABLE lt_src_tgt_curr INTO ls_rule_to_fill_curr WITH KEY target_curtp = ls_zsplinfo-curtp.
        IF sy-subrc IS INITIAL AND ls_rule_to_fill_curr-target_curtp IS NOT INITIAL.
          READ TABLE lt_acdoca_build INTO ls_acdoca_db WITH KEY buzei = ls_zsplinfo-buzei.
          CASE ls_rule_to_fill_curr-target_fieldname.
            WHEN 'KSL'.
              IF ls_zsplinfo-wrbtr NE ls_acdoca_db-ksl.
                ls_wrbtr_diff = ls_acdoca_db-ksl - ls_zsplinfo-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'OSL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-osl.
                ls_wrbtr_diff = ls_acdoca_db-osl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'VSL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-vsl.
                ls_wrbtr_diff = ls_acdoca_db-vsl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'BSL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-bsl.
                ls_wrbtr_diff = ls_acdoca_db-bsl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'CSL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-csl.
                ls_wrbtr_diff = ls_acdoca_db-csl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'DSL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-dsl.
                ls_wrbtr_diff = ls_acdoca_db-dsl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'ESL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-esl.
                ls_wrbtr_diff = ls_acdoca_db-esl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'FSL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-fsl.
                ls_wrbtr_diff  = ls_acdoca_db-fsl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
            WHEN 'GSL'.
              IF ls_zsplinfo_build-wrbtr NE ls_acdoca_db-gsl.
                ls_wrbtr_diff = ls_acdoca_db-gsl - ls_zsplinfo_build-wrbtr.
                READ TABLE gt_corr INTO gs_corr WITH KEY belnr  = ls_zsplinfo-belnr
                                                         gjahr  = ls_zsplinfo-gjahr
                                                         bukrs  = ls_zsplinfo-bukrs
                                                         buzei  = ls_zsplinfo-buzei
                                                         spl_no = ls_zsplinfo-spl_no
                                                         curtp  = ls_zsplinfo-curtp.
                 gs_corr-new_wrbtr = gs_corr-new_wrbtr + ls_wrbtr_diff.
                 MODIFY gt_corr FROM gs_corr INDEX sy-tabix TRANSPORTING new_wrbtr.
                 CLEAR: gs_corr,ls_wrbtr_diff,ls_zsplinfo,ls_acdoca_db,ls_zsplinfo_build.
              ENDIF.
          ENDCASE.
        ENDIF.
       ENDAT.
    ENDLOOP.
    ENDLOOP.

ENDFORM.
