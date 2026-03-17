@AbapCatalog.sqlViewName:  'ZPURCHREPV'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchasing Report with Mapping Header'

define view Z_I_PurchasingReport
  as select from zvertical_map as map -- Header table
  
    -- Inner join to PO Header ensures only POs for mapped groups are shown
    inner join I_PurchaseOrderAPI01 as  po on 
       po.PurchasingGroup = map.ekgrp
      
    inner join I_PurchaseOrderItemAPI01 as item 
      on item.PurchaseOrder = po.PurchaseOrder

    left outer join  Z_I_material_doc as matdoc 
      on  matdoc.PurchaseOrder     = item.PurchaseOrder
      and matdoc.PurchaseOrderItem = item.PurchaseOrderItem

    left outer join I_Businesspartnertaxnumber as tax 
      on  tax.BusinessPartner = po.Supplier
      and tax.BPTaxType       = 'IN4'

    -- Info Records (EINA/EINE)
    left outer join eina as eina_base 
      on eina_base.infnr is not initial
    left outer join eine as eina_org 
      on  eina_org.infnr = eina_base.infnr
      and eina_org.ekgrp = map.ekgrp

{
    key map.vname                             as VerticalName,
    key map.ekgrp                             as PurchasingGroup,
    key po.PurchaseOrder,
    key item.PurchaseOrderItem,
    po.PurchaseOrderType,
    po.Supplier,
    item.PurchasingDocumentDeletionCode,
    matdoc.MaterialDocument,
    matdoc.MaterialDocumentItem,
    matdoc.QuantityInBaseUnit as Quantity,
    matdoc.PostingDate,
    matdoc.MaterialDocumentYear,
    
    tax.BPTaxNumber                           as TaxNum,
    eina_base.infnr                           as InfoRecord,
    eina_base.urzzt                           as CastingWeight,
    po.CreationDate
}
where
      ( po.PurchaseOrderType = 'ZIMP' or po.PurchaseOrderType = 'NB' )
  and item.PurchasingDocumentDeletionCode = ' ' and matdoc.GoodsMovementType = '101' 
and matdoc.MaterialDocumentYear = '2025'
  and eina_base.urzzt is not initial and     tax.BPTaxNumber  is not initial
