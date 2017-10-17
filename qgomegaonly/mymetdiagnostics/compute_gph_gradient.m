function [xgrad,ygrad,latd,lond]=compute_gph_gradient(gph,lat,lon);

% function [xgrad,ygrad,latd,lond]=compute_gph_gradient(gph,lat,lon);
%
% Performs GRAD operator on given gph field
% ie d(gph)/dx + d(gph)/dy
%

%%%%%%%%% GET dgph_x & dgph_y
nlev=size(gph,1);nlat=size(gph,2);nlon=size(gph,3);ntime=size(gph,4);

dgph_x = gph(:,2:end-1,3:end,:) - gph(:,2:end-1,1:end-2,:);
dgph_y = gph(:,1:end-2,2:end-1,:) - gph(:,3:end,2:end-1,:);

%%%%%%%%%% GET delta_x & delta_y

[delta_lat,delta_lon,latd,lond]=delta_latlon(lat,lon);

d=repmat(delta_lon,[1 1 nlev ntime]);dx=permute(d,[3 1 2 4]);
d=repmat(delta_lat,[1 1 nlev ntime]);dy=permute(d,[3 1 2 4]);
xgrad=dgph_x./dx;
ygrad=dgph_y./dy;

endfunction