close all;
clear all;

% READ IMAGE
img = imread("OFTA/o_sr11.bmp");
% img = imread("images/artificial_eye.jpg");
% img = generate_Aeye(130, 130*0.3, 600, 400);
if 0
    figure(11)
    imshow(img)
end

% DECREASE IMAGE RESOLUTION
resolution_ratio = 0.5;
img_dec = decrease_resolution(img, resolution_ratio);
if 0
    figure(12)
    imshow(img_dec)
end

% EDGE DETECTION
filter_len = 4;
rgb2gray = true;
[img_edges, shift] = detect_edges(img_dec, filter_len, rgb2gray, 4, 7);


[rows, cols] = size(img_edges); % Get the size of the edge-detected image

% CALCULATE TRANSFORM
r_min = 115;
r_max = 170;
A = zeros(rows, cols, r_max - r_min + 1);

V = img_edges;

for x = 1:cols
    for y = 1:rows
        for r = r_min:r_max
            for theta = 0:pi/45:2*pi-(pi/180)
                % Calculate the center coordinates
                xc = round(x + r * cos(theta));
                yc = round(y + r * sin(theta));

                % Check if the center coordinates are within the image bounds
                if xc >= 1 && xc <= cols && yc >= 1 && yc <= rows
                    A(y, x, r - r_min + 1) = A(y, x, r - r_min + 1) + V(yc, xc);
                end
            end
        end
    end
end

% Find maximum value
[max_value, max_index] = max(A(:));
[y0, x0, r0_index] = ind2sub(size(A), max_index);
r0 = r_min + r0_index - 1;

% Adjust the center coordinates for the shift
x0 = x0 + shift(1) - 1;
y0 = y0 + shift(2) - 1;

% Display result
figure;
imshow(img_dec);
title(['r=', num2str(r0), ', x=', num2str(x0), ', y=', num2str(y0)]);
hold on;
viscircles([x0, y0], r0, 'EdgeColor', 'r');
hold off;

% figure()
% imshow(img_edges)