%AUTHOR: Amos Munezero
%This script is used to prepare images for feature extraction

%Initial image folder setup
trainFolder = 'images/train';
testFolder = 'images/test';

%validate specified training and test folders if exit
if ~isdir(trainFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', trainFolder);
  uiwait(warndlg(errorMessage));
  return;
end
if ~isdir(testFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', testFolder);
  uiwait(warndlg(errorMessage));
  return;
end

%extract images from folders 
trainFilePattern = fullfile(trainFolder, '*.jpg');
trainingImages = dir(trainFilePattern);
testFilePattern = fullfile(testFolder, '*.png');
testingImages = dir(testFilePattern);

%Declare lists
train_list = {};
train_labels_cat = [];
train_labels= [];
test_list = {};
test_labels_cat = [];
test_labels = [];
classes = {1,2};
%Get all the image names from training and test image folders

%extract and store training image names and path to the list
for i = 1:length(trainingImages)
  baseTrainImageName = trainingImages(i).name;
  fullTrainImageName = fullfile(trainFolder, baseTrainImageName);
  train_list{i} = fullTrainImageName;
  
  %Display training images
  fprintf(1, 'Now reading %s\n', fullTrainImageName);
  imageArray = imread(fullTrainImageName);
  %Convert image into gray scale
  grayedImg = rgb2gray(imageArray);
  %perform histogram equalization on grayed image
  histEqImg = histeq(grayedImg);
  %display figure 
  figure
  %imshow(imageArray);  % Display imageData preparation:.
  subplot(2,2,1);imshow(imageArray);title('Original Image');
  subplot(2,2,2);imhist(rgb2gray(imageArray));
  subplot(2,2,3);imshow(histEqImg);title('Image after histogram equalization');
  subplot(2,2,4);imhist(histEqImg);
  drawnow; % Force display to update immediately.
 end

%extract and store testing image names and path to the list
for j = 1:length(testingImages)
  baseTestImageName = testingImages(j).name;
  fullTestImageName = fullfile(testFolder, baseTestImageName);
  test_list{j} = fullTestImageName;
end 
%Extract training labels
imgSets = [ imageSet(fullfile('Kangaroo')), ...
            imageSet(fullfile('NotKangaroo'))];
for i = 1:size(imgSets,2)
        %category names
        train_labels_cat = vertcat(train_labels_cat,repelem({imgSets(i).Description}',[imgSets(i).Count],1));
        %train_labels_num = vertcat(train_labels_cat,repelem({imgSets(i).Description}',[imgSets(i).Count],1));
        %category numbers
end
for j=1:length(train_labels_cat)  
        if j <= 250
            train_labels{j} = 1;
        else
            train_labels{j} = 2;
        end
end 
%Extract Testing labels
testSet = [ imageSet(fullfile(testFolder))]
for i = 1:size(testSet,1)
        %category names
        test_labels_cat = vertcat(test_labels_cat,repelem({testSet(i).Description}',[testSet(i).Count],1));
end
for k=1:length(test_labels_cat)  
        if mod(k,2)==0                  %check even numbers
            test_labels{k} = 'Not Kangaroo';    %not a kangaroo
        else
            test_labels{k} = 'Kangaroo';     %is a kangaroo
        end
end 
%Save important variables to .mat file
save('filelist.mat','train_list','test_list','train_labels','test_labels','classes','train_labels_cat','test_labels_cat')
