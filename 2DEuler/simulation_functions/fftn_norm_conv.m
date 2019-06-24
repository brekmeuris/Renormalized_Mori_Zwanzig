function normalized_fftn = fftn_norm_conv(u)
%
%Computes the n-dimensional FFT of the 2Mx2Mx2x2 u using the more standard
%normalization of 1/N^2 instead of just 1.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Inputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  u  =  real space array to be transformed (2M x 2M x 2 x 2)
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Outputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  normalized_fftn  =  normalized FFT of that vector

% simply loop through each entry in the array and transform each one
normalized_fftn = zeros(size(u));
for i = 1:2
    for j = 1:2
        normalized_fftn(:,:,i,j) = fftn(u(:,:,i,j))*1/numel(u(:,:,i,j));
    end
end