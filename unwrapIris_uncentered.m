% jesli jest gorszy przypadek oka/zdjecia to wtedy nam moze nie dzialac
% najpierw pomijamy niecentryczne zrenice - zakladamy ze teczowka i zrenica
% maja rowne centra - Cx=cx, Cy=cy

% jak rozwinac?

% wyniki do dokumentu... (też te złe)

function unwrappedIris = unwrapIris_uncentered(img_gray, irisCenter, irisRadius, pupilCenter, pupilRadius)
    % Define angular and radial resolution
    thetaSamples = 360;
    radialSamples = irisRadius - pupilRadius;

    % Preallocate the unwrapped iris image
    unwrappedIris = zeros(radialSamples, thetaSamples);

    % Polar to Cartesian transformation
    for i = 1:thetaSamples
        theta = (i / thetaSamples) * 2 * pi + (270/thetaSamples)*2*pi;
        for r = pupilRadius:irisRadius-1
            x = round(irisCenter(1) + r * cos(theta));
            y = round(irisCenter(2) + r * sin(theta));
            if x > 0 && x <= size(img_gray, 2) && y > 0 && y <= size(img_gray, 1)
                unwrappedIrisr(r - pupilRadius + 1, i) = img_gray(y, x, 1);
                unwrappedIrisg(r - pupilRadius + 1, i) = img_gray(y, x, 2);
                unwrappedIrisb(r - pupilRadius + 1, i) = img_gray(y, x, 3);
            end
        end
    end

    unwrappedIris(:,:,1) = unwrappedIrisr;
    unwrappedIris(:,:,2) = unwrappedIrisg;
    unwrappedIris(:,:,3) = unwrappedIrisb;

    % Display the result
    figure;
    imshow(uint8(unwrappedIris));
    title('Unwrapped Iris');
end