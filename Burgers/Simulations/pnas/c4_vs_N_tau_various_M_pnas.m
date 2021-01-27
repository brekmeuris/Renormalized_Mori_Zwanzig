clear all; close all; clc;

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

n_list = [11:1:17];
N_full_list = 2.^n_list;
epsilon = 1;
N_list = 6:2:14;
dt = '_dt_5e5_';

% Set up empty dictionary
N_tau = [];

for j = 1:length(N_list)
    
    N_tau{j} = zeros(length(N_full_list),1);
    
    for i = 1:length(N_full_list)
        
        N_full = N_full_list(i);
    
        % This data is generated by running the c4_vs_N_tau_fits_M.m file
        load(['coeff_array_n_4_M_' num2str(N_full) '_N_' num2str(N_list(1)) '_to_' num2str(N_list(end)) '_inveps_' num2str(1/epsilon) dt '.mat'],'c4_loc')

        N_tau{j}(i) = c4_loc(end,j);
        
    end
        
end


figure()
hold on
for i = 1:length(N_list)
    
    txt = ['Fourth order $N$ = ' num2str(N_list(i)) ' ROM'];
    plot(N_full_list(:),N_tau{i}(:),style{i},'DisplayName',txt)
    box on
    xlim([N_full_list(1),N_full_list(end)])
    ylim([0,0.5])
    xlabel("$M'$",'fontsize',16)
    ylabel('$\tau$','fontsize',16)

end

hold off
legend('location','southeast')
saveas(gcf,sprintf('Burgers_tau_multiple_M_%i_to_%i_N_%i_to_%i_%s',N_full_list(1),N_full_list(end),N_list(1),N_list(end),dt),'eps')

