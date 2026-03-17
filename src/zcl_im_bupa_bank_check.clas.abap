class ZCL_IM_BUPA_BANK_CHECK definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BUPA_BANK_CHECK .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BUPA_BANK_CHECK IMPLEMENTATION.


  METHOD IF_EX_BUPA_BANK_CHECK~CHECK.

    DATA:   EW_RETURN TYPE   BAPIRET2 .


    SELECT SINGLE  * FROM USR21 INTO @DATA(WA_USR21) WHERE BNAME = @SY-UNAME .
    IF SY-SUBRC EQ 0 .
      SELECT SINGLE * FROM ADCP INTO @DATA(WA_ADCP)
           WHERE ADDRNUMBER = @WA_USR21-ADDRNUMBER
             AND PERSNUMBER =  @WA_USR21-PERSNUMBER.

      DATA(LV_FUN) = WA_ADCP-FUNCTION .
      DATA(LV_DEP_ST) = WA_ADCP-DEPARTMENT .

      TRANSLATE LV_FUN TO UPPER CASE.
      TRANSLATE LV_DEP_ST TO UPPER CASE.

*          IF  SY-SUBRC EQ 0 .
      IF   IV_ACTIVITY = 2 .
        IF IS_BANKDETAIL_X IS NOT INITIAL .
          IF    LV_DEP_ST NE 'USA' .
            IF   LV_DEP_ST NE 'SAUDI' .
              IF  LV_FUN NE 'FI' .

                EW_RETURN-TYPE = 'E'.
                EW_RETURN-NUMBER = '001'.
                EW_RETURN-ID = 'ZBANK'.
                APPEND EW_RETURN TO  ET_RETURN .

              ELSE.

                DATA(LV_DEP)  = WA_ADCP-DEPARTMENT .
                TRANSLATE LV_DEP TO UPPER CASE.
                IF LV_DEP CS  'ACCOUNT' OR
                   LV_DEP CS  'FINANCE' OR
                   LV_DEP CS  'CORPORATE SERVICE' .
                ELSE.
                  EW_RETURN-TYPE = 'E'.
                  EW_RETURN-NUMBER = '001'.
                  EW_RETURN-ID = 'ZBANK'.
                  APPEND EW_RETURN TO  ET_RETURN .
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
*          ELSE.
*            SELECT * from but0bk
*              INTO TABLE @DATA(it_but0bk)
*                where PARTNER = @IS_BUT000-PARTNER.
*
**              read TABLE it_but0bk INTO DATA(wa_but0bk) WITH  KEY BKVID =
        ENDIF.
      ELSE.

        IF    LV_DEP_ST NE 'USA' .
          IF   LV_DEP_ST NE 'SAUDI' .
            IF  LV_FUN NE 'FI' .

              EW_RETURN-TYPE = 'E'.
              EW_RETURN-NUMBER = '001'.
              EW_RETURN-ID = 'ZBANK'.
              APPEND EW_RETURN TO  ET_RETURN .

            ELSE.
              CLEAR: LV_DEP .
              LV_DEP   = WA_ADCP-DEPARTMENT .
              TRANSLATE LV_DEP TO UPPER CASE.
              IF LV_DEP CS  'ACCOUNT' OR
                 LV_DEP CS  'FINANCE' OR
                 LV_DEP CS  'CORPORATE SERVICE' .
              ELSE.
                EW_RETURN-TYPE = 'E'.
                EW_RETURN-NUMBER = '001'.
                EW_RETURN-ID = 'ZBANK'.
                APPEND EW_RETURN TO  ET_RETURN .
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
