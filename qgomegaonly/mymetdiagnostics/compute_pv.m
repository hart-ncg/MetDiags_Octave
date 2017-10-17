function [pv,latd,lond,iskd]=compute_pv(yyyy,u,v,lat,lon,lev,time,timeres);
#
# [pv,latd,lond,iskd]=compute_pv(yyyy,u,v,lat,lon,lev,time,timeres);
#
# Compute Ertels Potential Vorticity
# return pv in PVU
# Can compute PV using u, v winds already interpolated to isk surfaces (uwndk,vwndk or ones still to be interpolated, uwnd,vwnd)
#
nlev=length(lev);ntime=length(time);nlat=length(lat);nlon=length(lon);
levm=repmat(lev,[1 size(u,2) size(u,3) size(u,4)]);

if lev(1)<400;zcoord='potT';elseif lev(1)>800;zcoord='pres';endif

g=9.81;
[dy,dx,dlat,dlon]=delta_latlon(lat,lon);

[rv,latd,lond]=compute_curl(u,v,lat,lon,lev,time);

latd_grid=repmat(latd,[1 length(lond)]);
latd_grid=repmat(latd_grid,[1 1 nlev ntime]);latd_grid=permute(latd_grid,[3 1 2 4]);

f=2*7.29e-5.*sin(latd_grid.*pi()./180);

if timeres==24;
 load('-v6',['/home/neil/data/daily/isentropic/pres2isen',num2str(yyyy),'.mat']);
 load('-v6',['/home/neil/data/daily/isentropic/iup_idn_',num2str(yyyy),'.mat']);
elseif timeres==6;
 load('-v6',['/home/neil/data/6hourly/isentropic/pres2isen',num2str(yyyy),'.mat']);
 load('-v6',['/home/neil/data/6hourly/isentropic/iup_idn_',num2str(yyyy),'.mat']);
endif
iskd=isk(2:end-1);

df2=size(p_on_isen,2)-size(rv,2);df3=size(p_on_isen,3)-size(rv,3);

nu=rv+f;
if strcmp(zcoord,'pres');
[nu_on_isen]=var2isen(yyyy,nu,p_on_isen(:,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:),iup(:,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:),idn(:,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:),isk,levm(:,2:end-1,2:end-1,:));
nu=nu_on_isen;
endif
pk=p_on_isen(:,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:);
nlt=size(pk,2);nln=size(pk,3);
# # Either can use stability factor dtheta/dp determined in the pres2isen.m function (however it is particularly noisy and needs to be checked)
# # or one created here from finite differencing. 
# sf=sf(:,1+df2/2:end-df2/2,1+df3/2:end-df3/2,:);
# or
 dtheta=(isk(3:end)-isk(1:end-2));dtheta=repmat(dtheta,[1 nlt nln ntime]);
 dp=pk(3:end,:,:,:)-pk(1:end-2,:,:,:);
# dp=dp.*100;
 sf=dtheta./dp;

pv=nu(2:end-1,:,:,:).*(-g).*sf.*1e06;

endfunction
