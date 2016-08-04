tic
addpath(genpath('.'));
info = load('images/filelist.mat');
datasets = {'Kangaroo'}; 

%Get list of images path
train_lists = {info.train_list};
test_lists = {info.test_list};

%Placeholder for feature vectors
train_features = [];
test_features = [];
newLBPFeatureVector=[];

%LBP features configuration settings
cellSize=[44 44]; 
cellSize4Smals =[12 12];
noOfNeigbors = 16;
featureSize =1001;
radiusVal = 3;
uprightRotFlag=false;
txt = 'Now computing LBP features for - ';  %status Message for each image

%initialize training features set with the first image from the list
firstImage = imread(train_list{1});

disp('Begin computing LBP features for training images')
disp('------------------------------------------------')
%extract LBP features from training images
for i=1:length(train_list)
%for i=1:10
        %read image from training list
        newImg = imread(train_list{i});
        %extract features from the image
      newLBPFeatureVector= extractLBPFeatures(newImg,'CellSize',cellSize,'NumNeighbors',noOfNeigbors,'Radius',radiusVal, 'Upright',uprightRotFlag);
      vectorSize = numel(newLBPFeatureVector);
       % we need a way to check the size of train_features before adding a
       % new feature vector row to the matrix
       if featureSize < vectorSize
           %then reduce/chop the rest of the features data
           newLBPFeatureVector(featureSize:end) =[];
           %computing LBP features from image
            disp(strcat(txt,train_list{i}))     %display status message
           train_features =cat(1, train_features, newLBPFeatureVector);
       elseif featureSize > vectorSize
           newLBPFeatureVector= extractLBPFeatures(newImg,'CellSize',cellSize4Smals,'NumNeighbors',noOfNeigbors,'Radius',radiusVal, 'Upright',uprightRotFlag);
           newLBPFeatureVector(featureSize:end) =[];
           %computing LBP features from image
           disp(strcat(txt,train_list{i}))
           train_features =cat(1, train_features, newLBPFeatureVector);
       else
            disp(strcat(txt,train_list{i}))   %display status message
           train_features =cat(1, train_features, newLBPFeatureVector);
       end
end
disp('LBP feature Extraction for training images completed successfully')
disp('Begin computing LBP features for test images')
disp('------------------------------------------------')
%extract LBP features from training images
for j=1:length(test_list)
%for j=1:15
        %read image from training list
        newImg = imread(test_list{j});
        %extract features from the image
      newLBPFeatureVector= extractLBPFeatures(newImg,'CellSize',cellSize,'NumNeighbors',noOfNeigbors,'Radius',radiusVal, 'Upright',uprightRotFlag);
      vectorSize = numel(newLBPFeatureVector);
       % we need a way to check the size of train_features before adding a
       % new feature vector row to the matrix
       if featureSize < vectorSize
           %then reduce/chop the rest of the features data
           newLBPFeatureVector(featureSize:end) =[];
           %computing LBP features from image
            disp(strcat(txt,test_list{j}))     %display status message
           test_features =cat(1, test_features, newLBPFeatureVector);
       elseif featureSize > vectorSize
           newLBPFeatureVector= extractLBPFeatures(newImg,'CellSize',cellSize4Smals,'NumNeighbors',noOfNeigbors,'Radius',radiusVal, 'Upright',uprightRotFlag);
           newLBPFeatureVector(featureSize:end) =[];
           %computing LBP features from image
           disp(strcat(txt,test_list{j}))
           test_features =cat(1, test_features, newLBPFeatureVector);
       else
            disp(strcat(txt,test_list{j}))   %display status message
           test_features =cat(1, test_features, newLBPFeatureVector);
       end
end
disp('LBP feature Extraction for test images completed successfully')
disp('LBP feature Extraction completed successfully')
%add features to the table 
trainingFeaturesDataTable = array2table(train_features);
trainingFeaturesDataTable.label = info.train_labels_cat;
testFeaturesDataTable = array2table(test_features);
toc

