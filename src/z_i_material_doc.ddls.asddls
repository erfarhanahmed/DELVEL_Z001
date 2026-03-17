@AbapCatalog.sqlViewName: 'ZMAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'material document view'
@Metadata.ignorePropagatedAnnotations: true
define view Z_I_material_doc 
  as select from I_MaterialDocumentItem as item

  left outer join I_MaterialDocumentItem as rev
    on  rev.ReversedMaterialDocument     = item.MaterialDocument
    and rev.ReversedMaterialDocumentYear = item.MaterialDocumentYear
    and rev.ReversedMaterialDocumentItem = item.MaterialDocumentItem
{
  key item.MaterialDocumentYear,
  key item.MaterialDocument,
  key item.MaterialDocumentItem,
   key  item.PurchaseOrder,
   key item.PurchaseOrderItem,

      item.GoodsMovementType,
      item.Material,
      item.Plant,
      item.PostingDate,
      item.QuantityInBaseUnit,
      item.Supplier
}
where
      item.GoodsMovementType = '101'
  and rev.MaterialDocument is null
