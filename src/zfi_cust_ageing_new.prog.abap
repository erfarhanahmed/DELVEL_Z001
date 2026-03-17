REPORT  zfi_cust_ageing
        NO STANDARD PAGE HEADING LINE-COUNT 300.

** **************TABLE DECLARATION

DATA:
   tmp_kunnr TYPE kna1-kunnr.
*TABLES: bsid,kna1, bsad, knb1.
TYPE-POOLS : slis.

**************DATA DECLARATION

DATA : date1 TYPE sy-datum, date2 TYPE sy-datum, date3 TYPE i.

DATA   fs_layout TYPE slis_layout_alv.
DATA : fm_name TYPE rs38l_fnam.
DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.

*Internal Table for sorting
DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.


TYPES:
  BEGIN OF t_knvv,
    kunnr TYPE knvv-kunnr,
    vkbur TYPE knvv-vkbur,
  END OF t_knvv,
  tt_knvv TYPE STANDARD TABLE OF t_knvv.

TYPES:
  BEGIN OF t_tvkbt,
    vkbur TYPE tvkbt-vkbur,
    bezei TYPE tvkbt-bezei,
  END OF t_tvkbt,
  tt_tvkbt TYPE STANDARD TABLE OF t_tvkbt.

TYPES:
  BEGIN OF t_vbrk,
    vbeln TYPE vbrk-vbeln,
    fkdat TYPE vbrk-fkdat,
  END OF t_vbrk,
  tt_vbrk TYPE STANDARD TABLE OF t_vbrk.

TYPES:
  BEGIN OF t_vbrp,
    vbeln TYPE vbrp-vbeln,
    aubel TYPE vbrp-aubel,
  END OF t_vbrp,
  tt_vbrp TYPE STANDARD TABLE OF t_vbrp.

TYPES:
  BEGIN OF t_skat,
    saknr TYPE skat-saknr,
    txt50 TYPE skat-txt50,
  END OF t_skat,
  tt_skat TYPE STANDARD TABLE OF t_skat.

TYPES:
  BEGIN OF t_vbak,
    vbeln TYPE vbak-vbeln,
    audat TYPE vbak-audat,
    bstnk TYPE vbak-bstnk,
    bstdk TYPE vbak-bstdk,
  END OF t_vbak,
  tt_vbak TYPE STANDARD TABLE OF t_vbak.

TYPES:BEGIN OF ty_vbkd,
        vbeln TYPE vbkd-vbeln,
        posnr TYPE vbkd-posnr,
        bstkd TYPE vbkd-bstkd,
      END OF ty_vbkd.
DATA : it_vbkd TYPE TABLE OF ty_vbkd,
       wa_vbkd TYPE          ty_vbkd.


TYPES:
  BEGIN OF t_tvzbt,
    zterm TYPE tvzbt-zterm,
    vtext TYPE tvzbt-vtext,
  END OF t_tvzbt,
  tt_tvzbt TYPE STANDARD TABLE OF t_tvzbt.


TYPES: BEGIN OF idata ,
         name1      LIKE kna1-name1,          "custmor Name
         ktokd      LIKE kna1-ktokd,          " customer account group
         kunnr      LIKE bsid-kunnr,          "Customer Code
         shkzg      LIKE bsid-shkzg,          "debit/credit s/h
         bukrs      LIKE bsid-bukrs,          "Company Code
         augbl      LIKE bsid-augbl,          "Clearing Doc No
         auggj      LIKE bsid-auggj,
         augdt      LIKE bsid-augdt,          "Clearing Date
         gjahr      LIKE bsid-gjahr,          "Fiscal year
         belnr      LIKE bsid-belnr,          "Document no.
         umskz      LIKE bsid-umskz,          "Special G/L indicator
         buzei      LIKE bsid-buzei,          "Line item no.
         budat      LIKE bsid-budat,          "Posting date in the document
         bldat      LIKE bsid-bldat,          "Document date in document
         waers      LIKE bsid-waers,          "Currency
         blart      LIKE bsid-blart,          "Doc. Type
         xblnr      TYPE bsid-xblnr,          "ODN
         dmbtr      LIKE bsid-dmbtr,          "Amount in local curr.
         wrbtr      LIKE bsid-wrbtr,          "Amount in local curr.
         rebzg      LIKE bsid-rebzg,          "refr inv no
         rebzj      LIKE bsid-rebzj,          "Fiscal year
         rebzz      LIKE bsid-rebzz,          "Line Item no
         vbeln      TYPE bsad-vbeln,          "Invoice Number
         duedate    LIKE bsid-augdt,        "Due Date
         zterm      LIKE bsid-zterm,         "Payment Term
*         zbd1t     LIKE bsid-zbd1t,         "Cash Discount Days 1
         day        TYPE i,
         debit      LIKE bsid-dmbtr,         "Amount in local curr.
         credit     LIKE bsid-dmbtr,         "Amount in local curr.
         netbal     LIKE bsid-dmbtr,         "Amount in local curr.
         not_due_cr TYPE bsid-dmbtr,        "Amount in local curr.
         not_due_db TYPE bsid-dmbtr,        "Amount in local curr.
         not_due    TYPE bsid-dmbtr,        "Amount in local curr.
         debit30    LIKE bsid-dmbtr,        "Amount in local curr.
         credit30   LIKE bsid-dmbtr,       "Amount in local curr.
         netb30     LIKE bsid-dmbtr,         "Amount in local curr.
         debit60    LIKE bsid-dmbtr,        "Amount in local curr.
         credit60   LIKE bsid-dmbtr,       "Amount in local curr.
         netb60     LIKE bsid-dmbtr,         "Amount in local curr.
         debit90    LIKE bsid-dmbtr,        "Amount in local curr.
         credit90   LIKE bsid-dmbtr,       "Amount in local curr.
         netb90     LIKE bsid-dmbtr,         "Amount in local curr.
         debit120   LIKE bsid-dmbtr,       "Amount in local curr.
         credit120  LIKE bsid-dmbtr,      "Amount in local curr.
         netb120    LIKE bsid-dmbtr,         "Amount in local curr.
         debit180   LIKE bsid-dmbtr,       "Amount in local curr.
         credit180  LIKE bsid-dmbtr,      "Amount in local curr.
         netb180    LIKE bsid-dmbtr,         "Amount in local curr.
         debit360   LIKE bsid-dmbtr,       "Amount in local curr.
         credit360  LIKE bsid-dmbtr,      "Amount in local curr.
         netb360    LIKE bsid-dmbtr,         "Amount in local curr.
         debit720   LIKE bsid-dmbtr,       "Amount in local curr.
         credit720  LIKE bsid-dmbtr,      "Amount in local curr.
         netb720    LIKE bsid-dmbtr,         "Amount in local curr.
         debit730   LIKE bsid-dmbtr,       "Amount in local curr.
         credit730  LIKE bsid-dmbtr,      "Amount in local curr.
         netb730    LIKE bsid-dmbtr,         "Amount in local curr.
         debit_ab   LIKE bsid-dmbtr,       "Amount in local curr.
         credit_ab  LIKE bsid-dmbtr,      "Amount in local curr.
         netb_ab    LIKE bsid-dmbtr,         "Amount in local curr.
         tdisp      TYPE string,
         group      TYPE string,
         akont      TYPE knb1-akont,
         zfbdt      TYPE bsid-zfbdt,
         zbd1t      TYPE bsid-zbd1t,
         zbd2t      TYPE bsid-zbd2t,
         zbd3t      TYPE bsid-zbd3t,
         curr       TYPE bsid-dmbtr,
         bezei      TYPE tvkbt-bezei,
         fkdat      TYPE vbrk-fkdat,
         aubel      TYPE vbrp-aubel,
         audat      TYPE vbak-audat,
         bstnk      TYPE vbak-bstnk,
         bstdk      TYPE vbak-bstdk,
         vtext      TYPE char200,
         txt50      TYPE string,
         rec_txt    TYPE char70,     "Reconcilation Account text
         debit1000  LIKE bsid-dmbtr,
         credit1000 LIKE bsid-dmbtr,
         netb1000   LIKE bsid-dmbtr,
         sale       TYPE char10,
         sale_off   TYPE char50,
         bstkd      TYPE vbkd-bstkd,
         kursf      TYPE bkpf-kursf,
       END OF idata.

TYPES : BEGIN OF ty_down,
          group    TYPE string,
          sale     TYPE char10,
          sale_off TYPE char50,
          kunnr    TYPE char15,
          tdisp    TYPE string,
          bldat    TYPE char11,
          budat    TYPE char11,
          akont    TYPE char50,
          rec_txt  TYPE char100,
          duedate  TYPE char11,
          blart    TYPE char10,
          belnr    TYPE char15,
          vbeln    TYPE char20,
          xblnr    TYPE char20,
          fkdat    TYPE char11,
          vtext    TYPE char200,
          aubel    TYPE char15,
          audat    TYPE char11,
          bstkd    TYPE char50,
          bstdk    TYPE char11,
          curr     TYPE char15,
          waers    TYPE char10,
          debit    TYPE char15,
          credit   TYPE char15,
          netbal   TYPE char15,
          not_due  TYPE char15,
          netb30   TYPE char15,
          netb60   TYPE char15,
          netb90   TYPE char15,
          netb120  TYPE char15,
          netb180  TYPE char15,
          netb360  TYPE char15,
          netb720  TYPE char15,
          netb1000 TYPE char15,
          day      TYPE char15,
          ref      TYPE char11,
          kursf    type string,
        END OF ty_down.

DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE          ty_down,

       lt_ofic TYPE TABLE OF ty_down,
       ls_ofic TYPE          ty_down,

       lt_mail TYPE TABLE OF zcust_mail,
       ls_mail TYPE          zcust_mail.

DATA: rp01(3) TYPE n,                                     "   0
      rp02(3) TYPE n,                                     "  20
      rp03(3) TYPE n,                                     "  40
      rp04(3) TYPE n,                                     "  80
      rp05(3) TYPE n,                                     " 100
      rp06(3) TYPE n,                                     "   1
      rp07(3) TYPE n,                                     "  21
      rp08(3) TYPE n,                                     "  41
      rp09(3) TYPE n,                                     "  81
      rp10(3) TYPE n,                                     " 101
      rp11(3) TYPE n,                                     " 101
      rp12(3) TYPE n,                                     " 101
      rp13(3) TYPE n,                                     " 101
      rp14(3) TYPE n.                                     " 101

DATA: rc01(14) TYPE c,                                     "  0
      rc02(14) TYPE c,                                    "  20
      rc03(14) TYPE c,                                    "  40
      rc04(14) TYPE c,                                    "  80
      rc05(14) TYPE c,                                    " 100
      rc06(14) TYPE c,                                    "   1
      rc07(14) TYPE c,                                    "  21
      rc08(14) TYPE c,                                    "  41
      rc09(14) TYPE c,                                    "  81
      rc10(14) TYPE c,                                    " 101
      rc11(14) TYPE c,                                    " 101
      rc12(14) TYPE c,                                    " 101
      rc13(14) TYPE c,                                    " 101
      rc14(20) TYPE c,                                    " 101
      rc15(20) TYPE c,                                    " 101
      rc16(20) TYPE c,                                    " 101
      rc17(20) TYPE c,                                    " 101
      rc18(30) TYPE c,                                    " 101
      rc19(30) TYPE c,                                    " 101
      rc20(30) TYPE c,                                    " 101
      rc21(30) TYPE c,                                    " 101
      rc22(30) TYPE c,                                    " 101
      rc23(30) TYPE c.                                    " 101

DATA: itab  TYPE idata OCCURS 0 WITH HEADER LINE.

******************SELECTION SCREEN

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.
PARAMETERS: plant LIKE bsid-bukrs OBLIGATORY DEFAULT '1000' MODIF ID bu..
SELECT-OPTIONS: kunnr FOR tmp_kunnr.
*                akont FOR knb1-akont.
PARAMETERS: date  LIKE bsid-budat DEFAULT sy-datum OBLIGATORY.                "no-extension obligatory.
SELECTION-SCREEN BEGIN OF LINE.

SELECTION-SCREEN COMMENT 01(30) TEXT-026 FOR FIELD rastbis1.

SELECTION-SCREEN POSITION POS_LOW.

PARAMETERS: rastbis1 LIKE rfpdo1-allgrogr DEFAULT '000'.
PARAMETERS: rastbis2 LIKE rfpdo1-allgrogr DEFAULT '030'.
PARAMETERS: rastbis3 LIKE rfpdo1-allgrogr DEFAULT '060'.
PARAMETERS: rastbis4 LIKE rfpdo1-allgrogr DEFAULT '090'.
PARAMETERS: rastbis5 LIKE rfpdo1-allgrogr DEFAULT '180'.
PARAMETERS: rastbis6 LIKE rfpdo1-allgrogr DEFAULT '360'.
PARAMETERS: rastbis7 LIKE rfpdo1-allgrogr DEFAULT '720'.

SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK a1.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME.
PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
            r2 RADIOBUTTON GROUP abc.
SELECTION-SCREEN: END OF BLOCK b1.
***********************Initialization.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003 .
PARAMETERS p_mail AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN :BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-005.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-006.
  SELECTION-SCREEN COMMENT /1(70) TEXT-007.
SELECTION-SCREEN: END OF BLOCK B4.


INITIALIZATION.

**************************************************
AT SELECTION-SCREEN.

  IF rastbis1 GT '998'
  OR rastbis2 GT '998'
  OR rastbis3 GT '998'
  OR rastbis4 GT '998'
  OR rastbis5 GT '998'
  OR rastbis6 GT '998'
  OR rastbis7 GT '998'.

    SET CURSOR FIELD rastbis7.
    MESSAGE 'Enter a consistent sorted list' TYPE 'E'.      "e381.
  ENDIF.
  IF NOT rastbis7 IS INITIAL.
    IF  rastbis7 GT rastbis6
    AND rastbis6 GT rastbis5
    AND rastbis5 GT rastbis4
    AND rastbis4 GT rastbis3
    AND rastbis3 GT rastbis2
    AND rastbis2 GT rastbis1.
    ELSE.
      MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
    ENDIF.
  ELSE.
    IF NOT rastbis6 IS INITIAL.
      IF  rastbis6 GT rastbis5
      AND rastbis5 GT rastbis4
      AND rastbis4 GT rastbis3
      AND rastbis3 GT rastbis2
      AND rastbis2 GT rastbis1.
      ELSE.
        MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
      ENDIF.
    ELSE.
      IF NOT rastbis5 IS INITIAL.
        IF  rastbis5 GT rastbis4
        AND rastbis4 GT rastbis3
        AND rastbis3 GT rastbis2
        AND rastbis2 GT rastbis1.
        ELSE.
          MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
        ENDIF.
      ELSE.
        IF NOT rastbis4 IS INITIAL.
          IF  rastbis4 GT rastbis3
          AND rastbis3 GT rastbis2
          AND rastbis2 GT rastbis1.
          ELSE.
            MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
          ENDIF.
        ELSE.
          IF NOT rastbis3 IS INITIAL.
            IF  rastbis3 GT rastbis2
            AND rastbis2 GT rastbis1.
            ELSE.
              MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
            ENDIF.
          ELSE.
            IF NOT rastbis2 IS INITIAL.
              IF  rastbis2 GT rastbis1.
              ELSE.
                MESSAGE 'Enter a maximum of 998 days in the sorted list upper limits' TYPE 'E'.
              ENDIF.
            ELSE.
*         nichts zu tun
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.


  rp01 = rastbis1.
  rp02 = rastbis2.
  rp03 = rastbis3.
  rp04 = rastbis4.
  rp05 = rastbis5.
  rp06 = rastbis6.
  rp07 = rastbis7.

  rp08 = rp01 + 1.
  IF NOT rp02 IS INITIAL.
    rp09 = rp02 + 1.
  ELSE.
    rp09 = ''.
  ENDIF.
  IF NOT rp03 IS INITIAL.
    rp10 = rp03 + 1.
  ELSE.
    rp10 = ''.
  ENDIF.
  IF NOT rp04 IS INITIAL.
    rp11 = rp04 + 1.
  ELSE.
    rp11 = ''.
  ENDIF.
  IF NOT rp05 IS INITIAL.
    rp12 = rp05 + 1.
  ELSE.
    rp12 = ''.
  ENDIF.
  IF NOT rp06 IS INITIAL.
    rp13 = rp06 + 1.
  ELSE.
    rp13 = ''.
  ENDIF.
  IF NOT rp07 IS INITIAL.
    rp14 = rp07 + 1.
  ELSE.
    rp14 = ''.
  ENDIF.

  IF NOT rp01 IS INITIAL.
    CONCATENATE 'Upto'    rp01 'Dr' INTO rc01 SEPARATED BY space.
    CONCATENATE 'Upto'    rp01 'Cr' INTO rc08 SEPARATED BY space.
    CONCATENATE '000 to'  rp01 'Days' INTO rc17 SEPARATED BY space.
  ELSE.
    CONCATENATE 'Upto'    rp01 'Dr' INTO rc01 SEPARATED BY space.
    CONCATENATE 'Upto'    rp01 'Cr' INTO rc08 SEPARATED BY space.
    CONCATENATE rp01 'Days' INTO rc17 SEPARATED BY space.
  ENDIF.


  IF NOT rp02 IS INITIAL.
    CONCATENATE rp08 'To' rp02 'Dr' INTO rc02 SEPARATED BY space.
    CONCATENATE rp08 'To' rp02 'Cr' INTO rc09 SEPARATED BY space.
    CONCATENATE rp08 'To' rp02 'Days' INTO rc18 SEPARATED BY space.
  ELSEIF rp03 IS INITIAL.
    CONCATENATE rp08 '& Above' 'Dr' INTO rc02 SEPARATED BY space.
    CONCATENATE rp08 '& Above' 'Cr' INTO rc09 SEPARATED BY space.
    CONCATENATE rp08 'Days' INTO rc18 SEPARATED BY space.
  ENDIF.

  IF NOT rp03 IS INITIAL.
    CONCATENATE rp09 'To' rp03 'Dr' INTO rc03 SEPARATED BY space.
    CONCATENATE rp09 'To' rp03 'Cr' INTO rc10 SEPARATED BY space.
    CONCATENATE rp09 'To' rp03 'Days' INTO rc19 SEPARATED BY space.
  ELSEIF rp02 IS INITIAL.
    rc03 = ''.
    rc08 = ''.
    rc15 = ''.
  ELSEIF rp04 IS INITIAL.
    CONCATENATE rp09 '& Above' 'Dr' INTO rc03 SEPARATED BY space.
    CONCATENATE rp09 '& Above' 'Cr' INTO rc10 SEPARATED BY space.
    CONCATENATE rp09 'Days' INTO rc19 SEPARATED BY space.
  ENDIF.

  IF NOT rp04 IS INITIAL .
    CONCATENATE rp10 'To' rp04 'Dr' INTO rc04 SEPARATED BY space.
    CONCATENATE rp10 'To' rp04 'Cr' INTO rc11 SEPARATED BY space.
    CONCATENATE rp10 'To' rp04 'Days' INTO rc20 SEPARATED BY space.
  ELSEIF rp03 IS INITIAL.
    rc04 = ''.
    rc09 = ''.
    rc16 = ''.
  ELSEIF rp05 IS INITIAL.
    CONCATENATE rp10 '& Above' 'Dr' INTO rc04 SEPARATED BY space.
    CONCATENATE rp10 '& Above' 'Cr' INTO rc11 SEPARATED BY space.
*    CONCATENATE rp08 '& Above' 'Net Bal' INTO rc16 SEPARATED BY space.
    CONCATENATE rp10 'Days' INTO rc20 SEPARATED BY space.
  ENDIF.

  IF NOT rp05 IS INITIAL.
    CONCATENATE rp11 'To' rp05 'Dr' INTO rc05 SEPARATED BY space.
    CONCATENATE rp11 'To' rp05 'Cr' INTO rc12 SEPARATED BY space.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE rp11 'To' rp05 'Days' INTO rc21 SEPARATED BY space.
  ELSEIF rp04 IS INITIAL.
    rc05 = ''.
    rc10 = ''.
    rc17 = ''.
  ELSE.
    CONCATENATE rp11 '& Above' 'Dr' INTO rc05 SEPARATED BY space.
    CONCATENATE rp11 '& Above' 'Cr' INTO rc12 SEPARATED BY space.
    CONCATENATE rp11 'Days' INTO rc21 SEPARATED BY space.
  ENDIF.


  IF NOT rp06 IS INITIAL.
    CONCATENATE rp12 'To' rp06 'Dr' INTO rc06 SEPARATED BY space.
    CONCATENATE rp12 'To' rp06 'Cr' INTO rc13 SEPARATED BY space.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE rp12 'To' rp06 'Days' INTO rc22 SEPARATED BY space.
  ELSEIF rp05 IS INITIAL.
    rc05 = ''.
    rc10 = ''.
    rc17 = ''.
  ELSE.
    CONCATENATE rp12 '& Above' 'Dr' INTO rc06 SEPARATED BY space.
    CONCATENATE rp12 '& Above' 'Cr' INTO rc13 SEPARATED BY space.
    CONCATENATE rp12 'Days' INTO rc22 SEPARATED BY space.
  ENDIF.


  IF NOT rp07 IS INITIAL.
    CONCATENATE rp13 'To' rp07 'Dr' INTO rc07 SEPARATED BY space.
    CONCATENATE rp13 'To' rp07 'Cr' INTO rc14 SEPARATED BY space.
*    CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
    CONCATENATE rp13 'To' rp07 'Days' INTO rc23 SEPARATED BY space.
  ELSEIF rp06 IS INITIAL.
    rc05 = ''.
    rc10 = ''.
    rc17 = ''.
  ELSE.
    CONCATENATE rp13 '& Above' 'Dr' INTO rc07 SEPARATED BY space.
    CONCATENATE rp13 '& Above' 'Cr' INTO rc14 SEPARATED BY space.
    CONCATENATE rp13 'Days' INTO rc23 SEPARATED BY space.
  ENDIF.

  IF NOT rp14 IS INITIAL.
    CONCATENATE rp14 '& Above' 'Dr' INTO rc15 SEPARATED BY space.
    CONCATENATE rp14 '& Above' 'Cr' INTO rc16 SEPARATED BY space.
    CONCATENATE rp14 'Days and Above' INTO rc14 SEPARATED BY space.
  ENDIF.
*******************************************
AT SELECTION-SCREEN OUTPUT.       "Added by SR on 07.05.2021

LOOP AT SCREEN.


    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.


  IF SCREEN-name CS 'P_MAIL'.
    SCREEN-INPUT = 0.
    MODIFY SCREEN.
  ENDIF.


ENDLOOP.


**************************************************
START-OF-SELECTION.

  PERFORM datalist_bsid.

  PERFORM fill_fieldcatalog.
  PERFORM sort_list.
  PERFORM fill_layout.
  PERFORM list_display.
*  PERFORM send_email.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  datalist_bsid
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM datalist_bsid .
  DATA:
    ls_faede_i TYPE faede,
    ls_faede_e TYPE faede,
    lv_index   TYPE sy-tabix,
    lv_ktopl   TYPE t001-ktopl.

  DATA:
    lt_knvv  TYPE tt_knvv,
    ls_knvv  TYPE t_knvv,
    lt_tvkbt TYPE tt_tvkbt,
    ls_tvkbt TYPE t_tvkbt,
    lt_vbrk  TYPE tt_vbrk,
    ls_vbrk  TYPE t_vbrk,
    lt_vbrp  TYPE tt_vbrp,
    ls_vbrp  TYPE t_vbrp,
    lt_vbak  TYPE tt_vbak,
    ls_vbak  TYPE t_vbak,
    lt_tvzbt TYPE tt_tvzbt,
    ls_tvzbt TYPE t_tvzbt,
    lt_skat  TYPE tt_skat,
    ls_skat  TYPE t_skat,
    lt_data  TYPE STANDARD TABLE OF idata,
    ls_data  TYPE idata.

  SELECT bsid~bukrs
         bsid~kunnr
         augbl
         auggj
         augdt
         gjahr
         belnr
         buzei
         budat
         bldat
         waers
         shkzg
         dmbtr
         wrbtr
         rebzg
         rebzj
         rebzz
         umskz
         bsid~zterm
         zbd1t
         xblnr
         blart
*     kna1~name1
*     kna1~ktokd
    knb1~akont
    bsid~zfbdt
    bsid~zbd1t
    bsid~zbd2t
    bsid~zbd3t
    bsid~vbeln
  INTO CORRESPONDING FIELDS OF TABLE itab
                             FROM bsid INNER JOIN knb1 ON bsid~kunnr = knb1~kunnr AND knb1~bukrs = bsid~bukrs
                             WHERE bsid~bukrs = plant
                             AND   bsid~kunnr IN kunnr
                             AND   umskz <> 'F'
                             AND   budat <= date
                             AND WAERS <> 'INR'.
*                             AND   knb1~akont IN akont .
*                             AND   kna1~ktokd IN ktokd.

  SELECT bsad~bukrs
         bsad~kunnr
         augbl
         auggj
         augdt
         gjahr
         belnr
         buzei
         budat
         bldat
         waers
         shkzg
         dmbtr
         wrbtr
         rebzg
         rebzj
         rebzz
         umskz
         bsad~zterm
         zbd1t
         blart
         xblnr
    knb1~akont
    bsad~zfbdt
    bsad~zbd1t
    bsad~zbd2t
    bsad~zbd3t
    bsad~vbeln
APPENDING CORRESPONDING FIELDS OF TABLE itab
                             FROM bsad INNER JOIN knb1 ON knb1~kunnr = bsad~kunnr AND knb1~bukrs = bsad~bukrs
                             WHERE bsad~bukrs = plant
                             AND   bsad~kunnr IN kunnr
                             AND   umskz <> 'F'
*                             AND   budat <= date
                             AND   augdt >  date
                               AND WAERS <> 'INR'.
*                             AND  augdt = ' '
*                             AND   knb1~akont IN akont.

  DELETE itab WHERE budat > date.

  lt_data[] = itab[].

  DELETE itab[] WHERE rebzg IS NOT INITIAL .
*  DELETE lt_data WHERE bldat EQ 'DR'.

  IF NOT itab[] IS INITIAL.
    SELECT SINGLE ktopl
                FROM  t001
                INTO  lv_ktopl
                WHERE bukrs = plant.

    SELECT kunnr
           vkbur
      FROM knvv
      INTO TABLE lt_knvv
      FOR ALL ENTRIES IN itab
      WHERE kunnr = itab-kunnr.

    IF sy-subrc IS INITIAL.
      SELECT vkbur
             bezei
        FROM tvkbt
        INTO TABLE lt_tvkbt
        FOR ALL ENTRIES IN lt_knvv
        WHERE vkbur = lt_knvv-vkbur
        AND   spras = sy-langu.
    ENDIF.

    SELECT vbeln
           fkdat
      FROM vbrk
      INTO TABLE lt_vbrk
      FOR ALL ENTRIES IN itab
      WHERE vbeln = itab-vbeln.

    SELECT vbeln
           aubel
      FROM vbrp
      INTO TABLE lt_vbrp
      FOR ALL ENTRIES IN itab
      WHERE vbeln = itab-vbeln.

    IF sy-subrc IS INITIAL.
      SELECT vbeln
             audat
             bstnk
             bstdk
        FROM vbak
        INTO TABLE lt_vbak
        FOR ALL ENTRIES IN lt_vbrp
        WHERE vbeln = lt_vbrp-aubel.
    ENDIF.

    IF lt_vbak IS NOT INITIAL.
      SELECT vbeln
             posnr
             bstkd FROM vbkd INTO TABLE it_vbkd
             FOR ALL ENTRIES IN lt_vbak
             WHERE vbeln = lt_vbak-vbeln
               AND posnr = ' '.
    ENDIF.

    SELECT zterm
           vtext
      FROM tvzbt
      INTO TABLE lt_tvzbt
      FOR ALL ENTRIES IN itab
      WHERE zterm = itab-zterm
      AND   spras =  sy-langu.

    SELECT saknr
           txt50
      FROM skat
      INTO TABLE lt_skat
      FOR ALL ENTRIES IN itab
      WHERE saknr = itab-akont
      AND   ktopl = lv_ktopl
      AND   spras = sy-langu.

      select belnr,
             bukrs,
             GJAHR,
             kursf
             from bkpf
            INTO TABLE @data(it_bkpf)
            FOR ALL ENTRIES IN @itab
            WHERE belnr = @itab-belnr
             AND GJAHR = @ITAB-GJAHR
             and bukrs = @plant
             .


  ENDIF.

  SORT itab[] BY belnr gjahr buzei.
  SORT lt_data[] BY rebzg rebzj rebzz.

  LOOP AT itab .
    READ TABLE lt_data INTO ls_data WITH KEY rebzg = itab-belnr
                                             rebzj = itab-gjahr
                                             rebzz = itab-buzei.
    IF sy-subrc IS INITIAL.
      lv_index = sy-tabix.
      LOOP AT lt_data INTO ls_data FROM lv_index.
        IF ls_data-rebzg = itab-belnr AND ls_data-rebzj = itab-gjahr AND ls_data-rebzz = itab-buzei.
          IF ls_data-shkzg = 'S'.
            itab-credit = itab-credit - ls_data-wrbtr.
          ELSE.
            itab-credit = itab-credit + ls_data-wrbtr.
          ENDIF.

        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
    MODIFY itab TRANSPORTING credit.
  ENDLOOP.

  LOOP AT itab.

    SELECT SINGLE name1 INTO itab-name1 FROM kna1 WHERE kunnr = itab-kunnr.

***********Calculating DEBIT and CREDIT
    IF itab-shkzg  = 'S'.
      itab-debit  = itab-wrbtr.
    ELSE.
      if ITAB-BLART = 'DZ' OR ITAB-BLART = 'DG'.
       itab-credit = itab-wrbtr.
      else.

         itab-credit = itab-credit + itab-wrbtr.
      endif.
    ENDIF.

    IF itab-umskz  = ''.
      itab-group  = 'Normal'.
    ELSE.
      itab-group  = 'Special G/L'.
    ENDIF.


*    itab-duedate = itab-bldat. " + itab-zbd1t.

    ls_faede_i-koart = 'D'.
    ls_faede_i-zfbdt = itab-zfbdt.
    ls_faede_i-zbd1t = itab-zbd1t.
    ls_faede_i-zbd2t = itab-zbd2t.
    ls_faede_i-zbd3t = itab-zbd3t.

    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        i_faede                    = ls_faede_i
*       I_GL_FAEDE                 =
      IMPORTING
        e_faede                    = ls_faede_e
      EXCEPTIONS
        account_type_not_supported = 1
        OTHERS                     = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    itab-duedate = ls_faede_e-netdt.
    IF r1 = 'X'.
      IF itab-bldat = date.
        itab-day  = 0.
      ELSE."if itab-bldat < date.
        itab-day     = date - itab-bldat.

      ENDIF.
    ELSE.
      IF itab-duedate = date.
        itab-day  = 0.
      ELSE.
        itab-day     = date - itab-duedate.
      ENDIF.
    ENDIF.
***********Net Balance
      IF NOT itab-debit IS INITIAL.
        itab-curr = itab-wrbtr.
        itab-debit = itab-curr.
      ELSEIF NOT itab-credit IS INITIAL.
       if ITAB-BLART = 'DZ' OR ITAB-BLART = 'DG'.
         itab-curr = itab-wrbtr * -1.
       else.
        itab-curr = itab-wrbtr * -1.
        endif.
      ENDIF.
      if ITAB-BLART = 'DZ' OR ITAB-BLART = 'DG'.
        itab-netbal = itab-curr ."* -1.
        itab-credit = itab-curr + itab-credit.
      else.
        itab-netbal = itab-curr - itab-credit.
    endif.

    IF itab-day < 0.
      itab-not_due_db = itab-debit.
      itab-not_due_cr = itab-credit.
      itab-not_due    = itab-not_due_db - itab-not_due_cr.
    ELSEIF itab-day <= rastbis1.
      itab-debit30  = itab-debit.
      itab-credit30 = itab-credit.
      itab-netb30 = itab-debit30 - itab-credit30.
    ELSEIF rastbis2 IS INITIAL.
      itab-debit60  = itab-debit.
      itab-credit60 = itab-credit.
      itab-netb60   = itab-debit60 - itab-credit60.
    ELSE.
      IF itab-day > rastbis1 AND itab-day <= rastbis2.
        itab-debit60  = itab-debit.
        itab-credit60 = itab-credit.
        itab-netb60   = itab-debit60 - itab-credit60.
      ELSEIF rastbis3 IS INITIAL.
        itab-debit90  = itab-debit.
        itab-credit90 = itab-credit.
        itab-netb90   = itab-debit90 - itab-credit90.
      ELSE.
        IF itab-day > rastbis2 AND itab-day <= rastbis3.
          itab-debit90  = itab-debit.
          itab-credit90 = itab-credit.
          itab-netb90   = itab-debit90 - itab-credit90.
        ELSEIF rastbis4 IS INITIAL.
          itab-debit120  = itab-debit.
          itab-credit120 = itab-credit.
          itab-netb120   = itab-debit120 - itab-credit120.
        ELSE.
          IF itab-day > rastbis3 AND itab-day <= rastbis4.
            itab-debit120  = itab-debit.
            itab-credit120 = itab-credit.
            itab-netb120   = itab-debit120 - itab-credit120.
          ELSEIF rastbis5 IS INITIAL.
            itab-debit180  = itab-debit.
            itab-credit180 = itab-credit.
            itab-netb180   = itab-debit180 - itab-credit180.
          ELSE.
            IF itab-day > rastbis4 AND itab-day <= rastbis5.
              itab-debit180  = itab-debit.
              itab-credit180 = itab-credit.
              itab-netb180   = itab-debit180 - itab-credit180.
            ELSEIF rastbis6 IS INITIAL.
              itab-debit360  = itab-debit.
              itab-credit360 = itab-credit.
              itab-netb360   = itab-debit360 - itab-credit360.
            ELSE.
              IF itab-day > rastbis5 AND itab-day <= rastbis6.
                itab-debit360  = itab-debit.
                itab-credit360 = itab-credit.
                itab-netb360   = itab-debit360 - itab-credit360.
              ELSEIF rastbis6 IS INITIAL.
                itab-debit720  = itab-debit.
                itab-credit720 = itab-credit.
                itab-netb720   = itab-debit720 - itab-credit720.

              ELSE.
                IF itab-day > rastbis6 AND itab-day <= rastbis7.
                  itab-debit720  = itab-debit.
                  itab-credit720 = itab-credit.
                  itab-netb720   = itab-debit720 - itab-credit720.
                ELSEIF rastbis7 IS INITIAL.
                  itab-debit1000  = itab-debit.
                  itab-credit1000 = itab-credit.
                  itab-netb1000   = itab-debit1000 - itab-credit1000.

                ELSE.
                  IF itab-day > rastbis7.
                    itab-debit1000  = itab-debit.
                    itab-credit1000 = itab-credit.
                    itab-netb1000   = itab-debit1000 - itab-credit1000.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    CONCATENATE itab-kunnr itab-name1 INTO itab-tdisp SEPARATED BY space."itab-umskz
    SHIFT itab-xblnr LEFT DELETING LEADING '0'.

    READ TABLE lt_knvv INTO ls_knvv WITH KEY kunnr = itab-kunnr.
    IF sy-subrc IS INITIAL.
      READ TABLE lt_tvkbt INTO ls_tvkbt WITH KEY vkbur = ls_knvv-vkbur.
      IF sy-subrc IS INITIAL.
        itab-bezei = ls_tvkbt.
      ENDIF.
    ENDIF.

    READ TABLE lt_vbrk INTO ls_vbrk WITH KEY vbeln = itab-vbeln.
    IF sy-subrc IS INITIAL.
      itab-fkdat = ls_vbrk-fkdat.
    ENDIF.

    READ TABLE lt_vbrp INTO ls_vbrp WITH KEY vbeln = itab-vbeln.
    IF sy-subrc IS INITIAL.
      READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_vbrp-aubel.
      IF sy-subrc IS INITIAL.
        itab-aubel = ls_vbak-vbeln.
        itab-audat = ls_vbak-audat.
        itab-bstnk = ls_vbak-bstnk.
        itab-bstdk = ls_vbak-bstdk.

        READ TABLE it_vbkd INTO wa_vbkd WITH KEY vbeln = itab-aubel.
        IF sy-subrc = 0.
          itab-bstkd = wa_vbkd-bstkd.
        ENDIF.
      ENDIF.
    ENDIF.

    READ TABLE lt_tvzbt INTO ls_tvzbt WITH KEY zterm = itab-zterm.
    IF sy-subrc IS INITIAL.
      CONCATENATE ls_tvzbt-zterm ls_tvzbt-vtext INTO itab-vtext SEPARATED BY space.
    ENDIF.
*    IF itab-waers = 'INR'.
*      IF NOT itab-debit IS INITIAL.
*        itab-curr = itab-wrbtr.
*      ELSEIF NOT itab-credit IS INITIAL.
*        itab-curr = itab-wrbtr * -1.
*      ENDIF.
*    ELSE.


*    ENDIF.
    read TABLE it_bkpf INTO data(wa_bkpf) with key belnr = itab-belnr.
    if sy-subrc is INITIAL.
      itab-kursf = wa_bkpf-kursf.
    endif.
    READ TABLE lt_skat INTO ls_skat WITH KEY saknr = itab-akont.
    IF sy-subrc IS INITIAL.
      itab-txt50 = ls_skat-txt50.
      CONCATENATE itab-akont ls_skat-txt50 INTO itab-rec_txt SEPARATED BY space.
    ELSE.
      itab-rec_txt = itab-akont.
    ENDIF.
    SHIFT itab-rec_txt LEFT DELETING LEADING '0'.
    MODIFY itab.

  ENDLOOP.

  IF p_down = 'X'.

    LOOP AT itab.
      wa_down-group    = itab-group   .


      wa_down-sale     = itab-bezei+0(2).
      wa_down-sale_off = itab-bezei+2(18).
      wa_down-tdisp    = itab-name1   .
      wa_down-kunnr    = itab-kunnr   .
*   wa_down-BLDAT    = itab-BLDAT   .

      IF itab-bldat IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = itab-bldat
          IMPORTING
            output = wa_down-bldat.

        CONCATENATE wa_down-bldat+0(2) wa_down-bldat+2(3) wa_down-bldat+5(4)
                        INTO wa_down-bldat SEPARATED BY '-'.

      ENDIF.

*   wa_down-BUDAT    = itab-BUDAT   .

      IF itab-budat IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = itab-budat
          IMPORTING
            output = wa_down-budat.

        CONCATENATE wa_down-budat+0(2) wa_down-budat+2(3) wa_down-budat+5(4)
                        INTO wa_down-budat SEPARATED BY '-'.

      ENDIF.


      wa_down-rec_txt  = itab-txt50.
      wa_down-akont  = itab-akont .
*   wa_down-DUEDATE  = itab-DUEDATE .

      IF itab-budat IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = itab-duedate
          IMPORTING
            output = wa_down-duedate.

        CONCATENATE wa_down-duedate+0(2) wa_down-duedate+2(3) wa_down-duedate+5(4)
                        INTO wa_down-duedate SEPARATED BY '-'.

      ENDIF.
      wa_down-blart    = itab-blart   .
      wa_down-belnr    = itab-belnr   .
      wa_down-vbeln    = itab-vbeln   .
      wa_down-xblnr    = itab-xblnr   .
*   wa_down-FKDAT    = itab-FKDAT   .

      IF itab-fkdat IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = itab-fkdat
          IMPORTING
            output = wa_down-fkdat.

        CONCATENATE wa_down-fkdat+0(2) wa_down-fkdat+2(3) wa_down-fkdat+5(4)
                        INTO wa_down-fkdat SEPARATED BY '-'.

      ENDIF.


      wa_down-vtext    = itab-vtext   .
      wa_down-aubel    = itab-aubel   .
*   wa_down-AUDAT    = itab-AUDAT   .

      IF itab-audat IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = itab-audat
          IMPORTING
            output = wa_down-audat.

        CONCATENATE wa_down-audat+0(2) wa_down-audat+2(3) wa_down-audat+5(4)
                        INTO wa_down-audat SEPARATED BY '-'.

      ENDIF.



*   wa_down-BSTNK    = itab-BSTNK   .
      wa_down-bstkd    = itab-bstkd   .
*   wa_down-BSTDK    = itab-BSTDK   .

      IF itab-bstdk IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = itab-bstdk
          IMPORTING
            output = wa_down-bstdk.

        CONCATENATE wa_down-bstdk+0(2) wa_down-bstdk+2(3) wa_down-bstdk+5(4)
                        INTO wa_down-bstdk SEPARATED BY '-'.

      ENDIF.


      wa_down-waers        = itab-waers  .
      wa_down-curr         = abs( itab-curr )   .

      wa_down-debit        = abs( itab-debit )  .
      wa_down-credit       = abs( itab-credit ) .
      wa_down-netbal       = abs( itab-netbal )  .
      wa_down-not_due      = abs( itab-not_due ).
      wa_down-netb30       = abs( itab-netb30 )  .
      wa_down-netb60       = abs( itab-netb60 ) .
      wa_down-netb90       = abs( itab-netb90 )    .
      wa_down-netb120      = abs( itab-netb120 )    .
      wa_down-netb180      = abs( itab-netb180 )   .
      wa_down-netb360      = abs( itab-netb360 )   .
      wa_down-netb720      = abs( itab-netb720 )   .
      wa_down-netb1000     = abs( itab-netb1000 )   .
      wa_down-day          = abs( itab-day )       .

      CONDENSE wa_down-curr.
      IF itab-curr < 0.
        CONCATENATE '-' wa_down-curr INTO wa_down-curr.
      ENDIF.



      CONDENSE wa_down-debit.
      IF itab-debit < 0.
        CONCATENATE '-' wa_down-debit INTO wa_down-debit.
      ENDIF.

      CONDENSE wa_down-credit.
      IF itab-credit < 0.
        CONCATENATE '-' wa_down-credit INTO wa_down-credit.
      ENDIF.

      CONDENSE wa_down-netbal.
      IF itab-netbal < 0.
        CONCATENATE '-' wa_down-netbal INTO wa_down-netbal.
      ENDIF.

      CONDENSE wa_down-not_due.
      IF itab-not_due < 0.
        CONCATENATE '-' wa_down-not_due INTO wa_down-not_due.
      ENDIF.

      CONDENSE wa_down-netb30.
      IF itab-netb30 < 0.
        CONCATENATE '-' wa_down-netb30 INTO wa_down-netb30.
      ENDIF.

      CONDENSE wa_down-netb60.
      IF itab-netb60 < 0.
        CONCATENATE '-' wa_down-netb60 INTO wa_down-netb60.
      ENDIF.

      CONDENSE wa_down-netb90.
      IF itab-netb90 < 0.
        CONCATENATE '-' wa_down-netb90 INTO wa_down-netb90.
      ENDIF.

      CONDENSE wa_down-netb120.
      IF itab-netb120 < 0.
        CONCATENATE '-' wa_down-netb120 INTO wa_down-netb120.
      ENDIF.

      CONDENSE wa_down-netb180.
      IF itab-netb180 < 0.
        CONCATENATE '-' wa_down-netb180 INTO wa_down-netb180.
      ENDIF.

      CONDENSE wa_down-netb360.
      IF itab-netb360 < 0.
        CONCATENATE '-' wa_down-netb360 INTO wa_down-netb360.
      ENDIF.

      CONDENSE wa_down-netb720.
      IF itab-netb720 < 0.
        CONCATENATE '-' wa_down-netb720 INTO wa_down-netb720.
      ENDIF.

      CONDENSE wa_down-netb1000.
      IF itab-netb1000 < 0.
        CONCATENATE '-' wa_down-netb1000 INTO wa_down-netb1000.
      ENDIF.

      CONDENSE wa_down-day.
      IF itab-day < 0.
        CONCATENATE '-' wa_down-day INTO wa_down-day.
      ENDIF.



      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

       wa_down-kursf = itab-kursf.
      APPEND wa_down TO it_down.
      CLEAR wa_down.
    ENDLOOP.




  ENDIF.


ENDFORM.                    " DATALIST_Bsak


*&---------------------------------------------------------------------*
*&      Form  fill_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_fieldcatalog.

  PERFORM f_fieldcatalog USING '1'   'GROUP'     'GL Type'.
  PERFORM f_fieldcatalog USING '2'   'BEZEI'     'Sales Office'.
  PERFORM f_fieldcatalog USING '3'   'TDISP'     'Customer Code Name'.
  PERFORM f_fieldcatalog USING '4'   'BLDAT'     'Document Date'.
  PERFORM f_fieldcatalog USING '5'   'BUDAT'     'Posting Date'.
  PERFORM f_fieldcatalog USING '6'   'REC_TXT'   'Reconciliation Account'.
  PERFORM f_fieldcatalog USING '7'   'DUEDATE'   'Due Date'.
  PERFORM f_fieldcatalog USING '8'   'BLART'     'FI Doc Type'.
  PERFORM f_fieldcatalog USING '9'   'BELNR'     'Accounting Doc No.'.
  PERFORM f_fieldcatalog USING '10'   'VBELN'     'Billing Doc.No.'.
  PERFORM f_fieldcatalog USING '11'  'XBLNR'     'Tax Invoice No.(ODN)'.
  PERFORM f_fieldcatalog USING '12'  'FKDAT'     'Tax Invoice Date'.
  PERFORM f_fieldcatalog USING '13'  'VTEXT'     'Payment Terms'.
  PERFORM f_fieldcatalog USING '14'  'AUBEL'     'Sales Order No.'.
  PERFORM f_fieldcatalog USING '15'  'AUDAT'     'Sales Order Date'.
  PERFORM f_fieldcatalog USING '16'  'BSTKD'     'Customer PO. NO.'.
  PERFORM f_fieldcatalog USING '17'  'BSTDK'     'Customer PO. Date'.
  PERFORM f_fieldcatalog USING '18'   'CURR'      'Amt Document Currency'.
  PERFORM f_fieldcatalog USING '19'   'WAERS'     'Currency Key'.
  PERFORM f_fieldcatalog USING '20'   'DEBIT'     'Total Inv Amt' ."'Total Pending DR'.
  PERFORM f_fieldcatalog USING '21'  'CREDIT'    'Total Rec/Cre Memo Amt' . "'Total Pending CR'.
  PERFORM f_fieldcatalog USING '22'  'NETBAL'    'Total Outstanding'. "'Net Pending'.
  PERFORM f_fieldcatalog USING '23'  'NOT_DUE'   'Not Due'. "'Net Balance'.
  PERFORM f_fieldcatalog USING '24'  'NETB30'     rc17. "'Net Balance'.
  PERFORM f_fieldcatalog USING '25'  'NETB60'     rc18. "'Net Balance'.
  PERFORM f_fieldcatalog USING '26'  'NETB90'     rc19. "'Net Balance'.
  PERFORM f_fieldcatalog USING '27'  'NETB120'    rc20. "'Net Balance'.
  PERFORM f_fieldcatalog USING '28'  'NETB180'    rc21. "'Net Balance'.
  PERFORM f_fieldcatalog USING '29'  'NETB360'    rc22. "'Net Balance'.
  PERFORM f_fieldcatalog USING '30'  'NETB720'    rc23. "'Net Balance'.
  PERFORM f_fieldcatalog USING '31'  'NETB1000'   rc14. "'Net Balance'.
  PERFORM f_fieldcatalog USING '32'  'DAY'        'Over Due Days'.
  PERFORM f_fieldcatalog USING '33'  'KURSF'        'Exchange Rate'.

ENDFORM.                    " FILL_FIELDCATALOG

*&---------------------------------------------------------------------*
*&      Form  sort_list
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM sort_list.
  t_sort-spos      = '1'.
  t_sort-fieldname = 'GROUP'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '2'.
  t_sort-fieldname = 'TDISP'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = 'X'.
  APPEND t_sort.

  t_sort-spos      = '3'.
  t_sort-fieldname = 'BLDAT'.
  t_sort-tabname   = 'ITAB'.
  t_sort-up        = 'X'.
  t_sort-subtot    = ' '.
  APPEND t_sort.

ENDFORM.                    " sort_list

*&---------------------------------------------------------------------*
*&      Form  fill_layout
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM fill_layout.
  fs_layout-colwidth_optimize = 'X'.
  fs_layout-zebra             = 'X'.
  fs_layout-detail_popup      = 'X'.
  fs_layout-subtotals_text    = 'DR'.

ENDFORM.                    " fill_layout

*&---------------------------------------------------------------------*
*&      Form  f_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->VALUE(X)   text
*      -->VALUE(F1)  text
*      -->VALUE(F2)  text
*----------------------------------------------------------------------*
FORM f_fieldcatalog  USING   VALUE(x)
                             VALUE(f1)
                             VALUE(f2).
  t_fieldcat-col_pos      = x.
  t_fieldcat-fieldname    = f1.
  t_fieldcat-seltext_l    = f2.
*  t_fieldcat-decimals_out = '2'.

  IF f1 = 'DEBIT'    OR f1 = 'CREDIT'    OR f1 = 'DEBIT30'  OR f1 = 'CREDIT30'  OR
     f1 = 'DEBIT60'  OR f1 = 'CREDIT60'  OR f1 = 'DEBIT90'  OR f1 = 'CREDIT90'  OR
     f1 = 'DEBIT120' OR f1 = 'CREDIT120' OR f1 = 'DEBIT180' OR f1 = 'CREDIT180' OR
     f1 = 'DEBIT360' OR f1 = 'CREDIT360' OR f1 = 'NETBAL'   OR f1 = 'NETB30'    OR
     f1 = 'NETB60'   OR f1 = 'NETB90'    OR f1 = 'NETB120'  OR f1 = 'NETB180'   OR
     f1 = 'NETB360'  OR f1 = 'NETB720'   OR f1 = 'NETB1000'   OR f1 = 'NOT_DUE'.

    t_fieldcat-do_sum = 'X'.
  ENDIF.

  IF f1 = 'BELNR'.
    t_fieldcat-hotspot = 'X'.
  ENDIF.
  APPEND t_fieldcat.
  CLEAR t_fieldcat.

ENDFORM.                    " f_fieldcatalog

*&---------------------------------------------------------------------*
*&      Form  list_display
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM list_display.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_CMD'
      is_layout               = fs_layout
      i_callback_top_of_page  = 'TOP-OF-PAGE'
      it_fieldcat             = t_fieldcat[]
      it_sort                 = t_sort[]
      i_save                  = 'X'
    TABLES
      t_outtab                = itab[]
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
    BREAK primus.
    IF p_mail = 'X'.
      IF date = sy-datum.
        PERFORM send_mail.
      ENDIF.
    ENDIF.

  ENDIF.

ENDFORM.                    " list_display


*&---------------------------------------------------------------------*
*&      Form  top-of-page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top-of-page.

*  ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

*  Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Customer Ageing for Export Customer'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.

*  Date
  wa_header-typ  = 'S'.
  wa_header-key  = 'As on   :'.
  CONCATENATE wa_header-info date+6(2) '.' date+4(2) '.' date(4) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

*  Date
  wa_header-typ  = 'S'.
  wa_header-key  = 'Run Date : '.
  CONCATENATE wa_header-info sy-datum+6(2) '.' sy-datum+4(2) '.'
                      sy-datum(4) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

*  Time
  wa_header-typ  = 'S'.
  wa_header-key  = 'Run Time: '.
  CONCATENATE wa_header-info sy-timlo(2) ':' sy-timlo+2(2) ':'
                      sy-timlo+4(2) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

*   Total No. of Records Selected
  DESCRIBE TABLE itab LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
ENDFORM.                    " top-of-page


*&---------------------------------------------------------------------*
*&      Form  USER_CMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM user_cmd USING r_ucomm LIKE sy-ucomm
                    rs_selfield TYPE slis_selfield.
  IF r_ucomm = '&IC1'.
    IF rs_selfield-fieldname = 'BELNR'.
      READ TABLE itab WITH KEY belnr = rs_selfield-value.
      SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
      SET PARAMETER ID 'BUK' FIELD plant.
      SET PARAMETER ID 'GJR' FIELD itab-gjahr.
      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
    ENDIF.
  ENDIF.
ENDFORM.
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

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZCUSTAGE_CURR_EXPORT.TXT'.


  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'Date file ZCUSTAGE_CURR_EXPORT REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA LV_STRING_676 TYPE STRING.
    DATA LV_CRLF_676 TYPE STRING.
    LV_CRLF_676 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_676 = HD_CSV.
*    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
      CONCATENATE LV_STRING_676 LV_CRLF_676 WA_CSV INTO LV_STRING_676.
      CLEAR: WA_CSV.
    ENDLOOP.
    TRANSFER LV_STRING_676 TO LV_FULLFILE.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.

  ENDIF.
*********************************************SQL UPLOAD FILE *****************************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
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

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZCUSTAGE_CURR_EXPORT.TXT'.


  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZCUSTAGE_CURR_EXPORT REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    DATA LV_STRING_678 TYPE STRING.
    DATA LV_CRLF_678 TYPE STRING.
    LV_CRLF_678 = CL_ABAP_CHAR_UTILITIES=>CR_LF.
    LV_STRING_678 = HD_CSV.
*    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
      CONCATENATE LV_STRING_678 LV_CRLF_678 WA_CSV INTO LV_STRING_678.
      CLEAR: WA_CSV.
    ENDLOOP.

    TRANSFER LV_STRING_678 TO LV_FULLFILE.
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
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'GL Type'
              'Sales Office'
              'Sales Office Description'
              'Customer Code'
              'Customer Code Name'
              'Document Date'
              'Posting Date'
              'Reconciliation Account'
              'Reconciliation Account Desc'
              'Due Date'
              'FI Doc Type'
              'Accounting Doc No.'
              'Billing Doc.No.'
              'Tax Invoice No.(ODN)'
              'Tax Invoice Date'
              'Payment Terms'
              'Sales Order No.'
              'Sales Order Date'
              'Customer PO. NO.'
              'Customer PO. Date'
              'Amt Document Currency'
              'Currency Key'
              'Total Inv Amt (INR)'
              'Total Rec/Cre Memo Amt (INR)'
              'Total Outstanding'
              'Not Due'
              rc17
              rc18
              rc19
              rc20
              rc21
              rc22
              rc23
              rc14
              'Over Due Days'
              'Refresh Date'
              'Exchange Rate'
              INTO pd_csv
                SEPARATED BY l_field_seperator.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM send_mail .


  DATA : lv_subject   TYPE so_obj_des,
         lt_mail_body TYPE bcsy_text,
*         ls_message   TYPE soli,
*         lt_message   TYPE solisti1,
         lt_message   TYPE TABLE OF solisti1,
         ls_message   LIKE LINE OF lt_message,
         lt_headings  TYPE bcsy_text,
         ls_headings  TYPE soli,
         lt_solix     TYPE solix_tab.

  TYPES : BEGIN OF ty_rec,
            email_id TYPE ad_smtpadr,
          END OF ty_rec .

  DATA : ls_rec TYPE  ty_rec,
         lt_rec TYPE TABLE OF  ty_rec.

  DATA : gv_sale_off   TYPE char50,

         it_reclist    TYPE STANDARD TABLE OF  somlreci1,
         wa_it_reclist TYPE  somlreci1,

         imessage      TYPE STANDARD TABLE OF  solisti1,
         wa_imessage   LIKE LINE OF imessage,

         lo_mail_app   TYPE REF TO zcl_mail_app,

         i_line        TYPE TABLE OF ty_down,
         w_line        TYPE ty_down.

  CREATE OBJECT lo_mail_app .

  lt_ofic[] = it_down[] .
  SORT lt_ofic BY sale_off.
  DELETE ADJACENT DUPLICATES FROM lt_ofic COMPARING sale_off.

*  BREAK primus.
  LOOP AT lt_ofic INTO ls_ofic.

* e-mail receivers.
    gv_sale_off = ls_ofic-sale_off.
    SHIFT gv_sale_off LEFT DELETING LEADING space.
    TRANSLATE gv_sale_off TO UPPER CASE.

    SELECT * FROM zcust_mail
    INTO TABLE lt_mail
    WHERE zoffice = gv_sale_off.


    REFRESH lt_rec.
    LOOP AT lt_mail INTO ls_mail WHERE zoffice = gv_sale_off.

      CHECK ls_mail-zto IS NOT INITIAL.
      ls_rec-email_id = ls_mail-zto.
      APPEND ls_rec TO lt_rec.
      CLEAR ls_rec.

    ENDLOOP.

    IF lt_rec IS NOT INITIAL.
      " populate the text for body of the mail

      lv_subject = 'Customer Ageing Report'.


      REFRESH lt_message.
      ls_message-line  = 'Dear Sir/Madam,'.
      APPEND ls_message TO lt_message.
      CLEAR ls_message.

      ls_message-line =   'Please find below the Attachment of Customer Ageing Report'.
      APPEND ls_message TO lt_message.
      CLEAR ls_message.


      REFRESH i_line.
      LOOP AT it_down INTO wa_down WHERE sale_off = ls_ofic-sale_off.

*        CONCATENATE
        w_line-group           =  wa_down-group.
        w_line-sale            =  wa_down-sale.
        w_line-sale_off        =  wa_down-sale_off.
        w_line-kunnr           =  wa_down-kunnr.
        w_line-tdisp           =  wa_down-tdisp.
        w_line-bldat           =  wa_down-bldat.
        w_line-budat           =  wa_down-budat.
        w_line-akont           =  wa_down-akont.
        w_line-rec_txt         =  wa_down-rec_txt.
        w_line-duedate         =  wa_down-duedate.
        w_line-blart           =  wa_down-blart.
        w_line-belnr           =  wa_down-belnr.
        w_line-vbeln           =  wa_down-vbeln.
        w_line-xblnr           =  wa_down-xblnr.
        w_line-fkdat           =  wa_down-fkdat.
        w_line-vtext           =  wa_down-vtext.
        w_line-aubel           =  wa_down-aubel.
        w_line-audat           =  wa_down-audat.
        w_line-bstkd           =  wa_down-bstkd.
        w_line-bstdk           =  wa_down-bstdk.
        w_line-curr            =  wa_down-curr.
        w_line-waers           =  wa_down-waers.
        w_line-debit           =  wa_down-debit.
        w_line-credit          =  wa_down-credit.
        w_line-netbal          =  wa_down-netbal.
        w_line-not_due         =  wa_down-not_due.
        w_line-netb30          =  wa_down-netb30.
        w_line-netb60          =  wa_down-netb60.
        w_line-netb90          =  wa_down-netb90.
        w_line-netb120         =  wa_down-netb120.
        w_line-netb180         =  wa_down-netb180.
        w_line-netb360         =  wa_down-netb360.
        w_line-netb720         =  wa_down-netb720.
        w_line-netb1000        =  wa_down-netb1000.
        w_line-day             =  wa_down-day.
        w_line-ref             =  wa_down-ref.
        w_line-kursf            =  wa_down-kursf.

        APPEND w_line TO i_line.
        CLEAR : w_line, wa_down.

      ENDLOOP.

      REFRESH lt_headings.

      ls_headings-line  = 'GL Type'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Sales Office'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Sales Office Description'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Customer Code'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Customer Code Name'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Document Date'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Posting Date'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Reconciliation Account'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Reconciliation Account Desc'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Due Date'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'FI Doc Type'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Accounting Doc No.'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Billing Doc.No.'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Tax Invoice No.(ODN)'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Tax Invoice Date'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Payment Terms'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Sales Order No.'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Sales Order Date'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Customer PO. NO.'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Customer PO. Date'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Amt Document Currency'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Currency Key'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Total Inv Amt (INR)'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Total Rec/Cre Memo Amt (INR)'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Total Outstanding'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.


      ls_headings-line  = 'Not Due'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc17.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc18.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc19.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc20.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc21.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc22.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc23.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = rc14.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Over Due Days'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

      ls_headings-line  = 'Refresh Date'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.

       ls_headings-line  = 'Exchange Rate'.
      APPEND ls_headings TO lt_headings.
      CLEAR ls_headings.


       REFRESH lt_mail_body.
      CALL METHOD lo_mail_app->add_body_msg
        EXPORTING
          im_t_message = lt_message
        CHANGING
          ch_t_body    = lt_mail_body.

      CLEAR lt_message.


*  For attachment
      REFRESH lt_solix.
      CALL METHOD lo_mail_app->create_attachment
        EXPORTING
          im_t_headings = lt_headings
          im_t_data     = i_line
*         im_v_pdf      =
        IMPORTING
          ex_t_solix    = lt_solix.

      CALL METHOD lo_mail_app->send_mail
        EXPORTING
          im_t_receivers  = lt_rec
          im_subject      = lv_subject
          im_t_body       = lt_mail_body
          im_t_attach_hex = lt_solix
          im_att_type     = 'XLS'
          im_att_subj     = 'Customer Ageing Report'.

    ENDIF.
  ENDLOOP.
ENDFORM.
