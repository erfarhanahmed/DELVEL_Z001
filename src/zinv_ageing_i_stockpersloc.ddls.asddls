@AbapCatalog.sqlViewName: 'ZV_STOCKPERSLOC'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '''ZI_STK_SLOC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZINV_AGEING_I_StockPerSloc
  as select from mard
{
  key matnr         as Material,
  key werks         as Plant,
  key lgort         as StorageLocation,
      labst + insme as StockURQI
}

where
     labst is not null
  or insme is not null;
