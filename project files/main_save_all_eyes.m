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

% Directory containing the iris database
database_dir = 'my-iris-database';
people = dir(database_dir);
people = people([people.isdir] & ~startsWith({people.name}, '.'));

% Initialize variables to store combined strip images
combined_strip_images = {}; % Cell array to store combined strip images
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
        unwrapped_iris_image = unwrap_iris(img_dec, iris_center, iris_radius, pupil_center, pupil_radius, j);

        % Create combined image from unwrapped iris image
        combined_image = split_strips_filter(unwrapped_iris_image);

        % Store combined strip image and label
        combined_strip_images{end+1} = combined_image;
        labels{end+1} = people(i).name;
    end
end

% Save the combined strip images and labels as variables
save('combined_strip_images_add_1.mat', 'combined_strip_images', 'labels');

disp('Combined strip images have been created and saved.');
