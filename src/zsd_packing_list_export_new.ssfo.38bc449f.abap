DATA: l_werks   TYPE werks_d,
      l_adrnr   TYPE adrnr,
      l_country TYPE land1,
      l_fkimg   TYPE fkimg.

SELECT SINGLE werks INTO l_werks
  FROM lips
  WHERE vbeln = is_dlv_delnote-hd_gen-deliv_numb.

IF sy-subrc = 0.
  SELECT SINGLE adrnr INTO l_adrnr
    FROM t001w
    WHERE werks = l_werks.
  IF sy-subrc = 0.
    SELECT SINGLE * FROM adrc INTO gs_pl_adrc
        WHERE addrnumber = l_adrnr.

    IF sy-subrc = 0.
      SELECT SINGLE landx FROM t005t INTO gv_pl_landx
      WHERE land1 = gs_pl_adrc-country
        AND spras = 'EN'.

      SELECT SINGLE * FROM t005u INTO gs_pl_t005u
        WHERE spras = sy-langu
          AND land1 = gs_pl_adrc-country
          AND bland = gs_pl_adrc-region.

      SELECT SINGLE * FROM adrct
        INTO gs_pl_adrct
        WHERE addrnumber = l_adrnr.

    ENDIF.
    gv_gst_p = '27AACCD2898L1Z4'.
    SELECT SINGLE j_1iexcd FROM j_1imocomp INTO gv_pl_1iexcd
        WHERE werks = l_werks.

  ENDIF.
ENDIF.














