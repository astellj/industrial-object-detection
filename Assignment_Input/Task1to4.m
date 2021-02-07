clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_01.jpg');
%figure, imshow(I)
title('Step-1: Input Image')

% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);
%figure, imshow(I_gray)
title('Step-2: Grayscale Image')

% Step-3: Rescale image by linear interpolation
I_scaled = imresize(I_gray, 0.5, 'bilinear');
%figure, imagesc(I_scaled)
colormap gray;  % Returns the image to greyscale
title('Step-3: Rescaled by Linear Interploation Image')

% Step-4: Produce histogram before enhancing
%figure, imhist(I_scaled)
title('Step-4: Histogram Before Enhancing')

% Step-5: Enhance image before binarisation
I_enhanced = imadjust(I_scaled);  % Two different methods find out which is best
%I_enhanced = histeq(I_scaled);  % CHOOSE ONLY ONE
%figure, imagesc(I_enhanced)
colormap gray;
title('Step-5: Enhanced Image Before Binarisation')

% Step-6: Histogram after enhancement
%figure, imhist(I_enhanced)
title('Step-6: Histogram After Enhancement')

% Step-7: Image Binarisation
I_binarised = imbinarize(I_enhanced, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.25);  % 0.25 chosen as not too much noise caused, CHANGE AROUND
%figure, imshow(I_binarised)
title('Step-7: Binarised Image')

% Task 2: Edge detection ------------------------

% Task 3: Simple segmentation --------------------

% Task 4: Object Recognition --------------------
