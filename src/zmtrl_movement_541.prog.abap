*&---------------------------------------------------------------------*
*& Report ZMTRL_MOVEMENT_541
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
***************Below Report is developed for need dump for 541 movement type
******From table J_1IG_SUBCON for only India ( PL01) plant .
*&Report: ZMTRL_MOVEMENT_541
*&Transaction :ZMTRL_MOVEMENT
*&Functional Cosultant: MEghana Barhate
*&Technical Consultant: Jyoti MAhajan
*&TR: 1.DEVK915897       PRIMUSABAP   PRIMUS:INDIA:101690:ZMTRL_MOVEMENT:541 &542 DUMP NEW REPORT
*&Date: 1. 09.04.2025
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmtrl_movement_541.

TABLES : j_1ig_subcon.

DATA : it_j_1ig_subcon TYPE TABLE OF j_1ig_subcon,
       gr_table        TYPE REF TO cl_salv_table.

TYPES : BEGIN OF ty_down,
          mandt     TYPE string,
          bukrs     TYPE string,
          mblnr     TYPE string,
          mjahr     TYPE string,
          zeile     TYPE string,
          seq_no    TYPE string,
          chln_inv  TYPE string,
          item      TYPE string,
          fkart     TYPE string,
          budat     TYPE string,
          bwart     TYPE string,
          werks     TYPE string,
          menge     TYPE string,
          gr_rqty   TYPE string,
          meins     TYPE string,
          ch_qty    TYPE string,
          ch_oqty   TYPE string,
          ch_meins  TYPE string,
          matnr     TYPE string,
          lifnr     TYPE string,
          rec_qty   TYPE string,
          rec_meins TYPE string,
          status    TYPE string,
          ernam     TYPE string,
          erdat     TYPE string,
          cputm     TYPE string,
          aenam     TYPE string,
          aedat     TYPE string,
          utime     TYPE string,
          sobkz     TYPE string,
          ref_date        TYPE string,
          ref_time        TYPE string,
        END OF ty_down.

DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE ty_down.


CONSTANTS : c_plant TYPE char4 VALUE 'PL01',
            c_bwart TYPE char3 VALUE '541',
            c_path  TYPE char50 VALUE '/Delval/India'.    "'E:\delval\temp'.

INITIALIZATION.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
  PARAMETERS : p_werks TYPE j_1ig_subcon-werks DEFAULT c_plant MODIF ID bu.
  SELECT-OPTIONS :  s_matnr FOR j_1ig_subcon-matnr,
                    s_budat FOR j_1ig_subcon-budat.
  SELECTION-SCREEN END OF BLOCK b2.
  SELECTION-SCREEN END OF BLOCK b1.

  SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT c_path.
  SELECTION-SCREEN END OF BLOCK b3.

  SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN END OF BLOCK b4.

**********below logic for gray out the default valuse
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  SELECT *
  FROM j_1ig_subcon
  INTO TABLE it_j_1ig_subcon
  WHERE werks = p_werks
    AND matnr IN s_matnr
    AND budat IN s_budat
    AND bwart = '541'.

  IF p_down = 'X'.
    LOOP AT it_j_1ig_subcon INTO DATA(wa_j_1ig_subcon).
      wa_down-mandt     = wa_j_1ig_subcon-mandt    .
      wa_down-bukrs     = wa_j_1ig_subcon-bukrs    .
      wa_down-mblnr     = wa_j_1ig_subcon-mblnr    .
      wa_down-mjahr     = wa_j_1ig_subcon-mjahr    .
      wa_down-zeile     = wa_j_1ig_subcon-zeile    .
      wa_down-seq_no    = wa_j_1ig_subcon-seq_no   .
      wa_down-chln_inv  = wa_j_1ig_subcon-chln_inv .
      wa_down-item      = wa_j_1ig_subcon-item     .
      wa_down-fkart     = wa_j_1ig_subcon-fkart    .
*      wa_down-budat     = wa_j_1ig_subcon-budat    .
       IF wa_j_1ig_subcon-budat  IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_j_1ig_subcon-budat
          IMPORTING
            output = wa_down-budat.

        CONCATENATE wa_down-budat+0(2) wa_down-budat+2(3) wa_down-budat+5(4)
                        INTO wa_down-budat SEPARATED BY '-'.
       endif.


      wa_down-bwart     = wa_j_1ig_subcon-bwart    .
      wa_down-werks     = wa_j_1ig_subcon-werks    .
      wa_down-menge     = wa_j_1ig_subcon-menge    .
      wa_down-gr_rqty   = wa_j_1ig_subcon-gr_rqty  .
      wa_down-meins     = wa_j_1ig_subcon-meins    .
      wa_down-ch_qty    = wa_j_1ig_subcon-ch_qty   .
      wa_down-ch_oqty   = wa_j_1ig_subcon-ch_oqty  .
      wa_down-ch_meins  = wa_j_1ig_subcon-ch_meins .
      wa_down-matnr     = wa_j_1ig_subcon-matnr    .
      wa_down-lifnr     = wa_j_1ig_subcon-lifnr    .
      wa_down-rec_qty   = wa_j_1ig_subcon-rec_qty  .
      wa_down-rec_meins = wa_j_1ig_subcon-rec_meins.
      wa_down-status    = wa_j_1ig_subcon-status   .
      wa_down-ernam     = wa_j_1ig_subcon-ernam    .
*      wa_down-erdat     = wa_j_1ig_subcon-erdat    .
       IF wa_j_1ig_subcon-erdat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_j_1ig_subcon-erdat
          IMPORTING
            output = wa_down-erdat .

        CONCATENATE wa_down-erdat+0(2) wa_down-erdat+2(3) wa_down-erdat+5(4)
                        INTO wa_down-erdat SEPARATED BY '-'.
       endif.
*      wa_down-cputm     = wa_j_1ig_subcon-cputm    .
        CONCATENATE wa_j_1ig_subcon-cputm+0(2) ':' wa_j_1ig_subcon-cputm+2(2) ':' wa_j_1ig_subcon-cputm+4(2)  INTO wa_down-cputm.
      wa_down-aenam     = wa_j_1ig_subcon-aenam    .
      wa_down-aedat     = wa_j_1ig_subcon-aedat    .
        IF wa_j_1ig_subcon-aedat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_j_1ig_subcon-aedat
          IMPORTING
            output = wa_down-aedat .

        CONCATENATE wa_down-aedat+0(2) wa_down-aedat+2(3) wa_down-aedat+5(4)
                        INTO wa_down-aedat SEPARATED BY '-'.
       endif.
*      wa_down-utime     = wa_j_1ig_subcon-utime    .
      CONCATENATE wa_j_1ig_subcon-utime+0(2) ':' wa_j_1ig_subcon-utime+2(2) ':' wa_j_1ig_subcon-utime+4(2)  INTO wa_down-utime.

      wa_down-sobkz     = wa_j_1ig_subcon-sobkz    .


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.

      CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                      INTO wa_down-ref_date SEPARATED BY '-'.

*      wa_down-ref_time = sy-uzeit.
      CONCATENATE sy-uzeit+0(2) ':' sy-uzeit+2(2) ':' sy-uzeit+4(2)  INTO wa_down-ref_time.

       APPEND wa_down TO it_down.
      CLEAR :wa_down, wa_j_1ig_subcon.
    ENDLOOP.
  ENDIF.

 data: lr_columns type ref to cl_salv_columns_table,
        lr_column  type ref to cl_salv_column_table.
  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = gr_table
        CHANGING
          t_table      = it_j_1ig_subcon[].
    CATCH cx_salv_msg .
  ENDTRY.

*  data: gr_table   type ref to cl_salv_table.

  lr_columns = gr_table->get_columns( ).
  try.
    lr_column ?= lr_columns->get_column( 'SEQ_NO' ).
    lr_column->set_short_text( 'Seq. No' ).
    lr_column->set_medium_text( 'Sequence No' ).
   lr_column->set_long_text( 'Sequence No' ).
   catch cx_salv_not_found.
     endtry.



  CALL METHOD gr_table->set_screen_status
    EXPORTING
      report        = sy-repid
      pfstatus      = 'ZPF_STATUS' "your PF Status name
      set_functions = gr_table->c_functions_all.

  CALL METHOD gr_table->display.
*  break primusabap.
 if p_down = 'X'.
    PERFORM DOWNLOAD.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

  lv_file = 'ZMTRL_MOVEMENT_541.TXT'.

  CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

  WRITE: / 'ZMTRL_MOVEMENT_541.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CLOSE DATASET lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Client'
              'Company Code'
              'Number of Material Document'
              'Material Document Year'
              'Item in Material Document'
              'Sequence Number'
              'Challan Number'
              'Challan Item'
              'Billing Type'
              'Posting Date in the Document'
              'Movement type (inventory management)'
              'Plant'
              'Quantity'
              'GR Remaining Quantity'
              'Base Unit of Measure'
              'Quantity'
              'Challan Quantity Open for Reconciliation'
              'Base Unit of Measure'
              'Material Number'
              'Account Number of Vendor or Creditor'
              'Challan Reconciled Quantity'
              'Base Unit of Measure'
              'Subcontracting Status'
              'Name of Person Who Created the Object'
              'Date on Which Record Was Created'
              'Time of Entry'
              'Name of person who changed object'
              'Date of Last Change'
              'Time changed'
              'Special Stock Indicator'
              'Refreshable Date'
              'Refreshable Time'
               INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
*ENDFORM.
