function [dt_var,timed]=compute_dt(var,time)
%
% function [d_varK,timed]=compute_disk(varK,time)
%
% Calculates the change of var in time
% works on data with dimensions lev x lat x lon x time (will be incorrect if time is not the last dimension)
% 
n1=size(var,1);n2=size(var,2);n3=size(var,3);n4=size(var,4);

var=reshape(var,[n1*n2*n3 n4]);
dt_var=var(:,3:end)-var(:,1:end-2);
timed=time(2:end-1);

dt_var=reshape(dt_var,[n1 n2 n3 n4-2]);
endfunction
