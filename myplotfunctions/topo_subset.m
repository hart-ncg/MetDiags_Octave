function [topo,lat,lon]=topo_subset(ltmn,ltmx,lnmn,lnmx);

# topo_subset.m
# script for subsetting etopo2.nc data
l=[ltmn ltmx lnmn lnmx];
t=netcdf('/home/neil/data/Topo/etopo2_africa.nc','r');
lon=t{'lon'}(:);
lat=t{'lat'}(:);
topo=t{'topo'}(:);
close(t)

[m,il(1)]=min(abs(ltmn-lat));
[m,il(2)]=min(abs(ltmx-lat));
[m,il(3)]=min(abs(lnmn-lon));
[m,il(4)]=min(abs(lnmx-lon));

lon2=lon(il(3):il(4));
lat2=lat(il(1):il(2));