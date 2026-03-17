*&---------------------------------------------------------------------*
*& Include          ZUS_STOCKFI_NEW_AMDP_DISP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_DATA .
 cALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM     = SY-REPID
      I_CALLBACK_TOP_OF_PAGE = 'TOP-OF-PAGE'
      IT_FIELDCAT            = GT_FIELDCAT
      I_SAVE                 = 'X'
    TABLES
      T_OUTTAB               = LT_ET_SORT  "IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR          = 1
*     OTHERS                 = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
*  IF P_DOWN = 'X'.
*
**    PERFORM DOWNLOAD.
**    PERFORM gui_download.
*  ENDIF.
ENDFORM.
