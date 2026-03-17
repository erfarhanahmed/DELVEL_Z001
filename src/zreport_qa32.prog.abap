*&---------------------------------------------------------------------*
*& Report ZREPORT_QA32
*
*&---------------------------------------------------------------------*
*&Developed By Pratiksha Sawant on 19.02.2026
*&---------------------------------------------------------------------*
REPORT ZREPORT_QA32.
TABLES: AUFK.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: P_WERKS TYPE WERKS_D DEFAULT 'PL01'.
  PARAMETERS: P_INSP  TYPE QMART DEFAULT '04'.

  SELECT-OPTIONS: S_OTYPE FOR AUFK-AUART,
                  S_UDDAT FOR SY-DATUM,  " UD Posting Date From–To
                  S_MIGO  FOR SY-DATUM.  " MIGO DATE FROM -TO
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN COMMENT /1(60) TEXT-004.
SELECTION-SCREEN END OF BLOCK B3.

TYPES: BEGIN OF TY_FINAL,
         KDAUF                  TYPE AUFK-KDAUF,   " Sales Order No
         KDPOS                  TYPE AUFK-KDPOS,  " Sales Order Item
         KUNNR                  TYPE VBAK-KUNNR,  " Customer Code
         NAME1                  TYPE KNA1-NAME1,  " Customer Name
         AGING_DAYS             TYPE I,           "Aging Days
         MBLNR                  TYPE MATDOC-MBLNR, "Document No
         MATNR                  TYPE MATDOC-MATNR, " Item Code
         MAKTX                  TYPE MAKT-MAKTX,   " Item Description
         BLDAT                  TYPE MATDOC-BLDAT, "Document Date
         BLDAT_TXT              TYPE CHAR11,                 " document date format like 05 feb 2026 added by ps on 05.03.2026
         INSPECTIONLOT          TYPE I_INSPECTIONLOT-INSPECTIONLOT, "Inspection lot
         VDATUM                 TYPE QAVE-VDATUM,  "UD Date
         VDATUM_TXT             TYPE CHAR11,       " ud date format like 05 feb 2026 added by ps on 05.03.2026
         INSPECTIONLOTORIGIN    TYPE I_INSPECTIONLOT-INSPECTIONLOTORIGIN, "Inspection Type
         AUFNR                  TYPE AUFK-AUFNR, "Order No
         AUART                  TYPE AUFK-AUART, "Order Type
         STOCK_QTY              TYPE MATDOC-STOCK_QTY, "Received QTY
         STOCK_QTY_TXT TYPE CHAR15,
         SGTXT                  TYPE MATDOC-SGTXT, "Inspected By
         LINETXT                TYPE STRING, "QA Remark
         ZSERIES                TYPE MARA-ZSERIES, "Series
         ZSIZE                  TYPE MARA-ZSIZE, "Size
         BRAND                  TYPE MARA-BRAND, "Brand
         KURZTEXT               TYPE QPCT-KURZTEXT, "UD Code Description
         WERKS                  TYPE MATDOC-WERKS, "Plant
         REFRESH_DATE           TYPE CHAR11,
         REFRESH_TIME           TYPE SY-UZEIT,
         MATLDOCLATESTPOSTGDATE TYPE I_INSPECTIONLOT-MATLDOCLATESTPOSTGDATE,
         STATUSCODE             TYPE I_INSPECTIONLOTSTATUS1-STATUSCODE,
         PRUEFLOS               TYPE QAVE-PRUEFLOS,
         VCODEGRP               TYPE QAVE-VCODEGRP,
         VCODE                  TYPE QAVE-VCODE,
         VBELN                  TYPE VBAK-VBELN,
         LBBSA_SID              TYPE MATDOC-LBBSA_SID,
*         SGTXT_321              TYPE MATDOC-SGTXT,  " For 321 movement text
         CODEGRUPPE             TYPE QPCT-CODEGRUPPE,
         CODE                   TYPE QPCT-CODE,
         MJAHR                  TYPE MATDOC-MJAHR,

       END OF TY_FINAL,
       TTY_FINAL TYPE STANDARD TABLE OF TY_FINAL.

TYPES : BEGIN OF TY_FINAL2 ,
          KDAUF               TYPE AUFK-KDAUF,   " Sales Order No
          KDPOS               TYPE AUFK-KDPOS,  " Sales Order Item
          KUNNR               TYPE VBAK-KUNNR,  " Customer Code
          NAME1               TYPE KNA1-NAME1,  " Customer Name
          AGING_DAYS          TYPE I,           "Aging Days
          MBLNR               TYPE MATDOC-MBLNR, "Document No
          MATNR               TYPE MATDOC-MATNR, " Item Code
          MAKTX               TYPE MAKT-MAKTX,   " Item Description
*          BLDAT               TYPE MATDOC-BLDAT, "Document Date
          BLDAT_TXT           TYPE CHAR11,                 " document date format like 05 feb 2026 added by ps on 05.03.2026
          INSPECTIONLOT       TYPE I_INSPECTIONLOT-INSPECTIONLOT, "Inspection lot
*          VDATUM              TYPE QAVE-VDATUM,  "UD Date
          VDATUM_TXT          TYPE CHAR11,       " ud date format like 05 feb 2026 added by ps on 05.03.2026
          INSPECTIONLOTORIGIN TYPE I_INSPECTIONLOT-INSPECTIONLOTORIGIN, "Inspection Type
          AUFNR               TYPE AUFK-AUFNR, "Order No
          AUART               TYPE AUFK-AUART, "Order Type
*          STOCK_QTY           TYPE string, "MATDOC-STOCK_QTY, "Received QTY
          STOCK_QTY_TXT TYPE CHAR15,
          SGTXT               TYPE MATDOC-SGTXT, "Inspected By
          LINETXT             TYPE STRING, "QA Remark
          ZSERIES             TYPE MARA-ZSERIES, "Series
          ZSIZE               TYPE MARA-ZSIZE, "Size
          BRAND               TYPE MARA-BRAND, "Brand
          KURZTEXT            TYPE QPCT-KURZTEXT, "UD Code Description
          WERKS               TYPE MATDOC-WERKS, "Plant
          REFRESH_DATE        TYPE CHAR11,
          REFRESH_TIME        TYPE SY-UZEIT,


        END OF TY_FINAL2  ,

        TY_FINAL1 TYPE STANDARD   TABLE OF TY_FINAL2.

DATA :GT_FINAL2   TYPE STANDARD TABLE OF TY_FINAL2.

TYPES: BEGIN OF TY_MATDOC_321,
         AUFNR TYPE MATDOC-AUFNR,
         MATNR TYPE MATDOC-MATNR,
         SGTXT TYPE MATDOC-SGTXT,
       END OF TY_MATDOC_321.

DATA: GT_FINAL      TYPE STANDARD TABLE OF TY_FINAL,
      GT_MATDOC_321 TYPE STANDARD TABLE OF TY_MATDOC_321,
      GT_FIELDCAT   TYPE SLIS_T_FIELDCAT_ALV,
      GS_FIELDCAT   TYPE SLIS_FIELDCAT_ALV.


START-OF-SELECTION.
  PERFORM FETCH_DATA_WITH_JOINS.

  IF GT_FINAL IS NOT INITIAL.
    PERFORM ENRICH_ADDITIONAL_DATA.
    PERFORM DISPLAY_OUTPUT.

    CLEAR GT_FINAL2.
*    MOVE-CORRESPONDING GT_FINAL TO GT_FINAL2.
CLEAR: GT_FINAL2.
  gt_final2 = VALUE #(
    FOR wa_final IN gt_final
    ( CORRESPONDING #(
*        BASE ( VALUE #( stock_qty = condense(
         BASE ( VALUE #( stock_qty_TXT = condense(
                                   val     =  |{ wa_final-stock_qty }|
                                     ) ) )
        wa_final
      ) )
  ).
    IF P_DOWN = 'X'.
      PERFORM DOWNLOAD TABLES GT_FINAL2 USING P_FOLDER.
    ENDIF.
  ELSE.
    MESSAGE 'No data found for the given selection criteria' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

*----------------------------------------------------------------------*
*       FORM fetch_data_with_joins
*----------------------------------------------------------------------*
FORM FETCH_DATA_WITH_JOINS.
  SELECT
    M~MBLNR,
    M~MATNR,
    M~MJAHR,
    M~BLDAT,
    M~STOCK_QTY,
    M~WERKS,
    M~LBBSA_SID,
    M~SGTXT,
    A~AUFNR,
    A~AUART,
    A~KDAUF,
    A~KDPOS,
    MA~ZSERIES,
    MA~ZSIZE,
    MA~BRAND,
    MK~MAKTX,
    IL~INSPECTIONLOT,
    IL~INSPECTIONLOTORIGIN,
    V~VBELN,
    V~KUNNR,
    K~NAME1
FROM MATDOC AS M
    INNER JOIN AUFK AS A ON  A~AUFNR = M~AUFNR
    LEFT OUTER JOIN MARA AS MA ON MA~MATNR = M~MATNR

  LEFT OUTER JOIN MAKT AS MK  ON  MK~MATNR = M~MATNR
                              AND MK~SPRAS = @SY-LANGU

  "INNER JOIN
   INNER JOIN I_INSPECTIONLOT AS IL
    ON  IL~MATERIALDOCUMENT     = M~MBLNR
    AND IL~MATERIALDOCUMENTYEAR = M~MJAHR
    AND IL~INSPECTIONLOTORIGIN  = @P_INSP

  LEFT OUTER JOIN VBAK AS V  ON V~VBELN = A~KDAUF
  LEFT OUTER JOIN KNA1 AS K  ON K~KUNNR = V~KUNNR
  LEFT  OUTER JOIN QAVE AS VE ON VE~PRUEFLOS = IL~INSPECTIONLOT
                             AND VE~KZART = 'L'
                             AND VE~ZAEHLER = @SPACE
  WHERE
*      M~BUDAT IN @S_UDDAT AND
    M~BUDAT IN @S_MIGO
    AND M~BWART = '101'
    AND M~WERKS = @P_WERKS
    AND M~AUFNR IS NOT INITIAL
    AND A~AUART IN @S_OTYPE
    AND VE~VDATUM IN @S_UDDAT
     AND NOT EXISTS (
        SELECT INSPECTIONLOT
          FROM I_INSPECTIONLOTSTATUS1 AS ILS
          WHERE ILS~INSPECTIONLOT = IL~INSPECTIONLOT
            AND ILS~STATUSCODE = 'I0224'
      )
INTO CORRESPONDING FIELDS OF TABLE @GT_FINAL.


  IF SY-SUBRC <> 0 OR GT_FINAL IS INITIAL.
    MESSAGE 'No data found for the given selection criteria' TYPE 'S' DISPLAY LIKE 'W'.
    RETURN.
  ENDIF.
  SELECT AUFNR, MATNR, SGTXT
    FROM MATDOC
    WHERE BUDAT IN @S_UDDAT
*    AND BUDAT IN @S_MIGO
      AND BWART = '321'
      AND WERKS = @P_WERKS
      AND LBBSA_SID = '01'
      AND AUFNR IS NOT INITIAL
      AND SGTXT IS NOT INITIAL
    INTO CORRESPONDING FIELDS OF TABLE @GT_MATDOC_321.

  SORT GT_MATDOC_321 BY AUFNR MATNR .

  FIELD-SYMBOLS: <FS_FINAL> TYPE TY_FINAL.
  DATA: LS_MATDOC_321 TYPE TY_MATDOC_321.

  LOOP AT GT_FINAL ASSIGNING <FS_FINAL>.
    IF <FS_FINAL>-BLDAT IS NOT INITIAL.
      <FS_FINAL>-AGING_DAYS = SY-DATUM - <FS_FINAL>-BLDAT.
    ENDIF.
    WRITE <FS_FINAL>-STOCK_QTY TO <FS_FINAL>-STOCK_QTY_TXT DECIMALS 2.  " added by ps on 12.03.2026
  REPLACE ALL OCCURRENCES OF ',' IN <FS_FINAL>-STOCK_QTY_TXT WITH ''.
    READ TABLE GT_MATDOC_321 INTO LS_MATDOC_321
      WITH KEY AUFNR = <FS_FINAL>-AUFNR
               MATNR = <FS_FINAL>-MATNR
      BINARY SEARCH.
    IF SY-SUBRC = 0.
      <FS_FINAL>-SGTXT = LS_MATDOC_321-SGTXT."LS_MATDOC_321-SGTXT.
    ENDIF.

    IF <FS_FINAL>-KUNNR IS NOT INITIAL.
      IF <FS_FINAL>-KUNNR+0(4) = '0000'.
        <FS_FINAL>-KUNNR = <FS_FINAL>-KUNNR+4.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.


FORM ENRICH_ADDITIONAL_DATA.

  DATA: LT_INSPECTIONLOT TYPE STANDARD TABLE OF I_INSPECTIONLOT-INSPECTIONLOT,
        LT_QAVE          TYPE TABLE OF QAVE,
        LT_QPCT          TYPE TABLE OF QPCT,
        LV_LONG_TEXT     TYPE STRING,
        LV_TEXTNAME      TYPE THEAD-TDNAME,
        LT_LINES         TYPE TABLE OF TLINE,
        LS_QAVE          TYPE QAVE,
        LS_QPCT          TYPE QPCT,
        LS_LINE          TYPE TLINE.

  FIELD-SYMBOLS: <FS_FINAL> TYPE TY_FINAL.

  LT_INSPECTIONLOT = VALUE #( FOR <LOT> IN GT_FINAL
                              WHERE ( INSPECTIONLOT IS NOT INITIAL )
                            ( <LOT>-INSPECTIONLOT ) ).
  SORT LT_INSPECTIONLOT.
  DELETE ADJACENT DUPLICATES FROM LT_INSPECTIONLOT.

  IF LT_INSPECTIONLOT IS NOT INITIAL.

    SELECT *
      FROM QAVE
      FOR ALL ENTRIES IN @LT_INSPECTIONLOT
      WHERE PRUEFLOS = @LT_INSPECTIONLOT-TABLE_LINE
        AND VDATUM IN @S_UDDAT
      INTO TABLE @LT_QAVE.
    SORT LT_QAVE BY PRUEFLOS.

    IF LT_QAVE IS NOT INITIAL.
      SELECT *
        FROM QPCT
        FOR ALL ENTRIES IN @LT_QAVE
        WHERE CODEGRUPPE = @LT_QAVE-VCODEGRP
          AND CODE       = @LT_QAVE-VCODE
          AND SPRACHE    = @SY-LANGU
        INTO TABLE @LT_QPCT.
      SORT LT_QPCT BY CODEGRUPPE CODE.
    ENDIF.
    LOOP AT GT_FINAL ASSIGNING <FS_FINAL>
      WHERE INSPECTIONLOT IS NOT INITIAL.

      READ TABLE LT_QAVE INTO LS_QAVE
        WITH KEY PRUEFLOS = <FS_FINAL>-INSPECTIONLOT
        BINARY SEARCH.
      IF SY-SUBRC = 0.
        <FS_FINAL>-VCODEGRP = LS_QAVE-VCODEGRP.
        <FS_FINAL>-VCODE    = LS_QAVE-VCODE.
        <FS_FINAL>-VDATUM   = LS_QAVE-VDATUM.
        READ TABLE LT_QPCT INTO LS_QPCT
          WITH KEY CODEGRUPPE = LS_QAVE-VCODEGRP
                   CODE       = LS_QAVE-VCODE
          BINARY SEARCH.
        IF SY-SUBRC = 0.
          <FS_FINAL>-KURZTEXT = LS_QPCT-KURZTEXT.
          <FS_FINAL>-CODE     = LS_QPCT-CODE.
        ENDIF.
      ENDIF.
      CLEAR: LV_LONG_TEXT, LV_TEXTNAME, LT_LINES.
      LV_TEXTNAME = |{ SY-MANDT }{ <FS_FINAL>-INSPECTIONLOT }L|.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          CLIENT                  = SY-MANDT
          ID                      = 'QAVE'
          LANGUAGE                = 'E'
          NAME                    = LV_TEXTNAME
          OBJECT                  = 'QPRUEFLOS'
        TABLES
          LINES                   = LT_LINES
        EXCEPTIONS
          ID                      = 1
          LANGUAGE                = 2
          NAME                    = 3
          NOT_FOUND               = 4
          OBJECT                  = 5
          REFERENCE_CHECK         = 6
          WRONG_ACCESS_TO_ARCHIVE = 7
          OTHERS                  = 8.

      IF SY-SUBRC = 0.
        LOOP AT LT_LINES INTO LS_LINE.
          LV_LONG_TEXT = |{ LV_LONG_TEXT } { LS_LINE-TDLINE }|.
        ENDLOOP.
        <FS_FINAL>-LINETXT = LV_LONG_TEXT.
      ENDIF.
      PERFORM FORMAT_DATE USING SY-DATUM
                       CHANGING <FS_FINAL>-REFRESH_DATE.
*    <FS_FINAL>-REFRESH_DATE = sy-DATUM.
      <FS_FINAL>-REFRESH_TIME = SY-UZEIT.

      PERFORM FORMAT_DATE USING <FS_FINAL>-BLDAT
                        CHANGING <FS_FINAL>-BLDAT_TXT.

      PERFORM FORMAT_DATE USING <FS_FINAL>-VDATUM
                          CHANGING <FS_FINAL>-VDATUM_TXT.
    ENDLOOP.

  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
*       FORM display_output
*----------------------------------------------------------------------*
FORM DISPLAY_OUTPUT.
  PERFORM BUILD_FIELDCATALOG.

  IF GT_FINAL IS NOT INITIAL.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        IT_FIELDCAT = GT_FIELDCAT
      TABLES
        T_OUTTAB    = GT_FINAL
      EXCEPTIONS
        OTHERS      = 1.

    IF SY-SUBRC <> 0.
      MESSAGE 'Error displaying ALV grid' TYPE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'No data to display' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------*
*       FORM build_fieldcatalog
*----------------------------------------------------------------------*
FORM BUILD_FIELDCATALOG.
  DEFINE ADD_FIELD.
    CLEAR GS_FIELDCAT.
    GS_FIELDCAT-FIELDNAME = &1.
    GS_FIELDCAT-SELTEXT_M = &2.
    GS_FIELDCAT-OUTPUTLEN = &3.
    GS_FIELDCAT-JUST      = 'L'.
*    GS_FIELDCAT-KEY       = 'X'.
    APPEND GS_FIELDCAT TO GT_FIELDCAT.
  END-OF-DEFINITION.

  ADD_FIELD 'KDAUF'        'Sales Order No'         15.
  ADD_FIELD 'KDPOS'        'Sales Order Item'       15.
  ADD_FIELD 'KUNNR'        'Customer Code '         15.
  ADD_FIELD 'NAME1'        'Customer Name'          15.
  ADD_FIELD 'AGING_DAYS'   'Aging Days'             10.
  ADD_FIELD 'MBLNR'        'Document No'            10.
  ADD_FIELD 'MATNR'        'Item Code'              15.
  ADD_FIELD 'MAKTX'        'Item Description'       15.
*  ADD_FIELD 'BLDAT'        'Document Date'          15.
  ADD_FIELD 'BLDAT_TXT'    'Document Date'          15.
  ADD_FIELD 'INSPECTIONLOT' 'Inspection Lot'        15.
*  ADD_FIELD 'VDATUM'       'UD Date'                15.
  ADD_FIELD 'VDATUM_TXT'    'UD Date'               15.
  ADD_FIELD 'INSPECTIONLOTORIGIN' 'Inspection Type' 12.
  ADD_FIELD 'AUFNR'        'Order No'               10.
  ADD_FIELD 'AUART'        'Order Type'             10.
*  ADD_FIELD 'STOCK_QTY'    'Received QTY'           10.
  ADD_FIELD 'STOCK_QTY_TXT' 'Received QTY'          10.
  ADD_FIELD 'SGTXT'        'Inspected By'           12.
  ADD_FIELD 'LINETXT'      'QA Remark'              15.
  ADD_FIELD 'ZSERIES'      'Series'                  5.
  ADD_FIELD 'ZSIZE'        'Size'                    5.
  ADD_FIELD 'BRAND'        'Brand'                   5.
  ADD_FIELD 'KURZTEXT'     'UD Code Description'    15.
  ADD_FIELD 'WERKS'        'Plant'                   7.

  READ TABLE GT_FIELDCAT INTO GS_FIELDCAT WITH KEY FIELDNAME = 'STOCK_QTY'.
  IF SY-SUBRC = 0.
    GS_FIELDCAT-DECIMALS_OUT = 2.
    GS_FIELDCAT-NO_CONVEXT = 'X'.
    MODIFY GT_FIELDCAT FROM GS_FIELDCAT INDEX SY-TABIX.
  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
*       FORM download
*----------------------------------------------------------------------*
FORM DOWNLOAD TABLES GT_FINAL2 TYPE  TY_FINAL1 USING P_FOLDER." TTY_FINAL
  TYPE-POOLS TRUXS.

  DATA: IT_CSV      TYPE TRUXS_T_TEXT_DATA,
        WA_CSV      TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV      TYPE LINE OF TRUXS_T_TEXT_DATA,
        LV_FILE     TYPE STRING,
        LV_FULLFILE TYPE STRING,
        LV_MSG      TYPE STRING,
        LV_STRING   TYPE STRING,
        LV_CRLF     TYPE STRING.



  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      I_TAB_SAP_DATA       = GT_FINAL2
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.

  IF SY-SUBRC <> 0.
    MESSAGE 'Error converting data to CSV format' TYPE 'E'.
    RETURN.
  ENDIF.

  " Build filename using string template
*  LV_FILE = |ZQA32_details_{ P_WERKS }.TXT|.
  LV_FILE = |ZQA32_details| & |_| & |{ P_WERKS }| & |.TXT|.

  CONCATENATE P_FOLDER '/' LV_FILE INTO LV_FULLFILE.
  PERFORM CVS_HEADER USING HD_CSV.
  OPEN DATASET LV_FULLFILE FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
*  OPEN DATASET LV_FULLFILE FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
  IF SY-SUBRC = 0.
    LV_CRLF = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING = HD_CSV.

    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING LV_CRLF WA_CSV INTO LV_STRING.
    ENDLOOP.

    TRANSFER LV_STRING TO LV_FULLFILE.
    CLOSE DATASET LV_FULLFILE.

    LV_MSG = |File { LV_FULLFILE } downloaded successfully|.
    MESSAGE LV_MSG TYPE 'S'.
    WRITE: / 'ZREPORT_QA32', SY-DATUM, 'at', SY-UZEIT.
    WRITE: / LV_MSG.
  ELSE.
    MESSAGE 'Error opening file for download' TYPE 'E'.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------*
*       FORM cvs_header
*----------------------------------------------------------------------*
FORM CVS_HEADER USING PD_CSV.
  DATA: L_FIELD_SEPERATOR TYPE C.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
*  L_FIELD_SEPERATOR = ','.

  CONCATENATE 'Sales Order No' 'Sales Order Item' 'Customer Code' 'Customer Name'
              'Aging Days' 'Document No' 'Item Code' 'Item Description'
              'Document Date' 'Inspection lot' 'UD Date' 'Inspection Type'
              'Order No' 'Order Type' 'Received QTY' 'Inspected By'
              'QA Remark' 'Series' 'Size' 'Brand' 'UD Code Description' 'Plant' 'Refresh Date' 'Refresh Time'
    INTO PD_CSV SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.

FORM FORMAT_DATE USING    IV_DATE TYPE SY-DATUM
                 CHANGING CV_TEXT TYPE CHAR11.

  DATA: LV_MONTH TYPE STRING.

  CLEAR CV_TEXT.

  "If date is initial, keep it blank
  IF IV_DATE IS INITIAL.
    RETURN.
  ENDIF.

  CASE IV_DATE+4(2).
    WHEN '01'. LV_MONTH = 'Jan'.
    WHEN '02'. LV_MONTH = 'Feb'.
    WHEN '03'. LV_MONTH = 'Mar'.
    WHEN '04'. LV_MONTH = 'Apr'.
    WHEN '05'. LV_MONTH = 'May'.
    WHEN '06'. LV_MONTH = 'Jun'.
    WHEN '07'. LV_MONTH = 'Jul'.
    WHEN '08'. LV_MONTH = 'Aug'.
    WHEN '09'. LV_MONTH = 'Sep'.
    WHEN '10'. LV_MONTH = 'Oct'.
    WHEN '11'. LV_MONTH = 'Nov'.
    WHEN '12'. LV_MONTH = 'Dec'.
  ENDCASE.

  CV_TEXT = |{ IV_DATE+6(2) } { LV_MONTH } { IV_DATE+0(4) }|.

ENDFORM.
