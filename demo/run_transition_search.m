function run_transition_search(output_,test_module,nY,nTrials)
	% Were we given a fid or a file name path?
	if ischar(output_)
	    if exist(output_,'file')
	        % Append Mode
	        output_fid = fopen(output_,'a');
	    else
	        % New file
	        output_fid = fopen(output_,'w');
	    end
	else
	    output_fid = output_;
	end


	% Simplest approach -- Linear over the range of y
	y = linspace(0.01,1,nY);

	for i=1:nY
		y_ = y(i);
		x_ = transition_search(test_module,1e-3,y_,10,nTrials);

		% Now we just need to record that data
		fprintf(output_fid,'%0.5e,%0.5e\n',x_,y_);
	end


	% Other approach: using the stored results
