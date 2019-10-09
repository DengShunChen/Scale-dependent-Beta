#!/usr/bin/env python
from evaluate import Evaluate 

if __name__ == '__main__':
  ev = Evaluate(timesteps=2000)

  exp = './'
  filename = exp + '/output_truth.txt'
  truth = ev.get_data(filename)
  
  data={}
  for p in range(1,82,10):

    filename = 'out_chaotic_%d' % (p)
    print(filename)
    key='p=%3e' % ((p-41)/10000.)
    data[key]=ev.get_data(filename)

  labels=['true']
  args=[]
  for key, value in data.items():
    labels.append(key)
    args.append(value)
    
#  print('file  :',filename)
#  print('truth : ',truth.shape,' analysis ',analy.shape)
  ev.plot_state(truth,*args,labels=labels)

