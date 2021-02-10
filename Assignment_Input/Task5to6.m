clear; close all;

% Task 5: Robust method --------------------------
% Step-1: Load input image
% Choose image here
Input_filename = 'IMG_07.jpg';
GT_filename = 'IMG_07_GT.png';

I = imread(Input_filename);


% Step-2: Covert image to grayscale
I_gray = rgb2gray(I);


% Step-3: Rescale image by linear interpolation
I_scaled = imresize(I_gray, 0.5, 'bilinear');
colormap gray;  % Returns the image to greyscale


% Step-4: Enhance image before binarisation
I_enhanced = imadjust(I_scaled);  % Two different methods find out which is best
colormap gray;


% Step-5: Image Binarisation
I_binarised = imbinarize(I_enhanced, 'adaptive', 'ForegroundPolarity', ... 
    'dark', 'Sensitivity', 0.25);  % 0.25 chosen as not too much noise caused, CHANGE AROUND


% Step-6: Edge Detection
% Canny at 0.25 threshold was found to be the best
I_edge = edge(I_enhanced, 'canny', 0.25); 


% Step-7: Simple Segmentation
% Grow the object by one pixel
se1 = strel('disk', 1);
I_dilated = imdilate(I_edge, se1);

% Fill shape region
I_filled = imfill(I_dilated, 'holes');


% Step-8: Find the different individaul shapes and label them
% conn = 4 as less likely to have two objects label as the same
I_labeled = bwlabel(I_filled, 4);

figure, imshow(I_labeled)
title('Step 1: Distinguish invidual shapes')

% cmap = parula because it looks cool
% zerocolour = k (black background)
% order = noshuffle as makes it easier to see difference than random
figure, imshow(label2rgb(I_labeled, 'parula', 'k', 'noshuffle'))
title('Step 1b: Display different colours for each shape')


% Step-9: Extract the basic properties + boundaries of the labeled shapes
% basic = 'Area' + 'Centroid' + 'BoundingBox'
% Take basic for now, see if need other measurements later
I_props = regionprops(I_labeled, 'basic');
I_boundaries = bwboundaries(I_labeled);


% Step-10: Store all properties to variables
I_number_shapes = size(I_props, 1);  % Total no. of shapes
I_areas = [I_props.Area];  % Double array of areas
I_boundingBox = [I_props.BoundingBox];
I_centroids = [I_props.Centroid];  % Double array of centroids

% Extract every odd number of values from centroids for X values ...
% and every even nubmer for the Y values
X_centroids = I_centroids(1:2:end-1);
Y_centroids = I_centroids(2:2:end);


% Step-11: Label each of the shapes with its corrosponding number
% For loop to plot the number of each shape at its centroid location
for i = 1 : I_number_shapes
    str = {i};  % Display the shape number as a string
	text(X_centroids(i), Y_centroids(i), str);
end


% Step-12: Contrust table to display shape no. and properties
% Loop to add number of shapes to double array
for j = 1 : I_number_shapes
    test = (j);
    Shape_No{j, 1} = test;
end
Shape_No = cell2mat(Shape_No);

t1 = table(Shape_No);
t2 = struct2table(I_props);  % Convert 'regionprops' variables to table
properties_table = [t1 t2]   % Combine tables


% Step-13: Based on table results choose values to seperate screws from ...
% washers
% We can see from the table + labeled image that all the screws have an ...
% area under 1000
small_screw_areas = I_areas < 1000;
% We can see the washers all have an area between 1000 and 2400
washer_areas = I_areas > 1000 & I_areas < 2500;
% We can see that all big screws have an area above 2600
big_screw_areas = I_areas > 2600;

% Store an arrry containing object specifc shape numbers
small_screw_find = find(small_screw_areas);
washer_find = find(washer_areas);
big_screw_find = find(big_screw_areas);

% Match this matrix of shape numbers to the origial labeled image
small_screw_shape = ismember(I_labeled, small_screw_find);
washer_shape = ismember(I_labeled, washer_find);
big_screw_shape = ismember(I_labeled, big_screw_find);


% Step-14: Convert the new labeled shapes to different colours and combine
blue_map = [0 0.4 1];  % Blue colour for screws
red_map = [1 0 0];  % Red colour for washers
yellow_map = [0.2 1 0.2];

% Convert to RGB
small_screws_coloured = label2rgb(small_screw_shape, blue_map, 'k');
washers_coloured = label2rgb(washer_shape, red_map, 'k');
big_screws_coloured = label2rgb(big_screw_shape, yellow_map, 'k');

% Combine the two coloured images and display
I_recognised = small_screws_coloured + washers_coloured + big_screws_coloured;
figure, imshow(I_recognised)
title('Task 5: Robust Method')



% Task 6: Performance evaluation -----------------
% Step-1: Load ground truth data
GT = imread(GT_filename);
L_GT = label2rgb(GT, 'prism','k','shuffle');


% Step-2: Convert ground truth to binary
GT_gray = im2gray(L_GT);
GT_binarised = imbinarize(GT_gray);


% Step-3: Calcualte dice score
% I_filled = my final binary segmented image
% GT_binarised = ground truth 
Dice_Score = dice(I_filled, GT_binarised);


% Step-4: Calcualte precision + recall
% Threshold = 2.25 to ensure error is noticable
% Can ignore 'score' as using 'Dice_score'
[score, Precision, Recall] = bfscore(I_filled, GT_binarised, 2.25);  


% Step-5: Display similarity figure with results
figure, imshowpair(I_recognised, GT_gray)
title({['Task 6: Performance Evaluation:']
    ['Dice Score = ' num2str(Dice_Score), ' / Precision = ' ...
    num2str(Precision), ' / Recall = ' num2str(Recall)]})


% Step-5: Contruct performace evaluation table 
Image_Name = {GT_filename};
Performance_Evaluation = table(Image_Name, Dice_Score, Precision, Recall)
