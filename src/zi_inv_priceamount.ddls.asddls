@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_INV_PRICEAMOUNT as select from 
  I_BillingDocItemAnalytics as a
  left outer join vbrk as c  on a.BillingDocument = c.vbeln
 left outer join prcd_elements as b
       on  b.knumv = c.knumv
       and b.kposn      = a.BillingDocumentItem

//  left outer join  zi_priceamount2 as c
//  on a.SalesDocument = c.SalesDocument
//  and a. SalesDocumentItem = c.SalesDocumentItem

{
    key a.BillingDocument,
    key a.BillingDocumentItem,
    c.spart as Division,
    c.vkorg as SalesOrganization,
    c.vtweg as DistributionChannel,
    a.Product as Product,
    a.TransactionCurrency,
   a.PriceDetnExchangeRate,
    a.SalesDocumentType,
    a.BillingDocumentType,
/*-----------------------------*/
/* ZPFO CONDITION VALUE */
/*-----------------------------*/

@Semantics.amount.currencyCode: 'TransactionCurrency'
sum(
    case
        when b.kschl = 'ZPFO'
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
            then cast( b.kwert as abap.dec(15,2) )

        when b.kschl = 'ZDIS'
            then  cast( b.kwert as abap.dec(15,2) )

        else 0
    end
) 
as AccessibleValue,



cast( 'INR' as abap.cuky ) as DisplayCurrency,

@Semantics.amount.currencyCode: 'TransactionCurrency'
a.Subtotal1Amount


}



where
      b.kschl = 'ZPFO'
   or b.kschl = 'ZDIS'

group by
    a.BillingDocument,
    
    a.BillingDocumentItem,
    a.SalesDocumentType,
    a.BillingDocumentType,
     c.spart ,
    c.vkorg ,
    c.vtweg ,
    a.TransactionCurrency,
 a.PriceDetnExchangeRate,
    a.Subtotal1Amount,
    a.Product;
