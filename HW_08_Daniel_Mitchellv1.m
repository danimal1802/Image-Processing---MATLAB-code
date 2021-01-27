% ===========================
% Digital Image Processing
% Homework 08
% 1 Nov 2020
% Daniel Mitchell
% ===========================

load('fn.mat');
%I=double(I);
figure(1)
%subplot(3,3,1); imshow(uint8(I),[])

R = fn(:,:,1);
G = fn(:,:,2);
B = fn(:,:,3);

% DISPLAY RGB RAW CHANNELS 
figure(1)
%subplot(6,3,2); imshow(fn,[]);    THIS DOES NOT WORK
subplot(6,3,4);imshow(R,[]);xlabel('red');
subplot(6,3,5);imshow(G,[]);xlabel('green');
subplot(6,3,6);imshow(B,[]);xlabel('blue');
original_image = cat(3,R,G,B);
subplot(6,3,2);imshow(uint8(original_image),[]);xlabel('original');

% FIRST - GREEN CHANNEL with MEDFILT to remove SALT & PEPPER
% operate on salt and pepper noise in the green channel first
% this channel appear to be easily corrected
n = 3;
G2 = medfilt2(G, [n n]);
subplot(6,3,8); imshow(G2,[]); xlabel('G2 green filtered');
greenfixed_image = cat(3,R,G2,B);
subplot(6,3,11);imshow(uint8(greenfixed_image),[]);xlabel('fixed salt&pepper');

% SECOND - operate on the BLUE CHANNEL to remove vertical HI freq banding
B2 = fft2(B);
B2S = fftshift(B2);
% Using sigma of 21 - as the ideal threshold
% any number higher allows the hi-freq vertical banding to remain
% numbers lower blurs the image more than necessary
GAUSS1 = fspecial('gaussian',size(B2), );
GAUSS1 = GAUSS1./max(GAUSS1(:));
GAUSS2 = fspecial('gaussian',size(B2), 1);
GAUSS2 = GAUSS2./max(GAUSS2(:));
GAUSS3 = GAUSS1-GAUSS2;
GAUSS3 = GAUSS3./max(GAUSS3(:));
B2S = B2S.*GAUSS3;
subplot (6,3,12); imshow( log(abs(B2S) + 1), []);
B3 = real(ifft2(ifftshift(B2S)));
subplot (6,3,15); imshow(B3,[]); xlabel('Blue filtered')
bluefixed_image = cat(3,R,G2,B3);
subplot(6,3,18);imshow(uint8(bluefixed_image),[]);xlabel('green & blue filtered');

% THIRD - FIX RED CHANNEL
% With the help from the TA and some intuition
% I find the following pixels in the FFT image in the red channel
R2 = fft2(R);
R3 = fftshift(R2);
R4 = abs(log(R3));
subplot(6,3,7); 
figure(2);
imshow(R4,[]); xlabel ('R4')
figure(1);
MASK_RED = ones(size(R));
%MASK_RED(249,257) = 0;
%MASK_RED(265,257) = 0;
subplot(6,3,10);
imshow(MASK_RED,[]); xlabel('mask')
R5 = R3.* MASK_RED;
%subplot(6,3,13);
%imshow(log(abs(R5) + 1), [])
R6 = abs(ifft2(ifftshift(R5)));
subplot(6,3,16);
imshow(R6,[])
figure(3);
R7 = cat(3,R6,G2,B3);
imshow(uint8(R7),[]);xlabel('final');
