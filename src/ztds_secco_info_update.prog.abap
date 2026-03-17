*&---------------------------------------------------------------------*
*& Report ZTDS_SECCO_INFO_UPDATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTDS_SECCO_INFO_UPDATE.

type-pools: truxs.
tables: sscrfields.
types : begin of record,
          bukrs(4),  "companycode
*KOART
          accno(10), "V/C accnt
*FIWTIN_TANEX_SUB
          seccode(4), "Sect. Code
          witht(2), "Withhld tax type
          wt_withcd(2), "W/tax code

          wt_exnr(25), "Exemption number
          wt_exrt(10), "Exemption rate
          wt_wtexrs(2), " Exemption reas.
          fiwtin_exem_thr(20), "Exem threshold
          waers(5), "Currency
          wt_exdf(10), " exempt from
*PAN_NO
          wt_exdt(10), " Exempt To
        end of record.

data : it_upload type table of record.
data : wa_upload type record.
data : wa_excel type alsmex_tabline, "Excel data
       t_excel  type standard table of alsmex_tabline.
data : it_msg  type table of bdcmsgcoll,
       it_msg1 type table of bdcmsgcoll,
       wa_msg  type bdcmsgcoll,
       wa_msg1 type bdcmsgcoll.
data: it_tan type table of fiwtin_tan_exem,
      wa_tan type fiwtin_tan_exem.
data: it_tan1 type table of fiwtin_tan_exem,
      wa_tan1 type fiwtin_tan_exem.

data: begin of wa_header,
        name type c length 30,
      end of wa_header.

data: t_header like table of wa_header.

"TYPES:BEGIN OF ty_data,
*        order            TYPE aufnr,
*        order_type       TYPE aufart,
*        order_name       TYPE auftext,
*        co_area          TYPE kokrs,
*        comp_code        TYPE bukrs,
*        bus_area         TYPE gsber,
*        plant            TYPE werks_d,
*        profit_ctr       TYPE prctr,
**        s_ord_item       TYPE kdpos,
*        currency         TYPE aufwaers,
**        estimated_costs  TYPE aufuser4bapi,
**        processing_group TYPE aufabkrs,
**        statistical      TYPE aufstkz,
*        objectclass      TYPE scope_cv,
*
*      END OF ty_data.


types:begin of ty_data,
        bukrs           type bukrs,
        accno           type aufart,
        seccode	        type secco,
        witht           type witht,
        wt_withcd       type wt_withcd,
        wt_exnr         type wt_exnr,
        wt_exrt         type wt_exrt,
        wt_wtexrs       type wt_wtexrs,
*        s_ord_item       TYPE kdpos,
        fiwtin_exem_thr type fiwtin_exem_thr,
*        estimated_costs  TYPE aufuser4bapi,
*        processing_group TYPE aufabkrs,
*        statistical      TYPE aufstkz,
        waers           type waers,

      end of ty_data.


data : t_data type ty_data occurs 0 with header line.




types:begin of error_type,
        bukrs     type bukrs,
*KOART  type  KOART,
        accno     type   wt_acno,
*FIWTIN_TANEX_SUB  type   FIWTIN_TANEX_SUB
        seccode   type   secco,
        witht     type  witht,
        wt_withcd type wt_withcd,
        wt_exdf   type wt_exdf,
        pan_no    type j_1ipanno,
        text      type string,       " text
      end of error_type.

data: it_error type table of error_type,
      wa_error type error_type.

data : it_raw type truxs_t_text_data.

data: lv_prog   type sy-repid,
      gd_layout type slis_layout_alv,
      wa_fcat   type slis_fieldcat_alv,
      it_fcat   type slis_t_fieldcat_alv.


constants:
*abap_true TYPE abap_bool VALUE 'X',
  grid_tit  type lvc_title value 'Error Details'.

selection-screen: function key 1.

initialization.
  sscrfields-functxt_01 = 'Download Template'.


  selection-screen begin of block blck with frame title text-000.
    parameters : f_path   type rlgrap-filename.
*PARAMETERS : CBOX     AS CHECKBOX DEFAULT 'X'.
    " File Path
  selection-screen end of block blck.



at selection-screen.
  case sy-ucomm.
    when 'FC01'. " 'FC01' maps to FUNCTION KEY 1
      perform download_template.
  endcase.

at selection-screen on value-request for f_path.


  call function 'F4_FILENAME'
    exporting
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = 'F_PATH'
    importing
      file_name     = f_path.


start-of-selection.

  perform get_data.
  perform upload_data.
  perform error_disp.

form get_data.

  types:fs_struct(4096) type c occurs 0.
  data:w_struct type fs_struct.

  call function 'TEXT_CONVERT_XLS_TO_SAP'
    exporting
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = w_struct
      i_filename           = f_path
    tables
      i_tab_converted_data = it_upload
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
    message id sy-msgid type 'S' number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form upload_data .


  loop at it_upload into wa_upload.


    move-corresponding wa_upload to wa_tan.

    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = wa_tan-accno
      importing
        output = wa_tan-accno.


    wa_tan-mandt = sy-mandt.

    select single j_1ipanno from lfa1 into wa_tan-pan_no where lifnr = wa_tan-accno.

    wa_tan-koart = 'K'.

    concatenate wa_upload-wt_exdf+6(4) wa_upload-wt_exdf+3(2) wa_upload-wt_exdf+0(2)
        into wa_tan-wt_exdf.

    concatenate wa_upload-wt_exdt+6(4) wa_upload-wt_exdt+3(2) wa_upload-wt_exdt+0(2)
        into wa_tan-wt_exdt.

    append wa_tan to it_tan.
    clear wa_tan.


  endloop.

  if it_tan is not initial.

    try.
        insert fiwtin_tan_exem from table it_tan ."ACCEPTING DUPLICATE KEYS.
        if sy-subrc = 0.
          commit work.
          message 'Uplaoded Successfully' type 'I'.
        else.
          message 'Error' type 'I'.
        endif.

      catch cx_root.

        select * from fiwtin_tan_exem into table it_tan1
           for all entries in it_tan where bukrs = it_tan-bukrs
and accno = it_tan-accno
and seccode = it_tan-seccode
and witht = it_tan-witht
and wt_withcd = it_tan-wt_withcd
        and wt_exdf = it_tan-wt_exdf
        and pan_no = it_tan-pan_no.

        loop at it_tan into wa_tan.

          read table it_tan1 into wa_tan1 with key bukrs = wa_tan-bukrs
                                    accno = wa_tan-accno
                                    seccode = wa_tan-seccode
                                    witht = wa_tan-witht
                                    wt_withcd = wa_tan-wt_withcd
                                    wt_exdf = wa_tan-wt_exdf
                                    pan_no = wa_tan-pan_no.
          if sy-subrc = 0.
            wa_error-bukrs = wa_tan1-bukrs.
            wa_error-accno = wa_tan1-accno.
            wa_error-seccode = wa_tan1-seccode.
            wa_error-witht = wa_tan1-witht.
            wa_error-wt_withcd = wa_tan1-wt_withcd.
            wa_error-wt_exdf = wa_tan1-wt_exdf.
            wa_error-pan_no = wa_tan1-pan_no.
            wa_error-text = 'Duplicate Record'.
            append wa_error to it_error.
            clear wa_error.
          endif.

        endloop.

        message 'Duplicate Record found' type 'I'.


    endtry.

  endif.



endform.

*&---------------------------------------------------------------------*
*&      Form  ERROR_DISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form error_disp .
  lv_prog = sy-repid.
  gd_layout-zebra = 'X'.
  gd_layout-colwidth_optimize = 'X'.

  perform build_fcat using 'BUKRS'  'Company Code'  .
  perform build_fcat using 'ACCNO'  'Vendor/customer account number'  .
  perform build_fcat using 'SECCODE'  'Section Code'  .
  perform build_fcat using 'WITHT'  'Indicator for wh tax type'  .
  perform build_fcat using 'WT_WITHCD'  'Withholding tax code'  .
  perform build_fcat using 'WT_EXDF'  'Exemption from'  .
  perform build_fcat using 'PAN_NO'  'Pan Number'  .
  perform build_fcat using 'TEXT'  'Error Description'  .

  if it_error is not initial.
    call function 'REUSE_ALV_GRID_DISPLAY'
      exporting
        i_callback_program = lv_prog
        i_grid_title       = grid_tit
        is_layout          = gd_layout
        it_fieldcat        = it_fcat[]
      tables
        t_outtab           = it_error[]
      exceptions
        program_error      = 1
        others             = 2.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
  endif.
endform.


form build_fcat using fieldname
                      text.
  clear wa_fcat.
  wa_fcat-fieldname   = fieldname.
  wa_fcat-seltext_l   = text.
  append wa_fcat to it_fcat.
  clear wa_fcat.
endform.


*&---------------------------------------------------------------------*
*& Form download_template
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form download_template .
  perform fill_cell using 1 1   1 text-003.
  perform fill_cell using 1 2   1 text-004.
  perform fill_cell using 1 3   1 text-005.
  perform fill_cell using 1 4   1 text-006.
  perform fill_cell using 1 5   1 text-007.
  perform fill_cell using 1 6   1 text-008.
  perform fill_cell using 1 7   1 text-009.
  perform fill_cell using 1 8   1 text-010.
  perform fill_cell using 1 9   1 text-011.
  perform fill_cell using 1 10  1 text-012.
  perform fill_cell using 1 11  1 text-013.
  perform fill_cell using 1 12  1 text-014.
*    PERFORM fill_cell USING 1 13  1 TEXT-015.
*  perform fill_cell using 1 11  1 text-016.
  perform down_excel.
endform.
*&---------------------------------------------------------------------*
*& Form fill_cell
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_1
*&      --> P_1
*&      --> P_1
*&      --> TEXT_003
*&---------------------------------------------------------------------*
*form fill_cell  using    value(p_1   )
*                         value(p_1   )
*                         value(p_1   )
*                         p_text_003.
*
**  CALL METHOD OF h_excel 'CELLS' = h_zl
**EXPORTING
**  #1 = P_i
**  #2 = P_j.
**  SET PROPERTY OF h_zl 'Value' = P_val.
**  GET PROPERTY OF h_zl 'Font'  = h_f.
**  SET PROPERTY OF h_f  'Bold'  = P_bold.
*
*  APPEND P_val TO t_header.
*
*
*endform.

*&---------------------------------------------------------------------*
*& Form fill_cell
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_1
*&      --> P_1
*&      --> P_1
*&      --> TEXT_003
*&---------------------------------------------------------------------*
form fill_cell using p_i p_j p_bold p_val.

*  CALL METHOD OF h_excel 'CELLS' = h_zl
*EXPORTING
*  #1 = P_i
*  #2 = P_j.
*  SET PROPERTY OF h_zl 'Value' = P_val.
*  GET PROPERTY OF h_zl 'Font'  = h_f.
*  SET PROPERTY OF h_f  'Bold'  = P_bold.

  append p_val to t_header.

endform.

*&---------------------------------------------------------------------*
*& Form down_excel
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form down_excel .

  data: lv_filename      type string,
        lv_path          type string,
        lv_fullpath      type string,
        lv_result        type i,
        lv_default_fname type string,
        lv_fname         type string.

  call method cl_gui_frontend_services=>file_save_dialog
    exporting
      window_title      = 'File Directory'
      default_extension = 'XLS'
      initial_directory = 'D:\'
    changing
      filename          = lv_filename
      path              = lv_path
      fullpath          = lv_fullpath
      user_action       = lv_result.

  lv_fname = lv_fullpath.

*download file in excel
  call function 'GUI_DOWNLOAD'
    exporting
      bin_filesize            = ''
      filename                = lv_fname
      filetype                = 'DAT'
    tables
      data_tab                = t_data
      fieldnames              = t_header
    exceptions
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      others                  = 22.
  if sy-subrc <> 0.
    message: 'Error To Upload Excel' type 'E' .
  endif.

endform.
