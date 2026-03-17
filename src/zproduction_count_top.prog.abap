*&---------------------------------------------------------------------*
*& Include          ZPRODUCTION_COUNT_TOP
*&
*---------------------------------------------------------------------*
Tables : aufk.

TYPES : BEGIN OF ty_shirwal1,
        AUART TYPE AUFK-AUART,
        BRAND TYPE MARA-BRAND,
        ZPROD_ORDER TYPE i,
        PSMNG  TYPE AFPO-PSMNG,
*        STRMP TYPE AFPO-STRMP,
        erdat TYPE AUFK-ERDAT,
        END OF ty_shirwal1.


DATA : IT_SHIRWAL1 TYPE STANDARD TABLE OF ty_shirwal1,
       WA_SHIRWAL1 TYPE ty_shirwal1,
       IT_KAPURHOL1 TYPE STANDARD TABLE OF ty_shirwal1,
       WA_KAPURHOL1 TYPE ty_shirwal1,
       IT_SHIRWAL2 TYPE STANDARD TABLE OF ty_shirwal1,
       WA_SHIRWAL2 TYPE ty_shirwal1,
       IT_KAPURHOL2 TYPE STANDARD TABLE OF ty_shirwal1,
       WA_KAPURHOL2 TYPE ty_shirwal1.





DATA: it_fieldcat TYPE TABLE OF lvc_s_fcat,
      wa_fieldcat TYPE lvc_s_fcat,
      gs_layout   TYPE lvc_s_layo.

DATA :  g_grid1 TYPE REF TO cl_gui_alv_grid,
      g_grid2 TYPE REF TO cl_gui_alv_grid,
      g_grid3 TYPE REF TO cl_gui_alv_grid,
      g_grid4 TYPE REF TO cl_gui_alv_grid,
      g_cont1 TYPE REF TO cl_gui_custom_container,
      g_cont2 TYPE REF TO cl_gui_custom_container,
      g_cont3 TYPE REF TO cl_gui_custom_container,
      g_cont4 TYPE REF TO cl_gui_custom_container.

 DATA : LV_VAR     TYPE AFPO-PSMNG,
         LV_COUNTER TYPE i.
