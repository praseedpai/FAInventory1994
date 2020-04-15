Proc CUST_HELP
 private fil[2]
 set key 27 to
 fil[1]=" dLR_CODE"
 fil[2]=" dLR_NAME"
 private samp[2]
 samp[1]=" CODE "
 samp[2]= "          NAME            "
 xf=savescreen(4,34,23,71)
 set key 28 to
    rer=select()
    sele 5
   msav=setcolor("/w+,w+/n")
    @ 4,34 to 21,71 double
    go top
    public foo
    foo=""
    dbedit(5,35,20,70,fil,"__Funcr","",samp)
     setcolor(msav)
     select(rer)
      set key 27 to Esc_proc
      set key 28 to code_h
      restscreen(4,34,23,71,xf)
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
  case kes=27
   Retu 0
  case kes=13
      keyboard DLR_code
      return 0
  case ispchar(chr(kes))
       foo=foo+chr(kes)
  case kes==8
       foo=substr(foo,1,len(foo)-1)
   otherwise
      retu 1
   endcase

      @ 22,35 say space(34)
      @ 22,35 say foo
       df=recno()
    locate for upper( substr( DLR_NAME, 1 , len(foo) ) )=upper(foo)
      if !found()
         goto df
      endif
    return 1
