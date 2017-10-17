function plotrgb(lat,lon,rgbvals,R,G,B)
%
% function plotrgb(lat,lon,rgbvals,R,G,B)
% 
% Plots rgbvals matrix created by map2rgb
% R,G,B are strings describing what each color represents
% i.e. what is defined after line 137 in /home/neil/octave/metdiagnostics.m
% need to addpath with following command for it to work
% addpath('/home/neil/octave/myplotfunctions/')
% plotrgb(latddd,londdd,rgbvals,'PVA','Adiab','Diab')
 close
  n1=size(rgbvals,1);n2=size(rgbvals,2);n3=size(rgbvals,3);
   nlat=length(lat);nlon=length(lon);
    lon=lon';
     rgb=rgbvals./255;
%%%%%%%%%%%%%%%%%%% MAIN PLOTTING LOOP
for lt=0:n1-2
 for ln=0:n2-2
  y=[lat(1)-lt*2.5 lat(1)-lt*2.5 lat(1)-2.5-lt*2.5 lat(1)-2.5-lt*2.5 lat(1)-lt*2.5];
   x=[lon(1)+ln*2.5 lon(1)+2.5+ln*2.5 lon(1)+2.5+ln*2.5 lon(1)+ln*2.5 lon(1)+ln*2.5];
  fvc=[rgb(lt+1,ln+1,1) rgb(lt+1,ln+1,2) rgb(lt+1,ln+1,3)
       rgb(lt+1,ln+2,1) rgb(lt+1,ln+2,2) rgb(lt+1,ln+2,3)
       rgb(lt+2,ln+2,1) rgb(lt+2,ln+2,2) rgb(lt+2,ln+2,3)
       rgb(lt+2,ln+1,1) rgb(lt+2,ln+1,2) rgb(lt+2,ln+1,3)
       rgb(lt+1,ln+1,1) rgb(lt+1,ln+1,2) rgb(lt+1,ln+1,3)];
  verts=[x' y'];
   f=[1 2 3 4 5];
%    fvc=rgb2hsv(fvc);
    patch('Vertices',verts,'Faces',f,'FaceVertexCData',fvc,'FaceColor','interp','EdgeColor','interp')
 end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gca,'XLim',[lon(1) lon(end)]);
set(gca,'YLim',[lat(end) lat(1)]);
hold on;
[lon1,lon2,lat1,lat2]=plotcoast(lon(1),lon(end),lat(1),lat(end));hold on;
load /home/neil/data/Topo/southernafrica_political.mat
h=plot(sapolon,sapolat,'w');;set(h,'color','w');set(h,'linewidth',[1.5]);hold on;
set(gca,'XTick',[10:5:65]);
%%%%%%%%%%%%%%%%%%% CREATION AND PLOTTING OF COLOR LEGEND/KEY
key='no';
if strcmp(key,'yes')
latoffset=lat(end)-22;
 lonoffset=lon(end)-22-11;
  k=0.144338;
   scalefactor=30;
  x=[0 0.25 0.5 0.25 0.5 0.75 0.5 1 0.75 0.5].*scalefactor;x=x+lonoffset;
   y=[0 0.5 0 k 1 0.5 0.5+k 0 k 0.5-k].*scalefactor;y=y+latoffset;
%%%%SIMPLE TRIANGLE
%x=[0+lonoffset 9+lonoffset 18+lonoffset];
%y=[0+latoffset 18+latoffset 0+latoffset];
%f=[1 2 3];
%fvc=[1 0 0;0 1 0;0 0 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%COMPLEX TRIANGLE
f=[1 2 4 1;2 4 3 2;1 4 3 1;2 5 7 2;5 6 7 5;2 7 6 2;6 3 9 6;6 8 9 6;3 9 8 3;2 3 10 2;2 6 10 2;3 10 6 3];
fvc=[1 0 0;0 0 1;0 1 0;0.25 0.25 0.25;0 1 0;1 0 0;0.5 0.5 0.5;0 0 1;0 0 0;0.8 0.8 0.8];
v=[x' y'];
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% OCTAGON
idv=[2 3 4 6 7 9 10];f=[1 2 3 2;1 5 4 1;4 2 6 4;1 2 7 1;1 4 7 1;2 7 4 2];
v=v(idv,:);v(:,2)=v(:,2)+1.5;
fvc(4,:)=[0.25 0.25 0.25];fvc(7,:)=[0.25 0.25 0.25];fvc(9,:)=[0.25 0.25 0.25];
fvc=fvc(idv,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fvc=rgb2hsv(fvc);
patch('Vertices',v,'Faces',f,'FaceVertexCData',fvc,'FaceColor','interp','EdgeColor','interp')
hold on
[lon1,lon2,lat1,lat2]=plotcoast(lon(1),lon(end),lat(1),lat(end));
%text(x(1)-6.5,y(1)+1,R,'FontWeight','bold');
%text(x(2)+0.5,y(2),G,'FontWeight','bold');
%text(x(3),y(3)+1,B,'FontWeight','bold');

text(x(2)-3.5,y(2)+1,B,'FontWeight','bold');
text(x(3)-2,y(3)+0.5,G,'FontWeight','bold');
text(x(6)+0.5,y(6)+1,R,'FontWeight','bold');
grid;
set(gca,'XLim',[lon(1) lon(end)]);
set(gca,'YLim',[latoffset-1 lat(1)-1]);
end

% title(['Contribution to uplift forcing by ','PVA',', ','Adiabatic Advection',' & ','Diabatic',' Factors '],'FontWeight','bold','FontSize',[11])
