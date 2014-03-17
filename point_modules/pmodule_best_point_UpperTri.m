function [x,y] = pmodule_best_point_UpperTri(output_file,results_idx)
% 	if nargin > 0
		% Load the output output_file to see what points
		% we already have.
		% check to see if this file is actuall empty...
		ftest = dir(output_file);
		if ftest.bytes ~= 0
% 			[x,y] = pmodule_dt_point(output_file);
%         else
        	if nargin < 2
        		results_idx = 1;
        	end

            x = [];
            y = [];
            % Read in all the data
			raw_data = dlmread(output_file,',');
			x_p = raw_data(:,1);
			y_p = raw_data(:,2);
			% We assume that the user has given us which set of data to 
			% investigate when it comes to determine the variation in the
			% chart.
			z_p = raw_data(:,2+results_idx);

			tri = delaunay(x_p,y_p);
			triplot(tri,x_p,y_p);
			ntri = size(tri,1);
			areas  = zeros(ntri,1);
			zrange = zeros(ntri,1);
			P1 = zeros(ntri,2);
			P2 = zeros(ntri,2);
			P3 = zeros(ntri,2);

			% Get the areas and zranges
			for t=1:ntri
				% Get list of triangle vertices
				P1(t,:) = [x_p(tri(t,1)), y_p(tri(t,1))];
				P2(t,:) = [x_p(tri(t,2)), y_p(tri(t,2))];
				P3(t,:) = [x_p(tri(t,3)), y_p(tri(t,3))];
				
				% Calculate triangle area
				areas(t)  = tri_area(P1(t,:),P2(t,:),P3(t,:));

				% Calculate the z-range of each triangle.
				z_1 = z_p(tri(t,1));
				z_2 = z_p(tri(t,2));
				z_3 = z_p(tri(t,3));
				zrange(t) = abs(max([z_1 z_2 z_3]) - min([z_1 z_2 z_3]) );
			end

			% Find the largest quarter percent of triangles
			[~,sorted_order] = sort(areas,'descend');
			top_per = ceil(ntri*0.25);
			largest_tri = tri(sorted_order(1:top_per),:);

			% From this set, find the steepest			
			zrange = zrange(sorted_order(1:top_per));
			[~,best_tri] = max(zrange);		

			% Regenerate the triangle point set from this new subset
			P1 = [x_p(largest_tri(:,1)), y_p(largest_tri(:,1))];
			P2 = [x_p(largest_tri(:,2)), y_p(largest_tri(:,2))];	
			P3 = [x_p(largest_tri(:,3)), y_p(largest_tri(:,3))];	


			% Put a patch on the largest triangle so we can check it 
			hold on;
			triplot(tri,x_p,y_p);
			patch([P1(best_tri,1) P2(best_tri,1) P3(best_tri,1)],...
				  [P1(best_tri,2) P2(best_tri,2) P3(best_tri,2)],'b');			

			% Put a point in the center of this triangle
			x_new = mean([P1(best_tri,1) P2(best_tri,1) P3(best_tri,1)]);
			y_new = mean([P1(best_tri,2) P2(best_tri,2) P3(best_tri,2)]);
            
            x = [x; x_new];
            y = [y; y_new];
			scatter(x_new,y_new,'xr');
			hold off;
			pause(0.1);
	else
		% There is no set of points given, so generate them.
		% The set of corner points...
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
		% Only return these points. The other points must be generated
		% one at a time because the chosen point will depend on the current
		% set of results. 		
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