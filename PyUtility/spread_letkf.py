#!/usr/bin/env python
from evaluate import Evaluate 
import numpy as np
import json

ev = Evaluate()

mem_list=[5, 10, 15, 20, 30]
loc_list=np.arange(5,60,5).tolist()
wgt_list=np.arange(0,10,1).tolist()

mem_list=[ 10]
#loc_list=[5, 10, 15, 20, 25, 30, 35, 40, 4]
loc_list=np.arange(5,40.1,5).tolist()
wgt_list=[0, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

error={}
spdmdata={}
for mem in mem_list:
  spdmloc={}
  for loc in loc_list:
    spdm=[]
    for wgt in wgt_list:
      filename='letkfi%2.2dl%2.2dm%2.2d/output_spd.txt' % (wgt,loc,mem)
      # analysis 
      spread = ev.get_spread(filename)
      # get errors
      spd = spread.mean()
      print(spd.values)
      print('%s : RMS = %3.4f ' % (filename,spd.values))
      spdm.append(spd.values[0])
    spdmloc[str(loc)] = spdm
  spdmdata[str(mem)] = spdmloc
error['spd'] = spdmdata

with open('spd_letkf.json', 'w') as f:
    json.dump(error, f)

