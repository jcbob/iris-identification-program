function applyGaussianFilterToStripAndVisualize(gray_img)
    % Number of strips
    num_strips = 8;
    
    % Height of each strip
    [image_height, image_width] = size(gray_img);
    strip_height = floor(image_height / num_strips);
    
    % Create Gaussian filter
    gaussFilter = fspecial('gaussian', [strip_height, 1], strip_height / 2);
    
    % Initialize matrix to hold the strips
    filtered_strips = zeros(num_strips, image_width);
    
    % Apply Gaussian filter to each strip
    for i = 1:num_strips
        % Define the starting and ending rows for the current strip
        start_row = (i - 1) * strip_height + 1;
        end_row = min(i * strip_height, image_height);
        
        % Extract the current strip
        strip = double(gray_img(start_row:end_row, :));
        
        % Apply Gaussian filter to the strip
        filtered_strip = imfilter(strip, gaussFilter, 'replicate');
        
        % Store the filtered strip
        filtered_strips(i, :) = mean(filtered_strip, 1); % Uśrednienie wartości pikseli wzdłuż kolumn
    end
    
    % Create mesh grid for visualization
    [X, Y] = meshgrid(1:image_width, 1:num_strips); % Użyj num_strips zamiast length(strip_to_visualize)
    
    % Display the effect of Gaussian filter on the strips using mesh
    figure;
    mesh(X, Y, filtered_strips); % Użyj filtered_strips zamiast strip_to_visualize
    xlabel('Column');
    ylabel('Strip');
    zlabel('Intensity');
    title('Effect of Gaussian Filter on Strips');
end