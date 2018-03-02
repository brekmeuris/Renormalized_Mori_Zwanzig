%clear all; close all;

addpath ../../simulation_functions
addpath ../../nonlinear
addpath ../../analysis

N_list = [2,4,6];

% load u_full_data
%load u_full_data
%load t_full

tol = inf;
[u,t,tmodel_size_list] = resolve_array(u_full_data,t_full,tol);
save u u
save t t

time = 1;


coeff_array = renormalize(u,N_list,t,time);