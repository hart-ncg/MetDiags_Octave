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
%%%%%%%%% CALCULATE MOISTURE TRANSPORTS AND DIVERGENCE FIELD
if strcmp(moisturefield,'yes');printf("Calculating moisture transports and divergence field...")
[qdiv,qu,qv,lond,latd]=compute_quv(uwnd,vwnd,rhum,air,levm,lat,lon,lev,time);
 load('-v6',[loadfilepath_K,'pres2isen',num2str(yyyy),'.mat']);
  load('-v6',[loadfilepath_K,'iup_idn_',num2str(yyyy),'.mat']);
 [quk]=var2isen(yyyy,qu,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
  [qvk]=var2isen(yyyy,qv,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
   [qdivk]=var2isen(yyyy,qdiv,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
writenc(yyyy,quk,latd,lond,isk,time,"isk","quk",savefilepath)
 writenc(yyyy,qvk,latd,lond,isk,time,"isk","qvk",savefilepath)
  writenc(yyyy,qdivk,latd,lond,isk,time,"isk","qdivk",savefilepath)
clear qdiv qu qv qdivk quk qvk
printf("done!\n")
endif
%%%%%%%%% CALCULATE ADIABATIC OMEGA FROM PROJECTION OF U,V WINDS ON ISENTROPIC SURFACE
if strcmp(adiabaticuplift,'yes');printf("Calculating adiabatic omega from projection of vector winds on K surfaces...")
[isk,lat,lon,time,uwndk]=opennc([loadfilepath_K,'uwndk',num2str(yyyy),'.nc'],'uwndk');
 [isk,lat,lon,time,vwndk]=opennc([loadfilepath_K,'vwndk',num2str(yyyy),'.nc'],'vwndk');
  [isk,lat,lon,time,hgtk]=opennc([loadfilepath_K,'hgtk',num2str(yyyy),'.nc'],'hgtk');
       % Calculate omega (Pa/s)
         [adiab_wp,latd,lond]=compute_adiab_w(p_on_isen,uwndk,vwndk,lat,lon);
           writenc(yyyy,adiab_wp,latd,lond,isk,time,"isk","adiab_wp",savefilepath);
        % Calculate omega (m/s)
           [adiab_wh,latd,lond]=compute_adiab_w(hgtk,uwndk,vwndk,lat,lon);
              writenc(yyyy,adiab_wh,latd,lond,isk,time,"isk","adiab_wh",savefilepath);
clear adiab_wp adiab_wh uwndk vwndk hgtk
printf("done!\n")
endif
%%%%%%%%%% CALCULATE POTENTIAL VORTICITY
if strcmp(ertelsPV,'yes');printf("Calculating Ertel's Potential Vorticity...")
[isk,lat,lon,time,uwndk]=opennc([loadfilepath_K,'uwndk',num2str(yyyy),'.nc'],'uwndk');
 [isk,lat,lon,time,vwndk]=opennc([loadfilepath_K,'vwndk',num2str(yyyy),'.nc'],'vwndk');
[pv,latd,lond,iskd]=compute_pv(yyyy,uwndk,vwndk,lat,lon,isk,time,24);
 [pv_advec,latdd,londd]=compute_advection(pv,uwndk,vwndk,latd,lond,iskd);
 writenc(yyyy,pv,latd,lond,iskd,time,"isk","pv",savefilepath);
  writenc(yyyy,pv_advec,latdd,londd,iskd,time,"isk","pv_advec",savefilepath);
  clear pv
printf("done!\n")
endif
%%%%%%%%% CALCULATE DIABATIC PV TENDENCY
if strcmp(diabPV,'yes');printf("Calculating Diabatic Potential Vorticity Tendency...")
 load('-v6',[loadfilepath_K,'pres2isen',num2str(yyyy),'.mat']);
  load('-v6',[loadfilepath_K,'iup_idn_',num2str(yyyy),'.mat']);
[PV_LHR,latd,lond,levdd]=compute_pvdestruction(uwnd,vwnd,omega,air,rhum,levm,lat,lon,lev,time);
 [PV_LHRk]=var2isen(yyyy,PV_LHR,p_on_isen(3:end-2,2:end-1,2:end-1,:),iup(3:end-2,2:end-1,2:end-1,:),idn(3:end-2,2:end-1,2:end-1,:),isk(3:end-2),levm(3:end-2,2:end-1,2:end-1,:));
 writenc(yyyy,PV_LHRk,latd,lond,isk(3:end-2),time,"isk","PV_LHRk",savefilepath);
  writenc(yyyy,PV_LHR,latd,lond,levdd,time,"pres","PV_LHR",savefilepath);
clear PV_LHR PV_LHRk
 printf("done!\n")
endif
%%%%%%%%% CALCULATE GEOSTROPHIC & AGEOSTROPHIC WINDS
if (strcmp(geostrophicwinds,'yes') | (strcmp(inert_sym_stability,'yes') & exist([savefilepath,'ugk',num2str(yyyy),'.nc'])==0));printf("Calculating geostrophic and ageostrophic components of total wind...")
[ug,vg,ua,va,latd,lond]=compute_gwind(uwnd,vwnd,hgt,lat,lon);
 [ugk]=var2isen(yyyy,ug,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
  [vgk]=var2isen(yyyy,vg,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
   [uak]=var2isen(yyyy,ug,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
    [vak]=var2isen(yyyy,vg,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
  writenc(yyyy,ugk,latd,lond,isk,time,"isk","ugk",savefilepath);
   writenc(yyyy,vgk,latd,lond,isk,time,"isk","vgk",savefilepath);
    writenc(yyyy,uak,latd,lond,isk,time,"isk","uak",savefilepath);
     writenc(yyyy,vak,latd,lond,isk,time,"isk","vak",savefilepath);
    writenc(yyyy,ug,latd,lond,lev,time,"pres","ug",savefilepath);
     writenc(yyyy,vg,latd,lond,lev,time,"pres","vg",savefilepath);
      writenc(yyyy,ua,latd,lond,lev,time,"pres","ua",savefilepath);
       writenc(yyyy,va,latd,lond,lev,time,"pres","va",savefilepath);
 clear ugk vgk uak vak
printf("done!\n")
endif
%%%%%%%%% CALCULATE INERTIAL/SYMMETRIC INSTABILITY
if strcmp(inert_sym_stability,'yes');printf("Calculating inertial and symmetric instability...")
[isk,latd,lon,time,ugk]=opennc([savefilepath,'ugk',num2str(yyyy),'.nc'],'ugk');
 [isk,latd,lon,time,vgk]=opennc([savefilepath,'vgk',num2str(yyyy),'.nc'],'vgk');
[inert_stab,latdd,londd]=compute_instab(uwnd,vwnd,hgt,lat,lon,lev,time);
 writenc(yyyy,inert_stab,latdd,londd,lev,time,"pres","inert_stab",savefilepath);
[sym_stab,latdd,londd,iskd]=compute_symmetricstab(yyyy,ugk,vgk,latd,lon,isk,time,24);
 writenc(yyyy,sym_stab,latdd,londd,iskd,time,"isk","sym_stab",savefilepath);
clear inert_stab sym_stab
printf("done!\n")
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
%%%%%%%%% CALCULATE HORIZONTAL MASS DIVERGENCE FIELD
if strcmp(divergence,'yes');printf("Calculating divergence field...")
  load('-v6',[loadfilepath_K,'pres2isen',num2str(yyyy),'.mat']);
  load('-v6',[loadfilepath_K,'iup_idn_',num2str(yyyy),'.mat']);
 [uv_div,latd,lond]=compute_div(uwnd,vwnd,lat,lon);
 writenc(yyyy,uv_div,latd,lond,lev,time,"pres","uv_div",savefilepath);
[uv_divk]=var2isen(yyyy,uv_div,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
 writenc(yyyy,uv_divk,latd,lond,isk,time,"isk","uv_divk",savefilepath);
 clear uv_divk uv_div
printf("done!\n")
endif
%%%%%%%%% CALCULATE RATE OF CHANGE OF HGT OF THE ISENTROPIC SURFACES
if strcmp(hgtK_rateofchange,'yes');printf("Calculating rate of change of hgt of isentropic surfaces...")
[isk,lat,lon,time,hgtk]=opennc([loadfilepath_K,'hgtk',num2str(yyyy),'.nc'],'hgtk');
 [hgtk_roc,timed]=compute_dvar_dt_daily(hgtk,time);
  writenc(yyyy,hgtk_roc,lat,lon,isk,timed,"isk","hgtk_roc",savefilepath);
 clear hgtk_roc_daily hgtk_roc hgtk
printf("done!\n")
endif
%%%%%%%%% CALCULATE TOPOGRAPHIC OMEGA FROM PROJECTION OF U,V WINDS ON LAND SURFACE
if strcmp(topouplift,'yes');printf("Calculating topographic omega from projection of vector winds on land surfaces...")
%         % Calculate omega (Pa/s)
%           [adiab_wp,latd,lond]=compute_adiab_w(p_on_isen,uwndk,vwndk,lat,lon);
%             writenc(yyyy,adiab_wp,latd,lond,isk,time,"isk","adiab_wp",savefilepath);
 ltmn=-7.5;ltmx=-45;
 lnmn=7.5;lnmx=60;
        % Calculate omega (m/s)
           [topo_w,latd,lond,lat1,lon1,grad]=compute_topo_w(uwnd,vwnd,air,lev,lat,lon,ltmn,ltmx,lnmn,lnmx);
%  save -v6 topo.mat uwnd vwnd lat lon ltmn ltmx lnmn lnmx
              writenc(yyyy,topo_w,latd,lond,lev,time,"pres","topo_w",savefilepath);
%  clear topo_w
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
%%%%%%%% STUFF FOR GETTTING RGB VALUES BASED ON FORCING TERMS
rgbmapping='no';
if strcmp(rgbmapping,'yes')
[hrs]=hrssince('20071216_12','ncep2');
R=DVA(find(levd==250),:,:,find(time==hrs));
G=LOTA(find(levd==850),:,:,find(time==hrs));
B=hgtk_roc(find(isk==309),4:end-3,4:end-3,find(time==hrs));
[rgbvals]=map2rgb(R,G,B,"std");
save -v6 RGB.mat latddd londdd rgbvals

[hrs]=hrssince('20071216_09','ncep2');
R=DVA(find(levd==250),:,:,find(time==hrs));
G=adiab_wp(find(isk==309),3:end-2,3:end-2,find(time==hrs));
B=hgtk_roc(find(isk==309),4:end-3,4:end-3,find(time==hrs));
[rgbvals]=map2rgb(R,G,B,"none");
save -v6 RGB2.mat latddd londdd rgbvals
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
