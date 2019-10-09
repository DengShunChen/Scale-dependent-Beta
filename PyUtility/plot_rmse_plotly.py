#!/usr/bin/env python
import json
import numpy as np
import plotly.plotly as py
import plotly.graph_objs as go

with open('rmse.json', 'r') as f:
    data = json.load(f)


x=[]
y=[]
z=[]
v=[]
error = data['rmse']   
#error = data['ame']
for mem in error.keys():
  for loc in error[mem].keys():
    print('mem/loc',mem,loc,error[mem][loc])
    for i,value in enumerate(error[mem][loc]):
      x.append(i/10)
      y.append(loc)
      z.append(mem)
      v.append(value)

x = np.asarray(x)
y = np.asarray(y)
z = np.asarray(z)
v = np.asarray(v)
print(x.shape,y.shape,z.shape)  
trace1 = go.Scatter3d(
    x=x,
    y=y,
    z=z,
    text=v,
    mode='markers',
    marker=dict(
        size=8,
        color=v,                # set color to an array/list of desired values
        colorscale='Earth',   # choose a colorscale
        colorbar = dict(title = 'RMS Error'),
        opacity=0.8
    )
)

data = [trace1]
layout = go.Layout(
    margin=dict(
        l=0,
        r=0,
        b=0,
        t=0
    ),
    scene = dict(
      xaxis = dict(title='Hybrid Weights'),
      yaxis = dict(title='Localization'),
      zaxis = dict(title='Ensemble Size')
    )
)
fig = go.Figure(data=data, layout=layout)
py.plot(fig, filename='3d-scatter-colorscale') 


