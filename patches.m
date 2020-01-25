clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;

% Read in a standard MATLAB color demo image.
folder = fullfile(matlabroot, 'Reconnaissance de visages\TestDatabase');
baseFileName = '350.jpg';
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
%rgbImage = rgb2gray(rgbImage);


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

REye = mat2gray(list{1});
% figure;
% imshow(REye);
faceDetector=vision.CascadeObjectDetector('RightEye');
BB=step(faceDetector,REye);
iimg = insertObjectAnnotation(REye, 'rectangle', BB, 'RightEye');
figure;
imshow(iimg);

LEye = mat2gray(list{2});
% figure;
% imshow(LEye);
faceDetector=vision.CascadeObjectDetector('LeftEye');
BB=step(faceDetector,LEye);
iimg = insertObjectAnnotation(LEye, 'rectangle', BB, 'LeftEye');
figure;
imshow(iimg);

Mouth = mat2gray(list{4});
% figure;
% imshow(Mouth);
Nose = mat2gray(list{5});
% figure;
% imshow(Nose);
combImg = imfuse(Mouth, Nose, 'montage');
%imshow(combImg);

faceDetector=vision.CascadeObjectDetector('Mouth');
BB=step(faceDetector,combImg);
iimg = insertObjectAnnotation(combImg, 'rectangle', BB, 'Mouth');
figure;
imshow(iimg);

faceDetector=vision.CascadeObjectDetector('Nose');
BB=step(faceDetector,combImg);
iimg = insertObjectAnnotation(combImg, 'rectangle', BB, 'Nose');
figure;
imshow(iimg);

% Display the original image in a new figure.
figure;
imshow(rgbImage);
title('Original Image');