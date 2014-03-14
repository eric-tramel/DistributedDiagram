function [x,y] = pmodule_uniform01_UpperTri(N)
% Uniformly random points on X:[0,1],Y:[0,1], Y > X
if nargin == 1
    x = rand(N,1);
    y = rand(N,1);
    goodidx = y > x;    
    while sum(goodidx) < N
        x(~goodidx) = rand(sum(~goodidx),1);
        y(~goodidx) = rand(sum(~goodidx),1);
        goodidx = y > x;
    end    
else    
    x = rand(1);    
    y = rand(1);
    while y < x
        x = rand(1);    
        y = rand(1);
    end
end