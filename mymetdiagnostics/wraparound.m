function [lonnew,varnew]=wraparound(lon,var);
%
% function [lon,var]=wraparound(lon,var);
%
% "Wraps" longitudinal data around so that data is "continuous" 
%  around globe for spatial differencing operations

nlevs=size(var,1);nlat=size(var,2);nlon=size(var,3);ntime=size(var,4);

varnew=zeros(nlevs,nlat,8+nlon,ntime);
 lonnew=zeros(nlon+8,1);

varnew(:,:,1:8,:)=var(:,:,end-7:end,:);
 varnew(:,:,9:end,:)=var;
  lonnew(1:8,1)=lon(end-7:end,1)-360;
   lonnew(9:end,1)=lon;


endfunction
