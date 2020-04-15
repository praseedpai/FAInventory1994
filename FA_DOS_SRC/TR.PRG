*---------------- Program To TransFer Stock From Previous
*------------------ Financial Year

Sele 1	

Use C:\Simi\stock\stock  index C:\simi\stock\stock


Sele 2

Use stock\stock  index stock\stock




Sele 1
go top
do While !Eof()
    X= It_code
     Sele B
     Seek X
        IF Found()
               Replace it_qty With B->it_qty + A->it_qty
        Endif
           Sele A
            Skip
    Enddo
  Close All
  Clear All
  Quit
  
                 



