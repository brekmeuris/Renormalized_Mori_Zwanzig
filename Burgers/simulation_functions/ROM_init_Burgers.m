function simulation_params = ROM_init_Burgers(simulation_params)
%
%[simulation_params] = ROM_init_Burgers(simulation_params)
%
%Takes simulation_params structures and initializes them
%for a complete memory approximation with known effective coefficients simulation.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% simulation_params: a structure in which data relevant to the simulation
%                    no matter the model type
%
%       N         =  number of positive resolved modes
%
%       degree    =  degree of ROM
%
%       alpha     =  coefficient of nonlinearity
%
%       dt        =  timestep
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% simulation_params: a structure in which data relevant to the simulation
%                    no matter the model type
%
%       M        =  size of the full model
%
%       F_modes  =  an array of indices for resolved modes in the full
%                   model
%
%       G_modes  =  an array of indices for unresolved modes in the full
%                   model
%
%       k        =  an array of wave numbers in full model
%
%       u        =  state vector of positive modes of full model
%
%       RHS     =  function handle of the RHS

%create shorthand for ROM system size
N = simulation_params.N;
M = 3*N;

%define the ordinates in real space
x = linspace(0,2*pi*(2*N-1)/(2*N),2*N);

%define the initial condition as the Fourier transform of the sine function
%and ensure that high energy modes are zero in spite of any numerical
%errors
u_complete = fft_norm(simulation_params.initial_condition(x).');

%initialize cells indicating index information, and populate them
simulation_params.M = M;
% Wave numbers updated
simulation_params.F_modes = [1:N,2*N+1:4*N+1,5*N+1:6*N];
simulation_params.G_modes = [N+1:5*N+1];
simulation_params.k = [0:M-1,-M:-1].';

%construct vector of modes we will advance in full model (just the positive modes), and
%fill it
u = zeros(N,1);
u(:) = u_complete(1:N);

%save data into simulation_params
simulation_params.u = u;
simulation_params.RHS = @(x,t) renormalized_complete_Burgers(x,t,simulation_params);