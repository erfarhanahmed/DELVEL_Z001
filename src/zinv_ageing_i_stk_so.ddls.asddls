@AbapCatalog.sqlViewName: 'ZAGEING_V_STK_SO'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_STK_SO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZINV_AGEING_I_STK_SO
  as select from mska
{
  key matnr         as Material,
  key werks         as Plant,
  key lgort         as StorageLocation,
      kalab + kains as StockSO

}
where
  sobkz = 'E';
