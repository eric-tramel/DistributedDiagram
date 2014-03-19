function [x_trans, y_trans]= transition_search(test_module,threshold,y_,N_,trials_)
	% TRANSITION_SEARCH For a given y value, find the x value where
	%	the results cross the specified threshold.
	%
	% x_trans = transition_search(test_module,treshold,y)
	%		Will run the test sepcified by the function handle `test_module` at 
	%		fixed location `y` and search over a set of `x` to find the one 
	%		closest to the specified `threshold`. By default, 10 points will
	%		be attempted.
	%
	% x_trans = transition_search(test_module,threshold)
	%		The same as above, but without the specified y, instead the test will
	%		be run over 10 values of y.
	%
	% x_trans = transition_search(test_module,treshold,y,N)
	%		Same as above, but the search will stop after N iterations.

	%% Default Values
	trials = 5;	
	N = 6;
	nY = 10;
	mindx = 1e-4;

	%% Input Handling
	if nargin < 3
		% In this case, lets make a recursive call
		y = linspace(0.01,1,nY);
		for i = 1:nY
			[x_trans(i), y_trans(i)] = transition_search(test_module,threshold,y(i));
			plot(x_trans,y_trans,'-.k','LineWidth',2);
		end		
		return;
	else
		y = y_;
	end
	
	if nargin > 3
		N = N_;
    end
    
	if nargin > 4
		trials = trials_;
    end
    
    
    figure(1); 
    hold on;
    spcurve = load('Spinodal_replica.txt');
    plot(spcurve(:,2),spcurve(:,1),'-k','LineWidth',2);
	
    %% Main Search Loop
    y_trans = y;
	x_trans = y./2;				% Beginning halfway between 0 and the optimal.
	dx = y./4;
	for t=1:N
		if dx < mindx
			% If we are less than the smallest possibile dx we are done
			break;
		end
		successes = 0;
		fails = 0;

		% Run the experiment for the specified number of trials
		for i=1:trials
			result = test_module(x_trans,y);			
			test_result = result < threshold;		% A "positive" result if we are below the threshold
			if test_result
				successes = successes + 1;
			else
				fails = fails + 1;
			end
		end

		% Determine the update on x
		if successes > fails
			% Success: Step towards the difficult region
			scatter(x_trans,y,'bo','filled');
            x_trans = x_trans + dx;
			dx = dx ./ 2;            
		else			
			if successes == fails
				% Undetermined: Needs more testing. Increase the number of trials and run again.
				trials = trials + 1;
			else
				% Failure: Step towards the easier region
				scatter(x_trans,y,'ro','filled');
                x_trans = x_trans - dx;
				dx = dx ./ 2;                
			end
        end
        
        axis([0 1 0 1]); grid on;box on;
        pause(0.1);        
	end

