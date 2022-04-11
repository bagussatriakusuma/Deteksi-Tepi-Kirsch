clc; clear; close all; warning off all;

%input data citra uji
A=imread('biji12.png');

%mengubah citra uji menjadi greyscale
gray=double(rgb2gray(A));
figure,imshow(gray,[])


%konvolusi deteksi tepi metode kirsch
kirsch1 = [-3 -3 5; -3 0 5; -3 -3 5];
kirsch2 = [-3 5 5; -3 0 5; -3 -3 -3];
kirsch3 = [5 5 5; -3 0 -3; -3 -3 -3];
kirsch4 = [5 5 -3; 5 0 -3; -3 -3 -3];
kirsch5 = [5 -3 -3; 5 0 -3; 5 -3 -3];
kirsch6 = [-3 -3 -3; 5 0 -3; 5 5 -3];
kirsch7 = [-3 -3 -3; -3 0 -3; 5 5 5];
kirsch8 = [-3 -3 -3; -3 0 5; -3 5 5];
data1 = conv2(gray,kirsch1,'same');
data2 = conv2(gray,kirsch2,'same');
data3 = conv2(gray,kirsch3,'same');
data4 = conv2(gray,kirsch4,'same');
data5 = conv2(gray,kirsch5,'same');
data6 = conv2(gray,kirsch6,'same');
data7 = conv2(gray,kirsch7,'same');
data8 = conv2(gray,kirsch8,'same');
formula = sqrt((data1.^2)+(data2.^2)+(data3.^2)+(data4.^2)+(data5.^2)+(data6.^2)+(data7.^2)+(data8.^2));
figure,imshow(data1,[])
figure,imshow(data2,[])
figure,imshow(data3,[])
figure,imshow(data4,[])
figure,imshow(data5,[])
figure,imshow(data6,[])
figure,imshow(data7,[])
figure,imshow(data8,[])
figure,imshow(formula,[])

%transfer konvolusi menjadi logical dan mengubah ke citra biner
%(thresholding)
transfer=uint8(formula);
biner=imbinarize(transfer,.9);
figure,imshow(biner)

%proses morfologi
thresh=imclearborder(biner);
morf=imfill(thresh,'holes');
morf2=bwareaopen(morf,100);
figure,imshow(morf)

%melabeli citra uji
[labeled,numObjects]=bwlabel(morf2);
figure,imshow(labeled,[])
labeledrgb=label2rgb(labeled);
figure,imshow(labeledrgb,[])

%membuat bounding box dan perhitungan
eks=regionprops(labeled,'Area','Perimeter','BoundingBox');
luas=cat(1,eks.Area);
keliling=cat(1,eks.Perimeter);
bbox=cat(1,eks.BoundingBox);
metric=4*pi*luas/(keliling.^2);

for k= 1:numObjects
    if metric(k)>=0.7
        A = insertObjectAnnotation(A,'rectangle',bbox(k,:),'Robusta',...
            'LineWidth',3,'Color','blue','FontSize',24);
    else
        A = insertObjectAnnotation(A,'rectangle',bbox(k,:),'Liberika',...
            'LineWidth',3,'Color','red','FontSize',24);
    end
end

figure,imshow(A);