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
    rms = (df ** 2.).mean(axis=0) ** 0.5  
    am  = df.abs().mean(axis=0)
    return rms, am

  def errors(self,df1,df2):
    rms, am = self.errors1d(df1,df2)
    rms = rms.mean()
    am = am.mean()
    return rms, am

  def plot_state(self, df_t, *args, **kwargs):
   
    fig = plt.figure(figsize=(8,10))
    ax1 = plt.subplot2grid((3,1),(2,0))
    ax2 = plt.subplot2grid((3,1),(0,0), rowspan=2, projection='polar')

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

    ax2.set_title('Lorenz Model')

    def init():
      ax1.set_xlim(1,self.timesteps)
      ax1.set_ylim(0,1.5)
      for line1 in lines1:
        line1.set_data([],[])

      ax2.set_ylim(-25,20)
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
      maxrmse=0.5
      for i,df in enumerate(args):
        dff = df - df_t

        xdata = np.arange(1,self.timesteps+1)
        ydata = np.linspace(1,1,num=self.timesteps)

        rmseglb[i][iframe] = rmse(dff.iloc[iframe,0:])
        ydata = rmseglb[i]

        if max(rmseglb[i]) > maxrmse:
          maxrmse=max(rmseglb[i])
        ax1.set_ylim([0,maxrmse])
 
        xlist1.append(xdata)
        ylist1.append(ydata)    

        xdata = np.linspace(0,2.*np.pi, num=self.modelgrids)
        ydata = df.iloc[iframe,0:].values 
        
        xlist2.append(xdata)
        ylist2.append(ydata)    

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
    myAnimation.save('ChaoticModel2.mp4')
    
    plt.show()
    return myAnimation

  def show(self,df1,df2):
    x = np.arange(1, self.modelgrids+1, 1)

    df = df1 - df2
    mean,std = self._statistics(df)
    mean1,std1 = self._statistics(df1)
    mean2,std2 = self._statistics(df2)
 
    rms, am = self.errors1d(df1,df2)

    fig1, (ax1, ax2) = plt.subplots(2, 1)
    fig1.suptitle('time mean of model state', fontsize=14, fontweight='bold')
    fig1.subplots_adjust(hspace=0.5)
    ax1.plot(x,mean1,x,mean2) 
    ax2.plot(x,std1,x,std2)
    ax1.set_title('mean')
    ax2.set_title('standard deviation')
    ax1.set_xlim(1,self.modelgrids)
    ax2.set_xlim(1,self.modelgrids)
  
    fig2, (ax1, ax2) = plt.subplots(2, 1)
    fig2.suptitle('time mean of model state difference', fontsize=14, fontweight='bold')
    fig2.subplots_adjust(hspace=0.5)
    ax1.plot(x,mean) 
    ax2.plot(x,std)
    ax1.set_title('mean')
    ax2.set_title('standard deviation')
    ax1.set_xlim(1,self.modelgrids)
    ax2.set_xlim(1,self.modelgrids)
 
    fig3, (ax1, ax2) = plt.subplots(2, 1)
    fig3.suptitle('time mean of errors', fontsize=14, fontweight='bold')
    fig3.subplots_adjust(hspace=0.5)
    ax1.plot(x,rms) 
    ax2.plot(x,am)
    ax1.set_title('RMS')
    ax2.set_title('AM')
    ax1.set_xlim(1,self.modelgrids)
    ax2.set_xlim(1,self.modelgrids)
 
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



