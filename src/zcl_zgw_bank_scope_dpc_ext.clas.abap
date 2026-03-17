class ZCL_ZGW_BANK_SCOPE_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_BANK_SCOPE_DPC
  create public .

public section.
protected section.

  methods SCOPESET_GET_ENTITY
    redefinition .
  methods SCOPESET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGW_BANK_SCOPE_DPC_EXT IMPLEMENTATION.


  method SCOPESET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->SCOPESET_GET_ENTITY
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

*Scopeid
*Clientid

    READ TABLE it_key_tab into data(wa_key_tab) with key name = 'Scopeid'.
    if wa_key_tab-value is not INITIAL.
     data(lv_scopeid) = wa_key_tab-value.

      ELSE.
   er_entity-scopeid = 'Please enter proper scopeid'.
      endif.

  READ TABLE it_key_tab into wa_key_tab with key name = 'Clientid'.
    if wa_key_tab-value is not INITIAL.
     data(lv_Clientid) = wa_key_tab-value.

      ELSE.
   er_entity-Clientid = 'Please enter proper Clientid'.
      endif.

     IF lv_Clientid is not INITIAL and lv_scopeid is not INITIAL  .

       SELECT SINGLE * from zbank_scope INTO @DATA(wa_scope) WHERE Clientid = @lv_Clientid and scopeid = @lv_scopeid.

         IF  wa_scope is NOT INITIAL.
MOVE-CORRESPONDING wa_scope to er_entity.
         ENDIF.

     ENDIF.

*er_entity-BUSINESSPARTNER = gs_partner-partner.
*er_entity-TITLE_KEY       = gs_partner-title.
*
*er_entity-SEARCHTERM1     = gs_partner-BU_SORT1.
*er_entity-NAME1           = gs_partner-NAME_ORG1.
*er_entity-NAME2           = gs_partner-NAME_ORG2.
*er_entity-NAME4           = gs_partner-NAME_ORG4.
*er_entity-bu_group = gs_partner-bu_group.
*
*er_entity-CITY       = gs_adrc-CITY1.
*er_entity-POSTL_COD1 = gs_adrc-POST_CODE1.
*er_entity-STREET     = gs_adrc-STREET.
**er_entity-address-DISTRICT   = gs_adrc-d
*er_entity-STREET_NO   = gs_adrc-STREETCODE.
*er_entity-HOUSE_NO    = gs_adrc-HOUSE_NUM1.
*er_entity-COUNTRY     = gs_adrc-COUNTRY.
*er_entity-REGION    = gs_adrc-REGION.
*er_entity-TRANSPZONE = gs_adrc-TRANSPZONE.
*er_entity-mobile1 = gs_adr2-TEL_NUMBER.
*er_entity-email1 = gs_adr6-SMTP_ADDR.
*
*
*
*er_entity-message = 'Please enter the proper BP'.




  endmethod.


  method SCOPESET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->SCOPESET_GET_ENTITYSET
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




TYPES: BEGIN OF ty_Scopeid,
  Scopeid TYPE zbank_Scope-Scopeid,
  END OF ty_Scopeid.
  data: wa_Scopeid TYPE ty_Scopeid,
        it_Scopeid TYPE TABLE OF ty_Scopeid.
LOOP AT it_filter_select_options INTO DATA(ls_filter).
      READ TABLE ls_filter-select_options INTO DATA(select_option) INDEX 1.
      IF ls_filter-property = 'ScopeID'.
        wa_Scopeid-Scopeid = select_option-low.
        APPEND wa_Scopeid to it_Scopeid.
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
        clear: select_option, wa_Scopeid..
endloop.

    SELECT * from ZBANK_Scope INTO TABLE @DATA(it_Scope)
      FOR ALL ENTRIES IN @it_Scopeid WHERE Scopeid = @it_Scopeid-Scopeid.


      MOVE-CORRESPONDING it_Scope to et_entityset.

  endmethod.
ENDCLASS.
