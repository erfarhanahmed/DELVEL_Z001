@AbapCatalog.sqlViewName: 'ZIMSEGCOUNT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mesg count'
@Metadata.ignorePropagatedAnnotations: true
//@AbapCatalog.sqlViewName: 'ZIMSEGCOUNT'
define view ZI_MSEG_COUNT1
  as select from mseg as grn
    left outer join ekko as pur
      on pur.ebeln = grn.ebeln
    left outer join ekpo as item
      on item.ebeln = grn.ebeln
      and item.ebelp = grn.ebelp
{
  key grn.mblnr,
  key grn.mjahr,
  key grn.zeile,
  grn.ebeln,
  grn.ebelp,
  grn.matnr,
  grn.werks,
  grn.lgort,
  grn.bwart,
  grn.meins,
  grn.bukrs,
  grn.budat_mkpf,
  pur.ebeln as pur_ebeln,
  pur.bsart,
  item.matnr as po_matnr
}
where grn.lgort is not initial and grn.ebeln is not initial
