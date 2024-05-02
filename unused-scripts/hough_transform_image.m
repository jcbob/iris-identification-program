close all;
clear all;

img = imread("images/artificial_eye.jpg");
img_edges = detect_edges(img);

figure(1)
mesh(img_edges)

r_min = 125;
r_max = 135;

[rows, cols] = size(img_edges);

HS = zeros(rows,cols,r_max - r_min + 1);

for r = r_min:r_max
    for row = 1:rows
        for col = 1:cols
            if img_edges(row,col)>0.1
                for theta = 0.1*pi:0.1*pi:2*pi
                    a = round(col - r*cos(theta));
                    b = round(row - r*sin(theta));
                    if a>= 1 && a <= cols && b >= 1 && b <= rows
                        HS(b,a,r - r_min + 1) = HS(b,a,r-r_min + 1) + img_edges(row,col);
                    end
                end
            end 
        end
    end
end


% max_r = 0;
% [asize,bsize,rsize] = size(HS);
% for a_it=1:asize
%     for b_it=1:bsize
%         for r_it=1:rsize
%             if HS(a_it,b_it,r_it) > max_r
%                 max_r = HS(a_it,b_it,r_it);
%                 a_index = a_it;
%                 b_index = b_it;
%                 r_index = r_it;
%             end
%         end
%     end
% end



% % Wyświetlanie transformacji Hougha dla wszystkich promieni
% for r = r_min:r_max
%     % Wybieranie warstwy dla bieżącego promienia
%     layer_index = r - r_min + 1;
% 
%     % Wyświetlanie wyniku transformacji Hougha dla bieżącej warstwy
%     figure;
%     imshow(squeeze(HS(:, :, layer_index)));
%     % image(HS(:, :, layer_index)*10);
%     title(['Transformata Hougha dla promienia ', num2str(r)]);
% end




% figure(3)
% % Znajdź maksymalną wartość w macierzy HS oraz jej indeks
% [max_value, max_index] = max(HS(:));
% [y_max, x_max, r_max_index] = ind2sub(size(HS), max_index);
% 
% % Oblicz rzeczywisty promień na podstawie indeksu warstwy
% r_max_real = r_min + r_max_index - 1;
% 
% % Wyrysuj koło na oryginalnym obrazie
% imshow(img);
% hold on;
% viscircles([b_index, a_index], r_index+r_min, 'EdgeColor', 'r');
% hold off;


% Znajdź maksymalną wartość w macierzy HS oraz jej indeks
[max_value, max_index] = max(HS(:));
[y_max, x_max, r_max_index] = ind2sub(size(HS), max_index);

% Oblicz rzeczywisty promień na podstawie indeksu warstwy
r_max_real = r_min + r_max_index - 1;

% Wyrysuj koło na oryginalnym obrazie
figure(41)
imshow(img);
hold on;
viscircles([x_max, y_max], r_max_real, 'EdgeColor', 'r');
hold off;



figure(31)
% mesh(HS(:,:,r_max_index))
mesh(HS(:,:,r_max_index))
% figure()
% imagesc(HS(:,:,5))


%% NIEUŻYWANY KOD
% max_r = 0;
% [asize,bsize,rsize] = size(HS);
% for a_it=1:asize
%     for b_it=1:bsize
%         for r_it=1:rsize
%             if HS(a_it,b_it,r_it) > max_r
%                 max_r = HS(a_it,b_it,r_it);
%                 a_index = a_it;
%                 b_index = b_it;
%                 r_index = r_it;
%             end
%         end
%     end
% end



% % Wyświetlanie transformacji Hougha dla wszystkich promieni
% for r = r_min:r_max
%     % Wybieranie warstwy dla bieżącego promienia
%     layer_index = r - r_min + 1;
% 
%     % Wyświetlanie wyniku transformacji Hougha dla bieżącej warstwy
%     figure;
%     imshow(squeeze(HS(:, :, layer_index)));
%     % image(HS(:, :, layer_index)*10);
%     title(['Transformata Hougha dla promienia ', num2str(r)]);
% end




% figure(3)
% % Znajdź maksymalną wartość w macierzy HS oraz jej indeks
% [max_value, max_index] = max(HS(:));
% [y_max, x_max, r_max_index] = ind2sub(size(HS), max_index);
% 
% % Oblicz rzeczywisty promień na podstawie indeksu warstwy
% r_max_real = r_min + r_max_index - 1;
% 
% % Wyrysuj koło na oryginalnym obrazie
% imshow(img);
% hold on;
% viscircles([b_index, a_index], r_index+r_min, 'EdgeColor', 'r');
% hold off;
