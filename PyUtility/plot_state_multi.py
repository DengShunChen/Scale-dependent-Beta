#!/usr/bin/env python
from evaluate import Evaluate 

if __name__ == '__main__':
  ev = Evaluate(timesteps=5000)

  exp = './'
  filename = exp + '/output_truth.txt'
  print(filename)
  truth = ev.get_data(filename)

  #explist=['h3dw01l15m10','h3dw01l20m10','h3dw01l25m10','h3dw01l30m10','h3dw05l30m10']
  explist=['h3dctl']
  
  data={}
  for exp in explist:
    filename = exp + '/output_analy.txt'
    print(filename)
    key=exp
    data[key]=ev.get_data(filename)

  # labels
  labels=['true']
  args=[truth]
  for key, value in data.items():
    labels.append(key)
    args.append(value)
    
#  print('file  :',filename)
#  print('truth : ',truth.shape,' analysis ',analy.shape)
  ev.plot_state(*args,labels=labels)

