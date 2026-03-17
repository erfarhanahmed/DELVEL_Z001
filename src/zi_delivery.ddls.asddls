@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_DELIVERY as select  distinct from 
 I_SalesDocumentItemAnalytics as a
 left outer join  I_DeliveryDocumentItem  as DDI 
   on a.SalesDocument = DDI.ReferenceSDDocument
    and a.SalesDocumentItem = DDI.ReferenceSDDocumentItem
{
    key DDI.ReferenceSDDocument,
    key    DDI.ReferenceSDDocumentItem,
//       DDI.DeliveryDocument,
       @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
    sum(DDI.ActualDeliveryQuantity) as ActualDeliveryQuantity,
    DDI.DeliveryQuantityUnit
}
group by  DDI.ReferenceSDDocument,
        DDI.ReferenceSDDocumentItem,
       DDI.DeliveryQuantityUnit;
