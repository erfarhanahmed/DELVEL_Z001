class ZCL_ZASN_SUPPLIER_DPC_EXT definition
  public
  inheriting from ZCL_ZASN_SUPPLIER_DPC
  create public .

public section.
protected section.

  methods ZASN_SUPPLIERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZASN_SUPPLIER_DPC_EXT IMPLEMENTATION.


  method ZASN_SUPPLIERSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZASN_SUPPLIERSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
DATA: ls_lfa1 like LINE OF et_entityset.
    select lifnr  as SupplierCode,name1 as SupplierName from lfa1 INTO TABLE @DATA(lt_lfa1).
LOOP AT lt_lfa1 ASSIGNING FIELD-SYMBOL(<fs>).
ls_lfa1-SupplierCode = <fs>-SupplierCode.
ls_lfa1-SupplierName = <fs>-SupplierName.
APPEND ls_lfa1 to et_entityset.
CLEAr ls_lfa1.
ENDLOOP.
*      ET_ENTITYSET = lt_lfa1.



  endmethod.
ENDCLASS.
