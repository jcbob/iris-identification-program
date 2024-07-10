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

        % Display the iris and pupil detection result
        figure;
        imshow(img_dec);
        hold on;
        viscircles(iris_center, iris_radius, 'EdgeColor', 'b');
        viscircles(pupil_center, pupil_radius, 'EdgeColor', 'r');
        title(sprintf('%s - %s', people(i).name, images(j).name));

        % Save the figure
        saveas(gcf, sprintf('Detected_Iris_Pupil_%s_%s.png', people(i).name, images(j).name));
        close(gcf);
    end
end