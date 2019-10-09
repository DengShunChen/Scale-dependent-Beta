#!/usr/bin/env python
from evaluate import Evaluate 
import numpy as np
import nolds

if __name__ == '__main__':
  ev = Evaluate()

  exp = './'
  filename = exp + 'output_truth.txt'
  truth = ev.get_data(filename)

  lyap=[]
  for data in truth.values.T:
    #print(len(t))
    lyapexpo = nolds.lyap_e(data,emb_dim=10, matrix_dim=2,debug_plot=True, debug_data=True, plot_file=None)
    lyap.append(lyapexpo)
    print(lyapexpo)
