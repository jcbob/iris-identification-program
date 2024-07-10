function [iris_center, iris_radius] = find_iris(img_edges, shift, R_min, R_max, iris_threshold)

HS_iris = hough_transform(img_edges, R_min, R_max, iris_threshold);

[max_value, max_index] = max(HS_iris(:));
[Y, X, R_index] = ind2sub(size(HS_iris), max_index);
R = R_min + R_index - 1;
X = X + shift(1);
Y= Y + shift(2);

iris_center = [X,Y];
iris_radius = R;

end