function [iup,idn]=boundingsurfaces_daily(yyyy,isk)
%
% function [iup,idn]=boundingsurfaces_daily(yyyy,inc)
%
% Isolates bounding pressure surfaces for given isentropic surfaces isk
% which can be a single value or a vector
% Returns indices iup & idn which contain pressure level indexes above and below

[lev,lat,lon,time6hr,air]=opennc(['/home/neil/data/6hourly/air/air.',num2str(yyyy),'.casesubset.nc'],'air');air=air*0.01+465.15;
[air,time]=daily(air,time6hr);

nlev=length(lev);nisk=length(isk);
nlat=length(lat);nlon=length(lon);
ntime=length(time);

levm=repmat(lev,[1 nlat nlon ntime]);
pot_t=air.*(1013.25./levm).^0.286;
%%%%%%%%%%%%%%%%%%%%%%% ISOLATE PRESSURE SURFACES BOUNDING ISENTROPIC SURFACES
tk=reshape(pot_t,[nlev nlat*nlon*ntime]);
iup=NaN(nisk,nlat*nlon*ntime);
idn=NaN(nisk,nlat*nlon*ntime);
for m=1:nisk
   for n=1:nlat*nlon*ntime
       i=find(tk(:,n) < isk(m));if isempty(i);continue;endif
        idx=i(end);
         idn(m,n)=idx;
         iup(m,n)=idx+1;
     endfor
endfor
iup=reshape(iup,[nisk nlat nlon ntime]);
idn=reshape(idn,[nisk nlat nlon ntime]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save('-v6',['/home/neil/data/daily/isentropic/iup_idn_',num2str(yyyy),'.mat'],'iup','idn','isk')

endfunction
