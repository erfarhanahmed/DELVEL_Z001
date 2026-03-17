REPORT Z_CLEAR_KSL_ON_OPEN_ITEMS.

CONSTANTS:
  GC_INITIAL_ACDOCA TYPE ACDOCA VALUE IS INITIAL.
SELECT-OPTIONS:
  P_BUKRS FOR GC_INITIAL_ACDOCA-RBUKRS,
  S_belnr FOR GC_INITIAL_ACDOCA-BELNR.
PARAMETERS:
  P_GJAHR TYPE  ACDOCA-GJAHR,
  P_TEST AS CHECKBOX DEFAULT 'X'.

START-OF-SELECTION.
  PERFORM MAIN.

FORM MAIN.

  DATA:
    LT_BASE_PACKAGE      TYPE CL_FINS_NEW_CURR_UTIL=>GTYT_PACKAGE,
    LS_RULE_TO_FILL_CURR TYPE CL_FINS_NEW_CURR_UTIL=>GTYS_RULE_TO_FILL_CURR,
    LV_BUKRS             TYPE BKPF-BUKRS.
  FIELD-SYMBOLS:
    <LS_BASE_PACKAGE> LIKE LINE OF LT_BASE_PACKAGE.

  LT_BASE_PACKAGE = CL_FINS_NEW_CURR_KSL_UTIL=>GET_BASE_PACKAGES( ).

  SELECT BUKRS INTO LV_BUKRS FROM T001 WHERE BUKRS IN P_BUKRS.
    WRITE: / 'Company Code:', LV_BUKRS.
    LOOP AT LT_BASE_PACKAGE ASSIGNING <LS_BASE_PACKAGE> WHERE PACKAGE_KEY-BUKRS = LV_BUKRS.
      LS_RULE_TO_FILL_CURR = CL_FINS_NEW_CURR_KSL_UTIL=>GET_INSTANCE( )->GET_RULE_TO_FILL_CURR(
                                 IV_BUKRS = <LS_BASE_PACKAGE>-PACKAGE_KEY-BUKRS
                                 IV_RLDNR = <LS_BASE_PACKAGE>-PACKAGE_KEY-RLDNR
                                 IV_CURTP = <LS_BASE_PACKAGE>-PACKAGE_KEY-CURTP ).
      CHECK LS_RULE_TO_FILL_CURR-TARGET_FIELDNAME = 'KSL'.
      WRITE: /5 'Ledger:', <LS_BASE_PACKAGE>-PACKAGE_KEY-RLDNR.
      SELECT COUNT(*) FROM ACDOCA  ##DB_FEATURE_MODE[TABLE_LEN_MAX1]
        WHERE RBUKRS =  <LS_BASE_PACKAGE>-PACKAGE_KEY-BUKRS
        AND   RLDNR  =  <LS_BASE_PACKAGE>-PACKAGE_KEY-RLDNR
          and belnr in S_belnr
        and  GJAHR = p_GJAHR
*        AND   xopvw  =  abap_true
*        AND   xsplitmod = abap_true
*        AND   mig_source = 'G'
        AND CBTTYPE = 'RFBC'.
*        AND   vrgng  =  gc_initial_acdoca-vrgng
*        AND   kalnr  =  gc_initial_acdoca-kalnr.
      WRITE: /10 'Selected:', SY-DBCNT.
      CHECK SY-DBCNT > 0.
      CHECK P_TEST = ABAP_FALSE.
      SELECT *
              FROM ACDOCA
              INTO TABLE @DATA(LT_ACDOCA)
              WHERE RBUKRS =  @<LS_BASE_PACKAGE>-PACKAGE_KEY-BUKRS
        and belnr in @S_belnr
        and  GJAHR = @p_GJAHR
        AND   RLDNR  =  @<LS_BASE_PACKAGE>-PACKAGE_KEY-RLDNR
        AND CBTTYPE = 'RFBC'.

      LOOP AT LT_ACDOCA INTO DATA(LS_ACDOCA).
      UPDATE ACDOCA SET KSL = LS_ACDOCA-HSL  ##DB_FEATURE_MODE[TABLE_LEN_MAX1]
       WHERE RBUKRS =  LS_ACDOCA-RBUKRS
       AND   RLDNR  =  LS_ACDOCA-RLDNR
       and  GJAHR   =  LS_ACDOCA-GJAHR
       and  BELNR   =  LS_ACDOCA-BELNR
       and DOCLN    = LS_ACDOCA-DOCLN.
        CLEAR : LS_ACDOCA.
      ENDLOOP.
*      UPDATE acdoca SET ksl = 0  ##DB_FEATURE_MODE[TABLE_LEN_MAX1]
*        WHERE rbukrs =  <ls_base_package>-package_key-bukrs
*        AND   rldnr  =  <ls_base_package>-package_key-rldnr
*        AND   xopvw  =  abap_true
*        AND   xsplitmod = abap_true
*        AND   mig_source = 'G'
*        AND   vrgng  =  gc_initial_acdoca-vrgng
*        AND   kalnr  =  gc_initial_acdoca-kalnr.
      WRITE: /10 'Updated :', SY-DBCNT.
    ENDLOOP.
    CHECK SY-SUBRC <> 0.
    WRITE: '- Not relevant'.
  ENDSELECT.

ENDFORM.
