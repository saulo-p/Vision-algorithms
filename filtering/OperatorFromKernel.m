function H = OperatorFromKernel(h, im_size, im_size_pad, H_blocks)
% Given a 2D convolution kernel "h" and the size of the target image, the
% function returns the operator (H) that works on the linearized version of
% the image.
% If the size is to big, H is the set of matrixes that form the operator.
% The image is considered to be linearized by concatenating the COLUMNS.
% TODO: 
%   *Work for kernels that are even and odd in shape
%   *Work for images that are not symmetrical

h_s = size(h);
h_s_half = floor(h_s/2);
h_s_ref = h_s_half + 1;

% submatrixes of toeplitz structure
Hs = zeros(im_size(1), im_size(2), h_s(2));
for i = 1:h_s(2)
    r = [h(h_s_ref(1):-1:1, i)' zeros(1,im_size(1)-h_s_ref(2))];
    c = [h(h_s_ref(1):end, i); zeros(im_size(1)-h_s_ref(1), 1)];
    Hs(:,:,i) = toeplitz(c, r);
end
Hs(:,:,h_s(2)+1)= zeros(im_size(1));

% Indexes for H matrix from submatrices
c = [(h_s_ref(2):h_s(2))'; (h_s(2)+1)*ones(im_size(2)-h_s_ref(2), 1)];
r = [h_s_ref(2):-1:1       (h_s(2)+1)*ones(1, im_size(2)-h_s_ref(2))];
Idx = toeplitz(c, r);

% OPTIMIZE
H = zeros(im_size(1)*im_size(2), im_size(1)*im_size(2));
for i = 1:im_size(2)
    for j = 1:1:im_size(2)
        H((i-1)*im_size(1)+1:(i-1)*im_size(1)+im_size(1),(j-1)*im_size(1)+1:(j-1)*im_size(1)+im_size(1)) = ...
            Hs(:,:,Idx(i, j));
    end
end


if (max(im_size) < 200)
    'Toeplitz version'

else
    'Iterative version (TODO)'
%     H = zeros(im_size(1)*im_size(2),im_size(1)*im_size(2)/H_blocks , H_blocks);
%     for i = 1:(im_size(1)*im_size(2))
%         H(i,:,j) = r;
%     end
end


end

