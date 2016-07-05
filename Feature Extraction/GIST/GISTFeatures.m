%Load image dataset
%Construct an array of image sets based on the following categories
imgSets = [ imageSet(fullfile('Kangaroo')), ...
            imageSet(fullfile('NotKangaroo'))];
{imgSets.Description } % display all labels on one line
[imgSets.Count]         % show the corresponding count of image

% Parameters:
clear param
param.imageSize = [256 256]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;

% Computing gist requires 1) prefilter image, 2) filter image and collect
% output energies
% code modified to run GIST against the entire dataset instead of one image
% as shown in the original code.

gistFeatureVectors = [];
labels =[];	%class labels
%loop through the image dataset and extract GIST feature for each image
for i = 1:size(imgSets,2)
	for j = 1:imgSets(i).Count
	    img = read(imgSets(i),j);
        [gistFeatureVector, param] = LMgist(img, '', param);
	    gistFeatureVectors = vertcat(gistFeatureVectors,gistFeatureVector);
    end
    %for each image label it with approapriate class
    labels = vertcat(labels,repelem({imgSets(i).Description}',[imgSets(i).Count],1));
end
%sample data 
[gist1, param] = LMgist(img, '', param);
kangaroo = read(imgSets(1),1);
% Visualization
figure
subplot(121)
imshow(kangaroo)
title('Input image')
subplot(122)
showGist(gist1, param)
title('Descriptor')

%save features into table structure for easy export to csv later
GistFeaturesDataTable = array2table(gistFeatureVectors);
GistFeaturesDataTable.label = labels;

