function obraz_oka = generate_Aeye(promien_twardowki, promien_zrenicy, szerokosc, wysokosc)
    % Tworzenie obrazu o tle białym
    tlo = zeros(wysokosc, szerokosc); %czarne tło
    % tlo = ones(wysokosc, szerokosc); %białe tło

    % Współrzędne środka oka
    srodek_x = szerokosc / 2;
    srodek_y = wysokosc / 2;

    % Promienie dla poszczególnych części oka
    % promien_twardowki = min(szerokosc, wysokosc) * 0.35;
    % promien_zrenicy = promien_twardowki * 0.3;

    % Tworzenie twardówki (jedno koło o odcieniu szarawym)
    [x, y] = meshgrid(1:szerokosc, 1:wysokosc);
    twardowka = ((x - srodek_x).^2 + (y - srodek_y).^2) <= promien_twardowki^2;

    % Tworzenie źrenicy (jedno czarne koło w twardówce)
    zrenica_srodek_x = srodek_x;
    zrenica_srodek_y = srodek_y;
    zrenica = ((x - zrenica_srodek_x).^2 + (y - zrenica_srodek_y).^2) <= promien_zrenicy^2;

    % Ustawienie kolorów
    kolor_twardowki = 0.5;

    % Rysowanie oka
    obraz_oka = tlo;
    obraz_oka(twardowka) = kolor_twardowki;
    % obraz_oka(zrenica) = 0; % czarny kolor zrenicy
    obraz_oka(zrenica) = 1; % biały kolor zrenicy
end
