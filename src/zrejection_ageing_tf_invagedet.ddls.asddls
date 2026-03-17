@EndUserText.label: 'Inventory Ageing Detail'
define table function ZREJECTION_AGEING_TF_INVAGEDET
  with parameters
    @Environment.systemField: #CLIENT // <<< REQUIRED
    P_CLIENT : abap.clnt,
    P_BUKRS  : bukrs,
    P_WERKS  : werks_d,
    P_LGORT  : lgort_d
returns
{
  clnt         : abap.clnt;
  mblnr        : abap.numc(10);
  mjahr        : abap.numc(4);
  zeile        : abap.numc(6);
  bwart        : abap.char(3);
  matnr        : matnr;
  werks        : werks_d;
  lgort        : lgort_d;
  lifnr        : lifnr;
  budat        : budat;
  documentdate : budat;
  age_days     : abap.int4;
  alloc_cat    : abap.char(2);
  quantity     : abap.dec(15,3);
  alloc_qty    : abap.dec(15,3);
  alloc_amount : abap.dec(23,2);
  rate_used    : abap.dec(23,6);
  ur_alloc_qty : abap.dec(15,3);
  so_alloc_qty : abap.dec(15,3);
  ur_amount    : abap.dec(23,2);
  so_amount    : abap.dec(23,2);
  usacode      : abap.char(48);
}
implemented by method
  ZCL_REJECTION_AGEING_REPORT=>GET_DATA;
