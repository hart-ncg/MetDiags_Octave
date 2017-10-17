clear all
close all
load /home/neil/data/Topo/satopo.mat
load /home/neil/data/Topo/southernafrica_political.mat

lnmn=10;lnmx=55;
 ltmn=-40;ltmx=-10;
 [m,il(1)]=min(abs(ltmn-lat));
 [m,il(2)]=min(abs(ltmx-lat));
 [m,il(3)]=min(abs(lnmn-lon));
 [m,il(4)]=min(abs(lnmx-lon));

lat=lat(il(1):il(2));
lon=lon(il(3):il(4));
topo=topo(il(1):il(2),il(3):il(4));
 %topo=reshape(topo,[length(lat)*length(lon) 1]);
  ix=find(topo<0);topo(ix)=NaN;
   %topo=reshape(topo,[length(lat) length(lon)]);
%colormap('jet')
pcolor(lon,lat,topo);shading interp;
hold on;
h=colorbar;set(h,'FontSize',[12],'FontWeight','bold');
plot(sapolon,sapolat,'k');
set(gca,'XLim',[lnmn lnmx]);set(gca,'YLim',[ltmn ltmx]);set(gca,'FontSize',[16],'FontWeight','bold');
set(gca,'XTick',[lnmn:5:lnmx]);set(gca,'YTick',[ltmn:5:ltmx]);
box on;
h=text(20,-28,'SOUTH AFRICA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(26,-30,'LESOTHO');set(h,'FontSize',[10],'FontWeight','bold');
h=text(14,-20,'NAMIBIA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(15,-13,'ANGOLA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(23,-15,'ZAMBIA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(21,-22,'BOTSWANA');set(h,'FontSize',[10],'FontWeight','bold');
h=text(26,-19,'ZIMBABWE');set(h,'FontSize',[10],'FontWeight','bold');
h=text(35,-15,'MOZAMBIQUE');set(h,'FontSize',[10],'FontWeight','bold');
h=text(45,-20,'MADAGASCAR');set(h,'FontSize',[10],'FontWeight','bold');
print(['southernafrica','.eps'],'-depsc');
%print(['southernafrica','.png'],'-dpng');


doit='no';
if strcmp(doit,'yes')
load /home/neil/data/Topo/worldhi.mat
lat=SouthAfrica.lat(:);
lon=SouthAfrica.long(:);
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Zimbabwe.lat(:)];
lon=[lon;Zimbabwe.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Zambia.lat(:)];
lon=[lon;Zambia.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Namibia.lat(:)];
lon=[lon;Namibia.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Botswana.lat(:)];
lon=[lon;Botswana.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Tanzania.lat(:)];
lon=[lon;Tanzania.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Angola.lat(:)];
lon=[lon;Angola.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Kenya.lat(:)];
lon=[lon;Kenya.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Mozambique.lat(:)];
lon=[lon;Mozambique.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Malawi.lat(:)];
lon=[lon;Malawi.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Lesotho.lat(:)];
lon=[lon;Lesotho.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Swaziland.lat(:)];
lon=[lon;Swaziland.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;CongoDemocraticRepublicoftheFor.lat(:)];
lon=[lon;CongoDemocraticRepublicoftheFor.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Madagascar.lat(:)];
lon=[lon;Madagascar.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;CongoRepublicofthe.lat(:)];
lon=[lon;CongoRepublicofthe.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Gabon.lat(:)];
lon=[lon;Gabon.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Burundi.lat(:)];
lon=[lon;Burundi.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Rwanda.lat(:)];
lon=[lon;Rwanda.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;Uganda.lat(:)];
lon=[lon;Uganda.long(:)];
lat(end+1)=NaN;
lon(end+1)=NaN;
lat=[lat;EquatorialGuinea.lat(:)];
lon=[lon;EquatorialGuinea.long(:)];
sapolon=lon;
sapolat=lat;
save southernafrica_political.mat sapolon sapolat
end