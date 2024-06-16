function [HD_real, HD_imag] = hamming_distance_n(iris_code1_real, iris_code1_imag, iris_code2_real, iris_code2_imag)
    % Function to calculate the Hamming distance between two iris codes
    % for both real and imaginary parts, with circular shifting.

    % Input:
    % iris_code1_real - binary matrix for the real part of the first iris code
    % iris_code1_imag - binary matrix for the imaginary part of the first iris code
    % iris_code2_real - binary matrix for the real part of the second iris code
    % iris_code2_imag - binary matrix for the imaginary part of the second iris code

    % Output:
    % HD_real - Minimum Hamming distance for the real part
    % HD_imag - Minimum Hamming distance for the imaginary part

    % Calculate the Hamming distance for the real part
    function HD = calc_hd(code1, code2)
        XOR_code = xor(code1, code2);
        HD = sum(XOR_code(:)) / numel(code1);
    end

    shifts = -4:4; % Shift values from -4 to 4
    num_shifts = length(shifts);
    HD_real_vals = zeros(1, num_shifts);
    HD_imag_vals = zeros(1, num_shifts);

    for i = 1:num_shifts
        shift_val = shifts(i);
        if shift_val < 0
            shift_val = abs(shift_val);
            shifted_real = circshift(iris_code2_real, [0, -shift_val]);
            shifted_imag = circshift(iris_code2_imag, [0, -shift_val]);
        else
            shifted_real = circshift(iris_code2_real, [0, shift_val]);
            shifted_imag = circshift(iris_code2_imag, [0, shift_val]);
        end

        HD_real_vals(i) = calc_hd(iris_code1_real, shifted_real);
        HD_imag_vals(i) = calc_hd(iris_code1_imag, shifted_imag);
    end

    % Return the minimum Hamming distance found
    HD_real = min(HD_real_vals);
    HD_imag = min(HD_imag_vals);
end
