"Name: \TY:J_1IG_CL_INTRASTATE_STO\ME:FILL_KOMFKGN\SE:END\EI
ENHANCEMENT 0 ZSD_CHANGE_LGORT.

   IF SY-TCODE = 'J1IGINTRASTO' and SY-UCOMM = '&GST'.
    ls_komfkgn-lgort  = im_output-lgort_1.
    ex_komfkgn-LGORT  = im_output-lgort_1.
   ENDIF.
ENDENHANCEMENT.
