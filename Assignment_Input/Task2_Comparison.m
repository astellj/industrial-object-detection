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
