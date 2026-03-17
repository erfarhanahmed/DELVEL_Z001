*----------------------------------------------------------------------*
***INCLUDE LZBANK_CC_LIMIT1F02.
*----------------------------------------------------------------------*

FORM update.
  zbank_cc_limit1-createdby = sy-uname.
  zbank_cc_limit1-changedby = sy-uname.
  zbank_cc_limit1-createddate = sy-datum..
  zbank_cc_limit1-changeddate = sy-datum..
ENDFORM.
