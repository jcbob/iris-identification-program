function HS = hough_transform_pupil(img, r_min, r_max, threshold)

[rows, cols] = size(img);

HS = zeros(rows,cols,r_max - r_min + 1);

for r = r_min:r_max
    for row = 1:rows
        for col = 1:cols
            if img(row,col)>threshold
                for theta = 0.1*pi:0.1*pi:2*pi
                    a = round(col - r*cos(theta));
                    b = round(row - r*sin(theta));
                    if a>= 1 && a <= cols && b >= 1 && b <= rows
                        HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + img(row,col);
                    end
                end
            end 
        end
    end
end


% POPRAWIC
%1. tak zeby obejmowal nie caly okrag ale dwa razy (prawa strone i lewa) do
%   jakiegos tam zakresu stopni
%2. sprawic zeby lewa strona i prawa byly wagowane jesli jedna jest
%   bardziej oswietlona od drugiej


