
@AbapCatalog.sqlViewName: 'ZTEST12'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZTEST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ztest 
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
