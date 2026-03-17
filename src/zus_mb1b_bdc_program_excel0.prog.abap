*&---------------------------------------------------------------------*
*&  Include           ZMB1B_BDC_PROGRAM_EXCEL
*&---------------------------------------------------------------------*


TYPE-POOLS ole2.

DATA : application TYPE ole2_object,
       workbook    TYPE ole2_object,
       sheet       TYPE ole2_object,
       cells       TYPE ole2_object,
       cell1       TYPE ole2_object,
       cell2       TYPE ole2_object,
       range       TYPE ole2_object,
       font        TYPE ole2_object,
       column      TYPE ole2_object,
       shading     TYPE ole2_object,
       border      TYPE ole2_object.

CONSTANTS row_max TYPE i VALUE 256.

DATA : index      TYPE i,
       ld_colindx TYPE i,       "Column Index
       ld_rowindx TYPE i.       "Row Index

TYPES : BEGIN OF t_data,
          field1  TYPE string,
          field2  TYPE string,
          field3  TYPE string,
          field4  TYPE string,
          field5  TYPE string,
          field6  TYPE string,
          field7  TYPE string,
          field8  TYPE string,
          field9  TYPE string,
        END OF t_data.

DATA : it_col_no     TYPE STANDARD TABLE OF t_data,
       wa_col_no     LIKE LINE OF it_col_no,
       it_header     TYPE STANDARD TABLE OF t_data,
       wa_header     LIKE LINE OF it_header,
       it_sub_header TYPE STANDARD TABLE OF t_data,
       wa_sub_header LIKE LINE OF it_sub_header,
       it_data1       TYPE STANDARD TABLE OF t_data,
       wa_data1       LIKE LINE OF it_data1.

*----Field symbol to hold values-----*
FIELD-SYMBOLS : <fs>.

DATA : BEGIN OF itab1 OCCURS 0, first_name(10), END OF itab1,
       BEGIN OF itab2 OCCURS 0, last_name(10), END OF itab2,
         BEGIN OF itab3 OCCURS 0, formula(50), END OF itab3.

TYPES : BEGIN OF ty_log,
          bldat(30),
          budat(30),
          BWARTWA(30),
          werks(30),
          lgort(30),
          UMWRK(30),
          UMLGO(30),
          matnr(40),
          ERFMG(30),
       enD OF ty_log.

DATA : cnt       TYPE i,
       it_log    TYPE TABLE OF ty_log,
       wa_log    TYPE ty_log,
       it_fcat   TYPE slis_t_fieldcat_alv,
       wa_fcat   TYPE slis_fieldcat_alv,
       wa_layout TYPE slis_layout_alv.
