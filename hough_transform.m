close all;
clear all;

img = imread("images/artificial_eye.jpg");

img_edges = detect_edges(img);

% figure()
% imshow(img_edges)

circle = create_circle(130, 3);

r_min = 125;
r_max = 135;

[rows, cols] = size(circle);

HS = uint8(zeros(rows,cols,r_max - r_min + 1));

for r = r_min:r_max
    for col = 1:cols
        for row = 1:rows
            if circle(row,col)>0
                for theta = 0:0.1*pi:2*pi             
                    a = round(col - r*cos(theta));
                    b = round(row - r*sin(theta));
                    if a>= 1 && a <= cols && b >= 1 && b <= rows
                        HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + circle(row,col);
                    end
                end
            end 
        end
    end
end

% figure()
% imshow(HS(:,:,4))


% Znajdź maksymalną wartość w macierzy HS oraz jej indeks
[max_value, max_index] = max(HS(:));
[y_max, x_max, r_max_index] = ind2sub(size(HS), max_index);

% Oblicz rzeczywisty promień na podstawie indeksu warstwy
r_max_real = r_min + r_max_index - 1;

% Wyrysuj koło na oryginalnym obrazie
imshow(img);
hold on;
viscircles([x_max, y_max], r_max_real, 'EdgeColor', 'r');
hold off;



% % Wyświetlanie transformacji Hougha dla wszystkich promieni
% for r = r_min:r_max
%     % Wybieranie warstwy dla bieżącego promienia
%     layer_index = r - r_min + 1;
% 
%     % Wyświetlanie wyniku transformacji Hougha dla bieżącej warstwy
%     figure;
%     imshow(squeeze(HS(:, :, layer_index)));
%     title(['Transformata Hougha dla promienia ', num2str(r)]);
% end




