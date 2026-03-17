@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZBANK_CC_LIMIT'
define root view entity ZR_BANK_CC_LIMIT
  as select from zbank_cc_limit
{
  key bank_name as BankName,
  key account_type as AccountType,
  cc_limit as CcLimit,
  gl_1 as Gl1,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_created_at as LastCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
  
}
