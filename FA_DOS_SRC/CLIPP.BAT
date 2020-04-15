clipper %1 
if not errorlevel 1 rtlink file %1,ctus.obj,proc.obj  library planet,ct  
pause
%1
