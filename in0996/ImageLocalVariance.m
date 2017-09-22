function Ivar = ImageLocalVariance(I, window_size)
%Receives an image and returns the variance of each window.
w_sz = window_size;
w_sz = floor(w_sz/2);

I_pad = ImagePadding(I, window_size);
sz = size(I_pad);

Ivar = zeros(size(I));

for i = 1+w_sz(1):sz(1)-w_sz(1)
    for j = 1+w_sz(2):sz(2)-w_sz(2)
        A = I_pad(i-w_sz(1):i+w_sz(1), j-w_sz(2):j+w_sz(2));
        mu = mean(mean(A));
        
        Ivar(i-w_sz(1),j-w_sz(2)) = norm(A - mu);
    end

end


end

