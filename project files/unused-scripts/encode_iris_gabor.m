function [irisCode_real, irisCode_imag] = encode_iris_gabor(unwrappedIris, num)
    % Parameters for the Gabor filter
    wavelength = 8;
    orientations = 0:45:135; % Test multiple orientations
    aspectRatio = 0.5;
    bandwidth = 1;

    % Apply the Gabor filter to the unwrapped iris image for each orientation
    realParts = cell(length(orientations), 1);
    imaginaryParts = cell(length(orientations), 1);

    for i = 1:length(orientations)
        orientation = orientations(i);
        [gaborFilterReal, gaborFilterImag] = gabor_fn2(wavelength, orientation, aspectRatio, bandwidth);

        % Apply real part of Gabor filter
        gaborResponseReal = imfilter(unwrappedIris, gaborFilterReal, 'conv', 'same');

        % Apply imaginary part of Gabor filter
        gaborResponseImag = imfilter(unwrappedIris, gaborFilterImag, 'conv', 'same');

        % Store real and imaginary parts
        realParts{i} = gaborResponseReal;
        imaginaryParts{i} = gaborResponseImag;
    end

    % Use results for the first orientation (you can modify to use more orientations)
    realPart = realParts{1};
    imaginaryPart = imaginaryParts{1};

    % Encode the chosen part of the filtered image
    threshold_real = mean(realPart(:));
    irisCode_real = realPart > threshold_real;
    irisCode_real = uint8(irisCode_real) * 255;

    threshold_imag = mean(imaginaryPart(:));
    irisCode_imag = imaginaryPart > threshold_imag;
    irisCode_imag = uint8(irisCode_imag) * 255;

    % Display the combined iris code
    % figure;
    % subplot(2,1,1)
    % imshow(irisCode_real)
    % title(sprintf('%d - real', num))
    % subplot(2,1,2)
    % imshow(irisCode_imag)
    % title(sprintf('%d - imaginary', num))

    

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
