function Isq = SquarePadding( I )
%Receives image of any size and returns image with zero padding so it
%becomes square.

im_sz = size(I);

if (im_sz(1) > im_sz(2))
    Isq = [zeros(im_sz(1), floor((im_sz(1)-im_sz(2))/2) )...
           I...
           zeros(im_sz(1), ceil((im_sz(1)-im_sz(2))/2))];
else
    Isq = [zeros(floor((im_sz(2)-im_sz(1))/2), im_sz(2));
           I;
           zeros(ceil((im_sz(2)-im_sz(1))/2), im_sz(2))];
end

end

