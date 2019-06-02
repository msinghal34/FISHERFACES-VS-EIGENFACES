function [bases,originalImgName] = subspaceTraining(numFolders, num1, dimension, format, mainDir, identifier)
    originalImages = zeros(dimension, numFolders*num1);
    originalImgName = strings(1,0); % To be used to store the persons name. ith originalImages has name originalImgName(i)
       
    cd(mainDir);
    folders = dir(identifier + "*"); % Subdirectories
    
    bases = zeros(dimension,3,numFolders);
    
    for i=1:numFolders
        cd(folders(i).name);
        files = dir(format);
        
        % Reading images for training
        for j=1:num1
            img = imread(files(j).name);
            if(all(size(size(img)) == [1,3]))
                img = rgb2gray(img);
            end
            originalImages(:,(i-1)*num1+j) = double(img(:));
            originalImgName((i-1)*num1+j) = folders(i).name;
        end
        bases(:,:,i) = pca(originalImages(:,(i-1)*num1+1:i*num1)','Centered',false,'NumComponents',3);
        
        cd(".."); % Change directory back to main Directory;
    end    
end