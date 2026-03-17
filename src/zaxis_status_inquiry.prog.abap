*&---------------------------------------------------------------------*
*& Report ZAXIS_STATUS_INQUIRY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAXIS_STATUS_INQUIRY.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

TYPES: BEGIN OF TY_CUR_TXN_ENQ,
         STATUSDESCRIPTION TYPE STRING,
         BATCHNO           TYPE STRING,
         UTRNO             TYPE STRING,
         TRANSACTIONSTATUS TYPE STRING,
         PROCESSINGDATE    TYPE STRING,
         CORPCODE          TYPE STRING,
         CRN               TYPE STRING,
         RESPONSECODE      TYPE STRING,
       END OF TY_CUR_TXN_ENQ.

TYPES TY_T_CUR_TXN_ENQ TYPE STANDARD TABLE OF TY_CUR_TXN_ENQ WITH EMPTY KEY.


TYPES: BEGIN OF TY_DATA_NODE,
         CUR_TXN_ENQ  TYPE TY_T_CUR_TXN_ENQ,
         ERRORMESSAGE TYPE STRING,
         CHECKSUM     TYPE STRING,
       END OF TY_DATA_NODE.

TYPES: BEGIN OF TY_DATA_WRAPPER,
         DATA    TYPE TY_DATA_NODE,
         MESSAGE TYPE STRING,
         STATUS  TYPE STRING,
       END OF TY_DATA_WRAPPER.

TYPES: BEGIN OF TY_LOG,
         DATA TYPE TY_DATA_WRAPPER,
       END OF TY_LOG.

TYPES: BEGIN OF TY_RESPONSE,
         UTRNO             TYPE STRING,
         TRANSACTIONSTATUS TYPE STRING,
         LOG               TYPE TY_LOG,
         ERRORMESSAGE      TYPE STRING,
         MESSAGE           TYPE STRING,
         STATUS            TYPE STRING,
       END OF TY_RESPONSE.
DATA: GS_RESPONSE TYPE TY_RESPONSE.





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

TYPES: BEGIN OF TY_SUBHEADER,
         REQUESTUUID           TYPE STRING,
         SERVICEREQUESTID      TYPE STRING,
         SERVICEREQUESTVERSION TYPE STRING,
         CHANNELID             TYPE STRING,
       END OF  TY_SUBHEADER.


TYPES: BEGIN OF TY_BODYENCRYPTED ,
         CHANNELID TYPE STRING,
         CORPCODE  TYPE STRING,
         CRN       TYPE ZTT_AXIX_CRN,
         CHECKSUM  TYPE STRING,
       END OF TY_BODYENCRYPTED.

*TYPES: BEGIN OF TY_TRAPAYREQ,
*         SUBHEADER     TYPE TY_SUBHEADER,
*         BODYENCRYPTED TYPE TY_BODYENCRYPTED,
*       END OF TY_TRAPAYREQ.


TYPES: BEGIN OF TY_RES,
         UTRNO             TYPE STRING,
         TRANSACTIONSTATUS TYPE STRING,
         ERRORMESSAGE      TYPE STRING,
         MESSAGE           TYPE STRING,
         STATUS            TYPE STRING,
         ERRORCODE         TYPE STRING,
         LOG               TYPE STRING,
         STATUSDESCRIPTION TYPE STRING,
       END OF TY_RES.
TYPES : BEGIN OF TY_FINAL,
          DATA TYPE TY_BODYENCRYPTED,
        END OF TY_FINAL.

DATA:
*       WA_REQUEST TYPE  TY_TRAPAYREQ,
  WA_BODY    TYPE TY_BODYENCRYPTED,
  WA_SUB     TYPE TY_SUBHEADER,
  LO_CLIENT  TYPE REF TO IF_HTTP_CLIENT,
  RESULT     TYPE STRING,
  WA_RES_API TYPE TY_RES,
  RESULT_TAB TYPE TABLE OF STRING,
  WA_FINAL   TYPE TY_FINAL.

DATA:IT_MSG TYPE TABLE OF BDCMSGCOLL,
     WA_MSG TYPE BDCMSGCOLL.

DATA: IT_CRN TYPE TABLE OF ZAXIX_CRN,
      WA_CRN TYPE STRING.

DATA: LV_MODE TYPE CTU_PARAMS-DISMODE.

*      WA_CRN TYPE ZAXIX_CRN.

DATA: IT_TRANS TYPE TABLE OF ZAXIS_TRANS_RES,
      WA_TRANS TYPE ZAXIS_TRANS_RES.

DATA : LV_JSON TYPE /UI2/CL_JSON=>JSON,
       LV_CRN  TYPE STRING.
DATA: LV_UCOM TYPE SYST-UCOMM .

DATA : LV_DAT TYPE SYST-DATUM .
*DATA : LV_URL TYPE STRING VALUE 'http://172.16.1.38:443/api/statusEnquiry1' .  """"""""""""" dev
*DATA : LV_URL TYPE STRING VALUE 'http://172.16.1.38:443/api/StatusEnquiryPrd' .  """"""""""""" PRD
DATA : LV_URL TYPE STRING VALUE 'http://49.248.197.67:8080/api/v1/dev/statusEnquiry' .  """"""""""""" PRD



DATA:   BDCDATA LIKE BDCDATA    OCCURS 0 WITH HEADER LINE.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN: PUSHBUTTON /1(20) BTN1 USER-COMMAND PB1.
SELECTION-SCREEN: END OF BLOCK B1.

INITIALIZATION.
  BTN1 = 'Run Now'.

START-OF-SELECTION .

AT SELECTION-SCREEN.
  CASE SY-UCOMM.
    WHEN 'PB1'.
      REFRESH: IT_TRANS .
      LV_UCOM = 'PB1' .
      PERFORM MAIN_LOGIC.
      LEAVE SCREEN .
    WHEN 'ONLI'.
      REFRESH: IT_TRANS .
      LV_UCOM = 'ONLI'.
  ENDCASE.

START-OF-SELECTION .

  PERFORM MAIN_LOGIC.
*&---------------------------------------------------------------------*
*& Form main_logic
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAIN_LOGIC .


*  SELECT SINGLE END_POINT FROM  ZAXIS_ENDPT_UTR INTO @DATA(LV_ZAXIS_ENDPT) .
*  IF LV_ZAXIS_ENDPT IS NOT INITIAL  .
*    CONCATENATE LV_URL LV_ZAXIS_ENDPT INTO LV_URL SEPARATED BY '/'.
*  ELSE .
*    MESSAGE 'Please Maintain The End-Point First' TYPE 'E'.
*  ENDIF.

  """""""""""""""""""""" data declaration for token """"""""""""""""

  DATA: LO_HTTP_TOKEN    TYPE REF TO IF_HTTP_CLIENT,
        L_RESPONSE_TOKEN TYPE STRING.
  DATA: L_STATUS_CODE   TYPE I.
  DATA: BEGIN OF TS_TOKEN OCCURS 0,
          TOKEN TYPE STRING,
*          ACCESS_TOKEN TYPE STRING,
*          EXPIRES_IN   TYPE STRING,
        END OF TS_TOKEN .
  DATA URL TYPE STRING.

  DATA: LV_TOKEN     TYPE STRING,
        LV_CLIENT_ID TYPE STRING.
  DATA: LO_ROOT TYPE REF TO CX_ROOT.
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  URL = 'http://49.248.197.67:8080/auth/token'.

  TRY.
      CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_URL
        EXPORTING
          URL                = URL
*         SSL_ID             = 'UATSKY' "'DFAULT'
        IMPORTING
          CLIENT             = LO_HTTP_TOKEN
        EXCEPTIONS
          ARGUMENT_NOT_FOUND = 1
          PLUGIN_NOT_ACTIVE  = 2
          INTERNAL_ERROR     = 3
          OTHERS             = 4.
      IF SY-SUBRC <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*Close the client in case of Error
        LO_HTTP_TOKEN->CLOSE( ).
      ENDIF.

      IF LO_HTTP_TOKEN IS BOUND.
        LO_HTTP_TOKEN->REQUEST->SET_METHOD( IF_HTTP_ENTITY=>CO_REQUEST_METHOD_POST ).
      ENDIF.

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'X-Client-Id'
        VALUE = 'Q3/jSm+sjfM3MfygSboT69QucC0Bqvt5hJb9OIB/z7Q=' ).   """"""""" NC

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(   """""""" NC
        NAME  = 'X-Client-Secret'
        VALUE = 'Q3/jSm+sjfM3MfygSboT68Cy0hyOFti/TfYEJ/NwvHQ=' ).

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'X-Username'
        VALUE = 'm+75t+W8AAJmVsbUgo97KxsLwz4ruMTuIl7837ZFT2w=' ).

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'X-Password'
        VALUE = 'p7ZybLacnZ9tXqhakWA1fnrWa7mliAFrSpPcM4JtTxU=' ).

      LO_HTTP_TOKEN->REQUEST->SET_HEADER_FIELD(
        NAME  = 'Content-Type'
        VALUE = 'application/json' ).

      CALL METHOD LO_HTTP_TOKEN->SEND
        EXCEPTIONS
          HTTP_COMMUNICATION_FAILURE = 1
          HTTP_INVALID_STATE         = 2
          HTTP_PROCESSING_FAILED     = 3
          HTTP_INVALID_TIMEOUT       = 4
          OTHERS                     = 5.
      IF SY-SUBRC <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL METHOD LO_HTTP_TOKEN->RECEIVE
        EXCEPTIONS
          HTTP_COMMUNICATION_FAILURE = 1
          HTTP_INVALID_STATE         = 2
          HTTP_PROCESSING_FAILED     = 3
          OTHERS                     = 4.
      IF SY-SUBRC <> 0.
*          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      CALL METHOD LO_HTTP_TOKEN->RESPONSE->GET_STATUS
        IMPORTING
          CODE = L_STATUS_CODE.

      CALL METHOD LO_HTTP_TOKEN->RESPONSE->GET_CDATA
        RECEIVING
          DATA = L_RESPONSE_TOKEN.


      /UI2/CL_JSON=>DESERIALIZE(
        EXPORTING
          JSON = L_RESPONSE_TOKEN
        CHANGING
          DATA = TS_TOKEN  "Token will be stored in the instance structure, for retrieval in other methods.
      ).

      LV_TOKEN = TS_TOKEN-TOKEN.

      LO_HTTP_TOKEN->CLOSE( ).
    CATCH CX_ROOT INTO LO_ROOT.
  ENDTRY.


  IF  LV_TOKEN  IS NOT INITIAL .
    LV_DAT = SY-DATUM  - 7.

    IF LV_UCOM = 'PB1' OR LV_UCOM = 'ONLI' .
      SELECT * FROM ZAXIS_RES_API
        INTO TABLE @DATA(IT_API)
         WHERE  STATUS = 'S'
           AND CRE_DATE  >= @LV_DAT .


      IF IT_API IS NOT INITIAL .
        SELECT * FROM  ZAXIS_TRANS_RES
           FOR ALL ENTRIES IN @IT_API
             WHERE REQUESTUUID = @IT_API-CUSTUNIQREF
                AND TRANSACTIONSTATUS NE 'REJECTED'
                AND UTRNO eq @space
                AND  CRE_DATE >= @LV_DAT
                   INTO TABLE @DATA(IT_TRANS_RES) .
      ENDIF.

      SORT IT_API BY BELNR  DESCENDING .


      LOOP AT IT_API INTO DATA(WA_API).

        READ TABLE IT_TRANS_RES INTO DATA(WA_TRANS_RES) WITH KEY REQUESTUUID = WA_API-CUSTUNIQREF .

        IF SY-SUBRC NE 0 OR WA_TRANS_RES-UTRNO = SPACE .

          WA_SUB-REQUESTUUID               =  WA_API-REQUESTUUID .
*          WA_SUB-SERVICEREQUESTID          = 'OpenAPI' .
*          WA_SUB-SERVICEREQUESTVERSION     = '1.0'     .
*          WA_SUB-CHANNELID                 = 'TXB'     .

*     WA_CRN-CRN =  WA_API-CRN  . " 'IMPSTESTTRANSACTION' .
          LV_CRN = WA_API-CUSTUNIQREF . "'IMPSTESTTRANSACTION' .

*          WA_BODY-CHANNELID    = 'SULAWINES'     .
*          WA_BODY-CORPCODE     = 'DEMOCORP87'.
*          WA_BODY-CHECKSUM     = '304e7414297d79610c162e55b061e4bc'.

          APPEND LV_CRN TO WA_BODY-CRN .

*          WA_REQUEST-SUBHEADER     = WA_SUB  .
*          WA_REQUEST-BODYENCRYPTED = WA_BODY .

          WA_FINAL-DATA = WA_BODY .

          LV_JSON = /UI2/CL_JSON=>SERIALIZE( DATA        = WA_FINAL
                                             COMPRESS    = ABAP_FALSE
                                             PRETTY_NAME = /UI2/CL_JSON=>PRETTY_MODE-CAMEL_CASE ).
*
          REPLACE ALL OCCURRENCES OF  '"data"' IN LV_JSON WITH '"Data"'.
          REPLACE ALL OCCURRENCES OF  '"getstatusrequest"' IN LV_JSON WITH '"GetStatusRequest"'.
          REPLACE ALL OCCURRENCES OF  '"subheader"' IN LV_JSON WITH '"SubHeader"'.
          REPLACE ALL OCCURRENCES OF  '"requestuuid"' IN LV_JSON WITH '"requestUUID"'.
          REPLACE ALL OCCURRENCES OF  '"requestuuid"' IN LV_JSON WITH '"requestUUID"'.
          REPLACE ALL OCCURRENCES OF  '"servicerequestid"' IN LV_JSON WITH '"serviceRequestId"'.
          REPLACE ALL OCCURRENCES OF  '"servicerequestversion"' IN LV_JSON WITH '"serviceRequestVersion"'.
          REPLACE ALL OCCURRENCES OF  '"channelid"' IN LV_JSON WITH '"channelId"'.
          REPLACE ALL OCCURRENCES OF  '"bodyencrypted"' IN LV_JSON WITH '"GetStatusRequestBodyEncrypted"'.
          REPLACE ALL OCCURRENCES OF  '"channelid"' IN LV_JSON WITH '"channelId"'.
          REPLACE ALL OCCURRENCES OF  '"corpcode"' IN LV_JSON WITH '"corpCode"'.
          REPLACE ALL OCCURRENCES OF  '"checksum"' IN LV_JSON WITH '"checksum"'.

          CONDENSE LV_URL NO-GAPS.
          TRY.
              CALL METHOD CL_HTTP_CLIENT=>CREATE_BY_URL
                EXPORTING
                  URL                = LV_URL
                IMPORTING
                  CLIENT             = LO_CLIENT
                EXCEPTIONS
                  ARGUMENT_NOT_FOUND = 1
                  PLUGIN_NOT_ACTIVE  = 2
                  INTERNAL_ERROR     = 3
                  OTHERS             = 4.
              IF SY-SUBRC <> 0.
                LO_CLIENT->CLOSE( ).
              ENDIF.
              IF LO_CLIENT IS BOUND.
                LO_CLIENT->REQUEST->SET_METHOD( IF_HTTP_REQUEST=>CO_REQUEST_METHOD_POST ).
                LO_CLIENT->REQUEST->SET_HEADER_FIELD( NAME = 'Content-Type' VALUE = 'application/json' ).

                LO_CLIENT->REQUEST->SET_HEADER_FIELD(        """"""""" NC
                  NAME  = 'Authorization'
                  VALUE = |Bearer { LV_TOKEN }| ).

                LO_CLIENT->REQUEST->APPEND_CDATA(
                  EXPORTING
                    DATA = LV_JSON              " Character data
                ).

                LO_CLIENT->SEND( TIMEOUT = IF_HTTP_CLIENT=>CO_TIMEOUT_DEFAULT ).

                CALL METHOD LO_CLIENT->RECEIVE
                  EXCEPTIONS
                    HTTP_COMMUNICATION_FAILURE = 1
                    HTTP_INVALID_STATE         = 2
                    HTTP_PROCESSING_FAILED     = 3.

                IF SY-SUBRC = 0.
                  RESULT = LO_CLIENT->RESPONSE->GET_CDATA( ).

                  /UI2/CL_JSON=>DESERIALIZE(
                    EXPORTING
                      JSON = RESULT              " JSON string
                    CHANGING
                      DATA = GS_RESPONSE                 " Data to serialize
*                     DATA = WA_RES_API                 " Data to serialize
                  ).
                ELSE.
                  RESULT = LO_CLIENT->RESPONSE->GET_CDATA( ).
                  REFRESH RESULT_TAB .
                  SPLIT RESULT AT CL_ABAP_CHAR_UTILITIES=>CR_LF INTO TABLE RESULT_TAB .
                ENDIF.
              ENDIF.
              LO_CLIENT->CLOSE( ).
            CATCH CX_ROOT INTO DATA(E_TEXT).
              WRITE E_TEXT->GET_TEXT( ).
          ENDTRY.

          WA_TRANS-MANDT                 =  SY-MANDT                     .
*          WA_TRANS-REQUESTUUID           =  GS_RESPONSE-          .
          WA_TRANS-CRN                   =  WA_API-CUSTUNIQREF           .
          WA_TRANS-CHECKSUM              =  WA_API-CHECKSUM              .
          WA_TRANS-UTRNO                 =  GS_RESPONSE-UTRNO             .
          WA_TRANS-TRANSACTIONSTATUS     =  GS_RESPONSE-TRANSACTIONSTATUS .
*          WA_TRANS-ERRORMESSAGE          =  GS_RESPONSE-ERRORMESSAGE      .


          READ TABLE  GS_RESPONSE-LOG-DATA-DATA-CUR_TXN_ENQ   INTO DATA(WA_ENQ) INDEX 1 .

          WA_TRANS-ERRORMESSAGE              =  WA_ENQ-STATUSDESCRIPTION      .
          WA_TRANS-REQUESTUUID               =  WA_ENQ-BATCHNO      .
          WA_TRANS-STATUS                    =  GS_RESPONSE-STATUS            .

          CONDENSE GS_RESPONSE-STATUS NO-GAPS.

          IF WA_TRANS-STATUS NE 'S'.
            CASE WA_TRANS-STATUS.
              WHEN '400'.
                WA_TRANS-MESSAGE = 'Bad Request' .
              WHEN '401'.
                WA_TRANS-MESSAGE = 'Unauthorised Request' .
              WHEN '403'.
                WA_TRANS-MESSAGE = 'Forbidden/Authentication Failed' .
              WHEN '404'.
                WA_TRANS-MESSAGE = 'Not Found' .
              WHEN '429'.
                WA_TRANS-MESSAGE = 'Too Many Request' .
              WHEN '500'.
                WA_TRANS-MESSAGE = 'Internal Server Error' .
              WHEN '502'.
                WA_TRANS-MESSAGE = 'Bad Gateway' .
              WHEN '503'.
                WA_TRANS-MESSAGE = 'Service Unavailable ' .
              WHEN '504'.
                WA_TRANS-MESSAGE = 'Gateway Timeout' .
            ENDCASE.
          ELSEIF WA_TRANS-STATUS NE 'S'.
            WA_TRANS-MESSAGE = GS_RESPONSE-MESSAGE     .
          ENDIF.

          WA_TRANS-CRE_DATE              =  SY-DATUM                     .
          WA_TRANS-CRE_TIME              =  SY-TIMLO                     .
          WA_TRANS-USER_ID               =  SY-UNAME                     .

          IF WA_TRANS-UTRNO IS NOT INITIAL .
            PERFORM BDC_RUN  USING WA_API-BELNR WA_API-BUKRS WA_API-GJAHR  WA_TRANS-UTRNO     .
          ENDIF.

          MODIFY ZAXIS_TRANS_RES FROM WA_TRANS .
          COMMIT WORK .
          UPDATE ZAXIS_RES_API SET UTRNO                   = WA_TRANS-UTRNO
                                   TRANSACTIONSTATUS       = WA_TRANS-TRANSACTIONSTATUS
            WHERE CUSTUNIQREF = WA_TRANS-CRN .
          COMMIT WORK .
          APPEND WA_TRANS TO IT_TRANS .
        ENDIF .
        CLEAR : GS_RESPONSE , RESULT ,WA_API,WA_TRANS_RES , WA_TRANS,WA_SUB,LV_CRN,WA_BODY,LV_JSON,WA_RES_API,WA_FINAL.  "WA_REQUEST,
        REFRESH :WA_BODY-CRN , GS_RESPONSE-LOG-DATA-DATA-CUR_TXN_ENQ .

      ENDLOOP .
    ENDIF.

    PERFORM DESPLAY_ALV .

  ELSE.
    MESSAGE : 'Token was not generated' TYPE 'E' .

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DESPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DESPLAY_ALV .
  CLEAR : LV_UCOM .

  DATA: LO_ALV     TYPE REF TO CL_SALV_TABLE,
        LO_COLUMNS TYPE REF TO CL_SALV_COLUMNS_TABLE,
        LO_COLUMN  TYPE REF TO CL_SALV_COLUMN.

* Create ALV
  CL_SALV_TABLE=>FACTORY(
    IMPORTING
      R_SALV_TABLE = LO_ALV
    CHANGING
      T_TABLE      = IT_TRANS ).

  LO_COLUMNS = LO_ALV->GET_COLUMNS( ).

** Set custom column headings
  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'REQUESTUUID' ).
  LO_COLUMN->SET_SHORT_TEXT( 'Batch ID' ).
  LO_COLUMN->SET_MEDIUM_TEXT( 'Batch ID' ).
  LO_COLUMN->SET_LONG_TEXT( 'Batch ID' ).
  LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'CRN' ).
  LO_COLUMN->SET_SHORT_TEXT( 'CRN No' ).
  LO_COLUMN->SET_MEDIUM_TEXT( 'CRN Number' ).
  LO_COLUMN->SET_LONG_TEXT( 'CRN Number' ).
  LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

*  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'CHECKSUM' ).
*  LO_COLUMN->SET_SHORT_TEXT( 'Checksum' ).
*  LO_COLUMN->SET_MEDIUM_TEXT( 'Checksum' ).
*  LO_COLUMN->SET_LONG_TEXT( 'Checksum' ).
*  LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'UTRNO' ).
  LO_COLUMN->SET_SHORT_TEXT( 'UTR No' ).
  LO_COLUMN->SET_MEDIUM_TEXT( 'UTR Number' ).
  LO_COLUMN->SET_LONG_TEXT( 'UTR Number' ).
  LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'TRANSACTIONSTATUS' ).
  LO_COLUMN->SET_SHORT_TEXT( 'Trans Stat' ).
  LO_COLUMN->SET_MEDIUM_TEXT( 'Transaction Status' ).
  LO_COLUMN->SET_LONG_TEXT( 'Transaction Status' ).
  LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width


*  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'MESSAGE' ).
*  LO_COLUMN->SET_SHORT_TEXT( 'Message' ).
*  LO_COLUMN->SET_MEDIUM_TEXT( 'Message' ).
*  LO_COLUMN->SET_LONG_TEXT( 'Message' ).
*  LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

  TRY.
      LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'MANDT' ).
      LO_COLUMN->SET_VISIBLE( ABAP_FALSE ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.




  TRY.
      LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'MESSAGE' ).
      LO_COLUMN->SET_VISIBLE( ABAP_FALSE ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.

  TRY.
      LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'CHECKSUM' ).
      LO_COLUMN->SET_VISIBLE( ABAP_FALSE ).
    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.

  TRY.
*      LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'REQUESTUUID' ).
*      LO_COLUMN->SET_VISIBLE( ABAP_FALSE ).
*    CATCH CX_SALV_NOT_FOUND.
  ENDTRY.



  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'ERRORMESSAGE' ).
  LO_COLUMN->SET_SHORT_TEXT( 'Response' ).
  LO_COLUMN->SET_MEDIUM_TEXT( 'Response Message' ).
  LO_COLUMN->SET_LONG_TEXT( 'Response Message' ).
  LO_COLUMN->SET_OUTPUT_LENGTH( 50 ).  " Restrict width

  LO_COLUMN = LO_COLUMNS->GET_COLUMN( 'STATUS' ).
  LO_COLUMN->SET_SHORT_TEXT( 'Status' ).
  LO_COLUMN->SET_MEDIUM_TEXT( 'Status' ).
  LO_COLUMN->SET_LONG_TEXT( 'Status' ).
  LO_COLUMN->SET_OUTPUT_LENGTH( 20 ).  " Restrict width

  DATA(LO_FUNCTIONS) = LO_ALV->GET_FUNCTIONS( ).

  LO_FUNCTIONS->SET_ALL( ABAP_TRUE ).

  LO_ALV->DISPLAY( ).

ENDFORM.
*&---------------------------------------------------------------------*
*& FORM BDC_RUN
*&---------------------------------------------------------------------*
*& TEXT
*&---------------------------------------------------------------------*
*& -->  P1        TEXT
*& <--  P2        TEXT
*&---------------------------------------------------------------------*
FORM BDC_RUN  USING    P_BELNR P_BUKRS  P_GJAHR P_UTR .

  LV_MODE  =  'N'.
  PERFORM BDC_DYNPRO      USING 'SAPMF05L' '0100'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'RF05L-GJAHR'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=WEITE'.
  PERFORM BDC_FIELD       USING 'RF05L-BELNR'
                                 P_BELNR . "'1500000023'.   """"""""""""""""
  PERFORM BDC_FIELD       USING 'RF05L-BUKRS'   """""""""""""""""
                                 P_BUKRS .       "'1000'.
  PERFORM BDC_FIELD       USING 'RF05L-GJAHR'   """""""""""""
                                 P_GJAHR . "'2025'.
  PERFORM BDC_DYNPRO      USING 'SAPMF05L' '0700'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'RF05L-ANZDT(01)'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=PK'.
  PERFORM BDC_DYNPRO      USING 'SAPMF05L' '0300'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'BSEG-ZUONR'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=ZK'.
*  PERFORM BDC_FIELD       USING 'BSEG-ZUONR'
*                                 P_UTR .     "'20250429'.    """""""""""
  PERFORM BDC_FIELD       USING 'DKACB-FMORE'
                                'X'.
  PERFORM BDC_DYNPRO      USING 'SAPLKACB' '0002'.
*  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                'DKACB-ACROBJKONT'.   """"""""" CMT BY NC
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=ENTE'.
  PERFORM BDC_DYNPRO      USING 'SAPMF05L' '1300'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'BSEG-KIDNO'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=ENTR'.
  PERFORM BDC_FIELD       USING 'BSEG-KIDNO'
                                 P_UTR . " '121313132123123123132132'.   """"""""""""""""
  PERFORM BDC_DYNPRO      USING 'SAPMF05L' '0300'.
  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
                                'BSEG-ZUONR'.
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=AE'.
*  PERFORM BDC_FIELD       USING 'BSEG-ZUONR'
*                                 P_UTR ."'20250429'.       """""""""""""""""""
  PERFORM BDC_FIELD       USING 'DKACB-FMORE'
                                'X'.
  PERFORM BDC_DYNPRO      USING 'SAPLKACB' '0002'.
*  PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                'DKACB-ACROBJKONT'.   """"""" CMT BY NC
  PERFORM BDC_FIELD       USING 'BDC_OKCODE'
                                '=ENTE'.

  CALL TRANSACTION 'FB02' USING BDCDATA
       MODE   LV_MODE          " 'A' = display, 'N' = no display, 'E' = errors only
         MESSAGES INTO IT_MSG.


  REFRESH : IT_MSG , BDCDATA.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form BDC_DYNPRO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR BDCDATA.
  BDCDATA-PROGRAM  = PROGRAM.
  BDCDATA-DYNPRO   = DYNPRO.
  BDCDATA-DYNBEGIN = 'X'.
  APPEND BDCDATA.
ENDFORM.
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL IS NOT INITIAL .
    CLEAR BDCDATA.
    BDCDATA-FNAM = FNAM.
    BDCDATA-FVAL = FVAL.
    APPEND BDCDATA.
  ENDIF.
ENDFORM.
