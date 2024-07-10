% function plot_frequency_spectrum(combinedImage, dpi)
%     % Convert DPI to dots per millimeter
%     fs = dpi / 25.4;  % Sampling frequency in dots/mm
% 
%     % Get number of rows (strips) in combinedImage
%     num_strips = size(combinedImage, 1);
% 
%     % Iterate over each strip in combinedImage
%     for strip_idx = 1:num_strips
%         figure;
% 
%         % Extract the strip from the combined image
%         strip = combinedImage(strip_idx, :);
% 
%         % Remove the DC component (mean value) from the strip
%         stripMean = mean(strip, 'all');
%         strip = strip - stripMean;
% 
%         % Compute the FFT of the strip
%         N = length(strip);
%         fftStrip = fft(strip);
% 
%         % Compute the frequency axis in Hertz (or spatial frequency in this case)
%         freq = (0:N-1) * (fs / N);
% 
%         % Compute the magnitude spectrum
%         magnitudeSpectrum = abs(fftStrip);
% 
%         % Plot the magnitude spectrum
%         plot(freq, magnitudeSpectrum);
% 
%         xlabel('Spatial Frequency (cycles/mm)');
%         ylabel('Magnitude');
%         title('Frequency Spectrum of All Strips');
% 
%         % Display only the first half of the spectrum (since it is symmetric)
%         xlim([0, fs/2]);
%     end
% 
% 
% end


function plot_frequency_spectrum(combinedImage, dpi)
    % Convert DPI to dots per millimeter
    fs = dpi / 25.4;  % Sampling frequency in dots/mm

    % Extract the first strip from the combined image
    firstStrip = combinedImage(1, :);

    % Remove the DC component (mean value) from the strip
    stripMean = mean(firstStrip, 'all');
    firstStrip = firstStrip - stripMean;

    % Compute the FFT of the strip
    N = length(firstStrip);
    fftStrip = fft(firstStrip);

    % Compute the frequency axis in Hertz (or spatial frequency in this case)
    freq = (0:N-1) * (fs / N);

    % Compute the magnitude spectrum
    magnitudeSpectrum = abs(fftStrip);

    % Display the magnitude spectrum
    figure;
    plot(freq, magnitudeSpectrum);
    xlabel('Spatial Frequency (cycles/mm)');
    ylabel('Magnitude');
    title('Frequency Spectrum of the First Strip');

    % Display only the first half of the spectrum (since it is symmetric)
    xlim([0, fs/2]);
end
