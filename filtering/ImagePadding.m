function I_padded = ImagePadding(I, h_size)
%Perform a zero padding to the image I according to the biggest kernel
%applied to the image.

%talvez substituir chamada da função por troca do 'same' na conv2.
% atual deteriora bordas da imagem com o filtro local


h_center = floor(h_size/2);
lr = [h_center(2) h_size(2) - h_center(2)];
tb = [h_center(1) h_size(1) - h_center(1)];

% horizontal padding (top and bottom)
im_sz = size(I);
I_padded = [zeros(floor(h_size(1)/2),im_sz(2));
            I;
            zeros(floor(h_size(1)/2),im_sz(2))];

% vertical padding (left and right)
if (false)
im_sz = size(I);
I_padded = [zeros(im_sz(1),floor(h_size(2)/2)) ...
            I_padded ...
            zeros(im_sz(1),floor(h_size(2)/2))];
end
        
end
