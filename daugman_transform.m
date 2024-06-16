% function A = daugman_transform(img, r_min, r_max)
%     [rows, cols] = size(img);
%     A = zeros(rows, cols, r_max - r_min + 1);
% 
%     % Compute the gradient magnitude of the image
%     [Gx, Gy] = gradient(img);
%     V = sqrt(Gx.^2 + Gy.^2);
% 
%     for x = 1:cols
%         for y = 1:rows
%             for r = r_min:r_max
%                 for theta = 0:pi/180:2*pi
%                     % Calculate the center coordinates
%                     xc = round(x - r * cos(theta));
%                     yc = round(y - r * sin(theta));
% 
%                     % Check if the center coordinates are within the image bounds
%                     if xc >= 1 && xc <= cols && yc >= 1 && yc <= rows
%                         A(y, x, r - r_min + 1) = A(y, x, r - r_min + 1) + V(yc, xc);
%                     end
%                 end
%             end
%         end
%     end
% 
% end
