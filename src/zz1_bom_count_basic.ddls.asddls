//@AbapCatalog.sqlViewName: 'ZBOM_COUNT1'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Bom count basic'
//@Metadata.ignorePropagatedAnnotations: true

@AbapCatalog.sqlViewName: 'ZBOM_COUNT1'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM count'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@Metadata.allowExtensions: true 
@Metadata.ignorePropagatedAnnotations: true

define view ZZ1_BOM_COUNT_BASIC as select from ZZ1_BOM_COUNT
{
        key SalesOrder,
        key SalesOrderItem,

          totalbomcount,
        SalesOrderItemText,
        Division,
        Plant_1,
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
