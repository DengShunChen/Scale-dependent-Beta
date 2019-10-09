#!/usr/bin/env python
from evaluate import Evaluate 

if __name__ == '__main__':
  ev = Evaluate(timesteps=5000)

  ## get truth
  exp = './'
  filename = exp + '/output_truth.txt'
  print(filename)
  truth = ev.get_data(filename)
  
  data={}
  ## get hybrid 
  explist=['3dvar','letkfi19l10m10','h3dctl','sdbc27r06w01l20m10','h3dfull']
  explist=['h3dctl','sdbc27r06w01l20m10','h3dfull']
  #explist=['3dvar','3dvar_oldmin'] 
  for exp in explist:
    if exp[0:5] == 'letkf':
      filename = exp + '/output_analy_ens.txt'
      print(filename)
      data[exp]=ev.get_ens_data(filename)
    else:
      filename = exp + '/output_analy.txt'
      print(filename)
      data[exp]=ev.get_data(filename)

  # labels
  labels=['true']
  args=[truth]
  for key, value in data.items():
    labels.append(key)
    args.append(value)

  labels=['true','h3dctl','h3dsdb','h3dfull']    
#  print('file  :',filename)
#  print('truth : ',truth.shape,' analysis ',analy.shape)
  filename = 'RMSE_basic.png'
  ev.show(*args,labels=labels,filename=filename)

