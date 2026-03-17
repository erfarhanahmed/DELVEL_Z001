READ TABLE gt_mkpf INTO wa_mkpf INDEX 1.
READ TABLE gt_ekpo INTO wa_ekpo1 INDEX 1.
READ TABLE lt_afpo INTO wa_afpo INDEX 1.


SELECT SINGLE BSTKD_E INTO gv_BSTKD_E
    FROM VBKD WHERE VBELN = wa_afpo-kdauf
  AND POSNR = wa_afpo-kdpos.






















