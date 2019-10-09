#/bin/bash

path1=/home/water/work/Lorenz05/ToolGenIC2/
path2=

filelist=`ls *.m `
echo $filelist

for file in $filelist ;  do
   if [ -s $path2/$file  ] ;  then
    echo "file --> $file"
    diff $path1/$file $path2/$file

   fi












done
