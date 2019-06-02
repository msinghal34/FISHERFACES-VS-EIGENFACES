tic; clear; clc;
dimension = 77760; % Dimension of images 192*168
numFolders = 15; % Number of folders to get images from
mainDir = "../data/pngyalefaces/"; % Name of main directory
identifier = "p"; % Identifier to identify folders which contain useful images
format = "*.png";
currentDir=pwd;

% Leaving one out strategy
rates = zeros(100);
for i=1:100
    rates(i) = correlationLOO(numFolders, i, dimension, format, mainDir, identifier);
    cd(currentDir);
end
recognitionRate = mean(rates);
recognitionRate = recognitionRate(1);

cd(currentDir);
toc;