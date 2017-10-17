# # testpvdestruction.m
yyyymmdd="20020104";
tm='00';
yyyy=str2num(substr(yyyymmdd,1,4));mm=str2num(substr(yyyymmdd,5,2));dd=str2num(substr(yyyymmdd,7,2));
# %%%% SCRIPT PARAMETERS
loadfilepath_P=['/home/neil/data/era40/',num2str(yyyy),'/'];
loadfilepath_K='/home/neil/data/6hourly/isentropic/';
savefilepath='/home/neil/data/6hourly/diagnostics/';

moisturefield='no';
adiabaticuplift='no';
ertelsPV='no';
geostrophicwinds='no';
inert_sym_stability='no';
omegaterms='no';
qg_omega='no';
divergence='no';
hgtK_rateofchange='no';
diabPV='yes';

loadncep='yes';
loaddiagnostics='no';
# ################### LOAD NCEP PRESSURE LEVEL VARAIBLES
if strcmp(loadncep,'yes')
[lev,lat,lon,time,air]=opennc([loadfilepath_P,'air.',num2str(yyyy),'.casesubset.nc'],'t');air=air.*0.00238227567747673+244.840699194479;
[lev,lat,lon,time,hgt]=opennc([loadfilepath_P,'hgt.',num2str(yyyy),'.casesubset.nc'],'z');hgt=hgt.*7.63780780308232+243941.451716402;
[lev,lat,lon,time,uwnd]=opennc([loadfilepath_P,'uwnd.',num2str(yyyy),'.casesubset.nc'],'u');uwnd=uwnd.*0.00579810072303028+20.2296828028029;
[lev,lat,lon,time,vwnd]=opennc([loadfilepath_P,'vwnd.',num2str(yyyy),'.casesubset.nc'],'v');vwnd=vwnd.*0.00523837453269245+(-1.88226850804615);
[lev,lat,lon,time,rhum]=opennc([loadfilepath_P,'rhum.',num2str(yyyy),'.casesubset.nc'],'r');rhum=rhum.*0.00224455526894287+51.3172719892434;
[lev,lat,lon,time,omega]=opennc([loadfilepath_P,'omega.',num2str(yyyy),'.casesubset.nc'],'w');omega=omega.*6.16990102004103e-05+(-0.615279342603054);
nlev=length(lev);
nlat=length(lat);nlon=length(lon);
ntime=length(time);
levm=repmat(lev,[1 nlat nlon ntime]);
endif
################# CALCULATE DIABATIC PV TENDENCY
if strcmp(diabPV,'yes');printf("Calculating Diabatic Potential Vorticity Tendency...")
#  load('-v6',[loadfilepath_K,'pres2isen',num2str(yyyy),'.mat']);
#   load('-v6',[loadfilepath_K,'iup_idn_',num2str(yyyy),'.mat']);
[PV_LHR,latd,lond,levdd,lrs,pt,pte]=compute_pvdestruction(uwnd(:,:,:,:),vwnd(:,:,:,:),omega(:,:,:,:),air(:,:,:,:),rhum(:,:,:,:),levm(:,:,:,:),lat,lon,lev(:),time);
#  [PV_LHRk]=var2isen(yyyy,PV_LHR,p_on_isen(3:end-2,2:end-1,2:end-1,:),iup(3:end-2,2:end-1,2:end-1,:),idn(3:end-2,2:end-1,2:end-1,:),isk(3:end-2),levm(3:end-2,2:end-1,2:end-1,:));
#  writenc(yyyy,PV_LHRk,latd,lond,isk(3:end-2),time,"isk","PV_LHRk",savefilepath);
  writenc(yyyy,PV_LHR,latd,lond,levdd,time,"pres","diabpv_era",savefilepath);
 printf("done!\n")
endif