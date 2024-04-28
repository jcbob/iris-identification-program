function [circle] = create_circle(radius, thickness)

% Wymiary obrazu
width = 500;
height = 500;

% Środek okręgu
center_x = width / 2;
center_y = height / 2;

% Promień i grubość okręgu
radius_outer = radius;  % większy promień
thickness = thickness;  % grubość okręgu

% Tworzenie nowego obrazu
img = zeros(height, width);

% Tworzenie maski zewnętrznego okręgu
[x, y] = meshgrid(1:width, 1:height);
outer_circle_mask = (x - center_x).^2 + (y - center_y).^2 <= (radius_outer + thickness/2)^2;

% Tworzenie maski wewnętrznego okręgu
inner_circle_mask = (x - center_x).^2 + (y - center_y).^2 <= (radius_outer - thickness/2)^2;

% Określenie wartości intensywności pikseli wewnątrz okręgu
intensity_value = 100; % Wartość intensywności dla pikseli wewnątrz okręgu

% Rysowanie okręgu o zadanej grubości i wartości intensywności
img(outer_circle_mask & ~inner_circle_mask) = intensity_value;

circle = img;

end