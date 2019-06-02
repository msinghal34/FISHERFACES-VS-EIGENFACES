tic; clear; clc;
% this script uses the functioons Training_3 and Testing_3

types = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"];
correct = 0;
xi = zeros(2,15); % this stores the recognition rate for every image tested
for i = 1:size(types,2)
    for j = 1:2
        [originalMean, finalOriginalImages, W, eigenVectorsPCA, originalImgName] = Training_3(2,15,77760,"3.3","yale_",types(i)); % remove type(i) for training
        [recog_rate] = Testing_3(2,15,77760,"3.3_glasses","yale_",originalMean, finalOriginalImages, W, eigenVectorsPCA, originalImgName,types(i),"glasses"); 
         if(recog_rate == 100)
             correct = correct + 1;
         end
         xi(j,i) = recog_rate;
    end
end
correct;
xi;
toc;