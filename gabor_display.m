close all;
clear all;

% Parametry filtru Gabora
lambda = 8; % długość fali
theta = 0; % orientacja filtru (0°)
sigma = 10;
psi = 0; % faza przesunięcia
gamma = 1; % współczynnik aspektu

% Rozmiar filtru
filterSize = 51; % musi być nieparzyste
halfSize = (filterSize - 1) / 2;

% Tworzenie siatek x i y
[x, y] = meshgrid(-halfSize:halfSize, -halfSize:halfSize);

% Różne wartości sigma
gamma_values = [1, 0.65, 0.35, 0.1];

for i = 1:length(gamma_values)
    % Odchylenie standardowe gaussowskiego "okna"
    gamma = gamma_values(i);
    
    % Obliczanie współrzędnych po rotacji
    xPrime = x * cos(theta) + y * sin(theta);
    yPrime = -x * sin(theta) + y * cos(theta);

    % Obliczanie filtru Gabora
    expFactor = exp(-0.5 * (xPrime.^2 + gamma^2 * yPrime.^2) / sigma^2);
    realPart = expFactor .* cos(2 * pi * xPrime / lambda + psi);
    imaginaryPart = expFactor .* sin(2 * pi * xPrime / lambda + psi);

    % Wyświetlanie odpowiedzi impulsowej
    figure;
    subplot(1, 2, 1);
    imagesc(realPart);
    title(['Real part (\sigma = ' num2str(sigma) ')']);
    colorbar;
    axis image;

    subplot(1, 2, 2);
    imagesc(imaginaryPart);
    title(['Imaginary part (\sigma = ' num2str(sigma) ')']);
    colorbar;
    axis image;
end








% % Parametry filtru Gabora
% lambda = 8; % długość fali
% theta = 0; % orientacja filtru
% psi = 0; % faza przesunięcia
% sigma = 10; % odchylenie standardowe gaussowskiego "okna"
% gamma = 1; % współczynnik aspektu
% 
% % Rozmiar filtru
% filterSize = 51; % musi być nieparzyste
% halfSize = (filterSize - 1) / 2;
% 
% % Tworzenie siatek x i y
% [x, y] = meshgrid(-halfSize:halfSize, -halfSize:halfSize);
% 
% % Obliczanie współrzędnych po rotacji
% xPrime = x * cos(theta) + y * sin(theta);
% yPrime = -x * sin(theta) + y * cos(theta);
% 
% % Obliczanie filtru Gabora
% expFactor = exp(-0.5 * (xPrime.^2 + gamma^2 * yPrime.^2) / sigma^2);
% realPart = expFactor .* cos(2 * pi * xPrime / lambda + psi);
% imaginaryPart = expFactor .* sin(2 * pi * xPrime / lambda + psi);
% 
% % Wyświetlanie odpowiedzi impulsowej
% figure;
% subplot(1, 2, 1);
% imagesc(realPart);
% title('Real part of Gabor filter');
% colorbar;
% axis image;
% 
% subplot(1, 2, 2);
% imagesc(imaginaryPart);
% title('Imaginary part of Gabor filter');
% colorbar;
% axis image;