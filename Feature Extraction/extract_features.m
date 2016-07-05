%Feature extraction
addpath(genpath('.'));
info = load('images/filelist.mat');
datasets = {'Kangaroo'}; 
train_lists = {info.train_list};
test_lists = {info.test_list};
feature = 'color';              %set type of feature

% Load the configuration and set dictionary size to 20 (for fast demo)
c = conf();
c.feature_config.(feature).dictionary_size=20;

% Compute train and test features
datasets_feature(datasets, train_lists, test_lists, feature, c);

% Load train and test features
train_features = load_feature(datasets{1}, feature, 'train', c);
test_features = load_feature(datasets{1}, feature, 'test', c);
%save training features into table structure for easy export to csv later
trainingFeaturesDataTable = array2table(train_features);
trainingFeaturesDataTable.label = info.train_labels_cat;

%save testing features into table structure for easy export to csv later
testFeaturesDataTable = array2table(test_features);
testFeaturesDataTable.label = info.test_labels_cat;

%For classifier to perform prediction on test or new data, the data need to
%have same column names as the training data (i.e.
%trainingFeaturesDataTable and testFeaturesDataTable need to have same
%columns, to fix this I run the loop to modify column names in the test
%features table.
for k=1:length(testFeaturesDataTable.Properties.VariableNames)
    testFeaturesDataTable.Properties.VariableNames{k}= strcat('train_features',num2str(k));
end

