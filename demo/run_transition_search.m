function run_transition_search(output_,test_module,nY,nTrials)
	% Does this file already exist?
    if exist(output_,'file')
        % Append Mode
        output_fid = fopen(output_,'a');
        original_curve = dlmread(output_,',');

		% Other approach: using the stored results. We want to 
		% add in new points into the middle of the largest gaps
		% between the points and the [0,1] boundaries.
		% 
    	tested_y = original_curve(:,2);
    	y = [];
    	for i=1:nY
	    	all_y = sort([tested_y; y; 0; 1 ],'ascend');
			gaps_y = diff(all_y);
			[~,max_gap] = max(gaps_y);
			% Append the new value to the list
			y(end+1) = (all_y(max_gap) + all_y(max_gap+1))/2;
			y = y(:);
    	end		
    else
        % New file
        output_fid = fopen(output_,'w');

    	% Simplest approach -- Linear over the range of y
		y = linspace(0.01,1,nY);
    end



    % Run the transition search over the set of y to test.
	for i=1:nY
		y_ = y(i);
		x_ = transition_search(test_module,1e-3,y_,6,nTrials);

		% Now we just need to record that data
		fprintf(output_fid,'%0.5e,%0.5e\n',x_,y_);
	end
