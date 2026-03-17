@AbapCatalog.sqlViewName: 'ZSALESAMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales OrderRate'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.supportedCapabilities: [ #SQL_DATA_SOURCE,
                                      #CDS_MODELING_DATA_SOURCE,
                                      #CDS_MODELING_ASSOCIATION_TARGET,
                                      #EXTRACTION_DATA_SOURCE,
                                      #SEARCHABLE_ENTITY
                                      
                                      ]
                                      
@ObjectModel.modelingPattern: #ANALYTICAL_CUBE                                 
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
define view ZI_LATESTSALESORDERRATE 
with parameters 
P_ExchangeRateType : kurst ,
P_DisplayCurrency  : vdm_v_display_currency
as select from ZI_EXCHANGE_RATE
(
        P_ExchangeRateType: $parameters.P_ExchangeRateType,
        P_DisplayCurrency:  $parameters.P_DisplayCurrency
     )                                         as SD

{
    key SD.SalesOrder,
  key SD.SalesOrderItem,
  key SD.Product,
  SD.TransactionCurrency,
  SD. DisplayCurrency,
@DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
   SD.LatestExchangeRate,
   SD.ExchangeRateValidFrom,
     @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
   @DefaultAggregation: #SUM
   SD.NetPriceAmount,
   @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
SD.OrderQuantity as OrderQuantity,

SD.OrderQuantityUnit as OrderQuantityUnit,
@DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
 SD.LatestSalesOrderAmount  as SalesOrderamountasonDate,
 @DefaultAggregation: #SUM
   @Semantics.amount.currencyCode: 'SD.TransactionCurrency'
SD.LatestSalesOrderAmount as Order_Board_Value_as_on_Date
}
