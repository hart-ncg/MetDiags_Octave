function [lat,lon,time,olr]=olrnc2matrix(ncfile);

# [lat,lon,time,olr]=olrnc2matrix(ncfile)
#
# Function uses octcdf to open netcdf file fill matrices
# with its contents. Ensure ncfile='path to netcdf file'

nc=netcdf(ncfile,'r');
nc1=ncvar(nc){1};
nc2=ncvar(nc){2};
nc3=ncvar(nc){3};
nc4=ncvar(nc){4};
nc5=ncvar(nc){5};

#missvals=nc1(:);
lat=nc2(:);
lon=nc3(:);
olr=nc4(:);
time=nc5(:);

endfunction
