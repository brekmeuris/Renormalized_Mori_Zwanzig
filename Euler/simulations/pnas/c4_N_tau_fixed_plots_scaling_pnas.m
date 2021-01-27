clear all, close all, clc

addpath ../../simulation_functions/
addpath ../../nonlinear/
addpath ../../analysis/

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

style{1} = 'k-o';
style{2} = 'k-*';
style{3} = 'k-+';
style{4} = 'k-s';
style{5} = 'k-x';
style{6} = 'k-^';
style{7} = 'k->';
style{8} = 'k-<';
style{9} = 'k-p';
style{10} = 'k-h';


sim_endtime = 1000;
N_full = 48;
N_list = [16:2:24];
tau = 1;

figure()
hold on
for i = 1:length(N_list)
    
    N = N_list(i);

    % This data is generated using c_vs_N_tests_scaling_sims.m
    load(['t_' num2str(N) '_endtime_x10_' num2str(sim_endtime*10) '_tau_x100_' num2str(tau*100) '.mat'])
    load(['u_' num2str(N) '_endtime_x10_' num2str(sim_endtime*10) '_tau_x100_' num2str(tau*100) '.mat'])
    
    % Check that the sizes match
    if size(u,1) ~= N
        break
    end

    % Calculate the energy in the N modes of the ROM
    energy = get_3D_energy(u,N);
    
    even_log_space = exp(linspace(-2,log(t(end)),50));
    indexes = zeros(50,1);
    for j = 1:length(even_log_space)
        [~,min_loc] = min(abs(t - even_log_space(j)));
        indexes(j) = min_loc;
    end
    
    t_e = t(indexes);
    energy_e = energy(indexes);

    txt = ['Fourth order $N$ = ' num2str(N) ' ROM'];
    plot(log(t_e),log(energy_e),style{i},'DisplayName',txt)
    box on
    xlim([-2,log(t_e(end))])
    ylim([-11,0])
    xlabel('Log(Time)','fontsize',16)
    ylabel('Log(Energy)','fontsize',16)
    
end

hold off
legend('location','southwest')
legend show
saveas(gcf,sprintf('Euler_energy_multiple_N_%i_to_%i_scaling',N_list(1),N_list(end)),'eps')
