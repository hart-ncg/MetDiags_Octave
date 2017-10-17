function [xlap,ylap,latd,lond]=compute_laplacian_horiz(vrb,lat,lon);

% function [xgrad,ygrad,latd,lond]=compute_laplacian_horiz(vrb,lat,lon);
%
% Performs Laplacian operator on given vrb (or any vertical coord) field
% ie d(vrb)/dx + d(vrb)/dy
%

%%%%%%%%% GET dvar_x & dvar_y
nlev=size(vrb,1);nlat=size(vrb,2);nlon=size(vrb,3);ntime=size(vrb,4);

dvar_x = vrb(:,:,2:end,:) - vrb(:,:,1:end-1,:);
dvar_y = vrb(:,1:end-1,:,:) - vrb(:,2:end,:,:);

ddvar_x = dvar_x(:,:,2:end,:) - dvar_x(:,:,1:end-1,:);
ddvar_y = dvar_y(:,1:end-1,:,:) - dvar_y(:,2:end,:,:);
%%%%%%%%%% GET delta_x & delta_y
[dd_lat,dd_lon,latd,lond]=dd_latlon(lat,lon);

d=repmat(dd_lon,[1 1 nlev ntime]);dx=permute(d,[3 1 2 4]);
d=repmat(dd_lat,[1 1 nlev ntime]);dy=permute(d,[3 1 2 4]);


xlap=ddvar_x(:,2:end-1,:,:)./(dx.^2);
ylap=ddvar_y(:,:,2:end-1,:)./(dy.^2);

endfunction