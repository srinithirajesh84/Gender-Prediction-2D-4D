clc;
clear;
% Load the  hand image
img = imread('C:\Users\srini\Documents\sri.jpeg'); % Replace with your image file
imshow(img);
title('Original Image');

% Convert to grayscale
grayImg = rgb2gray(img);

% Apply Gaussian filter to reduce noise
filteredImg = imgaussfilt(grayImg, 2);

% Edge detection
edges = edge(filteredImg, 'Canny');

% Display edges
figure;
imshow(edges);
title('Edge Detection');

% Find contours of the fingers
[B, L] = bwboundaries(edges, 'noholes');

% Define image DPI (change as needed)
DPI = 96;  % Replace with actual DPI of your image

% Conversion factor from pixels to centimeters
pixel_to_cm = 2.54 / DPI;

% Initialize variables to store lengths
length_2D = 0;
length_4D = 0;

% Loop through boundaries to find finger lengths
for k = 1:length(B)
boundary = B{k};
% Calculate the length of the finger (using the y-coordinates)
finger_length_px = max(boundary(:, 1)) - min(boundary(:, 1));

% Convert pixels to centimeters
finger_length_cm = finger_length_px * pixel_to_cm;

% Assuming the index finger is the first boundary and the ring finger is the second
if k == 1
length_2D = finger_length_cm; % Index finger
elseif k == 2
length_4D = finger_length_cm; % Ring finger
end
end

% Calculate the 2D:4D ratio
if length_4D > 0
ratio = length_2D / length_4D;
fprintf('Index Finger Length (2D): %.2f cm\n', length_2D);
fprintf('Ring Finger Length (4D): %.2f cm\n', length_4D);
fprintf('2D:4D Ratio: %.2f\n', ratio);

% Gender prediction based on the 2D:4D ratio
if ratio < 0.95  % Adjust threshold based on research data
gender = 'Male';
else
gender = 'Female';
end

fprintf('Predicted Gender: %s\n', gender);
else
fprintf('Could not calculate the ratio. Check the image.\n');
end
