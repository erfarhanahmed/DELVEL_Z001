*----------------------------------------------------------------------*
***INCLUDE LZASN_AUTHF02.
*----------------------------------------------------------------------*

form update.
ZASN_AUTH-CREATEDBY = sy-uname.
ZASN_AUTH-CHANGEDBY = sy-uname.
ZASN_AUTH-CREATEDDATE = sy-datum..
ZASN_AUTH-CHANGEDDATE = sy-datum..

ENDFORM.
