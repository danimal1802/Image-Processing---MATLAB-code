%
%   Digital Image Processing
%   Homework # 4
%   Daniel Mitchell
%
%   NOTE:  I tried two different approaches in Problem 1 
%          (1) Transformations with Rotate, Skew and Aspect ratio independantly
%          (2) With cp2tform()
%          I kept all the code and understand this is verbose and not
%          optimized for performance - I left a trail of images to watch
%          and learn each step of the way.  
%
close all
clear()
% Examine original image and histogram
O = imread('tu.png');
figure(1)
imshow(O)
figure(11)
imhist(O)

% Open and examine the first image to be worked on
I = imread('tub-1.png');
figure(2)
imshow (I)
figure(22)
imhist(I)

%First calculated phi and orientation for rotation
phi = -0.37278 -  pi/2.0

T = [cos(phi) sin(phi) 0; -sin(phi) cos(phi) 0 ; 0 0 1]
tform =maketform('affine', T);
I2 = imtransform(I, tform, 'nearest');
figure(3)
imshow(I2, [])

% Next calculated phi for skew correction
% The exact value comes from my impixelimage points 

phi = .172159

% Perform skew transform
T = [1 0 0; tan(phi) 1 0 ; 0 0 1]
tform =maketform('affine', T);
I3 = imtransform(I2, tform, 'nearest'); 
figure(4)
imshow(I3)

% Crop image
I4 = imcrop(I3,[591 381 1280 960]);
figure(5)
imshow(I4,[])

% Take the negative of the image as it is clearly a negative-variant 
% of a photo
I5 = imcomplement(I);
figure(6)
imshow (I5)

% Correct aspect ratio
s2 = .88125;
s1 = 1.1156;

T = [s1 0 0 ; 0 s2 0; 0 0 1];

% Transform for aspect ratio
tform = maketform('affine', T);
I6 = imtransform(I5, tform, 'bilinear');
figure(7); 
imshow(I6, [])

% Look at the histogram of the resulting image
figure(77)
imhist(I6)

% ==============================================================
% 
% Second approach - using cp2tform() for all transformations 
%

fixedPoints = [1 1; 1 960; 1280 1];

movingPoints = [ 1346 564; 419 1;  927 1608 ];
cpselect(I, O, movingPoints, fixedPoints);

t = cp2tform(movingPoints, fixedPoints, 'affine');

F1 = imtransform(I, t);
F2 = imcomplement(F1);

F3 = imcrop(F2,[555 350 1279 959]);

figure(11);
imshow(F3, [])

% ==============================================================
% 
% Second image transformation - using cp2tform() 
% using the projective option to manage non-linear distortions 
%


F6 = imread('tub-2.png');
figure (15);
imshow(F6)
impixelinfo()
fixedPoints1  = [1 960; 1 1; 1280 1 ; 1280 960  ];
movingPoints1 = [1 928; 131 23; 1239 1; 1280 951  ];
cpselect(F6, O ,movingPoints1, fixedPoints1); 
t1 = cp2tform(movingPoints1, fixedPoints1, 'projective');
F6 = imtransform(F6, t1);
figure(16);
imshow(F6, [])

% use the negative value of this images grey values 
F7= imcomplement(F6);
F8 = imcrop( F7, [164 32 1279 959]);

% The following are here for analysis
figure(17)
imshow(F8);
figure(18)
imhist(F8);
figure(19)
imshow( abs(double(O)-double(F3)) , [0 127] );
% also ran range [0 255]
figure(20)
imshow( abs(double(O)-double(F8)) , [0 127] );
% also ran range [0 255]