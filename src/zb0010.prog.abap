*&---------------------------------------------------------------------*
*& Report  ZB0010
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zb0010 NO STANDARD PAGE HEADING
               LINE-SIZE 77.

TABLES: tbtco.

DATA: BEGIN OF joblist OCCURS 100.
        INCLUDE STRUCTURE tbtco.
DATA: END OF joblist.

DATA: suspended_jobs_no like SY-DBCNT.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.

SELECT-OPTIONS: s_jobnam      FOR     tbtco-jobname
                              OBLIGATORY
                              NO INTERVALS.

SELECTION-SCREEN END OF BLOCK  b1.



SELECT * FROM tbtco
  INTO TABLE joblist
  WHERE jobname IN s_jobnam
  AND   status EQ 'S'.

IF sy-subrc NE 0.
  MESSAGE i499(sy) WITH 'No Released Jobs found for given Selection'.
  EXIT.
ENDIF.

FORMAT COLOR COL_HEADING.
uline.
write:/ sy-vline , (32) 'Job Name' ,                  "#EC
        sy-vline , (10) 'Status' ,                    "#EC
        sy-vline , (10) 'LstChgDate' ,                "#EC
        sy-vline , (12) 'LastChgName' ,               "#EC
        sy-vline .
uline.

FORMAT COLOR COL_BACKGROUND.
LOOP AT joblist.

  tbtco            = joblist.
  tbtco-status     = 'Z'.
  tbtco-lastchdate = sy-datum.
  tbtco-lastchtime = sy-uzeit.
  tbtco-lastchname = sy-uname.

  UPDATE tbtco.

  write:/ sy-vline , tbtco-jobname ,
          sy-vline , (10) 'Suspended' ,
          sy-vline , tbtco-lastchdate ,
          sy-vline , tbtco-lastchname ,
          sy-vline .

  IF sy-subrc = 0.
    suspended_jobs_no = suspended_jobs_no + 1.
  ENDIF.
ENDLOOP.

uline.

write:/ 'Total Number of Jobs Suspended : ' , suspended_jobs_no.
