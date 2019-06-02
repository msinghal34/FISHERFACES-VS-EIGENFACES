function [recognitionRate] = correlationLOO(numFolders, num1, dimension, format, mainDir, identifier)
    originalImages = zeros(dimension, numFolders*num1);
    originalImgName = strings(1,0); % To be used to store the persons name. ith originalImages has name originalImgName(i)
    
    cd(mainDir);
    folders = dir(identifier + "*"); % Subdirectories
    
    for i=1:numFolders
        cd(folders(i).name);
        files = dir(format);
        s = size(files,1);
        % Reading images for training
        for j=1:s
            if(j ~= num1)
                img = imread(files(j).name);
                if(all(size(size(img)) == [1,3]))
                    img = rgb2gray(img);
                end
                originalImages(:,(i-1)*(s-1)+j) = double(img(:));
                originalImgName((i-1)*(s-1)+j) = folders(i).name;
            end
        end
        
        cd(".."); % Change directory back to main Directory;
    end
    cd(".."); % Change directory back to parent
    
    testingImages = zeros(dimension, 950); % Testing Images to be stored in testingImages
    testingImgName = strings(1,0); % To be used to store the persons name. ith testingImages has name testingImgName(i)
    countTestingImages = 0; % Number of testing images inserted in testingImages so far
    cd(mainDir); % Change to main Directory
    folders = dir(identifier + "*"); % Subdirectories
    
    for i=1:numFolders
        cd(folders(i).name); % Change directory to a subdirectory
        files = dir(format);

        % Reading images for testing
        for j=1:size(files,1)
            if(j == num1)
                img = imread(files(j).name);
                if(all(size(size(img)) == [1,3]))
                    img = rgb2gray(img);
                end
                countTestingImages = countTestingImages + 1;
                testingImgName(countTestingImages) = folders(i).name;
                testingImages(:,countTestingImages) = double(img(:));
            end
        end

        cd(".."); % Change directory back to main Directory;
    end

    cd(".."); % Change directory back to parent
    
    answer = 0;
    for i=1:countTestingImages
        testImage = testingImages(:,i);
        [~,index] = min(sum((originalImages - testImage) .^ 2));
        if (originalImgName(index) == testingImgName(i)) % Name should be same
            answer = answer + 1;
        end
    end
    recognitionRate = (answer./countTestingImages).*100;
end