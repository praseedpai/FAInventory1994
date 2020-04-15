*---------------------Function to Backup Data to Hard DISK
function backall
Param _wool
set key 27 to
VMA=SAVESCREEN(10,10,16,40)
@ 10,10 TO 16,40
SET COLO TO G/B
@ 11,11 CLEA TO 15,39
SET COLO TO N/W
@ 13,16 SAY "  DON'T INTERRUPT  "
cur="\"+curdir()
 if (!isdir("\back"))
     dirmake("\back")
endif
Do Case
   Case _wool=="1"
 num=adir("data\*.*")
 declare  x[num]
 adir("data\*.*",x)
   Case _wool=="2"
 num=adir("stock\*.*")
 declare  x[num]
 adir("stock\*.*",x)

Endcase
 for i= 1 to  num
   copy file ("stock\"+x[i]) to ("\back\"+x[i])
 next i


CLOSE ALL
*-----------------------------------
SET COLO TO
RESTSCREEN(10,10,15,40,VMA)




retu 0
*---------------------------------------------
function isdir
param kd
cur=curdir()
if (dirchange(kd)==0)
    dirchange(cur)
   retu .t.
else
  retu .f.
endif



