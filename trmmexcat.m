# trmmexcat.m trmm extract and concatenator for octave
# Currently implemented for daily accumulated rainfall
#    one file per month
clear all
trmmdata='/home/neil/data/daily/trmm/';
# Region to extract
# This boxes essentially extracts South Africa only
region='southernafrica'
switch region
#switch 'sa'
case 'sa'
ltmn=-35.125;
ltmx=-22.125;
lnmn=17.125;
lnmx=33.125;
# This box does southern african sector
case 'southernafrica'
ltmn=-49.125;
ltmx=-0.125;
lnmn=0.125;
lnmx=70.125;
end

trmm=[];
tic()
for yr=1998:2007
printf(['Getting data for ',num2str(yr),'...'])
  for m=1:12
    if m<10
     load('-v7',[trmmdata,'dailytt_',num2str(yr),'0',num2str(m),'.mat']);
      else
       load('-v7',[trmmdata,'dailytt_',num2str(yr),num2str(m),'.mat']);
    endif

    ilt1=find(lat2==ltmx);
    ilt2=find(lat2==ltmn);
    iln1=find(lon2==lnmn);
    iln2=find(lon2==lnmx);

      subset=dailytotal(ilt1:ilt2,iln1:iln2,:);
      sztr=size(trmm,3);szss=size(subset,3);
         trmm(:,:,sztr+1:sztr+szss)=subset;
            lat=lat2(ilt1:ilt2);lon=lon2(iln1:iln2);
     clear lat2 lon2 dailytotal subset
  endfor
    time=[hrssince([num2str(yr),'0101'],00,'ncep2'):24:hrssince([num2str(yr),'1231'],00,'ncep2')];
     trmm(:,:,1)=[];
   writenc(yr,trmm,lat,lon,1000,time,"pres","trmm",trmmdata);
  save('-v6',[trmmdata,'trmm_',region,num2str(yr),'.mat'],'lat','lon','trmm','time');
 trmm=[];
printf("done.\n")
endfor
toc()
#trmmAll(:,:,1)=[];
#trmm4xd=permute(trmmAll,[3 1 2]);
#trmm4xd=reshape(trmm4xd,size(trmm4xd,1),size(trmm4xd,2)*size(trmm4xd,3));
#trmm4xd=permute(trmm4xd,[2 1]);
#time=datenum(1998,1,1):datenum(2007,12,31);
#timestr=datestr(time,[29]);
#time=timestr;clear timestr