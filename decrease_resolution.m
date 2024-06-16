function [outImage] = decrease_resolution(inImage, resize_factor)

    outImage = imresize(inImage, resize_factor);
end