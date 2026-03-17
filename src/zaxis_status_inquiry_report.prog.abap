*&---------------------------------------------------------------------*
*& Report ZAXIS_STATUS_INQUIRY_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAXIS_STATUS_INQUIRY_REPORT.

DATA: O_ALV   TYPE REF TO CL_SALV_TABLE.

SELECT-OPTIONS S_DATE FOR SYST-DATUM.


SELECT * FROM ZAXIS_TRANS_RES
  INTO TABLE @DATA(IT_RES)
    WHERE CRE_DATE IN @S_DATE.

SORT IT_RES BY REQUESTUUID .


TRY.
    CL_SALV_TABLE=>FACTORY(
      IMPORTING
        R_SALV_TABLE = O_ALV
      CHANGING
        T_TABLE      = IT_RES ).

    " Hide column MATKL (Material Group)
    DATA(LO_COLUMNS) = O_ALV->GET_COLUMNS( ).
    DATA(LO_COLUMN)  = LO_COLUMNS->GET_COLUMN( 'MANDT' ).
    LO_COLUMN->SET_VISIBLE( ABAP_FALSE ).

* Set custom column headings
    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'REQUESTUUID' ).
    LO_COLUMN->SET_SHORT_TEXT( 'Req ID' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'Request ID' ).
    LO_COLUMN->SET_LONG_TEXT( 'Request ID' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'CRN' ).
    LO_COLUMN->SET_SHORT_TEXT( 'CRN No' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'CRN Number' ).
    LO_COLUMN->SET_LONG_TEXT( 'CRN Number' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'CHECKSUM' ).
    LO_COLUMN->SET_SHORT_TEXT( 'Checksum' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'Checksum' ).
    LO_COLUMN->SET_LONG_TEXT( 'Checksum' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'UTRNO' ).
    LO_COLUMN->SET_SHORT_TEXT( 'UTR No' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'UTR Number' ).
    LO_COLUMN->SET_LONG_TEXT( 'UTR Number' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'TRANSACTIONSTATUS' ).
    LO_COLUMN->SET_SHORT_TEXT( 'Trans Stat' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'Transaction Status' ).
    LO_COLUMN->SET_LONG_TEXT( 'Transaction Status' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'ERRORMESSAGE' ).
    LO_COLUMN->SET_SHORT_TEXT( 'Error Msg' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'Error Message' ).
    LO_COLUMN->SET_LONG_TEXT( 'Error Message' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'MESSAGE' ).
    LO_COLUMN->SET_SHORT_TEXT( 'Message' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'Message' ).
    LO_COLUMN->SET_LONG_TEXT( 'Message' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'STATUS' ).
    LO_COLUMN->SET_SHORT_TEXT( 'Status' ).
    LO_COLUMN->SET_MEDIUM_TEXT( 'Status' ).
    LO_COLUMN->SET_LONG_TEXT( 'Status' ).
    LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

    O_ALV->DISPLAY( ).

  CATCH CX_SALV_MSG INTO DATA(LX_MSG).
    MESSAGE LX_MSG->GET_TEXT( ) TYPE 'E'.
ENDTRY.
