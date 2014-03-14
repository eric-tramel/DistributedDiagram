clear;

res         = 100;                            % Resolution of the itnerpolation 
rtv         = 2;                              % Specify which result to view
experiments = 200;
output_file = 'test.dd';

run_dd(experiments,...                        % The number of experiments to run
       output_file,...                        % Where to save the results to
       @(N_) pmodule_uniform01(N_),...        % Specify the point-generation module
       @dd_foo);                              % The meat-and-potatoes experiment function   



raw_results = dlmread(output_file,',');
total_experiments = size(raw_results,1);

figure(1); clf;
subplot(1,2,1);
    [X,Y] = meshgrid(linspace(0,1,res),linspace(0,1,res));
    Z = dd_foo(X,Y);
    surf(X,Y,Z(:,:,rtv),'EdgeColor','none');
    title('Original Function');
    view(2);
subplot(1,2,2);
    view_dd(output_file,...                       % View the interpolated results
            100, ...                              % Resolution of the interpolation 
            rtv);                                   % Which result to display
    title('Interpolated from Random Experiments');
    xlabel(sprintf('%d Experiments',total_experiments));
    view(2);