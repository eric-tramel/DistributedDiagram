function [x,y] = pmodule_dt_point_UpperTri(N,output_file)
	if nargin > 1
		% Load the output output_file to see what points
		% we already have.
		ftest = dir(output_file);
		if ftest.bytes == 0
			[x,y] = pmodule_dt_point_UpperTri(N);
        else
        	x = [];
        	y = [];
			raw_data = dlmread(output_file,',');
			x_p = raw_data(:,1);
			y_p = raw_data(:,2);
			for i=1:N
				tri = delaunay(x_p,y_p);
				% triplot(tri,x,y);
				ntri = size(tri,1);
				areas = zeros(ntri,1);
				P1 = zeros(ntri,2);
				P2 = zeros(ntri,2);
				P3 = zeros(ntri,2);

				% Get the areas
				for t=1:ntri
					P1(t,:) = [x_p(tri(t,1)), y_p(tri(t,1))];
					P2(t,:) = [x_p(tri(t,2)), y_p(tri(t,2))];
					P3(t,:) = [x_p(tri(t,3)), y_p(tri(t,3))];
					areas(t) = tri_area(P1(t,:),P2(t,:),P3(t,:));
				end

				% Find the largest
				[~,max_tri] = max(areas);

				% Put a patch on the largest triangle so we can check it 
				% hold on;
				% triplot(tri,x,y);
				% patch([P1(max_tri,1) P2(max_tri,1) P3(max_tri,1)],...
				% 	  [P1(max_tri,2) P2(max_tri,2) P3(max_tri,2)],'b');			

				% Put a point in the center of this triangle
				x_new = mean([P1(max_tri,1) P2(max_tri,1) P3(max_tri,1)]);
				y_new = mean([P1(max_tri,2) P2(max_tri,2) P3(max_tri,2)]);
				% scatter(x_new,y_new,'xr');
				% hold off;

				x = [x; x_new];
				y = [y; y_new];
				x_p = [x_p; x_new];
				y_p = [y_p; y_new];
				% pause(0.1);
			end
		end
	else
		% There is no set of points given, so generate them.
		% The set of corner points...
		% Square corner points

		% Upper triangular points
		x = [0.001; 0.001; 0.999];
		y = [0.001; 0.999; 0.999];

		% Now a random point...Make sure it is above
		x(end+1) = rand(1);
		y(end+1) = rand(1);
		while y(end) < x(end)
			x(end) = rand(1);
			y(end) = rand(1);
		end
		

		% Now, we generate the rest of the points.
		for i=1:(N-4)
			tri = delaunay(x,y);
			% triplot(tri,x,y);
			ntri = size(tri,1);
			areas = zeros(ntri,1);
			P1 = zeros(ntri,2);
			P2 = zeros(ntri,2);
			P3 = zeros(ntri,2);

			% Get the areas
			for t=1:ntri
				P1(t,:) = [x(tri(t,1)), y(tri(t,1))];
				P2(t,:) = [x(tri(t,2)), y(tri(t,2))];
				P3(t,:) = [x(tri(t,3)), y(tri(t,3))];
				areas(t) = tri_area(P1(t,:),P2(t,:),P3(t,:));
			end

			% Find the largest
			[~,max_tri] = max(areas);

			% Put a patch on the largest triangle so we can check it 
			% hold on;
			% triplot(tri,x,y);
			% patch([P1(max_tri,1) P2(max_tri,1) P3(max_tri,1)],...
			% 	  [P1(max_tri,2) P2(max_tri,2) P3(max_tri,2)],'b');			

			% Put a point in the center of this triangle
			x_new = mean([P1(max_tri,1) P2(max_tri,1) P3(max_tri,1)]);
			y_new = mean([P1(max_tri,2) P2(max_tri,2) P3(max_tri,2)]);
			% scatter(x_new,y_new,'xr');
			% hold off;

			x(end+1) = x_new;
			y(end+1) = y_new;
			% pause(0.00001);
		end
	end


%% ----- Helper Functions
function A = tri_area(P1, P2, P3)
% A = tri_area(P1, P2, P3)
%
% DESC:
% calculates the triangle area given the triangle vertices (using Heron's
% formula)
%
% AUTHOR
% Marco Zuliani - zuliani@ece.ucsb.edu
%
% VERSION:
% 1.0
%
% INPUT:
% P1, P2, P3 = triangle vertices
%
% OUTPUT:
% A          = triangle area

u1 = P1 - P2;
u2 = P1 - P3;
u3 = P3 - P2;

a = norm(u1);
b = norm(u2);
c = norm(u3);

% Stabilized Heron formula
% see: http://http.cs.berkeley.edu/%7Ewkahan/Triangle.pdf
%
% s = semiperimeter
% A = sqrt(s * (s-a) * (s-b) * (s-c))

% sort the elements
v = sort([a b c]);
a = v(3);
b = v(2);
c = v(1);

temp = b + c;
v1 = a + temp;
temp = a - b;
v2 = c - temp;
v3 = c + temp;
temp = b - c;
v4 = a + temp;
A = 0.25 * sqrt(v1*v2*v3*v4);