% Gabor encoding function
function encoded = gabor_encoding(unwrapped_iris, filtered_real, filtered_imag)
    [rows, cols] = size(unwrapped_iris);
    alpha = 1.0; % Example value
    beta = 1.0;  % Example value
    omega = 1.0; % Example value
    r0 = rows / 2;
    theta0 = cols / 2;

    encoded = zeros(rows, cols);

    for r = 1:rows
        for c = 1:cols
            rho = r;
            phi = c;
            I = unwrapped_iris(r, c);
            gabor_response = filtered_real(r, c) + 1i * filtered_imag(r, c);
            encoded(r, c) = I * exp(-(r0 - rho)^2 / alpha^2) * exp(-(theta0 - phi)^2 / beta^2) * exp(-1i * omega * (theta0 - phi)) * rho;
        end
    end
end