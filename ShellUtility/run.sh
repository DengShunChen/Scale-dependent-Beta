#!/bin/bash

if [ $# = 1 ] ; then 
  nohup matlab -nodisplay -nosplash -r $1 > log.txt &
else
  nohup matlab -nodisplay -nosplash -r L05_run > log.txt & 
fi
