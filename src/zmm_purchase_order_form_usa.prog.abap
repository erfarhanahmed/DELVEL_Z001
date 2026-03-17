*&---------------------------------------------------------------------*
*& Report ZMM_PURCHASE_ORDER_FORM_USA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_PURCHASE_ORDER_FORM_USA.
DATA : V_EBELN TYPE EKKO-EBELN,
       XSCREEN TYPE C.
TABLES: NAST.
DATA: GV_FM_NAME         TYPE RS38L_FNAM, " FM Name
      GS_FP_DOCPARAMS    TYPE SFPDOCPARAMS,
      GS_FP_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS.
DATA : GV_FORM_NAME TYPE FPNAME,
 l_druvo       LIKE t166k-druvo,
 l_doc         TYPE meein_purchase_doc_print.
START-OF-SELECTION.

FORM ENTRY USING RETURN_CODE LIKE SY-SUBRC
                 US_SCREEN   TYPE C.
  DATA: LF_RETCODE TYPE SY-SUBRC.
  XSCREEN = US_SCREEN.                 "Screen Used for Display
  PERFORM PROCESSING USING    US_SCREEN
                     CHANGING LF_RETCODE.
  IF LF_RETCODE NE 0.
    RETURN_CODE = 1.
  ELSE.
    RETURN_CODE = 0.
  ENDIF.
ENDFORM.


FORM PROCESSING USING    XSCREEN    TYPE C
                CHANGING CF_RETCODE LIKE SY-SUBRC.
  MOVE NAST-OBJKY(10) TO V_EBELN.
data: l_from_memory,
         l_doc         TYPE meein_purchase_doc_print.
GV_FORM_NAME = 'ZMM_PURCHASE_ORDER_US_FORM'.

 CLEAR CF_RETCODE.
  IF nast-aende EQ space.
    l_druvo = '1'.
  ELSE.
    l_druvo = '2'.
  ENDIF.
CALL FUNCTION 'ME_READ_PO_FOR_PRINTING'
    EXPORTING
      ix_nast        = nast
      ix_screen      = xscreen
    IMPORTING
      ex_retco       = CF_RETCODE
      ex_nast        = nast
      doc            = l_doc
    CHANGING
      cx_druvo       = l_druvo
      cx_from_memory = l_from_memory.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      IE_OUTPUTPARAMS = GS_FP_OUTPUTPARAMS
    EXCEPTIONS
      CANCEL          = 1
      USAGE_ERROR     = 2
      SYSTEM_ERROR    = 3
      INTERNAL_ERROR  = 4
      OTHERS          = 5.
  IF SY-SUBRC <> 0.
    " Suitable Error Handling
  ENDIF.
*&---------------------------------------------------------------------*
**&&~~ Get the Function module name based on Form Name

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      I_NAME     = GV_FORM_NAME
    IMPORTING
      E_FUNCNAME = GV_FM_NAME.
  IF SY-SUBRC <> 0.
    " Suitable Error Handling
  ENDIF.
CALL FUNCTION GV_FM_NAME "'/1BCDWB/SM00000018'
    EXPORTING
      /1BCDWB/DOCPARAMS = GS_FP_DOCPARAMS
      LV_EBELN          = V_EBELN
        ekpo = l_doc-xekpo
        KOMV = l_doc-xtkomv
        EKKO = l_doc-xekko
        eket = l_doc-xeket
* IMPORTING
*     /1BCDWB/FORMOUTPUT       =
    EXCEPTIONS
      USAGE_ERROR       = 1
      SYSTEM_ERROR      = 2
      INTERNAL_ERROR    = 3
      OTHERS            = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
*   ENDDO.


*&---------------------------------------------------------------------*
*&---- Close the spool job
  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      USAGE_ERROR    = 1
      SYSTEM_ERROR   = 2
      INTERNAL_ERROR = 3
      OTHERS         = 4.
  IF SY-SUBRC <> 0.
* <error handling>
  ENDIF.


  ENDFORM.
