function [datestring,datenumeric]=datehrssince(data,hrs);
%
%function [datestring,datenumeric]=datehrssince(data,hrs);
% returns date given hours since 1800-01-01 00:00 (data='ncep2')
% returns date given hours since 0000-01-01 00:00 (data='olr')
% datestring is a string as 'yyyy-mm-dd HH:MM:SS'
% datenumeric is an array as [yyyy mm dd hh];
%

if strcmp(data,'ncep2') | strcmp(data,'1800')
 d=hrs./24+datenum(1800,01,01,00,0,0);
end

if strcmp(data,'olr') | strcmp(data,'0000')
 d=(hrs-17298624)./24 + datenum(1974,6,1,00,0,0);
end

 date=datestr(d,31);
  yyyy=date(:,1:4);mm=date(:,6:7);dd=date(:,9:10);hh=date(:,12:13);
  
datestring=[yyyy,mm,dd,repmat('_',[size(yyyy,1) 1]),hh];
datenumeric=[str2num(yyyy) str2num(mm) str2num(dd) str2num(hh)];