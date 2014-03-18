function result = dd_amp_module(x,y)
% A Test module for the transition search function. Requires that the 
% FreeOpt Eric-Scratch branch be on the path.
N = 2048;
M = round(N*y);
delta = 1e-8;	% Noise Variance

% Using the GB prior
gb_rho  = x;
gb_mean = 0;
gb_var  = 1;

%% Set moment and partition functions
partition_func = @(r_,s_) gb_partition(r_,s_,gb_mean,gb_var,gb_rho);
moment_func = @(r_,s_,z_) factorized_moments_gaussbernoulli_quick(r_,s_,gb_mean,gb_var,z_);

%% Generate Projector
A = generate_gauss_projector(M,N);

%% Generate Signal
x = generate_signal_gb(gb_mean,gb_var,gb_rho,N);

%% Generate Measurements
w = generate_signal_gaussian(0,delta,M);
y = A.A(x) + w;

%% Run AMP
x_hat = amp(A,y,partition_func,moment_func,x);

%% Report the mse as the result
result = norm(x-x_hat).^2./N;
