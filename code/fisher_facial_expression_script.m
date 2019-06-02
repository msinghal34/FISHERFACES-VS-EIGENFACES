tic; clear; clc;
% this script uses the functioons Training_3 and Testing_3

types = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15"];
correct = 0;
xi = zeros(5,15);% this matrix stores the recognition rates for every image tested

for i = 1:size(types,2)
    for j = 1:5
        [originalMean, finalOriginalImages, W, eigenVectorsPCA, originalImgName] = Training_3(5,15,77760,"3.3_emotions","yale_",types(i)); % remove type(i) for training
        [recog_rate] = Testing_3(5,15,77760,"3.3_emotions","yale_",originalMean, finalOriginalImages, W, eigenVectorsPCA, originalImgName,types(i),"sleepy");% over here change the facial expression 'sleepy' to anything from the following list [happy, sad, wink, surprised]
         if(recog_rate == 100)
             correct = correct + 1;
         end
         xi(j,i) = recog_rate;
    end
end
correct;
xi;
toc;