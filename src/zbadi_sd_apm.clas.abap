class ZBADI_SD_APM definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_BADI_SD_APM .
protected section.
private section.
ENDCLASS.



CLASS ZBADI_SD_APM IMPLEMENTATION.


  method IF_BADI_SD_APM~GET_SDOC_REJECTION_REASON.
      CV_SDOC_REJECTION_REASON = '04'.
  endmethod.
ENDCLASS.
