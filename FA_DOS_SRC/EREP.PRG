*programt o print detailed stock report
*
*
*
*

PARAM _WHY
set century on


DO CASE
 CASE _WHY=="2"


   Select 1
    Use stock\Cstocktr index stock\Cstocktr,stock\Cst1
   Select 2
    Use stock\Csub index stock\Csub
   SELE 3
    USE STOCK\c_HEAD INDEX STOCK\C_HEAD

 CASE _WHY=="1"
    Select 1
     Use stock\Rstocktr index stock\Rstocktr,stock\Rst1
   Select 2
     Use stock\Rsub index stock\Rsub
   SELE 3
     uSE STOCK\r_HEAD INDEX STOCK\R_HEAD
 ENDCASE

MY=IF(month(date())<=3,YEAR(date())-1,YEAR(date()))

STDAT=CTOD("01/04/"+STR(MY%100,4))

mcode=space(5)

Cur_Fld = 1

public mStDate 
Public mEndDate

mStDate = Ctod("")
mEndDate = Date()

SCROLL(8,10,14,55,0)

@ 8,10 to 14,55


SET KEY 27 TO ESC_PROC


BEGIN SEQUENCE

  DO WHILE .T.
 
    Do Case
       Case ( Cur_Fld == 1 ) 
         SET KEY 28 TO mun_wat  
          @ 10,12 say "Code       " Get mCODE
          Read
          if ( Lastkey() == 5 )
                loop
          endif
          SET KEY 28 TO
          sele 2
          seek mcode
           If !found()
              Err_msg("No such code exists ")
              loop
           endif
           Cur_Fld = Cur_Fld + 1
           Loop
      Case ( cur_Fld == 2 )
         @ 11,12 say "Start Date  " Get mStDate 
         Read
         if ( LastKey() == 5 )
                  Cur_Fld = Cur_Fld-1
                  Loop
          Endif
                     
          IF mStDate < STDAT  .or. mStDate > Date()  
                 Err_Msg(" Invalid Date " )
                 Loop
          Endif
               
          Cur_Fld = Cur_Fld+1
          Loop

       Case (  Cur_Fld == 3 )
          @ 12,12 Say "End Date   " get mEndDate
          read
              
          if ( LastKey() == 5 )
                Cur_Fld = Cur_Fld-1
                Loop
          Endif
                     
          IF mEndDate < mStDate  .or. mEndDate > Date()
                 Err_Msg(" Invalid Date " )
                 Loop
          Endif
                                  
          Cur_Fld = Cur_fld+1  
          
      EndCase   

 

exit
enddo



public mtno
MTNO=DATE()-STDAT+1


heller  = mStDate  - STDAT + 1
heller1 = mEndDate - STDAT + 1


SELE 1
SORT ON TNO TO TEMP FOR uppER(TCODE)=UPPER(MCODE) .and. !Deleted()


Set century off
SET DEVICE TO PRINTER
Set PRINTER TO sFOOL.TXT

SELE 4

USE TEMP
go top

*----- Compute the Opening Stock


mTotal = 0
Do While Tno < Heller .and. !Eof()
     IF Tind == "R"
         mTotal = mTotal + tqty
     else
         mTotal = mTotal - tqty
     Endif
     skip
Enddo

HEADERS()

mlin=6
tot_stock= mTotal


*------ Get the unit
   
SELE 3
SEEK LEFT(MCODE,2)
RTE=UNIT


       
SELE 4 
GO TOP


IF Heller !=1           
         @ mlin,1    Say mStDate                   
         @ mlin,9    Say "|"
         @ mlin,10   Say " Opening Balance " 
         @ mlin,43   Say "|"
         IF mTotal >= 0   
               @ mlin,44 say str(mTotal,10,2)+RTE
         Endif 
        @ MLIN,58 SAY "|"                            
        IF mTotal < 0   
               @ mlin,59 say str(abs(mTotal),10,2)+RTE
        Endif 
        @ mlin,74 Say "|"             
       
   
*---         Tot_Stock = mTotal 
          mlin = mlin+1

      Endif

       do while Tno <= Heller1 .and. !EOF()

            @ mlin,1 say stDAT+TNO-1
              sele 4
             @ mlin,9 say "|"
             @ mlin,12 say treason
             @ mlin,43 say "|"
         if tind=="R"
             
             @ mlin,44 say str(tqty,10,2) +RTE
             @ mlin,58 say "|"
             tot_stock=tot_stock+tqty  
          else
              @ mlin,58 say "|"
             @ mlin,59 say str(tqty,10,2) +RTE
              tot_stock=tot_stock-tqty 
        endif
        @ mlin,74 say "|"
        MLIN=MLIN+1
        IF MLIN>=55
          MLIN=6
          EJECT
          HEADERS()
        ENDIF
       skip
         



      endd
 @ mlin,1 say repli("-",79)
 @ mlin+1,1 say " STOCK BALANCE   "+str(tot_stock,14,2)+RTE
eject 
set device to screen
set printer to
brow("Sfool.txt")
set century on
END
SET KEY 27 TO
CLEAR GETS
set century on 
close all

FUNCTION HEADERS
set century off
@ 1,0 SAY CENTER("S I M I L I A  H O M O E O  L A B O R A T O R Y ")
@ 2,0 SAY Center( "STOCK REPORT OF "+b->DESC )
@ 3,0 SAY Center( "From " + Dtoc( mStDate ) + " To " + Dtoc(mEndDate ) )
@ 4,0 SAY " dATE         NARRATION                        RECIEPTS      ISSUES "
@ 5,0 SAY "--------------------------------------------------------------------"
RETURN 0

    proc mun_wat
    private fil[2],samp[2]
     set key 27 to
     fil[1]="code"
     fil[2]="desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
       mas=select()
         sele 2
        msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"_mucr","",samp)
            setcolor(msav)
            select(mas)
        set key 27 to ESc_proc
        set key 28 to mun_wat
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function _mucr
param dfg,klm
   kes=lastkey()
 do case
   case kes=13
       keyb B->Code
       return 0
  case kes=27
      return 0
  case kes>=32 
       foo=foo+Upper(chr(kes))
  case kes==8
       foo=Left(foo,len(foo)-1)
   otherwise
      retu 1
   endcase
    @ 22,9 say space(52)
    @ 22,9 say foo
        set softseek on
          seek foo
        set softseek off
            keyb chr(0)
        return 2


