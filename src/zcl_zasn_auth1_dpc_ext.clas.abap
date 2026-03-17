class ZCL_ZASN_AUTH1_DPC_EXT definition
  public
  inheriting from ZCL_ZASN_AUTH1_DPC
  create public .

public section.
protected section.

  methods ZASN_AUTH1SET_CREATE_ENTITY
    redefinition .
  methods ZASN_AUTH1SET_DELETE_ENTITY
    redefinition .
  methods ZASN_AUTH1SET_GET_ENTITY
    redefinition .
  methods ZASN_AUTH1SET_GET_ENTITYSET
    redefinition .
  methods ZASN_AUTH1SET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZASN_AUTH1_DPC_EXT IMPLEMENTATION.


  method ZASN_AUTH1SET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTH1SET_CREATE_ENTITY
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

    DATA: ls_data  TYPE ZCL_ZASN_AUTH1_MPC=>TS_ZASN_AUTH1,   "Your structure/table
      lv_entity TYPE string,
      ls_zasn type zasn_auth.
*BREAK-POINT.
io_data_provider->read_entry_data(
  IMPORTING
    es_data = ls_data ).

"Insert into DB table
SELECT single * from zasn_auth into @data(ls_asn) WHERE username = @ls_data-username  and
                                                         password = @ls_data-password.
  if ls_asn is INITIAL.
MOVE-CORRESPONDING ls_data to ls_zasn.
ls_zasn-CREATEDBY = sy-uname.
ls_zasn-CHANGEDBY = sy-uname.
ls_zasn-CREATEDDATE = sy-datum..
ls_zasn-CHANGEDDATE = sy-datum..

modify zasn_auth FROM ls_zasn.

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
*copy_data_to_ref(
*    EXPORTING
*      is_data = ls_data       "or ls_db if you want DB output
*    CHANGING
*      cr_data = er_entity ).
ELSE.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
    EXPORTING textid = /iwbep/cx_mgw_busi_exception=>business_error
              message = 'Insert failed'.
ENDIF.
*else.
* RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*    EXPORTING textid = /iwbep/cx_mgw_busi_exception=>business_error
*              message = 'Data already exits with this username'.
ENDIF.

  endmethod.


  method ZASN_AUTH1SET_DELETE_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTH1SET_DELETE_ENTITY
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
*    BREAK ctplsd.
*    READ TABLE IT_KEY_TAB INTO DATA(LS2) WITH KEY name = 'SUPPLIER'.
*     data(lv_supplier) = ls2-value.

    READ TABLE IT_KEY_TAB INTO DATA(LS3) WITH KEY name = 'USERNAME'.
     data(lv_username) = ls3-value.

*     DELETE FROM zasn_Auth WHERE supplier = lv_supplier
     DELETE FROM zasn_Auth WHERE
                                 username = lv_username.


  endmethod.


  method ZASN_AUTH1SET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTH1SET_GET_ENTITY
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
DATA:ls_keys  TYPE ZCL_ZASN_AUTH1_MPC=>TS_ZASN_AUTH1.
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
    WHERE " supplier = @ls_keys-supplier and
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


  method ZASN_AUTH1SET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->ZASN_AUTH1SET_GET_ENTITYSET
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


  method ZASN_AUTH1SET_UPDATE_ENTITY.
**TRY.
*CALL METHOD SUPER->ZASN_AUTH1SET_UPDATE_ENTITY
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


    dATA: ls_data  TYPE ZCL_ZASN_AUTH1_MPC=>TS_ZASN_AUTH1,   "Your structure/table
      lv_entity TYPE string,
      ls_zasn type zasn_auth.
*BREAK ctplsd.
io_data_provider->read_entry_data(
  IMPORTING
    es_data = ls_data ).
MOVE-CORRESPONDING ls_data to ls_zasn.
READ TABLE IT_KEY_TAB INTO DATA(LS3) WITH KEY name = 'USERNAME'.
     data(lv_username) = ls3-value.
select SINGLE * from zasn_auth INTO @DATA(ls_asn) WHERE username  = @lv_username.
  if ls_asn is NOT INITIAL.
     ls_zasn-changedby = sy-uname.
     ls_zasn-changeddate = sy-datum.
    update zasn_auth FROM ls_zasn.
    IF sy-subrc = 0.
*      DATA lv_user_str type string.
*      lv_user_str = | { lv_username } |.
*      DATA(lo_msg_cont) = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).
*
*      lo_msg_cont->add_message(
*        iv_msg_type              = 'S'          "Success
*        iv_msg_id                = 'ZMSG'       "Your message class
*        iv_msg_number            = '001'        "Message number
*        iv_msg_v1                = lv_user_str
*        iv_add_to_response_header = abap_true   "Send via sap-message header
*      ).

er_entity =  ls_data.

    ENDIF.
    else.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
    EXPORTING textid = /iwbep/cx_mgw_busi_exception=>business_error
              message = 'Data doesnot exist with this username '.
ENDIF.
CLear ls_Data.
  endmethod.
ENDCLASS.
