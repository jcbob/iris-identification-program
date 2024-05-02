function [outImage, shift] = detect_edges(inImage, filter_len, rgb2gray_true)

    Gh = [-ones(1, filter_len), 0, ones(1, filter_len)];
    % Gh = [-1,-1,-1,-1,0,1,1,1,1];
    Gv = Gh';

    if rgb2gray_true == true
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
    border_width = filter_len+1;
    result = imcrop(result, [border_width border_width cols-(2*border_width) rows-(2*border_width)]);

    % Obliczanie przesunięcia
    shift = [border_width, border_width];


    % % Zmniejsz rozdzielczość
    % if decrease_resolution
    %     result = imresize(result, resize_factor);
    %     shift = shift * resize_factor;
    % end

    outImage = result;

end