close all;
clear all;

% Load the combined strip images and labels
load('combined_strip_images_add_1.mat', 'combined_strip_images', 'labels');

% Initialize variables to store IrisCodes
irisCodes_real = {};
irisCodes_imag = {};

% Process each combined strip image
for i = 1:length(combined_strip_images)
    combined_image = combined_strip_images{i};

    % Encode Iris
    [iris_code_real, iris_code_imag] = apply_gabor_filter(combined_image);

    % Store IrisCodes
    irisCodes_real{end+1} = iris_code_real;
    irisCodes_imag{end+1} = iris_code_imag;
end

% Calculate Hamming distances and create confusion matrix
num_images = length(irisCodes_real);
confusion_matrix_real = zeros(num_images, num_images);
confusion_matrix_imag = zeros(num_images, num_images);

intra_class_distances_real = [];
inter_class_distances_real = [];
intra_class_distances_imag = [];
inter_class_distances_imag = [];

for i = 1:num_images
    for j = 1:num_images
        [hd_real, hd_imag] = hamming_distance_n(irisCodes_real{i}, irisCodes_imag{i}, irisCodes_real{j}, irisCodes_imag{j});
        confusion_matrix_real(i, j) = hd_real;
        confusion_matrix_imag(i, j) = hd_imag;
        
        % Separate intra-class and inter-class distances
        if iscell(labels)
            if strcmp(labels{i}, labels{j})
                intra_class_distances_real(end+1) = hd_real;
                intra_class_distances_imag(end+1) = hd_imag;
            else
                inter_class_distances_real(end+1) = hd_real;
                inter_class_distances_imag(end+1) = hd_imag;
            end
        else
            if labels(i) == labels(j)
                intra_class_distances_real(end+1) = hd_real;
                intra_class_distances_imag(end+1) = hd_imag;
            else
                inter_class_distances_real(end+1) = hd_real;
                inter_class_distances_imag(end+1) = hd_imag;
            end
        end
    end
end

% Filter out zero distances for d-prime calculation
intra_class_distances_real_no_zero = intra_class_distances_real(intra_class_distances_real ~= 0);
inter_class_distances_real_no_zero = inter_class_distances_real(inter_class_distances_real ~= 0);
intra_class_distances_imag_no_zero = intra_class_distances_imag(intra_class_distances_imag ~= 0);
inter_class_distances_imag_no_zero = inter_class_distances_imag(inter_class_distances_imag ~= 0);

% Calculate d-prime for real part
mu1_real = mean(intra_class_distances_real_no_zero);
mu2_real = mean(inter_class_distances_real_no_zero);
sigma1_real = std(intra_class_distances_real_no_zero);
sigma2_real = std(inter_class_distances_real_no_zero);
d_real = abs(mu1_real - mu2_real) / sqrt(sigma1_real^2 + sigma2_real^2);

% Calculate d-prime for imaginary part
mu1_imag = mean(intra_class_distances_imag_no_zero);
mu2_imag = mean(inter_class_distances_imag_no_zero);
sigma1_imag = std(intra_class_distances_imag_no_zero);
sigma2_imag = std(inter_class_distances_imag_no_zero);
d_imag = abs(mu1_imag - mu2_imag) / sqrt(sigma1_imag^2 + sigma2_imag^2);

% Display d-prime values
fprintf('d-prime for real part: %.4f\n', d_real);
fprintf('d-prime for imaginary part: %.4f\n', d_imag);

% Display confusion matrices without text labels
figure;
subplot(1,2,1)
imagesc(confusion_matrix_real);
colormap(gray);
colorbar;
title('Confusion Matrix (Real Part)');
xlabel('Image Index');
ylabel('Image Index');

% figure;
subplot(1,2,2)
imagesc(confusion_matrix_imag);
colormap(gray);
colorbar;
title('Confusion Matrix (Imaginary Part)');
xlabel('Image Index');
ylabel('Image Index');

% Save confusion matrices
% save('confusion_matrix_real.mat', 'confusion_matrix_real');
% save('confusion_matrix_imag.mat', 'confusion_matrix_imag');

disp('Confusion matrices have been created and saved.');

% Define bin edges for histograms
binEdges = 0:0.01:1;

% Plot histograms and Gaussian fits for real part
figure;
subplot(2, 1, 1);
histogram(intra_class_distances_real, binEdges, 'Normalization', 'probability', 'FaceColor', 'b');
hold on;
histogram(inter_class_distances_real, binEdges, 'Normalization', 'probability', 'FaceColor', 'r');
hold on;

% Gaussian fit for intra-class distances (real part)
x = binEdges;
pdf_intra_real = normpdf(x, mu1_real, sigma1_real);
plot(x, pdf_intra_real * (x(2) - x(1)), 'b-', 'LineWidth', 2);

% Gaussian fit for inter-class distances (real part)
pdf_inter_real = normpdf(x, mu2_real, sigma2_real);
plot(x, pdf_inter_real * (x(2) - x(1)), 'r-', 'LineWidth', 2);

hold off;
title('Hamming Distances (Real Part)');
xlabel('Hamming Distance');
ylabel('Probability');
legend('Intra-Class', 'Inter-Class', 'Intra-Class Fit', 'Inter-Class Fit');

% Plot histograms and Gaussian fits for imaginary part
subplot(2, 1, 2);
histogram(intra_class_distances_imag, binEdges, 'Normalization', 'probability', 'FaceColor', 'b');
hold on;
histogram(inter_class_distances_imag, binEdges, 'Normalization', 'probability', 'FaceColor', 'r');
hold on;

% Gaussian fit for intra-class distances (imaginary part)
pdf_intra_imag = normpdf(x, mu1_imag, sigma1_imag);
plot(x, pdf_intra_imag * (x(2) - x(1)), 'b-', 'LineWidth', 2);

% Gaussian fit for inter-class distances (imaginary part)
pdf_inter_imag = normpdf(x, mu2_imag, sigma2_imag);
plot(x, pdf_inter_imag * (x(2) - x(1)), 'r-', 'LineWidth', 2);

hold off;
title('Hamming Distances (Imaginary Part)');
xlabel('Hamming Distance');
ylabel('Probability');
legend('Intra-Class', 'Inter-Class', 'Intra-Class Fit', 'Inter-Class Fit');

% Concatenate Hamming distances from both real and imaginary parts
hamming_distances_combined_intra = [intra_class_distances_real, intra_class_distances_imag];
hamming_distances_combined_inter = [inter_class_distances_real, inter_class_distances_imag];

% Calculate combined Gaussian fit parameters
mu_combined_intra = mean(hamming_distances_combined_intra);
sigma_combined_intra = std(hamming_distances_combined_intra);
mu_combined_inter = mean(hamming_distances_combined_inter);
sigma_combined_inter = std(hamming_distances_combined_inter);

% Plot combined histogram and Gaussian fits
figure;
histogram(hamming_distances_combined_intra, binEdges, 'Normalization', 'probability', 'FaceColor', 'b');
hold on;
histogram(hamming_distances_combined_inter, binEdges, 'Normalization', 'probability', 'FaceColor', 'r');

% Gaussian fit for combined intra-class distances
pdf_combined_intra = normpdf(x, mu_combined_intra, sigma_combined_intra);
plot(x, pdf_combined_intra * (x(2) - x(1)), 'b-', 'LineWidth', 2);

% Gaussian fit for combined inter-class distances
pdf_combined_inter = normpdf(x, mu_combined_inter, sigma_combined_inter);
plot(x, pdf_combined_inter * (x(2) - x(1)), 'r-', 'LineWidth', 2);

hold off;
title('Combined Hamming Distances (Real and Imaginary Parts)');
xlabel('Hamming Distance');
ylabel('Probability');
legend('Intra-Class', 'Inter-Class', 'Intra-Class Fit', 'Inter-Class Fit');

disp('Histograms and Gaussian distributions of Hamming distances have been plotted.');



























% close all;
% clear all;
% 
% % Load the combined strip images and labels
% load('combined_strip_images_no_resize.mat', 'combined_strip_images', 'labels');
% 
% % Initialize variables to store IrisCodes
% irisCodes_real = {};
% irisCodes_imag = {};
% 
% % Process each combined strip image
% for i = 1:length(combined_strip_images)
%     combined_image = combined_strip_images{i};
% 
%     % Encode Iris
%     [iris_code_real, iris_code_imag] = apply_gabor_filter(combined_image);
% 
%     % Store IrisCodes
%     irisCodes_real{end+1} = iris_code_real;
%     irisCodes_imag{end+1} = iris_code_imag;
% end
% 
% % Calculate Hamming distances and create confusion matrix
% num_images = length(irisCodes_real);
% confusion_matrix_real = zeros(num_images, num_images);
% confusion_matrix_imag = zeros(num_images, num_images);
% 
% intra_class_distances_real = [];
% inter_class_distances_real = [];
% intra_class_distances_imag = [];
% inter_class_distances_imag = [];
% 
% for i = 1:num_images
%     for j = 1:num_images
%         [hd_real, hd_imag] = hamming_distance_n(irisCodes_real{i}, irisCodes_imag{i}, irisCodes_real{j}, irisCodes_imag{j});
%         confusion_matrix_real(i, j) = hd_real;
%         confusion_matrix_imag(i, j) = hd_imag;
% 
%         % Separate intra-class and inter-class distances
%         if iscell(labels)
%             if strcmp(labels{i}, labels{j})
%                 intra_class_distances_real(end+1) = hd_real;
%                 intra_class_distances_imag(end+1) = hd_imag;
%             else
%                 inter_class_distances_real(end+1) = hd_real;
%                 inter_class_distances_imag(end+1) = hd_imag;
%             end
%         else
%             if labels(i) == labels(j)
%                 intra_class_distances_real(end+1) = hd_real;
%                 intra_class_distances_imag(end+1) = hd_imag;
%             else
%                 inter_class_distances_real(end+1) = hd_real;
%                 inter_class_distances_imag(end+1) = hd_imag;
%             end
%         end
%     end
% end
% 
% % Filter out zero distances for d-prime calculation
% intra_class_distances_real_no_zero = intra_class_distances_real(intra_class_distances_real ~= 0);
% inter_class_distances_real_no_zero = inter_class_distances_real(inter_class_distances_real ~= 0);
% intra_class_distances_imag_no_zero = intra_class_distances_imag(intra_class_distances_imag ~= 0);
% inter_class_distances_imag_no_zero = inter_class_distances_imag(inter_class_distances_imag ~= 0);
% 
% % Calculate d-prime for real part
% mu1_real = mean(intra_class_distances_real_no_zero);
% mu2_real = mean(inter_class_distances_real_no_zero);
% sigma1_real = std(intra_class_distances_real_no_zero);
% sigma2_real = std(inter_class_distances_real_no_zero);
% d_real = abs(mu1_real - mu2_real) / sqrt(sigma1_real^2 + sigma2_real^2);
% 
% % Calculate d-prime for imaginary part
% mu1_imag = mean(intra_class_distances_imag_no_zero);
% mu2_imag = mean(inter_class_distances_imag_no_zero);
% sigma1_imag = std(intra_class_distances_imag_no_zero);
% sigma2_imag = std(inter_class_distances_imag_no_zero);
% d_imag = abs(mu1_imag - mu2_imag) / sqrt(sigma1_imag^2 + sigma2_imag^2);
% 
% % Display d-prime values
% fprintf('d-prime for real part: %.4f\n', d_real);
% fprintf('d-prime for imaginary part: %.4f\n', d_imag);
% 
% % Display confusion matrices
% figure;
% imagesc(confusion_matrix_real);
% colormap(gray);
% colorbar;
% title('Confusion Matrix (Real Part)');
% xlabel('Image Index');
% ylabel('Image Index');
% 
% % Add text labels
% for i = 1:num_images
%     for j = 1:num_images
%         text(j, i, sprintf('%.2f', confusion_matrix_real(i, j)), 'HorizontalAlignment', 'Center', 'Color', 'red');
%     end
% end
% 
% figure;
% imagesc(confusion_matrix_imag);
% colormap(gray);
% colorbar;
% title('Confusion Matrix (Imaginary Part)');
% xlabel('Image Index');
% ylabel('Image Index');
% 
% % Add text labels
% for i = 1:num_images
%     for j = 1:num_images
%         text(j, i, sprintf('%.2f', confusion_matrix_imag(i, j)), 'HorizontalAlignment', 'Center', 'Color', 'red');
%     end
% end
% 
% % Save confusion matrices
% % save('confusion_matrix_real.mat', 'confusion_matrix_real');
% % save('confusion_matrix_imag.mat', 'confusion_matrix_imag');
% 
% disp('Confusion matrices have been created and saved.');
% 
% % Plot histograms for real part
% figure;
% subplot(2, 1, 1);
% histogram(intra_class_distances_real, 'Normalization', 'probability', 'BinWidth', 0.01, 'FaceColor', 'b');
% hold on;
% histogram(inter_class_distances_real, 'Normalization', 'probability', 'BinWidth', 0.01, 'FaceColor', 'r');
% hold off;
% title('Hamming Distances (Real Part)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% legend('Intra-Class', 'Inter-Class');
% 
% % Plot histograms for imaginary part
% subplot(2, 1, 2);
% histogram(intra_class_distances_imag, 'Normalization', 'probability', 'BinWidth', 0.01, 'FaceColor', 'b');
% hold on;
% histogram(inter_class_distances_imag, 'Normalization', 'probability', 'BinWidth', 0.01, 'FaceColor', 'r');
% hold off;
% title('Hamming Distances (Imaginary Part)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% legend('Intra-Class', 'Inter-Class');
% 
% % Concatenate Hamming distances from both real and imaginary parts
% hamming_distances_combined_intra = [intra_class_distances_real, intra_class_distances_imag];
% hamming_distances_combined_inter = [inter_class_distances_real, inter_class_distances_imag];
% 
% % Plot combined histogram
% figure;
% histogram(hamming_distances_combined_intra, 'Normalization', 'probability', 'BinWidth', 0.01, 'FaceColor', 'b');
% hold on;
% histogram(hamming_distances_combined_inter, 'Normalization', 'probability', 'BinWidth', 0.01, 'FaceColor', 'r');
% hold off;
% title('Combined Hamming Distances (Real and Imaginary Parts)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% legend('Intra-Class', 'Inter-Class');
% 
% disp('Histograms of Hamming distances have been plotted.');






















































% close all;
% clear all;
% 
% % Load the combined strip images and labels
% % load('combined_strip_images_add_1.mat', 'combined_strip_images', 'labels');
% % load('combined_strip_images_greater_r.mat', 'combined_strip_images', 'labels');
% load('combined_strip_images.mat', 'combined_strip_images', 'labels');
% 
% % Initialize variables to store IrisCodes
% irisCodes_real = {};
% irisCodes_imag = {};
% 
% % Process each combined strip image
% for i = 1:length(combined_strip_images)
%     combined_image = combined_strip_images{i};
% 
%     % Encode Iris
%     [iris_code_real, iris_code_imag] = apply_gabor_filter(combined_image);
% 
%     % Store IrisCodes
%     irisCodes_real{end+1} = iris_code_real;
%     irisCodes_imag{end+1} = iris_code_imag;
% end
% 
% % Calculate Hamming distances and create confusion matrix
% num_images = length(irisCodes_real);
% confusion_matrix_real = zeros(num_images, num_images);
% confusion_matrix_imag = zeros(num_images, num_images);
% 
% for i = 1:num_images
%     for j = 1:num_images
%         [hd_real, hd_imag] = hamming_distance_n(irisCodes_real{i}, irisCodes_imag{i}, irisCodes_real{j}, irisCodes_imag{j});
%         confusion_matrix_real(i, j) = hd_real;
%         confusion_matrix_imag(i, j) = hd_imag;
%     end
% end
% 
% % Display confusion matrices
% figure;
% subplot(1,2,1)
% imagesc(confusion_matrix_real);
% colormap(gray);
% colorbar;
% title('Confusion Matrix (Real Part)');
% xlabel('Image Index');
% ylabel('Image Index');
% 
% subplot(1,2,2)
% imagesc(confusion_matrix_imag);
% colormap(gray);
% colorbar;
% title('Confusion Matrix (Imaginary Part)');
% xlabel('Image Index');
% ylabel('Image Index');
% 
% % Save confusion matrices
% save('confusion_matrix_real.mat', 'confusion_matrix_real');
% save('confusion_matrix_imag.mat', 'confusion_matrix_imag');
% 
% disp('Confusion matrices have been created and saved.');
% 
% % Calculate Hamming distances and flatten the matrices
% hamming_distances_real = confusion_matrix_real(:);
% hamming_distances_imag = confusion_matrix_imag(:);
% 
% % Plot histograms
% figure;
% subplot(2, 1, 1);
% histogram(hamming_distances_real, 'Normalization', 'probability', 'BinWidth', 0.01); % Adjust bin width here
% title('Hamming Distances (Real Part)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% 
% subplot(2, 1, 2);
% histogram(hamming_distances_imag, 'Normalization', 'probability', 'BinWidth', 0.01); % Adjust bin width here
% title('Hamming Distances (Imaginary Part)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% 
% % Concatenate hamming distances from both real and imaginary parts
% hamming_distances_combined = [hamming_distances_real, hamming_distances_imag];
% 
% 
% % Plot combined histogram
% figure;
% histogram(hamming_distances_combined, 'Normalization', 'probability', 'BinWidth', 0.01); % Adjust bin width here
% title('Combined Hamming Distances (Real and Imaginary Parts)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% 
% disp('Histograms of Hamming distances have been plotted.');



















































% close all;
% clear all;
% 
% % Load the combined strip images and labels
% % load('combined_strip_images_add_1.mat', 'combined_strip_images', 'labels');
% % load('combined_strip_images_greater_r.mat', 'combined_strip_images', 'labels');
% load('combined_strip_images.mat', 'combined_strip_images', 'labels');
% 
% % Initialize variables to store IrisCodes
% irisCodes_real = {};
% irisCodes_imag = {};
% 
% % Process each combined strip image
% for i = 1:length(combined_strip_images)
%     combined_image = combined_strip_images{i};
% 
%     % Encode Iris
%     [iris_code_real, iris_code_imag] = apply_gabor_filter(combined_image);
% 
%     % Store IrisCodes
%     irisCodes_real{end+1} = iris_code_real;
%     irisCodes_imag{end+1} = iris_code_imag;
% end
% 
% % Calculate Hamming distances and create confusion matrix
% num_images = length(irisCodes_real);
% confusion_matrix_real = zeros(num_images, num_images);
% confusion_matrix_imag = zeros(num_images, num_images);
% 
% for i = 1:num_images
%     for j = 1:num_images
%         [hd_real, hd_imag] = hamming_distance_n(irisCodes_real{i}, irisCodes_imag{i}, irisCodes_real{j}, irisCodes_imag{j});
%         confusion_matrix_real(i, j) = hd_real;
%         confusion_matrix_imag(i, j) = hd_imag;
%     end
% end
% 
% % Display confusion matrices
% figure;
% subplot(1,2,1)
% imagesc(confusion_matrix_real);
% colormap(gray);
% colorbar;
% title('Confusion Matrix (Real Part)');
% xlabel('Image Index');
% ylabel('Image Index');
% 
% % Add text labels
% for i = 1:num_images
%     for j = 1:num_images
%         text(j, i, sprintf('%.2f', confusion_matrix_real(i, j)), 'HorizontalAlignment', 'Center', 'Color', 'red');
%     end
% end
% 
% % figure;
% subplot(1,2,2)
% imagesc(confusion_matrix_imag);
% colormap(gray);
% colorbar;
% title('Confusion Matrix (Imaginary Part)');
% xlabel('Image Index');
% ylabel('Image Index');
% 
% % Add text labels
% for i = 1:num_images
%     for j = 1:num_images
%         text(j, i, sprintf('%.2f', confusion_matrix_imag(i, j)), 'HorizontalAlignment', 'Center', 'Color', 'red');
%     end
% end
% 
% % Save confusion matrices
% save('confusion_matrix_real.mat', 'confusion_matrix_real');
% save('confusion_matrix_imag.mat', 'confusion_matrix_imag');
% 
% disp('Confusion matrices have been created and saved.');
% 
% 
% 
% % Calculate Hamming distances and flatten the matrices
% hamming_distances_real = confusion_matrix_real(:);
% hamming_distances_imag = confusion_matrix_imag(:);
% 
% % Plot histograms
% figure;
% subplot(2, 1, 1);
% histogram(hamming_distances_real, 'Normalization', 'probability', 'BinWidth', 0.01); % Adjust bin width here
% title('Hamming Distances (Real Part)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% 
% subplot(2, 1, 2);
% histogram(hamming_distances_imag, 'Normalization', 'probability', 'BinWidth', 0.01); % Adjust bin width here
% title('Hamming Distances (Imaginary Part)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% 
% 
% % Concatenate hamming distances from both real and imaginary parts
% hamming_distances_combined = [hamming_distances_real, hamming_distances_imag];
% 
% 
% % Plot combined histogram
% figure;
% histogram(hamming_distances_combined, 'Normalization', 'probability', 'BinWidth', 0.01); % Adjust bin width here
% title('Combined Hamming Distances (Real and Imaginary Parts)');
% xlabel('Hamming Distance');
% ylabel('Probability');
% 
% disp('Histograms of Hamming distances have been plotted.');
