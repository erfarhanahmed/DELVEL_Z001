@AbapCatalog.sqlViewName: 'ZCRE_V_BANKGLSUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
@Analytics.dataCategory: #CUBE
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bankwise Credit and GL Amount Summary'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view ZCREDIT_BANKGLSUM as select from ZI_BankGLSummary
{
    

  key BankName,
  key BankType,

  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'vbrp.waerk'
  CreditAmount,

  @DefaultAggregation: #SUM
  @Semantics.amount.currencyCode: 'vbrp.waerk'
  LedgerBalance

    
}
