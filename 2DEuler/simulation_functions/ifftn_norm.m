function normalized_ifftn = ifftn_norm(u_full)
%
%Computes the n-dimensional IFFT of the NxN u_full using the more standard
%normalization of 1/N^2.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  u_full  =  Fourier space vector to be transformed
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  normalized_ifftn  =  normalized IFFT of that vector


normalized_ifftn = zeros(size(u_full));
for i = 1:2
    normalized_ifftn(:,:,i) = real(ifftn(u_full(:,:,i))*numel(u_full(:,:,i)));
end