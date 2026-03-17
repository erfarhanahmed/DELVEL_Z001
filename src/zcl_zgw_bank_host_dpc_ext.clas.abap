class ZCL_ZGW_BANK_HOST_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_BANK_HOST_DPC
  create public .

public section.
protected section.

  methods HOSTSET_GET_ENTITY
    redefinition .
  methods HOSTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGW_BANK_HOST_DPC_EXT IMPLEMENTATION.


  method HOSTSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->HOSTSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.



    READ TABLE it_key_tab INTO DATA(wa_key_tab) WITH KEY name = 'Hostid'.
    IF wa_key_tab-value IS NOT INITIAL.
      DATA(lv_Hostid) = wa_key_tab-value.

    ELSE.
      er_entity-hostid = 'Please enter proper hostid'.
    ENDIF.


    IF lv_Hostid IS NOT INITIAL   .

      SELECT SINGLE * FROM zbank_host INTO @DATA(wa_host) WHERE hostid = @lv_Hostid .
*        AND scopeid = @lv_scopeid.

      IF  wa_host IS NOT INITIAL.
        MOVE-CORRESPONDING wa_host TO er_entity.
      ENDIF.

    ENDIF.









  endmethod.


  method HOSTSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->HOSTSET_GET_ENTITYSET
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
  data : lv_BUSINESSPARTNER type  BAPIBUS1006_HEAD-BPARTNER.
clear: lv_BUSINESSPARTNER.


*TYPES: BEGIN OF ty_partner,
*             sign   TYPE ddsign,
*             option TYPE ddoption,
*             low(10)    TYPE C,
*             high(10)   TYPE C,
*           END OF ty_partner.
*    DATA: s_partner TYPE TABLE OF ty_partner.
*    DATA: wa_kunnr TYPE  ty_partner.
*       DATA: wa_entity like LINE OF et_entityset.
TYPES: BEGIN OF ty_hostid,
  hostid TYPE zbank_host-hostid,
  END OF ty_hostid.
  data: wa_hostid TYPE ty_hostid,
        it_hostid TYPE TABLE OF ty_hostid.
LOOP AT it_filter_select_options INTO DATA(ls_filter).
      READ TABLE ls_filter-select_options INTO DATA(select_option) INDEX 1.
      IF ls_filter-property = 'HostID'.
        wa_hostid-hostid = select_option-low.
        APPEND wa_hostid to it_hostid.
*        MOVE-CORRESPONDING  select_option TO wa_kunnr.
*
*        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*          EXPORTING
*            INPUT         = wa_kunnr-low
*         IMPORTING
*           OUTPUT        = wa_kunnr-low
*                  .
*
*        APPEND wa_kunnr to s_partner.
        endif.
        clear: select_option, wa_hostid..
endloop.

    SELECT * from ZBANK_HOST INTO TABLE @DATA(it_host)
      FOR ALL ENTRIES IN @it_hostid WHERE hostid = @it_hostid-hostid.


      MOVE-CORRESPONDING it_host to et_entityset.
  endmethod.
ENDCLASS.
