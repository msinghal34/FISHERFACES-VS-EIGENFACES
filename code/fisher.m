function [name] = fisher(images, labels, test, nameOfClasses, numClasses)
% This function applies Fisher Linear Discriminant on images and returns the nearest label for test image
% TRAINING PHASE 
    numImages = size(images, 2); % Number of images involved in training
    identifierLength = strlength(nameOfClasses(1)) + 1;
    
    % Applying PCA to reduce image space to N - c
    originalMean = mean(images,2); % Mean of original images
    images = images - originalMean;
    [eigenVectors,~,~] = svd(images, 'econ');
    eigenVectorsPCA = eigenVectors(:,1:(numImages-numClasses));
    reducedImages = eigenVectorsPCA'*images;
    
    % Scatter Within
    scatterWithin = zeros(numImages-numClasses);
    meanWithin = zeros(numImages-numClasses,numClasses);
    countWithin = zeros(numClasses, 1);
    for i=1:numClasses
        iClassImages = zeros(1, 100);
        countWithin(i) = 0;
        for j=1:numImages
            if (strcmp(extractBefore((labels(j).name), identifierLength), nameOfClasses(i)))
                countWithin(i) = countWithin(i) + 1;
                iClassImages(countWithin(i)) = j;
            end
        end
        meanWithin(:,i) = mean(reducedImages(:, iClassImages(1:countWithin(i))),2);
        reducedImages(:, iClassImages(1:countWithin(i))) = reducedImages(:, iClassImages(1:countWithin(i))) - meanWithin(:,i);
        scatterWithin = scatterWithin + reducedImages*reducedImages';
    end
    
    % Scatter Between
    finalMean = mean(meanWithin,2);
    meanWithin = meanWithin - finalMean;
    scatterBetween = countWithin(i)*(meanWithin*meanWithin');
    
    % Optimal Solution for FLD
    [W,~] = eig(scatterBetween, scatterWithin);
    W = W(:,numImages-numClasses-numClasses+2:numImages-numClasses);
    finalOriginalImages = W'*(eigenVectorsPCA'*images);
    
% TESTING PHASE
    test = test - originalMean;
    testingCoefficients = W'*(eigenVectorsPCA'*test);
    squaredDiff = (finalOriginalImages-testingCoefficients).^2; % Squared difference between linear coefficients
    [~, index] = min(sum(squaredDiff)); % Minimum Squared Difference
    name = extractBefore(labels(index).name, identifierLength);
end