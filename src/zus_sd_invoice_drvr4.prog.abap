*----------------------------------------------------------------------*
*      Print of a delivery note by SAPscript SMART FORMS               *
*----------------------------------------------------------------------*
REPORT ZUS_SD_INVOICE_DRVR4.




  DATA: lv_fm_name       TYPE funcname,
        lv_doc_params    TYPE sfpdocparams,
        lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
        ls_form_output   TYPE fpformoutput.
  DATA:       e_funcnm TYPE funcname .
  data : lv_dev type LEDLV_DELNOTE.
* declaration of data
INCLUDE ZRLE_DELNOTE_DATA_DECLARE.
*INCLUDE RLE_DELNOTE_DATA_DECLARE.
* definition of forms
INCLUDE ZRLE_DELNOTE_FORMS.
*INCLUDE RLE_DELNOTE_FORMS.
INCLUDE ZRLE_PRINT_FORMS.
*INCLUDE RLE_PRINT_FORMS.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM ENTRY USING RETURN_CODE US_SCREEN.

  IF CL_SHP_DELIVERY_OUTPUTS=>IS_ENABLED( ).
    MESSAGE E006(VLD) WITH NAST-KSCHL INTO DATA(LV_MESSAGE).
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        MSG_ARBGB = SY-MSGID
        MSG_NR    = SY-MSGNO
        MSG_TY    = SY-MSGTY
        MSG_V1    = SY-MSGV1
        MSG_V2    = SY-MSGV2
        MSG_V3    = SY-MSGV3
        MSG_V4    = SY-MSGV4
      EXCEPTIONS
        OTHERS    = 1.
    RETURN_CODE = 1.
    RETURN.
  ENDIF.

  DATA: LF_RETCODE TYPE SY-SUBRC.
  XSCREEN = US_SCREEN.
  PERFORM PROCESSING USING    US_SCREEN
                     CHANGING LF_RETCODE.
  IF LF_RETCODE NE 0.
    RETURN_CODE = 1.
  ELSE.
    RETURN_CODE = 0.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM PROCESSING USING    PROC_SCREEN
                CHANGING CF_RETCODE.

  DATA: LS_PRINT_DATA_TO_READ TYPE LEDLV_PRINT_DATA_TO_READ.
  DATA: LS_DLV_DELNOTE        TYPE LEDLV_DELNOTE.
  DATA: LF_FM_NAME            TYPE RS38L_FNAM.
  DATA: LS_CONTROL_PARAM      TYPE SSFCTRLOP.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
  DATA: LS_RECIPIENT          TYPE SWOTOBJID.
  DATA: LS_SENDER             TYPE SWOTOBJID.
  DATA: LF_FORMNAME           TYPE TDSFNAME.
  DATA: LS_ADDR_KEY           LIKE ADDR_KEY.

  IF CL_SHP_DELIVERY_OUTPUTS=>IS_ENABLED( ).
    MESSAGE E006(VLD) WITH NAST-KSCHL INTO DATA(LV_MESSAGE).
    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        MSG_ARBGB = SY-MSGID
        MSG_NR    = SY-MSGNO
        MSG_TY    = SY-MSGTY
        MSG_V1    = SY-MSGV1
        MSG_V2    = SY-MSGV2
        MSG_V3    = SY-MSGV3
        MSG_V4    = SY-MSGV4
      EXCEPTIONS
        OTHERS    = 1.
    CF_RETCODE = 1.
    RETURN.
  ENDIF.

* SmartForm from customizing table TNAPR
  LF_FORMNAME = TNAPR-SFORM.

* determine print data
  PERFORM SET_PRINT_DATA_TO_READ USING    LF_FORMNAME
                                 CHANGING LS_PRINT_DATA_TO_READ
                                 CF_RETCODE.

*  IF CF_RETCODE = 0.
* select print data
    PERFORM GET_DATA USING    LS_PRINT_DATA_TO_READ
                     CHANGING LS_ADDR_KEY
                              LS_DLV_DELNOTE
                              CF_RETCODE.
*  ENDIF.

*  IF CF_RETCODE = 0.
    PERFORM SET_PRINT_PARAM USING    LS_ADDR_KEY
                            CHANGING LS_CONTROL_PARAM
                                     LS_COMPOSER_PARAM
                                     LS_RECIPIENT
                                     LS_SENDER
                                     CF_RETCODE.
*  ENDIF.



LF_FORMNAME = 'ZUS_SD_DEL_CHALLAN_SFP'.
*  IF CF_RETCODE = 0.
* determine smartform function module for delivery note
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*         EXPORTING  FORMNAME           = LF_FORMNAME
**                 variant            = ' '
**                 direct_call        = ' '
*         IMPORTING  FM_NAME            = LF_FM_NAME
*         EXCEPTIONS NO_FORM            = 1
*                    NO_FUNCTION_MODULE = 2
*                    OTHERS             = 3.

  "ADDITION OF CODE BY MADHAVI
  lv_output_params-DEVICE = 'PRINTER'.
  lv_output_params-DEST = 'LP01'.
  IF SY-UCOMM = 'PRNT'.
    lv_output_params-NODIALOG = 'X'.
    lv_output_params-PREVIEW = ''.
    lv_output_params-REQIMM = 'X'.
  ELSE.
    lv_output_params-NODIALOG = ''.
    lv_output_params-PREVIEW = 'X'.
  ENDIF.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lv_output_params
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.



   CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
     EXPORTING
       i_name                     =  LF_FORMNAME
    IMPORTING
      E_FUNCNAME                 = LF_FM_NAME
*      E_INTERFACE_TYPE           =
*      EV_FUNCNAME_INBOUND        =
             .



    IF SY-SUBRC <> 0.
*   error handling
      CF_RETCODE = SY-SUBRC.
      PERFORM PROTOCOL_UPDATE.
    ENDIF.
*  ENDIF.

*  IF CF_RETCODE = 0.
*   call smartform delivery note
*    CALL FUNCTION LF_FM_NAME
*         EXPORTING
*                  ARCHIVE_INDEX        = TOA_DARA
*                  ARCHIVE_PARAMETERS   = ARC_PARAMS
*                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
**                 mail_appl_obj        =
*                  MAIL_RECIPIENT       = LS_RECIPIENT
*                  MAIL_SENDER          = LS_SENDER
*                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
*                  USER_SETTINGS        = ' '
*                  IS_DLV_DELNOTE       = LS_DLV_DELNOTE
*                  IS_NAST              = NAST
**      importing  document_output_info =
**                 job_output_info      =
**                 job_output_options   =
*       EXCEPTIONS FORMATTING_ERROR     = 1
*                  INTERNAL_ERROR       = 2
*                  SEND_ERROR           = 3
*                  USER_CANCELED        = 4
*                  OTHERS               = 5.

*ls_dlv_delnote-hd_gen-deliv_numb = nast-objky.
*ls_dlv_delnote-hd_gen-sold_to_party = nast-parnr.


CALL FUNCTION   LF_FM_NAME                     "'/1BCDWB/SM00000099'
  EXPORTING
*   /1BCDWB/DOCPARAMS        =
    archive_index            = TOA_DARA
    archive_parameters       = ARC_PARAMS
    control_parameters       = LS_CONTROL_PARAM
    mail_recipient           = LS_RECIPIENT
    mail_sender              = LS_SENDER
    user_settings            = ' '
    output_options           = LS_COMPOSER_PARAM
    is_dlv_delnote           = Ls_dlv_delnote
    is_nast                  = nast
* IMPORTING
*   /1BCDWB/FORMOUTPUT       =
 EXCEPTIONS
   USAGE_ERROR              = 1
   SYSTEM_ERROR             = 2
   INTERNAL_ERROR           = 3
   OTHERS                   = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.







    IF SY-SUBRC <> 0.
*   error handling
      CF_RETCODE = SY-SUBRC.
      PERFORM PROTOCOL_UPDATE.
*     get SmartForm protocoll and store it in the NAST protocoll
      PERFORM ADD_SMFRM_PROT.                  "INS_HP_335958
    ENDIF.
*  ENDIF.

  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  IF sy-subrc <> 0.
    MESSAGE 'Error closing Adobe form job' TYPE 'E'.
  ENDIF.


* get SmartForm protocoll and store it in the NAST protocoll
* PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958

ENDFORM.
