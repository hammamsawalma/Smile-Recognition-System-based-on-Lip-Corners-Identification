%% Training Part for FAST corner detector 
clear all ; close all ; clc ;
w = 0 ;
FASTSum = 0 ; 
for i = 1 : 14
images ='C:\Users\hsawa\OneDrive\Desktop\Imge\MyDataSet\Smiling\Training';
jpgfiles=dir(fullfile(images,'\*.jpg*')); n=numel(jpgfiles(i)); I1=jpgfiles(i).name;
I=imread(fullfile(images,I1));
J = I ; R = J(:,:,1);G = J(:,:,2); B = J(:,:,3);
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
corners1 = detectFASTFeatures(IoutG); 
if corners1.Count == 0 %% Check if any corner detected or no 
    FASTSum = FASTSum ; 
    w = w + 1 ; 
else  
FASTSum = FASTSum +  corners1.Location(1,2);
w = w + 1 ;
end
end
FASTAVG = FASTSum / ( w +1 )

%% Testing Part

prompt = 'What is the test file name? ';
name=input(prompt,'s');
Itest = imread(name); 
J = Itest ; 
Rt = J(:,:,1);Gt = J(:,:,2); Bt = J(:,:,3);
Iout = zeros(size(J)); x = size(J,1); z = size(J,2); 
Routt = zeros(x,z); Goutt = zeros(x,z); Boutt = zeros(x,z); 
 for Ro=1:x
    for C=1:z
        pixelRed=Rt(Ro,C);
        pixelGreen=Gt(Ro,C); 
        pixelBlue=Bt(Ro,C);
        if (( pixelRed > 80) && (pixelGreen < 80) && (pixelBlue < 100))
           Routt(Ro,C) = Rt(Ro,C);
           Goutt(Ro,C) = Gt(Ro,C);
           Boutt(Ro,C) = Bt(Ro,C);
        else 
           Routt(Ro,C) = 0;
           Goutt(Ro,C) = 0;
           Boutt(Ro,C) = 0;    
        end 
    end
 end
 
IoutRGB = cat(3,Routt ,Goutt ,Boutt);
IoutGt = rgb2gray(IoutRGB);
corners2 = detectFASTFeatures(IoutGt);
if corners2.Count == 0 %% Check if any corner detected or no 
    disp('No corner detected :('); 
else 
FASTValue = corners2.Location(1,2);
disp('The loocation of the most left corner = ');
disp(FASTValue); 
if FASTValue < FASTAVG 
    disp('Smiling'); 
else 
    disp('Non-smiling'); 
end 
end

figure; imshow(Itest);
figure; imshow(IoutGt); hold on;
plot(corners2);

