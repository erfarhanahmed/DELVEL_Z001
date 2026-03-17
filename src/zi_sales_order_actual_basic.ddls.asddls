@AbapCatalog.sqlViewName: 'ZACTUAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Actual View'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALES_ORDER_ACTUAL_BASIC 
//with parameters
//    P_ExchangeRateType : kurst,
//    P_DisplayCurrency  : vdm_v_display_currency
//    as select from   I_SalesDocumentItemAnalytics  
//  (P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency) 
//  as item
//  left outer to one join I_CalendarDate                                                                                                                    
//as CalendarDate           on item.CreationDate = CalendarDate.CalendarDate
// left outer to one join I_CalendarDate                                                                                                                    
//as CalendarDateSalesOrder on item.SalesDocumentDate = CalendarDateSalesOrder.CalendarDate
//  
//  association [1..1] to I_SalesOrder             as _SalesOrder                on  $projection.SalesOrder = _SalesOrder.SalesOrder
as select from ZI_SALES_ACTUAL_NEW 
{
  key SalesOffice,
//  key  SalesOrder,
      @Semantics.calendar.year
       SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
       SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      SalesOrderDateYearMonth,

//   key DisplayCurrency,
 
   @Semantics.amount.currencyCode: 'vbrp.waerk'
   
//   sum(NetAmountInDisplayCurrency)  as SalesActualAmount
  @DefaultAggregation: #SUM
    sum(SalesActualAmount)  as SalesActualAmount
}
//where displaycurrency = 'INR'


group by SalesOffice,
         
      SalesOrderDateYear,
   SalesOrderDateYearMonth,
  SalesOrderDateYearQuarter
// DisplayCurrency
