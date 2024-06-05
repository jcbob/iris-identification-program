% Function for LBP encoding
function lbp_image = lbp_encode(image)
    lbp_image = zeros(size(image));
    for i = 2:size(image, 1) - 1
        for j = 2:size(image, 2) - 1
            center = image(i, j);
            binary_string = '';
            binary_string = strcat(binary_string, num2str(image(i-1, j-1) >= center));
            binary_string = strcat(binary_string, num2str(image(i-1, j) >= center));
            binary_string = strcat(binary_string, num2str(image(i-1, j+1) >= center));
            binary_string = strcat(binary_string, num2str(image(i, j+1) >= center));
            binary_string = strcat(binary_string, num2str(image(i+1, j+1) >= center));
            binary_string = strcat(binary_string, num2str(image(i+1, j) >= center));
            binary_string = strcat(binary_string, num2str(image(i+1, j-1) >= center));
            binary_string = strcat(binary_string, num2str(image(i, j-1) >= center));
            lbp_image(i, j) = bin2dec(binary_string);
        end
    end
end