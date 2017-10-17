function [lev,lat,lon,time,variable]=nc2matrix(ncfile);

# [lev,lat,lon,time,var]=nc2matrix(ncfile)
#
# Function uses octcdf to open netcdf file fill matrices
# with its contents. Ensure ncfile='path to netcdf file'

nc=netcdf(ncfile,'r');
nc1=ncvar(nc){1};
nc2=ncvar(nc){2};
nc3=ncvar(nc){3};
nc4=ncvar(nc){4};
nc5=ncvar(nc){5};

lev=nc1(:);
lat=nc2(:);
lon=nc3(:);
time=nc4(:);
variable=nc5(:);

variable=permute(variable,[ 1 3 4 2 ]);

endfunction