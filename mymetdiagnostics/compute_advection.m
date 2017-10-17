function [advec,latd,lond]=compute_advection(vrb,u,v,lat,lon,lev);
%
% function [advec,latd,lond]=compute_advection(vrb,u,v,lat,lon,lev);
%
% Computes gradient of variable then multiplies by wind velocities

[xgrad,ygrad,latd,lond]=compute_gradient(vrb,lat,lon);

% Match u,v to gradient terms
df1=size(u,1)-size(xgrad,1);df2=size(u,2)-size(xgrad,2);df3=size(u,3)-size(xgrad,3);
u=u(1+df1/2:end-df1/2,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:);
v=v(1+df1/2:end-df1/2,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:);

xad=xgrad.*(-1).*u; yad=ygrad.*(-1).*v;
advec=xad+yad;

endfunction