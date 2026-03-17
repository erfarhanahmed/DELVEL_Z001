@AbapCatalog.sqlViewName: 'ZSUPPMATDOC_SQL'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view ZV_SUPP_MATDOC
  with parameters
       @Environment.systemField: #CLIENT   // <-- system fills current client
    p_client : abap.clnt,
    p_ekgrp_str : char100,-- Use same fixed length
    p_date_low  : datum,
    p_date_high : datum,
      p_lifnr_str : char100, -- New for Multiple Suppliers
    p_werks_str : char100,  -- New for Multiple Plants
    p_bukrs_str : char100   -- New for Multiple Company Codes
as select from ZTF_SUPP_MATDOC( 
    p_client    : $parameters.p_client,
    p_ekgrp_str : $parameters.p_ekgrp_str, -- Correct way to pass param
    P_DATE_LOW  : $parameters.p_date_low,
    P_DATE_HIGH : $parameters.p_date_high ,
      p_lifnr_str : $parameters.p_lifnr_str,-- New for Multiple Suppliers
    p_werks_str : $parameters.p_werks_str  ,-- New for Multiple Plants
    p_bukrs_str : $parameters.p_bukrs_str   -- New for Multiple Company Codes
)
{
  key mandt,
  key supplier,
  key materialdocument,
  key materialdocumentitem,
 key purchaseorder,
 key  purchaseorderitem,
  goodsmovementtype,
  material,
  plant,
  postingdate,
  @Semantics.quantity.unitOfMeasure: 'vbrp.meins'
  quantityinbaseunit,
  purchasinggroup,
  infnr,
  urzzt,
 taxnumber,
 bukrs,
 lfbnr
}
