
*--
Sele 1
Use stock\dealer 
Sele 2
Use data\sgroup 
Sele 3
Use data\bal_ledg 

xt=33001
sele 1
 Go top
  Do while !Eof()
    Sele 2
    append blank 
    Replace s_code with str(xt,5)
    replace s_desc with left(A->dlr_name,34)
    sele 3
      append blank
      Replace Is_code with str(xt,5)
      replace month00 with 0
      sele 1
      skip
      xt=xt+1 
    Enddo 
   