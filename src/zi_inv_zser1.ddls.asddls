@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice services'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_INV_ZSER1 as select from 
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
   c.kurrf as exchangerate,
    a.SalesDocumentType,
    a.BillingDocumentType,
/*-----------------------------*/
/* ZPFO CONDITION VALUE */
/*-----------------------------*/

@Semantics.amount.currencyCode: 'TransactionCurrency'
sum(
    case
        when b.kschl = 'ZPR0'
        then cast( b.kwert as abap.dec(15,2) )
        else 0
    end
) as ZPR0_Value,


cast( 'INR' as abap.cuky ) as DisplayCurrency,

@Semantics.amount.currencyCode: 'TransactionCurrency'
a.Subtotal1Amount




}


where
      b.kschl = 'ZPR0'

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
 c.kurrf,
    a.Subtotal1Amount,
    a.Product;
