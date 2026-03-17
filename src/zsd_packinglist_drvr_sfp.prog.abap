*&---------------------------------------------------------------------*
*& Report ZSD_PACKINGLIST_DRVR1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsd_packinglist_drvr_sfp.

TABLES: vekp.
DATA: gt_vekp LIKE vekp OCCURS 0 WITH HEADER LINE.

*----------------------------------------------------------------------*
*      PRINT OF A DELIVERY NOTE BY SAPSCRIPT SMART FORMS               *
*----------------------------------------------------------------------*
*REPORT RLE_DELNOTE.

* DECLARATION OF DATA
INCLUDE rle_delnote_data_declare.
* DEFINITION OF FORMS
INCLUDE rle_delnote_forms.
INCLUDE rle_print_forms.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM entry USING return_code us_screen.

  DATA: lf_retcode TYPE sy-subrc.
  xscreen = us_screen.
  PERFORM processing USING    us_screen
                     CHANGING lf_retcode.
  IF lf_retcode NE 0.
    return_code = 1.
  ELSE.
    return_code = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM processing USING    proc_screen
                CHANGING cf_retcode.

  DATA: ls_print_data_to_read TYPE ledlv_print_data_to_read.
  DATA: ls_dlv_delnote        TYPE ledlv_delnote.
  DATA: lf_fm_name            TYPE rs38l_fnam.
  DATA: ls_control_param      TYPE ssfctrlop.
  DATA: ls_composer_param     TYPE ssfcompop.
  DATA: ls_recipient          TYPE swotobjid.
  DATA: ls_sender             TYPE swotobjid.
  DATA: lf_formname           TYPE tdsfname.
  DATA: ls_addr_key           LIKE addr_key.

* SMARTFORM FROM CUSTOMIZING TABLE TNAPR
  lf_formname = tnapr-sform.

* DETERMINE PRINT DATA
  PERFORM set_print_data_to_read USING    lf_formname
                                 CHANGING ls_print_data_to_read
                                 cf_retcode.

*  IF cf_retcode = 0.
* SELECT PRINT DATA
    PERFORM get_data USING    ls_print_data_to_read
                     CHANGING ls_addr_key
                              ls_dlv_delnote
                              cf_retcode.
*  ENDIF.

*  IF cf_retcode = 0.
    PERFORM set_print_param USING    ls_addr_key
                            CHANGING ls_control_param
                                     ls_composer_param
                                     ls_recipient
                                     ls_sender
                                     cf_retcode.
*  ENDIF.

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  DATA: lv_fm_name       TYPE funcname,
        lv_doc_params    TYPE sfpdocparams,
        lv_output_params TYPE sfpoutputparams,
*      lv_control_params TYPE sfpcontrol,
        ls_form_output   TYPE fpformoutput.
  DATA:       e_funcnm TYPE funcname .             " Name of the Function Module
  CONSTANTS : sf_name1 TYPE fpname VALUE 'ZINITIAL_ORDER_SFP'.


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
*IF SY-UNAME = 'CTPLFARHAN'.
**lf_formname = 'ZSD_PACKING_LIST_EXPORT_SFP_F1R'.
*ENDIF.
*  IF cf_retcode = 0.
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = lf_formname "" 'ZADOBE_SAMPLE_FORM'  " Your Adobe form name
      IMPORTING
        e_funcname = e_funcnm.

    IF sy-subrc <> 0.
*   ERROR HANDLING
      cf_retcode = sy-subrc.
      PERFORM protocol_update.
    ENDIF.
*  ENDIF.


  SELECT * FROM vekp INTO TABLE gt_vekp
                      WHERE vpobjkey = ls_dlv_delnote-hd_gen-deliv_numb.

*  IF cf_retcode = 0.


    CALL FUNCTION    e_funcnm  "'/1BCDWB/SM00000129'
      EXPORTING
*       /1BCDWB/DOCPARAMS        =
        user_settings  = ' '
        is_dlv_delnote = ls_dlv_delnote
        is_nast        = nast
*     IMPORTING
*       /1BCDWB/FORMOUTPUT       =
*     EXCEPTIONS
*       USAGE_ERROR    = 1
*       SYSTEM_ERROR   = 2
*       INTERNAL_ERROR = 3
*       OTHERS         = 4
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
      cf_retcode = sy-subrc.
      PERFORM protocol_update.
*     GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
      PERFORM add_smfrm_prot.                  "INS_HP_335958
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




*
** DETERMINE SMARTFORM FUNCTION MODULE FOR DELIVERY NOTE
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = lf_formname
**     VARIANT            = ' '
**     DIRECT_CALL        = ' '
*    IMPORTING
*      fm_name            = lf_fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
**   ERROR HANDLING
*    cf_retcode = sy-subrc.
*    PERFORM protocol_update.
*  ENDIF.
*ENDIF.
*
*SELECT * FROM vekp INTO TABLE gt_vekp
*                     WHERE vpobjkey = ls_dlv_delnote-hd_gen-deliv_numb.
*
*  IF cf_retcode = 0.
**   CALL SMARTFORM DELIVERY NOTE
*
**    CALL FUNCTION LF_FM_NAME
**      EXPORTING
**   ARCHIVE_INDEX        = TOA_DARA
**                  ARCHIVE_PARAMETERS   = ARC_PARAMS
**                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
***                 MAIL_APPL_OBJ        =
**                  MAIL_RECIPIENT       = LS_RECIPIENT
**                  MAIL_SENDER          = LS_SENDER
**                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
**                  USER_SETTINGS        = ' '
**                 I_VBELN               =  LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.
**                    NAST              = NAST
***     IMPORTING
***       DOCUMENT_OUTPUT_INFO       =
***       JOB_OUTPUT_INFO            =
***       JOB_OUTPUT_OPTIONS         =
***     EXCEPTIONS
***       FORMATTING_ERROR           = 1
***       INTERNAL_ERROR             = 2
***       SEND_ERROR                 = 3
***       USER_CANCELED              = 4
***       OTHERS                     = 5
**              .
**    IF SY-SUBRC <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***    ENDIF.
**
*
*    CALL FUNCTION lf_fm_name
*      EXPORTING
*        archive_index      = toa_dara
*        archive_parameters = arc_params
*        control_parameters = ls_control_param
**       MAIL_APPL_OBJ      =
*        mail_recipient     = ls_recipient
*        mail_sender        = ls_sender
*        output_options     = ls_composer_param
*        user_settings      = ' '
*        is_dlv_delnote     = ls_dlv_delnote
*        is_nast            = nast
*      TABLES
*        gt_vekp            = gt_vekp
*      EXCEPTIONS
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        OTHERS             = 5.
*    IF sy-subrc <> 0.
**   ERROR HANDLING
*      cf_retcode = sy-subrc.
*      PERFORM protocol_update.
**     GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
*      PERFORM add_smfrm_prot.                  "INS_HP_335958
*    ENDIF.
*  ENDIF.




* GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
* PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958

ENDFORM.                    "PROCESSING
