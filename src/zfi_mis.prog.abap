*&---------------------------------------------------------------------*
*& Report ZFI_MIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFI_MIS.

*REPORT zmis_delval.

*--------------------*
* Selection Screen
*--------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS:
  r_per  RADIOBUTTON GROUP grp DEFAULT 'X',
  r_qtr  RADIOBUTTON GROUP grp,
  r_half RADIOBUTTON GROUP grp,
  r_year RADIOBUTTON GROUP grp.

*SELECTION-SCREEN COMMENT 5(20) TEXT-101 FOR FIELD r_per .
*SELECTION-SCREEN COMMENT 5(20) TEXT-102 FOR FIELD r_qtr .
*SELECTION-SCREEN COMMENT 5(20) TEXT-103 FOR FIELD r_half.
*SELECTION-SCREEN COMMENT 5(20) TEXT-104 FOR FIELD r_year.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.

  PARAMETERS:
  p_gjahr TYPE gjahr OBLIGATORY,
  p_cyear TYPE gjahr.

SELECTION-SCREEN END OF BLOCK b2.

*TEXT-001 = 'MIS Type Selection'.
*TEXT-002 = 'Fiscal Year Details'.

*--------------------*
* Auto calculate comparison year
*--------------------*
AT SELECTION-SCREEN OUTPUT.
p_cyear = p_gjahr - 1.

*--------------------*
* Start of Selection
*--------------------*
START-OF-SELECTION.

DATA lv_tcode TYPE sy-tcode.

CASE 'X'.
WHEN r_per.
  lv_tcode = 'ZFI_MIS01'.
WHEN r_qtr.
  lv_tcode = 'ZFI_MIS02'.
WHEN r_half.
  lv_tcode = 'ZFI_MIS03'.
WHEN r_year.
  lv_tcode = 'ZFI_MIS04'.
ENDCASE.

IF lv_tcode IS NOT INITIAL.

  SET PARAMETER ID 'GJR' FIELD p_gjahr.
  CALL TRANSACTION lv_tcode AND SKIP FIRST SCREEN.

ENDIF.
