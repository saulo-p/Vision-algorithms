function If = AddFrame(I, frame_sz)
im_sz = size(I);

If = [zeros(im_sz(1), frame_sz(1)) I zeros(im_sz(1), frame_sz(1))];
If = [zeros(frame_sz(1), im_sz(2) + 2*frame_sz(1)); ...
      If; ...
      zeros(frame_sz(1), im_sz(2) + 2*frame_sz(1))];

end

