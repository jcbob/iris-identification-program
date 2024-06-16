function [outImage, shift] = detect_edges(inImage, filter_len, rgb2gray_true, sigma, filter_ratio)

    Gh = [-ones(1, filter_len), 0, ones(1, filter_len)];
    Gv = Gh';

    if rgb2gray_true == true
        img_gray = rgb2gray(inImage);
    else
        img_gray = inImage;
    end

    img_gray = im2double(img_gray);

    % figure(100)
    % imshow(img_gray)

    filtersize = filter_ratio * sigma;
    kernel = fspecial("gaussian", filtersize, sigma);
    image = imfilter(img_gray, kernel, 'conv', 'replicate');
    % image = img_gray;

    % image = img_gray;

    % figure(101)
    % mesh(image)
    

    % Filtrowanie krawędzi
    horizontal = conv2(double(image), Gh, 'same');
    vertical = conv2(double(image), Gv, 'same');

    % figure(102)
    % mesh(horizontal)

    % figure(103)
    % mesh(vertical)

    horizontal = horizontal .* horizontal;
    vertical = vertical .* vertical;

    result = horizontal + vertical;
    result = sqrt(result);

    % Wycinanie obszaru brzegowego
    [rows, cols, ~] = size(result);
    border_width = filter_len+1;
    result = imcrop(result, [border_width border_width cols-(2*border_width) rows-(2*border_width)]);

    % Obliczanie przesunięcia
    shift = [border_width, border_width];

    outImage = result;
end