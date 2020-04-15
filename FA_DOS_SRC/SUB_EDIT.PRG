* program to edit subheads
PARAM _WHAT
  SELE 1
   use stock\e_head index stock\e_head
  sele 2
   use stock\e_subhea index stock\e_subhea,stock\E_SUB1,stock\E_SUB2,stock\E_SUB3
  SELE 3
    USE stock\STOCK INDEX stock\STOCK
* user interface
  scroll(4,20,18,70,0)
  @ 4,20 to 18,70 double
  SET COLO TO /W
  @ 5,21 SAY SPaCE(49)
  @ 5,30 SAY " Subheads  "+iif(_what=="A"," Addition ",iif(_what="D"," Deletion"," Change "))
   set colo to
   @ 6,21 say repli (chr(205),49)
   @ 16,21 say repli (chr(205),49)
   set colo to /w
   @ 17,21 say " Esc-Return  Pgdn- Save & NExt  F1-COde        "
   set colo to
   @ 7,23 say  " CODE     "
   @ 8,23 SAY  " DESCR.   "
   @ 9,23 SAY " PACKING  "
   @ 10,23 SAY " RATE     "
   @ 11,23 SAY " PACKING  "
   @ 12,23 SAY " RATE     "
   @ 13,23 SAY " PACKING  "
   @ 14,23 SAY " RATE     "
SET EXACT ON
 DECLARE _pir[8]
 _pir[1]=SPACE(8)
 _pir[2]=SPACE(30)
 STORE 0.00 TO _pir[3],_pir[4],_pir[5],_pir[6],_pir[7],_pir[8]

set key 27 to esc_proc
 set colo to w+/n+,n/w,,,w+/n+
begin sequence
readexit(.t.)
fiu=1
dO WHILE .T.
      do case 
        case  fiu==1
          IF _WHAT="A"
            SET KEY 28 TO MODEL_H
           ELSE  
             Set key 28 to mub1
           ENDIF
              @ 7,35 GET _pir[1]  pict "@!"
              READ
  		Set key 28 to
           if len(alltrim(_pir[1]))<3
              err_msg(" INVALID CODE ")
              LOOP
           ENDIF
          SELE 1
         SEEK (LEFT(_pir[1],2))
           IF !FOUND()
             ERR_MSG(" GROUP HEAD NOT FOUND ")
             SELE 2
             LOOP
          ENDIF
          SELE 2
        SEEK _pir[1]
          IF (FOUND() .AND. _WHAT="A")
             ERR_MSG(" duplication ?? ")
             loop
          elseif (!found() .and. _what$"CD")
             err_msg(" ITEM not found     ")
             loop
           elseif (_pir[1]=space(8) .or. _pir[1]="########")
             err_msg(" INVALID ITEM ")
             loop
          endif


             if _what$"CD"
                   for _nt=2 to 8
                     df=field(_nt)
                     _pir[_nt]=&df
                  next
                    if _what="D"
                          for _nt=2 to 8
                              @ 6+_nt,35  say   _pir[_nt]
                          next
                             if chr(err_msg(" CONFIRM(Y/N) "))$"yY"
                                       sele 3
                                       seek B->s_code
                                 if found()
                                      IF IT_QTY>0
                                        ERR_MSG(" CANNOT DELETE ")
                                        LOOP
                                       ENDIF
                                        Delete
                                ENDIF
                               SELE 2
                             REPLACE S_CODE WITH "########"
                             delete
                            LOOP
                          ENDIF
                     loop
                  ENDIF
          ENDIF
                 fiu=2
            case fiu==2  
              @ 8,35 GET _pir[2] PICT "@S20!"
              READ
              IF _pir[2]=SPACE(30)
                ERR_MSG(" BLANK ITEM ?? ")
                
              LOOP
            ENDIF
                fiu=iif(lastkey()==5,1,3)    
           case fiu==3
             @ 9,35 get _pir[3] pict "99999"
             read
                 fiu=iif(lastkey()==5,2,4)

             case fiu==4 
             @ 10,35 get _pir[4] pict "9999999.99"
             read
                rm=lastKEY()
                 if (_pir[3] <=0 .or. _pir[4]<=0)
                    err_msg(" INVALID ITEM ")
                       fiu=3
                    loop
                  endif
                   if (rm=3 )
                       DO REP_DAT WITH _pir,4,_what
                       fiu=1 
                       loop

                   ENDIF
                    fiu=iif(lastkey()==5,3,5)
                case fiu==5  
             @ 11,35 get _pir[5] pict "99999"
             read
                        if _pir[5]<=0
                             err_msg(" invalid ")
                             loop
                        endif 
                     fiu=iif(lastkey()==5,4,6)
              case fiu==6    
                 @ 12,35 get _pir[6] pict "9999999.99"
                 read
                  rm=lastKEY()
                  if (rm=18)
                    fiu=5
                   LOOP
                  ENDIF
                if ( _pir[6]<=0)
                 err_msg(" INVALID ITEM ")
                            loop
                endif
                IF (rm=3)
                  DO REP_DAT WITH _pir,6,_what
                  fiu=1
                  LOOP
                           ENDIF
                  fiu=if(lastkey()==5,5,7)       
            case fiu==7
             @ 13,35 get _pir[7] pict "99999"
             read
                     if _pir[7]<=0
                            err_msg(" invalid item ")
                            loop
                      endif 

                fiu=if(lastkey()==5,6,8)
             case fiu==8
              @ 14,35 get _pir[8] pict "9999999.99"
             read
               if ( _pir[8]<=0)

                 err_msg(" INVALID ITEM ")
                      
                 loop
              endif
                     rm=lastkey()
                  IF (rm=3 .OR. rm=13)
                     do rep_dat with _pir,8,_what
                      fiu=1
                     loop
                 endif
                   fiu=1
             endcase       
       enddo
End
close all
set key 27 to
SET KEY 28 TO
Return

************************************************************************8
Proc rep_dat
param fpos,fno,hmode
save_se=select()
 if chr(err_msg(" CONFIRM(Y/N) "))$"yY"
     sele 2
     If Hmode$"Aa"
        locate for Deleted()
           If !found()
              Appe Blank
            Else
              Recall
           Endif

     Endif
For i=1 to 8
   l=field(i)
 If i<=fno
     Repl &l with fpos[i]
 Else
      Repl &l with 0.00
   Endif
Next
sele 3
Seek fpos[1]
 if !found()
    append blank
 endif     
 replace it_code with fpos[1]
 select(save_se)
 Endif
 retu

*----------------------------

    proc mub1
    private fil[2],samp[2]
    Set key 27 to
     fil[1]="s_code"
     fil[2]="s_desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      public soo
      soo=""
       set key 28 to
         sele 2
         msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"muncr45","",samp)

      setcolor(msav)
      set key 27  to  Esc_proc
      set key 28 to mub1
         restscreen(4,9,23,61,xf)
          release xf
          retu

   *-----------------------------------------
   *----------------------function func_r
function muncr45
param dfg,klm
   kep=lastkey()
  do case
    case kep >=32
        soo=soo+upper(chr(kep))
    case kep=13
       keyb S_Code
       return 0
  case kep=27
      return 0
   case kep=8
       soo=substr(soo,1,len(soo)-1)
   otherwise
      retu 1
   endcase
     @ 22,9 say space(52)
     @ 22,9 say soo
        
        set softseek on
         seek soo
        set softseek off
          keyb chr(0)
    return 2


*****************************
