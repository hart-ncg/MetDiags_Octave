function [lev,lat,lon,time,var]=opennc(ncfile,variable);

# [lev,lat,lon,time,var]=opennc(ncfile,variable);
#
# Function uses octcdf to open netcdf file fill matrices
# with its contents. Ensure ncfile='path to netcdf file'
# and variable='variable name in nc file'
# returns a matrix with dims lev,lat,lon,time
# Only ERA40 and NCEP2 dimension names implemented
dimtype='ncep2';
if strcmp(dimtype,'ncep2')
z='level';
x='lon';
y='lat';
t='time';
elseif strcmp(dimtype,'era40')
z='levelist';
x='longitude';
y='latitude';
t='date';
endif

# OPEN NETCDF FILE
nc=netcdf(ncfile,'r');
lev=nc{z}(:);
lon=nc{x}(:);
lat=nc{y}(:);
time=nc{t}(:);
var=nc{variable}(:);
nvar(1)=size(var,1);nvar(2)=size(var,2);nvar(3)=size(var,3);nvar(4)=size(var,4);

# NaN MISSING VALUES
if strcmp(dimtype,'ncep2')
mv=nc{variable}.missing_value(:);
var=reshape(var,[nvar(1)*nvar(2)*nvar(3)*nvar(4) 1]);
inan=find(var == mv);var(inan)=NaN;
var=reshape(var,[nvar(1) nvar(2) nvar(3) nvar(4)]);
endif
# PERMUTE TO LEV X LAT X LON X TIME
ndims(1)=nc(z)(:);
ndims(2)=nc(y)(:);
ndims(3)=nc(x)(:);
ndims(4)=nc(t)(:);
for n=1:4;i(n)=find(nvar==ndims(n));endfor
var=permute(var,[ i(1) i(2) i(3) i(4) ]);

if strcmp(dimtype,'era40')
var=flipdim(var,1);
lev=flipud(lev);
endif

# WRAP LAST 6 LONGITUDE VALUES AROUND IF WANT TO EFFECTIVELY PERFORM CALCULATIONS FOR FULL HEMISPHERE
wrap="yes";
if strcmp(wrap,"yes")
 if (360-lon(end)) <= 2.5;
  [lon,var]=wraparound(lon,var);
 endif
endif


endfunction
