image = imread("images/artificial_eye.jpg");
image_gr = rgb2gray(image);
image_gr = im2double(image_gr);
imshow(image_gr)

% zmien rozdzielczość obrazu

% Define Gaussian filter kernel
sigma = 10;  % Standard deviation
filter_size = 5*sigma;  % Filter size
kernel = fspecial('gaussian', filter_size, sigma);
% Apply Gaussian filter
filtered_image = imfilter(image_gr, kernel, 'conv', 'replicate');


Gh = [-1,-1,-1,-1,0,1,1,1,1]; %horizontal
Gv = Gh'; %vertical

horizontal = conv2(double(filtered_image), Gh, 'same');
vertical = conv2(double(filtered_image), Gv, 'same'); 

horizontal = horizontal.*horizontal;
vertical = vertical.*vertical;

result = horizontal + vertical;
result = sqrt(result);
% result = sqrt(result);

validation(:,:,1) = mat2gray(image_gr); % Normalize the grayscale image
validation(:,:,2) = mat2gray(image_gr);
validation(:,:,3) = mat2gray(image_gr + 10.*result); 
figure()
imshow(validation)



% brac dwa razy mniejsza rozdzielczosc
% mniej proimeini do przeszukiwania
% jest duzo szybciej
% ale potem trzeba wrocic do pelenej rozdzielczosci i trzeba przekazac
% wspolrzedne srodka i promien (x2 wieksze czy zalezy ile tam
% zmniejszylismy