#!/bin/ksh
#set -x 

home='/Users/dalab/Matlab_LorenzModel'
scripts="${home}/scripts"
template="${home}/L05_namelist_template.m"
matlab='/Applications/MATLAB_R2019a.app/bin/matlab'
echo "home : ${home}"
echo "template : ${template}"

# experiments loop
#for l in 5 10 15 20 25 30 35 40; do 
for m in 10 ; do          # ensemble size
  for l in 5 10 15 20 25 30 35 40 45  ; do        # localization 
    for w in {0..9} ; do  # hybrid weights

      hybw=$(($w/10.))
      hybl=$l
      hybm=$m

      name_old=`printf "h3dw%2.2dl%2.2d" $w $l`
      name_new=`printf "h3dw%2.2dl%2.2dm%2.2d" $w $l $m`
#      echo "old/new : ${name_old} ${name_new}"
#      echo "hybw/hybl/hybm = ${hybw}, ${hybl}, ${hybm}"    
      echo mv ${name_old} ${name_new}
       mv ${name_old} ${name_new}

    done 
  done
done
