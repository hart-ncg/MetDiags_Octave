# class_dist.m

# function [clsdst]=class_dist(clsnos,clsdates)


[lat,lon,time,olr]=olrnc2matrix('/home/neil/data/daily/olr/olr.NDJF.700mb_subset1.nc');
load /home/neil/work/clusters/cluster_nos
load /home/neil/work/clusters/cluster_dates.csv

nos=cluster_nos;
dates=cluster_dates;

data=reshape(olr,length(time),length(lat)*length(lon));

# Create centroids
for i=1:7
 ix=find(nos==i);
   xmean(i,:)=mean(data(ix,:),1);
endfor
centroids=reshape(xmean,[7 length(lat) length(lon)]);
 save -v6 centroids.mat centroids

for i=1:7
 id=find(nos==i);
  clsdata=data(id,:);
   xm=repmat(xmean(i,:),[length(id) 1]);
    dif=clsdata-xm;
    dif2=sqrt(dif.*dif);
   sqrddist{i}=sum(dif2,2);
endfor
save -v6 sqrddist_OLR_nic.mat sqrddist nos dates

clear all

load sqrddist_OLR_nic.mat

nclass=7;
for icl=1:nclass
  dst=sqrddist{icl};
        subplot(ceil(nclass/2),2,icl);
         hist(dst*10e-9,20)
endfor

print '-depsc' nics_cls_dst.eps