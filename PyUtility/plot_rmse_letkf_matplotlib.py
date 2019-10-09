#!/usr/bin/env python
import json
import numpy as np
import matplotlib.pyplot as plt
from scipy import interpolate

with open('rmse_letkf.json', 'r') as f:
    data = json.load(f)

print(type(data))
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
x = np.asarray([1.0, 1.01, 1.03, 1.05, 1.07, 1.09, 1.11, 1.13, 1.15, 1.17, 1.19])
y = np.arange(5,40.1,5)

f = interpolate.interp2d(x, y, v, kind='cubic')

xx = np.arange(1.0,1.191,0.01)
yy = np.arange(5,40.1,0.5)

X, Y = np.meshgrid(xx, yy)
Z = f(xx,yy)
#print(type(Z),type(X),type(Y))

fig, ax = plt.subplots()
SD = ax.contourf(X, Y, Z, 100, zorder=0, cmap='jet')
plt.colorbar(SD)
CS = ax.contour(X, Y, Z, 20, colors='black', zorder=1)
ax.clabel(CS, inline=1, fontsize=7 )
ax.set_title('RMS Error of LETKF')

plt.xlabel(r'Inflation Factor ($\rho$)')
plt.ylabel('Localization')
plt.savefig('rmse_letkf.png')
plt.show()
