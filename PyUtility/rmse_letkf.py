#!/usr/bin/env python
from evaluate import Evaluate 
import numpy as np
import json

ev = Evaluate()
truth = ev.get_data('output_truth.txt')

mem_list=[5, 10, 15, 20, 30]
loc_list=np.arange(5,60,5).tolist()
wgt_list=np.arange(0,10,1).tolist()

mem_list=[ 10]
#loc_list=[5, 10, 15, 20, 25, 30, 35, 40, 4]
loc_list=np.arange(5,40.1,5).tolist()
wgt_list=[0, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

error={}
rmsedata={}
amedata={}
for mem in mem_list:
  rmseloc={}
  ameloc={}
  for loc in loc_list:
    rmse=[]
    ame=[]
    for wgt in wgt_list:
      filename='letkfi%2.2dl%2.2dm%2.2d/output_analy_ens.txt' % (wgt,loc,mem)
      # analysis 
      analy = ev.get_ens_data(filename)
      # get errors
      rms, am = ev.errors(truth,analy)
      print('%s : RMS = %3.4f , AM = %3.4f' % (filename,rms,am))
      rmse.append(rms)
      ame.append(am)
    rmseloc[str(loc)] = rmse
    ameloc[str(loc)] = ame
  rmsedata[str(mem)] = rmseloc
  amedata[str(mem)] = ameloc
error['rmse'] = rmsedata
error['ame'] = amedata

with open('rmse_letkf.json', 'w') as f:
    json.dump(error, f)

