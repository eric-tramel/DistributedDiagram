clear;

res         = 50;                            % Resolution of the itnerpolation 
rtv         = 1;                              % Specify which result to view
experiments = 60;
output_file = 'test.dd';

% Set up the DT module
% pmodule = @(N_) pmodule_dt_point_UpperTri(N_,output_file);
pmodule = @(x_) pmodule_best_point('test.dd',rtv);


run_dd(experiments,...                        % The number of experiments to run
       output_file,...                        % Where to save the results to
       pmodule,...                            % Specify the point-generation module
       @dd_foo);                              % The meat-and-potatoes experiment function   


raw_results = dlmread(output_file,',');
total_experiments = size(raw_results,1);

figure(1); clf;
subplot(1,3,1);
    [X,Y] = meshgrid(linspace(0,1,res),linspace(0,1,res));
    Z = dd_foo(X,Y);
    surf(X,Y,Z(:,:,rtv),'EdgeColor','none');
    title('Original Function');
    view(2);
subplot(1,3,2);
    view_dd(output_file,...                       % View the interpolated results
            100, ...                              % Resolution of the interpolation 
            rtv);                                   % Which result to display
    title('Interpolated from Random Experiments');
    xlabel(sprintf('%d Experiments',total_experiments));
    view(2);
subplot(1,3,3);
    tri = delaunay(raw_results(:,1),raw_results(:,2));
    trisurf(tri,raw_results(:,1),raw_results(:,2),raw_results(:,3));
    view(2);