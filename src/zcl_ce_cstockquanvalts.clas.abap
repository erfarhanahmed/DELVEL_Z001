CLASS zcl_ce_cstockquanvalts DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS zcl_ce_cstockquanvalts IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    "=========================================================
    " 1) Read parameters from RAP request (GET_PARAMETERS)
    "=========================================================
    DATA lt_params TYPE if_rap_query_request=>tt_parameters.
    lt_params = io_request->get_parameters( ).

    DATA lv_disp_curr TYPE waers.
    DATA lv_period    TYPE abap_char1.
    DATA lv_start     TYPE d.
    DATA lv_end       TYPE d.

    DATA lv_val TYPE string.
    DATA lv_n   TYPE string.

    FIELD-SYMBOLS <ls_any> TYPE any.
    FIELD-SYMBOLS <fs_n>   TYPE any.
    FIELD-SYMBOLS <fs_v>   TYPE any.

    DEFINE _get_param.
      CLEAR lv_val.
      CLEAR lv_n.

      LOOP AT lt_params ASSIGNING <ls_any>.
        UNASSIGN <fs_n>.
        UNASSIGN <fs_v>.

        "Parameter name component (release-dependent)
        ASSIGN COMPONENT 'NAME' OF STRUCTURE <ls_any> TO <fs_n>.
        IF sy-subrc <> 0.
          ASSIGN COMPONENT 'PARAMETER_NAME' OF STRUCTURE <ls_any> TO <fs_n>.
        ENDIF.

        "Parameter value component (release-dependent)
        ASSIGN COMPONENT 'VALUE' OF STRUCTURE <ls_any> TO <fs_v>.
        IF sy-subrc <> 0.
          ASSIGN COMPONENT 'PARAMETER_VALUE' OF STRUCTURE <ls_any> TO <fs_v>.
        ENDIF.

        IF <fs_n> IS ASSIGNED AND <fs_v> IS ASSIGNED.
          lv_n = |{ <fs_n> }|.
          TRANSLATE lv_n TO UPPER CASE.

          IF lv_n = &1.
            lv_val = |{ <fs_v> }|.
            EXIT.
          ENDIF.
        ENDIF.
      ENDLOOP.
    END-OF-DEFINITION.

    "Read ONLY these 4 parameters from request
    _get_param 'P_DISPLAYCURRENCY'. lv_disp_curr = lv_val.
    _get_param 'P_PERIODTYPE'.      lv_period    = lv_val.
    _get_param 'P_STARTDATE'.       lv_start     = CONV d( lv_val ).
    _get_param 'P_ENDDATE'.         lv_end       = CONV d( lv_val ).

    IF lv_disp_curr IS INITIAL OR lv_period IS INITIAL OR lv_start IS INITIAL OR lv_end IS INITIAL.
      io_response->set_total_number_of_records( 0 ).
      io_response->set_data( VALUE string_table( ) ).
      RETURN.
    ENDIF.

    "=========================================================
    " 2) Compute previous-month dates
    "=========================================================
    DATA lv_prev_start TYPE d.
    DATA lv_prev_end   TYPE d.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = lv_start
        months    = 1
        signum    = '-'
      IMPORTING
        calc_date = lv_prev_start.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = lv_end
        months    = 1
        signum    = '-'
      IMPORTING
        calc_date = lv_prev_end.

    "=========================================================
    " 3) Select from your CDS view entity directly
    "    (no custom TYPES; use CDS entity as ABAP type)
    "=========================================================
    DATA lt_out TYPE STANDARD TABLE OF zi_cstockquanvalts WITH EMPTY KEY.

    SELECT *
      FROM zi_cstockquanvalts(
        p_displaycurrency = @lv_disp_curr,
        p_periodtype      = @lv_period,
        p_startdate       = @lv_start,
        p_enddate         = @lv_end,
        p_prevstartdate   = @lv_prev_start,
        p_prevenddate     = @lv_prev_end
      )
      INTO TABLE @lt_out.

    "=========================================================
    " 4) Return to RAP
    "=========================================================
    io_response->set_total_number_of_records( lines( lt_out ) ).
    io_response->set_data( lt_out ).

  ENDMETHOD.

ENDCLASS.

