function [xgc,ygc,latd,lond]=compute_gradcurl(u,v,lat,lon,lev,time);

% function [gradcurl,latd,lond]=compute_gradcurl(u,v,lat,lon,lev,time);
%
% Computes finite difference curl, then gradient
% Useful in calculation of gradient of relative vorticity for use in omega equation
% Currently computes grid-points for points lying on the parent grid.
% 
nlev=length(lev);ntime=length(time);nlon=length(lon);nlat=length(lat);

%%%%%%%% Create correct corresponding dlat dlon grids
lat_gr=(lat(1:end-1)+lat(2:end))./2;
lon_gr=(lon(1:end-1)+lon(2:end))./2;
lat_grgrid=repmat(lat_gr,[1 length(lon_gr)]);
radius=6.37e6;
nmile_m=1852;
lat_meters=nmile_m*60;
lat_rad=(-1).*lat_grgrid.*pi()./180;
k=2*pi()*radius/360;
lon_meters=k.*sin(pi()/2-lat_rad);

lat_grid=repmat(lat,[1 nlon]);
lon_grid=repmat(lon',[nlat 1]);
dlon = lon_grid(:,2:end) - lon_grid(:,1:end-1);dlon_gr=(dlon(2:end,:)+dlon(1:end-1,:))./2;
dlat = lat_grid(1:end-1,:) - lat_grid(2:end,:);dlat_gr=(dlat(:,2:end)+dlat(:,1:end-1))./2;

delta_lon=dlon_gr.*lon_meters;
delta_lat=dlat_gr.*lat_meters;
%%%%%%%%%
%%% Calculate Curl on an intermediate point grid
d=repmat(delta_lat,[1 1 nlev ntime]);dy=permute(d,[3 1 2 4]);
d=repmat(delta_lon,[1 1 nlev ntime]);dx=permute(d,[3 1 2 4]);

dv = v(:,:,2:end,:) - v(:,:,1:end-1,:);dv_gr=(dv(:,2:end,:,:)+dv(:,1:end-1,:,:))./2;
du = u(:,1:end-1,:,:) - u(:,2:end,:,:);du_gr=(du(:,:,2:end,:)+du(:,:,1:end-1,:))./2;

curl = dv_gr./dx - du_gr./dy;
latd=lat(2:end-1);
lond=lon(2:end-1);
%%%%%% Calculate gradient of curl on the input (u,v) grid (although boundary gridpoints get lost)
[dd_lat,dd_lon,latd,lond]=dd_latlon(lat,lon);
d=repmat(dd_lat,[1 1 nlev ntime]);dy=permute(d,[3 1 2 4]);
d=repmat(dd_lon,[1 1 nlev ntime]);dx=permute(d,[3 1 2 4]);
xgrad=curl(:,:,2:end,:)-curl(:,:,1:end-1,:);xgr=(xgrad(:,2:end,:,:)+xgrad(:,1:end-1,:,:))./2;
ygrad=curl(:,1:end-1,:,:) - curl(:,2:end,:,:);ygr=(ygrad(:,:,2:end,:)+ygrad(:,:,1:end-1,:))./2;

xgc=xgr./dx;
ygc=ygr./dy;
gradcurl = xgc + ygc;


endfunction
