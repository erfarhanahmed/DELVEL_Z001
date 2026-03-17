@AbapCatalog.sqlViewName: 'ZI_EXH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exchange Rate'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_EXCHANGE_RATE
  with parameters
    P_ExchangeRateType : kurst,
    P_DisplayCurrency  : vdm_v_display_currency
as select from  ZI_PENDING_SALES_ORDER(
        P_ExchangeRateType: $parameters.P_ExchangeRateType,
        P_DisplayCurrency:  $parameters.P_DisplayCurrency
     )                                         as SD

left outer to one join ZI_LATESTEXCHANGERATE1(
        P_ExchangeRateType: $parameters.P_ExchangeRateType
     )                                         as LER
  on  LER.SourceCurrency = SD.TransactionCurrency
  and LER.TargetCurrency = $parameters.P_DisplayCurrency
{
  key SD.SalesOrder,
  key SD.SalesOrderItem,
  key SD.Product,
  SD.TargetQuantity,
  
  SD.TransactionCurrency,
  @Semantics.currencyCode: true
//  'INR' as TargetCurrency,
cast( 'INR' as abap.cuky ) as TargetCurrency,
  $parameters.P_DisplayCurrency     as DisplayCurrency,
  case
  when LER.ExchangeRate >= 1
    then LER.ExchangeRate
  else
    1
end as LatestExchangeRate,
  

//  LER.ExchangeRate                  as LatestExchangeRate,
  LER.ValidFrom                     as ExchangeRateValidFrom,
@Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
//SD.OrderQuantity as OrderQuantity,
SD.OrderQuantity as OrderQuantity,
case
  when SD.OpenDeliveryOrderQuantity = 0
    then SD.TargetQuantity
  else
    SD.OpenDeliveryOrderQuantity
end as OpenDeliveryOrderQuantity,
 

SD.OrderQuantityUnit as OrderQuantityUnit,

  @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
SD.NetPriceAmount as NetPriceAmount,

    
//SD.NetPriceAmount * SD.OpenDeliveryOrderQuantity as OrderNetValue,

cast(
  case
    when SD.OpenDeliveryOrderQuantity >= 1
//      then SD.NetPriceAmount * SD.OrderQuantity * LER.ExchangeRate
        then    SD.NetPriceAmount * SD.OpenDeliveryOrderQuantity 
    else
      SD.NetPriceAmount * SD.TargetQuantity
  end
as abap.dec(13,2)) as OrderNetValue,
//  cast(SD.NetPriceAmount * SD.OrderQuantity * LER.ExchangeRate as abap.dec(13,2)) as LatestSalesOrderAmount
//
//cast(
//  case
//    when LER.ExchangeRate > 1
////      then SD.NetPriceAmount * SD.OrderQuantity * LER.ExchangeRate
//then SD.NetPriceAmount * SD.OpenDeliveryOrderQuantity *  LER.ExchangeRate
//    else
//      SD.NetPriceAmount * SD.OpenDeliveryOrderQuantity
//  end
//as abap.dec(13,2)) as LatestSalesOrderAmount



cast(
  case 
    /* First: Check if Open Quantity > 1 */
    when SD.OpenDeliveryOrderQuantity >= 1 then
      case 
        when LER.ExchangeRate > 1 then 
          SD.NetPriceAmount * SD.OpenDeliveryOrderQuantity * LER.ExchangeRate
        else 
          SD.NetPriceAmount * SD.OpenDeliveryOrderQuantity
      end
    
    /* Else: Use Target Quantity (fallback) */
    else 
      case 
        when LER.ExchangeRate > 1 then
          SD.NetPriceAmount * SD.TargetQuantity * LER.ExchangeRate
        else
          SD.NetPriceAmount * SD.TargetQuantity
      end
  end 
as abap.dec(13,2)) as LatestSalesOrderAmount




}
