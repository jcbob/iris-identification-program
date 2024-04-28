function [outImage, shift, Gh] = detect_edges(inImage, filter_len, rgb2gray_true)

    % Gh = [-ones(1, filter_len), 0, ones(1, filter_len)];
    Gh = [-1,-1,-1,-1,0,1,1,1,1];
    Gv = Gh';

    if rgb2gray_true
        img_gray = rgb2gray(inImage);
    else
        img_gray = inImage;
    end

    img_gray = im2double(img_gray);

    sigma = 12;
    filtersize = 3 * sigma;
    kernel = fspecial("gaussian", filtersize, sigma);
    image = imfilter(img_gray, kernel, 'conv', 'replicate');

    % Filtrowanie krawędzi
    horizontal = conv2(double(image), Gh, 'same');
    vertical = conv2(double(image), Gv, 'same');

    horizontal = horizontal .* horizontal;
    vertical = vertical .* vertical;

    result = horizontal + vertical;
    result = sqrt(result);

    % Wycinanie obszaru brzegowego
    [rows, cols, ~] = size(result);
    border_width = filter_len;
    result = imcrop(result, [border_width border_width cols-(2*border_width) rows-(2*border_width)]);

    % Obliczanie przesunięcia
    shift = [border_width, border_width];

    outImage = result;

end


% function [outImage] = detect_edges(inImage, rgb2gray)
%     Gh = [-1,-1,-1,-1,0,1,1,1,1];
%     Gv = Gh';
% 
%     if rgb2gray
%         img_gray = rgb2gray(inImage);
%     else
%         img_gray = inImage;
%     end
% 
%     img_gray = im2double(img_gray);
% 
%     sigma = 12;
%     filtersize = 3 * sigma;
%     kernel = fspecial("gaussian", filtersize, sigma);
%     image = imfilter(img_gray, kernel, 'conv', 'replicate');
% 
%     % Filtrowanie krawędzi
%     horizontal = conv2(double(image), Gh, 'same');
%     vertical = conv2(double(image), Gv, 'same');
% 
%     horizontal = horizontal .* horizontal;
%     vertical = vertical .* vertical;
% 
%     result = horizontal + vertical;
%     result = sqrt(result);
% 
%     % Wycinanie obszaru brzegowego
%     [rows, cols, ~] = size(result);
%     border_width = 5;
%     result = imcrop(result, [border_width border_width cols-(2*border_width) rows-(2*border_width)]);
% 
%     % % Usunięcie obszaru brzegowego
%     % border_pixels = 100; % Ilość pikseli do usunięcia z brzegów
%     % result = result(border_pixels+1:end-border_pixels, border_pixels+1:end-border_pixels);
% 
%     outImage = result;
% end