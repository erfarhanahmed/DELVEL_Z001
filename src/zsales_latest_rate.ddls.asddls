@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales latest view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSALES_LATEST_RATE 
 with parameters
    P_ExchangeRateType : kurst,
    P_ValidFrom        : abap.dats
as select from I_ExchangeRate as a
{
  key a.SourceCurrency,
  key a.TargetCurrency,
  key a.ExchangeRateType,
      max( a.ExchangeRateEffectiveDate ) as ValidFrom
}
where
  a.ExchangeRateType = $parameters.P_ExchangeRateType
  and a.ExchangeRateEffectiveDate <= $parameters.P_ValidFrom
group by
  a.SourceCurrency,
  a.TargetCurrency,
  a.ExchangeRateType
