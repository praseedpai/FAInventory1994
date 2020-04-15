PARAM HMODE
 Sele 1
   Use stock\Stock inde stock\stock
 Sele  2
   Use stock\E_subhea index stock\E_subhea
Sele 3
   Use stock\Estocktr index stock\EstockTr

    store 0 to msstock
scroll(13,10,20,60,0)
@ 13,10 to 20,60

set color to /w+
@ 13,26 say  ' STOCK '+iif(hmode=='A','ADDITION   ','DELETION  ')
set color to w+
@ 13,43 say 'Ã'
@ 13,25 say  '´'
*--------------------------------------
@ 15,16 Say 'Item Code  :'
@ 17,16 Say 'Quantity   :'
@ 19,16 say 'Descreption:'
STORE SPACE(8) TO MSCODE
store space(50) to msdesc
Set key 27 to esc_proc
 set colo to w+/n+,n/w,,,w+/n+
begin sequence
DO WHILE .T.
set key 28 to hstkcode
@ 15,35 GET MSCODE PICT '@!'
 READ
 set key 28 to
sele 2
seek mscode
IF !FOUND()
  err_msg(" invalid code ")
  LOOP
ENDIF
msstock=0
   @ 17,35 get msstock PICT '999999999999' VALID MSSTOCK >0
   read

          if hmode="D"
               SELE 1
               SEEK MSCODE
              IF it_qty < MSSTOCK

                 Err_msg( " Sufficient stock is not available ")
                keyb chr(13)
               loop
            endif
         endif
   @ 19,35 get msdesc pict "@S20!"
   Read

 If  chr(Err_msg("Confirm(y/n)"))$"Yy"
if hmode$"Aa"
 sele 1
  SEEK MSCODE
replace it_qty with it_qty+msstock
Sele 3
append blank
  Replace Tdate with Date(),Tdesc with msdesc,tqty with msstock,tind with "A",;
  Tcode with mscode
  sele 1


else
sele 1
SEEK MSCODE

replace it_qty with it_qty-msstock
Sele 3
append blank
  Replace Tdate with Date(),Tdesc with msdesc,tqty with msstock,tind with "D",;
  Tcode with mscode
  sele 1

endif
endif
enddo
End
SET KEY 27 TO
SET KEY 28 TO
release  msstock,mspack,mscode
close databases
return
*******************************************************************************
*-------------- FUNCTION FOR CODE HELP

    proc hstkcode
    Set key 27 to
    private fil[2],samp[2]
     fil[1]="S_code"
     fil[2]="S_desc"
     samp[1]=" code  "
     samp[2]="  description  "
      xf=savescreen(4,9,23,61)
      foo=""
       set key 28 to
       retj=select()
         sele 2
         msav=setcolor("/w+,w+/n")
          @ 4,9 to 21,61 double
           dbedit(5,10,20,60,fil,"muncr80","",samp)
            setcolor(msav)
      set key 27 to Esc_proc
      set key 28 to hstkcode
          restscreen(4,9,23,61,xf)
        select(retj)
         release xf

   *-----------------------------------------
   *----------------------function func_r
function muncr80
param dfg,klm
   kes=lastkey()
  do case

  case kes=13
     keyb S_Code
       return 0
  case kes=27
      return 0
  case isalpha(upper(chr(kes)))  .or. isdigit(chr(kes))
       foo=foo+chr(kes)
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,9 say space(52)
      @ 22,9 say foo
       df=recno()
    locate for upper( substr( s_code, 1 , len(foo) ) )=upper(foo)
      if !found()
         goto df
      endif

    return 1
