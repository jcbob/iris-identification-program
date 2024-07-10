function visualizeGaussianFilterEffect(image)
    % Convert image to grayscale if it's not already
    if size(image, 3) == 3
        image = rgb2gray(image);
    end

    % Create a synthetic unwrapped iris image using the same values as the input image
    unwrappedIris = repmat(image, [8, 1]);

    % Dimensions of the unwrapped iris image
    [height, width] = size(unwrappedIris);
    
    % Number of strips
    num_strips = 8;
    
    % Height of each strip
    strip_height = round(height / num_strips);
    
    % Create Gaussian filter
    gaussFilter = fspecial('gaussian', [strip_height, 1], strip_height / 2);
    
    % Select one strip to visualize
    strip_index = 1; % Change this index to visualize different strips
    
    % Define the starting and ending rows for the selected strip
    start_row = (strip_index - 1) * strip_height + 1;
    if strip_index == num_strips
        end_row = height; % Make sure the last strip captures any remaining rows
    else
        end_row = strip_index * strip_height;
    end
    
    % Extract the selected strip
    strip = unwrappedIris(start_row:end_row, :);
    
    % Apply Gaussian filter to the strip
    gaussFilteredStrip = imfilter(strip, gaussFilter, 'replicate');
    
    % Create mesh grid for visualization
    [X, Y] = meshgrid(1:width, 1:strip_height);
    
    % Display the effect of Gaussian filter on the selected strip using mesh
    figure;
    mesh(X, Y, gaussFilteredStrip);
    xlabel('Column');
    ylabel('Row');
    zlabel('Intensity');
    title('Effect of Gaussian Filter on Strip');
end
