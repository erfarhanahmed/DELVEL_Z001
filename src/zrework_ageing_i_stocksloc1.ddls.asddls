//@AbapCatalog.sqlViewName: 'ZRVSTOLOC'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Rework Ageing interface view for StockPerSloc'
//@Metadata.ignorePropagatedAnnotations: true


@AbapCatalog.sqlViewName: 'ZRVSTOLOC'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '''ZI_STK_SLOC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZREWORK_AGEING_I_StockSloc1 
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
