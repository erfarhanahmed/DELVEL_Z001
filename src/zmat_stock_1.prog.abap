REPORT Z_MULTIPLE_ALV_DISPLAY.
TYPE-POOLS: SLIS. " Contains ALV-related types

DATA: gs_layout TYPE SLIS_LAYOUT_ALV,
      gt_fieldcat TYPE SLIS_T_FIELDCAT_ALV,
      gs_fieldcat TYPE SLIS_FIELDCAT_ALV.
* Type definitions for internal tables
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         mbrsh TYPE mara-mbrsh,
       END OF ty_mara.

TYPES: BEGIN OF ty_marc,
         matnr TYPE marc-matnr,
         werks TYPE marc-werks,
         pstat TYPE marc-pstat,
       END OF ty_marc.

* Internal tables and work areas
DATA: it_mara TYPE STANDARD TABLE OF ty_mara,
      wa_mara TYPE ty_mara.

DATA: it_marc TYPE STANDARD TABLE OF ty_marc,
      wa_marc TYPE ty_marc.
tables : mara.
* Selection screen parameters
SELECT-OPTIONS: s_matnr FOR mara-matnr.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM display_alv_mara.
  PERFORM display_alv_marc.

*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
FORM get_data.
  " Populate IT_MARA
  SELECT matnr mtart mbrsh
    FROM mara
    INTO CORRESPONDING FIELDS OF TABLE it_mara
    WHERE matnr IN s_matnr.

  " Populate IT_MARC
  SELECT matnr werks pstat
    FROM marc
    INTO CORRESPONDING FIELDS OF TABLE it_marc
    WHERE matnr IN s_matnr.
ENDFORM. " GET_DATA

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_MARA
*&---------------------------------------------------------------------*
FORM display_alv_mara.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'TY_MARA' " Use the type definition name
      i_grid_title       = 'Material Master Data (MARA)'
    TABLES
      t_outtab           = it_mara
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " DISPLAY_ALV_MARA

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_MARC
*&---------------------------------------------------------------------*
FORM display_alv_marc.
  " Add a separator or clear screen if desired before the second ALV
  NEW-PAGE. " Optional: Starts a new page for the second ALV

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'TY_MARC' " Use the type definition name
      i_grid_title       = 'Material Plant Data (MARC)'
    TABLES
      t_outtab           = it_marc
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM. " DISPLAY_ALV_MARC
