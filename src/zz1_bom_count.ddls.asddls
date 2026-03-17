@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Count'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

//@AbapCatalog.sqlViewName: 'ZBOM_COUNT'
//@AbapCatalog.compiler.compareFilter: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'BOM COUNT'
//@VDM.viewType: #BASIC
//@Analytics.dataCategory: #DIMENSION
//@Metadata.allowExtensions: true
//@Metadata.ignorePropagatedAnnotations: true

define view entity ZZ1_BOM_COUNT as select distinct from ZZ1_BOM_COUNT_RECORDS as agg 
//define view  ZZ1_BOM_COUNT as select from ZZ1_OrderStatus1 as os 
 inner join ZZ1_OrderStatus1 as os on  agg.Plant = os.Plant_1  and
                                           agg.BillOfMaterial = os.BillOfMaterial 
 
{
//          key os.SalesOrder,
//           key os.SalesOrderItem,
           key agg.Plant,
           key agg.BillOfMaterial,
                  os.SalesOrder,
                  os.SalesOrderItem,
              agg.totalbomcount,
           os.SalesOrderItemText,
           os.Division,
           os.Plant_1,
             @Semantics.amount.currencyCode: 'TransactionCurrency'
           os.NetAmount,
           os.TransactionCurrency,
            @Semantics.quantity.unitOfMeasure: 'NetPriceQuantityUnit'
           os.TargetQuantity,
           os.NetPriceQuantityUnit,
           os.BillOfMaterialVariant,
//           os.BillOfMaterial,
//           os.Plant,
           os.Material,
           os.BillOfMaterialVariantUsage,
           os.BillOfMaterialStatus,
           os.ZBRAND,
           os.bom,
           os.TargetQuantityUnit,
           os.TransactionCurrency_1,
           os.SoldToParty,
           os.SoldToParty_1,
           os.CreationDate,
           os.BillingDocumentDate,
              os./SAP/1_SALESORDER,
    /* Associations */
    os./SAP/1__SALESORDER,
    os._Division,
    os._NetPriceQuantityUnit,
    os._Plant,
    os._SalesOrder,
    os._SoldToParty,
    os._SoldToParty_1,
    os._SoldToParty_2,
    os._TargetQuantityUnit,
    os._TransactionCurrency,
    os._TransactionCurrency_1


        

}

