#!/usr/bin/env python
from evaluate import Evaluate 

if __name__ == '__main__':
  ev = Evaluate(timesteps=2000)

  exp = './'
  filename = exp + '/output_truth.txt'
  truth = ev.get_data(filename)

  filename = exp + '/output_bckgd.txt'
  analy = ev.get_data(filename)

#  print('file  :',filename)
#  print('truth : ',truth.shape,' analysis ',analy.shape)
  ev.plot_state(truth,analy)

