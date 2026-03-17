 REPORT  zfi_ven_ageing_msme.


**************TABLE DECLARATION
 DATA:
   tmp_lifnr TYPE bsik-lifnr,
   tmp_ekorg TYPE lfm1-ekorg.
* TABLES: bsik,lfa1, bsak, lfb1,lfm1.
 TYPE-POOLS : slis.

**************DATA DECLARATION

 DATA : date1 TYPE sy-datum, date2 TYPE sy-datum, date3 TYPE i.

 DATA : lv_j_1issist TYPE lfa1-j_1issist. "rushi

 DATA   fs_layout TYPE slis_layout_alv.
 DATA : fm_name TYPE rs38l_fnam.
 DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE.


*Internal Table for sorting
 DATA t_sort TYPE slis_t_sortinfo_alv WITH HEADER LINE.

 TYPES:
   BEGIN OF t_tvzbt,
     zterm TYPE tvzbt-zterm,
     vtext TYPE tvzbt-vtext,
   END OF t_tvzbt,
   tt_tvzbt TYPE STANDARD TABLE OF t_tvzbt.

 TYPES : """RUSHI N
   BEGIN OF ty_lfa1,
     j_1issist TYPE lfa1-j_1issist,
   END OF ty_lfa1.

 DATA : ty_ifa12 TYPE TABLE  OF ty_lfa1.

 TYPES:
   BEGIN OF t_skat,
     saknr TYPE skat-saknr,
     txt50 TYPE skat-txt50,
   END OF t_skat,
   tt_skat TYPE STANDARD TABLE OF t_skat.

 TYPES: BEGIN OF idata ,
          name1       LIKE lfa1-name1,          "Vendor Name
          ktokk       LIKE lfa1-ktokk,          " Vendor account group
          lifnr       LIKE bsik-lifnr,          "Vendor Code
          xblnr       LIKE bkpf-xblnr,          "Vendor Invoice No.    bkpf-xblnr                               "***************ADDED BY SP 12.05.2023
          landl       LIKE bsik-landl,
          shkzg       LIKE bsik-shkzg,          "debit/credit s/h
          bukrs       LIKE bsik-bukrs,          "Company Code
          augbl       LIKE bsik-augbl,          "Clearing Doc No
          auggj       LIKE bsik-auggj,
          augdt       LIKE bsik-augdt,          "Clearing Date
          gjahr       LIKE bkpf-gjahr,          "Fiscal year
          belnr       LIKE bsik-belnr,          "Document no.
          umskz       LIKE bsik-umskz,          "Special G/L indicator
          buzei       LIKE bsik-buzei,          "Line item no.
          budat       LIKE bsik-budat,          "Posting date in the document
          bldat       LIKE bsik-bldat,          "Document date in document
          waers       LIKE bsik-waers,          "Currency
          blart       LIKE bsik-blart,          "Doc. Type
          dmbtr       LIKE bsik-dmbtr,          "Amount in local curr.
          wrbtr       TYPE bsik-wrbtr,
          rebzg       LIKE bsik-rebzg,          "refr inv no
          rebzj       LIKE bsik-rebzj,          "Fiscal year
          rebzz       LIKE bsik-rebzz,          "Line Item no
          duedate     LIKE bsik-augdt,          "MSME Date
          duedate1    LIKE bsik-augdt,         "Due Date
          zfbdt       LIKE bsik-zfbdt,
          zterm       LIKE bsik-zterm,         "Payment Term
          zbd1t       LIKE bsik-zbd1t,         "Cash Discount Days 1
          zbd2t       LIKE bsik-zbd2t,         "Cash Discount Days 2
          zbd3t       LIKE bsik-zbd3t,         "Cash Discount Days 3
          day         TYPE i,
          debit       LIKE bsik-dmbtr,         "Amount in local curr.
          credit      LIKE bsik-dmbtr,         "Amount in local curr.
          not_due_db  LIKE bsik-dmbtr,
          not_due_cr  LIKE bsik-dmbtr,
          not_due     LIKE bsik-dmbtr,
          netbal      LIKE bsik-dmbtr,         "Amount in local curr.
          debit30     LIKE bsik-dmbtr,        "Amount in local curr.
          credit30    LIKE bsik-dmbtr,       "Amount in local curr.
          netb30      LIKE bsik-dmbtr,         "Amount in local curr.
          debit60     LIKE bsik-dmbtr,        "Amount in local curr.
          credit60    LIKE bsik-dmbtr,       "Amount in local curr.
          netb60      LIKE bsik-dmbtr,         "Amount in local curr.
          debit90     LIKE bsik-dmbtr,        "Amount in local curr.
          credit90    LIKE bsik-dmbtr,       "Amount in local curr.
          netb90      LIKE bsik-dmbtr,         "Amount in local curr.
          debit120    LIKE bsik-dmbtr,       "Amount in local curr.
          credit120   LIKE bsik-dmbtr,      "Amount in local curr.
          netb120     LIKE bsik-dmbtr,         "Amount in local curr.
          debit180    LIKE bsik-dmbtr,       "Amount in local curr.
          credit180   LIKE bsik-dmbtr,      "Amount in local curr.
          netb180     LIKE bsik-dmbtr,         "Amount in local curr.
          debit360    LIKE bsik-dmbtr,       "Amount in local curr.
          credit360   LIKE bsik-dmbtr,      "Amount in local curr.
          netb360     LIKE bsik-dmbtr,         "Amount in local curr.

**********************NOT DUE***********************************
          debit_n60   LIKE bsik-dmbtr,        "Amount in local curr.
          credit_n60  LIKE bsik-dmbtr,       "Amount in local curr.
          netb_n60    LIKE bsik-dmbtr,         "Amount in local curr.
          debit_n90   LIKE bsik-dmbtr,        "Amount in local curr.
          credit_n90  LIKE bsik-dmbtr,       "Amount in local curr.
          netb_n90    LIKE bsik-dmbtr,         "Amount in local curr.
          debit_n120  LIKE bsik-dmbtr,       "Amount in local curr.
          credit_n120 LIKE bsik-dmbtr,      "Amount in local curr.
          netb_n120   LIKE bsik-dmbtr,         "Amount in local curr.
          debit_n180  LIKE bsik-dmbtr,       "Amount in local curr.
          credit_n180 LIKE bsik-dmbtr,      "Amount in local curr.
          netb_n180   LIKE bsik-dmbtr,         "Amount in local curr.
          debit_n360  LIKE bsik-dmbtr,       "Amount in local curr.
          credit_n360 LIKE bsik-dmbtr,      "Amount in local curr.
          netb_n360   LIKE bsik-dmbtr,         "Amount in local curr.
******************************************************************
          curr        TYPE bsik-dmbtr,
          tdisp       TYPE char50,
          group       TYPE string,
          akont       LIKE knb1-akont,          "Reconciliation account in gener
          vtext       TYPE char200,
          rec_txt     TYPE char70,     "Reconcilation Account text
          pdc         TYPE bsik-dmbtr,
          grn_dt      TYPE mkpf-budat,
          invoice     TYPE bkpf-belnr,
          status      TYPE string,
          j_1issist   TYPE lfa1-j_1issist, "RUSHI N
          no_days_due TYPE i, "Shubham
        END OF idata.


 TYPES:
   BEGIN OF t_bkpf,
     bukrs TYPE bkpf-bukrs,
     belnr TYPE bkpf-belnr,
     gjahr TYPE bkpf-gjahr,
     xblnr TYPE bkpf-xblnr,                                                    "***************ADDED BY SP 09.05.2023
     awkey TYPE bkpf-awkey,
     year  TYPE bkpf-gjahr,                                   "rseg-gjahr,
     awtyp TYPE bkpf-awtyp,
   END OF t_bkpf,
   tt_bkpf TYPE STANDARD TABLE OF t_bkpf.

 TYPES:
   BEGIN OF t_rseg,
     belnr TYPE rseg-belnr,
     gjahr TYPE rseg-gjahr,
     buzei TYPE rseg-buzei,
     ebeln TYPE rseg-ebeln,
     ebelp TYPE rseg-ebelp,
     pstyp TYPE rseg-pstyp,
     lfbnr TYPE rseg-lfbnr,
     lfgja TYPE rseg-lfgja,
   END OF t_rseg,
   tt_rseg TYPE STANDARD TABLE OF t_rseg.

 TYPES:
   BEGIN OF t_ekbe,
     ebeln TYPE ekbe-ebeln,
     ebelp TYPE ekbe-ebelp,
     zekkn TYPE ekbe-zekkn,
     gjahr TYPE ekbe-gjahr,
     belnr TYPE ekbe-belnr,
     budat TYPE ekbe-budat,
     lfbnr TYPE ekbe-lfbnr,
     lfgja TYPE ekbe-lfgja,
   END OF t_ekbe,
   tt_ekbe TYPE STANDARD TABLE OF t_ekbe.

 TYPES:
   BEGIN OF t_mkpf,
     mblnr TYPE mkpf-mblnr,
     mjahr TYPE mkpf-mjahr,
     budat TYPE mkpf-bldat,
     lfbnr TYPE mseg-lfbnr,
     lfbja TYPE mseg-lfbja,
   END OF t_mkpf,
   tt_mkpf TYPE STANDARD TABLE OF t_mkpf.


 DATA : BEGIN OF t_lifnr OCCURS 0,
          lifnr TYPE lfm1-lifnr,
        END OF t_lifnr.
 DATA: rp01(3) TYPE n,                                    "   0
       rp02(3) TYPE n,                                    "  20
       rp03(3) TYPE n,                                    "  40
       rp04(3) TYPE n,                                    "  80
       rp05(3) TYPE n,                                    " 100
       rp06(3) TYPE n,                                    "   1
       rp07(3) TYPE n,                                    "  21
       rp08(3) TYPE n,                                    "  41
       rp09(3) TYPE n,                                    "  81
       rp10(3) TYPE n.                                    " 101

 DATA: rc01(14) TYPE c,                                     "  0
       rc02(14) TYPE c,                                   "  20
       rc03(14) TYPE c,                                   "  40
       rc04(14) TYPE c,                                   "  80
       rc05(14) TYPE c,                                   " 100
       rc06(14) TYPE c,                                   "   1
       rc07(14) TYPE c,                                   "  21
       rc08(14) TYPE c,                                   "  41
       rc09(14) TYPE c,                                   "  81
       rc10(14) TYPE c,                                   " 101
       rc11(14) TYPE c,                                   " 101
       rc12(14) TYPE c,                                   " 101
       rc13(14) TYPE c,                                   " 101
       rc14(14) TYPE c,                                   " 101
       rc15(14) TYPE c,                                   " 101
       rc16(14) TYPE c,                                   " 101
       rc17(14) TYPE c,                                   " 101
       rc18(14) TYPE c,                                   " 101
       rc19(14) TYPE c,                                   " 101
       rc20(14) TYPE c,                                   " 101
       rc21(14) TYPE c,                                   " 101
       rc22(14) TYPE c,                                   " 101
       rc23(14) TYPE c,                                   " 101
       rc24(14) TYPE c.                                   " 101

 DATA: itab  TYPE idata OCCURS 0 WITH HEADER LINE.

 TYPES:
   BEGIN OF t_file,
     tdisp     TYPE char50,
     rec_txt   TYPE char70,
     group     TYPE char10,
     xblnr     TYPE bkpf-xblnr,           "BSIK-XBLNR                                              "***************ADDED BY SP 12.05.2023
     belnr     TYPE bsik-belnr,
     blart     TYPE bsik-blart,
     budat     TYPE char11,
     bldat     TYPE char11,
     duedate   TYPE char11,
     grn_dt    TYPE char11,
     vtext     TYPE char120,
     curr      TYPE char15,
     waers     TYPE bsik-waers,
     credit    TYPE char15,
     debit     TYPE char15,
     netbal    TYPE char15,
     netb30    TYPE char15,
     netb60    TYPE char15,
     netb90    TYPE char15,
     netb120   TYPE char15,
     netb180   TYPE char15,
     netb360   TYPE char15,
     not_due   TYPE char15,
     netb_n60  TYPE char15,
     netb_n90  TYPE char15,
     netb_n120 TYPE char15,
     netb_n180 TYPE char15,
     netb_n360 TYPE char15,
     day       TYPE char10,
     pdc       TYPE char15,
     curr_dt   TYPE char11,
     invoice   TYPE char10,
     status    TYPE string,
*     j_1issist TYPE lfa1-j_1issist,  " RUSHI N
     no_days_due TYPE i,             "Shubham
   END OF t_file,

   tt_file TYPE STANDARD TABLE OF t_file.

******************SELECTION SCREEN

 SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-001.
   PARAMETERS: plant LIKE bsik-bukrs  OBLIGATORY DEFAULT '1000'.
   SELECT-OPTIONS: lifnr FOR tmp_lifnr.
*                 ekorg FOR tmp_ekorg.
*                 akont FOR lfb1-akont.
   PARAMETERS: date  LIKE bkpf-budat DEFAULT sy-datum OBLIGATORY.                "no-extension obligatory.
   SELECTION-SCREEN BEGIN OF LINE.

     SELECTION-SCREEN COMMENT 01(30) TEXT-026 FOR FIELD rastbis1.

     SELECTION-SCREEN POSITION POS_LOW.

     PARAMETERS: rastbis1 LIKE rfpdo1-allgrogr DEFAULT '000'.
     PARAMETERS: rastbis2 LIKE rfpdo1-allgrogr DEFAULT '030'.
     PARAMETERS: rastbis3 LIKE rfpdo1-allgrogr DEFAULT '060'.
     PARAMETERS: rastbis4 LIKE rfpdo1-allgrogr DEFAULT '090'.
     PARAMETERS: rastbis5 LIKE rfpdo1-allgrogr DEFAULT '120'.

   SELECTION-SCREEN END OF LINE.

 SELECTION-SCREEN END OF BLOCK a1.

 SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME.
   PARAMETERS: r1 RADIOBUTTON GROUP abc DEFAULT 'X',
               r2 RADIOBUTTON GROUP abc.
 SELECTION-SCREEN: END OF BLOCK b1.

 SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002.
   PARAMETERS p_down AS CHECKBOX.
   PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'."India'."temp'.
 SELECTION-SCREEN END OF BLOCK b5.


SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


***********************Initialization.

 INITIALIZATION.

**************************************************
 AT SELECTION-SCREEN.

   IF rastbis1 GT '998'
   OR rastbis2 GT '998'
   OR rastbis3 GT '998'
   OR rastbis4 GT '998'
   OR rastbis5 GT '998'.

     SET CURSOR FIELD rastbis5.
     MESSAGE 'Enter a consistent sorted list' TYPE 'E'.     "e381.
   ENDIF.

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

   rp01 = rastbis1.
   rp02 = rastbis2.
   rp03 = rastbis3.
   rp04 = rastbis4.
   rp05 = rastbis5.

   rp06 = rp01 + 1.
   IF NOT rp02 IS INITIAL.
     rp07 = rp02 + 1.
   ELSE.
     rp07 = ''.
   ENDIF.
   IF NOT rp03 IS INITIAL.
     rp08 = rp03 + 1.
   ELSE.
     rp08 = ''.
   ENDIF.
   IF NOT rp04 IS INITIAL.
     rp09 = rp04 + 1.
   ELSE.
     rp09 = ''.
   ENDIF.
   IF NOT rp05 IS INITIAL.
     rp10 = rp05 + 1.
   ELSE.
     rp10 = ''.
   ENDIF.

   IF NOT rp01 IS INITIAL.
     CONCATENATE 'Upto'    rp01 'Dr' INTO rc01 SEPARATED BY space.
     CONCATENATE 'Upto'    rp01 'Cr' INTO rc06 SEPARATED BY space.
     CONCATENATE '000 to'  rp01 'Net Bal' INTO rc13 SEPARATED BY space.
     CONCATENATE '-000 to'  rp01 'Net Bal' INTO rc19 SEPARATED BY space.

   ELSE.
     CONCATENATE 'Upto'    rp01 'Dr' INTO rc01 SEPARATED BY space.
     CONCATENATE 'Upto'    rp01 'Cr' INTO rc06 SEPARATED BY space.
     CONCATENATE rp01 'Days'  INTO rc13 SEPARATED BY space.
     CONCATENATE '-'  rp01 'Days' INTO rc19 SEPARATED BY space.
   ENDIF.

   IF NOT rp02 IS INITIAL.
     CONCATENATE rp06 'To' rp02 'Dr' INTO rc02 SEPARATED BY space.
     CONCATENATE rp06 'To' rp02 'Cr' INTO rc07 SEPARATED BY space.
     CONCATENATE rp06 'To' rp02 'Net Bal' INTO rc14 SEPARATED BY space.
     CONCATENATE '-' rp06 'To -' rp02 'Net Bal' INTO rc20 SEPARATED BY space.
   ELSEIF rp03 IS INITIAL.
     CONCATENATE rp06 '& Above' 'Dr' INTO rc02 SEPARATED BY space.
     CONCATENATE rp06 '& Above' 'Cr' INTO rc07 SEPARATED BY space.
     CONCATENATE rp06 '& Above' 'Net Bal' INTO rc14 SEPARATED BY space.
     CONCATENATE '-' rp06 '& Above' 'Net Bal' INTO rc20 SEPARATED BY space.
   ENDIF.

   IF NOT rp03 IS INITIAL.
     CONCATENATE rp07 'To' rp03 'Dr' INTO rc03 SEPARATED BY space.
     CONCATENATE rp07 'To' rp03 'Cr' INTO rc08 SEPARATED BY space.
     CONCATENATE rp07 'To' rp03 'Net Bal' INTO rc15 SEPARATED BY space.
     CONCATENATE '-' rp07 'To -' rp03 'Net Bal' INTO rc21 SEPARATED BY space.
   ELSEIF rp02 IS INITIAL.
     rc03 = ''.
     rc08 = ''.
     rc15 = ''.
     rc21 = ''.
   ELSEIF rp04 IS INITIAL.
     CONCATENATE rp07 '& Above' 'Dr' INTO rc03 SEPARATED BY space.
     CONCATENATE rp07 '& Above' 'Cr' INTO rc08 SEPARATED BY space.
     CONCATENATE rp07 '& Above' 'Net Bal' INTO rc15 SEPARATED BY space.
     CONCATENATE '-' rp07 '& Above' 'Net Bal' INTO rc21 SEPARATED BY space.
   ENDIF.

   IF NOT rp04 IS INITIAL .
     CONCATENATE rp08 'To' rp04 'Dr' INTO rc04 SEPARATED BY space.
     CONCATENATE rp08 'To' rp04 'Cr' INTO rc09 SEPARATED BY space.
     CONCATENATE rp08 'To' rp04 'Net Bal' INTO rc16 SEPARATED BY space.
     CONCATENATE '-' rp08 'To -' rp04 'Net Bal' INTO rc22 SEPARATED BY space.
   ELSEIF rp03 IS INITIAL.
     rc04 = ''.
     rc09 = ''.
     rc16 = ''.
     rc22 = ''.
   ELSEIF rp05 IS INITIAL.
     CONCATENATE rp08 '& Above' 'Dr' INTO rc04 SEPARATED BY space.
     CONCATENATE rp08 '& Above' 'Cr' INTO rc09 SEPARATED BY space.
     CONCATENATE rp08 '& Above' 'Net Bal' INTO rc16 SEPARATED BY space.
     CONCATENATE '-' rp08 '& Above' 'Net Bal' INTO rc22 SEPARATED BY space.
   ENDIF.

   IF NOT rp05 IS INITIAL.
     CONCATENATE rp09 'To' rp05 'Dr' INTO rc05 SEPARATED BY space.
     CONCATENATE rp09 'To' rp05 'Cr' INTO rc10 SEPARATED BY space.
     CONCATENATE rp09 'To' rp05 'Net Bal' INTO rc17 SEPARATED BY space.
     CONCATENATE '-' rp09 'To -' rp05 'Net Bal' INTO rc23 SEPARATED BY space.
   ELSEIF rp04 IS INITIAL.
     rc05 = ''.
     rc10 = ''.
     rc17 = ''.
     rc23 = ''.
   ELSE.
     CONCATENATE rp09 '& Above' 'Dr' INTO rc05 SEPARATED BY space.
     CONCATENATE rp09 '& Above' 'Cr' INTO rc10 SEPARATED BY space.
     CONCATENATE rp09 '& Above' 'Net Bal' INTO rc17 SEPARATED BY space.
     CONCATENATE '-' rp09 '& Above' 'Net Bal' INTO rc23 SEPARATED BY space.
   ENDIF.

   IF NOT rp10 IS INITIAL.
     CONCATENATE rp10 '& Above' 'Dr' INTO rc11 SEPARATED BY space.
     CONCATENATE rp10 '& Above' 'Cr' INTO rc12 SEPARATED BY space.
     CONCATENATE rp10 '& Above' 'Net Bal' INTO rc18 SEPARATED BY space.
     CONCATENATE '-' rp10 '& Above' 'Net Bal' INTO rc24 SEPARATED BY space.

   ENDIF.


*******************************************
*******************************************

***   IF lifnr IS INITIAL AND ekorg IS NOT INITIAL .
***
***     SELECT lifnr FROM lfm1 INTO TABLE t_lifnr WHERE ekorg IN ekorg.
***
***     IF t_lifnr[] IS NOT INITIAL .
***
***       LOOP AT t_lifnr .
***         lifnr-sign = 'I'.
***         lifnr-option = 'EQ'.
***         lifnr-low = t_lifnr-lifnr.
***         APPEND lifnr.
***
***       ENDLOOP.
***     ENDIF.
***   ENDIF.
*******************************************
 START-OF-SELECTION.

   PERFORM datalist_bsik.

   PERFORM fill_fieldcatalog.
   PERFORM sort_list.
   PERFORM fill_layout.
   PERFORM list_display.

 END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  datalist_bsik
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM datalist_bsik .
   DATA:
     lv_ktopl TYPE t001-ktopl,
     lv_index TYPE sy-index,
     lv_day   TYPE i.

   DATA:
     ls_faede_i TYPE faede,
     ls_faede_e TYPE faede,
     lt_tvzbt   TYPE tt_tvzbt,
     ls_tvzbt   TYPE t_tvzbt,
     lt_skat    TYPE tt_skat,
     ls_skat    TYPE t_skat,
     lt_bkpf    TYPE tt_bkpf,
     ls_bkpf    TYPE t_bkpf,
     lt_rseg    TYPE tt_rseg,
     lt_rseg_s  TYPE tt_rseg,
     lt_rseg_1  TYPE tt_rseg,
     ls_rseg    TYPE t_rseg,
     lt_ekbe    TYPE tt_ekbe,
     ls_ekbe    TYPE t_ekbe,
     lt_mkpf    TYPE tt_mkpf,
     ls_mkpf    TYPE t_mkpf,
     lt_clear   TYPE STANDARD TABLE OF idata,
     lt_data    TYPE STANDARD TABLE OF idata,
     ls_data    TYPE idata,
     lt_partial TYPE STANDARD TABLE OF idata.


   SELECT bsik~bukrs
          bsik~lifnr
          bsik~augbl
          bsik~auggj
          bsik~augdt

         bsik~xblnr                                                             """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""added by sp 12.05.2023

          gjahr
          belnr
          augbl
          buzei
          budat
          bldat
          bsik~waers
          blart
          shkzg
          dmbtr
*          LFB1~WRBTR     """NC 07.07.2025
          bsik~wrbtr  """ NC 07.07.2025
          rebzg
          rebzj
          rebzz
          umskz
          bsik~zterm
          zbd1t
          zbd2t
          zbd3t
          zfbdt
          landl
*      lfa1~name1
*      lfa1~ktokk
     lfb1~akont
 INTO CORRESPONDING FIELDS OF TABLE itab
                             FROM bsik INNER JOIN lfb1 ON lfb1~lifnr = bsik~lifnr AND lfb1~bukrs = bsik~bukrs
                              WHERE bsik~bukrs = plant
                              AND   bsik~lifnr IN lifnr
                              AND   umskz <> 'F'
                              AND   budat <= date.
*                              AND   lfb1~akont IN akont .
*                               and   lfa1~ktokk in ktokk.

   IF NOT itab[] IS INITIAL.
     SELECT bsik~bukrs
          bsik~lifnr
          bsik~augbl
          bsik~auggj
          bsik~augdt

         bsik~xblnr""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""ADDED BY SPN 12.05.2023

          gjahr
          belnr
          augbl
          buzei
          budat
          bldat
*          LFB1~WAERS
          bsik~waers
          blart
          shkzg
          dmbtr
*          LFB1~WRBTR   """"" NC 07.07.2025
          bsik~wrbtr   """"" NC 07.07.2025
          rebzg
          rebzj
          rebzz
          umskz
          bsik~zterm
          zbd1t
          zbd2t
          zbd3t
          zfbdt
          blart
          landl
*      lfa1~name1
*      lfa1~ktokk
          lfb1~akont
          INTO CORRESPONDING FIELDS OF TABLE lt_partial
          FROM bsik INNER JOIN lfb1 ON lfb1~lifnr = bsik~lifnr AND lfb1~bukrs = bsik~bukrs
*          FOR ALL ENTRIES IN itab[]
          WHERE bsik~bukrs = plant
          AND   bsik~lifnr IN lifnr
          AND   blart IN ('KZ','KU')
          AND   umskz <> 'F'
          AND   budat > date.
*          AND   rebzg = itab-belnr
*          AND   rebzj = itab-gjahr
*          AND   rebzz = itab-buzei.
   ENDIF.

   SELECT bsak~bukrs
          bsak~lifnr
          augbl
          auggj
          augdt
          gjahr
          belnr
          buzei
          budat
          bldat
*          LFB1~WAERS
          bsak~waers
          blart
          shkzg
          dmbtr
*          LFB1~WRBTR   """"" NC 07.07.2025
            bsak~wrbtr """"""""' NC
          rebzg
          rebzj
          rebzz
          umskz
          bsak~zterm
          zbd1t
          zbd2t
          zbd3t
          zfbdt
          lfb1~akont
          APPENDING CORRESPONDING FIELDS OF TABLE itab
          FROM bsak INNER JOIN lfb1 ON lfb1~lifnr = bsak~lifnr AND lfb1~bukrs = bsak~bukrs
          WHERE bsak~bukrs = plant
          AND   bsak~lifnr IN lifnr
          AND   umskz <> 'F'
          AND   budat <= date
*          AND  augdt = ' '
*          and  augbl <> ' ' AND augbl > date
          AND   augdt > date.

   IF NOT itab[] IS INITIAL.

     SELECT bsak~bukrs
            bsak~lifnr
            augbl
            auggj
            augdt
            gjahr
            belnr
            buzei
            budat
            bldat
            bsak~waers
            blart
            shkzg
            dmbtr
*            LFB1~WRBTR   """"" NC 07.07.2025
             bsak~wrbtr   """"" NC 07.07.2025
            rebzg
            rebzj
            rebzz
            umskz
            bsak~zterm
            zbd1t
            zbd2t
            zbd3t
            zfbdt
           INTO CORRESPONDING FIELDS OF TABLE lt_clear
           FROM bsak INNER JOIN lfb1 ON lfb1~lifnr = bsak~lifnr AND lfb1~bukrs = bsak~bukrs
           FOR ALL ENTRIES IN itab
           WHERE bsak~bukrs = plant
           AND   bsak~lifnr IN lifnr
           AND   blart IN ('KZ','KU')
           AND   umskz <> 'F'
           AND   budat > date
           AND   belnr = itab-augbl
           AND   augdt > date.

     SELECT belnr, bukrs, gjahr, buzei, zbd1t
       FROM bseg
       INTO TABLE @DATA(it_bseg)
       FOR ALL ENTRIES IN @itab
       WHERE belnr = @itab-belnr
         AND bukrs = @itab-bukrs
         AND gjahr = @itab-gjahr
         AND koart = 'K'.

     LOOP AT itab ASSIGNING FIELD-SYMBOL(<ls_itab>).
       READ TABLE it_bseg
        ASSIGNING FIELD-SYMBOL(<ls_bseg>)
        WITH KEY belnr = <ls_itab>-belnr
                 bukrs = <ls_itab>-bukrs
                 gjahr = <ls_itab>-gjahr
                 buzei = <ls_itab>-buzei.
       IF sy-subrc EQ 0.

         <ls_itab>-no_days_due = <ls_bseg>-zbd1t.

         IF <ls_itab>-no_days_due GT 45.
           <ls_itab>-no_days_due = 45.
         ENDIF.

       ENDIF.
     ENDLOOP.


   ENDIF.

   lt_data = itab[].

   SORT itab BY belnr gjahr buzei.
   SORT lt_clear BY augbl gjahr.
   SORT lt_partial BY rebzg rebzj rebzz.
   SORT lt_data BY rebzg rebzj rebzz.


   DELETE itab WHERE rebzg NE space.

   IF NOT itab[] IS INITIAL.
     SELECT zterm
            vtext
       FROM tvzbt
       INTO TABLE lt_tvzbt
       FOR ALL ENTRIES IN itab
       WHERE zterm = itab-zterm
       AND   spras = sy-langu.


     SELECT SINGLE ktopl
                FROM  t001
                INTO  lv_ktopl
                WHERE bukrs = plant.

     SELECT saknr
           txt50
      FROM skat
      INTO TABLE lt_skat
      FOR ALL ENTRIES IN itab
      WHERE saknr = itab-akont
      AND   ktopl = lv_ktopl
      AND   spras = sy-langu.

     IF NOT lt_partial IS INITIAL.
       SELECT saknr
          txt50
     FROM skat
     APPENDING TABLE lt_skat
     FOR ALL ENTRIES IN lt_partial
     WHERE saknr = lt_partial-akont
     AND   ktopl = lv_ktopl
     AND   spras = sy-langu.

     ENDIF.

     SELECT bukrs
            belnr
            gjahr
            xblnr                                                    "***************ADDED BY SP 09.05.2023
            awkey
       FROM bkpf
       INTO TABLE lt_bkpf
       FOR ALL ENTRIES IN itab
       WHERE bukrs = plant
       AND belnr = itab-belnr
       AND   gjahr = itab-gjahr
       AND  awtyp  =  'RMRP' .


     " ------------------------ ADDED BY ANISH ON 16.05.2023 ----------------------"
* ADDED LOGIC FOR VENDOR REFERENCE DOCUMENT NOT SHOWING

     DATA lr_awtyp TYPE RANGE OF bkpf-awtyp.
     CLEAR: lr_awtyp, lr_awtyp[].

     SELECT * FROM tvarvc INTO TABLE @DATA(lt_tvarv) WHERE name EQ 'ZFI_VEN_AGEING'.
     IF lt_tvarv IS NOT INITIAL.

       SORT lt_tvarv BY low ASCENDING.
       DELETE ADJACENT DUPLICATES FROM lt_tvarv COMPARING low.

       lr_awtyp = VALUE #( FOR ls_awtyp IN lt_tvarv ( sign   = 'I'
                                                      option = 'EQ'
                                                      low    = ls_awtyp-low ) ).
     ENDIF.

     SELECT FROM bkpf
            FIELDS bukrs,belnr,gjahr,xblnr
     FOR ALL ENTRIES IN @itab
     WHERE bukrs = @plant
     AND   belnr = @itab-belnr
     AND   gjahr = @itab-gjahr
     AND   awtyp IN @lr_awtyp
     INTO TABLE @DATA(lt_bkpf_new).

     "-----------------------------------------------------------------------------"





**                           ***********************************commented by sp 08.05.2023*****************************************

     IF sy-subrc IS INITIAL.
       LOOP AT lt_bkpf INTO ls_bkpf.
         ls_bkpf-year = ls_bkpf-awkey+10(4).
         MODIFY lt_bkpf FROM ls_bkpf TRANSPORTING year.
       ENDLOOP.

       SELECT belnr
              gjahr
              buzei
              ebeln
              ebelp
              pstyp
              lfbnr
              lfgja
         FROM rseg
         INTO TABLE lt_rseg
         FOR ALL ENTRIES IN lt_bkpf
         WHERE belnr = lt_bkpf-awkey+0(10)
         AND   gjahr = lt_bkpf-year
         AND   bukrs = plant
         AND   lfbnr NE ''.

       IF sy-subrc IS INITIAL.
         SORT lt_rseg BY belnr gjahr. " lfbnr lfgja.
         DELETE ADJACENT DUPLICATES FROM lt_rseg COMPARING belnr gjahr.
         lt_rseg_s[] = lt_rseg[].
         lt_rseg_1[] = lt_rseg[].
         DELETE lt_rseg_s WHERE pstyp NE '9'.
         DELETE lt_rseg_1 WHERE pstyp NE '3'.

         APPEND LINES OF lt_rseg_1 TO lt_rseg_s.

         SELECT mblnr
                mjahr
                budat
                lfbnr_i
                lfbja_i
           FROM wb2_v_mkpf_mseg2
           INTO TABLE lt_mkpf
           FOR ALL ENTRIES IN lt_rseg
           WHERE mblnr = lt_rseg-lfbnr
           AND   mjahr = lt_rseg-lfgja
           AND   bukrs_i = plant.

         IF NOT lt_rseg_s IS INITIAL.
*****
*****           SELECT mblnr
*****                mjahr
*****                budat
*****                lfbnr_i
*****                lfbja_i
*****           FROM wb2_v_mkpf_mseg2
*****           APPENDING TABLE lt_mkpf
*****           FOR ALL ENTRIES IN lt_rseg_s
*****           WHERE lfbnr_i = lt_rseg_s-lfbnr
*****           AND   lfbja_i = lt_rseg_s-lfgja
*****           AND   bwart_i = '101'
*****           AND   bukrs_i = plant  .

           SELECT a~mblnr
                  a~mjahr
                  a~budat
                  b~lfbnr
                  b~lfbja
           FROM mseg AS b INNER JOIN mkpf AS a  ON a~mblnr = b~mblnr AND a~mjahr = b~mjahr
           APPENDING TABLE lt_mkpf
           FOR ALL ENTRIES IN lt_rseg_s
           WHERE bwart = '101'
           AND  lfbnr = lt_rseg_s-lfbnr
           AND  lfbja = lt_rseg_s-lfgja
           AND  bukrs = plant  .





         ENDIF.
         SORT lt_mkpf BY mblnr mjahr.
         DELETE ADJACENT DUPLICATES FROM lt_mkpf COMPARING mblnr mjahr.

**         SELECT ebeln
**              ebelp
**              zekkn
**              gjahr
**              belnr
**              budat
**              lfbnr
**              lfgja
**         FROM ekbe
**         INTO TABLE lt_ekbe
**         FOR ALL ENTRIES IN lt_rseg
**         WHERE belnr = lt_rseg-lfbnr
**         AND   gjahr = lt_rseg-lfgja
**         AND   bewtp ='E'
**         AND   bwart = '101'.
**
**         SELECT ebeln
**             ebelp
**             zekkn
**             gjahr
**             belnr
**             budat
**             lfbnr
**             lfgja
**        FROM ekbe
**        APPENDING TABLE lt_ekbe
**        FOR ALL ENTRIES IN lt_rseg
**        WHERE lfbnr = lt_rseg-lfbnr
**        AND   lfgja = lt_rseg-lfgja
**        AND   bewtp ='E'
**        AND   bwart = '101'.
       ENDIF.
     ENDIF.
   ENDIF.
**   SORT lt_ekbe BY belnr gjahr.
**   DELETE ADJACENT DUPLICATES FROM lt_ekbe COMPARING belnr gjahr.
   LOOP AT itab.

     READ TABLE lt_data INTO ls_data WITH KEY rebzg = itab-belnr
                                        rebzj = itab-gjahr
                                        rebzz = itab-buzei.
     IF sy-subrc IS INITIAL.
       lv_index = sy-tabix.
       LOOP AT lt_data INTO ls_data FROM lv_index.
         IF ls_data-rebzg = itab-belnr AND ls_data-rebzj = itab-gjahr AND ls_data-rebzz = itab-buzei.
           IF ls_data-shkzg = 'H'.
             itab-debit = itab-debit - ls_data-dmbtr.
           ELSE.
             itab-debit = itab-debit + ls_data-dmbtr.
           ENDIF.

         ELSE.
           EXIT.
         ENDIF.
       ENDLOOP.
     ENDIF.
     MODIFY itab TRANSPORTING debit.

   ENDLOOP.

   LOOP AT itab.

***********Calculating DEBIT and CREDIT
     IF itab-shkzg  = 'S'.
       itab-debit  = itab-debit + itab-dmbtr.
     ELSE.
       itab-credit = itab-dmbtr.
     ENDIF.

     IF itab-umskz  = ''.
       itab-group  = 'Normal'.
     ELSE.
       itab-group  = 'Special G/L'.
     ENDIF.
*added by  ganesh primus to add payment days in doc date for due date
*     itab-duedate = itab-bldat + itab-zbd1t.       "+ itab-zbd1t.  "itab-zfbdt

     ls_faede_i-koart = 'K'.
     ls_faede_i-zfbdt = itab-zfbdt.
     ls_faede_i-zbd1t = itab-zbd1t.
     ls_faede_i-zbd2t = itab-zbd2t.
     ls_faede_i-zbd3t = itab-zbd3t.

     CALL FUNCTION 'DETERMINE_DUE_DATE'
       EXPORTING
         i_faede                    = ls_faede_i
*        I_GL_FAEDE                 =
       IMPORTING
         e_faede                    = ls_faede_e
       EXCEPTIONS
         account_type_not_supported = 1
         OTHERS                     = 2.
     IF sy-subrc <> 0.
* Implement suitable error handling here
     ENDIF.

*     itab-duedate = ls_faede_e-netdt.

     READ TABLE lt_bkpf INTO ls_bkpf
      WITH KEY belnr = itab-belnr
               gjahr = itab-gjahr
               bukrs = itab-bukrs.
     IF sy-subrc EQ 0.

       READ TABLE lt_rseg INTO ls_rseg WITH KEY belnr = ls_bkpf-awkey+0(10)
                                                gjahr = ls_bkpf-year.
       IF sy-subrc IS INITIAL.

         READ TABLE lt_mkpf INTO ls_mkpf WITH KEY mblnr = ls_rseg-lfbnr
                                                  mjahr = ls_rseg-lfgja.
         IF sy-subrc IS INITIAL.
           itab-grn_dt = ls_mkpf-budat.
         ELSE.
           READ TABLE lt_mkpf INTO ls_mkpf WITH KEY lfbnr = ls_rseg-lfbnr
                                                    lfbja = ls_rseg-lfgja.
           IF sy-subrc IS INITIAL.
             itab-grn_dt = ls_mkpf-budat.
           ENDIF.
         ENDIF.
       ENDIF.

     ENDIF.

     IF itab-grn_dt IS INITIAL.
       itab-duedate = itab-bldat + itab-no_days_due .
     ELSE.
       itab-duedate = itab-grn_dt + itab-no_days_due .
     ENDIF.

     IF r1 = 'X'.
       IF itab-bldat >= date.
         itab-day  = 0.
       ELSE.
         itab-day     = date - itab-bldat.
       ENDIF.
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
               ELSE.
                 IF itab-day > rastbis5.
                   itab-debit360  = itab-debit.
                   itab-credit360 = itab-credit.
                   itab-netb360   = itab-debit360 - itab-credit360.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
     ELSE.
       IF itab-duedate = date.
         itab-day  = 0.
       ELSE.
         itab-day     = date - itab-duedate.
       ENDIF.

       IF itab-day >= 0  .
         IF itab-day <= rastbis1.
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
                 ELSE.
                   IF itab-day > rastbis5.
                     itab-debit360  = itab-debit.
                     itab-credit360 = itab-credit.
                     itab-netb360   = itab-debit360 - itab-credit360.
                   ENDIF.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ELSE.
         lv_day = itab-day * -1.
         itab-not_due_db = itab-debit.
         itab-not_due_cr = itab-credit.
         itab-not_due    = itab-not_due_db - itab-not_due_cr.

**         IF lv_day <= rastbis1.
**
**           itab-debit_n30  = itab-debit.
**           itab-credit_n30 = itab-credit.
**           itab-netb_n30 = itab-debit_n30 - itab-credit_n30.
         IF rastbis2 IS INITIAL.
           itab-debit_n60  = itab-debit.
           itab-credit_n60 = itab-credit.
           itab-netb_n60   = itab-debit_n60 - itab-credit_n60.
         ELSE.
           IF lv_day > rastbis1 AND lv_day <= rastbis2.
             itab-debit_n60  = itab-debit.
             itab-credit_n60 = itab-credit.
             itab-netb_n60   = itab-debit_n60 - itab-credit_n60.
           ELSEIF rastbis3 IS INITIAL.
             itab-debit_n90  = itab-debit.
             itab-credit_n90 = itab-credit.
             itab-netb_n90   = itab-debit_n90 - itab-credit_n90.
           ELSE.
             IF lv_day > rastbis2 AND lv_day <= rastbis3.
               itab-debit_n90  = itab-debit.
               itab-credit_n90 = itab-credit.
               itab-netb_n90   = itab-debit_n90 - itab-credit_n90.
             ELSEIF rastbis4 IS INITIAL.
               itab-debit_n120  = itab-debit.
               itab-credit_n120 = itab-credit.
               itab-netb_n120   = itab-debit_n120 - itab-credit_n120.
             ELSE.
               IF lv_day > rastbis3 AND lv_day <= rastbis4.
                 itab-debit_n120  = itab-debit.
                 itab-credit_n120 = itab-credit.
                 itab-netb_n120   = itab-debit_n120 - itab-credit_n120.
               ELSEIF rastbis5 IS INITIAL.
                 itab-debit_n180  = itab-debit.
                 itab-credit_n180 = itab-credit.
                 itab-netb_n180   = itab-debit_n180 - itab-credit_n180.
               ELSE.
                 IF lv_day > rastbis4 AND lv_day <= rastbis5.
                   itab-debit_n180  = itab-debit.
                   itab-credit_n180 = itab-credit.
                   itab-netb_n180   = itab-debit_n180 - itab-credit_n180.
                 ELSE.
                   IF lv_day > rastbis5.
                     itab-debit_n360  = itab-debit.
                     itab-credit_n360 = itab-credit.
                     itab-netb_n360   = itab-debit_n360 - itab-credit_n360.
                   ENDIF.
                 ENDIF.
               ENDIF.
             ENDIF.
           ENDIF.
         ENDIF.
       ENDIF.
     ENDIF.

**     IF itab-duedate >= date.
**       itab-day = 0.
**     ELSE.
**       itab-day = date - itab-duedate.
**     ENDIF.
***********Net Balance
     itab-netbal = itab-debit - itab-credit.


*   ENDIF.
*     READ TABLE lt_data INTO ls_data
     READ TABLE lt_tvzbt INTO ls_tvzbt WITH KEY zterm = itab-zterm.
     IF sy-subrc IS INITIAL.
       CONCATENATE ls_tvzbt-zterm ls_tvzbt-vtext INTO itab-vtext SEPARATED BY space.
     ENDIF.
     SELECT SINGLE name1 INTO itab-name1 FROM lfa1 WHERE lifnr = itab-lifnr.
     CONCATENATE itab-lifnr itab-name1 INTO itab-tdisp SEPARATED BY space."itab-umskz

     DATA :lv_status TYPE j_1imovend-j_1issist.
     CLEAR lv_status.
     SELECT SINGLE j_1issist INTO lv_status FROM j_1imovend WHERE lifnr = itab-lifnr.
     IF lv_status = '1'.
       itab-status = 'Micro'.
     ELSEIF lv_status = '2'.
       itab-status = 'Small'.
     ELSEIF lv_status = '3'.
       itab-status = 'Medium'.
     ELSEIF lv_status = '4'.
       itab-status = 'NA'.
     ENDIF.

     READ TABLE lt_skat INTO ls_skat WITH KEY saknr = itab-akont.
     IF sy-subrc IS INITIAL.
       CONCATENATE itab-akont ls_skat-txt50 INTO itab-rec_txt SEPARATED BY space.
     ELSE.
       itab-rec_txt = itab-akont.
     ENDIF.
     SHIFT itab-rec_txt LEFT DELETING LEADING '0'.
     SHIFT itab-tdisp LEFT DELETING LEADING '0'.

     READ TABLE lt_clear INTO ls_data WITH KEY belnr = itab-augbl.
     IF sy-subrc IS INITIAL.
       itab-pdc = itab-netbal * -1.
     ELSE.
       READ TABLE lt_partial INTO ls_data WITH KEY rebzg = itab-belnr
                                                   rebzj = itab-gjahr
                                                   rebzz = itab-buzei.
       IF sy-subrc IS INITIAL.
         lv_index = sy-tabix.
         LOOP AT lt_partial INTO ls_data FROM lv_index.
           IF ls_data-rebzg = itab-belnr AND ls_data-rebzj = itab-gjahr AND ls_data-rebzz = itab-buzei.
             itab-pdc = itab-pdc + ls_data-dmbtr.
           ELSE.
             EXIT.
           ENDIF.
         ENDLOOP.
       ENDIF.
     ENDIF.
     READ TABLE lt_bkpf INTO ls_bkpf WITH KEY belnr = itab-belnr
                                              gjahr = itab-gjahr .
     IF sy-subrc IS INITIAL.
       itab-invoice =  ls_bkpf-awkey+0(10).
       itab-xblnr =  ls_bkpf-xblnr.                                                            "***************ADDED BY SP 09.05.2023

       READ TABLE lt_rseg INTO ls_rseg WITH KEY belnr = ls_bkpf-awkey+0(10)
                                                gjahr = ls_bkpf-year.
       IF sy-subrc IS INITIAL.
         READ TABLE lt_mkpf INTO ls_mkpf WITH KEY mblnr = ls_rseg-lfbnr
                                                  mjahr = ls_rseg-lfgja.
         IF sy-subrc IS INITIAL.
           itab-grn_dt = ls_mkpf-budat.
         ELSE.
           READ TABLE lt_mkpf INTO ls_mkpf WITH KEY lfbnr = ls_rseg-lfbnr
                                                    lfbja = ls_rseg-lfgja.
           IF sy-subrc IS INITIAL.
             itab-grn_dt = ls_mkpf-budat.
           ENDIF.
         ENDIF.
       ENDIF.
     ELSE.
       " -------------------------- added by anish on 16.05.2023 ------------------------------------------"
       IF itab-xblnr IS INITIAL.
         IF line_exists( lt_bkpf_new[ bukrs = itab-bukrs belnr = itab-belnr gjahr = itab-gjahr ] ).
           DATA(lv_xblnr) = lt_bkpf_new[ bukrs = itab-bukrs belnr = itab-belnr gjahr = itab-gjahr ]-xblnr.
           itab-xblnr = lv_xblnr.
           CLEAR lv_xblnr.
         ENDIF.
       ENDIF.

       "---------------------------------------------------------------------------------------------------"
     ENDIF.



     IF itab-waers = 'INR'.

       IF NOT itab-debit IS INITIAL.
         itab-curr = itab-dmbtr.
       ELSEIF NOT itab-credit IS INITIAL.
         itab-curr = itab-dmbtr * -1.
       ENDIF.
     ELSE.

       IF NOT itab-debit IS INITIAL.
         itab-curr = itab-wrbtr.
       ELSEIF NOT itab-credit IS INITIAL.
         itab-curr = itab-wrbtr * -1.
       ENDIF.
     ENDIF.

     SELECT SINGLE  j_1issist                         "rushi 14.11.25
     FROM lfa1
     INTO lv_j_1issist
     WHERE lifnr = itab-lifnr.

     IF lv_j_1issist = '1'.
       itab-status = 'Micro'.
       itab-j_1issist = lv_j_1issist.
     ELSEIF lv_j_1issist = '2'.
       itab-status = 'Small'.
       itab-j_1issist = lv_j_1issist.
     ELSEIF lv_j_1issist = '3'.
       itab-status = 'Medium'.
       itab-j_1issist = lv_j_1issist.
     ELSEIF lv_j_1issist = '4'.
       itab-status = 'NA'.
       itab-j_1issist = lv_j_1issist.
     ENDIF.

     MODIFY itab.
     CLEAR:
       ls_data,ls_skat,ls_tvzbt,ls_ekbe,ls_rseg,ls_bkpf,itab,ls_mkpf.
   ENDLOOP.

   LOOP AT lt_partial INTO ls_data WHERE rebzg IS INITIAL.
     READ TABLE itab WITH KEY belnr = ls_data-belnr.
     IF NOT sy-subrc IS INITIAL.
       CLEAR itab.
       itab-gjahr = ls_data-gjahr.
       itab-xblnr = ls_data-xblnr.                                                               "***************ADDED BY SP 09.05.2023
       itab-belnr = ls_data-belnr.
       itab-budat = ls_data-budat.
       itab-bldat = ls_data-bldat.
       itab-duedate1 = ls_data-zfbdt.
       itab-waers = ls_data-waers.
       itab-blart = ls_data-blart.
       itab-pdc = ls_data-dmbtr.
       itab-lifnr = ls_data-lifnr.
       itab-akont = ls_data-akont.
       SELECT SINGLE name1 INTO itab-name1 FROM lfa1 WHERE lifnr = itab-lifnr.

       CONCATENATE itab-lifnr itab-name1 INTO itab-tdisp SEPARATED BY space.

       READ TABLE lt_skat INTO ls_skat WITH KEY saknr = itab-akont.
       IF sy-subrc IS INITIAL.
         CONCATENATE itab-akont ls_skat-txt50 INTO itab-rec_txt SEPARATED BY space.
       ELSE.
         itab-rec_txt = itab-akont.
       ENDIF.
       SHIFT itab-rec_txt LEFT DELETING LEADING '0'.
       SHIFT itab-tdisp LEFT DELETING LEADING '0'.

       IF ls_data-umskz  = ''.
         itab-group  = 'Normal'.
       ELSE.
         itab-group  = 'Special G/L'.
       ENDIF.


       APPEND itab.
     ENDIF.
   ENDLOOP.

   REFRESH lt_bkpf_new.
 ENDFORM.                    " DATALIST_Bsak


*&---------------------------------------------------------------------*
*&      Form  fill_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM fill_fieldcatalog.

   PERFORM f_fieldcatalog USING '1'   'TDISP'     'Vendor Name'.
   PERFORM f_fieldcatalog USING '2'   'REC_TXT'     'Reconciliation Account '.
   PERFORM f_fieldcatalog USING '3'   'GROUP'     'GL Type'.
*   PERFORM f_fieldcatalog USING '2'   'LIFNR'     'Vendor code '.
   PERFORM f_fieldcatalog USING '4'   'XBLNR'     'Vendor Invoice No.'.
   PERFORM f_fieldcatalog USING '5'   'BELNR'     'Doc No.'.
   PERFORM f_fieldcatalog USING '6'   'BLART'     'Doc Type'.
   PERFORM f_fieldcatalog USING '7'   'BUDAT'     'Posting Date'.
   PERFORM f_fieldcatalog USING '8'   'BLDAT'     'Doc Date'.
   PERFORM f_fieldcatalog USING '9'   'DUEDATE'   'MSME Due Date'.
   PERFORM f_fieldcatalog USING '10'  'DUEDATE1' 'Due Date Payment Terms'.
   PERFORM f_fieldcatalog USING '11'   'GRN_DT'    'GRN Date'.
   PERFORM f_fieldcatalog USING '12'   'VTEXT'    'Payment Terms'.
   PERFORM f_fieldcatalog USING '13'   'J_1ISSIST'    'SSI STATUS'. " RUSHI N

   PERFORM f_fieldcatalog USING '14'   'CURR'     'Amt Document Currency'.
   PERFORM f_fieldcatalog USING '15'   'WAERS'    'Currency Key'.
   PERFORM f_fieldcatalog USING '16'   'CREDIT'    'Invoice Amt.'.
   PERFORM f_fieldcatalog USING '17'   'DEBIT'    'Payment/Debit Memo Amt'.
   PERFORM f_fieldcatalog USING '18'  'NETBAL'    'Net Pending'.
   PERFORM f_fieldcatalog USING '19'  'NETB30'    rc13. "'Net Balance'.
   PERFORM f_fieldcatalog USING '20'  'NETB60'    rc14. "'Net Balance'.
   PERFORM f_fieldcatalog USING '21'  'NETB90'    rc15. "'Net Balance'.
   PERFORM f_fieldcatalog USING '22'  'NETB120'   rc16. "'Net Balance'.
   PERFORM f_fieldcatalog USING '23'  'NETB180'   rc17. "'Net Balance'.
   PERFORM f_fieldcatalog USING '24'  'NETB360'   rc18. "'Net Balance'.
   PERFORM f_fieldcatalog USING '25'  'NOT_DUE'   'Not Due'. "'Net Balance'.
*   PERFORM f_fieldcatalog USING '23'  'NETB_N30'   rc19. "'Net Balance'.
   PERFORM f_fieldcatalog USING '26'  'NETB_N60'   rc20. "'Net Balance'.
   PERFORM f_fieldcatalog USING '27'  'NETB_N90'   rc21. "'Net Balance'.
   PERFORM f_fieldcatalog USING '28'  'NETB_N120'  rc22. "'Net Balance'.
   PERFORM f_fieldcatalog USING '29'  'NETB_N180'  rc23. "'Net Balance'.
   PERFORM f_fieldcatalog USING '30'  'NETB_N360'  rc24. "'Net Balance'.
   PERFORM f_fieldcatalog USING '31'  'DAY'       'Over Due Days'.
   PERFORM f_fieldcatalog USING '32'  'PDC'       'PDC Amt.'.
   PERFORM f_fieldcatalog USING '33'  'INVOICE'   'Invoice No.'.
   PERFORM f_fieldcatalog USING '34'  'STATUS'    'MSME Status'.
   PERFORM f_fieldcatalog USING '35'  'NO_DAYS_DUE'    'No of Days for Due Date'.


 ENDFORM.                    " FILL_FIELDCATALOG

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
   wa_header-info = 'MSME Vendor Ageing Report'.
   APPEND wa_header TO t_header.
   CLEAR wa_header.

*  Date
   wa_header-typ  = 'S'.
   wa_header-key  = 'As on: '.
   CONCATENATE wa_header-info date+6(2) '.' date+4(2) '.' date(4) INTO wa_header-info.
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
*&      Form  sort_list
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 FORM sort_list.
   t_sort-spos      = '1'.
   t_sort-fieldname = 'TDISP'.
   t_sort-tabname   = 'ITAB'.
   t_sort-up        = 'X'.
   APPEND t_sort.

   t_sort-spos      = '3'.
   t_sort-fieldname = 'GROUP'.
   t_sort-tabname   = 'ITAB'.
   t_sort-up        = 'X'.
   APPEND t_sort.


*   t_sort-spos      = '3'.
*   t_sort-fieldname = 'NAME1'.
*   t_sort-tabname   = 'ITAB'.
*   t_sort-up        = 'X'.
*
*   APPEND t_sort.


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
      f1 = 'NETB360'  OR f1 = 'PDC'       OR f1 = 'NOT_DUE'  OR f1 = 'NETB_N60' OR
      f1 = 'NETB_N90' OR f1 = 'NETB_N120' OR f1 = 'NETB_N180'  OR f1 = 'NETB_N360'.

     t_fieldcat-do_sum = 'X'.
   ENDIF.

   IF f1 = 'TDISP'.
     t_fieldcat-key = 'X'.
   ENDIF.

   IF  f1 = 'NETB_N60'  OR f1 = 'NETB_N120' OR f1 = 'NETB_N90'
    OR f1 = 'NETB_N180' OR f1 = 'NETB_N360' OR f1 = 'NOT_DUE'.
     t_fieldcat-emphasize = 'C510'.
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

   DELETE itab WHERE status NE 'Micro'
                 AND status NE 'Small'
                 AND status NE 'Medium'.

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
   ENDIF.
 ENDFORM.                    " list_display


*&---------------------------------------------------------------------*
*&      Form  USER_CMD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

 FORM user_cmd USING r_ucomm LIKE sy-ucomm
                     rs_selfield TYPE slis_selfield.
   IF r_ucomm = '&IC1'.
     IF rs_selfield-fieldname = 'BELNR'.
       READ TABLE itab INDEX rs_selfield-tabindex .            "WITH"KEY belnr = rs_selfield-value.     ADDED BY SP 12.05.2023
       IF sy-subrc = 0.                                            "********************************************ADDED BY SP 12.05.2023
         SET PARAMETER ID 'BLN' FIELD rs_selfield-value.
         SET PARAMETER ID 'BUK' FIELD plant.
         SET PARAMETER ID 'GJR' FIELD itab-gjahr.
*       SET PARAMETER ID 'AWT' FIELD transaction.
         CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
       ENDIF.                                                    "********************************************ADDED BY SP 12.05.2023
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

   DATA:
     lt_final TYPE tt_file,
     ls_final TYPE t_file.

*  DATA: lv_folder(150).
   DATA: lv_file(30).
   DATA: lv_fullfile TYPE string,
         lv_dat(10),
         lv_tim(4).
   DATA: lv_msg(80).

   LOOP AT itab.
     ls_final-tdisp   = itab-tdisp.
     ls_final-rec_txt = itab-rec_txt.
     ls_final-group   = itab-group.
     ls_final-xblnr   = itab-xblnr.                                                "***************ADDED BY SP 09.05.2023
     ls_final-belnr   = itab-belnr.
     ls_final-blart   = itab-blart.
     ls_final-vtext   = itab-vtext.
     ls_final-waers   = itab-waers.
     ls_final-invoice = itab-invoice.
     ls_final-status  = itab-status.
     ls_final-no_days_due   = itab-no_days_due.

     IF NOT itab-budat IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = itab-budat
         IMPORTING
           output = ls_final-budat.
       CONCATENATE ls_final-budat+0(2) ls_final-budat+2(3) ls_final-budat+5(4)
                      INTO ls_final-budat SEPARATED BY '-'.
     ENDIF.

     IF NOT itab-bldat IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = itab-bldat
         IMPORTING
           output = ls_final-bldat.
       CONCATENATE ls_final-bldat+0(2) ls_final-bldat+2(3) ls_final-bldat+5(4)
                      INTO ls_final-bldat SEPARATED BY '-'.
     ENDIF.

     IF NOT itab-duedate IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = itab-duedate
         IMPORTING
           output = ls_final-duedate.
       CONCATENATE ls_final-duedate+0(2) ls_final-duedate+2(3) ls_final-duedate+5(4)
                      INTO ls_final-duedate SEPARATED BY '-'.
     ENDIF.

     IF NOT itab-grn_dt IS INITIAL.
       CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
         EXPORTING
           input  = itab-grn_dt
         IMPORTING
           output = ls_final-grn_dt.
       CONCATENATE ls_final-grn_dt+0(2) ls_final-grn_dt+2(3) ls_final-grn_dt+5(4)
                      INTO ls_final-grn_dt SEPARATED BY '-'.
     ENDIF.


     CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
       EXPORTING
         input  = sy-datum
       IMPORTING
         output = ls_final-curr_dt.
     CONCATENATE ls_final-curr_dt+0(2) ls_final-curr_dt+2(3) ls_final-curr_dt+5(4)
                    INTO ls_final-curr_dt SEPARATED BY '-'.

     ls_final-curr           = abs( itab-curr ).
     IF itab-curr < 0.
       CONDENSE ls_final-curr.
       CONCATENATE '-' ls_final-curr INTO ls_final-curr.
     ENDIF.

     ls_final-credit           = abs( itab-credit ).
     IF itab-credit < 0.
       CONDENSE ls_final-credit.
       CONCATENATE '-' ls_final-credit INTO ls_final-credit.
     ENDIF.

     ls_final-debit           = abs( itab-debit ).
     IF itab-debit < 0.
       CONDENSE ls_final-debit.
       CONCATENATE '-' ls_final-debit INTO ls_final-debit.
     ENDIF.

     ls_final-netbal           = abs( itab-netbal ).
     IF itab-netbal < 0.
       CONDENSE ls_final-netbal.
       CONCATENATE '-' ls_final-netbal INTO ls_final-netbal.
     ENDIF.

     ls_final-netb30           = abs( itab-netb30 ).
     IF itab-netb30 < 0.
       CONDENSE ls_final-netb30.
       CONCATENATE '-' ls_final-netb30 INTO ls_final-netb30.
     ENDIF.

     ls_final-netb60           = abs( itab-netb60 ).
     IF itab-netb60 < 0.
       CONDENSE ls_final-netb60.
       CONCATENATE '-' ls_final-netb60 INTO ls_final-netb60.
     ENDIF.

     ls_final-netb90           = abs( itab-netb90 ).
     IF itab-netb90 < 0.
       CONDENSE ls_final-netb90.
       CONCATENATE '-' ls_final-netb90 INTO ls_final-netb90.
     ENDIF.

     ls_final-netb120           = abs( itab-netb120 ).
     IF itab-netb120 < 0.
       CONDENSE ls_final-netb120.
       CONCATENATE '-' ls_final-netb120 INTO ls_final-netb120.
     ENDIF.

     ls_final-netb180           = abs( itab-netb180 ).
     IF itab-netb180 < 0.
       CONDENSE ls_final-netb180.
       CONCATENATE '-' ls_final-netb180 INTO ls_final-netb180.
     ENDIF.

     ls_final-netb360           = abs( itab-netb360 ).
     IF itab-netb360 < 0.
       CONDENSE ls_final-netb360.
       CONCATENATE '-' ls_final-netb360 INTO ls_final-netb360.
     ENDIF.

     ls_final-not_due           = abs( itab-not_due ).
     IF itab-not_due < 0.
       CONDENSE ls_final-not_due.
       CONCATENATE '-' ls_final-not_due INTO ls_final-not_due.
     ENDIF.

     ls_final-netb_n60           = abs( itab-netb_n60 ).
     IF itab-netb_n60 < 0.
       CONDENSE ls_final-netb_n60.
       CONCATENATE '-' ls_final-netb_n60 INTO ls_final-netb_n60.
     ENDIF.

     ls_final-netb_n90           = abs( itab-netb_n90 ).
     IF itab-netb_n90 < 0.
       CONDENSE ls_final-netb_n90.
       CONCATENATE '-' ls_final-netb_n90 INTO ls_final-netb_n90.
     ENDIF.

     ls_final-netb_n120           = abs( itab-netb_n120 ).
     IF itab-netb_n120 < 0.
       CONDENSE ls_final-netb_n120.
       CONCATENATE '-' ls_final-netb_n120 INTO ls_final-netb_n120.
     ENDIF.

     ls_final-netb_n180           = abs( itab-netb_n180 ).
     IF itab-netb_n180 < 0.
       CONDENSE ls_final-netb_n180.
       CONCATENATE '-' ls_final-netb_n180 INTO ls_final-netb_n180.
     ENDIF.

     ls_final-netb_n360           = abs( itab-netb_n360 ).
     IF itab-netb_n360 < 0.
       CONDENSE ls_final-netb_n360.
       CONCATENATE '-' ls_final-netb_n360 INTO ls_final-netb_n360.
     ENDIF.

     ls_final-pdc           = abs( itab-pdc ).
     IF itab-pdc < 0.
       CONDENSE ls_final-pdc.
       CONCATENATE '-' ls_final-pdc INTO ls_final-pdc.
     ENDIF.

     ls_final-day           = abs( itab-day ).
     IF itab-day < 0.
       CONDENSE ls_final-day.
       CONCATENATE '-' ls_final-day INTO ls_final-day.
     ENDIF.
     APPEND ls_final TO lt_final.
     CLEAR:
       ls_final,itab.

   ENDLOOP.
   CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
     TABLES
       i_tab_sap_data       = lt_final
     CHANGING
       i_tab_converted_data = it_csv
     EXCEPTIONS
       conversion_failed    = 1
       OTHERS               = 2.
   IF sy-subrc <> 0.
* Implement suitable error handling here
   ENDIF.

   PERFORM cvs_header USING hd_csv.

   IF r1 = 'X'.
*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
     lv_file = 'ZMSME_AGE.TXT'.

     CONCATENATE p_folder '/' lv_file
       INTO lv_fullfile.

     WRITE: / 'ZMSME_AGE for Document date Download started on', sy-datum, 'at', sy-uzeit.
   ELSE.
     lv_file = 'ZMSME_AGE.TXT'.

     CONCATENATE p_folder '/' lv_file
       INTO lv_fullfile.

     WRITE: / 'ZMSME_AGE for Due date Download started on', sy-datum, 'at', sy-uzeit.
   ENDIF.

   OPEN DATASET lv_fullfile
     FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
   IF sy-subrc = 0.
     DATA lv_string_1762 TYPE string.
     DATA lv_crlf_1762 TYPE string.
     lv_crlf_1762 = cl_abap_char_utilities=>cr_lf.
     lv_string_1762 = hd_csv.
     LOOP AT it_csv INTO wa_csv.
       CONCATENATE lv_string_1762 lv_crlf_1762 wa_csv INTO lv_string_1762.
       CLEAR: wa_csv.
     ENDLOOP.
*TRANSFER lv_string_0 TO lv_fullfile.
     TRANSFER lv_string_1762 TO lv_fullfile.
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
   CONCATENATE 'Vendor Name'
               'Reconciliation Account'
               'GL Type'
               'Vendor Invoice No.'
               'Doc No.'
               'Doc Type'
               'Posting Date'
               'Doc Date'
               'MSME Due Date'
               'GRN Date'
               'Payment Terms'
               'Amt Document Currency'
               'Currency Key'
               'Invoice Amt.'
               'Payment/Debit Memo Amt'
               'Net Pending'
               rc13
               rc14
               rc15
               rc16
               rc17
               rc18
               'Not Due'
               rc20
               rc21
               rc22
               rc23
               rc24
               'Over Due Days'
               'PDC Amt.'
               'File Run Dt'
               'Invoice No.'
               'MSME Status'
               'No of Days for Due Date'
          INTO pd_csv
          SEPARATED BY l_field_seperator.


 ENDFORM.
