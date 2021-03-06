clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;

% Read in a standard MATLAB color demo image.
folder = fullfile(matlabroot, 'Facial-Recognition\faces94\male\rjlabr');
baseFileName = 'rjlabr.7.jpg';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
    % Didn't find it there.  Check the search path for it.
    fullFileName = baseFileName; % No path this time.
    if ~exist(fullFileName, 'file')
        % Still didn't find it.  Alert user.
        errorMessage = sprintf('Error: %s does not exist.', fullFileName);
        uiwait(warndlg(errorMessage));
        return;
    end
end
% Read the image from disk.
rgbImage = imread(fullFileName);

%on peut decommenter ligne suivante si image en input est en couleur
rgbImage = rgb2gray(rgbImage);


% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows columns numberOfColorBands] = size(rgbImage)

% The first way to divide an image up into blocks is by using mat2cell().
blockSizeR = rows/2; % Rows in block.
blockSizeC = columns/2; % Columns in block.

% Figure out the size of each block in rows.
% Most will be blockSizeR but there may be a remainder amount of less than that.
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns.
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];

% Create the cell array, ca. 
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks.
if numberOfColorBands > 1
    % It's a color image.
    ca = mat2cell(rgbImage, blockVectorR, blockVectorC, numberOfColorBands);
else
    ca = mat2cell(rgbImage, blockVectorR, blockVectorC);
end

% Now display all the blocks.
plotIndex = 1;
numPlotsR = size(ca, 1);
numPlotsC = size(ca, 2);
list = {};
for r = 1 : numPlotsR
    for c = 1 : numPlotsC
        fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
        % Specify the location for display of the image.
        subplot(numPlotsR, numPlotsC, plotIndex);
        % Extract the numerical array out of the cell
        % just for tutorial purposes.
        rgbBlock = ca{r,c};
        imshow(rgbBlock);
        list{end+1} = rgbBlock;
        %imshow(ca{r,c});
        [rowsB columnsB numberOfColorBandsB] = size(rgbBlock);
        % Make the caption the block number.
        caption = sprintf('Block #%d of %d\n%d rows by %d columns', ...
            plotIndex, numPlotsR*numPlotsC, rowsB, columnsB);
        title(caption);
        drawnow;
        % Increment the subplot to the next location.
        plotIndex = plotIndex + 1;
    end
end

BB = {};

combImgDroit = cat(1,list{1}, list{4});
%REye = mat2gray(list{4});
% figure;
% imshow(REye);
faceDetector=vision.CascadeObjectDetector('RightEye');
BB{end+1}=step(faceDetector,combImgDroit);
iimg = insertObjectAnnotation(combImgDroit, 'rectangle', BB{1}, 'RightEye');
figure;
imshow(iimg);

combImgGauche = cat(1,list{2}, list{5});
%LEye = mat2gray(list{5});
% figure;
% imshow(LEye);
faceDetector=vision.CascadeObjectDetector('LeftEye');
BB{end+1}=step(faceDetector,combImgGauche);
iimg = insertObjectAnnotation(combImgGauche, 'rectangle', BB{2}, 'LeftEye');
figure;
imshow(iimg);

combImgNezBouche = imfuse(list{4}, list{5}, 'montage');
%Nose = mat2gray(list{5});
faceDetector=vision.CascadeObjectDetector('Nose');
BB{end+1}=step(faceDetector,combImgNezBouche);
iimg = insertObjectAnnotation(combImgNezBouche, 'rectangle', BB{3}, 'Nose');
figure;
imshow(iimg);

%Mouth = mat2gray(list{8});
% figure;
% imshow(Mouth);
% figure;
% imshow(Nose);
%combImg = imfuse(list{7}, list{8}, 'montage');
%imshow(combImg);

faceDetector=vision.CascadeObjectDetector('Mouth');
BB{end+1}=step(faceDetector,combImgNezBouche);
iimg = insertObjectAnnotation(combImgNezBouche, 'rectangle', BB{4}, 'Mouth');
figure;
imshow(iimg);

BB = cell2mat(BB);

% Display the original image in a new figure.
figure;
imshow(rgbImage);
title('Original Image');



trainingSet = imageDatastore('faces94\male\rjlabr',   'IncludeSubfolders', true, 'LabelSource', 'foldernames');
testSet     = imageDatastore('faces94\male', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
countEachLabel(trainingSet);
countEachLabel(testSet);

figure;

subplot(2,3,1);
imshow(trainingSet.Files{20});

subplot(2,3,2);
imshow(trainingSet.Files{20});

subplot(2,3,3);
imshow(trainingSet.Files{18});

subplot(2,3,4);
imshow(testSet.Files{13});

subplot(2,3,5);
imshow(testSet.Files{12});

subplot(2,3,6);
imshow(testSet.Files{13});

%rgbImage = rgb2gray(rgbImage);
lbpFeatures = extractLBPFeatures(rgbImage,'CellSize',[64 64],'Normalization','None');
a = mat2gray(lbpFeatures(:));
figure, imshow(a), hold on, title('Detected features');
plot(lbpFeatures(:));

cellSize = [64 64];
lbpFeatureSize = length(lbpFeatures);

numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages, lbpFeatureSize, 'single');

for i = 1:numImages
    img = readimage(trainingSet, i);
    
    img = rgb2gray(img);
    
    % Apply pre-processing steps
    img = imbinarize(img);
    
    trainingFeatures(i, :) = extractLBPFeatures(img,'CellSize',cellSize,'Normalization','None');  
end

% Get labels for each image.
trainingLabels = trainingSet.Labels;

disp('Training/Loading Machine Learning Model...');
tic
classifier = fitcecoc(trainingFeatures, trainingLabels);
save('training_data.mat','classifier');
load('training_data.mat');


[testFeatures, testLabels] = helperExtractLBPFeaturesFromImageSet(testSet, lbpFeatureSize, cellSize);




% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);
accuracy = sum((predictedLabels == testLabels))/length(testLabels)*100;
toc

% Tabulate the results using a confusion matrix.
%confMat = confusionmat(testLabels, predictedLabels);
%disp(confMat);
%helperDisplayConfusionMatrix(confMat);

disp('Accuracy du mod�le avec les LBP features = ');
disp(accuracy);


violajonesFeatureSize = length(BB);

numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages, violajonesFeatureSize, 'single');

% for i = 1:numImages
%     img = readimage(trainingSet, i);
%     
%     img = rgb2gray(img);
%     
%     % Apply pre-processing steps
%     img = imbinarize(img);
%     
%     trainingFeatures(i, :) = extractLBPFeatures(img,'CellSize',cellSize,'Normalization','None');  
% end

% Get labels for each image.
trainingLabels = trainingSet.Labels;

disp('Training/Loading Machine Learning Model...');
tic
classifier = fitcecoc(trainingFeatures, trainingLabels);
save('training_data.mat','classifier');
load('training_data.mat');


[testFeatures, testLabels] = helperExtractViolaJonesFeaturesFromImageSet(testSet,violajonesFeatureSize);




% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

accuracy = sum((predictedLabels == testLabels))/length(testLabels)*100;
toc

% Tabulate the results using a confusion matrix.
%confMat = confusionmat(testLabels, predictedLabels);
%disp(confMat);
%helperDisplayConfusionMatrix(confMat);

disp('Accuracy du mod�le avec les Viola et Jones features = ');
disp(accuracy);



function helperDisplayConfusionMatrix(confMat)
% Display the confusion matrix in a formatted table.

% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2));

faces = '1':'2260';
colHeadings = arrayfun(@(x)sprintf('%d',x),1:2260,'UniformOutput',false);
format = repmat('%-9s',1,11);
header = sprintf(format,'face  |',colHeadings{:});
fprintf('\n%s\n%s\n',header,repmat('-',size(header)));
for idx = 1:numel(faces)
    fprintf('%-9s',   [faces(idx) '      |']);
    fprintf('%-9.2f', confMat(idx,:));
    fprintf('\n')
end
end

function [features, setLabels] = helperExtractLBPFeaturesFromImageSet(imds, lbpFeatureSize, cellSize)
% Extract LBP features from an imageDatastore.

setLabels = imds.Labels;
numImages = numel(imds.Files);
features  = zeros(numImages, lbpFeatureSize, 'single');

% Process each image and extract features
for j = 1:numImages
    img = readimage(imds, j);
    img = rgb2gray(img);
    
    % Apply pre-processing steps
    img = imbinarize(img);
    
    features(j, :) = extractLBPFeatures(img,'CellSize',cellSize,'Normalization','None'); 
end
end

function [features, setLabels] = helperExtractViolaJonesFeaturesFromImageSet(imds,violajonesFeatureSize)
% Extract Viola Jones features from an imageDatastore.

setLabels = imds.Labels;
numImages = numel(imds.Files);
features  = zeros(numImages, violajonesFeatureSize, 'single');
%BB = zeros(numImages, violajonesFeatureSize, 'single');

% Process each image and extract features

for j = 1:numImages
    img = readimage(imds, j);
    img = rgb2gray(img);
    % Enlarge figure to full screen.
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    drawnow;
    % Get the dimensions of the image.  numberOfColorBands should be = 3.
    [rows columns numberOfColorBands] = size(img)
    
    % The first way to divide an image up into blocks is by using mat2cell().
    blockSizeR = rows/2; % Rows in block.
    blockSizeC = columns/2; % Columns in block.
    
    % Figure out the size of each block in rows.
    % Most will be blockSizeR but there may be a remainder amount of less than that.
    wholeBlockRows = floor(rows / blockSizeR);
    blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
    % Figure out the size of each block in columns.
    wholeBlockCols = floor(columns / blockSizeC);
    blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];
    
    % Create the cell array, ca. 
    % Each cell (except for the remainder cells at the end of the image)
    % in the array contains a blockSizeR by blockSizeC by 3 color array.
    % This line is where the image is actually divided up into blocks.
    if numberOfColorBands > 1    
        ca = mat2cell(img, blockVectorR, blockVectorC, numberOfColorBands);
    else
        ca = mat2cell(img, blockVectorR, blockVectorC);
    end
    
    % Now display all the blocks.
    plotIndex = 1;
    numPlotsR = size(ca, 1);
    numPlotsC = size(ca, 2);

    list = {};
    for r = 1 : numPlotsR
        for c = 1 : numPlotsC
            fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
            % Specify the location for display of the image.
            subplot(numPlotsR, numPlotsC, plotIndex);
            % Extract the numerical array out of the cell
            % just for tutorial purposes.
            rgbBlock = ca{r,c};
            imshow(rgbBlock);
            list{end+1} = rgbBlock;
            %imshow(ca{r,c});
            [rowsB columnsB numberOfColorBandsB] = size(rgbBlock);
            % Make the caption the block number.
            caption = sprintf('Block #%d of %d\n%d rows by %d columns', ...
                plotIndex, numPlotsR*numPlotsC, rowsB, columnsB);
            title(caption);
            drawnow;
            % Increment the subplot to the next location.
            plotIndex = plotIndex + 1;
        end
    end
    
    BB = {};

    combImgDroit = cat(1,list{1}, list{4});
    faceDetector=vision.CascadeObjectDetector('RightEye');
    BB{end+1}=step(faceDetector,combImgDroit);
    iimg = insertObjectAnnotation(combImgDroit, 'rectangle', BB{1}, 'RightEye');
    

    combImgGauche = cat(1,list{2}, list{5});
    faceDetector=vision.CascadeObjectDetector('LeftEye');
    BB{end+1}=step(faceDetector,combImgGauche);
    iimg = insertObjectAnnotation(combImgGauche, 'rectangle', BB{2}, 'LeftEye');
    

    combImgNezBouche = imfuse(list{4}, list{5}, 'montage');
    faceDetector=vision.CascadeObjectDetector('Nose');
    BB{end+1}=step(faceDetector,combImgNezBouche);
    iimg = insertObjectAnnotation(combImgNezBouche, 'rectangle', BB{3}, 'Nose');

    faceDetector=vision.CascadeObjectDetector('Mouth');
    BB{end+1}=step(faceDetector,combImgNezBouche);
    iimg = insertObjectAnnotation(combImgNezBouche, 'rectangle', BB{4}, 'Mouth');
    %m=1;
    %features(j, :) = BB(j,:);
    %m=m+1;
end
end
