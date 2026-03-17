@EndUserText.label: 'Supplier Material Document Data'
define table function ZTF_SUPP_MATDOC
  with parameters
    @Environment.systemField: #CLIENT
    p_client : abap.clnt,
//    P_EKGRP      : ekgrp,
//      P_EKGRP     : abap.string,
      p_ekgrp_str:char100,
    P_DATE_LOW   : datum,
    P_DATE_HIGH  : datum,
        p_lifnr_str : char100, -- New for Multiple Suppliers
    p_werks_str : char100,  -- New for Multiple Plants
    p_bukrs_str : char100   -- New for Multiple Company Codes

    

returns
{
 key mandt                 : abap.clnt;
 key  supplier              : lifnr;
 key  materialdocument      : mblnr;
 key  materialdocumentitem  : mblpo;
  key purchaseorder         : ebeln;
  key purchaseorderitem     : ebelp;
  goodsmovementtype     : bwart;
  material              : matnr;
  plant                 : werks_d;
  postingdate           : budat;
  quantityinbaseunit    : menge_d;
  purchasinggroup       : ekgrp;
  infnr                 : infnr;
  urzzt                 : urzzt;
  taxnumber   :bptaxnum;
  bukrs:bukrs;
  lfbnr :lfbnr;
}
implemented by method
  ZCL_AMDP_SUPP_DOC=>GET_DATA;
