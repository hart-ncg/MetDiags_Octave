function [roc,roc_daily,timed,timed_daily]=compute_dvar_dt(var,time);
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
l=n4/4;
dt_var_daily=zeros(n1,n2,n3,l);timed_daily=zeros(l,1);
dt_var_daily(:,:,:,1)=mean(dt_var(:,:,:,1:4),4);timed_daily(1)=mean(timed(1:4));
for n=2:l-1
dt_var_daily(:,:,:,n)=mean(dt_var(:,:,:,4+(n-2)*4:8+(n-2)*4),4);timed_daily(n)=mean(timed(4+(n-2)*4:8+(n-2)*4));
endfor
dt_var_daily(:,:,:,end)=mean(dt_var(:,:,:,end-3:end),4);timed_daily(end)=mean(timed(end-3:end));

roc=dt_var;
roc_daily=dt_var_daily;
endfunction
