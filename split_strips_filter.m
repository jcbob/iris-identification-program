function combinedImage = split_strips_filter(unwrappedIris, selectedStripIndex)
    % Set default value for selectedStripIndex if not provided
    if nargin < 2
        selectedStripIndex = 1;
    end

    % Dimensions of the unwrapped iris image
    [height, width] = size(unwrappedIris);

    % Number of strips
    num_strips = 8;

    % Height of each strip
    strip_height = round(height / num_strips);

    % Create Gaussian filter
    gaussFilter = fspecial('gaussian', [strip_height, 1], strip_height / 2);

    % Initialize matrix to hold the strips
    strips = zeros(num_strips, width);
    weightedStrips = cell(num_strips, 1);

    % Create a new figure for subplots
    % figure;
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

        % Compute the weighted mean across the strip's rows to get a single row
        gaussFilterResized = imresize(gaussFilter, [size(strip, 1), 1], 'nearest');
        weightedStrip = sum(strip .* gaussFilterResized, 1) / sum(gaussFilterResized);
        strips(i, :) = weightedStrip;
        weightedStrips{i} = weightedStrip;

        % Display the strip
        % subplot(num_strips, 1, i); % Create a subplot for each strip (8 rows, 1 column)
        % imshow(repmat(weightedStrip, [strip_height, 1]), []);       
    end

    % Display mesh of selected strip before and after filtering
    % figure;

    % Define the starting and ending rows for the selected strip
    start_row = (selectedStripIndex - 1) * strip_height + 1;
    if selectedStripIndex == num_strips
        end_row = height; % Make sure the last strip captures any remaining rows
    else
        end_row = selectedStripIndex * strip_height;
    end

    % Extract the selected strip
    selected_strip = unwrappedIris(start_row:end_row, :);

    % % Create mesh grid for x and y coordinates (before filtering)
    % [X_before, Y_before] = meshgrid(1:width, 1:strip_height);
    % 
    % % Display mesh before filtering
    % subplot(2, 1, 1)
    % mesh(X_before, Y_before, selected_strip);
    % xlabel('Column');
    % ylabel('Row');
    % zlabel('Intensity');
    % title('Strip before filtering');
    % 
    % % Apply Gaussian filter to the selected strip
    % stripFiltered_selected = imfilter(selected_strip, gaussFilter, 'replicate');
    % 
    % % Create mesh grid for x and y coordinates (after filtering)
    % [X_after, Y_after] = meshgrid(1:width, 1:strip_height);
    % 
    % % Display mesh after filtering
    % subplot(2, 1, 2)
    % mesh(X_after, Y_after, stripFiltered_selected);
    % xlabel('Column');
    % ylabel('Row');
    % zlabel('Intensity');
    % title('Strip after filtering');

    % Combine all strips into one image
    combinedImage = strips;

    % % Verify if all individual weighted strips are equal to combined image strips
    % are_equal = true;
    % for i = 1:num_strips
    %     if any(weightedStrips{i} ~= combinedImage(i, :))
    %         are_equal = false;
    %         fprintf('Mismatch found in strip %d\n', i);
    %     end
    % end
    % if are_equal
    %     disp('All strips in the combined image are equal to the individual weighted strips.');
    % else
    %     disp('There are mismatches between some strips in the combined image and the individual weighted strips.');
    % end
end
