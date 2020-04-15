* Program to Add Data for an invoice
* most importrant Program of the system
*
*////////////////////////////////////////////////////////
*-------------------------------invoice summary
set century on
set deleted on
sele 1
use stock\invoice  index stock\invoice,stock\invoice1
*--------------------------------invoice detail
sele 2
use stock\stock inde stock\stock
*---------------------------------- sub_heads for valid code
sele 3
use stock\e_subhea index stock\e_subhea,stock\e_sub1,stock\e_sub2,stock\e_sub3
*-----------------------------------------------------FILE FOR DBEDIT
sele 4
use stock\tdet
*------------------------------------------dealer file
SELE 5
  use stock\dealer index stock\dealer
************************************************
* Caution next code analyzes the file to be used
*
*
 Sele 6
Public mdoi,mpas
mpas=0
mdoi=date()
  rsd=month(date())
  rsd=iif(rsd>=4,rsd-3,rsd+9)
  vfile="stock\"+'inv'+if(rsd<=9,'0'+str(rsd,1),str(rsd,2))

     if !file(vfile+".dbf")
          Use stock\fACT
          copy to &vfile
          use &vfile
          zap
          index on invno to &vfile
    endif
   use &vfile index &vfile
*--------------------------------------------------------
 scroll(0,0,24,79,0)
 @ 2,1 to 8,75 double
 public sdis
 sdis=0
*---------------------------------- PROMPTING
  @ 3,3 say  " Invoice no"
  @ 3,30 SAY " Date      "
  @ 3,54 SAY " customer  "
  @ 4,3 say  " order no  "
  @ 4,30 say " orddate   "
  @ 4,50 say " despatched"
  @ 5,3  say " to        "
  @ 5,40 say " r.r. lr.no"
  @ 6,3 say  " dATE      "
  @ 6,30 SAY " Through   "

 *------------------------  END PROMPT
 Public in[12]
 in[1]=0
 in[2]=date()
 in[3]=space(4)
 in[4]=space(10)
 in[5]=ctod("")
 in[6]=space(15)
 in[7]=space(25)
 in[8]=space(20)
 in[9]=ctod("")
 in[10]=space(46)
 in[11]=0
set colo to /w
 @ 24,0 say space(79)
 @ 24,0 say center(  "  F1-codelist   F2-SAVE  F7-change discount rate   ESC-cancel  ")
 *----------------------------
 set colo to
 Public Ind_flag
sele 1
go bott
in[1]=int(invno+1)
SET ORDER TO 1
public awe
awe=0.00
*---------------------------array of picture to dbedit
private pic[8]
pic[1]="@!"
pic[2]="@s20!"
pic[3]="99999"
pic[4]="999.99"
pic[5]="999.99"
pic[6]="999999999999999.99"
pic[7]="Y"
pic[8]="99.99"
*---------------------------------
private _head[8]
_head[1]=" code "
_head[2]=" Descr. "
_head[3]=" packing "
_head[4]=" RATE   "
_head[5]=" QTY    "
_head[6]=" Amount "
_head[7]=" Taxable "
_head[8]=" DISC    "
SET KEY 27 TO EsC_PROC
BEGIN SEQUENCE
Readexit(.t.)
*// going to change for two dimensional navigation
flc=1
Do while .t.
Sele 4
zap
appen blank
REPLACE TAXABLE WITH "Y"
 * // Case field =1
  Do while .t. 
   Do Case 
     Case flc==1
    set colo to w+/n+,n/w,,,w+/n+
    @ 3,17 get in[1] pict "99999999"
    read
        IF lastkey()==5 .or. lastkey()==24
               loop
        endif 
            
     if (in[1]<0)
       err_msg(" INVALID INVOICE NUMBER ")
      LOOP
     ENDIF
   sele 1
     SEEK IN[1]
      IF FOUND()
        ERR_MSG(" DUPLICATE INVOICE NO <RETRY>")
        LOOP
      ENDIF
         flc=2 
         Loop   
      Case flc==2
        @ 3,41 get in[2]
        read
             If lastkey()==5
                  flc=1
                  Loop
             Endif
        IF IN[2]>DATE()+10
        ERR_MSG(" INVALID DATE ")
         KEYB CHR(13)
         LOOP
      ENDIF
          flc=3
            Loop  
      Case flc==3
        sET KEY 28 TO CUST_HELP
        @ 3,65 get in[3] PICT "@!"
         read
        
           IF LASTKEY()==5
              SET KEY 28 TO
              FLc=2
              LOOP
           ENDIF    

         sele 5
          seek in[3]
           if !found()
              err_msg(" not frequent customer ??")
           endif
            sET KEY 28 TO
             flc=4
              Loop
         Case flc==4
            set colo to w+/n+,n/w,,,w+/n+
            @ 4,17 get in[4] PICT "@!"
             read
                   
           IF LASTKEY()==5
              FLc=3
              LOOP
           ENDIF    
          
       flc=5
        loop
   Case flc==5
     @ 4,41 get in[5]
      READ 
          
           IF LASTKEY()==5
              FLc=4
              LOOP
           ENDIF
          flc=6    
           Loop
    Case flc==6
       @ 4,60 get in[6] PICT "@s10!"
       READ
          
           IF LASTKEY()==5
              FLc=5
              LOOP
           ENDIF
            flc=7
           Loop        
     Case flc==7 
        @ 5,17 get in[7] pict "@s15!"
        READ   
        
           IF LASTKEY()==5
              FLc=6
              LOOP
           ENDIF    
           flc=8
            Loop
       Case flc==8
          @ 5,50 get in[8] PICT "@!"
          READ 
                
           IF LASTKEY()==5
              FLc=7
              LOOP
           ENDIF     
            flc=9
           Loop
        Case flc==9 
           @ 6,17 get in[9]
           READ 
          
           IF LASTKEY()==5
              FLc=8
              LOOP
           ENDIF     
             flc=10
             Loop
         Case flc==10  
          @ 6,41 get in[10]   pict "@s20!"
          read
               
           IF LASTKEY()==5
              FLc=9
              LOOP
           ENDIF     
             flc=11
             loop
          Case flc==11 
            Do while  .t.
            @ 7,3  Prompt "KGST"
            @ 7,10  Prompt "CST "
            menu to rmn
             if rmn==0
                loop
              elseif rmn==1
               indflag=" KGST "
    in[12]=8.00
   else
     in[12]=4.00
     indflag=" CST "

   endif
   @ 7,3 clea to  7,20
   @ 7,3 Say indflag
   exit
  enddo
     flc=12
      loop
 Case flc==12 
   @ 7,20 Say "Tax Rate %  :-"  Get in[12] pict "9999999.99"
   Read
          
           IF LASTKEY()==5
              FLc=10
              LOOP
           ENDIF     
      if in[12]<=0
        Err_msg(" INVALid rate ")
        loop
      endif
     if Chr(err_msg("Confirm(y/n)"))$"Yy"
         flc=13
         loop 
     else
        loop
     endif
       
   Case flc==13
            
      @ 7,60 say "ADD DIS." get awe pict "99.99"
       read 
        
           IF LASTKEY()==5
              FLc=12
              LOOP
           ENDIF     
             flc=1
          Endcase
     
     Exit
   Enddo

sele 4
    @9,1 to 23,76
   BEGIN SEQUENCE
  KEYB CHR(0)    
    dbedit(10,2,22,75,"","rap",pic,_head)
     if last()=-1
      showbox()
       Dat_SAVE()
       hidebox()
       IN[1]=int(IN[1]+1)
     ENDIF
   END
enddo
END
SET KEY 28 TO
SET KEY 27 TO

CLOSE ALL
RETU
*----------------------------------------

FUNCTION dAT_SAVE
   *--------------------------invoice.dbf
SELE 1
    APPEN BLANK
FOR I=1 TO 11
     SDMJ=FIELD(I)
     REPLACE   &SDMJ WITH IN[I]
NEXT I
*---------------------------------------Stock Updation
   SELE 4
   GO TOP
     grsales=0.00
     netdis=0.00
     taxes=0.00
*--------------------added lately
 tax_tot=0
 ntax_tot=0
 t_disc=0
 nt_disc=0
netdis=0
*------------------
 taxrate=in[12]*.01
 E1=0
 E2=0
 DO WHILE !EOF()
     Replace amount with Rate*quant
    sele 6
      append blank
       replace invno with in[1],code with d->code,;
       desc with d->desc,packing with d->packing,;
       rate with d->rate,quant with d->quant,amount with d->amount,;
       taxable with d->taxable,disc with d->disc
    SELE 2
       SEEK D->CODE
           
           SELE 4
           REPLACE  B->IT_QTY WITH ( B->IT_QTY -(qUANT*packing ))
          
       Grsales=Grsales+Amount
       netdis=netdis+(amount*disc/100)
     if taxable=="Y"
          tax_tot=tax_tot+amount
          t_disc=t_disc+(amount*disc/100)
          E1=E1+(amount-amount*disc/100)*awe/100
      else
           ntax_tot=ntax_tot+amount
           E2=E2+(amount-amount*disc/100)*awe/100
       endif

       skip
 ENDDO
  safl= Grsales-netdis-E1-E2

 Taxes=((Tax_tot-T_disc)-E1)*taxrate
 Sele 1
    Replace rtotal with safl,tax with taxes
    Replace tind with  if(indflag==" KGST ","0","1")
    REPLACE TRATE WITH IN[12],doi with mdoi
    Replace ADi with Awe,NAMOUNT WITH (NTAX_TOT-E2-(NETDIS-T_DISC))
    REPLACE TAMOUNT WITH TAX_TOT-T_DISC-E1

 Return 0



****************** // program to give customer help

Proc CUST_HELP
private fil[2]
set key 27 to
fil[1]=" dLR_CODE"
fil[2]=" dLR_NAME"
private samp[2]
samp[1]=" CODE "
samp[2]= "          NAME            "
xf=savescreen(4,25,23,76)
set key 28 to
rer=select()
 sele 5
 msav=setcolor("/w+,w+/n")
 @ 4,25 to 21,76 double
    go top
    public foo
    foo=""
    dbedit(5,26,20,75,fil,"__Funcr","",samp)
     setcolor(msav)
     select(rer)
      set key 27 to Esc_proc
      set key 28 to cuST_HELP
      restscreen(4,25,23,76,xf)
      release xf
      retu

* next function is used extensievely in
* edit_gro and Group file
* look with care
*---------------------------------------------------
function __funcr
param dfg,klm
   kes=lastkey()
  do case
  case kes>=32
      foo=foo+upper(chr(kes))
  case kes=27
   Retu 0
  case kes=13
      keyboard DLR_code
      return 0

  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,35 say space(34)
      @ 22,35 say foo
        set softseek on
            seek foo
        set softseek off 
 keyb chr(0)    
return 2
