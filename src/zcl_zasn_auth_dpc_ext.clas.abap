class ZCL_ZASN_AUTH_DPC_EXT definition
  public
  inheriting from ZCL_ZASN_AUTH_DPC
  create public .

public section.
protected section.

  methods ZASN_AUTHSET_CREATE_ENTITY
    redefinition .
  methods ZASN_AUTHSET_DELETE_ENTITY
    redefinition .
  methods ZASN_AUTHSET_GET_ENTITY
    redefinition .
  methods ZASN_AUTHSET_UPDATE_ENTITY
    redefinition .
  methods ZASN_AUTHSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZASN_AUTH_DPC_EXT IMPLEMENTATION.


  method ZASN_AUTHSET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTHSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

DATA: ls_data  TYPE ZCL_ZASN_AUTH_MPC=>TS_ZASN_AUTH,   "Your structure/table
      lv_entity TYPE string,
      ls_zasn type zasn_auth.
BREAK-POINT.
io_data_provider->read_entry_data(
  IMPORTING
    es_data = ls_data ).

"Insert into DB table
MOVE-CORRESPONDING ls_data to ls_zasn.
INSERT zasn_auth FROM ls_zasn.

IF sy-subrc = 0.
  "Return the created record back to OData
   DATA lr_entity TYPE REF TO data.

*  lr_entity = er_entity.  "assign Gateway return variable"
**
*  copy_data_to_ref(
*    EXPORTING
*      is_data = ls_data
*    CHANGING
*      cr_data = er_entity ).

MOVE-CORRESPONDING ls_Data to er_entity .
ELSE.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
    EXPORTING textid = /iwbep/cx_mgw_busi_exception=>business_error
              message = 'Insert failed'.
ENDIF.



  endmethod.


  method ZASN_AUTHSET_DELETE_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTHSET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
     READ TABLE IT_KEY_TAB INTO DATA(LS2) WITH KEY name = 'SUPPLIER'.
     data(lv_supplier) = ls2-value.

    READ TABLE IT_KEY_TAB INTO DATA(LS3) WITH KEY name = 'USERNAME'.
     data(lv_username) = ls3-value.

     DELETE FROM zasn_Auth WHERE supplier = lv_supplier
                                 and username = lv_username.

  endmethod.


  method ZASN_AUTHSET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTHSET_GET_ENTITY
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
    DATA: lv_username TYPE zusername,
        lv_password TYPE zpassword,
        ls_auth     TYPE zasn_auth.
*    CLEAr:lv_username,lv_password.
DATA:ls_keys  TYPE ZCL_ZASN_AUTH_MPC=>TS_ZASN_AUTH.
  " Read input parameters from the request URI
  io_tech_request_context->GET_CONVERTED_KEYS(
      IMPORTING es_key_values = ls_keys ).

*  LOOP AT lt_keys INTO ls_keys.
**    CASE ls_keys-name.
*      WHEN 'Username'.
*        lv_username = ls_keys-value.
*      WHEN 'Password'.
*        lv_password = ls_keys-value.
*    ENDCASE.
*  ENDLOOP.

  " Case-sensitive lookup
*  break ctplsd.
  SELECT SINGLE *
    FROM zasn_auth
    WHERE supplier = @ls_keys-supplier and
          username = @ls_keys-username
      AND password = @ls_keys-password
    INTO @ls_auth.

  IF sy-subrc = 0.
    er_entity = CORRESPONDING #( ls_auth ).
*    er_entity-message = 'Authorized'.
  ELSE.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        textid = /iwbep/cx_mgw_busi_exception=>business_error
        message = 'Invalid username or password'.
  ENDIF.



  endmethod.


  method ZASN_AUTHSET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZASN_AUTHSET_GET_ENTITYSET
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

SELECT * from zasn_auth INTO TABLE @DATA(lt_asn).
  move-CORRESPONDING lt_asn to et_entityset.
  endmethod.


  method ZASN_AUTHSET_UPDATE_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTHSET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

   "" naga
dATA: ls_data  TYPE ZCL_ZASN_AUTH_MPC=>TS_ZASN_AUTH,   "Your structure/table
      lv_entity TYPE string,
      ls_zasn type zasn_auth.

io_data_provider->read_entry_data(
  IMPORTING
    es_data = ls_data ).
MOVE-CORRESPONDING ls_data to ls_zasn.
update zasn_auth FROM ls_zasn.
    "naga

  endmethod.
ENDCLASS.
