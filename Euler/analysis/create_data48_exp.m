clear all;close all;

addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

N = 48;
M = 3*N;


if ~(exist('u48.mat','file') == 2)
    create_data(N,1);
end

if ~(exist('u48_2.mat','file')==2)
    
    load u48;
    load(sprintf('u%i.mat',N))
    load(sprintf('t%i.mat',N))
    start_time = t(end);
    u0 = u(:,:,:,:,:,end);
    
    
    % make k array
    k_vec = [0:M-1,-M:1:-1];
    [kx,ky,kz] = ndgrid(k_vec,k_vec,k_vec);
    k = zeros(2*M,2*M,2*M,3);
    k(:,:,:,1) = kx;
    k(:,:,:,2) = ky;
    k(:,:,:,3) = kz;
    
    % load relevant parameters into parameter structure
    params.k = k;
    params.N = N;
    params.M = M;
    params.func = @(x) full_RHS(x);
    params.coeff = [];
    params.a = 2:M;
    params.b = 2*M:-1:M+2;
    params.a_tilde = N+1:M;
    params.a_tilde2 = 2*N+1:M;
    params.print_time = 1;
    
    % run the simulation
    options = odeset('RelTol',1e-10,'Stats','on','InitialStep',1e-3);
    [t_new,u_raw] = ode45(@(t,u) RHS(u,t,params),[1,1.5],u0(:),options);
    
    % reshape the output array into an intelligible shape (should make this a
    % separate function later)
    u_new = zeros([size(u0) length(t_new)]);
    for i = 1:length(t_new)
        u_new(:,:,:,:,:,i) = reshape(u_raw(i,:),[N,N,N,3,4]);
    end
    
    t2 = t_new;
    u2 = u_new;
    
    save(sprintf('t%i_2',N),'t2');
    save(sprintf('u%i_2',N),'u2');
    
end




load u48
load u48_2

load t48
load t48_2

s = size(u);

u_both = zeros(s(1),s(2),s(3),s(4),s(5),length(t)+length(t2));
u_both(:,:,:,:,:,1:length(t)) = u;
u_both(:,:,:,:,:,length(t)+1:end) = u2;

t_both = [t;t2];

if ~(exist('tmodel_size_list48.mat','file') == 2)
    [tmodel_size_list,tmodel_size_list_full] = resolve_array(u_both,t_both);
    save('tmodel_size_list48','tmodel_size_list')
    save('tmodel_size_list_full48','tmodel_size_list_full')
end

load tmodel_size_list48
min_tol = 1e-16;
max_tol = 1e-10;

% ADDED BELOW
load tmodel_size_list_full48
% ADDED ABOVE

viable_snapshots = find(tmodel_size_list > min_tol & tmodel_size_list < max_tol);

% trim the arrays to those viable times
u_array = u_both(:,:,:,:,:,viable_snapshots);
t_array = t_both(viable_snapshots);

% compute the coefficients for all even modes smaller than the full
% simulation (except N = 2)
N_list = 4:2:24;

x0_no_time = [ 3.11 -0.92 0
              -5.01 -1.96 0
               4.92 -3.12 0
              -1.83 -4.31 0];
          
x0_time = [ 2.45 -0.91 1
           -3.12 -1.92 2
            2.63 -3.09 3
           -0.86 -4.31 4];

% compute the renormalization coefficients
scaling_laws_1 = renormalize_exponent(u,N_list,t,x0_no_time);
scaling_laws_2 = renormalize_exponent(u,N_list,t,x0_time);