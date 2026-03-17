*&---------------------------------------------------------------------*
*& Report ZSD_EXCISE_INVOICE_TCS_ADOBE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSD_PACKINGLIST_DRVR_ADOBE.

DATA : V_VBELN TYPE VBRK-VBELN,
       XSCREEN TYPE C.
TABLES: NAST, vekp.
DATA: GV_FM_NAME         TYPE RS38L_FNAM, " FM Name
      GS_FP_DOCPARAMS    TYPE SFPDOCPARAMS,
      GS_FP_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS.
 DATA: LS_DLV_DELNOTE        TYPE LEDLV_DELNOTE.
DATA : GV_FORM_NAME TYPE FPNAME.
DATA:CS_DLV_DELNOTE        TYPE LEDLV_DELNOTE.
data: gt_vekp TYPE zgt_vekp1 .
data:IS_PRINT_DATA_TO_READ TYPE LEDLV_PRINT_DATA_TO_READ.
TYPES: BEGIN OF ty_final,
        head type char70,
       END OF ty_final.
Data: lt_final type STANDARD TABLE OF ty_final,
      wa_final type ty_final.
Data :text type char30.
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
ENDFORM.                               "ENTRY

FORM PROCESSING USING    XSCREEN    TYPE C
                CHANGING CF_RETCODE LIKE SY-SUBRC.
  MOVE NAST-OBJKY(10) TO V_VBELN.
DATA: LS_DELIVERY_KEY TYPE  LESHP_DELIVERY_KEY.
  LS_DELIVERY_KEY-VBELN = v_vbeln.
   "" is print
   IS_PRINT_DATA_TO_READ-hd_gen      = 'X'.
   IS_PRINT_DATA_TO_READ-hd_adr      = 'X'.
   IS_PRINT_DATA_TO_READ-hd_org       = 'X'.
   IS_PRINT_DATA_TO_READ-HD_ORG_ADR      = 'X'.

        CALL FUNCTION 'LE_SHP_DLV_OUTP_READ_PRTDATA'
       EXPORTING
            IS_DELIVERY_KEY       = LS_DELIVERY_KEY
            IS_PRINT_DATA_TO_READ = IS_PRINT_DATA_TO_READ
            IF_PARVW              = NAST-PARVW
            IF_PARNR              = NAST-PARNR
            IF_LANGUAGE           = NAST-SPRAS
       IMPORTING
            ES_DLV_DELNOTE        = CS_DLV_DELNOTE
       EXCEPTIONS
            RECORDS_NOT_FOUND     = 1
            RECORDS_NOT_REQUESTED = 2
            OTHERS                = 3.


*    GV_FORM_NAME = 'ZSD_PACKING_LIST_EXPORT_FORM'.
    GV_FORM_NAME = 'ZSD_PACKINGLIST_EXPORTFORM_NEW'.

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

*-----------------------------------------------------------------------------

 SELECT * FROM VEKP INTO TABLE GT_VEKP
                       WHERE VPOBJKEY = LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.

*  IF CF_RETCODE = 0.

  CALL FUNCTION GV_FM_NAME "'/1BCDWB/SM00000018'
    EXPORTING
      /1BCDWB/DOCPARAMS = GS_FP_DOCPARAMS
      LV_VBELN          = V_VBELN
      IS_DLV_DELNOTE       = CS_DLV_DELNOTE
      IS_NAST              = NAST
       GT_VEKP            = GT_VEKP
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
*&---------------------------------------------------------------------*
ENDFORM.
