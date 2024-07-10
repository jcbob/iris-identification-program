% Ustawienie rozmiaru obrazu
szerokosc = 600;
wysokosc = 400;

% Tworzenie obrazu o tle białym
tlo = ones(wysokosc, szerokosc);

% Współrzędne środka oka
srodek_x = szerokosc / 2;
srodek_y = wysokosc / 2;

% Promienie dla poszczególnych części oka
promien_twardowki = min(szerokosc, wysokosc) * 0.35;
promien_zrenicy = promien_twardowki * 0.3;

% Tworzenie twardówki (jedno koło o odcieniu szarawym)
[x, y] = meshgrid(1:szerokosc, 1:wysokosc);
twardowka = ((x - srodek_x).^2 + (y - srodek_y).^2) <= promien_twardowki^2;

% Tworzenie źrenicy (jedno czarne koło w twardówce)
zrenica_srodek_x = srodek_x;
zrenica_srodek_y = srodek_y;
zrenica = ((x - zrenica_srodek_x).^2 + (y - zrenica_srodek_y).^2) <= promien_zrenicy^2;

% Ustawienie kolorów
kolor_twardowki = 0.7;

% Rysowanie oka
oko = tlo;
oko(twardowka) = kolor_twardowki;
oko(zrenica) = 0; % czarny kolor zrenicy

% Wyświetlenie obrazu
imshow(oko);
