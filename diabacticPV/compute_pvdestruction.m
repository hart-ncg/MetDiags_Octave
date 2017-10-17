function [PV_LHR,latd,lond,levdd]=compute_pvdestruction(u,v,omega,air,rh,pres,lat,lon,lev,time);
#
# function [PV_LHR]=compute_pvdestruction(u,v,omega,air,rh,pres,lat,lon,isk,time);
#
# Computes Destruction of Potential Vorticity by latent heat release
# following Posselt and Martin, Mon. Wea. Rev., 2004, pg 592
#
# 3-D variables: u,v,omega etc. need dimensions LEV X LAT X LON X TIME

nlev=length(lev);ntime=length(time);

w=omega;
T=air;
P=pres;
# P=levm;
# u=uwnd;
# v=vwnd;
# rh=rhum;
Lv=2.5e6;
Cp=1005.7;
Rd=287;
Rd=287;
Po=1013.25;
g=9.81;
Lr_d=g/Cp;

[sh,e,es]=compute_sh(rh,T,P,'GG');
r=0.622.*e./(P-e);
rs=0.622.*es./(P-es);
# Pot_Te=pot_t*exp(LC.*qs./T); this is for a saturated air parcel
# Below seems to be the correct one, although it is an approximate value


# pot_Te=Te.*(Po./p_on_isen).^RC;
# or
pot_T=T.*(Po./P).^0.286;
pot_Te=pot_T.*exp(Lv.*rs./Cp./T);

Lr_s=g.*((1+Lv.*rs./Rd./T)./(Cp+Lv.^2.*rs.*0.622./Rd./T.^2));

# Calculate latent heating
dpot_Te=(pot_Te(3:end,:,:,:)-pot_Te(1:end-2,:,:,:));
dpot_T=(pot_T(3:end,:,:,:)-pot_T(1:end-2,:,:,:));
dp=P(3:end,:,:,:)-P(1:end-2,:,:,:);
dp=dp.*100;
H=w(2:end-1,:,:,:).*(dpot_T./dp-Lr_s(2:end-1,:,:,:)./Lr_d.*pot_T(2:end-1,:,:,:)./pot_Te(2:end-1,:,:,:).*dpot_Te./dp);
################ OR
# dpot_Te=(pot_Te(2:end,:,:,:)-pot_Te(1:end-1,:,:,:));
# dpot_T=(pot_T(2:end,:,:,:)-pot_T(1:end-1,:,:,:));
# dp=P(2:end,:,:,:)-P(1:end-1,:,:,:);dp=dp.*100;
# H=(0.5.*w(1:end-1,:,:,:)+0.5.*w(2:end,:,:,:)).*(dpot_T./dp-(0.5.*Lr_s(1:end-1,:,:,:)+0.5.*Lr_s(2:end,:,:,:))./Lr_d.*(0.5.*pot_T(1:end-1,:,:,:)+0.5.*pot_T(2:end,:,:,:))./(0.5.*pot_Te(1:end-1,:,:,:)+0.5.*pot_Te(2:end,:,:,:)).*dpot_Te./dp);

# Calculate two-dimensional absolute vorticity
[rv,latd,lond]=compute_curl(u,v,lat,lon,lev,time);
latd_grid=repmat(latd,[1 length(lond)]);
latd_grid=repmat(latd_grid,[1 1 nlev ntime]);
latd_grid=permute(latd_grid,[3 1 2 4]);
f=2*7.292e-5.*sin(latd_grid.*pi()./180);
nu=rv+f;
nu=nu(3:end-2,:,:,:);
######### OR
# nu=rv+f;
# nu=nu(2:end-1,:,:,:);
# nu=(nu(1:end-1,:,:,:)+nu(2:end,:,:,:))./2;


# shear vorticity
[du_dp,levd]=compute_dp(u,lev);
du_dp=du_dp(2:end-1,2:end-1,2:end-1,:)./dp(2:end-1,2:end-1,2:end-1,:);
du_dp=du_dp.*(-1);
[dv_dp,levd]=compute_dp(v,lev);
dv_dp=dv_dp(2:end-1,2:end-1,2:end-1,:)./dp(2:end-1,2:end-1,2:end-1,:);
######### OR
# [du_dp,levd]=compute_dp(u,lev);du_dp=du_dp(:,2:end-1,2:end-1,:)./dp(:,2:end-1,2:end-1,:);du_dp=du_dp.*(-1);du_dp=(du_dp(1:end-1,:,:,:)+du_dp(2:end,:,:,:))./2;
# [dv_dp,levd]=compute_dp(v,lev);dv_dp=dv_dp(:,2:end-1,2:end-1,:)./dp(:,2:end-1,2:end-1,:);dv_dp=(dv_dp(1:end-1,:,:,:)+dv_dp(2:end,:,:,:))./2;

# Calculate time tendency of PV associated with LHR
[xgrad,ygrad,zgrad,latd,lond,levdd]=compute_3Dgradient(H,lat,lon,levd);
zgrad=zgrad.*(-1);
PV_LHRx=g.*(dv_dp.*xgrad);
PV_LHRy=g.*(du_dp.*ygrad);
PV_LHRz=g.*(nu.*zgrad);

# PV_LHR=PV_LHRz;
# PV_LHR=PV_LHRx+PV_LHRy;
PV_LHR=PV_LHRx+PV_LHRy+PV_LHRz;
PV_LHR=PV_LHR.*1e6;

endfunction
