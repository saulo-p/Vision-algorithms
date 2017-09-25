function If = AddFrame(I, frame_sz)
im_sz = size(I);

If = [zeros(im_sz(1), frame_sz) I zeros(im_sz(1), frame_sz)];
If = [zeros(frame_sz, im_sz(2) + 2*frame_sz); ...
      If; ...
      zeros(frame_sz, im_sz(2) + 2*frame_sz)];

end

