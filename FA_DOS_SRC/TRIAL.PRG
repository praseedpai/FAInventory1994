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

curr=savescreen(9,9,13,40)
scroll(9,9,13,40,0)
@ 9,9 to 13,40 double


begin sequence

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


   SELE 1
   Set softseek on

   Seek fri

     Copy To Scratch\t_temp while  jdate<=to
   Set softseek off
    Sele 1
      Use Scratch\T_temp
           index on AC_1 to Scratch\PT_temp
           index on AC_2 to Scratch\PT_temp1

      Use Scratch\T_temp index Scratch\PT_temp,Scratch\PT_temp1


  * Select 10

  *Use Scratch\t_temp 
  * Zap

  *index on AC_1 to Scratch\PT_temp
  *index on AC_1 to Scratch\Pt_temp1


   *Sele 1

  *Sekdate = fri 

  *Seek  Sekdate

  *Do While  Jdate <= to  .and. !Eof()

   *  Sele  10
   *  append blank
    * Replace Ac_1 with  A->Ac_1 , amount with A->amount , ;
    *         Ac_2 with A->Ac_2

    * Sele 1
     *Skip

*   Enddo
        
   


              Sele 2
                     Dr_tot=0
                      Cr_tot=0
                       LIN=6
                        sET dEVICE tO pRINTER
                        sET pRINTER TO pREP.REP
                          tROJAN()
                    Do While !Eof()
                        Rs=S_code
                         SEle 1
                          Set order to 1
                           Seek Rs
                             Sum amount To  Foo  While Ac_1==Rs
                           Set order to 2
                             sEEK rS
                             Sum Amount to  Foo1 while Ac_2==Rs
                               Bal=Foo-Foo1
                               IF Bal <>0
                                 @ lin,1  Say b->S_desc
                                 @ lin,37 Say CHR(186)
                                   IF Bal >0
                                      Dr_tot=Dr_tot+Bal
                                      @ lin,38 Say Str(bal,15,2)
                                      @ lin,54 Say CHR(186)
                                   Else
                                      Cr_Tot=Cr_tot+aBS(Bal)
                                      @ LIN,54 sAY CHR(186)
                                      @ lin,55 Say Str(-Bal,15,2)
                                   Endif

                                    @ lin,72 Say CHR(186)

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

@ lin,1 Say Repli(chr(205),72)
LIN=LIN+1
@ LIN,1 sAY " tOTAL      >>"
@ LIN,38 sAY sTR(dR_TOT,15,2)
@ LIN,55 sAY sTR(CR_TOT,15,2)
@ LIN+1,1 sAY rEPLI(CHR(205),72)
                          SET dEVICE tO sCREEN
                          sET pRINTER TO
                          bROW("pREP.REP")
       end
    Set key 27 to
                          Clear Gets
                         cLOSE ALL
                         rETURN




fUNCTION tROJAN
@ 1,0 sAY  cENTER(" S I M I L I A  H O M O E O   L A B O R A T O R Y ")
@ 2,0 sAY  cENTER(" TRIAL BALANCE ")
@ 3,0 sAY  cENTER(" From   "+dTOC(fRI) + "     tO    "+dTOC(TO) )
@ 4,0 sAY  "         aCCOUNTS                       dEBIT            cREDIT   "
@ 5,0 sAY  rEPLI(chr(205),72)
rETURN 0