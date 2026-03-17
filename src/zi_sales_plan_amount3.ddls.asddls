@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Plan Amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SALES_PLAN_AMOUNT3 as select from  ZI_SALES_PLAN_AMOUNT as a
association[1..1] to  ZI_LATEST_EXCHANGE_RATE1 as  exchange on exchange.SourceCurrency = 'USD'
  and exchange.TargetCurrency = 'INR'
    and exchange.ExchangeRateType = 'B'
{
     a.SalesOffice,
       a.SalesPlanPeriod,

     @Semantics.calendar.year
     a.SalesOrderDateYear,

      @Semantics.calendar.yearQuarter
      a.SalesOrderDateYearQuarter,
      @Semantics.calendar.yearMonth
      a.SalesOrderDateYearMonth,
      a.SalesPlanCurrency,
//      case 
//    when a.SalesPlanCurrency = 'USD'
//        then a.SalesPlanAmountInINR
//    else
//        case 
//            when exchange.ExchangeRate is not initial
//               then
//  cast(
//    cast( a.SalesPlanAmountInINR as abap.dec(15,2) )
//    *
//    cast( exchange.ExchangeRate as abap.dec(9,6) )
//    as abap.dec(17,2)
//  )            else
//                a.SalesPlanAmountInINR
//        end
//end as SalesPlanAmount,
//cast(
//    case 
//        when a.SalesPlanCurrency = 'USD'
//            then cast( a.SalesPlanAmountInINR as abap.dec(15,2) )
//
//        when exchange.ExchangeRate is not initial
//            then
//                round(
//                    cast( a.SalesPlanAmountInINR as abap.dec(15,2) )
//                  * cast( exchange.ExchangeRate as abap.dec(9,6) ),
//                    2
//                )
//
//        else
//            cast( a.SalesPlanAmountInINR as abap.dec(15,2) )
//    end
//as abap.dec(17,2) )
//as SalesPlanAmount,


case
  when SalesPlanCurrency = 'USD'
    then a.SalesPlanAmountInINR
  else
    case
      when exchange.ExchangeRate is not initial
        then
          cast(
            cast(
              cast( a.SalesPlanAmountInINR as abap.dec( 15, 2 ) )
              as abap.decfloat34
            )
            / cast(
                cast( exchange.ExchangeRate as abap.dec( 15, 6 ) )
                as abap.decfloat34
              )
            as abap.dec( 15, 2 )
          )
      else
        a.SalesPlanAmountInINR
    end
end as SalesPlanAmount,

exchange.ExchangeRate

}
