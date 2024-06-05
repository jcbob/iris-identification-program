function unwrappedIris = new_unwrap_iris_2(img_gray, irisCenter, irisRadius, pupilCenter, pupilRadius, num)
    % Define fixed angular and radial resolution
    fixedThetaSamples = 360;
    fixedRadialSamples = 100;

    % Preallocate the unwrapped iris image
    unwrappedIris = zeros(fixedRadialSamples, fixedThetaSamples);

    % Distance between pupil center and iris center
    centerDistanceX = irisCenter(1) - pupilCenter(1);
    centerDistanceY = irisCenter(2) - pupilCenter(2);

    % Polar to Cartesian transformation with uncentered correction
    for i = 1:fixedThetaSamples
        theta = (i - 1) * 2 * pi / fixedThetaSamples + (270/fixedThetaSamples) * 2 * pi;
        cosTheta = cos(theta);
        sinTheta = sin(theta);
        for r = 1:fixedRadialSamples
            rNorm = r / fixedRadialSamples; % Normalized radius
            actualRadius = pupilRadius + rNorm * (irisRadius - pupilRadius);

            % Calculate the Cartesian coordinates
            x = round(pupilCenter(1) + actualRadius * cosTheta + rNorm * centerDistanceX);
            y = round(pupilCenter(2) + actualRadius * sinTheta + rNorm * centerDistanceY);

            % Ensure the coordinates are within the image boundaries
            if x > 0 && x <= size(img_gray, 2) && y > 0 && y <= size(img_gray, 1)
                unwrappedIris(r, i) = img_gray(y, x);
            end
        end
    end

    % Display the result
    figure;
    imshow(uint8(unwrappedIris));
    title(sprintf('%d - Unwrapped Iris', num));
end