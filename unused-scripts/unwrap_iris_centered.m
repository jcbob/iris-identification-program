function unwrappedIris = unwrap_iris_centered(img, irisCenter, irisRadius, pupilCenter, pupilRadius)
    % Define angular and radial resolution
    thetaSamples = 360;
    radialSamples = irisRadius - pupilRadius;

    unwrappedIris = zeros(radialSamples, thetaSamples);

    for i = 1:thetaSamples
        theta = (i / thetaSamples) * 2 * pi + (270/thetaSamples)*2*pi;
        for r = pupilRadius:irisRadius-1
            x = round(irisCenter(1) + r * cos(theta));
            y = round(irisCenter(2) + r * sin(theta));
            if x > 0 && x <= size(img, 2) && y > 0 && y <= size(img, 1)
                unwrappedIrisr(r - pupilRadius + 1, i) = img(y, x, 1);
                unwrappedIrisg(r - pupilRadius + 1, i) = img(y, x, 2);
                unwrappedIrisb(r - pupilRadius + 1, i) = img(y, x, 3);
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