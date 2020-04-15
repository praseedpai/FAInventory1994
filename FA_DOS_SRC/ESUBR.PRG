* program to add | change | delete Raw materials
* parameters A|B|C
*--------------------------------------------------------
param _what,ty
clear gets
Do case
  case ty=1
Sele 1
 Use stock\r_head index stock\r_head
  Sele 2
  Use stock\rsub index stock\rsub
  Sele 3
  use stock\rstock index stock\Rstock
  case ty=2
  Sele 1
  Use stock\C_head index stock\C_head
  Sele 2
  Use stock\csub index stock\csub
  Sele 3
   use stock\cstock index stock\cstock
 endcase
Sele 2
  Scroll(10,10,22,60,0)

  @ 10,10 to 22,60 double
  @ 12,11 say repli(chr(205),49)
  @ 20,11 say repli(chr(205),49)
  set colo to /W
 if ty=1
   @ 11,11 say "   Raw materials - Subheads "+iif(_what="A"," Addition            ",iif(_what="D"," Deletion            "," change              "))
  else
   @ 11,11 say "   Containers - Subheads "+iif(_what="A"," Addition               ",iif(_what="D"," Deletion               "," change                 "))

endif
@ 21,11 say "  Esc-Cancel        F1-Codelist                  "
set colo to
  @ 13,12  Say " Code         "
  @ 15,12 say  " DEscreption  "
  @ 17,12 say  " Rate         "

Declare my[3]
my[1]=space(5)
my[2]=space(25)
store 0.00 to my[3]
          set colo to w+/n+,n/w,,,w+/n+
Set Key 27 to Esc_proc
 Begin sequence
Do while .t.
 if _what=="A"
     set key 28 to mode_h
 else
     set key 28 to fgh
 endif
  
     @ 13,27 get my[1] pict "@!"
     read
  
   set key 28 to 
     sele 1
     Seek left(my[1],2)
      if !found()
        err_msg(" Group head Error ")
        loop
      endif
      sele 2
        seek my[1]
          Do case
            Case _what="A" .and. found()
              Err_msg(" Duplication ")
              loop
            Case _what$"CD" .and. !found()
              err_msg(" Code Not found  ")
              loop
         Endcase
         *---------------------- Change
          if _what$"CD"

             my[2]=desc
             my[3]=Rate
                @15,27 say my[2]
                @17,27 say my[3]
                  IF _what=="D"
                        IF chr(err_msg(" Confirm(y/n) "))$"Yy"
                            Sele 3
                            seek my[1]
                             if rqty >0
                                  err_msg(" cannot Delete ")
                                  SEle 2
                                  loop
                             Endif
                             replace rcode with "    "
                             DELETE 
                             Sele 2
                             replace code with "     ",desc with space(25),rate with 0
                             delete
                       Endif
                       loop
                 Endif  
           Endif

     @ 15,27 get my[2] pict "@s20!"  valid my[2] !=space(25)
     read

    @ 17,27 get my[3]  pict "9999.99"
    read
     if my[3] <=0
        err_msg( " invalid ")
        keyb chr(13)
        loop
     endif
      if chr(err_msg(" CONFIRM(Y/N) "))$"yY"

              Do case
                Case _what=="A"
                  Sele 3
                  APpen Blank
                  replace Rcode with my[1]
                  Sele 2
                   appen blank
                   replace code with my[1],desc with my[2],rate with my[3]
                Otherwise
                   sele 2
                   replace code with my[1],desc with my[2],rate with my[3]
              Endcase
     endif
  enddo

end
close all
Set key 28 to
set key 27 to
retu


    proc fgh
    private fil[2],samp[2]
   set key 27 to
     fil[1]="code"
     fil[2]="desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
    public moo
   moo=""
       set key 28 to
         sele 2
        msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"muncr1","",samp)
            setcolor(msav)
          set key 27 to Esc_proc
          set key 28 to fgh
          restscreen(4,9,23,61,xf)
          release xf

   *-----------------------------------------
   *----------------------function func_r
function muncr1
param dfg,klm
   kes=lastkey()
  do case

  case kes=13
     keyb B->Code+chr(13)
       return 0
  case kes=27
      return 0
  case kes>=32
       moo=moo+upper(chr(kes))
  case kes==8
       moo=substr(moo,1,len(moo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say moo
         set softseek on
            seek moo
         set softseek off
            keyb chr(0)
            return 2
*----------------------------------------------------------------------

