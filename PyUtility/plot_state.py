#!/usr/bin/env python
from evaluate import Evaluate 

if __name__ == '__main__':
  ev = Evaluate()

  exp = './'
  filename = exp + '/output_truth.txt'
  truth = ev.get_data(filename)

  exp1 = '3dvarf12'
  filename = exp1 + '/output_analy.txt'
  analy1 = ev.get_data(filename)

  exp2 = 'h3dctlf12'
  filename = exp2 + '/output_analy.txt'
  analy2 = ev.get_data(filename)

  exp3 = 'letkff12'
  filename = exp3 + '/output_analy_ens.txt'
  analy3 = ev.get_ens_data(filename)
#  print('file  :',filename)
#  print('truth : ',truth.shape,' analysis ',analy.shape)
#  ev.plot_state(truth,analy)
  ev.plot_state(truth,analy1,analy2,analy3,labels=['Truth',exp1,exp2,'letkf'])

