@AbapCatalog.sqlViewName: 'ZI_SALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Actual amount'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SALES_ACTUAL_AMT as select from 
     I_SalesDocumentItemAnalytics  
//  (P_ExchangeRateType:$parameters.P_ExchangeRateType, P_DisplayCurrency: $parameters.P_DisplayCurrency) 
  as item
  left outer to one join I_CalendarDate                                                                                                                    
as CalendarDate           on item.CreationDate = CalendarDate.CalendarDate
 left outer to one join I_CalendarDate                                                                                                                    
as CalendarDateSalesOrder on item.SalesDocumentDate = CalendarDateSalesOrder.CalendarDate
  
  association [1..1] to I_SalesOrder             as _SalesOrder                on  $projection.SalesOrder = _SalesOrder.SalesOrder
  association[1..1] to  ZI_LATEST_EXCHANGE_RATE1 as  exchange on $projection.TransactionCurrency = exchange.SourceCurrency 
  and TargetCurrency = 'INR'
    and exchange.ExchangeRateType = 'B'
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
 
      @ObjectModel.foreignKey.association: '_TransactionCurrency'
  item.TransactionCurrency,
  item._TransactionCurrency,
   @Semantics.amount.currencyCode: 'vbrp.waerk'
   
//   sum(NetAmountInDisplayCurrency)  as SalesActualAmount

case 
    when TransactionCurrency = 'USD'
        then item.TotalNetAmount
    else
        case 
            when exchange.ExchangeRate is not initial
                then item.TotalNetAmount * exchange.ExchangeRate
            else
                item.TotalNetAmount
        end
end as SalesActualAmount,
exchange.ExchangeRate
}
//where displaycurrency = 'INR'
where item.SalesOrganization = '1000'
