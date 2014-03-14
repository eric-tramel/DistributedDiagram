function res = dd_foo(x,y)
% DD_FOO A tiny example function for demonstrating the use of the
% DistributedDiagram package.
%
% dd_foo(x,y)   Return two results as a function of x and y.
if isscalar(x)
	res(1) = sin(5.*x) + sin(7.*y);
	res(2) = sin(5.*x) > sin(7.*y);
else
	if isvector(x)
		res(:,1) = sin(5.*x) + sin(7.*y);
		res(:,2) = sin(5.*x) > sin(7.*y);
	else
		res(:,:,1) = sin(5.*x) + sin(7.*y);
		res(:,:,2) = sin(5.*x) > sin(7.*y);
	end
end