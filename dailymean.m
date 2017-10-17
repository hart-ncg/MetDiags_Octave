%%% Script for meaning ttt event data, based on stuff in metdiagnostics script
%yyyymmdd="STARTDATE";
%  yyyymmdd="19880218";
% yyyymmdd="20071214";
% yyyymmdd="19971230";
% yyyymmdd="19980101";
yyyy=str2num(substr(yyyymmdd,1,4));mm=str2num(substr(yyyymmdd,5,2));dd=str2num(substr(yyyymmdd,7,2));
%%%% SCRIPT PARAMETERS
loadfilepath_P='/home/neil/data/6hourly/';
loadfilepath_K='/home/neil/data/daily/isentropic/';
savefilepath='/home/neil/data/daily/';

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

writenc(yyyy,air,lat,lon,lev,time,"lev","air",[savefilepath,"air/"]);
writenc(yyyy,hgt,lat,lon,lev,time,"lev","hgt",[savefilepath,"hgt/"]);
writenc(yyyy,uwnd,lat,lon,lev,time,"lev","uwnd",[savefilepath,"uwnd/"]);
writenc(yyyy,vwnd,lat,lon,lev,time,"lev","vwnd",[savefilepath,"vwnd/"]);
writenc(yyyy,rhum,lat,lon,lev,time,"lev","rhum",[savefilepath,"rhum/"]);
writenc(yyyy,omega,lat,lon,lev,time,"lev","omega",[savefilepath,"omega/"]);
