close all;
clear all;

% READ IMAGE
% img = imread("OFTA/o_sr213.bmp");
% img = imread("images/artificial_eye.jpg");
img = generate_Aeye(130, 130*0.3, 600, 400);
if 0
    figure(11)
    imshow(img)
end

% DECREASE IMAGE RESOLUTION
resolution_ratio = 1;
img_dec = decrease_resolution(img, resolution_ratio);
if 0
    figure(12)
    imshow(img_dec)
end

% EDGE DETECTION
filter_len = 4;
rgb2gray = false;
[img_edges, shift] = detect_edges(img_dec, filter_len, rgb2gray, 4, 3);


% CALCULATE TRANSFROM
r_min = 129;
r_max = 131;
threshold = 0.1;

% Houghe
HS = hough_transform(img_edges, r_min, r_max, threshold);

% DISPLAY THE BEST MATCHING CIRCLE
[max_value, max_index] = max(HS(:));
[y_true, x_true, r_true_index] = ind2sub(size(HS), max_index);
r_true = r_min + r_true_index - 1;
x_true = x_true+ shift(1);
y_true = y_true + shift(2);
figure(2)
imshow(img_dec);
title(['r=', num2str(r_true), ', x=', num2str(x_true), ', y=', num2str(y_true)]);
hold on;
viscircles([x_true, y_true], r_true, 'EdgeColor', 'r');
hold off;



% DISPLAY EDG_DETECTION IMAGE
show = 0;

if show
    figure(2)
    subplot(2,2,1)
    imshow(img_edges)
    subplot(2,2,2)
    mesh(img_edges)
end


% DISPLAY HOUGH SPACE
if show
    subplot(2,2,4)
    mesh(HS(:,:,r_true_index))
    subplot(2,2,3)
    imagesc(HS(:,:,r_true_index))
end






% r_min = 125;
% r_max = 135;
% 
% [rows, cols] = size(img);
% A = zeros(rows, cols, r_max - r_min + 1);
% 
% % Compute the gradient magnitude of the image
% [Gx, Gy] = gradient(img);
% V = sqrt(Gx.^2 + Gy.^2);
% 
% for x = 1:cols
%     for y = 1:rows
%         for r = r_min:r_max
%             for theta = 0:pi/180:2*pi
%                 % Calculate the center coordinates
%                 xc = round(x - r * cos(theta));
%                 yc = round(y - r * sin(theta));
% 
%                 % Check if the center coordinates are within the image bounds
%                 if xc >= 1 && xc <= cols && yc >= 1 && yc <= rows
%                     A(y, x, r - r_min + 1) = A(y, x, r - r_min + 1) + V(yc, xc);
%                 end
%             end
%         end
%     end
% end