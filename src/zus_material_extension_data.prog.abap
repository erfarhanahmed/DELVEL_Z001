*&---------------------------------------------------------------------*
*& Include          ZUS_MATERIAL_EXTENSION_DATA
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = it_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = itab[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF .
  IF itab IS NOT INITIAL.
    PERFORM bapi_execution.
    PERFORM display_data.
  ELSE.
  ENDIF.
