param _what,md
Do case
case md=1
     sele 1
     Use stock\rstock index stock\Rstock
     Sele 2
     Use stock\rsub index stock\Rsub
     Sele 3
     Use stock\rstocktr index stock\rstocktr
Case md=2
     Sele 1
     Use stock\Cstock index stock\Cstock
     Sele 2
     Use stock\Csub Index stock\Csub
     Sele 3
     Use stock\cstocktr index stock\cstocktr
 Endcase
   declare de[3]
    de[1]=space(5)
    de[2]=0.00
    de[3]=space(50)
   Scroll(8,10,17,50,0)
    set colo to /w
    @ 9,11 say space(39)
    @ 9,15 say  "      Stock "+iif(_what=="A", " Addition  ","  Deletion  ")
   set colo to
   @ 10,11 say repli (chr(205),39)
   @ 8,10 to 17,50 double
    @ 12,12 say " CoDe     "
    @ 14,12 say " Qty      "
    @ 16,12 Say " Descr    "
 set key 27 to Esc_proc
  set colo to w+/n+,n/w,,,w+/n+
 Begin Sequence
    do while .t.
      Set key 28 to mun_12
      @ 12,20 get  de[1]
      read
      set key 28 to
     Sele 1
      Seek de[1]
         if !found()
           Err_msg(" Code not Found ")
           loop
         endif
      @ 14,20 get de[2]
      read
        if de[2]<=0
          err_msg(" INVALID AMOUNT ")
          KEYB CHR(13)
          LOOP
        ENDIF
       @ 16,20 get de[3] pict "@s25!"
       Read

   if chr(err_msg(" Confirm (y/n) "))$"Yy"
          dO CASE
            cASE _WHAT="A"
              Sele 3
               Append Blank
                 Replace Tdate with Date(),Tdesc with de[3],Tcode with De[1],;
                 Tqty with de[2],tind with "A"
            sele 1
             REPLACE RQTY WITH RQTY+DE[2]
            cASE _WHAT="D"
               IF RQTY<DE[2]
                  ERR_MSG(" sUFFICIENT STOCK IS NOT AVAILABLE ")
                  LOOP
               ENDIF
                Sele 3
               Append Blank
                 Replace Tdate with Date(),Tdesc with de[3],Tcode with De[1],;
                 Tqty with de[2],tind with "D"
              Sele 1
              REPLACE RQTY WITH RQTY-DE[2]
          ENDCASE



       DE[2]=0
       endif

    enddo
end
SET KEY 28 TO
SET KEY 27 TO
CLOSE ALL
RETU









    proc mun_12
    private fil[2],samp[2]
     Set key 27 to
     fil[1]="code"
     fil[2]="desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
         sele 2
        msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"mucr","",samp)
            setcolor(msav)
        set key 27 to ESc_proc
        set key 28 to mun_12
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function mucr
param dfg,klm
   kes=lastkey()
  do case

  case kes=13
     keyb B->Code
       return 0
  case kes=27
      return 0
  case isalpha(upper(chr(kes))) .or. isdigit(upper(chr(kes)))
       foo=foo+chr(kes)
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
       df=recno()
    locate for upper( substr( code, 1 , len(foo) ) )=upper(foo)
      if !found()
         goto df
      endif
    return 1






