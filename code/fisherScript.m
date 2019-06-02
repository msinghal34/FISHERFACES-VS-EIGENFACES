tic; clear; clc;
% Testing on Yale Database full images of 15 people. Each has 11 images

% CONSTANTS for a particular database
dimension = 77760; % Dimension of images 320*243
mainDir = "../data/Yale/"; % Name of main directory where images are present
identifier = "subject"; % Identifier string
identifierLength = 10;
numClasses = 15;
filetype = "*.png";
channels = 3;

% Initial setup
currentdir = pwd;
cd (mainDir);
files = dir(filetype);
numImages = size(files, 1); % Total number of images
images = zeros(dimension, numImages); % All images. Each image is stored column wise.
numCorrectResults = 0; % Total number of correct recognitions so far

% Reading all images in variable images
for i=1:numImages
    img = imread(files(i).name);
    if (channels == 3)
        img = rgb2gray(img);
    end
    images(:,i) = double(img(:));
end
cd (currentdir); % Going back to main directory

% Name of each class for identification
nameOfClasses = strings(1,0);
for i=1:numClasses
    if (i < 10)
        nameOfClasses(i) = identifier + "0" + int2str(i);
    else
        nameOfClasses(i) = identifier + int2str(i);
    end
end

results = zeros(numImages, 1);
% Calling fisher function on each image to determine recognition rate
for i=1:numImages
    name = fisher([images(:, 1:i-1) images(:, i+1:end)], [files(1:i-1); files(i+1:end)], images(:,i), nameOfClasses, numClasses);
    if (strcmp(name, extractBefore(files(i).name, identifierLength)))
        numCorrectResults = numCorrectResults + 1;
        results(i) = 1;
    end
end

recognitionRate = numCorrectResults/numImages;

toc;