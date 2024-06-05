function show_I_P(img_dec_1, iris_center_1, pupil_center_1, iris_radius_1, pupil_radius_1, img_dec_2, iris_center_2, pupil_center_2, iris_radius_2, pupil_radius_2)
% Display image 1
figure;
subplot(1, 2, 1);
imshow(img_dec_1);
hold on;

% Plot both iris and pupil circles on image 1
centers_1 = [iris_center_1; pupil_center_1];
radii_1 = [iris_radius_1; pupil_radius_1];
viscircles(centers_1, radii_1);

title('Image 1 with Iris and Pupil Circles');
hold off;

% Display image 2
subplot(1, 2, 2);
imshow(img_dec_2);
hold on;

% Plot both iris and pupil circles on image 2
centers_2 = [iris_center_2; pupil_center_2];
radii_2 = [iris_radius_2; pupil_radius_2];
viscircles(centers_2, radii_2);

title('Image 2 with Iris and Pupil Circles');
hold off;
end