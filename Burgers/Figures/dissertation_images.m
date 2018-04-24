clear all;close all

N_list = 8:2:14;
endtime = 1;

leg = {'Exact','n = 1, constant coefficients','n = 2, constant coefficients','n = 3, constant coefficients','n = 4, constant coefficients','n = 1, decaying coefficients','n = 2, decaying coefficients','n = 3, decaying coefficients','n = 4, decaying coefficients'};
[times_array,energies_array,error_array] = generate_comparisons(N_list,endtime);



for i = 1:4
    
    N = N_list(i);
    
    t_list = times_array{i}.exact;
    tc1B = times_array{i}.c1B;
    tc2B = times_array{i}.c2B;
    tc3B = times_array{i}.c3B;
    tc4B = times_array{i}.c4B;
    
    tc1KdV = times_array{i}.c1KdV;
    tc2KdV = times_array{i}.c2KdV;
    tc3KdV = times_array{i}.c3KdV;
    tc4KdV = times_array{i}.c4KdV;
    
    energy_exact = energies_array{i}.exact;
    energyc1B = energies_array{i}.c1B;
    energyc2B = energies_array{i}.c2B;
    energyc3B = energies_array{i}.c3B;
    energyc4B = energies_array{i}.c4B;
    
    energyc1KdV = energies_array{i}.c1KdV;
    energyc2KdV = energies_array{i}.c2KdV;
    energyc3KdV = energies_array{i}.c3KdV;
    energyc4KdV = energies_array{i}.c4KdV;
    
    errc1B = error_array{i}.c1B;
    errc2B = error_array{i}.c2B;
    errc3B = error_array{i}.c3B;
    errc4B = error_array{i}.c4B;
    
    figure(1);
    subplot(2,2,i)
    hold off
    plot(log(t_list),log(energy_exact),'linewidth',2)
    hold on
    plot(log(tc1B),log(energyc1B),'r')
    plot(log(tc2B),log(energyc2B),'k')
    plot(log(tc3B),log(energyc3B),'c')
    plot(log(tc4B),log(energyc4B),'m')
    
    plot(log(tc1KdV),log(energyc1KdV),'r--','linewidth',1.2)
    plot(log(tc2KdV),log(energyc2KdV),'k--','linewidth',1.2)
    plot(log(tc3KdV),log(energyc3KdV),'c--','linewidth',1.2)
    plot(log(tc4KdV),log(energyc4KdV),'m--','linewidth',1.2)
    legend(leg{:},'location','southwest')
    
    title(sprintf('N = %i',N),'fontsize',16)
    xlabel('log(t)')
    ylabel('log(energy)')
    
    
end

saveas(gcf,'energy_burgers','png')




for i = 1:4
    
     N = N_list(i);
    
    t_list = times_array{i}.exact;
    tc1B = times_array{i}.c1B;
    tc2B = times_array{i}.c2B;
    tc3B = times_array{i}.c3B;
    tc4B = times_array{i}.c4B;
    
    errc1B = error_array{i}.c1B;
    errc2B = error_array{i}.c2B;
    errc3B = error_array{i}.c3B;
    errc4B = error_array{i}.c4B;
    
    figure(2);
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

saveas(gcf,'error_burgers','png')