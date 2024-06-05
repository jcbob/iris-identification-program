% Gabor filter function
function gabor = gabor_fn(sigma, theta, lambda, gamma, psi, ksize)
    sigma_x = sigma;
    sigma_y = sigma / gamma;
    [x, y] = meshgrid(-floor(ksize/2):floor(ksize/2), -floor(ksize/2):floor(ksize/2));
    x_theta = x * cos(theta) + y * sin(theta);
    y_theta = -x * sin(theta) + y * cos(theta);
    gabor = exp(-0.5 * (x_theta.^2 / sigma_x^2 + y_theta.^2 / sigma_y^2)) .* cos(2 * pi * x_theta / lambda + psi);
end