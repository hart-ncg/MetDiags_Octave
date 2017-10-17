function [hrs]=hrssince(data,varargin)
%
%function [hrs]=hrssince(data,yyyymmdd_hh) or (data,yyyy,mm,dd,hh)
%returns hours since 1800-01-01 00:00 (ncep2/1800)
%returns hours since 0000-01-01 00:00 (olr/0000)
%primarily used to obtain hournum in ncep2 data
%or OLR
%Usage: (1) ensure "yyyymmdd_hh" is used so that it is a string
%       (2) define dataset in data: "olr | 0000" "ncep2 | 1800"

 if  length(varargin) == 1;
   yyyymmdd_hh=varargin{1};
    yyyy=str2num(yyyymmdd_hh(:,1:4));mm=str2num(yyyymmdd_hh(:,5:6));dd=str2num(yyyymmdd_hh(:,7:8));hh=str2num(yyyymmdd_hh(:,10:11));
  elseif length(varargin) == 4;
     yyyy=varargin{1};mm=varargin{2};dd=varargin{3};hh=varargin{4};
   else
      disp('ERROR in hrssince usage: number of arguments not accepted: 1 string (yyyymmdd_hh) or 4 numbers (yyyy,mm,dd,hh)')  
    return;
  end

%yyyy=str2num(yyyymmdd_hh(1:4));mm=str2num(yyyymmdd_hh(5:6));dd=str2num(yyyymmdd_hh(7:8));hh=str2num(yyyymmdd_hh(10:11));

if strcmp(data,'ncep2') | strcmp(data,'1800')
 hrs=24.*(datenum(yyyy,mm,dd,hh,0,0)-datenum(1800,01,01,00,0,0));
end

if strcmp(data,'olr') | strcmp(data,'0000')
 hrs=17298624+24.*(datenum(yyyy,mm,dd,hh,0,0)-datenum(1974,6,1,00,0,0));
end