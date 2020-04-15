*---------------------program to edit group_heads
* Three parameters A|C|D
* hot key F1-codehelp
*--------------------------------------------------
Param _what
  PRIVATE _pai[3]
 _pai[1]=space(2)
 _pai[2]=SPACE(35)
 _pai[3]=SPACE(1)
*----------------------------  File Section
  Sele 1
     Use DATA\GROUP Index DATA\GROUP
  Sele 2
     Use DATA\SGROUP Index DATA\SGROUP
*------------------------------------ User interface
 Sele 1
 
  tma=savescreen(5,5,17,50)
   SCROLL(5,5,17,50,0)
  SET COLO TO w+/G
  @ 6,6 sAY "             Group Heads  "+if(_what="A"," Addition "+space(9),if(_what="C"," Change "+space(11)," Deletion "+space(9)))
  set colo to
  @ 5,5 TO 17,50 DOUBLE
  @ 7,6 say repli(chr(205),44)
  Set colo to
  @ 9 ,8 say " Code       "
  @ 12,8 SAY " Descreption"
  @ 15,8 SAY " Type       "
  set colo to
  SET KEY 27 TO ESC_PROC
     set colo to w+/n+,n/w,,,w+/n+
*----------------------------------- main routine
      BEGIN SEQUENCE
        DO while .t.
         set key 28 to code_h

            @ 9,25 GET _pai[1]  pict "!!"
            READ
               seek _pai[1]
               *-------------- Data validation
                 IF  VAL(_pai[1])<=0
                    ERR_MSG(" INVALID CODE  ")
                    LOOP
                 ELSEIF _WHAT="A" .AND. FOUND()
                    ERR_MSG(" DUPLICATE ENTRY   ")
                    LOOP
                 ELSEIF _WHAT$"CD" .AND. !FOUND()
                     ERR_MSG(" NO SUCH ITEM       ")
                     LOOP
                ENDIF
                 set key 28 to
               IF _WHAT$"CD"
                      _PAI[2]=A_DESC
                      _PAI[3]=A_TYPE
                    @ 12,25 say Left(a_desc,20)
                    @ 15,25 say a_type
               ENDIF
               if _what=="D"
                   SEEK _pai[1]
                      if (chr(err_msg(" confirm (y/n) "))$"Yy")
                             sele 2
                               locate for substr(s_code,1,2)=_pai[1]
                                  if found()
                                     err_msg(" cannot delete ")
                                     sele 1
                                     loop
                                  endif
                               SELE 1
                         DELETE
                         PACK
                      endif
                     loop
              endif

          @  12,25 GET _pai[2] PICT "@S20!"
         READ
           IF (_pai[2]=SPACE(25))
             ERR_MSG(" BLANK ITEM NOT ALLOWED  ")
             KEYB CHR(13)
             LOOP
           ENDIF
          keyb  amenu()
          @ 15,25 get _pai[3] pict "!"
          Read
            if (chr(err_msg(" CONFIRM(Y/N) "))$"yY")
                     if _what=="A"
                       appen blank
                     endif

                       REPL A_CODE WITH _PAI[1],A_DESC WITH _PAI[2],A_TYPE WITH _PAI[3]
                ENDIF

           ENDdo
 END
set key 27 to
set key 28 to

 close all
release _pai
restscreen(5,5,17,50,tma)
 RETU
*------------------------ function amenu
 FUNCTION AMENU
  _SDmn=SAVESCREEN(14,23,16,65)
  Set key 27 to
  Scroll(14,23,16,65,0)
  @ 14,24 to 16,65 double
  DO WHILE .T.
  @ 15,25 PROMPT "ASSET"
  @ 15,35 PROMPT "LIABALITY"
  @ 15,45 PROMPT "INCOME"
  @15,55  PROMPT "EXPENSE"
  MENU TO K
   IF (K=0)
     LOOP
   ENDIF
   exit
   ENDDO
   RESTSCREEN(14,23,16,65,_SDmn)
   Release _Sdmn
   Set key 27 to  Esc_proc
 RETURN IF(K=1,"A",IF(K=2,"L",IF(K=3,"I","E")))

*----------------procedure for COdehelp
