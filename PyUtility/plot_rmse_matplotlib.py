#!/usr/bin/env python
import json
import numpy as np
import matplotlib.pyplot as plt
from scipy import interpolate

filename='rmse.json'
with open(filename, 'r') as f:
    data = json.load(f)

#print(type(data))
x=[]
y=[]
v=[]
error = data['rmse']   
#error = data['ame']
for mem in ['10']:
  for loc in error[mem].keys():
#    print('mem/loc',mem,loc,error[mem][loc])
    z = []
    for i,value in enumerate(error[mem][loc]):
      z.append(value)
    v.append(z)

mem = '10'
x = np.arange(0,0.91,0.1)
y = np.arange(5,55.1,5)
print(x,y)
f = interpolate.interp2d(x, y, v, kind='cubic')

xx = np.arange(0,0.91,0.01)
yy = np.arange(5,55.1,0.5)
print(xx,yy)
X, Y = np.meshgrid(xx, yy)
Z = f(xx,yy)
#print(type(Z),type(X),type(Y))


fig, ax = plt.subplots()
SD = ax.contourf(X, Y, Z, 100, zorder=0, cmap='jet')
plt.colorbar(SD)
CS = ax.contour(X, Y, Z, 20, colors='black', zorder=1)
ax.clabel(CS, inline=1, fontsize=7 )
ax.set_title('RMSE of Hybrid 3DEnVar')

plt.xlabel('Hybrid Weights')
plt.ylabel('Localization')
plt.savefig('rmse.png')
plt.savefig('rmse.pdf')
plt.show()
