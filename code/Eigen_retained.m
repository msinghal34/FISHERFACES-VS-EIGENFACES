%% Face recognition on yale Database without adjusting for lighting
tic;
clear;
clc;

types = ["centerlight","glasses","happy","leftlight","nogl","normal","rightlight","sad","sleepy","surprised","wink"];
correct = 0;
xi = zeros(15,11);
for io = 1:size(types,2)
    for po = 1:15
dimension = 77760; % Dimension of images 192*168

numFolders = 15; % Number of folders to get images from
mainDir = "pngyalefaces/"; % Name of main directory
identifier = "p"; % Identifier to identify folders which contain useful images

num1 = 11; % Number of images for training in each subdirectory

originalImages = zeros(dimension, numFolders*num1); % Original Images to be stored in a matrix of size dimensions X numFolders*num1
testingImages = zeros(dimension, 0); % Testing Images to be stored in testingImages

originalImgName = strings(1,0); % To be used to store the persons name. ith originalImages has name originalImgName(i)
testingImgName = strings(1,0); % To be used to store the persons name. ith testingImages has name testingImgName(i)

% Reading images

countTestingImages = 0; % Number of testing images inserted in testingImages so far
cd(mainDir);
folders = dir(identifier + "*"); % Subdirectories

for i=1:size(folders,1)
    cd(folders(i).name); % Change directory to a subdirectory
    files = dir("*.png");
    
    % Reading images for training
    for j=1:num1
        img = imread(files(j).name);
        img = rgb2gray(img);
        if((isempty(strfind(files(j).name,types(io)))) || ~(i == po))
        originalImages(:,(i-1)*num1+j) = double(img(:));
        originalImgName((i-1)*num1+j) = folders(i).name;
        end
    end
    
    % Reading images for testing
    %for j=num1+1:size(files,1)
    for j = 1:num1
        if((~(isempty(strfind(files(j).name,types(io)))) && (i == po)))
        img = rgb2gray(imread(files(j).name));
        countTestingImages = countTestingImages + 1;
        testingImgName(countTestingImages) = folders(i).name;
        testingImages(:,countTestingImages) = double(img(:));
        end
    end
    
    cd(".."); % Change directory back to main Directory;
end

cd(".."); % Change directory back to parent

originalMean = mean(originalImages,2); % Mean of original images
originalImages = originalImages-originalMean; % Mean deducted original images

% Using economical svd
[U,~,~] = svd(originalImages, 'econ');

eigenVectors = U; % Take all eigenvectors

%k = [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000]; % Values of eigenvectors to consider
k = 30; 
%Testing Phase
answer = 0; % Vector to store correct number of guesses for each value of k
testingImages = testingImages - originalMean; % Subtract originalMean from testing Images
for l=1:size(k,2)
    
    keigenvectors = eigenVectors(:,1:k(l)); % k eigen vectors corresponding to k maximum eigenvalues
    originalImgCoeffs = keigenvectors'*originalImages; % Linear Cofficients for original Images
    testingImgCoeffs = keigenvectors'*testingImages; % Linear Cofficients for all testing Images
    
    for i=1:size(testingImgCoeffs,2)
        squaredDiff = (originalImgCoeffs-testingImgCoeffs(:,i)).^2; % Squared difference between linear coefficients
        [value, index] = min(sum(squaredDiff)); % Minimum Squared Difference
        
        if (originalImgName(index) == testingImgName(i)) % Name should be same
            answer = answer + 1;
        end
        
    end
end

recognitionRate = (answer/countTestingImages)*100;

% % Plotting the results
% figure("Name", "Q1(ii)(a) Face recognition on yale Database without adjusting for lighting");
% plot(k, recognitionRate, 'r', 'LineWidth', 2);
% xlabel('K');
% ylabel('Recognition Rate (%)');
% title('Recognition Rate vs K');
if(recognitionRate == 100)
    correct = correct + 1;
end
xi(po,io) = recognitionRate;
    end
end
correct 
xi


toc;
