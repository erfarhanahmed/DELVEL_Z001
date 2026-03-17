@AbapCatalog.sqlViewName: 'ZI_LATEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest exchange Rate'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LATEST_EXCHANGE_RATE1 

as select from I_ExchangeRate              as ER
inner join ZI_LATEST_EXCHANGE_RATE
                                        as MaxDate
  on  ER.SourceCurrency             = MaxDate.SourceCurrency
  and ER.TargetCurrency             = MaxDate.TargetCurrency
  and ER.ExchangeRateType           = MaxDate.ExchangeRateType
  and ER.ExchangeRateEffectiveDate  = MaxDate.ValidFrom
{
  key ER.SourceCurrency,
  key ER.TargetCurrency,
  key ER.ExchangeRateType,
      ER.ExchangeRate,
      MaxDate.ValidFrom
      
}
