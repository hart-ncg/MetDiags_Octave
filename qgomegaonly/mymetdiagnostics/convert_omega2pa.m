function [wp]=convert_omega2pa(omega,air,levm);
%
% function [wp]=convert_omega2pa(omega,air,levm);
% 
% Converts vertical velocity in m/s to Pa/s
R=287;
g=9.81;


wp=-g.*R.*air.*omega./levm;