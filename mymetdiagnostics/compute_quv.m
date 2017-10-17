function [qdiv,qu,qv,lond,latd]=compute_quv(u,v,rh,temp,pres,lat,lon);
%
%
% function [qdiv,qu,qv]=compute_qvu(u,v,rh,temp,pres);
%
% Computes moisture transports and divergence field using
% subroutines compute_sh, compute_div

%%%%%%%%% TRANSPORTS
[sh,e,es]=compute_sh(rh,temp,pres,'GG');
qu=u.*sh;
qv=v.*sh;

%%%%%%%% DIVERGENCE FIELD
[qdiv,latd,lond]=compute_div(qu,qv,lat,lon);
qu=qu(:,2:end-1,2:end-1,:);
qv=qv(:,2:end-1,2:end-1,:);
endfunction