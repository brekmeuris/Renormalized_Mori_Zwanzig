clear all;close all

leg = {'Exact','n = 1, constant coefficients','n = 2, constant coefficients','n = 3, constant coefficients','n = 4, constant coefficients','n = 1, decaying coefficients','n = 2, decaying coefficients','n = 3, decaying coefficients','n = 4, decaying coefficients'};
[times_array,energies_array,error_array] = generate_comparisons(8:2:14,1000);

for i = 1:4
    
    tc1B = times_array{i}.tc1B;
    tc2B = times_array{i}.tc2B;
    tc3B = times_array{i}.tc3B;
    tc4B = times_array{i}.tc4B;
    
    tc1KdV = times_array{i}.tc1KdV;
    tc2KdV = times_array{i}.tc2KdV;
    tc3KdV = times_array{i}.tc3KdV;
    tc4KdV = times_array{i}.tc4KdV;
    
    energyc1B = energies_array{i}.energyc1B;
    energyc2B = energies_array{i}.energyc2B;
    energyc3B = energies_array{i}.energyc3B;
    energyc4B = energies_array{i}.energyc4B;
    
    energyc1KdV = energies_array{i}.energyc1KdV;
    energyc2KdV = energies_array{i}.energyc2KdV;
    energyc3KdV = energies_array{i}.energyc3KdV;
    energyc4KdV = energies_array{i}.energyc4KdV;
    
    errc1B = errors_array{i}.errc1B;
    errc2B = errors_array{i}.errc2B;
    errc3B = errors_array{i}.errc3B;
    errc4B = errors_array{i}.errc4B;
    
    x = figure(1);
    subplot(2,2,i)
    hold off
    plot(log(t_list),log(energy_exact),'linewidth',2)
    hold on
    plot(log(tc1B),log(energyc1B),'r')
    plot(log(tc2B),log(energyc2B),'k')
    plot(log(tc3B),log(errc3B),'c')
    plot(log(tc4B),log(energyc4B),'m')
    
    plot(log(tc1KdV),log(errc1KdV),'r--','linewidth',1.2)
    plot(log(tc2KdV),log(errc2KdV),'k--','linewidth',1.2)
    plot(log(tc3KdV),log(errc3KdV),'c--','linewidth',1.2)
    plot(log(tc4KdV),log(erc4KdV),'m--','linewidth',1.2)
    legend(leg{:},'location','southwest')
    
    title(sprintf('N = %i',N),'fontsize',16)
    xlabel('log(t)')
    ylabel('log(energy)')
    
    
    
    y = figure(2);
    subplot(2,2,i)
    hold off
    plot(tc1B,errc1B,'r','linewidth',1.5)
    hold on
    plot(tc2B,errc2B,'k','linewidth',1.5)
    plot(tc3B,errc3B,'c','linewidth',1.5)
    plot(tc4B,errc4B,'m','linewidth',1.5)
    axis([0,endtime,0,2])
    legend(leg{2:5},'location','northeast')
    
    title(sprintf('N = %i',N),'fontsize',16)
    xlabel('t')
    ylabel('error')
    
    
end

saveas(x,'energy_burgers','png')
saveas(y,'error_burgers','png')