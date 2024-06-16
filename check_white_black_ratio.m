function [white_ratio_real, white_ratio_imag] = check_white_black_ratio(irisCode_real, irisCode_imag)
    % Calculate the ratio of white pixels (value 1) to total pixels for both real and imaginary parts
    total_pixels = numel(irisCode_real); % Total number of pixels in the image

    white_pixels_real = nnz(irisCode_real); % Count the number of white pixels (value 1)
    black_pixels_real = total_pixels - white_pixels_real; % Count the number of black pixels (value 0)

    white_pixels_imag = nnz(irisCode_imag); % Count the number of white pixels (value 1)
    black_pixels_imag = total_pixels - white_pixels_imag; % Count the number of black pixels (value 0)

    % Calculate the ratio of white pixels to total pixels for both real and imaginary parts
    white_ratio_real = white_pixels_real / total_pixels;
    white_ratio_imag = white_pixels_imag / total_pixels;

    % Display the results
    fprintf('Ratio of white pixels (real): %.2f\n', white_ratio_real);
    fprintf('Ratio of black pixels (real): %.2f\n', 1 - white_ratio_real); % Black pixels ratio
    fprintf('Ratio of white pixels (imaginary): %.2f\n', white_ratio_imag);
    fprintf('Ratio of black pixels (imaginary): %.2f\n', 1 - white_ratio_imag); % Black pixels ratio
end
