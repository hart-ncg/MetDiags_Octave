function [var_curl,latd,lond]=compute_curl(u,v,lat,lon,lev,time);

% function [var_div]=compute_div(u,v);
%
% Computes finite difference divergences
% Currently computes grid-points for points lying on the parent grid.
% 
nlev=length(lev);ntime=length(time);

[delta_lat,delta_lon,dlat,dlon]=delta_latlon(lat,lon);
d=repmat(delta_lat,[1 1 nlev ntime]);dy=permute(d,[3 1 2 4]);
d=repmat(delta_lon,[1 1 nlev ntime]);dx=permute(d,[3 1 2 4]);

latd=lat(2:end-1);
lond=lon(2:end-1);

dv = v(:,:,3:end,:) - v(:,:,1:end-2,:);
du = u(:,1:end-2,:,:) - u(:,3:end,:,:);

var_curl = dv(:,2:end-1,:,:)./dx - du(:,:,2:end-1,:)./dy;

endfunction
