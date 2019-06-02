function [originalMean, finalOriginalImages, W, eigenVectorsPCA, originalImgName] = Training_3(numFolders, num1, dimension, mainDir,identifier,imageType)
% this function is used to train the model for both glasses and facial
% expresions
    originalImages = zeros(dimension, numFolders*num1);
    originalImgName = strings(1,0); % To be used to store the persons name. ith originalImages has name originalImgName(i)
    N = numFolders*num1;
    c = numFolders;
    
    cd(mainDir);
    folders = dir(identifier + "*"); % Subdirectories
    
    for i=1:numFolders
        cd(folders(i).name);
        files = dir('*.png');
        % Reading images for training
        for j=1:num1
            img = imread(files(j).name);
            img = rgb2gray(img);
            if((isempty(strfind(files(j).name,imageType)))) % if the image is the same as the test image type, then remove it from the training
                originalImages(:,(i-1)*num1+j) = double(img(:));
                originalImgName((i-1)*num1+j) = folders(i).name; 
            end  
        end
        
        cd('..'); % Change directory back to main Directory;
    end
    cd('..'); % Change directory back to parent
    
    % Applying PCA to reduce image space to N - c
    originalMean = mean(originalImages,2); % Mean of original images
    originalImages = originalImages - originalMean;
    [eigenVectors,~,~] = svd(originalImages, 'econ');
    eigenVectorsPCA = eigenVectors(:,1:(N-c));
    reducedOriginalImages = eigenVectorsPCA'*originalImages;
    
    % Scatter Within
    scatterWithin = zeros(N-c);
    meanWithin = zeros(N-c,c);
    for i=1:c
        meanWithin(:,i) = mean(reducedOriginalImages(:,((i-1)*num1+1:i*num1)),2);
        reducedOriginalImages(:,((i-1)*num1+1:i*num1)) = reducedOriginalImages(:,((i-1)*num1+1:i*num1)) - meanWithin(:,i);
        scatterWithin = scatterWithin + reducedOriginalImages(:,((i-1)*num1+1:i*num1))*reducedOriginalImages(:,((i-1)*num1+1:i*num1))';
    end
    
    % Scatter Between
    finalMean = mean(meanWithin,2);
    meanWithin = meanWithin - finalMean;
    scatterBetween = num1*(meanWithin*meanWithin');
    
    % Optimal Solution for FLD
    [W,~] = eig(scatterBetween, scatterWithin);
    W = W(:,N-c-c+2:N-c);
    finalOriginalImages = W'*(eigenVectorsPCA'*originalImages);
end