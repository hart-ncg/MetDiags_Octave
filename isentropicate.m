% isentropicate.m
%
%%%% START DATE
  yyyymmdd="STARTDATE";
% yyyymmdd="20071214";
% yyyymmdd="19980101";  
% yyyymmdd="19971230";
yyyy=str2num(substr(yyyymmdd,1,4));mm=str2num(substr(yyyymmdd,5,2));dd=str2num(substr(yyyymmdd,7,2));
%%%% SCRIPT PARAMETERS
p2isen='yes';
getbounds='yes';
savefilepath='/home/neil/data/6hourly/isentropic/';

isk=[300:3:356]';

% get indices for bounding surfaces of the isentropes given by isk

if strcmp(getbounds,'yes');[iup,idn]=boundingsurfaces(yyyy,isk);
  else;load('-v6',['/home/neil/data/6hourly/isentropic/iup_idn_',num2str(yyyy),'.mat']);
endif

%%%%%% LOAD HGT AND AIR VARIABLES
[lev,lat,lon,time,air]=opennc(['/home/neil/data/6hourly/air/air.',num2str(yyyy),'.casesubset.nc'],'air');air=air*0.01+465.15;
[lev,lat,lon,time,hgt]=opennc(['/home/neil/data/6hourly/hgt/hgt.',num2str(yyyy),'.casesubset.nc'],'hgt');hgt=hgt+31265;
nlev=length(lev);nisk=length(isk);
nlat=length(lat);nlon=length(lon);
ntime=length(time);
levm=repmat(lev,[1 nlat nlon ntime]);

%%%%%%%% INTERPOLATE PRESSURE TO isentropic surfaces and calculate stability factor for use in PV equation
if strcmp(p2isen,'yes');[p_on_isen,sf]=pres2isen(levm,air,hgt,iup,idn,isk,yyyy);writenc(yyyy,p_on_isen,lat,lon,isk,time,"isk","pk",savefilepath);
  else;load('-v6',['/home/neil/data/6hourly/isentropic/pres2isen',num2str(yyyy),'.mat']);
endif
% Interpolate VARIABLE to isentropic surface using method described in section 4.(b) of
% Shen et al., Mon.Wea.Rev.,1986.

%%%%%%%%% LOAD ALL VARIABLES
[lev,lat,lon,time,uwnd]=opennc(['/home/neil/data/6hourly/uwnd/uwnd.',num2str(yyyy),'.casesubset.nc'],'uwnd');uwnd=uwnd*0.01+187.65;
[lev,lat,lon,time,vwnd]=opennc(['/home/neil/data/6hourly/vwnd/vwnd.',num2str(yyyy),'.casesubset.nc'],'vwnd');vwnd=vwnd*0.01+187.65;
[lev,lat,lon,time,rhum]=opennc(['/home/neil/data/6hourly/rhum/rhum.',num2str(yyyy),'.casesubset.nc'],'rhum');rhum=rhum*0.01+302.65;
[lev,lat,lon,time,omega]=opennc(['/home/neil/data/6hourly/omega/omega.',num2str(yyyy),'.casesubset.nc'],'omega');omega=omega*0.001+28.765;
%%%%%%%%% INTERPOLATE VARIABLES TO ISENTROPIC SURFACES
[uwndk]=var2isen(yyyy,uwnd,p_on_isen,iup,idn,isk,levm);writenc(yyyy,uwndk,lat,lon,isk,time,"isk","uwndk",savefilepath);clear uwndk
[vwndk]=var2isen(yyyy,vwnd,p_on_isen,iup,idn,isk,levm);writenc(yyyy,vwndk,lat,lon,isk,time,"isk","vwndk",savefilepath);clear vwndk
[omegak]=var2isen(yyyy,omega,p_on_isen,iup,idn,isk,levm);writenc(yyyy,omegak,lat,lon,isk,time,"isk","omegak",savefilepath);clear omegak
[rhumk]=var2isen(yyyy,rhum,p_on_isen,iup,idn,isk,levm);writenc(yyyy,rhumk,lat,lon,isk,time,"isk","rhumk",savefilepath);clear rhumk
[hgtk]=var2isen(yyyy,hgt,p_on_isen,iup,idn,isk,levm);writenc(yyyy,hgtk,lat,lon,isk,time,"isk","hgtk",savefilepath);clear hgtk

%%%%%%%% CALCULATE ALL METEOROLOGICAL DIAGNOSTIC VARIABLES
 metdiagnostics

%%%%%%%%%% ROUTINES TO PLOT DATA IF WANTED (generally not used much)
plottest="no";
if strcmp(plottest,"yes")
n=1;m=0;
m++;pcolor(lon,lat,squeeze(idn(n,:,:,m)));colorbar;

n=2;m=0;
m++;pcolor(lond,latd,squeeze(adiab_wp(n,:,:,m)));colorbar;
endif
