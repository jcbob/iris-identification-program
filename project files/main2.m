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

% Directory containing the iris database
database_dir = 'my-iris-database';
people = dir(database_dir);
people = people([people.isdir] & ~startsWith({people.name}, '.'));

% Initialize variables to store IrisCodes
irisCodes_real = {};
irisCodes_imag = {};
labels = {};

% Process each person's images
for i = 1:length(people)
    person_dir = fullfile(database_dir, people(i).name);
    images = dir(fullfile(person_dir, '*.bmp'));
    
    for j = 1:length(images)
        img_path = fullfile(person_dir, images(j).name);
        img = imread(img_path);
        img_dec = decrease_resolution(img, resolution_ratio);
        [img_edges, shift] = detect_edges(img_dec, filter_len, rgb2gray, sigma, filter_ratio);

        % Find Iris and Pupil
        [iris_center, iris_radius] = find_iris(img_edges, shift, R_min, R_max, iris_threshold);
        [pupil_center, pupil_radius] = find_pupil(img_edges, shift, r_min, r_max, pupil_threshold);

        % Unwrap Iris
        unwrapped_iris_image = new_unwrap_iris_3(img_dec, iris_center, iris_radius, pupil_center, pupil_radius, j);

        % Encode Iris
        [iris_code_real, iris_code_imag] = new_encoding(unwrapped_iris_image, j);

        % Store IrisCodes
        irisCodes_real{end+1} = iris_code_real;
        irisCodes_imag{end+1} = iris_code_imag;
        labels{end+1} = people(i).name;
    end
end

% Calculate Hamming distances and create confusion matrix
num_images = length(irisCodes_real);
confusion_matrix_real = zeros(num_images, num_images);
confusion_matrix_imag = zeros(num_images, num_images);

for i = 1:num_images
    for j = 1:num_images
        [hd_real, hd_imag] = hamming_distance(irisCodes_real{i}, irisCodes_imag{i}, irisCodes_real{j}, irisCodes_imag{j});
        confusion_matrix_real(i, j) = hd_real;
        confusion_matrix_imag(i, j) = hd_imag;
    end
end

% Display confusion matrices
figure;
imagesc(confusion_matrix_real);
colormap(gray);
colorbar;
title('Confusion Matrix (Real Part)');
xlabel('Image Index');
ylabel('Image Index');

% Add text labels
for i = 1:num_images
    for j = 1:num_images
        text(j, i, sprintf('%.2f', confusion_matrix_real(i, j)), 'HorizontalAlignment', 'Center', 'Color', 'red');
    end
end

figure;
imagesc(confusion_matrix_imag);
colormap(gray);
colorbar;
title('Confusion Matrix (Imaginary Part)');
xlabel('Image Index');
ylabel('Image Index');

% Add text labels
for i = 1:num_images
    for j = 1:num_images
        text(j, i, sprintf('%.2f', confusion_matrix_imag(i, j)), 'HorizontalAlignment', 'Center', 'Color', 'red');
    end
end

% Save confusion matrices
save('confusion_matrix_real.mat', 'confusion_matrix_real');
save('confusion_matrix_imag.mat', 'confusion_matrix_imag');