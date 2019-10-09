#!/usr/bin/env python
import matplotlib
matplotlib.use("Agg")
import re
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from scipy import interpolate

class Evaluate():
  def __init__(self,modelgrids=960,timesteps=5000):
    self.modelgrids = modelgrids
    self.timesteps = timesteps
    
  def _cut_text(self,text,lenth):
    textArr = re.findall('.{' + str(lenth) + '}', text)
    textArr.append(text[(len(textArr) * lenth):])
    return textArr

  def get_data(self,filename):
    with open(filename,'r') as f:
      text = f.readlines()
    data = self._cut_text(text[0],10)
    del data[-1]
    df = pd.DataFrame(data)
    df = df.astype(float)
    df = pd.DataFrame(np.resize(df.values, (self.timesteps, self.modelgrids)))
    return df

  def get_spread(self,filename):
    with open(filename,'r') as f:
      text = f.readlines()
    data = self._cut_text(text[0],10)
    del data[-1]
    df = pd.DataFrame(data)
    df = df.astype(float)
    return df
    
  def get_ens_data(self,filename,reduce_factor=4,ensemblesize=10):
    with open(filename,'r') as f:
      text = f.readlines()
    data = self._cut_text(text[0],10)  
    del data[-1]
    df = pd.DataFrame(data)
    df = df.astype(float)
    data = np.resize(df.values, (self.timesteps, ensemblesize, int(self.modelgrids/reduce_factor)))
#   print(data[0,:,:].shape)
#   print(data[:,:,:].mean(axis=1).shape)
#   print(data[:,:,:].std(axis=1).shape)
    mean = data.mean(axis=1)

    y = np.arange(1,self.timesteps+0.01,1)
    x = np.arange(1,self.modelgrids+0.01,reduce_factor)
    f = interpolate.interp2d(x, y, mean)
    yy= np.arange(1,self.timesteps+0.01,1)
    xx= np.arange(1,self.modelgrids+0.01,1)
    
    data = f(xx,yy)
#   print(data.shape)   
 
    df = pd.DataFrame(data)
    print("reduce_factor=",reduce_factor)
    print("ensemblesize=",ensemblesize)
    return df

  def _statistics(self,df):
    mean=df.mean(axis=0).values
    std =df.std(axis=0).values
    return mean,std

  def errors1d(self,df1,df2):
    df = df1 - df2
    rms = (df ** 2.).mean(axis=1) ** 0.5  
    am  = df.abs().mean(axis=1)
    return rms, am

  def errors(self,df1,df2):
    rms, am = self.errors1d(df1,df2)
    rms = rms[500:].mean()
    am = am[500:].mean()
    return rms, am

  def plot_state(self, df_t, *args, **kwargs):
   
    fig = plt.figure(figsize=(8,10))
    ax1 = plt.subplot2grid((3,1),(2,0))
    #ax2 = plt.subplot2grid((3,1),(0,0), rowspan=2, projection='polar')
    ax2 = plt.subplot2grid((3,1),(0,0), rowspan=2, polar=True)

    labels =  ['Truth','Analysis','Analysis2','Analysis3']
    if 'labels' in kwargs:
      labels = kwargs['labels']
    plotcols = ["black","red","green","purple","brown","orange","pink","gray",(0.2,0.3,0.4),(0.4,0.5,0.6)]
    plotlays = [len(args)+1]

    lines1 = [ax1.plot([], [], color=plotcols[i+1], label = 'line {}'.format(i))[0] for i in range(len(args))]
    texts1 = [ax1.text(0.0, 0.98-i*0.03,'',color=plotcols[i],fontsize=10,transform=ax1.transAxes) for i in range(plotlays[0])]
    lines2 = [ax2.plot([], [], color=plotcols[i], label = 'line {}'.format(i))[0] for i in range(plotlays[0])]
    texts2 = [ax2.text(0.05, 0.95-i*0.03,'',color=plotcols[i],fontsize=10,transform=ax2.transAxes,horizontalalignment='right',) for i in range(plotlays[0])]

    rmseglb = {}
    for i in range(plotlays[0]):
      rmseglb[i] = np.linspace(1,1,num=self.timesteps)
      rmseglb[i][:] = np.nan
    
    ax1.set_title('RMS Errors')
    ax1.set_ylabel('Values')
    ax1.set_xlabel('Time Steps')
    ax1.grid(color='k', linestyle=':')
    ax1.set_xlim(1,self.timesteps)
    ax1.set_ylim(0,1.5)

    ax2.set_title('Lorenz Model')
    ax2.set_theta_zero_location('N')
    ax2.set_theta_direction(-1)
    ax2.set_rlim([-20,20])

    def init():
      for line1 in lines1:
        line1.set_data([],[])

      for line2 in lines2:
        line2.set_data([],[])

      return lines2 + lines1

    def update(iframe):

      def rmse(df):
        rms = (df ** 2.).mean(axis=0) ** 0.5
        return rms      
      
      xdata = np.linspace(0,2.*np.pi, num=self.modelgrids)
      ydata = df_t.iloc[iframe,0:].values 
      xlist1 = []
      ylist1 = []
      xlist2 = [xdata]
      ylist2 = [ydata]
      maxrmse=1.0
      for i,df in enumerate(args):
        dff = df - df_t

        # lines1
        xdata = np.arange(1,self.timesteps+1)
        rmseglb[i][iframe] = rmse(dff.iloc[iframe,0:])
        ydata = rmseglb[i]
        xlist1.append(xdata)
        ylist1.append(ydata)    

        if max(rmseglb[i][100:]) > maxrmse :
          maxrmse=max(rmseglb[i])
        ax1.set_ylim([0,maxrmse])

        # lines2
        xdata = np.linspace(0,2.*np.pi, num=self.modelgrids)
        ydata = df.iloc[iframe,0:].values         
        xlist2.append(xdata)
        ylist2.append(ydata)    

      # setup data
      for iline in range(len(args)):
        lines1[iline].set_data(xlist1[iline], ylist1[iline])    
      for iline in range(plotlays[0]):
        lines2[iline].set_data(xlist2[iline], ylist2[iline])    
        texts2[iline].set_text('%8s, t=%d' % (labels[iline],iframe+1))

      return lines2 + texts2 + lines1 + texts1

    # create animation using the animate() function
    myAnimation = animation.FuncAnimation(fig, update, frames=self.timesteps, \
                            init_func=init, interval=20, blit=False, repeat=False)

    plt.tight_layout() 
    myAnimation.save('ChaoticModel.mp4')
    
    plt.show()
    return myAnimation

  def show(self, df_t, *args, **kwargs):
    if 'labels' in kwargs:
      labels = kwargs['labels']
    if 'filename' in kwargs:
      savefig = True
      figname = kwargs['filename']
    else:
      savefig = False

    meant,stdt = self._statistics(df_t)
      
    fig1, (ax11, ax12) = plt.subplots(2, 1)
    fig1.suptitle('Time averaged model state', fontsize=14, fontweight='bold')
    fig1.subplots_adjust(hspace=0.5)
    ax11.set_title('Mean')
    ax12.set_title('Standard deviation')
    ax11.set_xlim(1,self.modelgrids)
    ax12.set_xlim(1,self.modelgrids)
    ax11.set_xlabel('Model grids')
    ax12.set_xlabel('Model grids')
 
    fig2, (ax21, ax22) = plt.subplots(2, 1)
    fig2.suptitle('Time averaged  model state difference', fontsize=14, fontweight='bold')
    fig2.subplots_adjust(hspace=0.5)
    ax21.set_title('Mean')
    ax22.set_title('Standard deviation')
    ax21.set_xlim(1,self.modelgrids)
    ax22.set_xlim(1,self.modelgrids)
    ax21.axhline(linewidth=1, color='k')
#   ax22.axhline(linewidth=1, color='k')
    ax21.set_xlabel('Model grids')
    ax22.set_xlabel('Model grids')

    fig3, (ax31, ax32) = plt.subplots(2, 1, sharex=True)
#    fig3.suptitle('Time series of errors', fontsize=14, fontweight='bold')
    fig3.subplots_adjust(hspace=0.5)
    ax31.set_title('Root Mean Square Error')
    ax32.set_title('Absolute Mean Error')
#   ax31.axhline(linewidth=1, color='k')
#   ax32.axhline(linewidth=1, color='k')
    ax31.set_xlabel('Time steps')
    ax32.set_xlabel('Time steps')

    # plot truth
    x = np.arange(1, self.modelgrids+1, 1)
    ax11.plot(x,meant,label='Truth %6.3f' % (np.mean(meant)), color='k') 
    ax12.plot(x,stdt,label='Truth %6.3f' % (np.mean(stdt)), color='k')
   
    # time series start at 
    startat=500

    # plot experiments
    for i,df in enumerate(args):
      dff = df - df_t

      mean,std = self._statistics(df)
      meand,stdd = self._statistics(dff)
 
      rms, am = self.errors1d(df_t,df)
      mrms = rms[startat:].mean()
      mam = am[startat:].mean()

      x = np.arange(1, self.modelgrids+1, 1)
      ax11.plot(x,mean,label=labels[i+1]+' %6.3f' % (np.mean(mean))) 
      ax12.plot(x,std,label=labels[i+1] +' %6.3f' % (np.mean(std)))
  
      ax21.plot(x,meand,label=labels[i+1]+' %6.3f' % (np.mean(meand))) 
      ax22.plot(x,stdd,label=labels[i+1] +' %6.3f' % (np.mean(stdd)))
 
      x = np.arange(1, len(rms)+1, 1)
      ax31.plot(x,rms,label=labels[i+1]+' %6.3f' % (mrms)) 
      x = np.arange(1, len(am)+1, 1)
      ax32.plot(x,am,label=labels[i+1] +' %6.3f' % (mam))
  
    ax31.set_xlim(startat+1,self.timesteps)
    ax32.set_xlim(startat+1,self.timesteps)
    ax31.set_ylim(min(rms[startat:]-0.1),max(rms[startat:])+0.1)
    ax32.set_ylim(min(am[startat:]-0.1),max(am[startat:])+0.1)

    # activate legend 
    ax11.legend()    
    ax12.legend()    
    ax21.legend()    
    ax22.legend()    
    ax31.legend()    
    ax32.legend()    

    if savefig:
      plt.savefig(figname)

    plt.tight_layout()
    plt.show()

if __name__ == '__main__':

  ev = Evaluate(timesteps=2000)

  exp = './'
  filename = exp + '/output_truth.txt'
  truth = ev.get_data(filename)

  filename = exp + '/output_bckgdPerf.txt'
  back1 = ev.get_data(filename)
  filename = exp + '/output_bckgdPure.txt'
  back2 = ev.get_data(filename)
  filename = exp + '/output_bckgdImperf.txt'
  back3 = ev.get_data(filename)

#  print('file  :',filename)
#  print('truth : ',truth.shape,' analysis ',analy.shape)
  ev.plot_state(truth,back1,back2,back3,labels=['Truth','Perturbed','Forcing=14','Both'])
  #ev.plot_state(truth,back1,back2,back3)



