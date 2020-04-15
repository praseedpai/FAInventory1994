* program to edit raw materials  && Containers and bottles
* 3 parameters A|C|d   and  1|2 which specifies raw material or containers
* Group heads
*-----------------------------------------
param _what,km
   Sele 1
   do case
       case km=1
              Use  stock\r_head index  stock\r_head
          sele 2
              Use  stock\rsub index  stock\rsub
       case km=2
              use  stock\c_head index  stock\c_head
          sele 2
              use  stock\csub index  stock\csub
   endcase
sele 1
Scroll(4,10,16,50,0)
@ 4,10 to 16,50 double
SEtcolor("W+/G")
if km=1
   @ 5,19 say " Raw materials "+iif(_what="A","Addition",iif(_what="D","Deletion"," change "))
  Else
    @ 5,19 say "   Containers "+iif(_what="A","Addition",iif(_what="D","Deletion"," change "))
Endif
@ 6,10 to 14,50 double
Setcolor("n/w")
@ 15,11 say "  Esc- cancel   F1-Codelist            "
setcolor("")
@ 4,10 to 16,50 double
@ 6,11 say repli (chr(205),39)
@ 14,11 say repli (chr(205),39)
SET KEY 27 TO ESC_PROC
 Private dat[4]
  dat[1]="  "
  dat[2]="                        "
  dat[3]="  "
  @ 8,12 Say   "   Code   "
  @ 10,12 say  "   Desc   "
  @ 12,12 say  "   Unit   "
        set colo to w+/n+,n/w,,,w+/n+
Begin Sequence
   Do while .t.
     set key 28 to mode_h
       @ 8, 24  Get dat[1] pICT "!!"
       Read
       set key 28 to
         if dat[1]=="  "
            loop
         endif

          Seek Dat[1]

          Do case
            Case _what=="A" .and. found()
                  Err_msg(" dUPLICATION ")
                  loop
            Case _what$"CD" .and. !found()
                  Err_msg(" CODE NOT FOUND    ")
                  loop
           Endcase
               if _what$"CD"
                   dat[1]=Code
                   dat[2]=Desc
                   dat[3]=Unit
                  @ 8,24 say dat[1]
                  @ 10,24 say dat[2]
                  @ 12,24 say dat[3]
               if _what=="D"
                  if chr(err_msg("Confirm(y/n)"))$"Yy"
                       Sele 2
                       locate for Substr(code,1,2)==dat[1]
                       if found()
                         Err_msg(" Cannot delete ")
                        sele 1
                        loop
                       endif
                 sele 1
                   replace code with "  ",desc with space(25),unit with " "
                   delete

                  endif
               loop
              endif
          endif
        @ 10,24 GET DAT[2] PICT "@!" VALID DAT[2] !=SPACE(25)
        READ
        @ 12,24 GET DAT[3] PICT "@!"
        READ
          If (.not.(DAT[3]=="LR" .OR. DAT[3] =="KG" .OR. DAT[3]=="NO") )
            ERR_MSG(" CHOOSE BETWEEN  <LR | KG | NO >")
            KEYB CHR(13)+CHR(13)
            LOOP
          ENDIF
              IF CHR(ERR_MSG(" CONFIRM(Y/N) "))$"yY"
                   IF _WHAT=="A"
                      locate for deleted()
                       if !found()
                        APPEN BLANK
                       else
                       recall
                      endif
                   ENDIF
                   REPLACE CODE WITH DAT[1],DESC WITH DAT[2],UNIT WITH DAT[3]
             ENDIF

enddo
END
SET KEY 28 TO
SET KEY 27 TO
release dat
CLOSE ALL
RETU

   *function mode_h
    proc mode_h
    private fil[2],samp[2]
     set key 27 to
     fil[1]="code"
     fil[2]="desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
       rse=select()
         sele 1
          msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"muncr","",samp)
            setcolor(msav)
            select(rse)
            set key 27 to Esc_proc
        set key 28 to mode_h
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function muncr
param dfg,klm
   kes=lastkey()
  do case

  case kes=13
     keyb A->Code
       return 0
  case kes=27
      return 0
  case kes>=32
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
