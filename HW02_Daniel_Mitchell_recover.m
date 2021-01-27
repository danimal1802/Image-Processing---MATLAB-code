%
%  Homework 02 - Daniel Mitchell - 17 Sep 2020
%

I = imread('sensor_data.png');

% Display original image
subplot (1,3,1); 
imshow (I); xlabel('Original Image');

% Call function with original image and display 
IDM = demosaic_dan(I);
subplot (1,3,2); imshow (uint8(IDM)); xlabel('My Demosaic v4');

% Create and show MATLAB Demosaic
I_MATLAB = demosaic(I,'gbrg');
subplot (1,3,3);
imshow(I_MATLAB,[]); xlabel('MATLAB Demosaic');

% FUNCTION to Demosaic
function [IDM] = demosaic_dan(I)

ID = double(I);
EDGE = size(ID,1);
a = mod(1:EDGE,2);
[y,x] = meshgrid(1:EDGE,1:EDGE);

% Process the red channel from the checkerboard-mask values only
RED = circshift(a'*a,1,1);
[redx,redy] = ind2sub([EDGE EDGE],find(RED));
rnew = griddata (redx,redy,ID(RED==1),x,y,'v4');

% Process the green channel from the checkerboard-mask values only
GREEN = a'*a + circshift(RED,1,2); 
[greenx,greeny] = ind2sub([EDGE EDGE],find(GREEN));
gnew = griddata (greenx,greeny,ID(GREEN==1),x,y,'v4');

% Process the blue channel from the checkerboard-mask values only
BLUE = circshift(a'*a,1,2); 
[bluex,bluey] = ind2sub([EDGE EDGE],find(BLUE));
bnew = griddata (bluex,bluey,ID(BLUE==1),x,y,'v4');

% Create the final composite color image
IDM = cat(3,rnew,gnew,bnew);

end