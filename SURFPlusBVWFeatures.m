%the following script is to extract SURF features from each of the image
%and create bag of words feature vector
%set up the clock time to for start of training
startClock= clock;
disp(datestr(datenum(startClock(1),startClock(2),startClock(3),startClock(4),(5),startClock(6))));
%Construct an array of image sets based on the following categories
imgSets = [ imageSet(fullfile('Kangaroo')), ...
            imageSet(fullfile('NotKangaroo'))];
{imgSets.Description } % display all labels on one line
[imgSets.Count]         % show the corresponding count of image


%Checking if training contents and display a one image from each category
kangaroo = read(imgSets(1),1);
notkangaroo = read(imgSets(2),1);
figure

subplot(1,3,1);
imshow(kangaroo)
subplot(1,3,2);
imshow(notkangaroo)

%Create a Visual Vocabulary and Train an Image Category Classifier
bag = bagOfFeatures(imgSets,'VocabularySize',1000,'PointSelection','Detector');
bagOfFeaturesData = double(encode(bag, imgSets));
%the above does the following:
%extracts SURF features from all images in all image categories
%constructs the visual vocabulary by reducing the number of features through quantization of feature space using K-means clustering
%When you set PointSelection to 'Detector', the feature points are selected using a speeded up robust feature (SURF) detector. Otherwise, the points are picked on a predefined grid with spacing defined by 'GridStep'.
%Additionally, the bagOfFeatures object provides an encode method for counting the visual word occurrences in an image. It produced a histogram that becomes a new and reduced representation of an image.

img = read(imgSets(1), 1);  %this needs to be repeated for the rest of the images - by changing img = read(imgSets(1), 2);, img = read(imgSets(1), 3); and ....img = read(imgSets(1), n); where n is number of images
featureVector = double(encode(bag, img)); %this needs to be repeated for the rest of the images
img2 = read(imgSets(1), 2);
featureVector2 = double(encode(bag, img2));

%create labels from images
labels =[];	%class labels
for i = 1:size(imgSets,2)
  	  	labels = vertcat(labels,repelem({imgSets(i).Description}',[imgSets(i).Count],1));
end
%save features into table structure for easy export to csv later
DatatableExtract = array2table(bagOfFeaturesData);
label = categorical(repelem(labels,1,1));
%append labels to the feature vectors
DatatableExtract.class = label;





