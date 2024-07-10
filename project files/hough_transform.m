function HS = hough_transform(img, r_min, r_max, threshold)

[rows, cols] = size(img);

HS = zeros(rows,cols,r_max - r_min + 1);

for r = r_min:r_max
    for row = 1:rows
        for col = 1:cols
            if img(row,col)>threshold
                for theta = -pi/4:0.1*pi:pi/3     %od -45 do +60 stopni (0 jest poziomo)
                    a = round(col - r*cos(theta));
                    b = round(row - r*sin(theta));
                    if a>= 1 && a <= cols && b >= 1 && b <= rows
                        HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + img(row,col);
                        % HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + 1;
                    end
                end
                for theta = 2/3*pi:0.1*pi:1.25*pi
                    a = round(col - r*cos(theta));
                    b = round(row - r*sin(theta));
                    if a>= 1 && a <= cols && b >= 1 && b <= rows
                        HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + img(row,col);
                        % HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + 1;
                    end
                end
            end 
        end
    end
end