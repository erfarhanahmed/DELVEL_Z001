@AbapCatalog.sqlViewName: 'ZV_GLACCTAMTFL'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Account Amounts for Ledger 0L and Company Code 1000 (up to Today)'

define view ZI_GLAccountAmountFiltered
  as select from I_GLAccountLineItemCube
{
//  key Ledger,
//  key CompanyCode,
 key ltrim( GLAccount, '0' ) as GLAccount,
//   PostingDate,

  @Semantics.amount.currencyCode: 'vbrp.waerk'
   sum(AmountInCompanyCodeCurrency) as TotalAmount
}
where
  Ledger = '0L' and
  CompanyCode = '1000' and
  BusinessTransactionType <> 'RFBC' and
  PostingDate <= $session.system_date
group by
//  Ledger,
//  CompanyCode,
  GLAccount;
//  PostingDate;
