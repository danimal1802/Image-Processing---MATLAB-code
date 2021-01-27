% ==========================================
% Digital Image Processing
% Homework 06
% Daniel Mitchell
% 22 Oct 2020
% Edge Detection
% ==========================================

I = imread('tu_n.png');  % Read initial image
I = double(I);           % Double I variable
subplot(4,4,1); imshow(I,[]); xlabel('original image') 

% Preprocessing nose reduction for GAUSSIAN - uncomment to run
%
%
%  I = conv2(double(I), ones(3)/9, 'same');

% Set up Kirsch operation and convolution
[X Y Z ]= size(I);
x = double([ 5  5  5;
            -3  0 -3; 
            -3 -3 -3 ] / 15 );
        
% From figure2 in the Homework - gradiant directions
kirsch_arrays = zeros(X, Y, 8);  % Create and initalize 8 Kirsch arrays
gradDir = zeros(X,Y,8);
for i = 1:8
    theta = 45 * (i-1);
    direction = imrotate(x, theta, 'crop');
    kirsch_arrays(:, :, i) = conv2(I, direction, 'same');
end

[C, In] = max(kirsch_arrays, [], 3);
Image_1 = reshape(C, [960,1280]);
subplot(4,4,5);
imshow(Image_1,[]) 
xlabel('Max response from the 8 angles')

radians = [0, 0.7854,1.5708, 2.3562, 3.14, -2.3562, -1.5708, -0.7854]
for i = 1:8
    gradDir(:,:,i) = radians(i);
end
[a,b] = ind2sub(size(I), (1:size(I,1)*size(I, 2))');
c = In(:);
idx = sub2ind(size(kirsch_arrays), uint32(a), uint32(b), uint32(c));

S = gradDir(idx);
Image_2 = reshape(S, [960,1280]);
subplot(4,4,6);
imshow(Image_2, [])
xlabel('grad direction no thresh. - 8 angles');

t1 = 20;
Image_2(Image_1<t1) = 6;

subplot(4,4,7);
imshow(Image_2,[])
xlabel('grad. direction with thresh. 8 angles');


[X1 Y1 Z1] = size(I);
x1= double([ 5  5  5;
            -3  0 -3; 
            -3 -3 -3 ] );
kirschOp1 = zeros(X1, Y1, 4);         % Create Kirsch planes - one for each 8 orientations
for i = 1:4
    theta = 90 * (i-1);         % Now capturing only 2x horiz and 2xvertical angles
    direction1 = imrotate(x1, theta, 'crop');
    kirschOp1(:, :, i) = conv2(I, direction1, 'same');
end

[C1, In1] = max(kirschOp1,[],3);

Image_3 = reshape(C1, [960,1280]);
subplot(4,4,9);
imshow(Image_3, []);
xlabel('gradient magn - horiz & vert');

grad = zeros(X,Y,4);

for i = 1:4
    grad(:,:,i) = kirsch_arrays(:,:,i);
end

P = atan2(grad(:,:,2),grad(:,:,1));
Image_4 = reshape(P, [960, 1280]);

subplot(4,4,10);
imshow(Image_4,[])
xlabel('grad. direction no thresh.- horiz & vert');

t2 = 280;

Image_4(Image_3<t2) = 6;

subplot(4,4,11);
imshow(Image_4, [])
xlabel('grad. direction w/ Threshold');



