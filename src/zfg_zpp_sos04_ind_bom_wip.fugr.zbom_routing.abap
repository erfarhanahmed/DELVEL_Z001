FUNCTION ZBOM_ROUTING.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(PM_MTNRV) TYPE  MARA-MATNR
*"     REFERENCE(PM_WERKS) TYPE  MARC-WERKS
*"     REFERENCE(PM_CAPID) TYPE  TC04-CAPID
*"     REFERENCE(PM_DATUV) TYPE  CHAR10
*"     REFERENCE(PM_EHNDL) TYPE  CHAR1
*"----------------------------------------------------------------------

DATA: BEGIN OF ALV_STB OCCURS 100.
        INCLUDE STRUCTURE STPOX_ALV.
DATA : LV_CNT(3).
DATA: INFO(3) TYPE C,
      END OF ALV_STB.


SUBMIT ZCS12
      WITH PM_MTNRV = PM_MTNRV
      WITH PM_WERKS = PM_WERKS
      WITH PM_CAPID = PM_CAPID
      WITH PM_DATUV = PM_DATUV
      WITH PM_EHNDL = '1'
      AND RETURN.
      IMPORT ALV_STB[] FROM MEMORY ID 'ALV_STB'.





ENDFUNCTION.
