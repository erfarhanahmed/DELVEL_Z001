*&---------------------------------------------------------------------*
*& Include          ZUS_STOCKFI_NEW_AMDP_FCAT
*&---------------------------------------------------------------------*
 FORM FCAT .

  PERFORM BUILD_FC USING  '1' PR_COUNT 'MATNR'                 'Material Code'             'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'WRKST'                 'USA Material Code'         'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MATTXT'                'Material Description'      'IT_FINAL'  '50' .
  PERFORM BUILD_FC USING  '1' PR_COUNT 'ERSDA'                 'Material Created Date'     'IT_FINAL'  '20'.

  PERFORM BUILD_FC USING  '1' PR_COUNT 'OPEN_QTY'              'Pending SO '               'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'OPEN_QTY_V'            'Pending So Sales Total'    'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'PRICE'                 'Pending So Value'          'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'UN_QTY'                'Unrestricted Quantity'     'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'UN_VAL'                'Unrestricted Value'          'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'LABST'                 'Stock In Hand'             'IT_FINAL'  '15'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'LABST_V'               'Stock In Hand Value'       'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'KULAB'                 'Consignment Stock'         'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'KULAB_V'               'Consignment Stock Value'   'IT_FINAL'  '20'.
*  PERFORM BUILD_FC USING  '1' PR_COUNT 'TRAN_QTY'              'Transit Qty'               'IT_FINAL'  '15'.
*  PERFORM BUILD_FC USING  '1' PR_COUNT 'TRAN_QTY_V'            'Transit Value'             'IT_FINAL'  '15'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'TRAN_QTY_NEW'              'Transit Qty'               'IT_FINAL'  '15'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'TRAN_QTY_V_NEW'            'Transit Value'             'IT_FINAL'  '15'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'FREE_STOCK'            'Free Stock'                'IT_FINAL'  '15'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'FREE_STOCK_V'          'Free Stock Value'          'IT_FINAL'  '15'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'PEND_PO_QTY'           'Pending PO Qty'            'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'SO_FALL_QTY'           'SO Short Fall Qty'         'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'SO_FALL_QTY_V'         'SO Short Fall Qty Value'   'IT_FINAL'  '20'.

*  PERFORM build_fc USING  '1' pr_count 'PO_VALUE'              'Pending PO Amount'         'IT_FINAL'  '20'.
*  PERFORM build_fc USING  '1' pr_count 'INDENT_QTY'            'Indent Qty'                'IT_FINAL'  '20'.
*  PERFORM build_fc USING  '1' pr_count 'INDENT_QTY_V'          'Indent Qty Value'          'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'OPEN_INV'              'Open Invoice Qty'          'IT_FINAL'  '20'.
*  PERFORM build_fc USING  '1' pr_count 'OPEN_INV_V'            'Open Invoice Qty Value'    'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'AMOUNT'                'Last Item Price'           'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'VALUE'                 'Moving Price'              'IT_FINAL'  '20'.

  PERFORM BUILD_FC USING  '1' PR_COUNT 'ZSERIES'               'Series'                    'IT_FINAL'  '5'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MTART'                 'Material Type'             'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'BKLAS'                 'Valuation Class'           'IT_FINAL'  '20'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'BRAND'                 'Brand'                     'IT_FINAL'  '5'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'MOC'                   'MOC'                       'IT_FINAL'  '5'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'ZSIZE'                 'Size'                      'IT_FINAL'  '5'.
  PERFORM BUILD_FC USING  '1' PR_COUNT 'TYPE'                  'Type'                      'IT_FINAL'  '5'.

  PERFORM BUILD_FC USING  '1' PR_COUNT 'MENGE_104'              '104 Qty'                  'IT_FINAL'  '15'."ADDED BY JYOTI ON 28.06.2024
  PERFORM BUILD_FC USING  '1' PR_COUNT 'QTY_104_VAL'              '104 Qty Value'                  'IT_FINAL'  '15'."ADDED BY JYOTI ON 28.06.2024
*    PERFORM BUILD_FC USING  '1' PR_COUNT 'TRAN_QTY_NEW'              'Transit Qty New'               'IT_FINAL'  '15'.
*  PERFORM BUILD_FC USING  '1' PR_COUNT 'TRAN_QTY_V_NEW'            'Transit Value New'             'IT_FINAL'  '15'.



ENDFORM.

FORM BUILD_FC  USING        PR_ROW TYPE I
                            PR_COUNT TYPE I
                            PR_FNAME TYPE STRING
                            PR_TITLE TYPE STRING
                            PR_TABLE TYPE SLIS_TABNAME
                            PR_LENGTH TYPE STRING.

  PR_COUNT = PR_COUNT + 1.
  GS_FIELDCAT-ROW_POS   = PR_ROW.
  GS_FIELDCAT-COL_POS   = PR_COUNT.
  GS_FIELDCAT-FIELDNAME = PR_FNAME.
  GS_FIELDCAT-SELTEXT_L = PR_TITLE.
  GS_FIELDCAT-TABNAME   = PR_TABLE.
  GS_FIELDCAT-OUTPUTLEN = PR_LENGTH.

  APPEND GS_FIELDCAT TO GT_FIELDCAT.
  CLEAR GS_FIELDCAT.

ENDFORM.
