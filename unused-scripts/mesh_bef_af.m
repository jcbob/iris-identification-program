function mesh_bef_af(unwrappedIris, stripIndex)
    % Dimensions of the unwrapped iris image
    [height, width] = size(unwrappedIris);
    
    % Number of strips
    num_strips = 8;
    
    % Height of each strip
    strip_height = round(height / num_strips);
    
    % Define the starting and ending rows for the specified strip
    start_row = (stripIndex - 1) * strip_height + 1;
    if stripIndex == num_strips
        end_row = height; % Make sure the last strip captures any remaining rows
    else
        end_row = stripIndex * strip_height;
    end
    
    % Extract the strip
    strip = unwrappedIris(start_row:end_row, :);
    
    % Create mesh grid for x and y coordinates (before filtering)
    [X_before, Y_before] = meshgrid(1:size(strip, 2), start_row:end_row);

    % Display the mesh before filtering
    figure;
    subplot(3,1,1);
    mesh(X_before, Y_before, strip);
    xlabel('Column');
    ylabel('Row');
    zlabel('Intensity');
    title(['Strip ', num2str(stripIndex), ' Mesh (Before Filtering)']);
    
    % Create Gaussian filter
    gaussFilter = fspecial('gaussian', [strip_height, 1], strip_height / 2);
    
    % Extend the Gaussian filter to match strip dimensions
    gaussFilter_extended = repmat(gaussFilter, [1, size(strip, 2)]);

    % Create mesh grid for x and y coordinates of Gaussian filter
    [X_gauss, Y_gauss] = meshgrid(1:size(gaussFilter_extended, 2), 1:size(gaussFilter_extended, 1));

    % Display the Gaussian filter mesh
    subplot(3,1,2);
    mesh(X_gauss, Y_gauss, gaussFilter_extended);
    xlabel('Column');
    ylabel('Row');
    zlabel('Intensity');
    title('Gaussian Filter Mesh');
    
    % Apply Gaussian filter to the strip
    stripFiltered = imfilter(strip, gaussFilter, 'replicate');
    
    % Create mesh grid for x and y coordinates (after filtering)
    [X_after, Y_after] = meshgrid(1:size(stripFiltered, 2), start_row:end_row);

    % Display the mesh after filtering
    subplot(3,1,3);
    mesh(X_after, Y_after, stripFiltered);
    xlabel('Column');
    ylabel('Row');
    zlabel('Intensity');
    title(['Strip ', num2str(stripIndex), ' Mesh (After Filtering)']);
end
