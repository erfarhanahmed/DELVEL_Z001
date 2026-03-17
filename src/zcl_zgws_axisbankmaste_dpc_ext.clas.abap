class ZCL_ZGWS_AXISBANKMASTE_DPC_EXT definition
  public
  inheriting from ZCL_ZGWS_AXISBANKMASTE_DPC
  create public .

public section.
protected section.

  methods MASTERDATASET_CREATE_ENTITY
    redefinition .
  methods MASTERDATASET_DELETE_ENTITY
    redefinition .
  methods MASTERDATASET_GET_ENTITY
    redefinition .
  methods MASTERDATASET_GET_ENTITYSET
    redefinition .
  methods MASTERDATASET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGWS_AXISBANKMASTE_DPC_EXT IMPLEMENTATION.


  method MASTERDATASET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->MASTERDATASET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    IO_TECH_REQUEST_CONTEXT =
*    IT_NAVIGATION_PATH      =
**    IO_DATA_PROVIDER        =
**  IMPORTING
**    ER_ENTITY               =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.

       DATA :  wa_entity like er_entity.
    DATA :  wa_axismaster TYPE zaxis_master.

    TRY.
        CALL METHOD io_data_provider->read_entry_data
          IMPORTING
            es_data = wa_entity.
        .
      CATCH /iwbep/cx_mgw_tech_exception. " mgw technical exception
    ENDTRY.

  if wa_entity is not initial.

    move-CORRESPONDING wa_entity to wa_axismaster.

    select single from zaxis_master
    fields *
    where clintid = @wa_axismaster-clintid
*      and CORPACCNUM =  @wa_axismaster-CORPACCNUM
    into @data(ls_axismaster).
    if sy-subrc = 0.

      data(lo_msg_container) = mo_context->get_message_container( ).

      lo_msg_container->add_message_text_only(
      iv_msg_type               = 'E'                 " Message Type - defined by GCS_MESSAGE_TYPE
*      iv_msg_text               = |client id { wa_axismaster-clintid } Corpaccno { wa_axismaster-CORPACCNUM } already exist |              " Message Text
      iv_msg_text               = |client id { wa_axismaster-clintid }  already exist |              " Message Text
      ).
      raise EXCEPTION type /iwbep/cx_mgw_busi_exception
      exporting
        message_container = lo_msg_container.

    else.
      insert zaxis_master from wa_axismaster.
      if sy-subrc = 0.
        commit work.
      else.
        rollback work.
      endif.
    endif.
er_entity = wa_entity.
  endif.
  endmethod.


  method MASTERDATASET_DELETE_ENTITY.
**TRY.
*CALL METHOD SUPER->MASTERDATASET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    IO_TECH_REQUEST_CONTEXT =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.

       DATA : ls_axismaster TYPE zaxis_master.
    DATA : lv_clientid TYPE zaxis_master-clintid.
 data: lv_CORPACCNUM TYPE zaxis_master-CORPACCNUM.
    lv_clientid = VALUE #( it_key_tab[ name = 'Clintid'  ]-value OPTIONAL ).
    lv_CORPACCNUM = value #( it_key_tab[ name = 'Corpaccnum' ]-value optional ).
    IF lv_clientid IS NOT INITIAL.
      SELECT SINGLE FROM zaxis_master
        FIELDS *
        WHERE clintid = @lv_clientid
        and CORPACCNUM = @lv_CORPACCNUM
        INTO @ls_axismaster.
      IF sy-subrc = 0.
        DELETE zaxis_master FROM ls_axismaster.
        IF sy-subrc = 0.
          COMMIT WORK.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ENDIF.
    ENDIF.
  endmethod.


  method MASTERDATASET_GET_ENTITY.
**TRY.
*CALL METHOD SUPER->MASTERDATASET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    IO_REQUEST_OBJECT       =
**    IO_TECH_REQUEST_CONTEXT =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    ER_ENTITY               =
**    ES_RESPONSE_CONTEXT     =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.

     data : wa_axismaster type zaxis_master.
    data : lv_clientid type zaxis_master-clintid.
    data: lv_CORPACCNUM TYPE zaxis_master-CORPACCNUM.

    lv_clientid = value #( it_key_tab[ name = 'Clintid' ]-value optional ).
*    lv_CORPACCNUM = value #( it_key_tab[ name = 'Corpaccnum' ]-value optional ).

    if lv_clientid is not initial.
      select single from zaxis_master
        fields *
        where clintid = @lv_clientid
*        and CORPACCNUM = @lv_CORPACCNUM
        into @wa_axismaster.
        if wa_axismaster is not initial.
          move-corresponding wa_axismaster to er_entity.
        endif.
    endif.
  endmethod.


  method MASTERDATASET_GET_ENTITYSET.
**TRY.
*CALL METHOD SUPER->MASTERDATASET_GET_ENTITYSET
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
**    IO_TECH_REQUEST_CONTEXT  =
**  IMPORTING
**    ET_ENTITYSET             =
**    ES_RESPONSE_CONTEXT      =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.

    DATA : lt_axismaster TYPE TABLE OF zaxis_master.
    DATA : r_clintid TYPE RANGE OF zaxis_master-clintid,
*     r_clintid_acc TYPE RANGE OF zaxis_master-CORPACCNUM,
           w_clintid LIKE LINE OF r_clintid.

    DATA : p_clintid TYPE /iwbep/s_cod_select_option,
           wa_filter TYPE /iwbep/s_mgw_select_option.
*     DATA : p_clintid_acc TYPE /iwbep/s_cod_select_option,
*           wa_filter_acc TYPE /iwbep/s_mgw_select_option.

    DATA : lt_sort TYPE TABLE OF abap_sortorder,
           ls_sort LIKE LINE OF lt_sort.

    wa_filter = VALUE #( it_filter_select_options[ property = 'Clintid' ] OPTIONAL ).
*    wa_filter_acc = VALUE #( it_filter_select_options[ property = 'Corpaccnum' ] OPTIONAL ).
    p_clintid = VALUE #( wa_filter-select_options[ 1 ] OPTIONAL ).
*    p_clintid_acc = VALUE #( wa_filter-select_options[ 1 ] OPTIONAL ).

    IF p_clintid IS NOT INITIAL .
      APPEND VALUE #( sign    = p_clintid-sign
                      option  = p_clintid-option
                      low     = p_clintid-low
                      high    = p_clintid-high ) TO r_clintid.

*      APPEND VALUE #( sign    = p_clintid_acc-sign
*                      option  = p_clintid_acc-option
*                      low     = p_clintid_acc-low
*                      high    = p_clintid_acc-high ) TO r_clintid_acc.

      SELECT FROM zaxis_master
      FIELDS *
      WHERE clintid IN @r_clintid
*        and CORPACCNUM in @r_clintid_acc
      INTO TABLE @lt_axismaster.
    ELSE.
      SELECT FROM zaxis_master
      FIELDS *
      INTO TABLE @lt_axismaster.
    ENDIF.

    IF lt_axismaster IS NOT INITIAL.
      et_entityset = CORRESPONDING #( lt_axismaster ).
    ENDIF.

    LOOP AT it_order  ASSIGNING FIELD-SYMBOL(<ls_order>).
      ls_sort-name = <ls_order>-property.
      IF <ls_order>-order = 'desc'.
        ls_sort-descending = abap_true.
      ELSE.
        ls_sort-descending = abap_false.
      ENDIF.
      APPEND ls_sort TO lt_sort.
      CLEAR ls_sort.
    ENDLOOP.

    SORT et_entityset BY (lt_sort).

    CALL METHOD io_tech_request_context->has_inlinecount
      RECEIVING
        rv_has_inlinecount = DATA(inline).

    IF inline IS NOT INITIAL.
      DATA(lines) = lines( et_entityset ).
      IF lines IS NOT INITIAL.
        es_response_context-inlinecount = lines.
      ENDIF.
    ENDIF.

  endmethod.


  method MASTERDATASET_UPDATE_ENTITY.
**TRY.
*CALL METHOD SUPER->MASTERDATASET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    IO_TECH_REQUEST_CONTEXT =
*    IT_NAVIGATION_PATH      =
**    IO_DATA_PROVIDER        =
**  IMPORTING
**    ER_ENTITY               =
*    .
**  CATCH /IWBEP/CX_MGW_BUSI_EXCEPTION.
**  CATCH /IWBEP/CX_MGW_TECH_EXCEPTION.
**ENDTRY.


     DATA : wa_entity LIKE er_entity.
    DATA : ls_axismaster TYPE zaxis_master.

    TRY.
        CALL METHOD io_data_provider->read_entry_data
          IMPORTING
            es_data = wa_entity.
      CATCH /iwbep/cx_mgw_tech_exception. " mgw technical exception

    ENDTRY.

    IF wa_entity IS NOT INITIAL.
      MOVE-CORRESPONDING wa_entity TO ls_axismaster.
      IF ls_axismaster IS NOT INITIAL.
        MODIFY zaxis_master FROM ls_axismaster.
        IF sy-subrc = 0.
          COMMIT WORK.
        ELSE.
          ROLLBACK WORK.
        ENDIF.
      ENDIF.
    ENDIF.
  endmethod.
ENDCLASS.
