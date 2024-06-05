% % Encode the unwrapped iris using Local Binary Patterns (LBP)
% encoded_iris = lbp_encode(unwrapped_iris_image);
% 
% % Display the encoded iris
% figure;
% imshow(encoded_iris, []);
% title('Encoded Iris Image');





% % GABOR FILTER
% u = 5; % Number of scales
% v = 8; % Number of orientations
% m = 39; % Filter size (adjust based on your image size)
% n = 39; % Filter size (adjust based on your image size)
% gaborFilterBank = createGaborFilterBank(u, v, m, n);
% 
% % Unwrapped iris image (assumed to be already unwrapped)
% unwrappedIris = unwrapped_iris_image;
% 
% % Convert to grayscale if necessary
% if size(unwrappedIris, 3) == 3
%     unwrappedIris = rgb2gray(unwrappedIris);
% end
% 
% % Generate iris code
% irisCode = generateIrisCode(unwrappedIris, gaborFilterBank);
% 
% % Save the iris code
% save('irisCode.mat', 'irisCode');
% 
% % Visualize the iris code
% visualizeIrisCode(irisCode);




% % Apply Gabor filter to the unwrapped iris image
% ksize = 31;
% sigma = 4.0;
% theta = 1.0;
% lambda = 10.0;
% gamma = 0.5;
% psi = 0;
% 
% gaborFilterReal = gabor_fn(sigma, theta, lambda, gamma, psi, ksize);
% gaborFilterImag = gabor_fn(sigma, theta, lambda, gamma, psi + pi/2, ksize);
% 
% filtered_iris_real = conv2(double(unwrapped_iris_image), double(real(gaborFilterReal)), 'same');
% filtered_iris_imag = conv2(double(unwrapped_iris_image), double(real(gaborFilterImag)), 'same');
% filtered_iris_magnitude = sqrt(filtered_iris_real.^2 + filtered_iris_imag.^2);
% 
% % Encode using the given equation
% encoded_iris = gabor_encoding(unwrapped_iris_image, filtered_iris_real, filtered_iris_imag);
% 
% figure;
% subplot(1, 3, 1);
% imshow(unwrapped_iris_image, []);
% title('Unwrapped Iris');
% subplot(1, 3, 2);
% imshow(filtered_iris_real, []);
% title('Filtered Iris (Real Part)');
% subplot(1, 3, 3);
% imshow(abs(encoded_iris), []);
% title('Encoded Iris');