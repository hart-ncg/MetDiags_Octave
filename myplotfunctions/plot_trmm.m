function plot_trmm(lnmn,lnmx,ltmx,ltmn,day)
# plot_trmm.m

close all;
#load /home/neil/data/daily/trmm/dailytt_YEARMM.mat
load /home/neil/data/daily/trmm/dailytt_200712.mat
#day=13;
#ltmn=-35.125;
#ltmx=-22.125;
#lnmn=17.125;
#lnmx=33.125;
    ilt1=find(round(lat2)==ltmx);ilt1=ilt1(1);
    ilt2=find(round(lat2)==ltmn);ilt2=ilt2(1);
    iln1=find(round(lon2)==lnmn);iln1=iln1(1);
    iln2=find(round(lon2)==lnmx);iln2=iln2(1);
    
    subset=dailytotal(ilt1:ilt2,iln1:iln2,day);
    lat=lat2(ilt1:ilt2);
    lon=lon2(iln1:iln2);
for i=1:size(subset,1)
  ix=find(subset(i,:) == 0);
  subset(i,ix)=NaN;
endfor

#save -v6 selectdays.mat lat lon subset

plotcoast(lnmn,lnmx,ltmx,ltmn);hold on;
pcolor(lon,lat,subset);
caxis([0 100])
shading interp;
colormap('cool');
title(['TRMM DAILY RAINFALL ',num2str(day),'DEC2007'])
colorbar

print([num2str(day),'DEC2007_trmm.png'],'-dpng');
endfunction

