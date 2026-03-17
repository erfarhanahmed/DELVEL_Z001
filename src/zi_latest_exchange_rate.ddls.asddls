@AbapCatalog.sqlViewName: 'ZI_LATEST_SALES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest exchange Rate'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LATEST_EXCHANGE_RATE 
as select from I_ExchangeRate
{
  key SourceCurrency,
  key TargetCurrency,
  key ExchangeRateType,
// key  ExchangeRate,
  max(  ExchangeRateEffectiveDate ) as ValidFrom
}
where
// ExchangeRateType = :P_ExchangeRateType
   ExchangeRateEffectiveDate <= $session.system_date
group by
  SourceCurrency,
  TargetCurrency,
  ExchangeRateType;
