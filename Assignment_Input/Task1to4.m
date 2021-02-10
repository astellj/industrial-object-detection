% -----------------------------------------------------
% CMP3108M-2021: Image Processing - Assessment 01
% Written by James Astell (17668733)
% Extension Authorisation Code: FWWKT47HLQMYXK7B
% -----------------------------------------------------

clear; close all;

% Task 1: Pre-processing -----------------------
% Step-1: Load input image
I = imread('IMG_01.jpg');

%figure, imshow(I)
%title('Step-1: Input Image')


% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);

%figure, imshow(I_gray)
%title('Step-2: Grayscale Image')


% Step-3: Rescale image by bilinear interpolation
I_scaled = imresize(I_gray, 0.5, 'bilinear');

%figure, imagesc(I_scaled)
colormap gray;  % Returns the image to greyscale
%title('Step-3: Rescaled by Linear Interploation Image')


% Step-4: Produce histogram before enhancing
%figure, imhist(I_scaled)
%title('Step-4: Histogram Before Enhancing')


% Step-5: Enhance image before binarisation
I_enhanced = imadjust(I_scaled);  % Two different methods find out which is best
%I_enhanced = histeq(I_scaled);  % CHOOSE ONLY ONE


%figure, imagesc(I_enhanced)
colormap gray;
%title('Step-5: Enhanced Image Before Binarisation')


% Step-6: Histogram after enhancement
%figure, imhist(I_enhanced)
%title('Step-6: Histogram After Enhancement')


% Step-7: Image Binarisation
I_binarised = imbinarize(I_enhanced, 'adaptive', 'ForegroundPolarity', ... 
    'dark', 'Sensitivity', 0.25);  % 0.25 chosen as not too much noise caused, CHANGE AROUND

%figure, imshow(I_binarised)
%title('Step-7: Binarised Image')



% Task 2: Edge detection ------------------------
% Canny at 0.25 threshold was found to be the best
I_edge = edge(I_enhanced, 'canny', 0.25); 

figure, imshow(I_edge)
title('Task 2: Edge Detection')



% Task 3: Simple segmentation --------------------
% Grow the object by one pixel
se1 = strel('disk', 1);
I_dilated = imdilate(I_edge, se1);

% Fill shape region
I_filled = imfill(I_dilated, 'holes');

figure, imshow(I_filled)
title('Task 3: Simple Segmentation')



% Task 4: Object Recognition --------------------
% Step-1: Find the different individaul shapes and label them
% conn = 4 as less likely to have two objects label as the same
I_labeled = bwlabel(I_filled, 4);

figure, imshow(I_labeled)
title('Step 1: Distinguish invidual shapes')

% cmap = parula because it looks cool
% zerocolour = k (black background)
% order = noshuffle as makes it easier to see difference than random
figure, imshow(label2rgb(I_labeled, 'parula', 'k', 'noshuffle'))
title('Step 1b: Display different colours for each shape')


% Step-2: Extract the basic properties + boundaries of the labeled shapes
% basic = 'Area' + 'Centroid' + 'BoundingBox'
% Take basic for now, see if need other measurements later
I_props = regionprops(I_labeled, 'basic');
I_boundaries = bwboundaries(I_labeled);


% Step-3: Store all properties to variables
I_number_shapes = size(I_props, 1);  % Total no. of shapes
I_areas = [I_props.Area];  % Double array of areas
I_boundingBox = [I_props.BoundingBox];
I_centroids = [I_props.Centroid];  % Double array of centroids

% Extract every odd number of values from centroids for X values ...
% and every even nubmer for the Y values
X_centroids = I_centroids(1:2:end-1);
Y_centroids = I_centroids(2:2:end);


% Step-4: Label each of the shapes with its corrosponding number
% For loop to plot the number of each shape at its centroid location
for k = 1 : I_number_shapes
    str = {k};  % Display the shape number as a string
	text(X_centroids(k), Y_centroids(k), str);
end


% Step-5: Contrust table to display shape no. and properties
Shape_No = [1:11]';  % HARD CODED needs changing to loop for amount of ...
% shapes in robust method
t1 = table(Shape_No);
t2 = struct2table(I_props);  % Convert 'regionprops' variables to table
properties_table = [t1 t2]   % Combine tables


% Step-6: Based on table results choose values to seperate screws from ...
% washers
% We can see from the table + labeled image that all the screws have an ...
% area under 1000
screw_areas = I_areas < 1000;
% We can see the washers all have an area above 1500
washer_areas = I_areas > 1500;

% Store an arrry containing object specifc shape numbers
screw_find = find(screw_areas);
washer_find = find(washer_areas);

% Match this matrix of shape numbers to the origial labeled image
screw_shape = ismember(I_labeled, screw_find);
washer_shape = ismember(I_labeled, washer_find);


% Step-7: Convert the new labeled shapes to different colours and combine
blue_map = [0 0.4 1];  % Blue colour for screws
red_map = [1 0 0];  % Red colour for washers
screws_coloured = label2rgb(screw_shape, blue_map, 'k');
washers_coloured = label2rgb(washer_shape, red_map, 'k');

% Combine the two coloured images and display
I_recognised = screws_coloured + washers_coloured;
figure, imshow(I_recognised)
title('Task 4: Object Recognition')
