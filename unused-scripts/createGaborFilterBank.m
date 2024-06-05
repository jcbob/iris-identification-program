function gaborFilterBank = createGaborFilterBank(u, v, m, n)
    % u: Number of scales
    % v: Number of orientations
    % m, n: Size of the Gabor filter

    gaborFilterBank = cell(u, v);
    fmax = 0.25; % Maximum frequency
    gama = sqrt(2); % Spatial aspect ratio
    eta = sqrt(2); % Spatial aspect ratio

    for i = 1:u
        fu = fmax / (sqrt(2)^(i-1));
        alpha = fu / gama;
        beta = fu / eta;
        for j = 1:v
            tetav = (j-1)/v*pi;
            gaborFilterBank{i, j} = zeros(m, n);
            for x = -m/2+1:m/2
                for y = -n/2+1:n/2
                    xPrime = x * cos(tetav) + y * sin(tetav);
                    yPrime = -x * sin(tetav) + y * cos(tetav);
                    gaborFilterBank{i, j}(x + m/2, y + n/2) = ...
                        fu^2/(pi*gama*eta) * exp(- (alpha^2*xPrime^2 + beta^2*yPrime^2)) * ...
                        exp(1i * 2 * pi * fu * xPrime);
                end
            end
        end
    end
end
