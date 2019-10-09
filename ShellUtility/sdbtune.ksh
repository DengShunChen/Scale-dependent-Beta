#!/bin/ksh
set -x 

datype='sdb'
rho=1.19
Bs_loc='15'                 # decorrelation length of static B
#--------------------------------------------------------------#
loc_list='20'                                             # localization 
wgt_list='1'                                              # hybrid weights
mem_list='10'                                             # member size
sdbc_list='12 14 16 18 20 22 24 26 28 30 32 34 36 38 40'                    # sdb center 
sdbr_list='1 2 3 4 6 8 10 12 14 16 18 20 22 24'           # sdb radius e
sdbc_list={12..40}                                        # sdb center 
sdbr_list={1..20}                                         # sdb radius e
#--------------------------------------------------------------#
home=$(pwd)
scripts="${home}/scripts"
template="${scripts}/L05_namelist_template.m"
sdbtemplate="${scripts}/GenSDBeta_template.m"
matlab='/Applications/MATLAB_R2019a.app/bin/matlab'
echo "home : ${home}"
echo "template : ${template}"
#--------------------------------------------------------------#
# experiments loop
for m in ${mem_list} ; do           # ensemble size
for l in ${loc_list} ; do         # localization 
for w in ${wgt_list} ; do       # hybrid weights
for sdbc in ${sdbc_list} ; do       # hybrid weights
for sdbr in ${sdbr_list} ; do       # hybrid weights
      hybw=$(($w/10.))
      hybl=$l
      hybm=$m
      if [ ${hybw} -eq 1 ] ; then
        Bs_loc=${l}
      fi
      expname=`printf "sdbc%2.2dr%2.2dw%2.2dl%2.2dm%2.2d" $sdbc $sdbr $w $l $m`
      echo "expname : $expname"
      echo "hybw/hybl/hybm = ${hybw}, ${hybl}, ${hybm}"

      cd ${scripts}
      cat ${template} | sed "s/prefix.da.beta1_inv=\(.*\)/prefix.da.beta1_inv=${hybw};/g" | \
                        sed "s/prefix.ensemblesize=\(.*\)/prefix.ensemblesize=${hybm};/g" | \
                        sed "s/prefix.da.type=\(.*\)/prefix.da.type='${datype}';/g" | \
                        sed "s/Bs_loc=\(.*\)/Bs_loc=${Bs_loc};/g" | \
                        sed "s/prefix.da.rho=\(.*\)/prefix.da.rho=${rho};/g" | \
                        sed "s/prefix.da.LR=\(.*\)/prefix.da.LR=${hybl};/g" > L05_namelist.m
      cat ${sdbtemplate} | sed "s/center=\(.*\)/center=${sdbc};/g" | \
                           sed "s/Radius=\(.*\)/Radius=${sdbr};/g" > GenSDBeta.m

      if [ ! -e ${home}/${expname} ] ; then
        ${matlab} -nodisplay -nosplash -r L05_run > log.txt
        if [ $? == 0 ] ; then
          mkdir -p ${home}/${expname}
          cp ${scripts}/log.txt ${home}/${expname}/
          cp ${scripts}/output_analy.txt ${home}/${expname}/
          cp ${scripts}/output_truth.txt ${home}/
        fi
      fi
done 
done
done
done
done
