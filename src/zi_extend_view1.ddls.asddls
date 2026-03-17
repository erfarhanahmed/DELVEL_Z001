@AbapCatalog.sqlViewAppendName: 'ZI_EXT_MATERIAL1'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'I_MATERIAL EXTENDED CDS VIEW'
//@Metadata.ignorePropagatedAnnotations: true
extend view I_Product with ZI_EXTEND_VIEW1
 {
    mara.air_pressure as AIR_PRESSURE,
    mara.air_fail as AIR_FAIL,
    mara.actuator as ACTUATOR,
    mara.vertical as VERTICAL,
    mara.bom as bom,
    mara.item_type as ITEM_TYPE,
    mara.dev_status as DEV_STATUS,
    mara.zkanban as ZKANBAN,
    mara.zpen_item as ZPEN_ITEM,
    mara.zre_pen_item as ZRE_PEN_ITEM,
    mara.zseries as ZSERIES,
    mara.zsize as zsize,
    mara.brand  as ZBRAND,
    mara.moc as MOC,
    mara.type as TYPE,
    mara.zzeds as ZZEDS,
    mara.zzmss as ZZMSS,
    mara.cap_lead as CAP_LEAD,
    mara.qap_no as QAP_NO,
    mara.rev_no as REV_NO,
    mara.zboi as ZBOI,
    mara.zitem_class as ZITEM_CLASS,
    mara.mtart as material_type
    
}
