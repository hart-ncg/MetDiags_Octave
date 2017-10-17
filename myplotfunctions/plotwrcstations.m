clear all
close all
%load /home/neil/data/Topo/satopo.mat
load /home/neil/data/Topo/southernafrica_political.mat
load /home/neil/work/wrc/ndjftotals_wrc.mat

lnmn=10;lnmx=55;
 ltmn=-40;ltmx=-10;
 [m,il(1)]=min(abs(ltmn-lat));
 [m,il(2)]=min(abs(ltmx-lat));
 [m,il(3)]=min(abs(lnmn-lon));
 [m,il(4)]=min(abs(lnmx-lon));

%lat=lat(il(1):il(2));
%lon=lon(il(3):il(4));
%topo=topo(il(1):il(2),il(3):il(4));
 %topo=reshape(topo,[length(lat)*length(lon) 1]);
%  ix=find(topo<0);topo(ix)=NaN;
   %topo=reshape(topo,[length(lat) length(lon)]);
%colormap('jet')
%pcolor(lon,lat,topo);shading interp;
scatter(lon,lat,6,[.5 .5 .5],'.');
hold on;
%h=colorbar;set(h,'FontSize',[12],'FontWeight','bold');
plot(sapolon,sapolat,'k');
set(gca,'XLim',[lnmn lnmx]);set(gca,'YLim',[ltmn ltmx]);set(gca,'FontSize',[16],'FontWeight','bold');
set(gca,'XTick',[lnmn:5:lnmx]);set(gca,'YTick',[ltmn:5:ltmx]);
box on;
h=text(17,-30,'SOUTH AFRICA');set(h,'FontSize',[10],'FontWeight','bold');
%h=text(26,-30,'LESOTHO');set(h,'FontSize',[10],'FontWeight','bold');set(h,'Color','b');
h=text(14,-20,'NAMIBIA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(15,-13,'ANGOLA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(23,-15,'ZAMBIA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(21,-22,'BOTSWANA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(26,-19,'ZIMBABWE');set(h,'FontSize',[10],'FontWeight','bold');
h=text(32,-23,'MOZAMBIQUE');set(h,'FontSize',[10],'FontWeight','bold');
h=text(45,-20,'MADAGASCAR');set(h,'FontSize',[10],'FontWeight','bold');
h=text(26,-29.5,'LESOTHO');set(h,'FontSize',[10],'FontWeight','bold');
print(['southernafrica','.eps'],'-depsc');
print(['southernafrica','.png'],'-dpng');