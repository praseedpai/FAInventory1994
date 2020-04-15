use data\ledger

for i=4 to 12
 if i<=9
    fir='0'+str(i,1)+'94'
  else
   fir=str(i,2)+'94'
 endif
mir="data\"+"lg"+fir
mir1="data\"+"Alg"+fir
 mir2="data\"+"Blg"+fir
 mir3="data\"+"jlg"+fir
  sele 1
    copy structure to &mir
  sele 2
    use &mir
    index on dtoc(jdate)+ac_1 to &mir1
    index on dtoc(jdate)+ac_2 to &mir2
    index on jid to &mir3

 next i
  