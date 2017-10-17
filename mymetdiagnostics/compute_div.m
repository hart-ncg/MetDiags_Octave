function [var_div,latd,lond]=compute_div(u,v,lat,lon);

% function [var_div]=compute_div(u,v);
%
% Computes finite difference divergences
% Currently computes grid-points for points lying on the parent grid.
nlev=size(u,1);ntime=size(u,4);

[delta_lat,delta_lon,dlat,dlon]=delta_latlon(lat,lon);
d=repmat(delta_lat,[1 1 nlev ntime]);dy=permute(d,[3 1 2 4]);
d=repmat(delta_lon,[1 1 nlev ntime]);dx=permute(d,[3 1 2 4]);

latd=lat(2:end-1);
lond=lon(2:end-1);

div_u = u(:,:,3:end,:) - u(:,:,1:end-2,:);
div_v = v(:,1:end-2,:,:) - v(:,3:end,:,:);

var_div = div_u(:,2:end-1,:,:)./dx + div_v(:,:,2:end-1,:)./dy;

endfunction
