%By Amos Munezero on 09/04/2016 

% Load training and test data using imageSet.
% imageSet recursively scans the directory tree containing the images.
trainingSet = [ imageSet(fullfile('Kangaroo')), ...
            imageSet(fullfile('NotKangaroo'))];
{trainingSet.Description } % display all labels on one line
[trainingSet.Count]         % show the corresponding count of image
testSet =imageSet(fullfile('test'));

% Show training and test samples
figure;

subplot(2,3,1);
imshow(trainingSet(1).ImageLocation{3});

subplot(2,3,2);
imshow(trainingSet(2).ImageLocation{23});

subplot(2,3,3);
imshow(trainingSet(1).ImageLocation{4});

% Show pre-processing results
exTestImage = read(trainingSet(1), 5);
processedImage = imbinarize(rgb2gray(exTestImage));

figure;

subplot(1,2,1)
imshow(exTestImage)

subplot(1,2,2)
imshow(processedImage)

img = read(trainingSet(1), 4);

% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_24x24, vis24x24] = extractHOGFeatures(img,'CellSize',[24 24]);

% Show the original image
figure;
subplot(2,3,1:3); imshow(img);

% Visualize the HOG features
subplot(2,3,4);
plot(vis2x2);
title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});

subplot(2,3,5);
plot(vis4x4);
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});

subplot(2,3,6);
plot(vis24x24);
title({'CellSize = [24 24]'; ['Feature length = ' num2str(length(hog_24x24))]});

%The visualization shows that a cell size of [8 8] does not encode much shape information, 
%while a cell size of [2 2] encodes a lot of shape information but increases the dimensionality of
%the HOG feature vector significantly. A good compromise is a 4-by-4 cell size. This size setting encodes enough spatial information to 
%visually identify a digit shape while limiting the number of dimensions in the HOG feature vector, which helps speed up training. 
%In practice, the HOG parameters should be varied with repeated classifier training and testing to identify the optimal parameter settings.

%So based on visualization results we set HoG configuration as follows
cellSize = [24 24];
hogFeatureSize = length(hog_24x24);

featureVector = extractHOGFeatures(img, 'CellSize', cellSize);
%Feature extraction step
trainingFeatures = [];
trainingLabels   = [];

for digit = 1:numel(trainingSet)

    numImages = trainingSet(digit).Count;
    features  = zeros(700, hogFeatureSize, 'single');

    for i = 1:numImages

        img = rgb2gray(read(trainingSet(digit), i));

        % Apply pre-processing steps
        %img = imbinarize(img);

        features(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
    end
    % Use the imageSet Description as the training labels. The labels are
    % the digits themselves, e.g. '0', '1', '2', etc.
    labels = repmat(trainingSet(digit).Description, numImages, 1);

    trainingFeatures = [trainingFeatures; features];   %#ok<AGROW>
    trainingLabels   = [trainingLabels;   labels  ];   %#ok<AGROW>
end 