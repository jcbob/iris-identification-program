function [binary_real_iris_code, binary_imag_iris_code] = apply_custom_gabor_filter(combinedImage)
    % Parameters for the Gabor filter
    wavelength = 8; % Frequency of the sinusoidal wave
    orientation = 0; % Orientation in degrees
    aspectRatio = 0.5; % Aspect ratio of the Gaussian window
    bandwidth = 1; % Bandwidth
    sigma = 2; % Standard deviation for Gaussian window

    % Get the number of strips
    num_strips = size(combinedImage, 1);

    % Preallocate arrays to store Gabor filter responses
    gaborRealResponses = cell(num_strips, 1);
    gaborImagResponses = cell(num_strips, 1);

    % Loop through each strip
    for i = 1:num_strips
        % Extract the strip from the combined image
        strip = combinedImage(i, :);

        % Step 1: Remove the DC component (constant component) from the strip
        stripMean = mean(strip, 'all');
        strip = strip - stripMean;

        % Step 2: Define the Gabor filter components
        t = linspace(-length(strip)/2, length(strip)/2, length(strip));
        w = exp(-0.5 * (t / sigma).^2); % Gaussian window
        s = exp(1j * (2 * pi * t / wavelength + orientation * pi / 180)); % Complex sinusoidal wave

        % Combine the components to form the Gabor filter
        gaborFilter = w .* s;

        % Apply the Gabor filter to the strip
        gaborFiltered = conv(strip, gaborFilter, 'same');

        % Separate real and imaginary parts
        gaborRealFiltered = real(gaborFiltered);
        gaborImagFiltered = imag(gaborFiltered);

        % Store the filtered strip in the array
        gaborRealResponses{i} = gaborRealFiltered;
        gaborImagResponses{i} = gaborImagFiltered;
    end

    % Combine all the real and imaginary filtered strips into one iris code
    real_iris_code = cell2mat(gaborRealResponses);
    imag_iris_code = cell2mat(gaborImagResponses);

    % Get the size of the iris code
    [height, width] = size(real_iris_code);

    % Stretch the iris code vertically for better visualization
    stretched_real_iris_code = imresize(real_iris_code, [height*10, width]);
    stretched_imag_iris_code = imresize(imag_iris_code, [height*10, width]);

    % Binarize the iris codes
    binary_real_iris_code = real_iris_code > 0;
    binary_imag_iris_code = imag_iris_code > 0;

    % Stretch the binarized iris codes vertically for better visualization
    stretched_binary_real_iris_code = imresize(binary_real_iris_code, [height*10, width]);
    stretched_binary_imag_iris_code = imresize(binary_imag_iris_code, [height*10, width]);

    % Display the iris codes and their sizes
    figure;
    subplot(2,2,1)
    imshow(stretched_real_iris_code, []);
    title(sprintf('Real Part of Combined Iris Code\nSize: %d x %d', height*10, width));

    subplot(2,2,2)
    imshow(stretched_imag_iris_code, []);
    title(sprintf('Imaginary Part of Combined Iris Code\nSize: %d x %d', height*10, width));

    subplot(2,2,3)
    imshow(stretched_binary_real_iris_code);
    title('Binarized Real Part of Iris Code');

    subplot(2,2,4)
    imshow(stretched_binary_imag_iris_code);
    title('Binarized Imaginary Part of Iris Code');
end
