clear all;close all;

addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

N = 48;
M = 3*N;

alpha_list = [0.1;0.01;0.001];
N_list = 4:2:24;

renormalization_range = zeros(2,length(alpha_list));

coefficients = zeros(length(alpha_list),4,length(N_list),4);
laws = zeros(length(alpha_list),4,2,4);
r = zeros(length(alpha_list),4,4);

coefficients_t = zeros(length(alpha_list),4,length(N_list),4);
laws_t = zeros(length(alpha_list),4,2,4);
r_t = zeros(length(alpha_list),4,4);

for j = 1:length(alpha_list)
    
    
    if ~(exist(sprintf('u48_%i.mat',alpha_list(j)),'file') == 2)
        create_data_alpha(N,1,alpha_list(j));
    end
    if ~(exist(sprintf('u48_2_%i.mat',alpha_list(j)),'file')==2)
        
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
        
        save(sprintf('t%i_2_%i',N,alpha_list(j)),'t2');
        save(sprintf('u%i_2_%i',N,alpha_list(j)),'u2');
        
    end
    
    
    
    
    load(sprintf('u48_%i',alpha_list(j)))
    load(sprintf('u48_2_%i',alpha_list(j)))
    
    load(sprintf('t48_%i',alpha_list(j)))
    load(sprintf('t48_2_%i',alpha_list(j)))
    
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
    
    viable_snapshots = find(tmodel_size_list > min_tol & tmodel_size_list < max_tol);
    
    % trim the arrays to those viable times
    u_array = u_both(:,:,:,:,:,viable_snapshots);
    t_array = t_both(viable_snapshots);
    renormalization_range(1,j) = t_array(1);
    renormalization_range(2,j) = t_array(end);
    save('diff_IC_renorm_times','renormalization_range')
    
    % compute the coefficients for all even modes smaller than the full
    % simulation (except N = 2)
    N_list = 4:2:24;
    
    % compute the renormalization coefficients
    [c48,laws48,r48] = renormalize(u_array,N_list,t_array,0,1);
    coefficients(j,:,:,:) = c48;
    laws(j,:,:,:) = laws48;
    r(j,:,:) = r48;
    save('diff_IC_coeffs','coefficients')
    save('diff_IC_laws','laws')
    save('diff_IC_r','r')
    
    [c48_t,laws48_t,r48_t] = renormalize(u_array,N_list,t_array,1,1);
    coefficients_t(j,:,:,:) = c48_t;
    laws_t(j,:,:,:) = laws48_t;
    r_t(j,:,:) = r48_t;
    save('diff_IC_coeffs_t','coefficients_t')
    save('diff_IC_laws_t','laws_t')
    save('diff_IC_r_t','r_t')
    
end