"Name: \PR:SAPMV45A\FO:USEREXIT_MOVE_FIELD_TO_VBAP\SE:BEGIN\EI
ENHANCEMENT 0 ZVA02_N.

if sy-tcode = 'ZVA02'.
data : begin of i_tab occurs 0,
       vbeln like vbap-vbeln,
       posnr like vbap-posnr,
       matnr like vbap-matnr,
       menge like vbap-ZMENG,
       ARKTX like vbap-ARKTX,
       kdmat like vbap-kdmat,
       f_date(10) type c,
       n_pric like vbap-NETWR,
       ofm_srno(2) type n,      "Should confirm
       BSTKD like vbkd-BSTKD,
       NTGEW like vbap-NTGEW,
       BRGEW like vbap-BRGEW,
       ZINS_LOC like vbap-ZINS_LOC,
       del_dt(10) type c,
       cust_dl_dt(10) type c,
       ofm_dl_dt(10)  type c,
       tr_mrp_dt(10)  type c,
       exp_mrp_dt(10) type c,
       gd_r(1)        type c,
       remark(50) type c,
 end of i_tab.
data : wa_tab like i_tab.
Data : wa_vbap_N type VBAP.


IMPORT I_TAB FROM MEMORY ID 'I_TAB'.
read table i_tab into wa_tab
              with key vbeln = vbap-vbeln
                       posnr = vbap-posnr.
if sy-subrc eq 0.
   concatenate WA_TAB-DEL_DT+6(4) WA_TAB-DEL_DT+3(2)
               WA_TAB-DEL_DT+0(2) into  vbap-DELDATE.
   concatenate WA_TAB-CUST_DL_DT+6(4) WA_TAB-CUST_DL_DT+3(2)
               WA_TAB-CUST_DL_DT+0(2) into  vbap-CUSTDELDATE.
   concatenate WA_TAB-TR_MRP_DT+6(4) WA_TAB-TR_MRP_DT+3(2)
               WA_TAB-TR_MRP_DT+0(2) into  vbap-ZMRP_DATE.
   concatenate WA_TAB-exp_mrp_dt+6(4) WA_TAB-exp_mrp_dt+3(2)
               WA_TAB-exp_mrp_dt+0(2) into  vbap-ZEXP_MRP_DATE1.
   concatenate WA_TAB-ofm_dl_dt+6(4) WA_TAB-ofm_dl_dt+3(2)
               WA_TAB-ofm_dl_dt+0(2) into  vbap-OFM_DATE.

*   concatenate WA_TAB-cd_rc_dt+6(4) WA_TAB-cd_rc_dt+3(2)
*               WA_TAB-cd_rc_dt+0(2) into  vbap-RECEIPT_DATE.

 move : wa_tab-zins_loc to vbap-zins_loc,
        wa_tab-gd_r     to vbap-ZGAD.
endif.
elseif sy-tcode = 'ZVA02_1'.
data : begin of i_exp occurs 0,
       vbeln like vbap-vbeln,
       posnr like vbap-posnr,
       cd_rc_dt(10) type c,
       end of i_exp.
data : wa_exp like i_exp.
refresh i_exp[].
clear : wa_exp.
IMPORT I_EXP FROM MEMORY ID 'I_EXP'.
read table i_exp into wa_exp
              with key vbeln = vbap-vbeln
                       posnr = vbap-posnr.
if sy-subrc eq 0.
concatenate WA_EXP-cd_rc_dt+6(4) WA_EXP-cd_rc_dt+3(2)
            WA_EXP-cd_rc_dt+0(2) into  vbap-RECEIPT_DATE.
endif.
elseif sy-tcode = 'ZVA02_2'.
data : begin of i_exp1 occurs 0,
       vbeln like vbap-vbeln,
       posnr like vbap-posnr,
       del_dt(10) type c,
       end of i_exp1.
data : wa_exp1 like i_exp1.
clear : wa_exp1.
IMPORT I_EXP1 FROM MEMORY ID 'I_EXP1'.
read table i_exp1 into wa_exp1
              with key vbeln = vbap-vbeln
                       posnr = vbap-posnr.
if sy-subrc eq 0.
concatenate wa_exp1-del_dt+6(4) wa_exp1-del_dt+3(2)
            wa_exp1-del_dt+0(2) into  vbap-DELDATE.
endif.
endif.
ENDENHANCEMENT.
