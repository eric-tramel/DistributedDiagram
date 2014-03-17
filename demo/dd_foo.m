function res = dd_foo(x,y)
% DD_FOO A tiny example function for demonstrating the use of the
% DistributedDiagram package.
%
% dd_foo(x,y)   Return two results as a function of x and y.

a = 10;
b = 30;
if isscalar(x)
	res(1) = sin(a.*x) + sin(b.*y);
	res(2) = sin(a.*x) > sin(b.*y);
else
	if isvector(x)
		res(:,1) = sin(a.*x) + sin(b.*y);
		res(:,2) = sin(a.*x) > sin(b.*y);
	else
		res(:,:,1) = sin(a.*x) + sin(b.*y);
		res(:,:,2) = sin(a.*x) > sin(b.*y);
	end
end