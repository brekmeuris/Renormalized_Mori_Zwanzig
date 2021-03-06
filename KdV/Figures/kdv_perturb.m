%a script demonstrate perturbative convergence of KdV ROMs

clear all;close all;

addpath ../simulation_functions
addpath ../nonlinear
addpath ../analysis

N = 28;
epsilon = 0.1;
endtime = 100;
howoften = 100;

%find the exact solution
simulation_params.epsilon = epsilon;  %coefficient on linear term in KdV
simulation_params.alpha = 1;      %coefficient on nonlinear term in KdV
simulation_params.dt = 1e-3;      %timestep
simulation_params.endtime = endtime;   %end of simulation
simulation_params.howoften = howoften;   %how often to save state vector
simulation_params.blowup = 1;     %if 1, instabilities cause simulation to end, but not give error
simulation_params.tol = inf;    %tolerance for identifying instabilities
simulation_params.N = 256;          %number of positive modes to simulate
simulation_params.initialization = @(x) full_init_KdV(x);  %full simulation

simulation_params.initial_condition = @(x) sin(x);

[t_list,u_list] = PDE_solve(simulation_params);


simulation_params.initialization = @(x) full_init_KdV(x);
simulation_params.N = N;
[t_markov,u_markov] = PDE_solve(simulation_params);

simulation_params.initialization = @(x) complete_init_KdV(x);
simulation_params.order = 2;
simulation_params.N = N;
[t2,u2] = PDE_solve(simulation_params);

simulation_params.initialization = @(x) complete_init_KdV(x);
simulation_params.order = 4;
simulation_params.N = N;
[t4,u4] = PDE_solve(simulation_params);


rel_err_markov = sum((u_markov(:,1:length(t_markov)) - u_list(1:N,1:length(t_markov))).*conj(u_markov(:,1:length(t_markov)) - u_list(1:N,1:length(t_markov))),1)./sum(u_list(1:N,1:length(t_markov)).*conj(u_list(1:N,1:length(t_markov))),1);
rel_err_2 = sum((u2(:,1:length(t2)) - u_list(1:N,1:length(t2))).*conj(u2(:,1:length(t2)) - u_list(1:N,1:length(t2))),1)./sum(u_list(1:N,1:length(t2)).*conj(u_list(1:N,1:length(t2))),1);
rel_err_4 = sum((u4(:,1:length(t4)) - u_list(1:N,1:length(t4))).*conj(u4(:,1:length(t4)) - u_list(1:N,1:length(t4))),1)./sum(u_list(1:N,1:length(t4)).*conj(u_list(1:N,1:length(t4))),1);




figure
set(gca,'FontSize',16)
%plot(t_markov,rel_err_markov,'r','linewidth',2)
hold on
plot(t2,rel_err_2,'g','linewidth',2)
plot(t4,rel_err_4,'k','linewidth',2)
%legend('Markov','2nd Order ROM','4th Order ROM','location','northwest')
legend('2nd Order ROM','4th Order ROM','location','northwest')
xlabel('Time')
ylabel('Relative error')
saveas(gcf,'kdv_perturb','png')