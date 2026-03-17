@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_BANK_CC_LIMIT'
@ObjectModel.semanticKey: [ 'BankName', 'AccountType' ]
define root view entity ZC_BANK_CC_LIMIT
  provider contract transactional_query
  as projection on ZR_BANK_CC_LIMIT
{
  key BankName,
  key AccountType,
  CcLimit,
  Gl1,
  LocalLastChangedAt
  
}
