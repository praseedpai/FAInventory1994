Param _why
setcursor off
rmd=sav
if _why=="1"
  do while inkey()==0 
   big_print(time(),5)
  endif
else
   big_print(dtoc(date()),5)
endif 

cs=left(_why,9)
set cursor off
set date italian
r=0
CLEAR
 Big_print(cs,0)
big_print(rs,8)
big_print(rs1,16)

do while (r==0)
 r=inkey()

enddo
set cursor on




Function Big_print
Param _woo,_Row
declare x[8]
_woo=Substr(_woo,1,9)

Curr=1
how=len(_woo)
For er=1 to how
   Samk=ASC(substr(_woo,er,1))*8
*       FOR I=0 TO 7
*          x[i+1]=ret_num(samk+i)
*       next i

       for i=0 to 7
            df=dectobin(ptret_num(samk+i))
       for j=1 to 8
               @ _row+i,(curr+j-1) say if(substr(df,j,1)=="1",chr(219)," ")
      next j
   next i
   Curr=Curr+8
next er
RETURN 0

function dectobin
param sd
sa=""
do while sd<>0

   sa=iif(mod(sd,2)==0,"0","1")+sa
   sd=int(sd/2)
enddo
return Repli("0",8-len(sa))+sa

