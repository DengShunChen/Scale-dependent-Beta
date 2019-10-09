
 clc; 
 clear all;

% Create a parallel pool
 poolobj = parpool('IdleTimeout',200)

% loading namelist
 L05_namelist

% open/delete files 
 L05_init

% Cycling 
 L05_cycle

% close files
 L05_final

% shutting down parallel pool
 delete(poolobj)

% plot ?

