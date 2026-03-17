*&---------------------------------------------------------------------*
*& Report ZBOM_CS12_P
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBOM_CS12_P.
TABLES : MARA.

DATA:
  LV_XML    TYPE STRING.


DATA : FUNCTIONCALL1(1) TYPE C,
       SYSTEM           TYPE RZLLI_APCL,
       TASKNAME(8)      TYPE C,
       INDEX(3)         TYPE C,
       INDEX1           TYPE I,
       SND_JOBS         TYPE I,
       RCV_JOBS         TYPE I,
       EXC_FLAG         TYPE I,
       MESS             TYPE C LENGTH 80.
DATA: IT_CSV TYPE TRUXS_T_TEXT_DATA,
      WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
      HD_CSV TYPE LINE OF TRUXS_T_TEXT_DATA.

DATA: LV_PER_CHUNK TYPE I,
      LV_INDEX     TYPE I VALUE 0,
      LV_REMAINDER TYPE I.


DATA :   I_MARA   TYPE STANDARD TABLE OF MARA.

CONSTANTS: DONE(1) TYPE C VALUE 'X'.

DATA: S_MAT TYPE TABLE OF RSMATNR WITH HEADER LINE.

FIELD-SYMBOLS: <FS_MARA> TYPE MARA.

**SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
**  SELECT-OPTIONS: s_matnr FOR mara-matnr,
**                  s_date FOR mara-ersda.
**SELECTION-SCREEN: END OF BLOCK b1.
**
**SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
**  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
**SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
  SELECT-OPTIONS : S_MATNR  FOR MARA-MATNR  NO INTERVALS.
  PARAMETERS     : PM_WERKS LIKE MARC-WERKS,
                   PM_DATUV LIKE STKO-DATUV DEFAULT SY-DATUM,
                   PM_STLAN LIKE STZU-STLAN,
                   PM_STLAL LIKE STKO-STLAL,
                   PM_CAPID LIKE TC04-CAPID,
                   CTU_MODE LIKE CTU_PARAMS-DISMODE DEFAULT 'N' NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK B1.

**Added By Sarika Thange 06.03.2019
SELECTION-SCREEN BEGIN OF BLOCK B5 WITH FRAME TITLE TEXT-074 .
  PARAMETERS P_DOWN AS CHECKBOX.
  PARAMETERS P_FOLDER LIKE RLGRAP-FILENAME DEFAULT '/Delval/India'."India'."India'."temp'.
SELECTION-SCREEN END OF BLOCK B5.

SELECTION-SCREEN :BEGIN OF BLOCK B3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN: END OF BLOCK B3.


DATA: IT_WPINFO TYPE TABLE OF  WPINFO .

CALL FUNCTION 'TH_WPINFO'
* EXPORTING
*   SRVNAME             = ' '
*   WITH_CPU            = 0
*   WITH_MTX_INFO       = 0
*   MAX_ELEMS           = 0
  TABLES
    WPLIST = IT_WPINFO
* EXCEPTIONS
*   SEND_ERROR          = 1
*   OTHERS = 2
  .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


DELETE IT_WPINFO WHERE WP_TYP <> 'BGD' OR WP_STATUS <> 'Waiting'.
DESCRIBE TABLE IT_WPINFO LINES DATA(LV_AVAILABLEWP).
LV_AVAILABLEWP = LV_AVAILABLEWP / 2.
SELECT * FROM MARA INTO TABLE I_MARA WHERE MATNR IN S_MATNR . "AND ERSDA IN S_DATE.
*SELECT * FROM mara INTO TABLE i_mara UP TO 40 ROWS.
DESCRIBE TABLE I_MARA LINES DATA(LV_LINES).
LV_PER_CHUNK = LV_LINES DIV LV_AVAILABLEWP.
LV_REMAINDER = LV_LINES MOD LV_AVAILABLEWP.
IF LV_PER_CHUNK = 0.
  LV_PER_CHUNK = 1.
ENDIF.

**********************************************************************************
* RFC Server Group created from transaction RZ12
* It will be the config for Parallel processing.
* We can keep it as DEFAULT. In our case it is 'parallel_generators'
**********************************************************************************
SYSTEM = 'parallel_generators'.



LOOP AT I_MARA ASSIGNING <FS_MARA>.
  LV_INDEX =  LV_INDEX + 1.
  S_MAT-SIGN = 'I'.
  S_MAT-OPTION = 'EQ'.
  S_MAT-LOW = <FS_MARA>-MATNR.
  APPEND S_MAT.
  IF ( LV_INDEX MOD LV_PER_CHUNK = 0 AND LV_INDEX < LV_LINES )  OR ( LV_INDEX = LV_LINES ).
    INDEX = INDEX + 1.
    CONCATENATE 'Bom' INDEX INTO TASKNAME. "Generate Unique Task Name

**********************************************************************************
* Below is the SYNTAX for calling our own FM (For which we need Papallel processing)
*
* CALL FUNCTION func STARTING NEW TASK task
*              [DESTINATION {dest|{IN GROUP {group|DEFAULT}}}]
*              parameter_list
*              [{PERFORMING subr}|{CALLING meth} ON END OF TASK].
*
* We can keep the syntax as DESTINATION IN GROUP DEFAULT instead of
*                           DESTINATION IN GROUP system
*
* The above syntaxes will creates Different task name TASK in a     separate work process.
* Each such task executes “process_parallel” in a separate work process.
*
**********************************************************************************
*    CALL FUNCTION 'ZPARALLEL_PROCESSING_FM'
    CALL FUNCTION 'ZPARALLEL_BOM_CS12'
      STARTING NEW TASK TASKNAME
*DESTINATION IN GROUP system
*DESTINATION IN GROUP 390
      DESTINATION 'NONE'
      PERFORMING PROCESS_PARALLEL ON END OF TASK
      EXPORTING
        P_HIDDEN              = TASKNAME
        P_WERKS               = PM_WERKS
        P_DATUV               = PM_DATUV
        P_STLAN               = PM_STLAN
        P_STLAL               = PM_STLAL
        P_CAPID               = PM_CAPID
      TABLES
        MATERIAL              = S_MAT
      EXCEPTIONS
        SYSTEM_FAILURE        = 1 MESSAGE MESS
        COMMUNICATION_FAILURE = 2 MESSAGE MESS
        RESOURCE_FAILURE      = 3.

    CASE SY-SUBRC.
      WHEN 0.
        SND_JOBS = SND_JOBS + 1.
        WAIT UP TO 1 SECONDS.
      WHEN 1 OR 2.
        MESSAGE MESS TYPE 'I'.
      WHEN 3.
        IF SND_JOBS >= 1 AND
        EXC_FLAG = 0.
          EXC_FLAG = 1.
          WAIT UNTIL RCV_JOBS >= SND_JOBS UP TO 10 SECONDS.
        ENDIF.

        IF SY-SUBRC = 0.
          EXC_FLAG = 0.
        ELSE.
          MESSAGE 'Resource failure' TYPE 'I'.
        ENDIF.
      WHEN OTHERS.
        MESSAGE 'Other error' TYPE 'I'.
    ENDCASE.

    CLEAR: S_MAT,S_MAT[].
  ENDIF.

ENDLOOP.

WAIT UNTIL RCV_JOBS >= SND_JOBS .


*&---------------------------------------------------------------------*
*&      Form  process_parallel
*&---------------------------------------------------------------------*
* Each task will execute “process_parallel” in a separate work process.
*----------------------------------------------------------------------
FORM PROCESS_PARALLEL USING TASKNAME.

  RCV_JOBS = RCV_JOBS + 1.

  RECEIVE RESULTS FROM FUNCTION 'ZPARALLEL_BOM_CS12'
  IMPORTING
   LV_JSON        =  LV_XML.
  FUNCTIONCALL1 = DONE.

ENDFORM.
