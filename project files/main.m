close all;
clear all;

% CONSTANTS
resolution_ratio = 0.5;

filter_len = 4;
rgb2gray = true;
sigma = 4;
filter_ratio = 7;

R_min = 140;
R_max = 170;
iris_threshold = 0.1;

r_min = 35;
r_max = 70;
pupil_threshold = 0.1;


% Iris Detection & Recognition

% READ AND PREPROCESS IMAGES
img_1 = imread("my-iris-database/person1/o_sr11.bmp");
img_dec_1 = decrease_resolution(img_1, resolution_ratio);
[img_edges_1, shift_1] = detect_edges(img_dec_1, filter_len, rgb2gray, sigma, filter_ratio);

img_2 = imread("my-iris-database/person1/o_sr13.bmp");
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
unwrapped_iris_image_1 = unwrap_iris(img_dec_1, iris_center_1, iris_radius_1, pupil_center_1, pupil_radius_1, 1);
unwrapped_iris_image_2 = unwrap_iris(img_dec_2, iris_center_2, iris_radius_2, pupil_center_2, pupil_radius_2, 2);


% SPLIT UNWRAPPED IRIS IMAGE INTO 8 STRIPS
combined_image_1 = split_strips_filter(unwrapped_iris_image_1);
combined_image_2 = split_strips_filter(unwrapped_iris_image_2);


% ENCODE THE UNWRAPPED IRIS IMAGE USING GABOR FILTER
[real_1, imag_1] = apply_gabor_filter(combined_image_1);
[real_2, imag_2] = apply_gabor_filter(combined_image_2);

% COMPARE
[hd_real, hd_imag] = hamming_distance_n(real_1, imag_1, real_2, imag_2);

fprintf('Hamming Distance (Real): %.2f\n', hd_real);
fprintf('Hamming Distance (Imaginary): %.2f\n', hd_imag);

check_white_black_ratio(real_1, imag_1)
check_white_black_ratio(real_2, imag_2)


visualize_code_difference(real_1, imag_1, real_2, imag_2)