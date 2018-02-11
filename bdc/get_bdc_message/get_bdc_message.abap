DATA:   I_BDC TYPE STANDARD TABLE OF BDCDATA ,
         W_BDC TYPE BDCDATA,
         I_MSG TYPE STANDARD TABLE OF BDCMSGCOLL,
         W_MSG TYPE BDCMSGCOLL.



IF I_BDC IS NOT INITIAL.
*&-----Call Transaction F-32
     CALL TRANSACTION C_TCODE USING I_BDC
                              OPTIONS FROM V_OPTION MESSAGES INTO I_MSG.
   ENDIF.

****************************************************
* BDCMSGCOLL의 내용을 이용하여 메시지를 String으로 세팅해주는 작업
   DATA : LV_MSG TYPE STRING.
   LOOP AT I_MSG INTO W_MSG.
     CLEAR LV_MSG.
     CALL FUNCTION 'FORMAT_MESSAGE'
       EXPORTING
         ID        = W_MSG-MSGID
         LANG      = 'EN'
         NO        = W_MSG-MSGNR
         V1        = W_MSG-MSGV1
         V2        = W_MSG-MSGV2
         V3        = W_MSG-MSGV3
         V4        = W_MSG-MSGV4
       IMPORTING
         MSG       = LV_MSG
       EXCEPTIONS
         NOT_FOUND = 1
         OTHERS    = 2.
     IF SY-SUBRC <> 0.
       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
     ENDIF.
