function processedImg = preprocessImage(img)
    processedImg = imresize(img, [480, 640]);
    processedImg = imgaussfilt(processedImg, 1);
end