@AbapCatalog.sqlViewName: 'ZCTBG_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CTBG DETAILS'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_CTBG
with parameters
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency
//    P_CurrentDate      : abap.dats
     as select from 
I_SalesOrderItemCube(P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency) 
  
{
    key SalesOrder,
    key SalesOrderItem,
    key Product,
    SalesOffice,
    SalesOrderType,
    SalesOrderItemCategory,
    SalesOrderDate,
     BillingDocumentDate,
//     dats_days_between( SalesOrderDate,:P_CurrentDate ) as DaysFromSalesOrder,
     dats_days_between( SalesOrderDate, cast($session.system_date as abap.dats) ) as DaysFromSalesOrder,
           @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      OrderQuantity,
        @Semantics.unitOfMeasure: true      
      OrderQuantityUnit,
@Semantics.amount.currencyCode: 'vbap.waerk'
      NetAmount_2,

@Semantics.currencyCode: true
cast( 'INR' as abap.cuky ) as DisplayCurrency,
      @Semantics.currencyCode: true
//      @ObjectModel.foreignKey.association: '_TransactionCurrency'
      TransactionCurrency
}
where Product like 'CTBG%'
