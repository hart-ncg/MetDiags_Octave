function [delta_lat,delta_lon,dlat,dlon]=delta_latlon(lat,lon);

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

delta_lat=lat_grid(1:end-2,2:end-1)-lat_grid(3:end,2:end-1);
delta_lon=lon_grid(2:end-1,3:end)-lon_grid(2:end-1,1:end-2);

delta_lat=delta_lat.*lat_meters;

lat_rad=(-1).*lat_grid.*pi()./180;
k=2*pi()*radius/360;
lon_meters=k.*sin(pi()/2-lat_rad);
delta_lon=delta_lon.*lon_meters(2:end-1,2:end-1);

dlon=lon(2:end-1);dlat=lat(2:end-1);

endfunction