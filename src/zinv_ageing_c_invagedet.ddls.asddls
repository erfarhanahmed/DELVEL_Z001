@AbapCatalog.sqlViewName: 'ZV_CINVAGEDET'
@EndUserText.label: 'Inventory Ageing Details (UR & SO allocations)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@OData.publish: true
@Analytics.dataCategory: #FACT
define view ZINV_AGEING_C_INVAGEDET
  with parameters
      @Environment.systemField: #CLIENT   // <-- system fills current client
    p_client : abap.clnt,
    p_bukrs : bukrs,
    p_werks : werks_d,
    p_lgort : lgort_d
  as select from ZINV_AGEING_TF_INVAGEDET(
                 P_CLIENT:$parameters.p_client,
                 P_BUKRS: $parameters.p_bukrs,
                 P_WERKS: $parameters.p_werks,
                 P_LGORT: $parameters.p_lgort
                 ) as A

  association [0..1] to I_ProductText              as _Text   on  _Text.Product  = A.matnr
                                                              and _Text.Language = $session.system_language
  association [0..1] to I_Product                  as _Prod   on  _Prod.Product = A.matnr
  association [0..1] to ZINV_AGEING_I_MvmtTypeText as _MvtTxt on  _MvtTxt.bwart = A.bwart
{
  key     A.matnr           as Product,
  key     _Text.ProductName as ProductDescription,
  key     _Prod.BaseUnit    as BaseUnit,
  key     A.mblnr           as MaterialDocument,
  key     A.zeile           as MaterialDocumentItem,
          A.mjahr           as MaterialDocumentYear,
          A.werks           as Plant,
          A.lgort           as StorageLocation,
          A.bwart           as MovementType,
          A.budat           as PostingDate,
          A.age_days        as AgeDays,
          A.alloc_cat       as AllocationCategory,
          A.quantity        as quantity, // original movement qty
          A.alloc_qty       as AllocatedQty,
          A.ur_alloc_qty    as AllocURQTY, // UR Alloced QTY
          A.so_alloc_qty    as AllocSOQTY, // SO Alloced QTY
          A.ur_amount       as URAmount,
          A.so_amount       as SOAmount,
          A.rate_used       as RateUsed,
          A.alloc_amount    as AllocatedAmount,
          A.documentdate    as documentdate,
          A.usacode         as usacode,
          A.sales_order     as salesorder,
          A.sales_item      as salesitem,
          _MvtTxt.btext     as MovementText
}
--where
--  A.alloc_qty > 0;
