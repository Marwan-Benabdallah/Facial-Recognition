 %#function vision
faceDetector=vision.CascadeObjectDetector('FrontalFaceLBP'); %Creer un detecteur d'objets
img=imread('EN2.jpg'); %Lire l'input image
%img=rgb2gray(img); % convertir en niveau de gris
BB=step(faceDetector,img); % Detecter les visages
iimg = insertObjectAnnotation(img, 'rectangle', BB, 'Face'); %Annoter les visages detectés
figure(1);
imshow(iimg); 
title('Visages détectés');
hold on
for i=1:size(BB,1)
    rectangle('position',BB(i,:),'Linewidth',2,'Linestyle','-','Edgecolor','y');
end
hold on
N=size(BB,1);
handles.N=N;
counter=1;
for i=1:N
    face=imcrop(img,BB(i,:));
    savenam = strcat('C:\Users\Marwan\Desktop\Facial-Recognition' ,num2str(counter), '.jpg'); %Image sauvegardée à cet emplacement
    baseDir  = 'C:\Users\Marwan\Desktop\Facial-Recognition\TestDatabase\';
    newName  = [baseDir num2str(counter) '.jpg'];
    handles.face=face;
    while exist(newName,'file')
        counter = counter + 1;
        newName = [baseDir num2str(counter) '.jpg'];
    end
    fac=imresize(face,[112,92]);
    imwrite(fac,newName);
end