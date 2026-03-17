@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Price amount view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PENDING_P13 as select from ZI_PENDING_P12  as a
{
    key SalesDocument,
    key SalesDocumentItem,
    TransactionCurrency,
    @Semantics.quantity.unitOfMeasure:  'OrderQuantityUnit'
    Quantity,
    OrderQuantityUnit,
    SalesDocumentType,
    ZPFO_Value,
    ZDIS_Value,
    ZPR0_VALUE,
    zpr0,
    assess,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessibleValuesub,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    AccessValue_WithDiscount,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    Final_Assessible_Value,
//  @EndUserText.label: 'Assessable Value Per Unit'
//@Semantics.amount.currencyCode: 'TransactionCurrency'
//@Aggregation.default: #NONE 
//cast( 
//  case when Quantity > 0 
//       then cast(Final_Assessible_Value as abap.fltp) / cast(Quantity as abap.fltp)
//       else 0 
//  end as abap.dec(15,2) 
//) as AssessbaleValuePerUnit    

@EndUserText.label: 'Assessable Value Per Unit'
@Semantics.amount.currencyCode: 'TransactionCurrency'
@Aggregation.default: #NONE

cast(
  case 
       when Quantity > 0
       then Final_Assessible_Value / cast(Quantity as abap.dec(15,3))
       else 0
  end 
as abap.dec(15,2)) as AssessbaleValuePerUnit
      
}
