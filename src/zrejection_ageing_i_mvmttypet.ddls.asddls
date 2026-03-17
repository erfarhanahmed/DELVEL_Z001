@AbapCatalog.sqlViewName: 'ZV_RMVMTTYPETEXT'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Movement Type Text by Language (1:1)'
@Metadata.ignorePropagatedAnnotations: true
define view ZREJECTION_AGEING_I_MvmtTypeT
  as select from t156t
{
  key t156t.bwart                            as bwart,
  key t156t.spras                            as Language,
      max( t156t.btext )                     as btext
}
where t156t.spras = $session.system_language
  and t156t.kzzug = ''       // no “goods receipt/issue” sub-variants
  and t156t.kzvbr = ''       // no consumption posting variant
  and t156t.sobkz = ''
group by t156t.bwart, t156t.spras
