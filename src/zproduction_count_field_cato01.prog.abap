*----------------------------------------------------------------------*
***INCLUDE ZPRODUCTION_COUNT_FIELD_CATO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module FIELD_CATALOGUE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE FIELD_CATALOGUE OUTPUT.
  WA_FIELDCAT-COL_POS   = 1.
  WA_FIELDCAT-FIELDNAME = 'AUART'.
  WA_FIELDCAT-COLTEXT   = 'Order type'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-COL_POS    = 2.
  WA_FIELDCAT-FIELDNAME = 'BRAND'.
  WA_FIELDCAT-COLTEXT   = 'BRAND'.
   WA_FIELDCAT-do_sum = ' '.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-COL_POS   = 3.
  WA_FIELDCAT-FIELDNAME = 'ZPROD_ORDER'.
  WA_FIELDCAT-COLTEXT   = 'No of Pod. Orders'.
  WA_FIELDCAT-do_sum = 'X'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-COL_POS  = 4.
  WA_FIELDCAT-FIELDNAME = 'PSMNG'.
  WA_FIELDCAT-COLTEXT   = 'No of Valves'.
  WA_FIELDCAT-do_sum = 'X'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-COL_POS  = 5.
  WA_FIELDCAT-FIELDNAME = 'ERDAT'.
  WA_FIELDCAT-COLTEXT   = 'Oldest Production Order Date'.
*  wa_fieldcat-outputlen = 10.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


"CONTAINER 1

 IF g_cont1 IS NOT BOUND.

    CREATE OBJECT g_cont1
      EXPORTING
        container_name              = 'ALV1_SHIRWAL'                 " Name of the Screen CustCtrl Name to Link Container To
      EXCEPTIONS
        cntl_error                  = 1                " CNTL_ERROR
        cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
        create_error                = 3                " CREATE_ERROR
        lifetime_error              = 4                " LIFETIME_ERROR
        lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
        OTHERS                      = 6.
ENDIF.
   CHECK g_cont1 IS BOUND.

   CREATE OBJECT g_grid1
    EXPORTING
      i_parent          = g_cont1                 " Parent Container
    EXCEPTIONS
      error_cntl_create = 1                " Error when creating the control
      error_cntl_init   = 2                " Error While Initializing Control
      error_cntl_link   = 3                " Error While Linking Control
      error_dp_create   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.

  CHECK g_grid1 IS BOUND.


   CALL METHOD g_grid1->SET_TABLE_FOR_FIRST_DISPLAY
*     EXPORTING
*       I_BUFFER_ACTIVE               =
*       I_BYPASSING_BUFFER            =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME              =
*       IS_VARIANT                    =
*       I_SAVE                        =
*       I_DEFAULT                     = 'X'
*       IS_LAYOUT                     =
*       IS_PRINT                      =
*       IT_SPECIAL_GROUPS             =
*       IT_TOOLBAR_EXCLUDING          =
*       IT_HYPERLINK                  =
*       IT_ALV_GRAPHICS               =
*       IT_EXCEPT_QINFO               =
*       IR_SALV_ADAPTER               =
     CHANGING
       IT_OUTTAB                     = it_shirwal1
       IT_FIELDCATALOG               = it_fieldcat
*       IT_SORT                       =
*       IT_FILTER                     =
     EXCEPTIONS
       INVALID_PARAMETER_COMBINATION = 1
       PROGRAM_ERROR                 = 2
       TOO_MANY_LINES                = 3
       OTHERS                        = 4
           .
   IF SY-SUBRC <> 0.
*    Implement suitable error handling here
   ENDIF.


"CONTAINER 2

 IF g_cont2 IS NOT BOUND.

    CREATE OBJECT g_cont2
      EXPORTING
        container_name              = 'ALV2_KAPURHOL'                 " Name of the Screen CustCtrl Name to Link Container To
      EXCEPTIONS
        cntl_error                  = 1                " CNTL_ERROR
        cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
        create_error                = 3                " CREATE_ERROR
        lifetime_error              = 4                " LIFETIME_ERROR
        lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
        OTHERS                      = 6.
ENDIF.

 CHECK g_cont2 IS BOUND.

   CREATE OBJECT g_grid2
    EXPORTING
      i_parent          = g_cont2                " Parent Container
    EXCEPTIONS
      error_cntl_create = 1                " Error when creating the control
      error_cntl_init   = 2                " Error While Initializing Control
      error_cntl_link   = 3                " Error While Linking Control
      error_dp_create   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.

  CHECK g_grid2 IS BOUND.

     CALL METHOD g_grid2->SET_TABLE_FOR_FIRST_DISPLAY
*     EXPORTING
*       I_BUFFER_ACTIVE               =
*       I_BYPASSING_BUFFER            =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME              =
*       IS_VARIANT                    =
*       I_SAVE                        =
*       I_DEFAULT                     = 'X'
*       IS_LAYOUT                     =
*       IS_PRINT                      =
*       IT_SPECIAL_GROUPS             =
*       IT_TOOLBAR_EXCLUDING          =
*       IT_HYPERLINK                  =
*       IT_ALV_GRAPHICS               =
*       IT_EXCEPT_QINFO               =
*       IR_SALV_ADAPTER               =
     CHANGING
       IT_OUTTAB                     = IT_KAPURHOL1
       IT_FIELDCATALOG               = it_fieldcat
*       IT_SORT                       =
*       IT_FILTER                     =
     EXCEPTIONS
       INVALID_PARAMETER_COMBINATION = 1
       PROGRAM_ERROR                 = 2
       TOO_MANY_LINES                = 3
       OTHERS                        = 4
           .
   IF SY-SUBRC <> 0.
*    Implement suitable error handling here
   ENDIF.

"CONTAINER 3

 IF g_cont3 IS NOT BOUND.

    CREATE OBJECT g_cont3
      EXPORTING
        container_name              = 'ALV3_SHIRWAL'                 " Name of the Screen CustCtrl Name to Link Container To
      EXCEPTIONS
        cntl_error                  = 1                " CNTL_ERROR
        cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
        create_error                = 3                " CREATE_ERROR
        lifetime_error              = 4                " LIFETIME_ERROR
        lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
        OTHERS                      = 6.
ENDIF.

 CHECK g_cont3 IS BOUND.

   CREATE OBJECT g_grid3
    EXPORTING
      i_parent          = g_cont3              " Parent Container
    EXCEPTIONS
      error_cntl_create = 1                " Error when creating the control
      error_cntl_init   = 2                " Error While Initializing Control
      error_cntl_link   = 3                " Error While Linking Control
      error_dp_create   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.

  CHECK g_grid3 IS BOUND.

     CALL METHOD g_grid3->SET_TABLE_FOR_FIRST_DISPLAY
*     EXPORTING
*       I_BUFFER_ACTIVE               =
*       I_BYPASSING_BUFFER            =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME              =
*       IS_VARIANT                    =
*       I_SAVE                        =
*       I_DEFAULT                     = 'X'
*       IS_LAYOUT                     =
*       IS_PRINT                      =
*       IT_SPECIAL_GROUPS             =
*       IT_TOOLBAR_EXCLUDING          =
*       IT_HYPERLINK                  =
*       IT_ALV_GRAPHICS               =
*       IT_EXCEPT_QINFO               =
*       IR_SALV_ADAPTER               =
     CHANGING
       IT_OUTTAB                     = IT_SHIRWAL2
       IT_FIELDCATALOG               = it_fieldcat
*       IT_SORT                       =
*       IT_FILTER                     =
     EXCEPTIONS
       INVALID_PARAMETER_COMBINATION = 1
       PROGRAM_ERROR                 = 2
       TOO_MANY_LINES                = 3
       OTHERS                        = 4
           .
   IF SY-SUBRC <> 0.
*    Implement suitable error handling here
   ENDIF.

   "CONTAINER 4

   IF g_cont4 IS NOT BOUND.

    CREATE OBJECT g_cont4
      EXPORTING
        container_name              = 'ALV4_KAPURHOL'                 " Name of the Screen CustCtrl Name to Link Container To
      EXCEPTIONS
        cntl_error                  = 1                " CNTL_ERROR
        cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
        create_error                = 3                " CREATE_ERROR
        lifetime_error              = 4                " LIFETIME_ERROR
        lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
        OTHERS                      = 6.
ENDIF.

 CHECK g_cont4 IS BOUND.

   CREATE OBJECT g_grid4
    EXPORTING
      i_parent          = g_cont4               " Parent Container
    EXCEPTIONS
      error_cntl_create = 1                " Error when creating the control
      error_cntl_init   = 2                " Error While Initializing Control
      error_cntl_link   = 3                " Error While Linking Control
      error_dp_create   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.

  CHECK g_grid4 IS BOUND.

     CALL METHOD g_grid4->SET_TABLE_FOR_FIRST_DISPLAY
*     EXPORTING
*       I_BUFFER_ACTIVE               =
*       I_BYPASSING_BUFFER            =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME              =
*       IS_VARIANT                    =
*       I_SAVE                        =
*       I_DEFAULT                     = 'X'
*       IS_LAYOUT                     =
*       IS_PRINT                      =
*       IT_SPECIAL_GROUPS             =
*       IT_TOOLBAR_EXCLUDING          =
*       IT_HYPERLINK                  =
*       IT_ALV_GRAPHICS               =
*       IT_EXCEPT_QINFO               =
*       IR_SALV_ADAPTER               =
     CHANGING
       IT_OUTTAB                     = IT_KAPURHOL2
       IT_FIELDCATALOG               = it_fieldcat
*       IT_SORT                       =
*       IT_FILTER                     =
     EXCEPTIONS
       INVALID_PARAMETER_COMBINATION = 1
       PROGRAM_ERROR                 = 2
       TOO_MANY_LINES                = 3
       OTHERS                        = 4
           .
   IF SY-SUBRC <> 0.
*    Implement suitable error handling here
   ENDIF.



ENDMODULE.
