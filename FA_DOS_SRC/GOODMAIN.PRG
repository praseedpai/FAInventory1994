 _Rs=savescreen( 5,2,20,38)
 Scroll(5,2,20,28,0)
 @ 5,2 to 20,30 double

  Do while .t.
  @ 7,3 prompt    " R. materials Group      "
  @ 8,3 prompt    " C & Bottles  Group      "
  @ 9,3 prompt    " End prod.    Group      "
  @ 10,3 prompt   " R. materials SubGroup   "
  @ 11,3 prompt   " C & Bottles  SubGroup   "
  @ 12,3 prompt   " End prod.    SubGroup   "
  @ 13,3 prompt   " R. materials Stock      "
  @ 14,3 prompt   " C & Bottles  Stock      "
  @ 15,3 prompt   " End product  Stock      "
  @ 16,3 prompt   "      Exit               "
  menu to ks
        IF ks==0
          Loop
        Elseif Ks==10
          Retu
        Endif
     save screen to mks
   Do Case
     Case ks==1
        Rs=menu11()
         if Rs==0
           loop
           Rst screen from mks
         Endif
         Do Heads with if(Rs=1,"A",if(Rs=2,"C","D")
