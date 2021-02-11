clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_01.jpg');


% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);


% Step-3: Rescale image by linear interpolation
I_scaled = imresize(I_gray, 0.5, 'bilinear');
colormap gray;  % Returns the image to greyscale


% Step-4: Enhance image before binarisation
I_enhanced = imadjust(I_scaled);


% Step-5: Image Binarisation
I_binarised = imbinarize(I_enhanced, 'adaptive', 'ForegroundPolarity', ...
    'dark', 'Sensitivity', 0.25);  % 0.25 chosen as not too much noise


% Task 2: Edge detection ------------------------
I_edge = edge(I_enhanced, 'canny', 0.25); 



% Task 3: Simple segmentation --------------------
se = strel('disk', 1);

% COMPARING 'imclose' vs 'imdilate'
I_close = imclose(I_edge, se);
I_fill_1 = imfill(I_close, 'holes');
figure, imshow(I_fill_1)
title('imclose')

I_dilate = imdilate(I_edge, se);
I_fill_2 = imfill(I_dilate, 'holes');
figure, imshow(I_fill_2)
title('imdilate')
