function im_bw = PatternBinarization( im, gauss_window, gauss_sig, bin_th )

%>Filters
L = fspecial('gaussian', gauss_window, gauss_sig);
H = fspecial('sobel');

%>LPF:
% imf = imfilter(im, L);
iml = im;

% %TEST: 4 direction filters
% figure;
% subplot(2,2,1); imshow(imfilter(imf,H)); subplot(2,2,2); imshow(imfilter(imf,H'));
% subplot(2,2,3); imshow(imfilter(imf,-H)); subplot(2,2,4); imshow(imfilter(imf,-H'));

%>HPF + binarization: Combines Sobel filters in each direction and performs 
% threshold binarization. TODO: binarize by bw percentage.
imb = imfilter(iml, H) > bin_th  | imfilter(iml, H') > bin_th | ...
      imfilter(iml, -H) > bin_th | imfilter(iml, -H') > bin_th;

%>Erosions
%Line erosions
% steL1 = strel('line',len,45);
% steL2 = strel('line',len,-45);
% imbe = imerode(imb, steL1) | imerode(imb, steL2);

im_bw = imb;

end

