function [pupil_center, pupil_radius] = find_pupil(img_edges, shift, r_min, r_max, pupil_threshold)

HS_pupil = hough_transform_pupil(img_edges, r_min, r_max, pupil_threshold);

[max_value, max_index] = max(HS_pupil(:));
[y, x, r_index] = ind2sub(size(HS_pupil), max_index);
r = r_min + r_index - 1;
x = x + shift(1);
y = y + shift(2);

pupil_center = [x,y];
pupil_radius = r;

end