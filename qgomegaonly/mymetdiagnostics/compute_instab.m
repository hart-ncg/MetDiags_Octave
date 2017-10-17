function [inert_stab,latdd,londd]=compute_instab(u,v,gph,lat,lon,lev,time);

% function []=compute__inertialstab(ug,vg,lat,lon,lev,time);
%
% computes inertial instability as per eq.7.54 pg 205, Holton (2004)
%
% inert_stab > 0 : stable
%            = 0 : neutral
%            < 0 : unstable

[ug,vg,ua,va,latd,lond]=compute_gwind(u,v,gph,lat,lon);
nlev=size(ug,1);ntime=size(ug,4);
%%%%%%%%%%%%%% CALCULATE RELATIVE GEOSTROPHIC VORTICITY
[rv,latdd,londd]=compute_curl(ug,vg,latd,lond,lev,time);

%%%%%%%%%%%%%% CALCULATE F-GRID
latdd_grid=repmat(latdd,[1 length(londd)]);
latdd_grid=repmat(latdd_grid,[1 1 nlev ntime]);latdd_grid=permute(latdd_grid,[3 1 2 4]);
f=2*7.29e-5.*sin(latdd_grid.*pi()./180);

%%%%%%%%%%%%%%%%% CALCULATE INERTIAL STABILITY PARAMETER
nu=rv+f;

inert_stab=f.*nu;

endfunction
