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


% FIND IRIS CIRCLE
r_min = 140;
r_max = 170;
threshold = 0.2;
HS_iris = hough_transform(img_edges, r_min, r_max, threshold);
% HS_iris = hough_transform_worse(img_edges, r_min, r_max, threshold);
% Display
[max_value, max_index] = max(HS_iris(:));
[Y, X, R_index] = ind2sub(size(HS_iris), max_index);
R = r_min + R_index - 1;
X = X + shift(1);
Y= Y + shift(2);

figure()
imshow(img);
title(['r=', num2str(R), ', x=', num2str(X), ', y=', num2str(Y)]);
hold on;
viscircles([X*2, Y*2], R*2, 'EdgeColor', 'r');
% hold off;

% FIND PUPIL CIRCLE
r_min = 35;
r_max = 70;
threshold = 0.1;
% HS_pupil = hough_transform(img_edges, r_min, r_max, threshold);
HS_pupil = hough_transform_pupil(img_edges, r_min, r_max, threshold);
% Display
[max_value, max_index] = max(HS_pupil(:));
[y, x, r_index] = ind2sub(size(HS_pupil), max_index);
r = r_min + r_index - 1;
x = x+ shift(1);
y = y + shift(2);


title(['r=', num2str(r), ', x=', num2str(x), ', y=', num2str(y)]);
hold on;
viscircles([x*2, y*2], r*2, 'EdgeColor', 'r');
hold off;





% UNWRAP IRIS
irisCenter = [X, Y];
pupilCenter = [x, y];
unwrapped_iris_image = unwrap_iris(img_dec, irisCenter, R, pupilCenter, r, 0);


% SPLIT THE UNWRAPPED IRIS IMAGE INTO STRIPS
combined_strips_1 = split_strips_filter(unwrapped_iris_image);

DPI = 72;
% plot_frequency_spectrum(combined_strips_1, DPI)



% ENCODE THE UNWRAPPED IRIS IMAGE
[real_1, imag_1] = apply_gabor_filter(combined_strips_1);




% % COMPARE
% similarity = compareIrisCodes(irisCode1_real, irisCode1_imag, irisCode2_real, irisCode2_imag);




% DISPLAY EDG_DETECTION IMAGE
show = 0;

if show
    % figure(20)
    % % subplot(2,2,1)
    % imshow(img_edges)
    % title("Edges detected (image)")
    % figure(21)
    % % subplot(2,2,2)
    % mesh(img_edges)
    % title("Edges detected (mesh)")
    % colormap("gray")
end


% DISPLAY HOUGH SPACE
if show
    % figure(22)
    % % subplot(2,2,4)
    % imagesc(HS_iris(:,:,R_index))
    % title("Hough space (image)")
    % figure(24)
    % % subplot(2,2,3)
    % mesh(HS_iris(:,:,R_index))
    % title("Hough space (mesh)")

    % figure(25)
    % % subplot(2,2,4)
    % imagesc(HS_pupil(:,:,r_index))
    % title("Hough space (image)")
    % figure(26)
    % % subplot(2,2,3)
    % mesh(HS_pupil(:,:,r_index))
    % title("Hough space (mesh")

end