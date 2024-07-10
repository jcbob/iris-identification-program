clear all;
close all;

load('combined_image.mat');

figure;
imagesc(combined_image)
colormap("gray")

dpi=200;
% plot_frequency_spectrum(combined_image, dpi)
[real, imag] = apply_gabor_filter(combined_image);
