@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'KNVV for Sales Office'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_KNVV
  as select distinct from knvv
{
  key kunnr as Kunnr,
      vkbur as vkbur
}
