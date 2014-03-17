function res = dd_foo2(x,y)
% DD_FOO A tiny example function for demonstrating the use of the
% DistributedDiagram package.
%
% dd_foo(x,y)   Return two results as a function of x and y.

a = 0;
b = 100;
if isscalar(x)
	res(1) = sin(a.*x) + tanh(b.*(y-0.5));
	res(2) = sin(a.*x) > tanh(b.*(y-0.5));
else
	if isvector(x)
		res(:,1) = sin(a.*x) + tanh(b.*(y-0.5));
		res(:,2) = sin(a.*x) > tanh(b.*(y-0.5));
	else
		res(:,:,1) = sin(a.*x) + tanh(b.*(y-0.5));
		res(:,:,2) = sin(a.*x) > tanh(b.*(y-0.5));
	end
end