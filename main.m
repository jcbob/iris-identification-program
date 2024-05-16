close all;
clear all;

% READ IMAGE
img = imread("OFTA/o_sr211.bmp");
% img = imread("images/artificial_eye.jpg");
% img = generate_Aeye(130, 130*0.3, 600, 400);

if 0
    figure(11)
    imshow(img)
end

% DECREASE IMAGE RESOLUTION
resolution_ratio = 0.5;
img_dec = decrease_resolution(img, resolution_ratio);
img_gray = rgb2gray(img_dec);
if 0
    figure(12)
    imshow(img_dec)
end

% EDGE DETECTION
filter_len = 4;
rgb2gray = true;
[img_edges, shift] = detect_edges(img_dec, filter_len, rgb2gray, 4, 7);


% FIND IRIS CIRCLE
r_min = 120;
r_max = 150;
threshold = 0.1;
HS_iris = hough_transform(img_edges, r_min, r_max, threshold);
% Display
[max_value, max_index] = max(HS_iris(:));
[Y, X, R_index] = ind2sub(size(HS_iris), max_index);
R = r_min + R_index - 1;
X = X + shift(1);
Y= Y + shift(2);

figure(2)
imshow(img_dec);
title(['r=', num2str(R), ', x=', num2str(X), ', y=', num2str(Y)]);
hold on;
viscircles([X, Y], R, 'EdgeColor', 'r');
% hold off;


% FIND PUPIL CIRCLE
r_min = 35;
r_max = 70;
threshold = 0.1;
HS_pupil = hough_transform(img_edges, r_min, r_max, threshold);
% Display
[max_value, max_index] = max(HS_pupil(:));
[y, x, r_index] = ind2sub(size(HS_pupil), max_index);
r = r_min + r_index - 1;
x = x+ shift(1);
y = y + shift(2);
% figure(3)
% imshow(img_dec);
title(['r=', num2str(r), ', x=', num2str(x), ', y=', num2str(y)]);
hold on;
viscircles([x, y], r, 'EdgeColor', 'r');
hold off;





% UNWRAPPING IRIS
irisCenter = [X, Y];
pupilCenter = [x, y];
unwrapped_iris_image = unwrapIris_uncentered(img_dec, irisCenter, R, pupilCenter, r);














% DISPLAY EDG_DETECTION IMAGE
show = 0;

if show
    figure(20)
    subplot(2,2,1)
    imshow(img_edges)
    subplot(2,2,2)
    mesh(img_edges)
end


% DISPLAY HOUGH SPACE
if show
    subplot(2,2,4)
    mesh(HS_iris(:,:,R_index))
    subplot(2,2,3)
    imagesc(HS_iris(:,:,R_index))
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