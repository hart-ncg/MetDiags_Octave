function [var]=ncep2big_nan(var);

nd=ndims(var);

dim1=size(var,1);
dim2=size(var,2);
dim3=size(var,3);
dim4=size(var,4);

var=reshape(var,[dim1*dim2*dim3*dim4 1]);

inan=find(var > 1e05);var(inan)=NaN;

var=reshape(var,[dim1 dim2 dim3 dim4]);

endfunction
