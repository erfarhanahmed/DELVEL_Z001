
@AbapCatalog.sqlViewName: 'ZPLAINTEXT'
define view ZI_SalesOrderReplicatedText
  as select from I_TextObjectPlainLongText
{
  key TextObjectCategory,
      TextObjectType,
      TextObjectKey as salesorder,
      PlainLongText ,
    Language
//  LongText
  
}
//where
//TextObjectKey = 'VBBK'; -- Filter for Sales Order Header texts
