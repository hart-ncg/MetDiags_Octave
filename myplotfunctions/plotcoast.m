function [lon1,lon2,lat1,lat2]=plotcoast(lon1,lon2,lat1,lat2);

% Plots coast for given region, then to be overlayed with subsequent plots

load /home/neil/octave/m_coasts.mat
data=ncst;
lon1=lon1;%-2;
lon2=lon2;%+2;
lat1=lat1;%+2;
lat2=lat2;%-2;

iln2nan=find(data(:,1) < lon1 | data(:,1) > lon2  );
    data(iln2nan,:)=NaN;

ilt2nan=(data(:,2) > lat1 | data(:,2) < lat2 );
    data(ilt2nan,:)=NaN;
i=isnan(data(:,1));
%i1=min(data(:,1));
%i2=max(data(:,1));
i=find(i==0);
%x=data(i1:i2,:);
subset=data(i(1):i(end),:);
x=subset;
%[s,i]=sort(subset);
%x=subset(i(1),:);

h=plot(x(:,1),x(:,2));set(h,'color','w');set(h,'linewidth',[1.5]);
%axis("square");

