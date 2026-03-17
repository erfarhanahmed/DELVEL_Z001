@AbapCatalog.sqlViewName: 'ZV_BANKGLSUM_B'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bankwise Credit and GL Amount (Line Items)'
@VDM.viewType: #BASIC
@Analytics.dataCategory: #DIMENSION
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view ZI_BankGLSummary_Basic
  as select from ZI_CreditSum               as Credit
    inner join   ZI_GLAccountAmountFiltered as GL on Credit.gl = GL.GLAccount
{
  key Credit.bank_name           as BankName,
  key Credit.bank_type           as BankType,
  //key Credit.gl                  as GLAccount, // keep GL at line-item granularity

      @Semantics.amount.currencyCode: 'vbrp.waerk'
      sum( Credit.total_credit ) as CreditAmount,

      @Semantics.amount.currencyCode: 'vbrp.waerk'
     sum( GL.TotalAmount )      as LedgerBalance
}
group by
  Credit.bank_name,
  Credit.bank_type;
