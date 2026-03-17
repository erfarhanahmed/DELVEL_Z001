@AbapCatalog.sqlViewName: 'ZV_RSTOCKPERSLOC'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '''ZI_STK_SLOC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZREJECTION_AGEING_I_StockSloc
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
