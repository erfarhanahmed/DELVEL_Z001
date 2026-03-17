@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pending sales price'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PENDING_P as select distinct from 
I_SalesDocumentItemAnalytics as a
 left outer join prcd_elements as b
       on  a.SalesDocumentCondition = b.knumv
       and a.SalesDocumentItem      = b.kposn

//  left outer join  zi_priceamount2 as c
//  on a.SalesDocument = c.SalesDocument
//  and a. SalesDocumentItem = c.SalesDocumentItem
  left outer join  ZI_ZSER1 as c   on a.SalesDocument = c.SalesDocument
  and a. SalesDocumentItem = c.SalesDocumentItem
{
    key a.SalesDocument,
    key a.SalesDocumentItem,
    a.SalesDocumentType,
    
    a.TransactionCurrency,
//    c.exchangerate,

/*-----------------------------*/
/* ZPFO CONDITION VALUE */
/*-----------------------------*/

@Semantics.amount.currencyCode: 'TransactionCurrency'
sum(
    case
        when b.kschl = 'ZPFO'
//        then cast( b.kbetr as abap.dec(15,2) )
    then cast( b.kwert as abap.dec(15,2) )
        else 0
    end
) as ZPFO_Value,


/*-----------------------------*/
/* ZDIS CONDITION VALUE */
/*-----------------------------*/

@Semantics.amount.currencyCode: 'TransactionCurrency'
sum(
    case
        when b.kschl = 'ZDIS'
        then cast( b.kwert as abap.dec(15,2) )
        else 0
    end
) as ZDIS_Value,


/*-----------------------------*/
/* ACCESSIBLE VALUE */
/* ZPFO - ZDIS */
/*-----------------------------*/

@Semantics.amount.currencyCode: 'TransactionCurrency'
sum(
    case
        when b.kschl = 'ZPFO'
//            then cast( b.kbetr as abap.dec(15,2) )
 then cast( b.kwert as abap.dec(15,2) )

     
        when b.kschl = 'ZDIS'
//            then  cast( b.kbetr as abap.dec(15,2) )
             then  cast( b.kwert as abap.dec(15,2) )

        else 0
    end
) as AccessibleValue,


  c.ZPR0_VALUE,

cast( 'INR' as abap.cuky ) as DisplayCurrency,
@Semantics.amount.currencyCode: 'TransactionCurrency'
a.Subtotal1Amount

//@Semantics.amount.currencyCode: 'TransactionCurrency'
//a.Subtotal1Amount
//@Semantics.amount.currencyCode: 'TransactionCurrency'
//case
//    when a.Subtotal1Amount <= 0
//        then cast( c.ZPR0_VALUE as abap.dec(15,2) )
//    else
//        cast( a.Subtotal1Amount as abap.dec(15,2) )
//end as Subtotal1Amount


}
where
      b.kschl = 'ZPFO'
   or b.kschl = 'ZDIS' 

group by
    a.SalesDocument,
    a.SalesDocumentItem,
    a.TransactionCurrency,
    a.SalesDocumentType,
//    c.exchangerate,
    a.Subtotal1Amount,
   c.ZPR0_VALUE

    
