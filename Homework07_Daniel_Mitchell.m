% ===========================================
% Digital Image Processing - Fall 2020
% Homework 07 - Daniel Mitchell
%
% Edge Detection II
% Due Oct 29 2020
% ===========================================

% Read image and convert to double
%
%  adjust image input as needed 
%            |
%            |
%            V
i = imread('B.png');
%i = double(I);
figure(1)
subplot(5,5,1);
imshow(i); xlabel('original image')
impixelinfo();
figure(2); imshow(i); figure(1);

% split out the colors, r, g, b channels and display
I_red   = i(:,:,1);   % extract red channel
I_green = i(:,:,2);   % extract green channel
I_blue  = i(:,:,3);   % extract blue channel
subplot(5,5,6); imshow(I_red); xlabel('red channel');
subplot(5,5,7); imshow(I_green); xlabel('green channel');
subplot(5,5,8); imshow(I_blue); xlabel('blue channel');

% create and split out the h,s,v channels and display 
I_hsv = rgb2hsv(i);
I_hsv_h = I_hsv(:,:,1); 
I_hsv_s = I_hsv(:,:,2); 
I_hsv_v = I_hsv(:,:,3); 
subplot(5,5,11); imshow(I_hsv_h, []);xlabel('h channel');
subplot(5,5,12); imshow(I_hsv_s, []);xlabel('s channel');
subplot(5,5,13); imshow(I_hsv_v, []);xlabel('v channel');

% Using S-channel(HSV) - perform a FFT to lessen the high freq grid
I = fft2(I_hsv_s);
I2 = fftshift(I);
G = fspecial('gaussian',size(I_hsv_s), 55);
G = G./max(G(:));

subplot(5,5,14); imshow(log(abs(I2)+ 1),[]); xlabel('fft log(abs(image)+1)')
subplot(5,5,15); imshow(G,[]); xlabel('G kernel')
subplot(5,5,16); mesh(G); 

I2 = I2.*G;
subplot(5,5,17); imshow(log(abs(I2) + 1), []); xlabel('Manipulated spectrum')
A = real(ifft2(ifftshift(I2)));
figure (1)
subplot(5,5,18); 
imshow(A,[]); xlabel ('inverse fft')
%impixelinfo() - this was used to determine fillowing threshold 
figure(5)
imshow(A,[]); xlabel('inverse fft')
impixelinfo()

% Convert to a binary image using threshold from emperical testing
BW = im2bw(A,.40);   
figure(10)
imshow(BW,[]); xlabel('binary of fft filter w/ thresh.')
 
% With the binary image and clean edges - doing edge detection
% Set up Kirsch operation and convolution
[X Y Z ]= size(BW);
x = double([ 5  5  5;
            -3  0 -3; 
            -3 -3 -3 ] / 15 );
        
% From figure2 in the Homework 06 - gradiant directions
kirsch_arrays = zeros(X, Y, 8);  % Create and initalize 8 Kirsch arrays
gradDir = zeros(X,Y,8);
for i = 1:8
    theta = 45 * (i-1);
    direction = imrotate(x, theta, 'crop');
    kirsch_arrays(:, :, i) = conv2(BW, direction, 'same');
end

[C, In] = max(kirsch_arrays, [], 3);
Image_1 = reshape(C, [1200,1600]);
figure(20)
imshow(Image_1,[]); xlabel('Max response from the 8 angles')
figure(1)
subplot(5,5,21); imshow(Image_1,[]);

% End of code






