function visualizeIrisCode(irisCode)
    [m, n, u, v] = size(irisCode);
    combinedIrisCode = zeros(m * u, n * v);
    
    for i = 1:u
        for j = 1:v
            combinedIrisCode((i-1)*m + 1:i*m, (j-1)*n + 1:j*n) = irisCode(:, :, i, j);
        end
    end
    
    figure;
    imshow(combinedIrisCode);
    title('Encoded Iris Visualization');
end
