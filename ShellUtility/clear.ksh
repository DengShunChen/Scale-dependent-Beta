#!/bin/ksh
#set -x 

home='/Users/dalab/Matlab_LorenzModel'
scripts="${home}/scripts"
template="${home}/L05_namelist_template.m"
matlab='/Applications/MATLAB_R2019a.app/bin/matlab'
echo "home : ${home}"
echo "template : ${template}"

files='output_bckgd.txt output_gsta.txt output_truth.txt output_bckgd_ens.txt  output_obsdata.txt output_xbinc.txt  output_analy_ens.txt  output_gens.txt       output_obsposi.txt    output_xeinc.txt'

folders=`ls -d h3dw*/`


for folder in ${folders} ; do 
   echo cd ${home}/${folder} ; rm -r ${files}
   cd ${home}/${folder} ; rm -r ${files}    
done
