@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'priceamount'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_PRICEAMOUNT1 as select from ZI_PRICEAMOUNT as a
{
   key   a.SalesDocument,
    key a.SalesDocumentItem

 
}
