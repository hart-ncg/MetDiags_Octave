function [varn]=ncprepare(var,varstring);
%
% function [var]=ncprepare(var,varstring);
%
% prepares variable to write to netcdf

varn=reshape(var,[size(var,1)*size(var,2)*size(var,3)*size(var,4) 1]);

%load('-v6',['/home/neil',varstring,'ncprepare_vals.mat'])
offset=187.5;scalef=0.01;

%varn=var./scalef-offset;
i=find(isnan(varn));varn(i)=32766;
varn=reshape(varn,[size(var,1) size(var,2) size(var,3) size(var,4)]);

