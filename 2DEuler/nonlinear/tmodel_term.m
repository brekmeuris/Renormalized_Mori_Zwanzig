function [t1,t1hat,t1tilde] = tmodel_term(u_full,t0tilde,a,b,k,a_tilde,a_tilde2)
%
% Computes the RHS for every mode in the full model for 2D Euler
%
%
%%%%%%%%%
%INPUTS:%
%%%%%%%%%
%
%    u_full  =  full array of current Fourier state (2Mx2Mx2)
%
%   t0tilde  =  full array of current Fourier state of C_tilde(u,u)
%
%         a  =  indices of positive resolved modes 1:M
%
%         b  =  indices of negative resolved modes -M:-1
%
%         k  =  array of wavenumbers (2Mx2Mx2)
%
%   a_tilde  =  indices of unresolved modes
%
%  a_tilde2  =  indices corresponding to modes included only for
%               dealiasing
%
%
%%%%%%%%%%
%OUTPUTS:%
%%%%%%%%%%
%
%       t1  =  t-model term of derivative of each resolved mode
%
%    t1hat  =  only the resolved modes of t1
%
%  t1tilde  =  only the unresolved modes of t1

% the t-model is Dk(u_hat,C_tilde(u_hat,u_hat))
[t1,t1hat,t1tilde] = Dk(u_full,t0tilde,a,b,k,a_tilde,a_tilde2);