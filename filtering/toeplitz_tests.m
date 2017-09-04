%% ========================================================================
% Toeplitz convolution tests
%
% OBS: Implicit padding causes issues regarding the theoretical aspects.
%  - Using the 'valid' part of the convolution causes problems with the
%  spectral comparison.
%   - Compare fft('full') with padded signal and filter
% Author: Saulo P.
% Date Created: 30/08/17
% =========================================================================
close all;
clear all;

%%
N = 10;

% Signal and kernel definition
x = rand(1, N);
h = [1 1 1];

% Type 1 (time-domain filtering):
y = conv(x, h, 'full');
N2 = length(y);
yf = fft(y);

% Type 2 (frequency-domain):

h_pad = [h zeros(1, N2 - length(h))];
x_pad = [x zeros(1, N2 - length(x))];
% padding is necessary to make the size of DFT the same of the convolved
% signal.
xf = fft(x_pad);
hf = fft(h_pad);

yf2 = xf.*hf;
norm(yf - yf2)

% Type 3 (toeplitz time-domain filtering):
Hf = diag(hf);
yf3 = (Hf*xf.').';

norm(yf - yf3)

%% On DFTs:
% Uma DFT divide o espectro em partes iguais e soma os valores com os seus
% pesos. 
% O tamanho dos saltos é definido pelo elemento que está sendo computado.
% Neste sentido se trata de uma forma bem direta de contagem de elementos
% de frequência.