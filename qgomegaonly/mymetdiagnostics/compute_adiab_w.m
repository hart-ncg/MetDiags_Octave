function [adiab_w,latd,lond]=compute_adiab_w(vcoord,u,v,lat,lon);
%
% function [adiab_w,latd,lond]=compute_adiab_w(gph,u,v);
% 
% Computes adiabatic uplift on isentropic surface by calculating
% from projection of wind vectors on the height or pressure field

nisk=size(vcoord,1);nlat=length(lat);nlon=length(lon);ntime=size(vcoord,4);

%%%%%%% GET GRADIENT OF GIVEN FIELD
[xgrad,ygrad,latd,lond]=compute_gradient(vcoord,lat,lon);

%%%%%%%% CALULATE VERTICAL PROJECTION OF HORIZONTAL WIND ON ISENTROPIC SURFACE

w_u=u(:,2:end-1,2:end-1,:).*xgrad;
w_v=v(:,2:end-1,2:end-1,:).*ygrad;

adiab_w = w_u + w_v;

endfunction
