rem echo "test %0" > debug.txt

echo off

  set Version=__versionKey__
  
echo on
rem echo "%1 %2 %3 %4" >> debug.txt

cd %~dp0\%Version%
rattleCAD.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
