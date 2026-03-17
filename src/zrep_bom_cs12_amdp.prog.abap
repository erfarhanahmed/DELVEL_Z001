
REPORT ZREP_BOM_CS12_AMDP
       NO STANDARD PAGE HEADING LINE-SIZE 255.

*&*--------------------------------------------------------------------*
*&* START OF SELECTION
*&*--------------------------------------------------------------------*
INCLUDE: ZINCL_BOM_CS12_AMDP_DATADECF01,
         ZINCL_BOM_CS12_AMDP_GETDATAF01.



START-OF-SELECTION.

  PERFORM GET_DATA.
  IF P_DOWN = 'X'.
    PERFORM DOWNLOAD.
  ELSE.
    it_final1 = CORRESPONDING #( lt_bom_final  ).

    PERFORM DISPLAY_ALV.
  ENDIF.
