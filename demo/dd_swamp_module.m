function result = dd_swamp_module(x,y)
% A Test module for the transition search function. Requires that the 
% FreeOpt Eric-Scratch branch be on the path.
N = 2048;
M = round(N*y);
delta = 1e-8;	% Noise Variance

% Using the GB prior
gb_rho  = x;
gb_mean = 0;
gb_var  = 1;

%% Generate Projector
A = generate_gauss_projector(M,N);

%% Generate Signal
x = generate_signal_gb(gb_mean,gb_var,gb_rho,N);

%% Generate Measurements
w = generate_signal_gaussian(0,delta,M);
y = A.A(x) + w;

%% Run SwAMP
a0 = zeros(N,1);
c0 = ones(N,1);

x_hat = amp_fast(y, A, 'gb', [gb_rho, gb_mean, gb_var], 2000, 1e-10,1,1,a0,c0,'/dev/null',1e-12);

%% Report the mse as the result
result = norm(x-x_hat).^2./N;
