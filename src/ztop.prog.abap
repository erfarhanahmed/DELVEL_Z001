*&---------------------------------------------------------------------*
*& Include          ZTOP
*&---------------------------------------------------------------------*
FORM ztop.
TABLES : vbak,vbap.
TYPES :BEGIN OF ty_final,
         cust_ref          TYPE vbkd-bstkd,
         Cust_name         TYPE kna1-name1,
         sales_office      TYPE vbak-vkbur,
         so                TYPE vbak-vbeln,
         so_date           TYPE vbak-audat,
         cdpos             TYPE datum,
         hold_date         TYPE vbap-holdreldate,
         receipt_date      TYPE vbap-receipt_Date,
*         mrp_date          TYPE vbep-ettypchangedate,
         target_date       TYPE vbap-zmrp_date,
         mrp_tag           TYPE char10,
         so_mrp            TYPE i,
         del_date          TYPE vbap-deldate,
         mat               TYPE vbap-matnr,
         posnr             TYPE vbap-posnr,
         desc              TYPE vbap-arktx,
         so_qty            TYPE vbap-kwmeng,
         so_status         TYPE vbep-ettyp,
         rate              TYPE prcd_elements-kbetr,
         currency          TYPE prcd_elements-waers,
         currency_conv     TYPE prcd_elements-kkurs,
         pending_so_amount TYPE vbap-kwmeng,
         ofm               TYPE datum,
         cust_Deldate      TYPE vbap-custdeldate,
         po_date           TYPE vbkd-bstdk,
         ctbg              TYPE vbap-ctbg,
         ofm_date          TYPE vbap-ofm_date,
         po_ofm            TYPE i,
         ofm_po            TYPE i,
         so_rel            TYPE i,
         rel_del           TYPE i,
         code_mrp          TYPE i,
         tarmrp_mrpdate    TYPE i,

       END OF ty_final.

       DATA :lt_final TYPE STANDARD TABLE OF ty_final,
             ls_final TYPE ty_final.
endform.
