*&---------------------------------------------------------------------*
*& Include          ZASSET_SCHEDULE_REPORT_SEL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZASSET_SCHEDULE_REPORT_SEL
*&---------------------------------------------------------------------*
TABLES : ANLA,ANLC,ANEP.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS : P_BUKRS  TYPE ANLA-BUKRS DEFAULT '1000' OBLIGATORY MODIF ID BU,
             P_ANLKL TYPE ANLA-ANLKL,
             P_ZUJHR TYPE ANLA-zujhr DEFAULT SY-DATUM+(4).
SELECTION-SCREEN END OF BLOCK B1.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TEXT-002.
PARAMETERS P_DOWN AS CHECKBOX.
PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'.   "'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK B2.

INITIALIZATION.
***Initialisation -> This event is used when ever you initialize any variable or a field in your program.
***
***this indicates the start of program .It is similar to Load of program .
***
***this is the first event executed as the program is executed .
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
