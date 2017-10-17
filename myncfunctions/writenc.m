function writenc(yyyy,var,lat,lon,lev,time,hcoord,varstring,filepath)

% function writenc(yyyy,var,lat,lon,lev,time,hcoord,varstring,filepath)
%
% Usage: Varstring, filepath (must end with /), hcoord need to be strings

%%%%%%%%%%%%%%%%%%%% CREATE NETCDF FILE USING OCTCDF

if lon(1)<0
[lon,var]=wrapback(lon,var);
endif

nlev=length(lev);nlon=length(lon);nlat=length(lat);ntime=length(time);

mv=32766;
inan=find(var==-Inf | var==Inf);var(inan)=mv;

[varn]=ncprepare(var,varstring);

nc = netcdf([filepath,varstring,num2str(yyyy),'.nc'],'c');

nc('level')   = nlev;
nc('lat') = nlat;
nc('lon') = nlon;
nc('time') = ntime;

nc{'level'} = ncdouble('level');
nc{'level'}(:) = lev;
if strcmp(hcoord,'isk')
nc{'level'}.units = "K" ;
nc{'level'}.actual_range = [300 355] ;
nc{'level'}.long_name = "Level" ;
nc{'level'}.positive = "down" ;
nc{'level'}.GRIB_id = 100 ;
nc{'level'}.GRIB_name = "K" ;
endif
if strcmp(hcoord,'pres')
nc{'level'}.units = "millibar" ;
nc{'level'}.actual_range = [1000 10] ;
nc{'level'}.long_name = "Level" ;
nc{'level'}.positive = "down" ;
nc{'level'}.GRIB_id = 100 ;
nc{'level'}.GRIB_name = "hPa" ;
endif
nc{'level'}.axis = "z" ;
nc{'level'}.coordinate_defines = "point" ;

nc{'lat'} = ncdouble('lat');
nc{'lat'}(:) = lat;
nc{'lat'}.units = "degrees_north" ;
nc{'lat'}.actual_range = [90 -90] ;
nc{'lat'}.long_name = "Latitude" ;
nc{'lat'}.standard_name = "latitude_north" ;
nc{'lat'}.axis = "y" ;
nc{'lat'}.coordinate_defines = "point" ;

nc{'lon'} = ncdouble('lon');
nc{'lon'}(:) = lon;
nc{'lon'}.units = "degrees_east" ;
nc{'lon'}.long_name = "Longitude" ;
nc{'lon'}.actual_range = [0 357.5];
nc{'lon'}.standard_name = "longitude_east" ;
nc{'lon'}.axis = "x" ;
nc{'lon'}.coordinate_defines = "point" ;

nc{'time'} = ncdouble('time');
nc{'time'}(:) = time;
nc{'time'}.units = "hours since 1800-1-1 00:00:0.0" ;
nc{'time'}.long_name = "Time" ;
nc{'time'}.actual_range = [1814520 1823274] ;
nc{'time'}.delta_t = "0000-00-00 06:00:00" ;
nc{'time'}.standard_name = "time" ;
nc{'time'}.axis = "t" ;
nc{'time'}.coordinate_defines = "point" ;

nc{varstring} = ncdouble('level','lat','lon','time');
nc{varstring}(:) = varn;                                 
nc{varstring}.units = 'degree Celsius';                  
nc{varstring}.long_name = "6-hourly U-wind on Pressure Levels" ;
%nc{varstring}.valid_range = [-32765 -1266] ;
%nc{varstring}.unpacked_valid_range = [-140 175];
%nc{varstring}.actual_range = [-112.7 142.9];
nc{varstring}.units = "m/s" ;
%nc{varstring}.add_offset = 187.5 ;
%nc{varstring}.scale_factor = 0.01 ;
nc{varstring}.missing_value = 32766 ;
%nc{varstring}._FillValue = -32767 ;
nc{varstring}.precision = 2 ;
nc{varstring}.least_significant_digit = 1 ;
nc{varstring}.GRIB_id = 33 ;
nc{varstring}.GRIB_name = "UGRD" ;
nc{varstring}.var_desc = "u-wind" ;
nc{varstring}.dataset = "NCEP/DOE AMIP-II Reanalysis (Reanalysis-2)" ;
nc{varstring}.level_desc = "Pressure Levels" ;
nc{varstring}.statistic = "Individual Obs" ;
nc{varstring}.parent_stat = "Other" ;
nc{varstring}.standard_name = "eastward_wind" ;


dd=date;
nc.history = ['Created by octave using octcdf on ',date];

ncclose(nc)

endfunction
