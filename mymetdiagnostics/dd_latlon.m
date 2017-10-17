function [dd_lat,dd_lon,latd,lond]=dd_latlon(lat,lon);

% Calculates distances between each points on lat long grid
%
%             LON
%
%         1---2---3---4
%         |   |   |   |
%   L     |   |   |   |
%   A     5---6---7---8
%   T     |   |   |   |
%         |   |   |   |
%         9---10--11--12
%
% such that delta_lat@6 = distance(m) from 2->10
%           delta_lon@6 = distance(m) from 5->7
%
% final outputs are two lat-2 x lon-2 grids
% containing values of x & y distances between points on the grid

nlon=length(lon);nlat=length(lat);

radius=6.37e6;
nmile_m=1852;

lat_meters=nmile_m*60;

lat_grid=repmat(lat,[1 nlon]);
lon_grid=repmat(lon',[nlat 1]);

delta_lat=(lat_grid(1:end-1,:)+lat_grid(2:end,:))./2;dd_lat=delta_lat(1:end-1,:)-delta_lat(2:end,:);
delta_lon=(lon_grid(:,2:end)+lon_grid(:,1:end-1))./2;dd_lon=delta_lon(:,2:end)-delta_lon(:,1:end-1);



dd_lat=dd_lat(:,2:end-1).*lat_meters;

lat_rad=(-1).*lat_grid.*pi()./180;
k=2*pi()*radius/360;
lon_meters=k.*sin(pi()/2-lat_rad);
dd_lon=dd_lon(2:end-1,:).*lon_meters(2:end-1,2:end-1);

lond=lon(2:end-1);latd=lat(2:end-1);

endfunction