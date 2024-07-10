function [binary_real_iris_code, binary_imag_iris_code] = apply_gabor_filter(combinedImage)
    % Parameters for the Gabor filter
    wavelength = 33; %25, 33, 142
    orientation = 0;
    aspectRatio = 0.5;
    bandwidth = 1;
    
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

        % Step 2: Apply the Gabor filter to the strip
        theta = orientation * pi / 180;
        sigma = wavelength * sqrt(log(2) / 2) * ((2^bandwidth + 1) / (2^bandwidth - 1)) / pi;
        sigma_x = sigma;
        sigma_y = sigma / aspectRatio;
        nstds = 3;
        xmax = max(abs(nstds * sigma_x * cos(theta)), abs(nstds * sigma_y * sin(theta)));
        xmax = ceil(max(1, xmax));
        ymax = max(abs(nstds * sigma_x * sin(theta)), abs(nstds * sigma_y * cos(theta)));
        ymax = ceil(max(1, ymax));
        [x, y] = meshgrid(-xmax:xmax, -ymax:ymax);
        x_theta = x * cos(theta) + y * sin(theta);
        y_theta = -x * sin(theta) + y * cos(theta);
        gaborReal = exp(-0.5 * (x_theta.^2 / sigma_x^2 + y_theta.^2 / sigma_y^2)) .* cos(2 * pi / wavelength * x_theta);
        gaborImag = exp(-0.5 * (x_theta.^2 / sigma_x^2 + y_theta.^2 / sigma_y^2)) .* sin(2 * pi / wavelength * x_theta);

        % Apply the Gabor filter to the strip
        gaborRealFiltered = conv2(strip, gaborReal, 'same');
        gaborImagFiltered = conv2(strip, gaborImag, 'same');
        
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
    % figure;
    % subplot(2,1,1)
    % imshow(stretched_real_iris_code, []);
    % title(sprintf('Real Part of Gabor Filtered Iris Code\nEnlarged Size: %d x %d', height*10, width));
    % 
    % % figure;
    % subplot(2,1,2)
    % imshow(stretched_imag_iris_code, []);
    % title(sprintf('Imaginary Part of Gabor Filtered Iris Code\nEnlarged Size: %d x %d', height*10, width));
    % 
    % figure;
    % subplot(2,1,1)
    % imshow(stretched_binary_real_iris_code);
    % title('Binarized Real Part of Iris Code');
    % 
    % % figure;
    % subplot(2,1,2)
    % imshow(stretched_binary_imag_iris_code);
    % title('Binarized Imaginary Part of Iris Code');
end
