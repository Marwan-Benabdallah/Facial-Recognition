ImageDatabasePath ='C:\Users\Marwan\Desktop\Reconnaissance de visages\test';
ImageFiles = dir(ImageDatabasePath);
Train_Number = 0;
Image_Number = 0;
for i = 1:size(ImageFiles,1)
    if not(strcmp(ImageFiles(i).name,'.')|strcmp(ImageFiles(i).name,'..')|strcmp(ImageFiles(i).name,'Thumbs.db'))
        Image_Number = Image_Number + 1; 
    end
end

T = [];

for i = 1:Image_Number
    str = int2str(i);
    str = strcat('\',str,'.jpg');
    str = strcat(ImageDatabasePath,str);
    imt = imread(str);
    [irow icol] = size(imt);
    temp = reshape(imt,irow*icol,1);   
    T = [T temp];                  
end

m = mean(T,2); 
Train_Number = size(T,2);

A = [];  

for i = 1:Image_Number
    temp = double(T(:,i)) - m; 
    A = [A temp];
end

L = A'*A;   

[V D] = eig(L); 

L_eig_vec = [];

for i = 1:size(V,2) 
    if( D(i,i)>1 )
        L_eig_vec = [L_eig_vec V(:,i)];
    end
end

Eigenfaces = A * L_eig_vec;
min_matrix = min(Eigenfaces(:))
max_matrix = max(Eigenfaces(:))
M = mat2gray(Eigenfaces);
min_image = min(M(:))
max_image = max(M(:))
figure
imshow(M)
for i=1:size(Eigenfaces,1)
    imshow(Eigenfaces(i,:))
end