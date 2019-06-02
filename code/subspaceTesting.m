function [recognitionRate] = subspaceTesting(numFolders, num1, dimension, format, mainDir, identifier, originalImgName,bases)
    testingImages = zeros(dimension, 0); % Testing Images to be stored in testingImages
    testingImgName = strings(1,0); % To be used to store the persons name. ith testingImages has name testingImgName(i)
    countTestingImages = 0; % Number of testing images inserted in testingImages so far
    cd(mainDir); % Change to main Directory
    folders = dir(identifier + "*"); % Subdirectories

    for i=1:numFolders
        cd(folders(i).name); % Change directory to a subdirectory
        files = dir(format);

        % Reading images for testing
        for j=num1+1:size(files,1)
            img = imread(files(j).name);
            if(all(size(size(img)) == [1,3]))
                img = rgb2gray(img);
            end
            countTestingImages = countTestingImages + 1;
            testingImgName(countTestingImages) = folders(i).name;
            testingImages(:,countTestingImages) = double(img(:));
        end

        cd(".."); % Change directory back to main Directory;
    end

    cd(".."); % Change directory back to parent
    
    answer = 0;
    for i=1:countTestingImages
        mse = zeros(numFolders,1);
        for j=1:numFolders
            coeffs = testingImages(:,i)' * bases(:,:,j);
            projection = coeffs(1)*bases(:,1,j)+coeffs(2)*bases(:,2,j)+coeffs(3)*bases(:,3,j);
            mse(j) = sum((testingImages(:,i)-projection) .^ 2);
        end
        [~,index] = min(mse);
        index = index*num1 - 1;
        if (originalImgName(index) == testingImgName(i)) % Name should be same
            answer = answer + 1;
        end
    end
    recognitionRate = (answer./countTestingImages).*100;
end