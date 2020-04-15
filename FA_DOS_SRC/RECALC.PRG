* program to recalculate balnces in
* bal_ledg.dbf
* Usage is neccessary when taking P&l A/c for
* Serious matters
*--------------------------------------------------------
Showbox()
Set date  Brit
Set deleted on
sele 1
  use data\bal_ledg index data\bal_ledg
sele 2
  use data\ledger index  data\ledger4 ,data\ledger5

sele 3
   Use data\sgroup index data\sgroup
 sele 1
   set relation to Is_code into C   
  mhifi=month(DAte())
  awe= if(mhifi<4, year(date())-1,year(date()))
  start=Ctod("01/04/"+str(awe%100,2))
  Ends=date()
   @ 1,0 clea to 3,60
   @ 1,0 to 3,60 double

@ 2,2 Say "Recalculating "    
Sele 1
Go top
Do while !eof()
  
  As=IS_code
  @ 2,16 Say C->s_desc 
Ks=start
   seek as
    op_bal=month00
     kn=1
        
    Do while ks<=ends
       kl=month(ks)
       Sele 2
          set order to 1
           Seek as+str(kl,2)
            Sum amount while  AC_1==AS .and. (month(Jdate)==kl)  to Foo1

          Set order to 2
              seek as+str(kl,2) 
        Sum amount while   AC_2==AS .and. (month(Jdate)==kl)  to Foo2

        op_bal=op_bal+(fOO1-FOO2)
        rap='month'+iif(kn<=9,'0'+str(kn,1),str(kn,2))
        Sele 1
        Replace &rap with op_bal
        kn=kn+1
        ks=addmonth(ks,1)
      ENDDO
    sele 1
    skip
  Enddo

close all
hidebox()



