function f = fSubproblem(mu, ro, g, y, u, H, D, FH2, FD2)
%Function that encapsulates the computations of equation 15.
 %Careful with size of the parameters

num = mu*H'*g + ro*D'*u - D'*y;
num = fft(num);
den = mu*norm(FH2) + ro*norm(FD2);

f = ifft2(num/den);
 
end

