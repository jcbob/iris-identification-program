function [HD_real, HD_imag] = hamming_distance(iris_code1_real, iris_code1_imag, iris_code2_real, iris_code2_imag)
    % Function to calculate the Hamming distance between two iris codes
    % for both real and imaginary parts.

    % Input:
    % iris_code1_real - binary matrix for the real part of the first iris code
    % iris_code1_imag - binary matrix for the imaginary part of the first iris code
    % iris_code2_real - binary matrix for the real part of the second iris code
    % iris_code2_imag - binary matrix for the imaginary part of the second iris code

    % Output:
    % HD_real - Hamming distance for the real part
    % HD_imag - Hamming distance for the imaginary part

    % Calculate the Hamming distance for the real part
    XOR_real = xor(iris_code1_real, iris_code2_real);
    HD_real = sum(XOR_real(:)) / numel(iris_code1_real);

    % Calculate the Hamming distance for the imaginary part
    XOR_imag = xor(iris_code1_imag, iris_code2_imag);
    HD_imag = sum(XOR_imag(:)) / numel(iris_code1_imag);
end