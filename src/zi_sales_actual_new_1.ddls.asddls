@AbapCatalog.sqlViewName: 'ZACTUAL_NEW1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Actual View'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALES_ACTUAL_NEW_1    as select from   I_SalesDocumentItemAnalytics  
//  (P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency) 
  as item
  left outer to one join I_CalendarDate                                                                                                                    
as CalendarDate           on item.CreationDate = CalendarDate.CalendarDate
 left outer to one join I_CalendarDate                                                                                                                    
as CalendarDateSalesOrder on item.SalesDocumentDate = CalendarDateSalesOrder.CalendarDate
  
  association [1..1] to I_SalesOrder             as _SalesOrder                on  $projection.SalesOrder = _SalesOrder.SalesOrder
{
  key item.SalesOffice,
  key cast( SalesDocument as vdm_sales_order preserving type )                         as SalesOrder,
      _SalesOrder,
      @Semantics.calendar.year
      cast(CalendarDateSalesOrder.CalendarYear as sales_order_date_year)                    as SalesOrderDateYear,
      @Semantics.calendar.yearQuarter
      cast(CalendarDateSalesOrder.YearQuarter as sales_order_date_year_quarter)             as SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      cast(CalendarDateSalesOrder.YearMonth as sales_order_date_year_month)                 as SalesOrderDateYearMonth,

//   key DisplayCurrency,
 
   @Semantics.amount.currencyCode: 'vbrp.waerk'
   
//   sum(NetAmountInDisplayCurrency)  as SalesActualAmount

     item.TotalNetAmount * item.PriceDetnExchangeRate as SalesActualamount
}
//where displaycurrency = 'INR'
where item.SalesOrganization = '1000' 
and SalesOffice = 'PN' and SalesOffice = 'MB' and
    SalesOffice = 'AH' and SalesOffice = 'KO' and 
    SalesOffice = 'CH' and SalesOffice = 'HD'

//group by SalesOffice,
//         
//       cast( CalendarDateSalesOrder.YearMonth
//        as sales_order_date_year_month )
//   SalesOrderDateYearMonth,
//  SalesOrderDateYearQuarter
// DisplayCurrency
