@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'priceamount2'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_priceamount2 
 as select from I_SalesDocumentItemAnalytics as a

  left outer join prcd_elements as b
       on  a.SalesDocumentCondition = b.knumv
       and a.SalesDocumentItem      = b.kposn

  left outer join ZI_PRICEAMOUNT1 as c
       on  a.SalesDocument     = c.SalesDocument
       and a.SalesDocumentItem = c.SalesDocumentItem
{
  key a.SalesDocument,
    a.SalesDocumentItem,  
    b.kkurs as exchangerate
    
}
where b.kschl = 'ZPRO'
group by 
 a.SalesDocument,
    a.SalesDocumentItem,  
    b.kkurs
