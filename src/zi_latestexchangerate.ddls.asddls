@AbapCatalog.sqlViewName: 'ZV_EXR_LST'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Latest Exchange Rate by Currency Pair'
define view ZI_LatestExchangeRate with parameters
    P_ExchangeRateType : kurst
as select from I_ExchangeRate
{
  key SourceCurrency,
  key TargetCurrency,
  key ExchangeRateType,
// key  ExchangeRate,
  max(  ExchangeRateEffectiveDate ) as ValidFrom
}
where ExchangeRateType = :P_ExchangeRateType
  and  ExchangeRateEffectiveDate <= $session.system_date
group by
  SourceCurrency,
  TargetCurrency,
  ExchangeRateType;
// ExchangeRate;
