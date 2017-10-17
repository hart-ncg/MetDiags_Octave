function [xgrad,ygrad,zgrad,latd,lond,levd]=compute_3Dgradient(vrb,lat,lon,lev);
%
% function [xgrad,ygrad,zgrad,lond,latd,levd]=compute_3Dgradient(vrb,lon,lat,lev);
%
% Essentially combines the compute_dp and compute_gradient functions into one

%%%%%%%%% GET dgph_x & dgph_y
nlev=size(vrb,1);nlat=size(vrb,2);nlon=size(vrb,3);ntime=size(vrb,4);

dvrb_x = vrb(2:end-1,2:end-1,3:end,:) - vrb(2:end-1,2:end-1,1:end-2,:);
dvrb_y = vrb(2:end-1,1:end-2,2:end-1,:) - vrb(2:end-1,3:end,2:end-1,:);
dvrb_p = vrb(3:end,2:end-1,2:end-1,:) - vrb(1:end-2,2:end-1,2:end-1,:);
%%%%%%%% OR
%  dvrb_x = vrb(:,2:end-1,3:end,:) - vrb(:,2:end-1,1:end-2,:);dvrb_x=(dvrb_x(1:end-1,:,:,:)+dvrb_x(2:end,:,:,:))./2;
%  dvrb_y = vrb(:,1:end-2,2:end-1,:) - vrb(:,3:end,2:end-1,:);dvrb_y=(dvrb_y(1:end-1,:,:,:)+dvrb_y(2:end,:,:,:))./2;
%  dvrb_p = vrb(2:end,2:end-1,2:end-1,:) - vrb(1:end-1,2:end-1,2:end-1,:);

%%%%%%%%%% GET delta_x & delta_y

[delta_lat,delta_lon,latd,lond]=delta_latlon(lat,lon);
delta_p=lev(3:end)-lev(1:end-2);

d=repmat(delta_lon,[1 1 nlev ntime]);dx=permute(d,[3 1 2 4]);
d=repmat(delta_lat,[1 1 nlev ntime]);dy=permute(d,[3 1 2 4]);
d=repmat(delta_p,[1 nlat nlon ntime]);dz=d.*100;
xgrad=dvrb_x./dx(2:end-1,:,:,:);
ygrad=dvrb_y./dy(2:end-1,:,:,:);
zgrad=dvrb_p./dz(:,2:end-1,2:end-1,:);

levd=lev(2:end-1);
%  %%%%%%%% OR
%  
%  [delta_lat,delta_lon,latd,lond]=delta_latlon(lat,lon);
%  delta_p=lev(2:end)-lev(1:end-1);
%  
%  d=repmat(delta_lon,[1 1 nlev-1 ntime]);dx=permute(d,[3 1 2 4]);
%  d=repmat(delta_lat,[1 1 nlev-1 ntime]);dy=permute(d,[3 1 2 4]);
%  d=repmat(delta_p,[1 nlat nlon ntime]);dz=d.*100;
%  xgrad=dvrb_x./dx;
%  ygrad=dvrb_y./dy;
%  zgrad=dvrb_p./dz(:,2:end-1,2:end-1,:);
%  
%  levd=lev(2:end)+lev(1:end-1);levd=levd./2;
endfunction