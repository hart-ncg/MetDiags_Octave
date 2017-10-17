function [roc,timed]=compute_dvar_dt_daily(var,time);
%
% 
% Computes rate of change of given variable in time
% by default leaving the dt as the timestep of the data
% i.e: dt_var/6hrs for ncep 4 x daily data
% var needs to have time set as last dimension
n1=size(var,1);n2=size(var,2);n3=size(var,3);n4=size(var,4);
% Compute timestep of data
timestep=time(2:end)-time(1:end-1);
% Compute change of variable in time
[dt_var,timed]=compute_dt(var,time);
% Averaged rate of change
roc=dt_var;
endfunction
