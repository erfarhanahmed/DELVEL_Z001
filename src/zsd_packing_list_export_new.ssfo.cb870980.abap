DATA: lv_adrnr TYPE ad_addrnum.
DATA: ls_adr TYPE ty_adr.

REFRESH gt_adr.
CLEAR v_flag .
SELECT SINGLE adrnr FROM kna1 INTO lv_adrnr
  WHERE kunnr = is_dlv_delnote-hd_gen-sold_to_party.

IF sy-subrc IS INITIAL
    AND l_kunnr NE is_dlv_delnote-hd_gen-sold_to_party.

  v_flag = 'X'.
  SELECT SINGLE *
    FROM adrc
    INTO gs_ku_adrc
    WHERE addrnumber = lv_adrnr.

  SELECT SINGLE * FROM t005u INTO gs_ku_t005u
    WHERE spras = sy-langu
      AND land1 = gs_ku_adrc-country
      AND bland = gs_ku_adrc-region.

  SELECT SINGLE landx FROM t005t INTO gv_ku_landx
    WHERE spras = sy-langu
      AND land1 = gs_ku_adrc-country.

  CLEAR ls_adr-line.
  ls_adr-line = gs_ku_adrc-name1.
  APPEND ls_adr TO gt_adr.

  IF gs_ku_adrc-str_suppl1 IS NOT INITIAL.
    CLEAR ls_adr-line.
    ls_adr-line = gs_ku_adrc-str_suppl1.
    APPEND ls_adr TO gt_adr.
  ENDIF.

  IF gs_ku_adrc-str_suppl2 IS NOT INITIAL.
    CLEAR ls_adr-line.
    ls_adr-line = gs_ku_adrc-str_suppl2.
    APPEND ls_adr TO gt_adr.
  ENDIF.

  IF gs_ku_adrc-street IS NOT INITIAL.
    CLEAR ls_adr-line.
    ls_adr-line = gs_ku_adrc-street.
    APPEND ls_adr TO gt_adr.
  ENDIF.

  IF gs_ku_adrc-str_suppl3 IS NOT INITIAL.
    CLEAR ls_adr-line.
    ls_adr-line = gs_ku_adrc-str_suppl3.
    APPEND ls_adr TO gt_adr.
  ENDIF.
  IF gs_ku_adrc-location IS NOT INITIAL.
    CLEAR ls_adr-line.
    ls_adr-line = gs_ku_adrc-location.
    APPEND ls_adr TO gt_adr.
  ENDIF.
  IF gs_ku_adrc-city2 IS NOT INITIAL.
    CLEAR ls_adr-line.
    CONCATENATE 'District' gs_ku_adrc-city2
      INTO ls_adr-line SEPARATED BY space.
    APPEND ls_adr TO gt_adr.
  ENDIF.

  CLEAR ls_adr-line.

  CONCATENATE gs_ku_adrc-city1 gs_ku_adrc-post_code1
    gs_ku_t005u-bezei gv_ku_landx
    INTO ls_adr-line SEPARATED BY space.
  APPEND ls_adr TO gt_adr.

  CLEAR ls_adr-line.
  CONCATENATE 'Tel :' gs_ku_adrc-tel_number
              'Fax :' gs_ku_adrc-fax_number
    INTO ls_adr-line SEPARATED BY space.
  APPEND ls_adr TO gt_adr.

ENDIF.












