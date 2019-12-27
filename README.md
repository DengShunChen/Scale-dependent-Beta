Scale-dependent-Beta
=========================
* scripts : main Matlab scripts
* GenIC : generate initial condition
* MatlabUtility : some tools with Matlab code
* PyUtility : some tools with Python code
* ShellUtility : some tools with korn or bash shell
* da_base : the storage of data assimilation system
* model_base : the srotage of model system
___
**4dvar is not completed!**
___

generate OSSE initial conditions, observations, and background error covariance
==========================
  
* configuration
```
cd GenIC/
vim L05_config.m
```

* first step - spin up from a constant value then add a perturbation at the center of model
```
L05_SpinUp.m
```

* second step - generate Truth and observations
```
matlab L05_GenTruthObs.m
```

* third step - generate background errors convariance
```
L05_genB.m
```

how to run?
==========================
```
cd scripts;
vim L05_namelist.m;
./run.sh;
```
data assimilation system
==========================
* 3DVAR
* Hybrid 3DEnVar
* SDB : Hybrid 3DEnVar Scale-dependent Beta
* SDL : Hybrid 3DEnVar Scale-dependent Localization
* MSDA: Multi-scale DA
* LETKF : Local ensemble transform kalman filter


