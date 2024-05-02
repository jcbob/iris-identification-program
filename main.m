close all;
clear all;

img = imread("images/artificial_eye.jpg");
figure()
imshow(img)
img_dec = decrease_resolution(img, 0.5);
figure()
imshow(img_dec)