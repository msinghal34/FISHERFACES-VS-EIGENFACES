tic; clear; clc;
dimension = 77760; % Dimension of images 192*168
numFolders = 15; % Number of folders to get images from
mainDir = "../data/pngyalefaces/"; % Name of main directory
identifier = "p"; % Identifier to identify folders which contain useful images
format = "*.png";
num1 = 3; % Number of images for training in each subdirectory
currentDir=pwd;
[bases,originalImgName] = subspaceTraining(numFolders, num1, dimension, format, mainDir, identifier);
cd(currentDir);
[recognitionRate] = subspaceTesting(numFolders, num1, dimension, format, mainDir, identifier, originalImgName, bases);
cd(currentDir);
toc;