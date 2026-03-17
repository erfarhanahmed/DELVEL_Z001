*&---------------------------------------------------------------------*
*&  Include           ZSD_PENDING_SO_SELSCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
SELECT-OPTIONS   :  s_date FOR wa_vbak-erdat OBLIGATORY ,
                    s_matnr FOR wa_vbap-matnr,
                    s_kunnr FOR wa_vbak-kunnr,
                    s_vbeln FOR wa_vbap-vbeln.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
PARAMETERS open_so  RADIOBUTTON GROUP code DEFAULT 'X' USER-COMMAND codegen.
PARAMETERS all_so  RADIOBUTTON GROUP code.
SELECTION-SCREEN END OF BLOCK b3.

SELECT-OPTIONS:  s_kschl   FOR  wa_konv-kschl NO-DISPLAY .
SELECT-OPTIONS:  s_stat   FOR  wa_jest1-stat NO-DISPLAY .

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN :BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-075.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
  SELECTION-SCREEN COMMENT /1(70) TEXT-077.
  SELECTION-SCREEN COMMENT /1(70) TEXT-078.
  SELECTION-SCREEN COMMENT /1(70) TEXT-079.
SELECTION-SCREEN: END OF BLOCK B4.


DATA wa_kschl LIKE s_kschl.
DATA wa_jest LIKE s_stat.
CLEAR: wa_kschl , wa_jest.




wa_kschl-sign = 'I'.
wa_kschl-option = 'EQ'.
wa_kschl-low = 'ZPRO'.
APPEND wa_kschl TO s_kschl.

wa_kschl-sign = 'I'.
wa_kschl-option = 'EQ'.
wa_kschl-low = 'VPRS'.
APPEND wa_kschl TO s_kschl.

wa_jest-sign = 'I'.
wa_jest-option = 'EQ'.
wa_jest-low = 'E0001'.
APPEND wa_jest TO s_stat.

wa_jest-sign = 'I'.
wa_jest-option = 'EQ'.
wa_jest-low = 'E0002'.
APPEND wa_jest TO s_stat.

wa_jest-sign = 'I'.
wa_jest-option = 'EQ'.
wa_jest-low = 'E0003'.
APPEND wa_jest TO s_stat.
