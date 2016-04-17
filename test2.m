%Initial image folder setup
trainFolder = 'images\train_old';
testFolder = 'images\test';

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
testFilePattern = fullfile(testFolder, '*.jpg');
testingImages = dir(testFilePattern);

%Declare lists
train_list = {};
train_labels_cat = [];
train_labels_num = [];
test_list = {};
test_labels = [];
%Get all the image names from training and test image folders

%extract and store training image names and path to the list

for i = 1:length(trainingImages)
  baseTrainImageName = trainingImages(i).name;
  fullTrainImageName = fullfile(trainFolder, baseTrainImageName);
  train_list{i} = fullTrainImageName;
  
  %Display training images
  fprintf(1, 'Now reading %s\n', fullTrainImageName);
  imageArray = imread(fullTrainImageName);
  imshow(imageArray);  % Display image.
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
        train_labels_num = vertcat(train_labels_cat,repelem({imgSets(i).Description}',[imgSets(i).Count],1));
        %category numbers
end
for j=1:length(train_labels_num)  
        if j <= 250
            train_labels_num{j} = 1;
        elseif j <=700
            train_labels_num{j} = 2;
        end
end 
%create training labels
%kangaroos =ones(1:250);
%notKangaroos(1:450)=2;
%train_labels = horzcat(kangaroos,notKangaroos);
