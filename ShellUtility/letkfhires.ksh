#!/bin/ksh
set -x 

#--------------------------------------------------------------#
reduced_factor=1  # high resolution
system='LETKF'

# Hybrid
Bs_loc='20'                                     # decorrelation length of static B
hybw=0.1
wgt_list='10'                              # hybrid weights

#LETKF
rho=1.01
loc_list='5 10 15 20 25 30'    # localization 
mem_list='5 7 9 11 13 15 20 30'                                 # member size
#--------------------------------------------------------------#
home=$(pwd)
scripts="${home}/scripts"
template="${scripts}/L05_namelist_template.m"
matlab='/Applications/MATLAB_R2019a.app/bin/matlab'
echo "home : ${home}"
echo "template : ${template}"
#--------------------------------------------------------------#
# experiments loop
for m in ${mem_list} ; do           # ensemble size
  for l in ${loc_list} ; do         # localization 
    for w in ${wgt_list} ; do       # hybrid weights
      hybw=$(($w/10.))
      hybl=$l
      hybm=$m
      if [ ${hybw} -eq 1 ] ; then
        Bs_loc=${l}
      fi
      expname=`printf "letkfl%2.2dm%2.2d" $l $m`
      echo "expname : $expname"
      echo "hybw/hybl/hybm = ${hybw}, ${hybl}, ${hybm}"

      cd ${scripts}
      cat ${template} | sed "s/prefix.da.beta1_inv=\(.*\)/prefix.da.beta1_inv=${hybw};/g" | \
                        sed "s/prefix.ensemblesize=\(.*\)/prefix.ensemblesize=${hybm};/g" | \
                        sed "s/Bs_loc=\(.*\)/Bs_loc=${Bs_loc};/g" | \
                        sed "s/prefix.da.rho=\(.*\)/prefix.da.rho=${rho};/g" | \
                        sed "s/prefix.da.system=\(.*\)/prefix.da.system='${system}';/g" | \
                        sed "s/prefix.reduced_factor=\(.*\)/prefix.reduced_factor=${reduced_factor};/g" | \
                        sed "s/prefix.da.LR=\(.*\)/prefix.da.LR=${hybl};/g" > L05_namelist.m

#     if [ ${hybm} -ge 30 -a ${hybm} -lt 50 ] ; then
#        cat L05_namelist.m > tmp
#        cat tmp | sed "s/prefix.da.rho=\(.*\)/prefix.da.rho=1.02;/g" > L05_namelist.m 
#     elif [ ${hybm} -ge 50 ] ; then
#        cat L05_namelist.m > tmp
#        cat tmp | sed "s/prefix.da.rho=\(.*\)/prefix.da.rho=1.05;/g" > L05_namelist.m 
#     else
#        cat L05_namelist.m > tmp
#        cat tmp | sed "s/prefix.da.rho=\(.*\)/prefix.da.rho=1.01;/g" > L05_namelist.m  
#     fi 


      ${matlab} -nodisplay -nosplash -r L05_run > log.txt
      if [ $? == 0 ] ; then
        mkdir -p ${home}/${expname}
        cp ${scripts}/log.txt ${home}/${expname}/
        cp ${scripts}/output_analy_ens.txt ${home}/${expname}/
        cp ${scripts}/output_spd.txt ${home}/${expname}/
        cp ${scripts}/output_truth.txt ${home}/
      fi
    done 
  done
done
