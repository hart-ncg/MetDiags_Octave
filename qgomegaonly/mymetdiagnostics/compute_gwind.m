function [ug,vg,ua,va,latd,lond]=compute_gwind(u,v,gph,lat,lon);
%
% function [ug,vg,latd,lond]=compute_gwind(u,v)
%
%
g=-9.81;
nlev=size(u,1);ntime=size(u,4);
%%%%%%%%% GET DX, DY
[xgrad,ygrad,latd,lond]=compute_gradient(gph,lat,lon);

%%%%%%%%% U,V
u=u(:,2:end-1,2:end-1,:);
v=v(:,2:end-1,2:end-1,:);

%%%%%%%%%%%%%% CALCULATE F-GRID
latd_grid=repmat(latd,[1 length(lond)]);
latd_grid=repmat(latd_grid,[1 1 nlev ntime]);latd_grid=permute(latd_grid,[3 1 2 4]);
f=2*7.292e-5.*sin(latd_grid.*pi()./180);

%%%%%%%%%%%%%% CALCULATE GEOSTROPHIC AND AGEOSTROPHIC WIND
ug=g.*ygrad./f;
 vg=-g.*xgrad./f;
 
 ua=u-ug;
  va=v-vg;
 
endfunction
