function irisCode = generateIrisCode(unwrappedIris, gaborFilterBank)
    [u, v] = size(gaborFilterBank);
    [m, n] = size(unwrappedIris);
    
    irisCode = zeros(m, n, u, v);
    
    for i = 1:u
        for j = 1:v
            filteredImage = imfilter(double(unwrappedIris), real(gaborFilterBank{i, j}), 'symmetric');
            irisCode(:, :, i, j) = filteredImage > 0; % Quantization
        end
    end
end
