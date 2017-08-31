%% ========================================================================
% Toeplitz convolution tests
%
% OBS: Implicit padding causes issues regarding the theoretical aspects.
%
% Author: Saulo P.
% Date Created: 30/08/17
% =========================================================================
close all;
clear all;

%%
N = 10;

% Signal and kernel definition
x = ones(N, 1);
h = [1 1 1];
lh = length(h);

 % part of the signal that can be filtered by the defined kernel without
 % zero padding. (Explicit because truncated fft might eliminate
x2 = x(floor(lh/2)+1:end-floor(lh/2));

% Type 1 (time-domain filtering):
y = conv(x, h, 'valid');

yf = fft(y);

% Type 2 (frequency-domain):
h_pad = [zeros(1, length(y) - lh) h];

% xf = fft(x, length(y));
xf2 = fft(x2);
hf = fft(h, length(y));
hf2 = fft(h_pad);
assert(norm(hf - hf2) == 0);

yf2 = xf2.*hf';

% Type 3 (toeplitz time-domain filtering):
H = toeplitz([h(1) zeros(1,length(y) - 1)]', h_pad);

Hf = [];
for i = 1:8
   Hf(i,:) = fft(H(i,:)); 
end
yf3 = Hf*xf2;

norm(yf - yf2)
norm(yf - yf3)