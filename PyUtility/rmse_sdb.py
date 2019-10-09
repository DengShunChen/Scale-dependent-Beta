#!/usr/bin/env python
from evaluate import Evaluate 
import numpy as np
import json

gen_data=False
plot_fig=True

basename='rmse_sdb'
jsonfile=basename+'.json'
print('gen_data/plot_fig/filename = ',gen_data,plot_fig,basename)

mem_list=[10]
#wgt_list=[12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40]
#loc_list=[1, 2, 3, 6, 8, 12, 14, 16, 18]
locend=20
wgtend=40
loc_list=np.arange(1,locend+0.1,1).tolist()
wgt_list=np.arange(12,wgtend+0.1,1).tolist()
 
if gen_data:
  ev = Evaluate()
  truth = ev.get_data('output_truth.txt')  
 
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
        filename='sdbc%2.2dr%2.2dw01l20m%2.2d/output_analy.txt' % (wgt,loc,mem)
        # analysis 
        analy = ev.get_data(filename)
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
  
  with open(jsonfile, 'w') as f:
      json.dump(error, f)

if plot_fig:
  import matplotlib.pyplot as plt
  from scipy import interpolate

  with open(jsonfile, 'r') as f:
      data = json.load(f)
  
  #print(type(data))
  error = data['rmse']
  #error = data['ame']
  for mem in mem_list:
    v=[]
    print('ensemble size=',mem)
    for loc in error[str(mem)].keys():
  #    print('mem/loc',mem,loc,error[mem][loc])
      z = []
      for i,value in enumerate(error[str(mem)][loc]):
        z.append(value)
      v.append(z)
  
    x = np.asarray(wgt_list)
    y = np.asarray(loc_list)
    #print(x,y)
    v[:] = [[vl - 0.487 for vl in e ] for e in v]
    f = interpolate.interp2d(x, y, v, kind='cubic')
  
    xx = np.arange(min(wgt_list),max(wgt_list)+0.1,0.5)
    yy = np.arange(min(loc_list),max(loc_list)+0.1,0.5)
    xx = x 
    yy = y
    #print(xx,yy)
    X, Y = np.meshgrid(xx, yy)
    Z = f(xx,yy)
    #print(type(Z),type(X),type(Y))
    vmax=np.max(Z)   
 
    fig, ax = plt.subplots()
    SD = ax.contourf(X, Y, Z, 100, zorder=0, cmap='seismic',vmax=vmax,vmin=-vmax)
    plt.colorbar(SD)
#   CS = ax.contour(X, Y, Z, 20, colors='black', zorder=1)
#   ax.clabel(CS, inline=1, fontsize=7 )
    ax.set_title('RMSE difference\n w/ - w/o SDB (Ens. Size=%d)' % (mem))
    
  
    plt.xlabel('Center')
    plt.ylabel('Radius')

    outfile = basename+'_m%2.2d' % (mem)
    pdffile = outfile+'.pdf'
    pngfile = outfile+'.png'
    plt.savefig(pngfile)
    plt.savefig(pdffile)
    plt.show()


