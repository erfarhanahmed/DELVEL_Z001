//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Bom count composit'
//@Metadata.ignorePropagatedAnnotations: true

@AbapCatalog.sqlViewName: 'ZBOM_COUNT2'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sale order consuption'
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view ZZ1_BOM_COUNT_COMP as select from ZZ1_BOM_COUNT_BASIC
{
      key SalesOrder,
      key SalesOrderItem,
@DefaultAggregation: #SUM
     totalbomcount ,
      SalesOrderItemText,
      Division,
      Plant_1,
      @Aggregation.default: #SUM
      NetAmount,
      TransactionCurrency,
      TargetQuantity,
      NetPriceQuantityUnit,
      BillOfMaterialVariant,
      BillOfMaterial,
      Plant,
      Material,
      BillOfMaterialVariantUsage,
      BillOfMaterialStatus,
      ZBRAND,
      bom,
      TargetQuantityUnit,
      TransactionCurrency_1,
      SoldToParty,
      SoldToParty_1,
      CreationDate,
      BillingDocumentDate,
        /SAP/1_SALESORDER,
    /* Associations */
    /SAP/1__SALESORDER,
    _Division,
    _NetPriceQuantityUnit,
   _Plant,
   _SalesOrder,
    _SoldToParty,
    _SoldToParty_1,
    _SoldToParty_2,
    _TargetQuantityUnit,
    _TransactionCurrency,
    _TransactionCurrency_1  
}
