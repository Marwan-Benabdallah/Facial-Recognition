%I = double(imread('TestDatabase\8.jpg'));
%X = reshape(I,size(I,1)*size(I,2),3);
%coeff = pca(X);
%Itransformed = X*coeff;
%Ipc1 = reshape(Itransformed(:,1),size(I,1),size(I,2));
%Ipc2 = reshape(Itransformed(:,2),size(I,1),size(I,2));
%Ipc3 = reshape(Itransformed(:,3),size(I,1),size(I,2));
%figure, imshow(Ipc1,[]);
%figure, imshow(Ipc2,[]);
%figure, imshow(Ipc3,[]);
I = imread('TestDatabase\8.jpg');
figure
imshow(I)
N = im2double(I);
P = pca(N);
disp(P);
min_matrix = min(P(:))
max_matrix = max(P(:))
K = mat2gray(P);
min_image = min(K(:))
max_image = max(K(:))
figure
imshow(K)


% m = mean(N,2);
% A = [];
% temp = double(N(:,1)) - m;
% A = [A temp];
% 
[V,D] = eig(P);
disp(V);
disp(D);

L_eig_vec = [];
for i = 1 : size(V,2) 
    if( D(i,i) > 1 )
        L_eig_vec = [L_eig_vec V(:,i)];
    end
end

disp(size(L_eig_vec,1));
disp(size(P,2));
%eigenfaces = P * L_eig_vec;
%O = mat2gray(P);
%imshow(O);

% %I = imread('C:\Users\Marwan\Desktop\Reconnaissance de visages\TestDatabase\318.jpg');
% folder = fullfile(matlabroot, 'Reconnaissance de visages\TestDatabase');
% baseFileName = '318.jpg';
% fullFileName = fullfile(folder, baseFileName);
% fullFileName = fullfile(folder, baseFileName);
% fontSize = 20;
% if ~exist(fullFileName, 'file')
%     fullFileName = baseFileName;
%     if ~exist(fullFileName, 'file')
%         errorMessage = sprintf('Error: %s does not exist.', fullFileName);
%         uiwait(warndlg(errorMessage));
%         return;
%     end
% end
% grayImage = imread(fullFileName);
% [rows columns numberOfColorBands] = size(grayImage);
% figure;
% subplot(2, 2, 1);
% imshow(grayImage, []);
% title('Original Grayscale Image', 'FontSize', fontSize);
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% 
% % Divide the image up into 4 blocks.
% % Let's assume we know the block size and that all blocks will be the same size.
% blockSizeR = 56; % Rows in block.
% blockSizeC = 46; % Columns in block.
% % Figure out the size of each block.
% wholeBlockRows = floor(rows / blockSizeR);
% wholeBlockCols = floor(columns / blockSizeC);
% % Preallocate a 3D image
% image3d = zeros(wholeBlockRows, wholeBlockCols, 3);
% % Now scan though, getting each block and putting it as a slice of a 3D array.
% sliceNumber = 1;
% for row = 1 : blockSizeR : rows
%     for col = 1 : blockSizeC : columns
%         % Let's be a little explicit here in our variables
%         % to make it easier to see what's going on.
%         % Determine starting and ending rows.
%         row1 = row;
%         row2 = row1 + blockSizeR - 1;
%         row2 = min(rows, row2); % Don't let it go outside the image.
%         % Determine starting and ending columns.
%         col1 = col;
%         col2 = col1 + blockSizeC - 1;
%         col2 = min(columns, col2); % Don't let it go outside the image.
%         % Extract out the block into a single subimage.
%         oneBlock = grayImage(row1:row2, col1:col2);
%         % Specify the location for display of the image.
%         subplot(2, 2, sliceNumber);
%         imshow(oneBlock);
%         % Make the caption the block number.
%         caption = sprintf('Block #%d of 4', sliceNumber);
%         title(caption, 'FontSize', fontSize);
%         drawnow;
%         % Assign this slice to the image we just extracted.
%         if (row2-row1+1) == blockSizeR && (col2-col1+1) == blockSizeC
%             % Then the block size is the tile size,
%             % so add a slice to our 3D image stack.
%             image3D(:, :, sliceNumber) = oneBlock;
%         else
%             newTileSize = [(row2-row1+1), (col2-col1+1)];
%             warningMessage = sprintf('Warning: this block size of %d rows and %d columns\ndoes not match the preset block size of %d rows and %d columns.\nIt will not be added to the 3D image stack.',...
%                 newTileSize(1), newTileSize(2), blockSizeR, blockSizeC);
%             uiwait(warndlg(warningMessage));
%         end
%         sliceNumber = sliceNumber + 1;
%     end
% end
% % Now image3D is a 3D image where each slice,
% % or plane, is one quadrant of the original 2D image.
% 
% % imSz = size(I);
% % patchSz = [100 100];
% % xIdxs = [1:patchSz(2):imSz(2) imSz(2)+1];
% % yIdxs = [1:patchSz(1):imSz(1) imSz(1)+1];
% % patche = cell(length(yIdxs)-1,length(xIdxs)-1);
% % for i = 1:length(yIdxs)-1
% %     Isub = I(yIdxs(i):yIdxs(i+1)-1,:);
% %     for j = 1:length(xIdxs)-1
% %         patche{i,j} = Isub(:,xIdxs(j):xIdxs(j+1)-1);
% %     end
% % end
% % disp(patche);
% % figure
% % for i=1:size(patche)
% %     imagesc(patche{i,1});
% % end
% % %figure, imagesc(patche{1,1})
