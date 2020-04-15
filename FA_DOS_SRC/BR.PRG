FUNCTION BROW
 param hmode
  *------------------------------- IF NO PARAMETER EXIT
  if pcou()=0 
    ?"ERROR"+" BROWSE <FILENAME>"
  RETU 
  ENDI
CLEAR
USE \DATA\TEXT
SET SAFE OFF
ZAP
APPEN FROM &HMODE SDF
GO TOP
*------------------------------ FUNCTION TO SHOW DATA ON SCREEN
DBSCR(1)
*--------------------- N IS FOR ROW AND IND KEEPS TRACK OF COLUMN
PRIVATE IND,N,R
N =2
IND=1
SET COLO TO N/W

@ N,1 SAY SUBSTR(TITLE,IND,79)
SET COLO TO N/W
@ 1,1 SAY SPACE(79)
@ 1,40 say "BROWSE UTILITY VER .01"

@ 22,1 SAY SPACE(79)  
@ 22,40 say " PAITOOLS CORPORATION ,ALWAYE  "


    DO WHILE .T.
      R=INKEY(0)
  *----------------- IF LASTKEY IS ESC RETURN TO CALLING PROGRAM    
            IF R=27
              RETURN
            ENDIF
  *-------------------- MAKE NORMAL VIDEO
     SET COLO TO W/N
       @ N,1 SAY SUBSTR(TITLE,IND,79)
 *------------------ NEXT CASE STRUCTURE KEEPS TRACK OF KEYS
       DO CASE
  *------------------------ CASE UP_ARROW
         CASE R=5
          IF N=2 .and. recno()<>1 
              SKIP -1
              scroll(2,1,21,79,-1)  
          ELSEIF N<>2 .AND. !BOF()
              N=N-1
              SKIP -1
          ENDIF
   *------------------------- END OF CASE UP_ARROW
   *****************************************************
   *------------------------- CASE DOWN_ARROW
        CASE R=24
           IF N=21 .AND. !EOF()
             SKIP 1
             SCROLL (2,1,21,79,1)
           ELSEIF N<>21 .AND. !EOF()
           SKIP
           N=N+1
          ENDIF
 *----------------------------------- END OF CASE DOWN ARROW
**********************************************
  *------------------- CASE RIGHT ARROW
    CASE R=4
      IF IND<70
              
       IND =IND+5
       DBSCR(IND)
      ENDIF
    *---------------------- END OF CASE LEFT ARROW
    **************************************************************
    *** --------------------- CASE LEFT ARROW
    CASE R=19
      IF IND<>1
       IND =IND-5
       DBSCR(IND)
      ENDIF
*------------------------ END OF CASE LEFT ARROW
 ********************************************************************
 *-------------------- CASE HOME
   CASE R=1
   GO top
   n=2
   IND=1
   DBSCR(IND)
   *--------------------------------------- end of case home
  ******************************************************************** 
   *---------------------------------- CASE END KEY
   CASE R=6
   GOTO IIF(RECCOUNT()>17 ,RECCOUNT()-17,RECCOUNT()%18)
    n=2
     IND=1
    DBSCR(IND)
    *----------------------------------- END OF CASE END KEY
  **********************************************************************
  *----------------------------------- CASE HOME PGUP
    case r=18
       skip -(min(reccount(),16))
       n=2
       dbscr(ind)
 *---------------------------------------END OF CASE PGUP
 ************************************************************
 *--------------------------------CASE PGDN 
   case r=3
      skip (min(reccount(),16))
      n=2
      dbscr(ind)
*------------------------------------ END OF CASE PGDN      
 ENDCASE
 *--------------------------------- END OF CASE STRUCTURE
     SET COLO TO N/W
       @ N,1 SAY SUBSTR(TITLE,IND,79)
 ENDDO
 RETU
 *----------------------------- END OF MAIN ROUTINE
*********************************************************************
* FUNCTION DBSCR TO DISPLAY DATA ON SCREEN
* ONE PARAMETER IND TO KEEP TRACK OF COLUMN
*********************************************************************
  FUNCTION DBSCR
    PARAM IND
 PRIVATE NUM,RC,I
     NUM=MIN(RECCOUNT(),20)
     RC=RECNO()
     FOR I= 1 TO NUM
       @ 1+I,1 SAY SUBSTR(TITLE,IND,79)
       SKIP
     NEXT I
   GOTO RC
   RELE NUM,RC,I
   RETURN 0
 ******************************************************
 * \\ EOF BROWSE.PRG
***************************
