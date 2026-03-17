*&---------------------------------------------------------------------*
*& Report ZMTRL_MOVEMENT_542
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
***************Below Report is developed for need dump for 542 movement type
******From table msegfor only India ( PL01) plant .
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
REPORT : ZMTRL_MOVEMENT_542.

TABLES : MSEG.

DATA : IT_MSEG  TYPE TABLE OF MSEG,
       GR_TABLE TYPE REF TO CL_SALV_TABLE.

TYPES : BEGIN OF TY_DOWN,
          MANDT            TYPE STRING,
          MBLNR            TYPE STRING,
          MJAHR            TYPE STRING,
          ZEILE            TYPE STRING,
          LINE_ID          TYPE STRING,
          PARENT_ID        TYPE STRING,
          LINE_DEPTH       TYPE STRING,
          MAA_URZEI        TYPE STRING,
          BWART            TYPE STRING,
          XAUTO            TYPE STRING,
          MATNR            TYPE STRING,
          WERKS            TYPE STRING,
          LGORT            TYPE STRING,
          CHARG            TYPE STRING,
          INSMK            TYPE STRING,
          ZUSCH            TYPE STRING,
          ZUSTD            TYPE STRING,
          SOBKZ            TYPE STRING,
          LIFNR            TYPE STRING,
          KUNNR            TYPE STRING,
          KDAUF            TYPE STRING,
          KDPOS            TYPE STRING,
          KDEIN            TYPE STRING,
          PLPLA            TYPE STRING,
          SHKZG            TYPE STRING,
          WAERS            TYPE STRING,
          DMBTR            TYPE STRING,
          BNBTR            TYPE STRING,
          BUALT            TYPE STRING,
          SHKUM            TYPE STRING,
          DMBUM            TYPE STRING,
          BWTAR            TYPE STRING,
          MENGE            TYPE STRING,
          MEINS            TYPE STRING,
          ERFMG            TYPE STRING,
          ERFME            TYPE STRING,
          BPMNG            TYPE STRING,
          BPRME            TYPE STRING,
          EBELN            TYPE STRING,
          EBELP            TYPE STRING,
          LFBJA            TYPE STRING,
          LFBNR            TYPE STRING,
          LFPOS            TYPE STRING,
          SJAHR            TYPE STRING,
          SMBLN            TYPE STRING,
          SMBLP            TYPE STRING,
          ELIKZ            TYPE STRING,
          SGTXT            TYPE STRING,
          EQUNR            TYPE STRING,
          WEMPF            TYPE STRING,
          ABLAD            TYPE STRING,
          GSBER            TYPE STRING,
          KOKRS            TYPE STRING,
          PARGB            TYPE STRING,
          PARBU            TYPE STRING,
          KOSTL            TYPE STRING,
          PROJN            TYPE STRING,
          AUFNR            TYPE STRING,
          ANLN1            TYPE STRING,
          ANLN2            TYPE STRING,
          XSKST            TYPE STRING,
          XSAUF            TYPE STRING,
          XSPRO            TYPE STRING,
          XSERG            TYPE STRING,
          GJAHR            TYPE STRING,
          XRUEM            TYPE STRING,
          XRUEJ            TYPE STRING,
          BUKRS            TYPE STRING,
          BELNR            TYPE STRING,
          BUZEI            TYPE STRING,
          BELUM            TYPE STRING,
          BUZUM            TYPE STRING,
          RSNUM            TYPE STRING,
          RSPOS            TYPE STRING,
          KZEAR            TYPE STRING,
          PBAMG            TYPE STRING,
          KZSTR            TYPE STRING,
          UMMAT            TYPE STRING,
          UMWRK            TYPE STRING,
          UMLGO            TYPE STRING,
          UMCHA            TYPE STRING,
          UMZST            TYPE STRING,
          UMZUS            TYPE STRING,
          UMBAR            TYPE STRING,
          UMSOK            TYPE STRING,
          KZBEW            TYPE STRING,
          KZVBR            TYPE STRING,
          KZZUG            TYPE STRING,
          WEUNB            TYPE STRING,
          PALAN            TYPE STRING,
          LGNUM            TYPE STRING,
          LGTYP            TYPE STRING,
          LGPLA            TYPE STRING,
          BESTQ            TYPE STRING,
          BWLVS            TYPE STRING,
          TBNUM            TYPE STRING,
          TBPOS            TYPE STRING,
          XBLVS            TYPE STRING,
          VSCHN            TYPE STRING,
          NSCHN            TYPE STRING,
          DYPLA            TYPE STRING,
          UBNUM            TYPE STRING,
          TBPRI            TYPE STRING,
          TANUM            TYPE STRING,
          WEANZ            TYPE STRING,
          GRUND            TYPE STRING,
          EVERS            TYPE STRING,
          EVERE            TYPE STRING,
          IMKEY            TYPE STRING,
          KSTRG            TYPE STRING,
          PAOBJNR          TYPE STRING,
          PRCTR            TYPE STRING,
          PS_PSP_PNR       TYPE STRING,
          NPLNR            TYPE STRING,
          AUFPL            TYPE STRING,
          APLZL            TYPE STRING,
          AUFPS            TYPE STRING,
          VPTNR            TYPE STRING,
          FIPOS            TYPE STRING,
          SAKTO            TYPE STRING,
          BSTMG            TYPE STRING,
          BSTME            TYPE STRING,
          XWSBR            TYPE STRING,
          EMLIF            TYPE STRING,
          EXBWR            TYPE STRING,
          VKWRT            TYPE STRING,
          AKTNR            TYPE STRING,
          ZEKKN            TYPE STRING,
          VFDAT            TYPE STRING,
          CUOBJ_CH         TYPE STRING,
          EXVKW            TYPE STRING,
          PPRCTR           TYPE STRING,
          RSART            TYPE STRING,
          GEBER            TYPE STRING,
          FISTL            TYPE STRING,
          MATBF            TYPE STRING,
          UMMAB            TYPE STRING,
          BUSTM            TYPE STRING,
          BUSTW            TYPE STRING,
          MENGU            TYPE STRING,
          WERTU            TYPE STRING,
          LBKUM            TYPE STRING,
          SALK3            TYPE STRING,
          VPRSV            TYPE STRING,
          FKBER            TYPE STRING,
          DABRBZ           TYPE STRING,
          VKWRA            TYPE STRING,
          DABRZ            TYPE STRING,
          XBEAU            TYPE STRING,
          LSMNG            TYPE STRING,
          LSMEH            TYPE STRING,
          KZBWS            TYPE STRING,
          QINSPST          TYPE STRING,
          URZEI            TYPE STRING,
          J_1BEXBASE       TYPE STRING,
          MWSKZ            TYPE STRING,
          TXJCD            TYPE STRING,
          EMATN            TYPE STRING,
          J_1AGIRUPD       TYPE STRING,
          VKMWS            TYPE STRING,
          HSDAT            TYPE STRING,
          BERKZ            TYPE STRING,
          MAT_KDAUF        TYPE STRING,
          MAT_KDPOS        TYPE STRING,
          MAT_PSPNR        TYPE STRING,
          XWOFF            TYPE STRING,
          BEMOT            TYPE STRING,
          PRZNR            TYPE STRING,
          LLIEF            TYPE STRING,
          LSTAR            TYPE STRING,
          XOBEW            TYPE STRING,
          GRANT_NBR        TYPE STRING,
          ZUSTD_T156M      TYPE STRING,
          SPE_GTS_STOCK_TY TYPE STRING,
          KBLNR            TYPE STRING,
          KBLPOS           TYPE STRING,
          XMACC            TYPE STRING,
          VGART_MKPF       TYPE STRING,
          BUDAT_MKPF       TYPE STRING,
          CPUDT_MKPF       TYPE STRING,
          CPUTM_MKPF       TYPE STRING,
          USNAM_MKPF       TYPE STRING,
          XBLNR_MKPF       TYPE STRING,
          TCODE2_MKPF      TYPE STRING,
          VBELN_IM         TYPE STRING,
          VBELP_IM         TYPE STRING,
          SGT_SCAT         TYPE STRING,
          SGT_UMSCAT       TYPE STRING,
          SGT_RCAT         TYPE STRING,
          /BEV2/ED_KZ_VER  TYPE STRING,
          /BEV2/ED_USER    TYPE STRING,
          /BEV2/ED_AEDAT   TYPE STRING,
          /BEV2/ED_AETIM   TYPE STRING,
          DISUB_OWNER      TYPE STRING,
          FSH_SEASON_YEAR  TYPE STRING,
          FSH_SEASON       TYPE STRING,
          FSH_COLLECTION   TYPE STRING,
          FSH_THEME        TYPE STRING,
          FSH_UMSEA_YR     TYPE STRING,
          FSH_UMSEA        TYPE STRING,
          FSH_UMCOLL       TYPE STRING,
          FSH_UMTHEME      TYPE STRING,
          SGT_CHINT        TYPE STRING,
          OINAVNW          TYPE STRING,
          OICONDCOD        TYPE STRING,
          CONDI            TYPE STRING,
          WRF_CHARSTC1     TYPE STRING,
          WRF_CHARSTC2     TYPE STRING,
          WRF_CHARSTC3     TYPE STRING,
          REF_DATE         TYPE STRING,
          REF_TIME         TYPE STRING,
        END OF TY_DOWN.

DATA : IT_DOWN TYPE TABLE OF TY_DOWN,
       WA_DOWN TYPE TY_DOWN.


CONSTANTS : C_PLANT TYPE CHAR4 VALUE 'PL01',
            C_BWART TYPE CHAR3 VALUE '542',
            C_PATH  TYPE CHAR50 VALUE '/Delval/India'.

INITIALIZATION.

  SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
    SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME .
      PARAMETERS : P_WERKS TYPE MSEG-WERKS DEFAULT C_PLANT MODIF ID BU.
      SELECT-OPTIONS :  S_MATNR FOR MSEG-MATNR,
                        S_BUDAT FOR MSEG-BUDAT_MKPF.
    SELECTION-SCREEN END OF BLOCK B2.
  SELECTION-SCREEN END OF BLOCK B1.

  SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-002 .
    PARAMETERS P_DOWN AS CHECKBOX.
    PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT C_PATH.
  SELECTION-SCREEN END OF BLOCK B3.

  SELECTION-SCREEN BEGIN OF BLOCK B4 WITH FRAME TITLE TEXT-003.
    SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN END OF BLOCK B4.

**********below logic for gray out the default valuse
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  SELECT *
  FROM MSEG
  INTO TABLE IT_MSEG
  WHERE WERKS = P_WERKS
    AND MATNR IN S_MATNR
    AND BUDAT_MKPF IN S_BUDAT
    AND BWART = C_BWART.

  IF P_DOWN = 'X'.
    LOOP AT IT_MSEG INTO DATA(WA_MSEG).
      MOVE-CORRESPONDING WA_MSEG TO WA_DOWN.
      IF WA_MSEG-BUDAT_MKPF IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_MSEG-BUDAT_MKPF
          IMPORTING
            OUTPUT = WA_DOWN-BUDAT_MKPF.

        CONCATENATE WA_DOWN-BUDAT_MKPF+0(2) WA_DOWN-BUDAT_MKPF+2(3) WA_DOWN-BUDAT_MKPF+5(4)
                        INTO WA_DOWN-BUDAT_MKPF SEPARATED BY '-'.
      ENDIF.

      IF WA_MSEG-CPUDT_MKPF IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            INPUT  = WA_MSEG-CPUDT_MKPF
          IMPORTING
            OUTPUT = WA_DOWN-CPUDT_MKPF.

        CONCATENATE WA_DOWN-CPUDT_MKPF+0(2) WA_DOWN-CPUDT_MKPF+2(3) WA_DOWN-CPUDT_MKPF+5(4)
                        INTO WA_DOWN-CPUDT_MKPF SEPARATED BY '-'.
      ENDIF.

      CONCATENATE WA_MSEG-CPUTM_MKPF+0(2) ':' WA_MSEG-CPUTM_MKPF+2(2) ':' WA_MSEG-CPUTM_MKPF+4(2)  INTO WA_DOWN-CPUTM_MKPF.

*        IF wa_mseg-/BEV2/ED_AEDAT is NOT INITIAL.
*         CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*          EXPORTING
*            input  = wa_mseg-/BEV2/ED_AEDAT
*          IMPORTING
*            output = wa_down-/BEV2/ED_AEDAT.
*
*        CONCATENATE wa_down-/BEV2/ED_AEDAT+0(2) wa_down-/BEV2/ED_AEDAT+2(3) wa_down-/BEV2/ED_AEDAT+5(4)
*                        INTO wa_down-/BEV2/ED_AEDAT SEPARATED BY '-'.
*      endif.

*      CONCATENATE wa_mseg-/BEV2/ED_AETIM+0(2) ':' wa_mseg-/BEV2/ED_AETIM+2(2) ':' wa_mseg-/BEV2/ED_AETIM+4(2)  INTO wa_down-/BEV2/ED_AETIM.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = WA_DOWN-REF_DATE.

      CONCATENATE WA_DOWN-REF_DATE+0(2) WA_DOWN-REF_DATE+2(3) WA_DOWN-REF_DATE+5(4)
                      INTO WA_DOWN-REF_DATE SEPARATED BY '-'.

      CONCATENATE SY-UZEIT+0(2) ':' SY-UZEIT+2(2) ':' SY-UZEIT+4(2)  INTO WA_DOWN-REF_TIME.

      APPEND WA_DOWN TO IT_DOWN.
      CLEAR :WA_DOWN, WA_MSEG.
*     ENDLOOP.


    ENDLOOP.

  ENDIF.


  TRY.
      CALL METHOD CL_SALV_TABLE=>FACTORY
        IMPORTING
          R_SALV_TABLE = GR_TABLE
        CHANGING
          T_TABLE      = IT_MSEG[].
    CATCH CX_SALV_MSG .
  ENDTRY.



  CALL METHOD GR_TABLE->SET_SCREEN_STATUS
    EXPORTING
      REPORT        = SY-REPID
      PFSTATUS      = 'ZPF_STATUS' "your PF Status name
      SET_FUNCTIONS = GR_TABLE->C_FUNCTIONS_ALL.

  CALL METHOD GR_TABLE->DISPLAY.
*  break primusabap.
  IF P_DOWN = 'X'.
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
FORM DOWNLOAD .
  TYPE-POOLS TRUXS.
  DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

  DATA: LV_FILE(30).
  DATA: LV_FULLFILE TYPE STRING,
        LV_DAT(10),
        LV_TIM(4).
  DATA: LV_MSG(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      I_TAB_SAP_DATA       = IT_DOWN
    CHANGING
      I_TAB_CONVERTED_DATA = IT_CSV
    EXCEPTIONS
      CONVERSION_FAILED    = 1
      OTHERS               = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM CVS_HEADER USING HD_CSV.

  LV_FILE = 'ZMTRL_MOVEMENT_542.TXT'.

  CONCATENATE P_FOLDER '/' LV_FILE
     INTO LV_FULLFILE.

  WRITE: / 'ZMTRL_MOVEMENT_542.TXT Download started on', SY-DATUM, 'at', SY-UZEIT.
  OPEN DATASET LV_FULLFILE
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF SY-SUBRC = 0.
    DATA LV_STRING_2490 TYPE STRING.
    DATA LV_CRLF_2490 TYPE STRING.
    LV_CRLF_2490 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_2490 = HD_CSV.
    LOOP AT IT_CSV INTO WA_CSV.
      CONCATENATE LV_STRING_2490 LV_CRLF_2490 WA_CSV INTO LV_STRING_2490.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_2490 TO LV_FULLFILE.
    CONCATENATE 'File' LV_FULLFILE 'downloaded' INTO LV_MSG SEPARATED BY SPACE.
    MESSAGE LV_MSG TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM CVS_HEADER  USING    P_HD_CSV.

  DATA: L_FIELD_SEPERATOR.
  L_FIELD_SEPERATOR = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
  CONCATENATE  'Client'
               'Material document'
               'Material doc. year'
               'Material doc.item'
               'Identification'
               'Parent line id'
               'Hierarchy level'
               'Original line item'
               'Movement type'
               'Item automatically created'
               'Material'
               'Plant'
               'Storage location'
               'Batch'
               'Stock type'
               'Status key'
               'Batch restricted'
               'Special stock'
               'Vendor'
               'Customer'
               'Sales order'
               'Sales order item'
               'Sales order schedule'
               'Distr. differences'
               'Debit/credit ind'
               'Currency'
               'Amt.in loc.cur.	0'
               'Delivery costs  0'
               'Amount  0'
               'D/c indicator reval.'
               'Revaluation	0'
               'Valuation Type'
               'Quantity  0'
               'Base Unit of measure'
               'Qty in unit of entry  0'
               'Unit of Entry'
               'Qty in opun	0'
               'Order price Unit'
               'Purchase order'
               'Item'
               'Fisc. year Ref. doc.'
               'Reference document'
               'Reference doc. item'
               'Material doc. year'
               'Material document'
               'Material doc.item'
               'Delivery completed'
               'Text'
               'Equipment'
               'Goods recipient'
               'Unloading Point'
               'Business Area'
               'Controlling Area'
               'Trading part.ba'
               'Clearing cocode'
               'Cost Center'
               'Not in use'
               'Order'
               'Asset'
               'Sub-number'
               'Cctrpostingstatist'
               'Order post.statist.'
               'Proj. posting stat'
               'Pa posting stat.'
               'Fiscal year'
               'Allow posting to previous per.'
               'Post to prev. year'
               'Company Code'
               'Document Number'
               'Line item'
               'Document Number'
               'Line item'
               'Reservation'
               'Item number of reservation'
               'Final issue'
               'Quantity  0'
               'Statistically relev.'
               'Receiving material'
               'Receiving plant'
               'Receiving stor. loc.'
               'Receiving batch'
               'Restricted-use'
               'Stat. key tfr. batch'
               'Val. Type tfr batch'
               'Sp. ind. stock tfr.'
               'Movement indicator'
               'Consumption'
               'Receipt indicator'
               'Gr non-valuated'
               'No. of pallets  0'
               'Warehouse Number'
               'Storage Type'
               'Storage bin'
               'Stock category'
               'Movement Type'
               'Tr Number'
               'Tr item'
               'Posting in wm'
               'Int.st.post.source'
               'Interim stor.p.dest.'
               'Dynamic storage bin'
               'Postingchange Number'
               'Transfer Priority'
               'Transfer Order Number'
               'Number of gr slips'
               'Reason for movement'
               'Shipping Instr.'
               'Compliance with shipping Instr.'
               'Real estate Key'
               'Cost Object'
               'Profitab. segmt No.'
               'Profit Center'
               'Wbs element'
               'Network'
               'Opertn task list no.'
               'Counter'
               'Order item number'
               'Partner'
               'Commitment item'
               'G/l account'
               'Qty in order unit	0'
               'Order Unit'
               'Revgr despite ir'
               'Vendor'
               'Ext. Amount in lc	0'
               'Sales Value inc. vat 0'
               'Promotion'
               'Seq. No. of account assgt'
               'Sled/bbd'
               'Internal object no.'
               'Sales Value	0'
               'Partner profit ctr'
               'Record type'
               'Fund'
               'Funds center'
               'Stock material'
               'Receiving material'
               'Quantity string'
               'Value String'
               'Quantity updating'
               'Value updating'
               'Valuated stock  0'
               'Totl val. bf.posting  0'
               'Price control'
               'Functional Area'
               'Reference date'
               'Sales value w/o vat	0'
               'Reference date'
               'Automatic po'
               'Del. note quantity  0'
               'Delivery note Unit'
               'Spec. stk valuation'
               'Inspection Status in gr document'
               'Original line item'
               'Alt. base amount  0'
               'Tax Code'
               'Tax jurisdiction'
               'Mpn material'
               'Gi-revaluation o.k.'
               'Tax Code'
               'Date of manufacture'
               'Mat.staging indicat.'
               'Sales order'
               'Sales order item'
               'Wbs element'
               'Calcn of value open'
               'Accounting indicator'
               'Business Process'
               'Supplying vendor'
               'Activity Type'
               'Vendor stock valuation'
               'Grant'
               'Stock Type Modif.'
               'Gts stock Type'
               'Earmarked funds'
               'Document item'
               'Multiple acct assignment'
               'Trans./event Type'
               'Posting Date'
               'Entry Date'
               'Time of Entry'
               'User Name'
               'Reference'
               'Transaction Code'
               'Delivery'
               'Item'
               'Stock Segment'
               'Rec. stock Segment'
               'Requirement Segment'
               'Ed Status'
               'User Name'
               'Changed On'
               'Time'
               'Owner of stock'
               'Season year'
               'Season'
               'Collection'
               'Theme'
               'Receiving/issuing season year'
               'Receiving/issuing season'
               'Receiving/issuing Collection'
               'Receiving/issuing theme'
               'Discrete batch No.'
               'Non-deductible  0'
               'Condkey'
               'Condkey'
               'Characteristic Value 1'
               'Characteristic Value 2'
               'Characteristic Value 3'
               'Refreshable Date'
               'Refreshable Time'
                 INTO P_HD_CSV
                SEPARATED BY L_FIELD_SEPERATOR.
ENDFORM.
*ENDFORM.
