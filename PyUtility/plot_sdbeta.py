#!/usr/bin/env python 
import math
import numpy as np
import matplotlib.pyplot as plt

def sdbeta(center,radius):
  '''
  Generate scale-dependent beta

  the gaussian-like distribution cutting edge was defined 
  by giving center and wide 

  '''

  beta2_inv = 1 - beta1_inv

  # define beta2_inv tail can not only be zero
  #beta2_tail = 0.125;
  beta2_tail = 0.0
 
  wgt = np.ones(dim)
  #- Gaussian Distribution -------------------------------
  for i in range(1,dim+1):
    wgt[i-1] = math.exp((-(i-center)**2)/(2*(radius**2)))

  wgt[0:center-1] = 1.

  if (beta2_tail > beta2_inv):
    beta2_tail = beta2_inv

  width = abs(beta1_inv - beta2_inv)+(beta1_inv - beta2_tail)
  shift = abs(beta2_inv - width)

  wgt = abs(width) * wgt + shift

  sdb_beta2 = wgt
  sdb_beta1 = 1 - sdb_beta2 

  return sdb_beta1, sdb_beta2

def plot_fig(data):
  fig, ax = plt.subplots()
  x = range(1,dim+1)
  for beta in data: 
    ax.plot(x,beta['sdb_beta2'],label='center/wide=%2.2d/%2.2d' % (beta['center'],beta['radius']))
  ax.set_title('Scale-dependent Weights')
  ax.legend()

  plt.xscale('log')
  plt.xlabel('Wave numbers')
  plt.ylabel('Ensemble weights')

  plt.savefig('sdbeta.png')
  plt.show()

def show(modelresolution,beta1_inv):
  global dim 
  dim = int(modelresolution/2)+1

  centerlist = [12]
  radiuslist = np.linspace(1,20,20).tolist()

  centerlist = [12,24,27,32]
  radiuslist = [15,1,6,5]


  print(centerlist)
  print(radiuslist)
  if len(centerlist) != len(radiuslist):        
    data = []
    for center in centerlist:
      for radius in radiuslist:
        beta = {}
        sdb_beta1, sdb_beta2 = sdbeta(center,radius)

        beta['sdb_beta2'] = sdb_beta2
        beta['center'] = center
        beta['radius'] = radius
        data.append(beta)
  else:
    data = []
    for center,radius in zip(centerlist,radiuslist):
      beta = {}
      sdb_beta1, sdb_beta2 = sdbeta(center,radius)

      beta['sdb_beta2'] = sdb_beta2
      beta['center'] = center
      beta['radius'] = radius
      data.append(beta)

  plot_fig(data)

if __name__ == '__main__':
  modelresolution, beta1_inv = 960, 0.1
  show(modelresolution,beta1_inv)
