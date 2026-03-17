@AbapCatalog.sqlViewName: 'ZV_CREDITSUM'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum of Credit by Bank, Bank Type, and GL Account'

define view ZI_CreditSum
  as select from zbank_cc_limit1
{
  key bank_name,
  key bank_type,
  key gl,

  @Semantics.amount.currencyCode: 'vbrp.waerk'
   sum(credit)  as total_credit
}
group by
  bank_name,
  bank_type,
  gl;
 
