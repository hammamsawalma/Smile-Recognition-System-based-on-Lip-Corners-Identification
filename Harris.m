%% Training Part for Harris Corner Detector

clear all ; close all ; clc ;
w = 0 ;
HarrisSum = 0 ; 
for i = 1 : 14 % Set to number of training data 
images ='C:\Users\hsawa\OneDrive\Desktop\Imge\MyDataSet\Smiling\Training'; % Dir for training data 
jpgfiles=dir(fullfile(images,'\*.jpg*')); n=numel(jpgfiles(i)); I1=jpgfiles(i).name;
I=imread(fullfile(images,I1));
J = I ;  R = J(:,:,1); G = J(:,:,2); B = J(:,:,3);
Iout = zeros(size(J));  x = size(J,1);  z = size(J,2); 
Rout = zeros(x,z);  Gout = zeros(x,z);  Bout = zeros(x,z); % Color Segmentation Color Channels
 
 for Ro=1:x
    for C=1:z
        pixelRed=R(Ro,C);
        pixelGreen=G(Ro,C); 
        pixelBlue=B(Ro,C);
        if (( pixelRed > 40) && (pixelGreen < 80) && (pixelBlue < 80))
           Rout(Ro,C) = R(Ro,C);
           Gout(Ro,C) = G(Ro,C);
           Bout(Ro,C) = B(Ro,C);
        else 
           Rout(Ro,C) = 0;
           Gout(Ro,C) = 0;
           Bout(Ro,C) = 0;    
        end 
    end
 end
 
IoutRGB = cat(3,Rout ,Gout ,Bout); % New image after the color Segmentation 
IoutG = rgb2gray(IoutRGB); % Convert from RGB to Gray 
corners1 = detectHarrisFeatures(IoutG); % Built in Function to find Corners using Harris method
HarrisSum = HarrisSum +  corners1.Location(1,2); % Finding the Sum of the most left corner of the lip
w = w + 1 ; 
end
HarrisAVG = HarrisSum / (w+1) ; % Calculation of the Harris Corners AVG to be used to determine if smiling or no
disp('Location Average ='); 
disp(HarrisAVG); 

%% Testing Part

prompt = 'What is the test file name? ';
name=input(prompt,'s');
Itest = imread(name); 
J = Itest ; 
R = J(:,:,1);G = J(:,:,2); B = J(:,:,3);
Iout = zeros(size(J)); x = size(J,1); z = size(J,2); 
Rout = zeros(x,z); Gout = zeros(x,z); Bout = zeros(x,z); 
 for Ro=1:x
    for C=1:z
        pixelRed=R(Ro,C);
        pixelGreen=G(Ro,C); 
        pixelBlue=B(Ro,C);
        if (( pixelRed > 80) && (pixelGreen < 80) && (pixelBlue < 100))
           Rout(Ro,C) = R(Ro,C);
           Gout(Ro,C) = G(Ro,C);
           Bout(Ro,C) = B(Ro,C);
        else 
           Rout(Ro,C) = 0;
           Gout(Ro,C) = 0;
           Bout(Ro,C) = 0;    
        end 
    end
 end
 
IoutRGB = cat(3,Rout ,Gout ,Bout);
IoutG = rgb2gray(IoutRGB);
corners2 = detectHarrisFeatures(IoutG);
HarrisValue = corners2.Location(1,2);
disp('The location of the most left corner = ');
disp(HarrisValue); 
if HarrisValue < HarrisAVG 
    disp('Smiling'); 
else 
    disp('Non-smiling'); 
end 

figure; imshow(Itest);
figure; imshow(IoutG); hold on;
plot(corners2);

