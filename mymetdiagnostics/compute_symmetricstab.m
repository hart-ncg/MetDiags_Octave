function [sym_stab,latdd,londd,iskd]=compute_symmetricstab(yyyy,u,v,latd,lond,isk,time,timeres);
%
% function [sym_stab,latdd,londd]=compute_symmetricstab(yyyy,u,v,latd,lond,lev,time);
%
% computes symmetric instability as per eq.9.20 pg 280, Holton (2004)
%
%   sym_stab > 0 : stable
%            = 0 : neutral
%            < 0 : unstable

%%%%%%%%%%%%%% CALCUALTE RELATIVE GEOSTROPHIC VORTICITY
[pvg,latdd,londd,iskd]=compute_pv(yyyy,u,v,latd,lond,isk,time,timeres);

nlev=size(pvg,1);ntime=size(pvg,4);
%%%%%%%%%%%%%% CALCULATE F-GRID
latdd_grid=repmat(latdd,[1 length(londd)]);
latdd_grid=repmat(latdd_grid,[1 1 nlev ntime]);latdd_grid=permute(latdd_grid,[3 1 2 4]);
f=2*7.29e-5.*sin(latdd_grid.*pi()./180);

%%%%%%%%%%%%%%%%% CALCULATE INERTIAL STABILITY PARAMETER

sym_stab=f.*pvg;

endfunction
