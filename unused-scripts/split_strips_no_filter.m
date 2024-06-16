function combinedImage = split_strips_no_filter(unwrappedIris)
    % Dimensions of the unwrapped iris image
    [height, width] = size(unwrappedIris);
    
    % Number of strips
    num_strips = 8;
    
    % Height of each strip
    strip_height = round(height / num_strips);
    
    % Initialize matrix to hold the strips
    strips = zeros(num_strips, width);
    
    figure; % Create a new figure for subplots
    for i = 1:num_strips
        % Define the starting and ending rows for the current strip
        start_row = (i - 1) * strip_height + 1;
        if i == num_strips
            end_row = height; % Make sure the last strip captures any remaining rows
        else
            end_row = i * strip_height;
        end
        
        % Extract the strip
        strip = unwrappedIris(start_row:end_row, :);
        
        % Compute the mean across the strip's rows to get a single row
        strips(i, :) = mean(strip, 1);
        
        % % Display the strip
        subplot(8, 1, i); % Create a subplot for each strip (2 rows, 4 columns)
        imshow(repmat(strips(i, :), [strip_height, 1]), []);
        % title(sprintf('Strip %d', i));
    end
    
    % Combine all strips into one image
    combinedImage = strips;
    
    % Resize the combined image to make it larger in the vertical direction
    scaling_factor = 35; % Adjust this value to make the image larger or smaller
    enlargedCombinedImage = imresize(combinedImage, [num_strips * scaling_factor, width], 'nearest');
    
    % Display the combined image
    % figure;
    % imshow(enlargedCombinedImage, []);
    % title('Combined Image (Enlarged)');
    % 
    % % Display the size of the combined image
    % disp('Size of the original combined image:');
    % disp(size(combinedImage));
    % disp('Size of the enlarged combined image:');
    % disp(size(enlargedCombinedImage));
end
