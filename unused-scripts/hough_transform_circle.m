close all;
clear all;

circle = create_circle(130, 1);
% circle = generate_Aeye(130, 50, 400, 600)


figure(1)
imshow(circle)

r_min = 129;
r_max = 131;

[rows, cols] = size(circle);

HS = uint8(zeros(rows,cols,r_max - r_min + 1));

for r = r_min:r_max
    for col = 1:cols
        for row = 1:rows
            if circle(row,col)>0.1
                for theta = 0.1:0.1*pi:2*pi             
                    a = round(col - r*cos(theta));
                    b = round(row - r*sin(theta));
                    if a>= 1 && a <= cols && b >= 1 && b <= rows
                        HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + 10;
                    end
                end
            end 
        end
    end
end

% figure(2)
% imshow(HS(:,:,11))


% max_r = 0;
% [asize,bsize,rsize] = size(HS);
% for a=1:asize
%     for b=1:bsize
%         for r=1:rsize
%             if HS(a,b,r) > max_r
%                 max_r = HS(a,b,r);
%                 a_index = a;
%                 b_index = b;
%                 r_index = r;
%             end
%         end
%     end
% end



% Znajdź maksymalną wartość w macierzy HS oraz jej indeks
[max_value, max_index] = max(HS(:));
[y_max, x_max, r_max_index] = ind2sub(size(HS), max_index);

% Oblicz rzeczywisty promień na podstawie indeksu warstwy
r_max_real = r_min + r_max_index - 1;


% Wyświetlanie transformacji Hougha dla wszystkich promieni
for r = r_min:r_max
    % Wybieranie warstwy dla bieżącego promienia
    layer_index = r - r_min + 1;

    % Wyświetlanie wyniku transformacji Hougha dla bieżącej warstwy
    figure;
    imshow(squeeze(HS(:, :, layer_index))*5);
    title(['Transformata Hougha dla promienia ', num2str(r)]);
end


% Wyrysuj koło na oryginalnym obrazie
figure(2)
imshow(circle, []);
hold on;
viscircles([x_max, y_max], r_max_real, 'EdgeColor', 'r');
hold off;


