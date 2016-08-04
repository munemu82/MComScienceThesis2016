function [trainedClassifier, validationAccuracy, resubstitutionAccuracy, confMatrix, predictConfusionMatrix, estimates] = naiveBayesClassifier(trainingData, testdata, testLabels)

% Extract predictors and response
inputTable = trainingData;

%Extract features/predictors from inputTable
predictorData = inputTable(:,1:end-1);

predictorNames = predictorData.Properties.VariableNames;
predictors = inputTable(:, predictorNames);
response = inputTable.label;
% prepare input data to fit Matlab Naive Bayes inputs
Xtrain = table2array(predictors);
Ytrain = response;
Xtest = testdata(:,1:end-1); % remove the wrong target labels
Xtest = table2array(Xtest);  % convert table to matrix/array Naive Bayes Prediction
Ytest = testLabels;

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
nbClassication = fitcnb(Xtrain,Ytrain, 'distribution','kernel', 'Kernel', 'epanechnikov');

%display model
display(nbClassication)

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
nbPredictFcn = @(x) predict(nbClassication, x);
trainedClassifier.predictFcn = @(x) nbPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = predictorNames;
trainedClassifier.NBClassification = nbClassication;
trainedClassifier.About = 'This struct is a trained classifier exported from Classification Learner R2016a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedClassifier''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Perform cross-validation
partitionedModel = crossval(nbClassication, 'KFold', 10);

% Compute validation accuracy
'Computing Validation Accuracy .....................'
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

% Compute validation predictions and scores
[validationPredictions, validationScores] = kfoldPredict(partitionedModel);

%Compute resubstitution accuracy
'Computing Resubstitution/Training Accuracy'
resubError = resubLoss(nbClassication);
resubstitutionAccuracy = 1-resubError;

%compute confusion matrix
'Computing Confusion Matrix........................'
yfit = predict(nbClassication, Xtrain);
confMatrix = confusionmat(Ytrain,yfit);

%compute predictions on the test dataset
yhat = predict(nbClassication,Xtest);

'Computing prediction confusion matrix'
predictConfusionMatrix = confusionmat(Ytest,yhat);
%computing feature estimates
'Estimates for the first image features vector'
%Xvect1 = strcmp(nbClassication.ClassLabels,'Kangaroo');
%estimates = nbClassication.Params{Xvect1,1};
[c,cm,ind,per] = confusion(Ytest,yhat)

