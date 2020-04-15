* Program to Print Trial Balance
*
*********************************************
 
Set date brit
set key 27 to esc_proc
sele 1
use data\ledger index data\ledger1,data\ledger2,data\ledger3

sele 2
use data\sgroup index data\sgroup
Lin=0
fri=ctod("")
to=date()
begin sequence
curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double
  Do while .t.
set colo to w+/n+,n/w,,,w+/n+
  set key 28 to

  fri=ctod("")

 @ 11,10 say " from   " get fri
 read
 goo_dat=Ctod("01/04/"+if(month(date())<=3,str((year(date())-1 )%100,2),str(year(date())%100,2)))

  if fri< goo_dat  .or. fri ==ctod("")
     err_msg(" invalid date")
     loop
 endif

 @ 12,10 say " to     " get to
 read
   if to<fri .or. fri>date() .or. to ==ctod("")
     err_msg(" invalid date")
    keyb chr(13)
    loop
  endif

  Exit
 Enddo
   sele 1
     Copy To Scratch\t_temp For jdate>=fri .and. jdate<=to

    Sele 1
      Use Scratch\T_temp
           index on AC_1 to Scratch\PT_temp
           index on AC_2 to Scratch\PT_temp1

        Use Scratch\T_temp index Scratch\PT_temp,Scratch\PT_temp1

              Sele 2
                     Dr_tot=0
                      Cr_tot=0
                       LIN=6
                        sET dEVICE tO pRINTER
                        sET pRINTER TO pREP.REP
                          tROJAN()
                    Do While !Eof()
                        Rs=S_code
                        bAL = iif(s_DRCR=="D",S_OPBAL,-S_OPBAL)
                         SEle 1
                          Set order to 1
                           Seek Rs
                             Sum amount To  Foo  While Ac_1==Rs
                           Set order to 2
                             sEEK rS
                             Sum Amount to  Foo1 while Ac_2==Rs
                               Bal=BAL+(Foo-Foo1)
                               IF Bal <>0
                                 @ lin,1  say chr(15)+ b->S_desc
                                 @ lin,37 say chr(15)+ CHR(186)
                                   IF Bal >0
                                      Dr_tot=Dr_tot+Bal
                                      @ lin,38 say chr(15)+ Str(bal,15,2)
                                      @ lin,54 say chr(15)+ CHR(186)
                                   Else
                                      Cr_Tot=Cr_tot+aBS(Bal)
                                      @ LIN,54 say chr(15)+ CHR(186)
                                      @ lin,55 say chr(15)+ Str(-Bal,15,2)
                                   Endif

                                    @ lin,72 say chr(15)+ CHR(186)

                                     Lin=lin+1
                                      eNDIF
                                       IF LIN>60

                                           LIN=6
                                           eJECT
                                       tROJAN()
                                        eNDIF

                                  Sele 2
                                    sKIP
                               ENDDO

@ lin,1 say chr(15)+ Repli(chr(205),72)
LIN=LIN+1
@ LIN,1 say chr(15)+ " tOTAL      >>"
@ LIN,38 say chr(15)+ sTR(dR_TOT,15,2)
@ LIN,55 say chr(15)+ sTR(CR_TOT,15,2)
@ LIN+1,1 say chr(15)+ rEPLI(CHR(205),72)
                          SET dEVICE tO sCREEN
                          sET pRINTER TO
                          bROW("pREP.REP")
       end
    Set key 27 to
                          Clear Gets
                         cLOSE ALL
                         rETURN




