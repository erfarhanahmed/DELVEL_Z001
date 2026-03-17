*BREAK primus.
DATA gv_category TYPE vbap-zmono.
CLEAR gv_category.
SELECT SINGLE zmono INTO gv_category
  FROM vbap
  WHERE vbeln = wa_afpo-kdauf
    AND posnr = wa_afpo-kdpos.


CASE gv_category.
  WHEN '1'.
    gv_cat_txt = '(MONOGRAMMED)' .
  WHEN '2'.
    gv_cat_txt = '(MONOGRAMMABLE)'.
  WHEN '3'.
    gv_cat_txt =  '(NON-MONOGRAMMABLE)'.
ENDCASE.


CLEAR:ibr,ul,sil,ce,api6d,api6,atex,trcu,crn,marine,wa_vbap.
SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE vbeln = wa_afpo-kdauf
    AND posnr = wa_afpo-kdpos.

IF wa_vbap-zibr = 'X'.
  ibr = 'IBR'.
ENDIF.

IF wa_vbap-zul = 'X'.
  ul = 'UL'.
ENDIF.

IF wa_vbap-zsl = 'X'.
  sil = 'SIL3'.
ENDIF.

IF wa_vbap-zce = 'X'.
  ce = 'CE'.
ENDIF.

IF wa_vbap-zapi6d = 'X'.
  api6d = 'API 6D'.
ENDIF.

IF wa_vbap-zapi60 = 'X'.
  api6 = 'API 609'.
ENDIF.

IF wa_vbap-zatex = 'X'.
  atex = 'ATEX'.
ENDIF.

IF wa_vbap-ztrcu = 'X'.
  trcu = 'TRCU'.
ENDIF.

IF wa_vbap-zcrn = 'X'.
  crn = 'CRN'.
ENDIF.

IF wa_vbap-zmarine = 'X'.
  marine = 'MARINE Apllication'.
ENDIF.

















