function [S,N] = view_dd_successrate(filename,res,specific_result,threshold)
    raw_data=dlmread(filename,',');
    x = raw_data(:,1);
    y = raw_data(:,2);
    
    rdim = size(raw_data,2) - 3;
    results = raw_data(:,2+specific_result);
     
    
    % Set the y-dom and x-dom
    xdom = linspace(0,1,res);
    ydom = linspace(0,1,res);
    d = xdom(2) - xdom(1);
    [XX,YY] = meshgrid(xdom,ydom);

    S = zeros(res);
    N = zeros(res);

    
    % Scan over all the possibile bins
    for i=1:res
        for j=1:res
            % Do any points exist in this bin?
            xv = [xdom(i) xdom(i)   xdom(i)+d xdom(i)+d];
            yv = [ydom(j) ydom(j)+d ydom(j)+d ydom(j)];
            points_in = inpolygon(x,y,xv,yv);

            % Count the number in this bin
            n = sum(points_in);
            N(j,i) = n;

            % And from here, how many succeses do we have?
            bin_pts_x = x(points_in);
            bin_pts_y = y(points_in);
            bin_vals  = results(points_in);

            if n > 0
                S(j,i) = sum(bin_vals > threshold) ./ n;
            else
                S(j,i) = nan;
            end
        end
    end