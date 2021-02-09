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
% COMPARING BEST METHOD WITHOUT PARAMETERS
b = edge(I_enhanced, 'roberts'); 
c = edge(I_enhanced, 'sobel');  % Sobel was found to be the best method
d = edge(I_enhanced, 'prewitt'); 
e = edge(I_enhanced, 'canny'); 
f = edge(I_enhanced, 'log'); 

subplot(2,3,1), imshow(b), title('Roberts');
subplot(2,3,2), imshow(c), title('Sobel');
subplot(2,3,3), imshow(d), title('Prewitt');
subplot(2,3,4), imshow(e), title('Canny');
subplot(2,3,5), imshow(f), title('Log');

% COMPARING BEST METHOD OF CANNY WITH THRESHOLD
g = edge(I_enhanced, 'canny', 0.1); 
h = edge(I_enhanced, 'canny', 0.2); 
i = edge(I_enhanced, 'canny', 0.3); 
j = edge(I_enhanced, 'canny', 0.4); 
k = edge(I_enhanced, 'canny', 0.5); 
l = edge(I_enhanced, 'canny', 0.6); 

subplot(2,3,1), imshow(g), title('0.1');
subplot(2,3,2), imshow(h), title('0.2');
subplot(2,3,3), imshow(i), title('0.3');
subplot(2,3,4), imshow(j), title('0.4');
subplot(2,3,5), imshow(k), title('0.5');
subplot(2,3,6), imshow(l), title('0.6');
