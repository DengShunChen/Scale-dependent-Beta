#!/usr/bin/env python
from evaluate import Evaluate 
import numpy as np
import json

gen_data=False
plot_fig=True

basename='rmse'
jsonfile=basename+'.json'
print('gen_data/plot_fig/filename = ',gen_data,plot_fig,basename)

mem_list=[6, 10]
loc_list=np.arange(5,60,5).tolist()
wgt_list=np.arange(0,10,1).tolist()
 
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
        filename='h3dw%2.2dl%2.2dm%2.2d/output_analy.txt' % (wgt,loc,mem)
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
  
    x = np.arange(0,0.91,0.1)
    y = np.arange(5,55.1,5)
    #print(x,y)
    f = interpolate.interp2d(x, y, v, kind='cubic')
  
    xx = np.arange(0,0.91,0.05)
    yy = np.arange(5,55.1,1)
    #print(xx,yy)
    xx = x
    yy = y

    X, Y = np.meshgrid(xx, yy)

    Z = f(xx,yy)
    #Z = v
    #print(type(Z),type(X),type(Y))
    
    fig, ax = plt.subplots()
    SD = ax.contourf(X, Y, Z, 100, zorder=0, cmap='jet')
    plt.colorbar(SD)
    CS = ax.contour(X, Y, Z, 20, colors='black', zorder=1)
    ax.clabel(CS, inline=1, fontsize=7 )
    ax.set_title('RMSE of Hybrid 3DEnVar(Ens. Size=%d)' % (mem))
  
    plt.xlabel('Hybrid Weights')
    plt.ylabel('Localization')

    outfile = basename+'_m%2.2d' % (mem)
    pdffile = outfile+'.pdf'
    pngfile = outfile+'.png'
    plt.savefig(pngfile)
    plt.savefig(pdffile)
  plt.show()


