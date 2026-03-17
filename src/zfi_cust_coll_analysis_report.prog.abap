

********************** Developed by Madhuri Vykuntam 18.11.2025 given by nikhil functional


REPORT ZFI_CUST_COLL_ANALYSIS_REPORT.


TABLES: BSID.

*---------------------------------------------------------------------*
* Selection Screen Declarations
*---------------------------------------------------------------------*
PARAMETERS: P_BUKRS TYPE BSID-BUKRS OBLIGATORY. "Company Code
SELECT-OPTIONS: S_KUNNR FOR BSID-KUNNR.               "Customer Number

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: R_MTD RADIOBUTTON GROUP R1 DEFAULT 'X' USER-COMMAND RAD,
              R_YTD RADIOBUTTON GROUP R1.
*  PARAMETERS: P_BUDAT TYPE BSID-BUDAT OBLIGATORY DEFAULT SY-DATUM.
  PARAMETERS: P_BUDAT TYPE DATS OBLIGATORY DEFAULT SY-DATUM.

SELECTION-SCREEN END OF BLOCK B1.

*---------------------------------------------------------------------*
* Data Structure for FI Receivables Report
*---------------------------------------------------------------------*

TYPES: BEGIN OF TY_FI_RECEIVABLE,
         SR_NO              TYPE I,                "Serial Number
         BRANCH_NAME        TYPE TVKBT-BEZEI,      "Name of the Branch
         KUNNR              TYPE BSID-KUNNR,       "Customer Code
         CUSTOMER_NAME      TYPE KNA1-NAME1,       "Customer Name
         WAERS              TYPE T001-WAERS,       "Currency
         TOTAL_RECEIVABLES  TYPE BSID-DMBTR,       "Total Receivables
         NOT_DUE            TYPE BSID-DMBTR,       "Not Due
         DUE_AMOUNT         TYPE BSID-DMBTR,       "Due Amount
         COLLECTED_AMOUNT   TYPE BSID-DMBTR,       "Collected Amount
         BALANCE_DUE_AMOUNT TYPE BSID-DMBTR,       "Balance Due Amount

         NOT_DUE_PERC       TYPE P DECIMALS 2,     "Not Due %
         COLLECTED_PERC     TYPE P DECIMALS 2,     "Collected Amount %
         BALANCE_DUE_PERC   TYPE P DECIMALS 2,     "Balance Due Amount %

         DUE_0_30           TYPE BSID-DMBTR,       "Due from 0–30 days
         DUE_31_60          TYPE BSID-DMBTR,       "Due from 31–60 days
         DUE_61_90          TYPE BSID-DMBTR,       "Due from 61–90 days
         DUE_91_120         TYPE BSID-DMBTR,       "Due from 91–120 days
         DUE_121_150        TYPE BSID-DMBTR,       "Due from 121–150 days
         DUE_151_180        TYPE BSID-DMBTR,       "Due from 151–180 days
         DUE_181_365        TYPE BSID-DMBTR,       "Due from 181–365 days
         DUE_366_730        TYPE BSID-DMBTR,       "Due from 366–730 days
         DUE_731_1095       TYPE BSID-DMBTR,       "Due from 731–1095 days
         DUE_ABOVE_3YRS     TYPE BSID-DMBTR,       "Above 3 Years
       END OF TY_FI_RECEIVABLE.

*---------------------------------------------------------------------*
* Internal Table & Work Area
*---------------------------------------------------------------------*
DATA: GT_FI_RECEIVABLE TYPE TABLE OF TY_FI_RECEIVABLE,
      GS_FI_RECEIVABLE TYPE TY_FI_RECEIVABLE.

DATA: GT_FI_BSID TYPE TABLE OF TY_FI_RECEIVABLE,
      GS_FI_BSID TYPE TY_FI_RECEIVABLE.
DATA: GT_FI_BSAD TYPE TABLE OF TY_FI_RECEIVABLE,
      GS_FI_BSAD TYPE TY_FI_RECEIVABLE.
DATA: R_BUDAT      TYPE RANGE OF BUDAT,
      LV_DATE_FROM TYPE SY-DATUM,
      LV_DATE_TO   TYPE SY-DATUM.

DATA: LO_ALV       TYPE REF TO CL_SALV_TABLE,
      LO_DISPLAY   TYPE REF TO CL_SALV_DISPLAY_SETTINGS,
      LO_COLUMNS   TYPE REF TO CL_SALV_COLUMNS_TABLE,
      LO_COLUMN    TYPE REF TO CL_SALV_COLUMN_TABLE,
      LO_FUNCTIONS TYPE REF TO CL_SALV_FUNCTIONS_LIST.

START-OF-SELECTION.

  IF R_MTD  = 'X'.
    " Example: MTD (Month-To-Date)
    LV_DATE_TO = P_BUDAT.        " Today's date
    LV_DATE_FROM = P_BUDAT.
    LV_DATE_FROM+6(2) = '01'.     " Set day = 01 (first of month)

*    CLEAR R_BUDAT.
*    APPEND VALUE #( SIGN   = 'I'
*                    OPTION = 'BT'
*                    LOW    = LV_DATE_FROM
*                    HIGH   = LV_DATE_TO ) TO R_BUDAT.
  ELSEIF  R_YTD = 'X'.
    DATA: YEAR TYPE GJAHR.
    CALL FUNCTION 'GET_CURRENT_YEAR'
      EXPORTING
        BUKRS = '1000'
        DATE  = P_BUDAT
      IMPORTING
*       CURRM =
        CURRY = YEAR
*       PREVM =
*       PREVY =
      .
    LV_DATE_TO = P_BUDAT.        " Today's date
    LV_DATE_FROM = |{ YEAR }0401|.
    LV_DATE_FROM+6(2) = '01'.

*CLEAR R_BUDAT.
*    APPEND VALUE #( SIGN   = 'I'
*                    OPTION = 'BT'
*                    LOW    = LV_DATE_FROM
*                    HIGH   = LV_DATE_TO ) TO R_BUDAT.
  ENDIF.


  CLEAR R_BUDAT.
  APPEND VALUE #( SIGN   = 'I'
                  OPTION = 'BT'
                  LOW    = LV_DATE_FROM
                  HIGH   = LV_DATE_TO ) TO R_BUDAT.

*---------------------------------------------------------------------*
* Fetch Branch Name, Customer Name, and Currency for BSID Records
*---------------------------------------------------------------------*
  SELECT KUNNR FROM BSID INTO TABLE @DATA(IT_CUST_BSID) WHERE KUNNR IN @S_KUNNR AND BUKRS = @P_BUKRS.
  SORT IT_CUST_BSID BY KUNNR.
  DELETE ADJACENT DUPLICATES FROM IT_CUST_BSID COMPARING KUNNR.
  DATA(IT_CUST) = IT_CUST_BSID.
  SELECT
      A~BUKRS,
      A~KUNNR,
      B~VKBUR,
      C~BEZEI         AS BRANCH_NAME,     "Branch Description
      D~NAME1         AS CUSTOMER_NAME,   "Customer Name
      E~WAERS         AS CURRENCY         "Company Code Currency
    FROM BSID AS A
    INNER JOIN KNVV AS B
            ON B~KUNNR = A~KUNNR
           AND B~VKORG = A~BUKRS
    INNER JOIN TVKBT AS C
            ON C~VKBUR = B~VKBUR
           AND C~SPRAS = @SY-LANGU
    INNER JOIN KNA1 AS D
            ON D~KUNNR = A~KUNNR
    INNER JOIN T001 AS E
            ON E~BUKRS = A~BUKRS
    INTO TABLE @DATA(LT_BSID_INFO) WHERE A~KUNNR IN @S_KUNNR.

*    SELECT kunnr, budat, dmbtr, shkzg from bsid INTO TABLE @DATA(it_bsid_s)
*       WHERE kunnr in @s_kunnr and budat in @r_budat and shkzg = 'S'.

  SELECT
KUNNR,
SUM(
    CASE
        WHEN SHKZG = 'H' THEN - DMBTR
        ELSE DMBTR
    END
) AS TOTAL_AMOUNT
FROM BSID
WHERE BUKRS = @P_BUKRS
AND KUNNR IN @S_KUNNR
AND BUDAT IN @R_BUDAT
AND BLART IN ('DG','DR','RV')
GROUP BY KUNNR
INTO TABLE @DATA(LT_RECE_BSID).

  SELECT
      KUNNR,
      SUM(
          CASE
              WHEN SHKZG = 'S' THEN - DMBTR
              ELSE DMBTR
          END
      ) AS TOTAL_AMOUNT
    FROM BSID
    WHERE BUKRS = @P_BUKRS
      AND KUNNR IN @S_KUNNR
      AND BUDAT IN @R_BUDAT
      AND BLART <> 'DG'
      AND BLART <> 'DR'
      AND BLART <> 'RV'
    GROUP BY KUNNR
    INTO TABLE @DATA(LT_COLL_BSID).


  SELECT
      A~KUNNR,

      SUM(
          CASE
              WHEN B~NETDT >  @P_BUDAT
              THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
              ELSE 0
          END
      ) AS AMT_NETDT_GT,

      SUM(
          CASE
              WHEN B~NETDT <= @P_BUDAT
              THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
              ELSE 0
          END
      ) AS AMT_NETDT_LE

  FROM BSID AS A
  INNER JOIN BSEG AS B
    ON  A~BUKRS = B~BUKRS
    AND A~GJAHR = B~GJAHR
    AND A~BELNR = B~BELNR
    AND A~BUZEI = B~BUZEI

  WHERE A~BUKRS = @P_BUKRS
    AND A~KUNNR IN @S_KUNNR
    AND A~BUDAT IN @R_BUDAT
    AND A~BLART IN ('DG','DR','RV')

  GROUP BY A~KUNNR
  INTO TABLE @DATA(LT_BISD_SUM).


  SELECT
        A~KUNNR,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 0 AND 30
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_0_30,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 31 AND 60
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_31_60,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 61 AND 90
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_61_90,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 91 AND 120
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_91_120,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 121 AND 150
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_121_150,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 151 AND 180
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_151_180,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 181 AND 365
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_181_365,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 366 AND 730
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_366_730,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 731 AND 1095
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_731_1095,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) > 1095
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_ABOVE_3YRS

    FROM BSID_VIEW AS A
    LEFT JOIN BSEG AS B
      ON A~BUKRS = B~BUKRS
     AND A~GJAHR = B~GJAHR
     AND A~BELNR = B~BELNR
     AND A~BUZEI = B~BUZEI

*  WHERE a~budat IN @r_budat
    WHERE A~BUDAT < @P_BUDAT
      AND A~BUKRS = @P_BUKRS
      AND A~KUNNR IN @S_KUNNR
      AND A~BLART IN ('DG','DR','RV')
    GROUP BY A~KUNNR
    INTO TABLE @DATA(LT_AGING_BSID).

****************** now for BSAD table same logic

  LOOP AT IT_CUST_BSID INTO DATA(WA_CUST_BSID).

    READ TABLE LT_BSID_INFO INTO DATA(WA_BSID_INFO) WITH KEY KUNNR = WA_CUST_BSID-KUNNR.
    IF SY-SUBRC = 0.
      GS_FI_BSID-BRANCH_NAME     = WA_BSID_INFO-BRANCH_NAME.   "TYPE TVKBT-BEZEI,      "Name of the Branch
      GS_FI_BSID-KUNNR            = WA_BSID_INFO-KUNNR  .
      GS_FI_BSID-CUSTOMER_NAME      = WA_BSID_INFO-CUSTOMER_NAME.
      GS_FI_BSID-WAERS               = WA_BSID_INFO-CURRENCY.
    ENDIF.

    READ TABLE LT_RECE_BSID INTO DATA(WA_RECE_BSID) WITH KEY KUNNR = WA_CUST_BSID-KUNNR.
    IF SY-SUBRC = 0.
      GS_FI_BSID-TOTAL_RECEIVABLES      = WA_RECE_BSID-TOTAL_AMOUNT.
*      GS_FI_bsid-COLLECTED_AMOUNT = WA_CUST_SUM-TOTAL_DMBTR_H.
    ENDIF.

    READ TABLE LT_COLL_BSID INTO DATA(WA_COLL_BSID) WITH KEY KUNNR = WA_CUST_BSID-KUNNR.
    IF SY-SUBRC = 0.

      GS_FI_BSID-COLLECTED_AMOUNT = WA_COLL_BSID-TOTAL_AMOUNT.
    ENDIF.


    READ TABLE LT_BISD_SUM INTO DATA(WA_BISD_SUM) WITH KEY KUNNR = WA_CUST_BSID-KUNNR.
    IF SY-SUBRC = 0.
      GS_FI_BSID-NOT_DUE = WA_BISD_SUM-AMT_NETDT_GT.
      GS_FI_BSID-DUE_AMOUNT = WA_BISD_SUM-AMT_NETDT_LE.
    ENDIF.

    GS_FI_BSID-BALANCE_DUE_AMOUNT = GS_FI_BSID-DUE_AMOUNT -  GS_FI_BSID-COLLECTED_AMOUNT .

    READ TABLE LT_AGING_BSID INTO DATA(WA_AGING_BSID) WITH KEY KUNNR = WA_CUST_BSID-KUNNR.
    IF SY-SUBRC = 0.
      MOVE-CORRESPONDING WA_AGING_BSID TO GS_FI_BSID.
    ENDIF.
    APPEND GS_FI_BSID TO GT_FI_BSID.
    CLEAR: WA_CUST_BSID,  GS_FI_BSID, WA_BISD_SUM, WA_BISD_SUM, WA_RECE_BSID.
  ENDLOOP.


  SELECT KUNNR FROM BSAD INTO TABLE @DATA(IT_CUST_BSAD) WHERE KUNNR IN @S_KUNNR AND BUKRS = @P_BUKRS..
  SORT IT_CUST_BSAD BY KUNNR.
  DELETE ADJACENT DUPLICATES FROM IT_CUST_BSAD COMPARING KUNNR.

*REFRESH : it_cust.

  APPEND LINES OF IT_CUST_BSAD TO IT_CUST.
  SELECT
      A~BUKRS,
      A~KUNNR,
      B~VKBUR,
      C~BEZEI         AS BRANCH_NAME,     "Branch Description
      D~NAME1         AS CUSTOMER_NAME,   "Customer Name
      E~WAERS         AS CURRENCY         "Company Code Currency
    FROM BSAD AS A
    INNER JOIN KNVV AS B
            ON B~KUNNR = A~KUNNR
           AND B~VKORG = A~BUKRS
    INNER JOIN TVKBT AS C
            ON C~VKBUR = B~VKBUR
           AND C~SPRAS = @SY-LANGU
    INNER JOIN KNA1 AS D
            ON D~KUNNR = A~KUNNR
    INNER JOIN T001 AS E
            ON E~BUKRS = A~BUKRS
    INTO TABLE @DATA(LT_BSAD_INFO) WHERE A~KUNNR IN @S_KUNNR.



  SELECT
 KUNNR,
SUM(
     CASE
         WHEN SHKZG = 'H' THEN - DMBTR
         ELSE DMBTR
     END
 ) AS TOTAL_AMOUNT
FROM BSAD
WHERE BUKRS = @P_BUKRS
 AND KUNNR IN @S_KUNNR
 AND BUDAT IN @R_BUDAT
 AND BLART IN ('DG','DR','RV')
GROUP BY KUNNR
INTO TABLE @DATA(LT_RECE_BSAD).

  SELECT
      KUNNR,
      SUM(
          CASE
              WHEN SHKZG = 'S' THEN - DMBTR
              ELSE DMBTR
          END
      ) AS TOTAL_AMOUNT
    FROM BSAD
    WHERE BUKRS = @P_BUKRS
      AND KUNNR IN @S_KUNNR
      AND BUDAT IN @R_BUDAT
      AND BLART <> 'DG'
      AND BLART <> 'DR'
      AND BLART <> 'RV'
    GROUP BY KUNNR
    INTO TABLE @DATA(LT_COLL_BSAD).

  SELECT
A~KUNNR,

SUM(
  CASE
      WHEN B~NETDT >  @P_BUDAT
      THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
      ELSE 0
  END
) AS AMT_NETDT_GT,

SUM(
  CASE
      WHEN B~NETDT <= @P_BUDAT
      THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
      ELSE 0
  END
) AS AMT_NETDT_LE

FROM BSAD AS A
INNER JOIN BSEG AS B
ON  A~BUKRS = B~BUKRS
AND A~GJAHR = B~GJAHR
AND A~BELNR = B~BELNR
AND A~BUZEI = B~BUZEI

WHERE A~BUKRS = @P_BUKRS
AND A~KUNNR IN @S_KUNNR
AND A~BUDAT IN @R_BUDAT
AND A~BLART IN ('DG','DR','RV')

GROUP BY A~KUNNR
INTO TABLE @DATA(LT_BSAD_SUM).

  SELECT
        A~KUNNR,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 0 AND 30
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_0_30,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 31 AND 60
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_31_60,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 61 AND 90
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_61_90,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 91 AND 120
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_91_120,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 121 AND 150
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_121_150,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 151 AND 180
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_151_180,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 181 AND 365
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_181_365,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 366 AND 730
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_366_730,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) BETWEEN 731 AND 1095
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_731_1095,

        SUM( CASE
                WHEN DAYS_BETWEEN( B~NETDT, @P_BUDAT ) > 1095
                THEN ( CASE WHEN A~SHKZG = 'H' THEN - A~DMBTR ELSE A~DMBTR END )
                ELSE 0
             END ) AS DUE_ABOVE_3YRS

    FROM BSAD_VIEW AS A
    LEFT JOIN BSEG AS B
      ON A~BUKRS = B~BUKRS
     AND A~GJAHR = B~GJAHR
     AND A~BELNR = B~BELNR
     AND A~BUZEI = B~BUZEI

*  WHERE a~budat IN @r_budat
    WHERE A~BUDAT < @P_BUDAT
      AND A~BUKRS = @P_BUKRS
      AND A~KUNNR IN @S_KUNNR
      AND A~BLART IN ('DG','DR','RV')
        AND A~AUGDT > @P_BUDAT
    GROUP BY A~KUNNR
    INTO TABLE @DATA(LT_AGING_BSAD).



  LOOP AT IT_CUST_BSAD INTO DATA(WA_CUST_BSAD).

    READ TABLE LT_BSAD_INFO INTO DATA(WA_BSAD_INFO) WITH KEY KUNNR = WA_CUST_BSAD-KUNNR.
    IF SY-SUBRC = 0.
      GS_FI_BSAD-BRANCH_NAME     = WA_BSAD_INFO-BRANCH_NAME.   "TYPE TVKBT-BEZEI,      "Name of the Branch
      GS_FI_BSAD-KUNNR            = WA_BSAD_INFO-KUNNR  .
      GS_FI_BSAD-CUSTOMER_NAME      = WA_BSAD_INFO-CUSTOMER_NAME.
      GS_FI_BSAD-WAERS               = WA_BSAD_INFO-CURRENCY.
    ENDIF.

    READ TABLE LT_RECE_BSAD INTO DATA(WA_RECE_BSAD) WITH KEY KUNNR = WA_CUST_BSAD-KUNNR.
    IF SY-SUBRC = 0.
      GS_FI_BSAD-TOTAL_RECEIVABLES      = WA_RECE_BSAD-TOTAL_AMOUNT.
*      GS_FI_bsad-COLLECTED_AMOUNT = WA_CUST_SUM-TOTAL_DMBTR_H.
    ENDIF.

    READ TABLE LT_COLL_BSAD INTO DATA(WA_COLL_BSAD) WITH KEY KUNNR = WA_CUST_BSAD-KUNNR.
    IF SY-SUBRC = 0.

      GS_FI_BSAD-COLLECTED_AMOUNT = WA_COLL_BSAD-TOTAL_AMOUNT.
    ENDIF.


    READ TABLE LT_BSAD_SUM INTO DATA(WA_BSAD_SUM) WITH KEY KUNNR = WA_CUST_BSAD-KUNNR.
    IF SY-SUBRC = 0.
      GS_FI_BSAD-NOT_DUE = WA_BSAD_SUM-AMT_NETDT_GT.
      GS_FI_BSAD-DUE_AMOUNT = WA_BSAD_SUM-AMT_NETDT_LE.
    ENDIF.

    GS_FI_BSAD-BALANCE_DUE_AMOUNT = GS_FI_BSAD-DUE_AMOUNT -  GS_FI_BSAD-COLLECTED_AMOUNT .
*    if GS_FI_bsad-TOTAL_bsadS is not INITIAL.
*    GS_FI_bsad-NOT_DUE_PERC       = ( GS_FI_bsad-NOT_DUE /  GS_FI_bsad-TOTAL_bsadS ) * 100.
*    GS_FI_bsad-COLLECTED_PERC     = ( GS_FI_bsad-COLLECTED_AMOUNT /  GS_FI_bsad-TOTAL_bsadS ) * 100.
*    GS_FI_bsad-BALANCE_DUE_PERC   = ( GS_FI_bsad-BALANCE_DUE_AMOUNT /  GS_FI_bsad-TOTAL_bsadS ) * 100.
*endif.
    READ TABLE LT_AGING_BSAD INTO DATA(WA_AGING_BSAD) WITH KEY KUNNR = WA_CUST_BSAD-KUNNR.
    IF SY-SUBRC = 0.
      MOVE-CORRESPONDING WA_AGING_BSAD TO GS_FI_BSAD.
    ENDIF.
    APPEND GS_FI_BSAD TO GT_FI_BSAD.
*    CLEAR: wa_cust_bsad.
    CLEAR: WA_CUST_BSAD,  GS_FI_BSAD, WA_BSAD_SUM, WA_BSAD_SUM, WA_RECE_BSAD.
  ENDLOOP.

  SORT IT_CUST BY KUNNR.
  DELETE ADJACENT DUPLICATES FROM IT_CUST COMPARING KUNNR.
  DATA : N TYPE I.
  CLEAR: N.
  DELETE IT_CUST WHERE KUNNR IS INITIAL.
  LOOP AT IT_CUST INTO DATA(WA_CUST).


    READ TABLE GT_FI_BSID INTO GS_FI_BSID WITH KEY KUNNR = WA_CUST-KUNNR.
    IF SY-SUBRC = 0.
*MOVE-CORRESPONDING  Gs_FI_bsid to Gs_FI_RECEIVABLE.

      GS_FI_RECEIVABLE-BRANCH_NAME       = GS_FI_BSID-BRANCH_NAME.
      GS_FI_RECEIVABLE-KUNNR        = GS_FI_BSID-KUNNR.
      GS_FI_RECEIVABLE-CUSTOMER_NAME    = GS_FI_BSID-CUSTOMER_NAME.
      GS_FI_RECEIVABLE-WAERS   = GS_FI_BSID-WAERS.
    ENDIF.

    READ TABLE GT_FI_BSAD INTO GS_FI_BSAD WITH KEY KUNNR = WA_CUST-KUNNR.
    IF SY-SUBRC = 0.

      GS_FI_RECEIVABLE-BRANCH_NAME       = GS_FI_BSAD-BRANCH_NAME.
      GS_FI_RECEIVABLE-KUNNR        = GS_FI_BSAD-KUNNR.
      GS_FI_RECEIVABLE-CUSTOMER_NAME    = GS_FI_BSAD-CUSTOMER_NAME.
      GS_FI_RECEIVABLE-WAERS   = GS_FI_BSAD-WAERS.
    ENDIF.

    GS_FI_RECEIVABLE-TOTAL_RECEIVABLES = GS_FI_BSAD-TOTAL_RECEIVABLES + GS_FI_BSID-TOTAL_RECEIVABLES.
    GS_FI_RECEIVABLE-COLLECTED_AMOUNT = GS_FI_BSAD-COLLECTED_AMOUNT + GS_FI_BSID-COLLECTED_AMOUNT.
    GS_FI_RECEIVABLE-NOT_DUE = GS_FI_BSAD-NOT_DUE + GS_FI_BSID-NOT_DUE.
    GS_FI_RECEIVABLE-DUE_AMOUNT = GS_FI_BSAD-DUE_AMOUNT + GS_FI_BSID-DUE_AMOUNT.
    GS_FI_RECEIVABLE-BALANCE_DUE_AMOUNT = GS_FI_BSAD-BALANCE_DUE_AMOUNT + GS_FI_BSID-BALANCE_DUE_AMOUNT.
    IF  GS_FI_RECEIVABLE-TOTAL_RECEIVABLES IS NOT INITIAL.
      GS_FI_RECEIVABLE-NOT_DUE_PERC       = ( ( GS_FI_BSAD-NOT_DUE + GS_FI_BSID-NOT_DUE ) /  GS_FI_RECEIVABLE-TOTAL_RECEIVABLES ) * 100.
      GS_FI_RECEIVABLE-COLLECTED_PERC     = ( ( GS_FI_BSAD-COLLECTED_AMOUNT + GS_FI_BSID-COLLECTED_AMOUNT )  /  GS_FI_RECEIVABLE-TOTAL_RECEIVABLES ) * 100.
      GS_FI_RECEIVABLE-BALANCE_DUE_PERC   = ( ( GS_FI_BSAD-BALANCE_DUE_AMOUNT + GS_FI_BSID-BALANCE_DUE_AMOUNT ) /  GS_FI_RECEIVABLE-TOTAL_RECEIVABLES ) * 100.
    ENDIF.


    GS_FI_RECEIVABLE-DUE_0_30   = GS_FI_BSAD-DUE_0_30 + GS_FI_BSID-DUE_0_30.
    GS_FI_RECEIVABLE-DUE_31_60  = GS_FI_BSAD-DUE_31_60 + GS_FI_BSID-DUE_31_60.
    GS_FI_RECEIVABLE-DUE_61_90  = GS_FI_BSAD-DUE_61_90 + GS_FI_BSID-DUE_61_90.
    GS_FI_RECEIVABLE-DUE_91_120  = GS_FI_BSAD-DUE_91_120 + GS_FI_BSID-DUE_91_120.
    GS_FI_RECEIVABLE-DUE_121_150   = GS_FI_BSAD-DUE_121_150  + GS_FI_BSID-DUE_121_150 .
    GS_FI_RECEIVABLE-DUE_151_180  = GS_FI_BSAD-DUE_151_180 + GS_FI_BSID-DUE_151_180.
    GS_FI_RECEIVABLE-DUE_181_365  = GS_FI_BSAD-DUE_181_365 + GS_FI_BSID-DUE_181_365.
    GS_FI_RECEIVABLE-DUE_366_730  = GS_FI_BSAD-DUE_366_730 + GS_FI_BSID-DUE_366_730.
    GS_FI_RECEIVABLE-DUE_731_1095  = GS_FI_BSAD-DUE_731_1095 + GS_FI_BSID-DUE_731_1095.
    GS_FI_RECEIVABLE-DUE_ABOVE_3YRS  = GS_FI_BSAD-DUE_ABOVE_3YRS + GS_FI_BSID-DUE_ABOVE_3YRS.

    IF GS_FI_RECEIVABLE-KUNNR IS INITIAL OR ( GS_FI_RECEIVABLE-TOTAL_RECEIVABLES  IS INITIAL AND
             GS_FI_RECEIVABLE-NOT_DUE    IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_AMOUNT        IS INITIAL AND
             GS_FI_RECEIVABLE-COLLECTED_AMOUNT   IS INITIAL AND
             GS_FI_RECEIVABLE-BALANCE_DUE_AMOUNT IS INITIAL AND

             GS_FI_RECEIVABLE-NOT_DUE_PERC       IS INITIAL AND
             GS_FI_RECEIVABLE-COLLECTED_PERC    IS INITIAL AND
             GS_FI_RECEIVABLE-BALANCE_DUE_PERC  IS INITIAL AND

             GS_FI_RECEIVABLE-DUE_0_30           IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_31_60          IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_61_90         IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_91_120         IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_121_150        IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_151_180       IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_181_365        IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_366_730        IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_731_1095       IS INITIAL AND
             GS_FI_RECEIVABLE-DUE_ABOVE_3YRS    IS INITIAL ) .
             ELSE.
      N = N + 1.
      GS_FI_RECEIVABLE-SR_NO = N .
      APPEND GS_FI_RECEIVABLE TO GT_FI_RECEIVABLE.
    ENDIF.
    CLEAR: WA_CUST, GS_FI_BSAD, GS_FI_BSID, GS_FI_RECEIVABLE.
  ENDLOOP.
*---------------------------------------------------------------------*
* OOPs ALV Output for FI Receivables Report
*---------------------------------------------------------------------*





  TRY.
      "Create ALV object via Factory Method
      CL_SALV_TABLE=>FACTORY(
        IMPORTING
          R_SALV_TABLE = LO_ALV
        CHANGING
          T_TABLE      = GT_FI_RECEIVABLE
      ).

      "------------------------------------------------------------------*
      " Display Settings
      "------------------------------------------------------------------*
      LO_DISPLAY = LO_ALV->GET_DISPLAY_SETTINGS( ).
      LO_DISPLAY->SET_STRIPED_PATTERN( ABAP_TRUE ).   "Zebra lines
      LO_DISPLAY->SET_LIST_HEADER( 'FI Customer Receivables Report' ).

      "------------------------------------------------------------------*
      " Activate Standard ALV Functions (Sort, Filter, Export, Print, etc.)
      "------------------------------------------------------------------*
      LO_FUNCTIONS = LO_ALV->GET_FUNCTIONS( ).
      LO_FUNCTIONS->SET_ALL( ABAP_TRUE ).

      "------------------------------------------------------------------*
      " Column Settings
      "------------------------------------------------------------------*
      LO_COLUMNS = LO_ALV->GET_COLUMNS( ).

      "Auto optimize column width
      LO_COLUMNS->SET_OPTIMIZE( ABAP_TRUE ).

      "Set custom column headings
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'SR_NO' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Sr. No.' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Sr. No.' ).
      LO_COLUMN->SET_LONG_TEXT( 'Serial Number' ).

      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'BRANCH_NAME' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Branch' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Branch Name' ).
      LO_COLUMN->SET_LONG_TEXT( 'Name of the Branch' ).

      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'CUSTOMER_NAME' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Customer' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Customer Name' ).
      LO_COLUMN->SET_LONG_TEXT( 'Name of the Customer' ).

      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'WAERS' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Curr.' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Currency' ).
      LO_COLUMN->SET_LONG_TEXT( 'Document Currency' ).

      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'TOTAL_RECEIVABLES' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Total' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Total Receivables' ).
      LO_COLUMN->SET_LONG_TEXT( 'Total Receivables' ).

      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_AMOUNT' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Due' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Due Amount' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due Amount' ).

      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'COLLECTED_AMOUNT' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Collected' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Collected Amt' ).
      LO_COLUMN->SET_LONG_TEXT( 'Collected Amount' ).

      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'BALANCE_DUE_AMOUNT' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Balance' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Balance Due' ).
      LO_COLUMN->SET_LONG_TEXT( 'Balance Due Amount' ).

      "------------------------------------------------------------------*
      " Add Remaining Columns
      "------------------------------------------------------------------*

      "NOT_DUE
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'NOT_DUE' ).
      LO_COLUMN->SET_SHORT_TEXT( 'Not Due' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Not Due Amt' ).
      LO_COLUMN->SET_LONG_TEXT( 'Not Due Amount' ).

      "NOT_DUE_PERC
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'NOT_DUE_PERC' ).
      LO_COLUMN->SET_SHORT_TEXT( '% ND' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Not Due %' ).
      LO_COLUMN->SET_LONG_TEXT( 'Not Due Percentage' ).

      "COLLECTED_PERC
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'COLLECTED_PERC' ).
      LO_COLUMN->SET_SHORT_TEXT( '% Col.' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Collected %' ).
      LO_COLUMN->SET_LONG_TEXT( 'Collected Percentage' ).

      "BALANCE_DUE_PERC
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'BALANCE_DUE_PERC' ).
      LO_COLUMN->SET_SHORT_TEXT( '% Bal.' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Balance Due %' ).
      LO_COLUMN->SET_LONG_TEXT( 'Balance Due Percentage' ).


      "===================== AGING BUCKET FIELDS ======================*

      "0–30 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_0_30' ).
      LO_COLUMN->SET_SHORT_TEXT( '0–30' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '0–30 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 0–30 Days' ).

      "31–60 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_31_60' ).
      LO_COLUMN->SET_SHORT_TEXT( '31–60' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '31–60 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 31–60 Days' ).

      "61–90 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_61_90' ).
      LO_COLUMN->SET_SHORT_TEXT( '61–90' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '61–90 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 61–90 Days' ).

      "91–120 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_91_120' ).
      LO_COLUMN->SET_SHORT_TEXT( '91–120' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '91–120 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 91–120 Days' ).

      "121–150 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_121_150' ).
      LO_COLUMN->SET_SHORT_TEXT( '121–150' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '121–150 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 121–150 Days' ).

      "151–180 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_151_180' ).
      LO_COLUMN->SET_SHORT_TEXT( '151–180' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '151–180 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 151–180 Days' ).

      "181–365 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_181_365' ).
      LO_COLUMN->SET_SHORT_TEXT( '181–365' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '181–365 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 181–365 Days' ).

      "366–730 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_366_730' ).
      LO_COLUMN->SET_SHORT_TEXT( '366–730' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '366–730 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 366–730 Days' ).

      "731–1095 days
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_731_1095' ).
      LO_COLUMN->SET_SHORT_TEXT( '731–1095' ).
      LO_COLUMN->SET_MEDIUM_TEXT( '731–1095 Days' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due from 731–1095 Days' ).

      "Above 3 years
      LO_COLUMN ?= LO_COLUMNS->GET_COLUMN( 'DUE_ABOVE_3YRS' ).
      LO_COLUMN->SET_SHORT_TEXT( '>3 Yrs' ).
      LO_COLUMN->SET_MEDIUM_TEXT( 'Above 3 Years' ).
      LO_COLUMN->SET_LONG_TEXT( 'Due Above 3 Years' ).


      "------------------------------------------------------------------*
      " Display ALV
      "------------------------------------------------------------------*
      LO_ALV->DISPLAY( ).

    CATCH CX_SALV_MSG INTO DATA(LX_MSG).
      MESSAGE LX_MSG->GET_TEXT( ) TYPE 'E'.
  ENDTRY.
