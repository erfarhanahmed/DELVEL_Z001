@EndUserText.label: 'Latest posting date for SO special stock (SO level)'
define view entity ZI_SO_STOCK_BUDAT_TEST
  as select from I_MaterialDocumentItem as Item
    association [0..1] to I_MaterialDocumentHeader as _Hdr
      on _Hdr.MaterialDocument     = Item.MaterialDocument
     and _Hdr.MaterialDocumentYear = Item.MaterialDocumentYear
{
  key Item.Material           as Matnr,
  key Item.Plant              as Werks,
  key Item.IssgOrRcvgSpclStockInd   as Sobkz,
  key Item.SalesOrder         as Vbeln,
  key Item.SalesOrderItem     as Posnr,

      max( _Hdr.PostingDate ) as Budat
}
where Item.IssgOrRcvgSpclStockInd = 'E'
group by
  Item.Material,
  Item.Plant,
  Item.IssgOrRcvgSpclStockInd,
  Item.SalesOrder,
  Item.SalesOrderItem;
