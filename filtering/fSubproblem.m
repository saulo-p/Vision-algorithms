function f = fSubproblem(mu, ro, g, y, u, H, D, nFH2, nFD2)
%Function that encapsulates the computations of equation 15.
 %Careful with size of the parameters

num = mu*H'*g + ro*D'*u - D'*y;
num = fft(num);
den = mu*nFH2 + ro*nFD2;

f = ifft2(num/den);
 
end

