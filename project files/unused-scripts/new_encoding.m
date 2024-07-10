function [irisCode_real, irisCode_imag] = new_encoding(unwrappedIris, num)
    % Parameters for the Gabor filter
    wavelength = 8;
    orientation = 0;
    aspectRatio = 0.5;
    bandwidth = 1;

    % Step 1: Remove the DC component (constant component) from the image
    unwrappedIris = unwrappedIris - mean(unwrappedIris, 'all');

    % Step 2: Divide the unwrapped iris image into 8 weighted strips using Gaussian filters
    num_strips = 8;
    strip_width = size(unwrappedIris, 2) / num_strips;
    weighted_strips = zeros(size(unwrappedIris));
    
    % Create Gaussian filter
    gaussian_filter = fspecial('gaussian', [1, strip_width], strip_width / 2);

    for i = 1:num_strips
        start_col = round((i - 1) * strip_width) + 1;
        end_col = round(i * strip_width);
        % Apply Gaussian filter to the strip
        weighted_strips(:, start_col:end_col) = imfilter(unwrappedIris(:, start_col:end_col), gaussian_filter', 'replicate');
    end

    % Step 3: Apply the Gabor filter to each strip individually
    [gaborFilterReal, gaborFilterImag] = gabor_fn2(wavelength, orientation, aspectRatio, bandwidth);

    % Apply real part of Gabor filter
    gaborResponseReal = imfilter(weighted_strips, gaborFilterReal, 'conv', 'same');

    % Apply imaginary part of Gabor filter
    gaborResponseImag = imfilter(weighted_strips, gaborFilterImag, 'conv', 'same');

    % Binarize the Gabor filter responses
    irisCode_real = gaborResponseReal > 0;
    irisCode_imag = gaborResponseImag > 0;

    % Display the combined iris code
    figure;
    subplot(2,1,1)
    imshow(irisCode_real)
    title(sprintf('%d - real', num))
    subplot(2,1,2)
    imshow(irisCode_imag)
    title(sprintf('%d - imaginary', num))
end


% Helper function to generate Gabor filter parts
function [gaborReal, gaborImag] = gabor_fn2(wavelength, orientation, aspectRatio, bandwidth)
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
end