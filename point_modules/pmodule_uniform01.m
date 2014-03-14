function [x,y] = pmodule_uniform01(N)
% Uniformly random points on X:[0,1],Y:[0,1]
if nargin == 1
    x = rand(N,1);
    y = rand(N,1);
else
    x =  rand(1);
    y = rand(1);
end