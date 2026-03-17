@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pending ZPR0'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_ZSER1 as select from 
I_SalesDocumentItemAnalytics as a

  left outer join prcd_elements as b
       on  a.SalesDocumentCondition = b.knumv
       and a.SalesDocumentItem      = b.kposn
left outer join vbkd as c on a.SalesDocument = c.vbeln
//  left outer join  zi_priceamount2 as c
//  on a.SalesDocument = c.SalesDocument
//  and a. SalesDocumentItem = c.SalesDocumentItem

{
    key a.SalesDocument,
    key a.SalesDocumentItem,
    a.SalesDocumentType,
   c.kursk as Exchangerate,
    a.TransactionCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
sum(
    case
        when b.kschl = 'ZPR0'
//        then cast( b.kbetr as abap.dec(15,2) )
   then cast( b.kwert as abap.dec(15,2) )
        else 0
    end
) as ZPR0_VALUE
    
    }
    
    where
      b.kschl = 'ZPR0'
    

group by
    a.SalesDocument,
    a.SalesDocumentItem,
    c.kursk,
    a.TransactionCurrency,
    a.SalesDocumentType;
