close all;
clear all;

img = imread("images/iris1.jpg");
img_dec = decrease_resolution(img, 0.5);
% img = generate_Aeye(130, 130*0.3, 600, 400);

% figure(1)
% imshow(img)

[img_edges, shift] = detect_edges(img_dec, 4, true);

% figure(1)
% imshow(img_edges)
% figure(11)
% mesh(img_edges)

r_min = 129;
r_max = 150;

[rows, cols] = size(img_edges);

HS = zeros(rows,cols,r_max - r_min + 1);

for r = r_min:r_max
    for row = 1:rows
        for col = 1:cols
            if img_edges(row,col)>0.2
                for theta = 0.1*pi:0.1*pi:2*pi
                    a = round(col - r*cos(theta));
                    b = round(row - r*sin(theta));
                    if a>= 1 && a <= cols && b >= 1 && b <= rows
                        HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + img_edges(row,col);
                    end
                end
            end 
        end
    end
end

[max_value, max_index] = max(HS(:));
[y_max, x_max, r_max_index] = ind2sub(size(HS), max_index);
r_max_real = r_min + r_max_index - 1;
x_max = x_max + shift(1);
y_max = y_max + shift(2);
figure(41)
imshow(img_dec);
title(['r=', num2str(r_max_real), ', x=', num2str(x_max), ', y=', num2str(y_max)]);
hold on;
viscircles([x_max, y_max], r_max_real, 'EdgeColor', 'r');
hold off;


figure(31)
mesh(HS(:,:,r_max_index))
% imagesc(HS(:,:,r_max_index))












