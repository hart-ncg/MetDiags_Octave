# diagnostics.m
# Computes meteorological diagnostics using functions in /home/neil/octave/mymetdiagnostics/
# IMPORTANT: MANY OF THESE FUNCTIONS REQUIRE VARIABLES ON 
# ISENTROPIC SURFACES CREATED BY ~/home/neil/octave/isentropicate.m
#
# NB: "compute_pv.m" FUNCTION HAS LOADFILEPATH INTRINSICALLY SET TO "/home/neil/6hourly/"
#   SO IF YOU ARE USING A PATH DIFFERENT TO THAT YOU NEED EDIT "compute_pv.m" YOURSELF!
%%%% START DATE
%yyyymmdd="20071214";
yyyymmdd="19980101";
yyyy=str2num(substr(yyyymmdd,1,4));mm=str2num(substr(yyyymmdd,5,2));dd=str2num(substr(yyyymmdd,7,2));
%%%% SCRIPT PARAMETERS
loadfilepath_P='/home/neil/data/6hourly/';
loadfilepath_K='/home/neil/data/daily/isentropic/';
savefilepath='/home/neil/data/daily/diagnostics/';

moisturefield='yes';
adiabaticuplift='yes';
ertelsPV='yes';
geostrophicwinds='yes';
inert_sym_stability='yes';
omegaterms='yes';
divergence='yes';
hgtK_rateofchange='yes';

loadncep='yes';
loaddiagnostics='yes';
rgbmapping='yes';
################### LOAD NCEP PRESSURE LEVEL VARAIBLES
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
       # Calculate omega (Pa/s)
         [adiab_wp,latd,lond]=compute_adiab_w(p_on_isen,uwndk,vwndk,lat,lon);
           writenc(yyyy,adiab_wp,latd,lond,isk,time,"isk","adiab_wp",savefilepath);
        # Calculate omega (m/s)
           [adiab_wh,latd,lond]=compute_adiab_w(hgtk,uwndk,vwndk,lat,lon);
              writenc(yyyy,adiab_wh,latd,lond,isk,time,"isk","adiab_wh",savefilepath);
clear adiab_wp adiab_wh uwndk vwndk hgtk
printf("done!\n")
endif
%%%%%%%%%% CALCULATE POTENTIAL VORTICITY       
if strcmp(ertelsPV,'yes');printf("Calculating Ertel's Potential Vorticity...")
[pv,latd,lond]=compute_pv_daily(yyyy,uwnd,vwnd,lat,lon,lev,time);
 writenc(yyyy,pv,latd,lond,isk,time,"isk","pv",savefilepath);
  clear pv
printf("done!\n")
endif
%%%%%%%%% CALCULATE GEOSTROPHIC & AGEOSTROPHIC WINDS
if strcmp(geostrophicwinds,'yes');printf("Calculating geostrophic and ageostrophic components of total wind...")
[ug,vg,ua,va,latd,lond]=compute_gwind(uwnd,vwnd,hgt,lat,lon);
 [ugk]=var2isen(yyyy,ug,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
  [vgk]=var2isen(yyyy,vg,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
   [uak]=var2isen(yyyy,ug,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
    [vak]=var2isen(yyyy,vg,p_on_isen(:,2:end-1,2:end-1,:),iup(:,2:end-1,2:end-1,:),idn(:,2:end-1,2:end-1,:),isk,levm(:,2:end-1,2:end-1,:));
writenc(yyyy,ugk,latd,lond,isk,time,"isk","ugk",savefilepath);
 writenc(yyyy,vgk,latd,lond,isk,time,"isk","vgk",savefilepath);
  writenc(yyyy,uak,latd,lond,isk,time,"isk","uak",savefilepath);
   writenc(yyyy,vak,latd,lond,isk,time,"isk","vak",savefilepath);
 clear ugk vgk uak vak
printf("done!\n")
endif
%%%%%%%%% CALCULATE INERTIAL/SYMMETRIC INSTABILITY
if strcmp(inert_sym_stability,'yes');printf("Calculating inertial and symmetric instability...")
[inert_stab,latdd,londd]=compute_instab(uwnd,vwnd,hgt,lat,lon,lev,time);
 writenc(yyyy,inert_stab,latdd,londd,lev,time,"lev","inert_stab",savefilepath);
[sym_stab,latdd,londd]=compute_symmetricstab(yyyy,uwnd,vwnd,hgt,lat,lon,lev,time);
 writenc(yyyy,sym_stab,latdd,londd,isk,time,"isk","sym_stab",savefilepath);
clear inert_stab sym_stab
printf("done!\n")
endif
%%%%%%%%% CALCULATE OMEGA TERMS
if strcmp(omegaterms,'yes');printf("Calculating vorticity and temperature advection terms in Omega Equation...")
[DVA,LOTA,latddd,londdd,levd]=compute_omegaterms(uwnd,vwnd,air,hgt,levm,lat,lon,lev,time);
 writenc(yyyy,DVA,latddd,londdd,levd,time,"lev","DVA",savefilepath);
  writenc(yyyy,LOTA,latddd,londdd,levd,time,"lev","LOTA",savefilepath);
  clear LOTA DVA
printf("done!\n")
endif
%%%%%%%%% CALCULATE HORIZONTAL MASS DIVERGENCE FIELD
if strcmp(divergence,'yes');printf("Calculating divergence field...")
[uv_div,latd,lond]=compute_div(uwnd,vwnd,lat,lon);
 writenc(yyyy,uv_div,latd,lond,lev,time,"lev","uv_div",savefilepath);
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
[hrs]=hrssince('20071216',12,'ncep2');
R=DVA(find(levd==250),:,:,find(time==hrs));
G=LOTA(find(levd==850),:,:,find(time==hrs));
B=hgtk_roc(find(isk==309),4:end-3,4:end-3,find(time==hrs));
[rgbvals]=map2rgb(R,G,B,"std");
save -v6 RGB.mat latddd londdd rgbvals

[hrs]=hrssince('20071216',12,'ncep2');
R=DVA(find(levd==250),:,:,find(time==hrs));
G=adiab_wp(find(isk==309),3:end-2,3:end-2,find(time==hrs));
B=hgtk_roc(find(isk==309),4:end-3,4:end-3,find(time==hrs));
[rgbvals]=map2rgb(R,G,B,"none");
save -v6 RGB2.mat latddd londdd rgbvals
endif
%%%%%%%%%% ROUTINES TO PLOT DATA IF WANTED (generally not used much)
plottest="no";
if strcmp(plottest,"yes")
n=1;m=0;
m++;pcolor(lon,lat,squeeze(uwnd(n,:,:,m)));colorbar;

n=2;m=0;
m++;pcolor(lond,latd,squeeze(adiab_wp(n,:,:,m)));colorbar;
endif
