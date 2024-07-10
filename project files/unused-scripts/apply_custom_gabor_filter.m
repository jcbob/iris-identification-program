function gaborFilteredImage = apply_custom_gabor_filter(combinedImage)
    % Define parameters for the Gabor filter
    lambda = 10; % Wavelength of the sinusoidal component
    theta = 0; % Orientation of the Gabor filter in degrees
    sigma = 2; % Standard deviation of the Gaussian envelope
    gamma = 0.5; % Spatial aspect ratio
    psi = 0; % Phase offset
    
    % Number of strips
    [num_strips, width] = size(combinedImage);

    % Initialize matrix to hold the Gabor filtered strips
    gaborFilteredStrips = zeros(num_strips, width);
    
    % Create the Gabor filter
    for i = 1:num_strips
        strip = combinedImage(i, :);
        gaborFilter = custom_gabor_filter(lambda, theta, sigma, gamma, psi, size(strip, 2));
        filteredStrip = apply_gabor_filter_to_strip(strip, gaborFilter);
        gaborFilteredStrips(i, :) = filteredStrip;
    end
    
    % Display the Gabor filtered strips
    figure;
    for i = 1:num_strips
        subplot(num_strips, 1, i); % Create a subplot for each strip
        imshow(repmat(gaborFilteredStrips(i, :), [1, 1]), []); % Display the strip
        title(['Custom Gabor Filtered Strip ' num2str(i)]);
    end
    
    % Combine all Gabor filtered strips into one image
    gaborFilteredImage = gaborFilteredStrips;
end

function gaborFilter = custom_gabor_filter(lambda, theta, sigma, gamma, psi, width)
    % Generate sinusoidal component of the Gabor filter
    [x, y] = meshgrid(-floor(width/2):floor((width-1)/2));
    x_theta = x * cos(theta) + y * sin(theta);
    y_theta = -x * sin(theta) + y * cos(theta);
    sinusoidal = exp(-(x_theta.^2 + (gamma*y_theta).^2) / (2*sigma^2)) .* cos(2*pi/lambda * x_theta + psi);
    
    % Normalize the filter
    gaborFilter = sinusoidal - mean(sinusoidal(:));
end

function filteredStrip = apply_gabor_filter_to_strip(strip, gaborFilter)
    % Apply the Gabor filter to the strip
    filteredStrip = conv(strip, gaborFilter, 'same');
end
