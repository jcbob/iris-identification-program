image = imread("iris3.jpg");
image = rgb2gray(image);
image = im2double(image);
% figure()
% imshow(image)

% % Define Gaussian filter kernel
% sigma = 15;  % Standard deviation
% filter_size = 5*sigma;  % Filter size
% kernel = fspecial('gaussian', filter_size, sigma);
% 
% % Apply Gaussian filter
% filtered_image = imfilter(image, kernel, 'conv', 'replicate');



image = filtered_image;
tmp_image = filtered_image;

[row, col] = size(image);

for y = 2:row-1
    for x = 2:col-1
        % tmp = ((0.5 * (image(y, x+1) - image(y, x-1)))^2) + ((0.5 * (image(y+1, x) - image(y-1, x)))^2);
        tmp = (((image(y, x+1) - image(y, x)))^2) + (((image(y+1, x) - image(y, x)))^2);
        % tmp = (((image(y, x) - image(y, x-1)))^2) + (((image(y, x) - image(y-1, x)))^2);
        tmp_image(y, x) = sqrt(tmp);
    end
end

tmp_image = tmp_image*50;
figure()
imshow(tmp_image)

