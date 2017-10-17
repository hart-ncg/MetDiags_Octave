% metdiagnostics.m
% Computes meteorological diagnostics using functions in /home/neil/octave/mymetdiagnostics/
% IMPORTANT: MANY OF THESE FUNCTIONS REQUIRE VARIABLES ON 
% ISENTROPIC SURFACES CREATED BY ~/home/neil/octave/isentropicate.m
%
% NB: "compute_pv.m" FUNCTION HAS LOADFILEPATH INTRINSICALLY SET TO "/home/neil/6hourly/"
%   SO IF YOU ARE USING A PATH DIFFERENT TO THAT YOU NEED EDIT "compute_pv.m" YOURSELF!
clear all
%%%% START DATE
for n=1:3
%  yyyymmdd="STARTDATE";
if n==1;yyyymmdd="19971230";end
if n==2;yyyymmdd="19980101";end
if n==3;yyyymmdd="20071214";end
%   yyyymmdd="20020104";
yyyymmdd
yyyy=str2num(substr(yyyymmdd,1,4));mm=str2num(substr(yyyymmdd,5,2));dd=str2num(substr(yyyymmdd,7,2));
%%%% SCRIPT PARAMETERS
loadfilepath_P='/home/neil/data/6hourly/';
loadfilepath_K='/home/neil/data/daily/isentropic/';
savefilepath='/home/neil/data/daily/diagnostics/';

moisturefield='no';
adiabaticuplift='no';
ertelsPV='no';
geostrophicwinds='no';
inert_sym_stability='no';
omegaterms='no';
qg_omega='no';
divergence='no';
hgtK_rateofchange='no';
diabPV='no';
topouplift='no';

loadncep='yes';
loaddiagnostics='no';
%%%%%%%%%%%%%%%%%%% LOAD NCEP PRESSURE LEVEL VARAIBLES
if strcmp(loadncep,'yes')
[lev,lat,lon,time6hr,air]=opennc([loadfilepath_P,'air/air.',num2str(yyyy),'.casesubset.nc'],'air');air=air*0.01+465.15;
[lev,lat,lon,time6hr,hgt]=opennc([loadfilepath_P,'hgt/hgt.',num2str(yyyy),'.casesubset.nc'],'hgt');hgt=hgt+31265;
[lev,lat,lon,time6hr,uwnd]=opennc([loadfilepath_P,'uwnd/uwnd.',num2str(yyyy),'.casesubset.nc'],'uwnd');uwnd=uwnd*0.01+187.65;
[lev,lat,lon,time6hr,vwnd]=opennc([loadfilepath_P,'vwnd/vwnd.',num2str(yyyy),'.casesubset.nc'],'vwnd');vwnd=vwnd*0.01+187.65;
[lev,lat,lon,time6hr,rhum]=opennc([loadfilepath_P,'rhum/rhum.',num2str(yyyy),'.casesubset.nc'],'rhum');rhum=rhum*0.01+302.65;
[lev,lat,lon,time6hr,omega]=opennc([loadfilepath_P,'omega/omega.',num2str(yyyy),'.casesubset.nc'],'omega');omega=omega*0.001+28.765;

[air,time]=daily(air,time6hr);
[hgt,time]=daily(hgt,time6hr);
[uwnd,time]=daily(uwnd,time6hr);
[vwnd,time]=daily(vwnd,time6hr);
[rhum,time]=daily(rhum,time6hr);
[omega,time]=daily(omega,time6hr);

nlev=length(lev);
nlat=length(lat);nlon=length(lon);
ntime=length(time);
levm=repmat(lev,[1 nlat nlon ntime]);
endif

%%%%%%%%% CALCULATE OMEGA TERMS
if (strcmp(omegaterms,'yes') | strcmp(qg_omega,'yes'));printf("Calculating vorticity and temperature advection terms in Omega Equation...")
[DVA,LOTA,latddd,londdd,levd,fsigma]=compute_omegaterms(uwnd,vwnd,air,hgt,levm,lat,lon,lev,time,-30);
 writenc(yyyy,DVA,latddd,londdd,levd,time,"pres","DVA",savefilepath);
  writenc(yyyy,LOTA,latddd,londdd,levd,time,"pres","LOTA",savefilepath);
   [Ro]=compute_rossbyno(uwnd,lat,lon);
    writenc(yyyy,Ro,lat,lon,lev,time,"pres","Ro",savefilepath);
%   clear LOTA DVA
printf("done!\n")
endif
  [Ro]=compute_rossbyno(uwnd,lat,lon);
    writenc(yyyy,Ro,lat,lon,lev,time,"pres","Ro",savefilepath);

%%%%%%%%% CALCULATE QUASIGEOSTROPHIC OMEGA
if strcmp(qg_omega,'yes');printf("Calculating Quasigeostrophic Omega...")
 ltmn=-7.5;ltmx=-45;
 lnmn=7.5;lnmx=60;
%  ltmn=40;ltmx=10;
%  lnmn=315;lnmx=350;
lt1=find(latddd==ltmn);lt2=find(latddd==ltmx);ln1=find(londdd==lnmn);ln2=find(londdd==lnmx);
ltw1=find(lat==ltmn);ltw2=find(lat==ltmx);lnw1=find(lon==lnmn);lnw2=find(lon==lnmx);
qgw=zeros(nlev-2,length(latddd(lt1:lt2)),length(londdd(ln1:ln2)),ntime);
% qgw=zeros(nlev-2,length(latddd(lt1:lt2)),length(londdd(ln1:ln2)),1);
for tt=1:ntime
%  for tt=3
  [qg,latqg,lonqg]=compute_qgw(squeeze(DVA(:,lt1:lt2,ln1:ln2,tt)),squeeze(LOTA(:,lt1:lt2,ln1:ln2,tt)),squeeze(omega(:,ltw1-1:ltw2+1,lnw1-1:lnw2+1,tt)),squeeze(fsigma(:,lt1:lt2,ln1:ln2,tt)),lat(ltw1-1:ltw2+1),lon(lnw1-1:lnw2+1),lev);
   qgw(:,:,:,tt)=permute(qg,[3 2 1]);
 endfor
 writenc(yyyy,qgw,latddd(lt1:lt2),londdd(ln1:ln2),levd,time,"pres","qgw",savefilepath);
 clear LOTA DVA qgw
printf("done!\n")
endif

%%%%%%%%% LOAD DIAGNOSTICS VARIABLES CREATED BY THIS SCRIPT
if strcmp(loaddiagnostics,'yes')
[isk,lat,lon,timed,hgtk_roc]=opennc([savefilepath,'hgtk_roc',num2str(yyyy),'.nc'],'hgtk_roc');
[levd,latddd,londdd,time,DVA]=opennc([savefilepath,'DVA',num2str(yyyy),'.nc'],'DVA');
[levd,latddd,londdd,time,LOTA]=opennc([savefilepath,'LOTA',num2str(yyyy),'.nc'],'LOTA');
[isk,latd,lond,time,adiab_wp]=opennc([savefilepath,'adiab_wp',num2str(yyyy),'.nc'],'adiab_wp');
%[isk,latd,lond,time,adiab_wh]=opennc([savefilepath,'adiab_wh',num2str(yyyy),'.nc'],'adiab_wh');
[lev,latd,lond,time,uv_div]=opennc([savefilepath,'uv_div',num2str(yyyy),'.nc'],'uv_div');
[isk,latd,lond,time,uv_divk]=opennc([savefilepath,'uv_divk',num2str(yyyy),'.nc'],'uv_divk');
[lev,latdd,londd,time,inert_stab]=opennc([savefilepath,'inert_stab',num2str(yyyy),'.nc'],'inert_stab');
[isk,latdd,londd,time,sym_stab]=opennc([savefilepath,'sym_stab',num2str(yyyy),'.nc'],'sym_stab');
endif
%%%%%%%%%% ROUTINES TO PLOT DATA IF WANTED (generally not used much)
plottest="no";
if strcmp(plottest,"yes")
n=2;m=0;
m++;pcolor(lond,latd,squeeze(ug(n,:,:,m)));colorbar;

n=2;m=0;
m++;pcolor(lond,latd,squeeze(adiab_wp(n,:,:,m)));colorbar;
endif

end
%   exit
