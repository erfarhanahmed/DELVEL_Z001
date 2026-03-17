*&---------------------------------------------------------------------*
*& Include          ZUS_MATERIAL_EXTENSION_SUB
*&---------------------------------------------------------------------*
FORM download_excel .

  ls_data-field1 = 'Material Number'.
  ls_data-field2 = 'Industry Sector'.
  ls_data-field3 = 'Material Type'.
  ls_data-field4 = 'Plant'.
  ls_data-field5 = 'Purchasing Group'.
  ls_data-field6 = 'MRP Profile'.
  ls_data-field7 = 'MRP Type'.
  ls_data-field8 = 'MRP Controller'.
  ls_data-field9 = 'Planned Delivery Time in Days'.
  ls_data-field10 = 'GR PR Time'.
  ls_data-field11 = 'Period Indicator'.
  ls_data-field12 = 'Lot size Key'.
  ls_data-field13 = 'Procurement Type'.
  ls_data-field14 = 'SM Key'.
  ls_data-field15 = 'Checking Group for Availability Check'.
  ls_data-field16 = 'Profit Center'.
  ls_data-field17 = 'Storage Location'.
  ls_data-field18 = 'Price control indicator'.
  ls_data-field19 = 'Moving price'.
  ls_data-field20 = 'Standard price'.
  ls_data-field21 = 'Price unit'.
  ls_data-field22 = 'Valuation Class'.
  ls_data-field23 = 'Moving price in Previous Period'.
  ls_data-field24 = 'Standard price in the previous period'.
  ls_data-field25 = 'Price unit of previous period'.
  ls_data-field26 = 'Sales Organization'.
  ls_data-field27 = 'Distribution Channel'.
  ls_data-field28 = 'Minimum order quantity in base unit of measure'.
  ls_data-field29 = 'Minimum delivery quantity in delivery note processing'.
  ls_data-field30 = 'Minimum make-to-order quantity'.
  ls_data-field31 = 'Delivery unit'.
  ls_data-field32 = 'Material Description'.

  APPEND ls_data TO it_data.

  CREATE OBJECT application 'EXCEL.APPLICATION'.
  SET PROPERTY OF application 'VISIBLE' = 1.
  CALL METHOD OF
    application
      'WORKBOOKS' = workbook.

* CREATE NEW WORKSHEET
  SET PROPERTY OF application 'SHEETSINNEWWORKBOOK' = 1.
  CALL METHOD OF
    workbook
    'ADD'.

* CREATE FIRST EXCEL SHEET
  CALL METHOD OF
  application
  'WORKSHEETS' = sheet
  EXPORTING
    #1 = 1.
  CALL METHOD OF
    sheet
    'ACTIVATE'.
  SET PROPERTY OF sheet 'NAME' = 'Material Details'.

  " FILL_DATA
*&---------------------------------------------------------------------*
*&   DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET
*&---------------------------------------------------------------------*

  ld_rowindx = 1. "START AT ROW 1 FOR COLUMN NUMBERS
  LOOP AT it_data INTO ls_data.
    ld_rowindx = sy-tabix . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
    CLEAR ld_colindx.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE ls_data TO <fs>.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
      ld_colindx = sy-index.
      CALL METHOD OF
      sheet
      'CELLS' = cells
      EXPORTING
        #1 = ld_rowindx
        #2 = ld_colindx.
      SET PROPERTY OF cells 'VALUE' = <fs>.
    ENDDO.
  ENDLOOP.

  " DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*&  FORMATTING OF COLUMN NUMBER ROW
*&---------------------------------------------------------------------*

  CALL METHOD OF
  application
  'CELLS' = cell1
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

*END OF RANGE CELL
  CALL METHOD OF
  application
  'CELLS' = cell2
  EXPORTING
    #1 = 1     "DOWN
    #2 = 23.   "COLUMN ACROSS

  CALL METHOD OF
  application
  'RANGE' = range
  EXPORTING
    #1 = cell1
    #2 = cell2.

* SET FONT DETAILS OF RANGE

  GET PROPERTY OF range 'FONT' = font.
  SET PROPERTY OF font 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
  CALL METHOD OF
    range
      'INTERIOR' = shading.
  SET PROPERTY OF shading 'COLORINDEX' = 2. " COLOUR - CHANGE NUMBER FOR DIFF COLOURS
  SET PROPERTY OF shading 'PATTERN' = 1.    " PATTERN - SOLID, STRIPED ETC
  FREE OBJECT shading.

  "END OF FORMATTING OF COLUMN NUMBER ROW

*&*--------------------------------------------------------------------*
*&*  MODIFY PROPERTIES OF CELL RANGE
*&*--------------------------------------------------------------------*

  FREE range.
  CALL METHOD OF application 'CELLS' = cell1  "START CELL
  EXPORTING
    #1 = 1     "DOWN
    #2 = 1.    "ACROSS

  CALL METHOD OF application 'CELLS' = cell2 "END CELL
  EXPORTING
    #1 = 1    "DOWN
    #2 = 32.   "COLUMNS ACROSS

  CALL METHOD OF
  application
  'RANGE' = range
  EXPORTING
    #1 = cell1
    #2 = cell2.


* SET BORDER PROPERTIES OF RANGE
  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1 = '1'.  "LEFT
  SET PROPERTY OF border 'LINESTYLE' = '1'. "LINE STYLE SOLID, DASHED...
  SET PROPERTY OF border 'WEIGHT' = 1.                      "MAX = 4
  FREE OBJECT border.

  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1 = '2'.  "RIGHT
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT border.

  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1 = '3'.   "TOP
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT border.

  CALL METHOD OF
  range
  'BORDERS' = border
  EXPORTING
    #1 = '4'.   "BOTTOM
  SET PROPERTY OF border 'LINESTYLE' = '1'.
  SET PROPERTY OF border 'WEIGHT' = 2.                      "MAX = 4
  FREE OBJECT border.

  " SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *

  CALL METHOD OF application
      'COLUMNS' = column.
  CALL METHOD OF column
    'AUTOFIT'.
  FREE OBJECT column.

  " SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME

  CALL METHOD OF
*      sheet'SAVEAS'
    workbook 'SAVEAS'
    EXPORTING
      #1 = 'C:\\ZMATERIAL_EXTENSION_BAPI_SUB.xls'     "FILENAME
      #2 = 1.                "FILEFORMAT

  FREE OBJECT sheet.
  FREE OBJECT workbook.
  FREE OBJECT application.

  " CELL_BORDER
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BAPI_EXECUTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM bapi_execution .

  LOOP AT itab INTO wa.
    if wa-plant = 'US01' or wa-plant = 'US02' or wa-plant = 'US03' .
    CLEAR : lw_header,lv_plantdata,lv_plantdatax,lv_planningdata,lv_planningdatax,lv_storagelocationdata,
            lv_storagelocationdatax,lv_valuationdata,lv_valuationdatax,lv_salesdata,lv_salesdatax.
    REFRESH : lt_materialdescription.
    lw_header-material = wa-matnr.
    lw_header-ind_sector = wa-ind_sector.
    lw_header-matl_type = wa-matl_type.
    lw_header-basic_view = 'X'.
    lw_header-sales_view = 'X'.
    lw_header-purchase_view = 'X'.
    lw_header-mrp_view = 'X'.
    lw_header-storage_view = 'X'.
    lw_header-account_view = 'X'.

    lv_plantdata-plant = wa-plant.
    lv_plantdata-pur_group = wa-pur_group.
    lv_plantdata-mrpprofile = wa-mrp_profile.
    lv_plantdata-mrp_type = wa-mrp_type.
    lv_plantdata-mrp_ctrler = wa-mrp_ctrler.
    lv_plantdata-plnd_delry = wa-plnd_delry.
    lv_plantdata-gr_pr_time = wa-gr_pr_time.
    lv_plantdata-period_ind = wa-period_ind.
    lv_plantdata-lotsizekey = wa-lotsizekey.
    lv_plantdata-proc_type = wa-proc_type.
    lv_plantdata-sm_key = wa-sm_key.
    lv_plantdata-availcheck = wa-availcheck.
    lv_plantdata-profit_ctr = wa-profit_ctr.

    lv_plantdatax-plant = wa-plant.
    lv_plantdatax-pur_group = 'X'.
    lv_plantdatax-mrpprofile = 'X'.
    lv_plantdatax-mrp_type = 'X'.
    lv_plantdatax-mrp_ctrler = 'X'.
    lv_plantdatax-plnd_delry = 'X'.
    lv_plantdatax-gr_pr_time = 'X'.
    lv_plantdatax-period_ind = 'X'.
    lv_plantdatax-lotsizekey = 'X'.
    lv_plantdatax-proc_type = 'X'.
    lv_plantdatax-sm_key = 'X'.
    lv_plantdatax-availcheck = 'X'.
    lv_plantdatax-profit_ctr = 'X'.

    lv_planningdata-plant = wa-plant.
    lv_planningdatax-plant = wa-plant.

    lv_storagelocationdata-plant = wa-plant.
    lv_storagelocationdata-stge_loc = wa-stge_loc.

    lv_storagelocationdatax-plant = wa-plant.
    lv_storagelocationdatax-stge_loc = wa-stge_loc.

    lv_valuationdata-val_area = wa-plant.
    lv_valuationdata-price_ctrl = wa-price_ctrl.
    lv_valuationdata-moving_pr = wa-moving_pr.
    lv_valuationdata-std_price = wa-std_price.
    lv_valuationdata-price_unit = wa-price_unit.
    lv_valuationdata-val_class = wa-val_class.
    lv_valuationdata-mov_pr_pp = wa-mov_pr_pp.
    lv_valuationdata-std_pr_pp = wa-std_pr_pp.
     lv_valuationdata-PR_UNIT_PP = wa-PR_UNIT_PP.

    lv_valuationdatax-val_area = wa-plant.
    lv_valuationdatax-price_ctrl = 'X'.
    lv_valuationdatax-moving_pr = 'X'.
    lv_valuationdatax-std_price = 'X'.
    lv_valuationdatax-price_unit = 'X'.
    lv_valuationdatax-val_class = 'X'.
    lv_valuationdatax-mov_pr_pp = 'X'.
    lv_valuationdatax-std_pr_pp = 'X'.
    lv_valuationdatax-std_pr_pp = 'X'.

    lv_salesdata-sales_org = wa-sales_org.
    lv_salesdata-distr_chan = wa-distr_chan.
    lv_salesdata-min_order = wa-min_order.
    lv_salesdata-min_dely = wa-min_dely.
    lv_salesdata-min_mto = wa-min_mto.
    lv_salesdata-dely_unit = wa-dely_unit.

    lv_salesdatax-sales_org = wa-sales_org.
    lv_salesdatax-distr_chan = wa-distr_chan.
    lv_salesdatax-min_order  = 'X'.
    lv_salesdatax-min_dely   = 'X'.
    lv_salesdatax-min_mto    = 'X'.
    lv_salesdatax-dely_unit  = 'X'.

    lt_materialdescription-langu       = sy-langu.
    lt_materialdescription-langu_iso   = sy-langu.
    lt_materialdescription-matl_desc   = wa-matl_desc.
    APPEND lt_materialdescription.

    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata             = lw_header
*       CLIENTDATA           =
*       CLIENTDATAX          =
        plantdata            = lv_plantdata
        plantdatax           = lv_plantdatax
*       FORECASTPARAMETERS   =
*       FORECASTPARAMETERSX  =
        planningdata         = lv_planningdata
        planningdatax        = lv_planningdatax
        storagelocationdata  = lv_storagelocationdata
        storagelocationdatax = lv_storagelocationdatax
        valuationdata        = lv_valuationdata
        valuationdatax       = lv_valuationdatax
*       WAREHOUSENUMBERDATA  =
*       WAREHOUSENUMBERDATAX =
        salesdata            = lv_salesdata
        salesdatax           = lv_salesdatax
*       STORAGETYPEDATA      =
*       STORAGETYPEDATAX     =
*       FLAG_ONLINE          = ' '
*       FLAG_CAD_CALL        = ' '
*       NO_DEQUEUE           = ' '
*       NO_ROLLBACK_WORK     = ' '
*   IMPORTING
*       RETURN               =
      TABLES
        materialdescription  = lt_materialdescription
*       UNITSOFMEASURE       =
*       UNITSOFMEASUREX      =
*       INTERNATIONALARTNOS  =
*       MATERIALLONGTEXT     =
*       TAXCLASSIFICATIONS   =
        returnmessages       = retmat
*       PRTDATA              =
*       PRTDATAX             =
*       EXTENSIONIN          =
*       EXTENSIONINX         =
      .
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*   EXPORTING
*     WAIT          =
      IMPORTING
        return = ret.
IF ret[] IS INITIAL.
      READ TABLE retmat WITH KEY type = 'S' id = 'M3' number = '364'.
*      loop at retmat where type = 'S'." and number = '364'.
*        if retmat-number = '364' and retmat-id = 'M3'."or retmat-number = '160'.
      IF sy-subrc IS INITIAL.
        wa_log-status = retmat-message.
*      ELSE.
*        READ TABLE retmat INDEX 2.
        wa_log-status = retmat-message.
*      ENDIF.
      wa_log-matnr = wa-matnr.
      wa_log-maktx = wa-matl_desc.
      wa_log-werks = wa-plant.
      wa_log-lgort = wa-stge_loc.
      APPEND wa_log TO it_log.
      CLEAR wa_log.
      endif.
        READ TABLE retmat WITH KEY type = 'S' id = 'MG' number = '160'.
*      elseif retmat-number = '160' and retmat-id = 'MG'.
       IF sy-subrc IS INITIAL.
        wa_log-status = retmat-message.
*      ELSE.
*        READ TABLE retmat INDEX 2.
        wa_log-status = retmat-message.
*      ENDIF.
      wa_log-matnr = wa-matnr.
      wa_log-maktx = wa-matl_desc.
      wa_log-werks = wa-plant.
      wa_log-lgort = wa-stge_loc.
      APPEND wa_log TO it_log.
      CLEAR wa_log.

      endif.
*      endloop.

*       READ TABLE retmat WITH KEY type = 'E' id = 'M3' number = '305'.
*       loop at retmat where type = 'E' and id = 'M3' and number = '305'.
       READ TABLE  retmat with KEY type = 'E' id = 'M3' number = '305'.
      IF sy-subrc IS INITIAL.
        wa_log-status = retmat-message.
*      ELSE.
*        READ TABLE retmat INDEX 2.
        wa_log-status = retmat-message.
*      ENDIF.
      wa_log-matnr = wa-matnr.
      wa_log-maktx = wa-matl_desc.
      wa_log-werks = wa-plant.
      wa_log-lgort = wa-stge_loc.
      APPEND wa_log TO it_log.
      CLEAR wa_log.
*      endloop.
      endif.
    ENDIF.
   refresh : retmat.
  ELSE.
  MESSAGE 'BAPI is for only US Plant' TYPE 'E'.
  endif.
    ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .
 IF IT_LOG IS NOT INITIAL.
    PERFORM :  FIELD_CAT USING '01' 'Material'               'MATNR'         'IT_LOG'    '18'.
    PERFORM :  FIELD_CAT USING '02' 'Description'            'MAKTX'         'IT_LOG'    '40'.
    PERFORM :  FIELD_CAT USING '03' 'Plant'                  'WERKS'         'IT_LOG'    '04'.
    PERFORM :  FIELD_CAT USING '04' 'Storage Location'       'LGORT'         'IT_LOG'    '04'.
    PERFORM :  FIELD_CAT USING '05' 'Status'                 'STATUS'        'IT_LOG'    '220'.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        IT_FIELDCAT   = IT_FCAT
      TABLES
        T_OUTTAB      = IT_LOG
      EXCEPTIONS
        PROGRAM_ERROR = 1
        OTHERS        = 2.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.
ENDFORM.


FORM FIELD_CAT  USING  VALUE(PARA1)
                       VALUE(PARA2)
                       VALUE(PARA3)
                       VALUE(PARA4)
                       VALUE(PARA5).
  WA_FCAT-COL_POS      = PARA1.
  WA_FCAT-SELTEXT_L    = PARA2.
  WA_FCAT-FIELDNAME    = PARA3.
  WA_FCAT-TABNAME      = PARA4.
  WA_FCAT-OUTPUTLEN    = PARA5.
  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.

ENDFORM.
