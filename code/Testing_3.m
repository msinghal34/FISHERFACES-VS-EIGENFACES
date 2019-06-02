function [recognitionRate] = Testing_3(numFolders, num1, dimension, mainDir, identifier, originalMean, finalOriginalImages, W, eigenVectorsPCA, originalImgName,person,imageType)
 % this function is used to test for glasses and facial
 % expressions 
    testingImages = zeros(dimension, 0); % Testing Images to be stored in testingImages
    testingImgName = strings(1,0); % To be used to store the persons name. ith testingImages has name testingImgName(i)
    countTestingImages = 0; % Number of testing images inserted in testingImages so far
    cd(mainDir); % Change to main Directory
    folders = dir(identifier + "*"); % Subdirectories
    N = numFolders*num1;
    c = numFolders;
    
    for i=1:numFolders
        cd(folders(i).name); % Change directory to a subdirectory
        files = dir('*.png');
        % Reading images for testing
        
        for j = 1:num1
            if((~(isempty(strfind(files(j).name,imageType)))) && ~(isempty((strfind(files(j).name,person))))) % include only the required image in the test set
                img = rgb2gray(imread(files(j).name));
                countTestingImages = countTestingImages + 1;
                testingImgName(countTestingImages) = folders(i).name;
                testingImages(:,countTestingImages) = double(img(:));
            end
        end
        
        cd('..'); % Change directory back to main Directory;
    end

    cd('..'); % Change directory back to parent
    
    answer = 0;
    testingImages = testingImages - originalMean; % Subtract originalMean from testing Images
    testingImgCoeffs = W'*(eigenVectorsPCA'*testingImages); % Linear Cofficients for all testing Images
    for i=1:size(testingImgCoeffs,2)
        squaredDiff = (finalOriginalImages-testingImgCoeffs(:,i)).^2; % Squared difference between linear coefficients
        [~, index] = min(sum(squaredDiff)); % Minimum Squared Difference
        if (originalImgName(index) == testingImgName(i)) % Name should be same
            answer = answer + 1;
        end
    end
    
    recognitionRate = (answer./countTestingImages).*100;
end