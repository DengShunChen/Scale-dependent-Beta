#/bin/bash

path1=$1
path2=`pwd`

filelist=`ls *.m `
echo "path1 = $path1"
echo "path2 = $path2"
echo '=== Files ======================'
echo $filelist
echo '================================'
for file in $filelist ;  do
   if [ -s $path2/$file  ] ;  then
    echo "file --> $file"
    diff $path1/$file $path2/$file

   fi

done
