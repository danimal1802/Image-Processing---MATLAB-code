% ===================================================================
% Homework 05 - Daniel Mitchell
% Digital image processing
% Rotating Mask Filter
% Mean and dispersion calculations 
% NOTE: The 7 images were created from 2 runs 
%     To rerun - edit lines 10 (input image) 
%                     line 14 (input image name)
%                     line 56,57 and 61,62 and 64 accordingly
% ===================================================================

I = imread('lizard_sn.png');
I = double(I);                        % convert image to type double
subplot (3,3,4); 

imshow(I, []); xlabel('original sn');    % show image 

m = zeros(size(I, 1), size(I, 2), 8); % 
v = zeros(size(I, 1), size(I, 2), 8); % 

fun  = @fm;                           % define function for mean
fun2 = @fv;                           % define function for dispersion

m(:,:,1) = nlfilter(I, [5 5], fun, 1);      % mask position 1
v(:,:,1) = nlfilter(I, [5 5], fun2,1);

m(:,:,2) = nlfilter(I, [5 5], fun, 2);      % mask position 2
v(:,:,2) = nlfilter(I, [5 5], fun2,2);

m(:,:,3) = nlfilter(I, [5 5], fun, 3);      % mask position 3
v(:,:,3) = nlfilter(I, [5 5], fun2,3);

m(:,:,4) = nlfilter(I, [5 5], fun, 4);      % mask position 4
v(:,:,4) = nlfilter(I, [5 5], fun2,4);

m(:,:,5) = nlfilter(I, [5 5], fun, 5);      % mask position 5
v(:,:,5) = nlfilter(I, [5 5], fun2,5);

m(:,:,6) = nlfilter(I, [5 5], fun, 6);      % mask position 6
v(:,:,6) = nlfilter(I, [5 5], fun2,6);

m(:,:,7) = nlfilter(I, [5 5], fun, 7);      % mask position 7
v(:,:,7) = nlfilter(I, [5 5], fun2,7);

m(:,:,8) = nlfilter(I, [5 5], fun, 8);      % mask position 8
v(:,:,8) = nlfilter(I, [5 5], fun2,8);

[C, In] = min(v, [], 3);

[x, y] = ind2sub(size(I), (1:size(I, 1)*size(I, 2))');
z = In(:);
idx = sub2ind(size(v), uint32(x), uint32(y), uint32(z));

MEAN_TMP = m(idx);
MEAN = reshape(MEAN_TMP, size(I));
subplot(3,3,5);
imshow(MEAN, []); xlabel('mean sn')

DISP_TMP = v(idx);
DISP = reshape(DISP_TMP, size(I));
subplot(3,3,6);
imshow(DISP, []); xlabel('dispersion sn')

subplot(3,3,9);
filteredImage = conv2(single(I) , ones(5,5)/25, 'same');
imshow(filteredImage, []); xlabel('MATLAB AVG filter sn')





