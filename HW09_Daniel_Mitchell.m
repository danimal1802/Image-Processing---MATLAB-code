% ===========================================
% Digital Image Processing - Fall 2020
% Final Project - Part I
%                 Arianna Brenes 
%                 Daniel Mitchell
% 
% Due December 9 2020
% ===========================================

I = imread('text2.tif');
figure(1);
imshow (I,[]);
I2 = fft2(I);
I3 = fftshift(I2);
I4 = abs(log(I3));
figure(2)
imshow (I4,[]);
impixelinfo ();

% This was an attempt to clean up the image using specific pixel points
% in the freq domain.  The pixels were hand selected near or at the center
% of the image (low freqency) ... this attempt 
MASK = ones(size(I));
MASK(551,680) = 0;
MASK(551,690) = 0;
MASK(551,670) = 0;
MASK(551,699) = 0;
MASK(551,702) = 0;
MASK(551,661) = 0;
MASK(551,658) = 0;
MASK(551,708) = 0;
MASK(551,712) = 0;

% I also mad an attempt to threshold in the freq domain ... 
% this did not succeed either and I aborted this effort
%
%I4 = (I4 >15.5)
%figure(10)
%imshow (I4,[]);
%MASK = I4./max(I4(:));
%MASK = 1-I4;
%imshow (MASK,[]);
%subplot(6,3,10);

%figure(3)
%imshow(MASK,[]); xlabel('mask')
%I5 = I3.* MASK;
%ubplot(6,3,13);
%imshow(I5, [])

%here i create a high-pass gaussian filter
% As the noise is dart (low freq)
%
G = fspecial('gaussian',size(I), 19);
G= 1-G./max(G(:));
I7 = I5.*G;
figure(4);
imshow(log(abs(I7) + 1), [])

% Here we transform the filtered image back to the spatial domain
%
figure(5);
I8 = real(ifft2(ifftshift(I7)));
imshow(I8,[])

% Using the optimization threashold code supplied from the instructor
% and displaying the final image ... 
final = optithd(I8);
figure(6)
imshow ( final,[])
