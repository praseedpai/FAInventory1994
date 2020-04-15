
*------- Program to Recalculate Stock

PARAM _why

set Deleted on


Do Case
   Case  (  _why == "1" )
     Sele 1
     Use stock\Rstocktr  index stock\rst1
     SELE 2
     Use stock\rstock   index stock\rstock
     sele 3
     Use  stock\Rsub index stock\rsub

   Case ( _why == "2"  )

     Select 1
      Use stock\Cstocktr index stock\Cst1
     Select 2
      Use stock\Cstock index stock\Cstock
    SELE 3
      USE STOCK\csub INDEX STOCK\Csub

   EndCase






 *------- Move to the Top

 Go top

 *-------- iterate to the end of the life

 Do While !Eof()


   
   Temp_code = Code     && Assign the Code to temporary


   *------- Lookup in Stock file

   Sele 1
   Seek Temp_code


   Temp = 0

   Do While tcode == Temp_code .and. !eof()

       IF ( TIND == "R"  )

            Temp = Temp + tqty

       ELSEIF ( TIND == "I" ) 
            
            Temp = Temp - tqty

       
       Endif 
 

       Skip
   Enddo 
    


   Sele 2
   Seek Temp_code

   if ( Found() )

        Replace Rqty with Temp 
   endif

   Sele 3
   Skip

  Enddo

  Close All
  return



  






 






















