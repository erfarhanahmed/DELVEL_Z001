*&---------------------------------------------------------------------*
*& Report ZASSET_SCHEDULE_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZASSET_SCHEDULE_REPORT.


INCLUDE ZASSET_SCHEDULE_REPORT_SEL.
INCLUDE ZASSET_SCHEDULE_REPORT_SUB.
START-OF-SELECTION.

  DATA(obj_rep) = NEW lcl_cust_coll_cls( ).
  obj_rep->get_data( ).
