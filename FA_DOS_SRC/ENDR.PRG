* programt o print detailed stock report
*
*
*
*
PARAM _WHY
public mStDate
public mEndDate
set century on
set deleted on
   Select 1
    Use stock\Estocktr index stock\Estocktr,stock\Est1
   Select 2
    Use stock\E_subhea index stock\E_subhea
   sele 8
    use stock\E_head index Stock\E_head    
   sele 10
   use stock\invoice index stock\invoice
SET KEY 27 TO ESC_PROC
DFGM=MONTH(DATE())
MY=IF(DFGM<=3,YEAR(date())-1,YEAR(date()))
STDAT=CTOD("01/04/"+STR(MY%100,4))
*-------------------------- Variables to get Date
 mStDate = Ctod("")
 mEndDate = Date()
 Cur_Fld  = 1
ReadExit(.T.)
SET KEY 27 TO ESC_PROC
mcode=space(8)
scroll(8,10,14,55,0)
@ 8,10 to 14,55
BEGIN SEQUENCE
do while .t.
 
  Do Case
     Case ( Cur_Fld == 1 ) 
          SET KEY 28 TO mun_wa 
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

mns = month( mStDate )  
mns = IIF( mns < 4 , mns+9 , mns )
rns = month( mEndDate )
rns = IIF( rns < 4 , rns+9 ,rns )
SELE 1
copy TO TEMP FOR TCODE=MCODE  


  sele 5
  use temp

for i=1 to 12
   fil="stock\"+"inv"+if(i<=9,'0'+str(i,1),str(i,2))+".dbf"
      IF File(fil)
        sele 6
        Use &fil
        go top
           do while !eof()
             
                IF  code=mcode 
                    Sele 10
                    Seek F->Invno
                            
                          sele 5
                          append blank
                          replace  tcode with f->code,tqty with f->quant*f->packing,;
                          tind with "I"
                         replace treason  with     "invoice no "+str(F->invno,5)
                        replace tno with (j->invdate)-stdat+1
                     
                Endif 
                     sele 6
                      skip
             enddo
      else
        exit
     endif
 next
  sele 5
  index on tno to temp
  
   go top
 Set device to printer
 set printer to fool.txt
 set century off

   go top
   HADERS()
   mlin=6
    Tot_stock=0
     sele 8
      seek left(mcode,2)
      rte=unit
      if rte=="GM" 
            rte="KGS"
       elseif rte=="ML"
            RTe="LRS"
       endif
     
       sele 5
         
         IF heller !=1 
          mTotal = 0
           
          
          Do While tno <Heller .and. !Eof()
               IF Tind == "R"     
                  mTotal = mTotal + tqty
               Else 
                  mTotal = mTotal - tqty   
               Endif 
               skip
          Enddo 
 
           @ mlin,1    Say mStDate                   
           @ mlin,9    Say "|"
           @ mlin,10   Say " Opening Balance " 
           @ mlin,43   Say "|"
           IF mTotal >= 0   
              if rte=="LRS" .or. rte=="KGS"
                    @ mlin,44 say str(mTotal/1000,10,2)+" "+rTE
              Else
                    @ mlin,44 say str(mTotal,10,2)+" "+RTE
              endif 
           Endif 
           @ MLIN,58 SAY "|"                            
          IF mTotal < 0   
              if rte=="LRS" .or. rte=="KGS"
                    @ mlin,59 say str(abs(mTotal)/1000,10,2)+" "+rTE
              Else
                    @ mlin,59 say str(abs(mTotal),10,2)+" "+RTE
             endif 
          Endif 
          @ mlin,74 Say "|"           
           mlin = mlin +1
           Tot_stock = mTotal
         Endif 
      do while Tno <= Heller1 .and. !EOF()
             @ mlin,1 say stDAT+TNO-1
             @ mlin,9 say "|"
             @ mlin,12 say treason
             @ mlin,43 say "|"
        if tind=="R"
              if rte=="LRS" .or. rte=="KGS"
                  @ mlin,44 say str(tqty/1000,10,2)+" "+rTE
              Else
                  @ mlin,44 say str(tqty,10,2)+" "+RTE
              endif 
              @ MLIN,58 SAY "|"                          
           tot_stock =tot_stock+tqty
        else
            @ MLIN,58 SAY "|"
              if RTE=="LRS" .or. RTE=="KGS"
            
                @ mlin,59 say str(tqty/1000,10,2)+" "+RTE
              Else
                  @ mlin,59 say str(tqty,10,2)+" "+RTE

              endif 
                       



             tot_stock=tot_stock-tqty         
       endif
      @ mlin,74 say "|" 
        MLIN=MLIN+1
        IF MLIN>=55
          MLIN=6
          EJECT
          haders()
        ENDIF
       skip



      endd
@ mlin,1 say repli("-",79)
IF RTE=="KGS" .OR. RTE=="LRS"
      TOT_STOCK=TOT_STOCK/1000
 ENDIF 
@ mlin+1,1 say  " STOCK BALANCE     "+STR(TOT_STOCK,14,2)+"  "+RTE
eject      
set device to screen
set printer to
brow("fool.txt")
set century on 
END
SET KEY 27 TO
CLEAR GETS
set century on 
close all

FUNCTION haders
@ 1,0 SAY CENTER("S I M I L I A  H O M O E O  L A B O R A T O R Y ")
@ 2,0 SAY Center("STOCK REPORT OF "+b->s_DESC)
@ 3,0 Say Center(" Between " + Dtoc( mStDate ) + " To "+ Dtoc(mEndDate ) )
@ 4,0 SAY " dATE         NARRATION                        RECIEPTS        ISSUES      "
@ 5,0 SAY "----------------------------------------------------------------------------"
RETURN 0





    proc mun_wa
    private fil[2],samp[2]
     set key 27 to
     fil[1]="s_code"
     fil[2]="s_desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
       mas=select()
         sele 2
        msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"_muc","",samp)
            setcolor(msav)
            select(mas)
        set key 27 to ESc_proc
        set key 28 to mun_wa
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function _muc
param dfg,klm
   kes=lastkey()
  do case

  case kes=13

       keyb B->s_Code
       return 0
  case kes=27
      return 0
  case kes >=32
       foo=foo+upper(chr(kes))
  case kes==8
       foo=substr(foo,1,len(foo)-1)
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

* function to save data to the file
*

