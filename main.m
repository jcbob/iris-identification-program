close all;
clear all;

% CONSTANTS
resolution_ratio = 0.5;

filter_len = 4;
rgb2gray = true;
sigma = 4;
filter_ratio = 7;

R_min = 120;
R_max = 170;
iris_threshold = 0.1;

r_min = 35;
r_max = 70;
pupil_threshold = 0.1;

% Iris Detection & Recognition
img_1 = imread("OFTA/o_sr113.bmp");
img_dec_1 = decrease_resolution(img_1, resolution_ratio);
[img_edges_1, shift_1] = detect_edges(img_dec_1, filter_len, rgb2gray, sigma, filter_ratio);

img_2 = imread("OFTA/o_sr11.bmp");
img_dec_2 = decrease_resolution(img_2, resolution_ratio);
[img_edges_2, shift_2] = detect_edges(img_dec_2, filter_len, rgb2gray, sigma, filter_ratio);

% FIND IRIS CIRCLE
[iris_center_1, iris_radius_1] = find_iris(img_edges_1, shift_1, R_min, R_max, iris_threshold);
[iris_center_2, iris_radius_2] = find_iris(img_edges_2, shift_2, R_min, R_max, iris_threshold);

% FIND PUPIL CIRCLE
[pupil_center_1, pupil_radius_1] = find_pupil(img_edges_1, shift_1, r_min, r_max, pupil_threshold);
[pupil_center_2, pupil_radius_2] = find_pupil(img_edges_2, shift_2, r_min, r_max, pupil_threshold);

show_I_P(img_dec_1, iris_center_1, pupil_center_1, iris_radius_1, pupil_radius_1, img_dec_2, iris_center_2, pupil_center_2, iris_radius_2, pupil_radius_2);


% UNWRAP IRIS
unwrapped_iris_image_1 = new_unwrap_iris_3(img_dec_1, iris_center_1, iris_radius_1, pupil_center_1, pupil_radius_1, 1);
unwrapped_iris_image_2 = new_unwrap_iris_3(img_dec_2, iris_center_2, iris_radius_2, pupil_center_2, pupil_radius_2, 2);


% ENCODE IRIS
[iris_code_real_1, iris_code_imag_1] = encode_iris_gabor(unwrapped_iris_image_1, 1);
[iris_code_real_2, iris_code_imag_2] = encode_iris_gabor(unwrapped_iris_image_2, 2);


% COMPARE
[hd_real, hd_imag] = hamming_distance(iris_code_real_1, iris_code_imag_1, iris_code_real_2, iris_code_imag_2);

fprintf('Hamming Distance (Real): %.2f\n', hd_real);
fprintf('Hamming Distance (Imaginary): %.2f\n', hd_imag);