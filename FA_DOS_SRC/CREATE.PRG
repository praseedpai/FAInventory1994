use data\journal

for i=4 to 12
 if i<=9
    fir="data\"+"jG"+'0'+str(i,1)+'94'
  else
   fir="data\"+"jg"+str(i,2)+'94'
 endif
  sele 1
    copy structure to &fir
  sele 2  
    use &fir
    index on j_id to &fir
 next i     
  