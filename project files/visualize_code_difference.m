function visualize_code_difference(iris_code_real1, iris_code_imag1, iris_code_real2, iris_code_imag2)
    % Ensure both IrisCodes (real and imaginary parts) are the same size
    assert(all(size(iris_code_real1) == size(iris_code_real2)), 'Real parts of IrisCodes must be the same size.');
    assert(all(size(iris_code_imag1) == size(iris_code_imag2)), 'Imaginary parts of IrisCodes must be the same size.');

    % Create difference images for real and imaginary parts
    difference_image_real = create_difference_image(iris_code_real1, iris_code_real2);
    difference_image_imag = create_difference_image(iris_code_imag1, iris_code_imag2);

    % Stretch the difference images vertically
    stretched_difference_real = imresize(difference_image_real, [size(difference_image_real, 1)*10, size(difference_image_real, 2)], 'nearest');
    stretched_difference_imag = imresize(difference_image_imag, [size(difference_image_imag, 1)*10, size(difference_image_imag, 2)], 'nearest');

    % Display both stretched difference images in a single subplot
    figure;

    % Plot real part difference image
    subplot(2, 1, 1);
    imshow(stretched_difference_real, 'InitialMagnification', 'fit');
    title('Visual Differences (Real Part)');
    axis on;

    % Plot imaginary part difference image
    subplot(2, 1, 2);
    imshow(stretched_difference_imag, 'InitialMagnification', 'fit');
    title('Visual Differences (Imaginary Part)');
    axis on;
end

function difference_image = create_difference_image(iris_code1, iris_code2)
    % Create an empty image to store the visualization
    [rows, cols] = size(iris_code1);
    difference_image = zeros(rows, cols, 3);  % RGB image

    % Iterate over each pixel
    for r = 1:rows
        for c = 1:cols
            if iris_code1(r, c) == iris_code2(r, c)
                if iris_code1(r, c) == 1
                    difference_image(r, c, :) = [1, 1, 1];  % White for matching 1s
                else
                    difference_image(r, c, :) = [0, 0, 0];  % Black for matching 0s
                end
            else
                difference_image(r, c, :) = [1, 0, 0];  % Red for mismatched pixels
            end
        end
    end
end
