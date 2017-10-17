function [Ro]=compute_rossbyno(u,lat,lon);
%
% function [Ro]=compute_rossbyno(u,v,lat,lon);


nlev=size(u,1);ntime=size(u,4);

%%%% CORIOLOS PARAMETER
lat_grid=repmat(lat,[1 length(lon)]);
lat_grid=repmat(lat_grid,[1 1 nlev ntime]);lat_grid=permute(lat_grid,[3 1 2 4]);
f=2*7.292e-5.*sin(lat_grid.*pi()./180);
%%%% LENGTH SCALE
L=10^6;

Ro=u./f./L;