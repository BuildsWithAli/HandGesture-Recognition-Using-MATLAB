function [mask, maskedImg] = segmentHand(img)
    ycbcr = rgb2ycbcr(img);
    Cb = double(ycbcr(:,:,2));
    Cr = double(ycbcr(:,:,3));
    maskYCbCr = (Cb >= 77 & Cb <= 127) & (Cr >= 133 & Cr <= 173);

    hsv = rgb2hsv(img);
    H = hsv(:,:,1); S = hsv(:,:,2); V = hsv(:,:,3);
    maskHSV = ((H < 0.10) | (H > 0.90)) & (S > 0.10) & (S < 0.85) & (V > 0.25);

    combined = maskYCbCr | maskHSV;
    combined = bwareaopen(combined, 600);
    se1 = strel('disk', 4);
    se2 = strel('disk', 8);
    combined = imclose(combined, se2);
    combined = imopen(combined, se1);
    combined = imfill(combined, 'holes');

    CC = bwconncomp(combined);
    if CC.NumObjects == 0
        mask = combined; maskedImg = img; return;
    end
    numPixels = cellfun(@numel, CC.PixelIdxList);
    [~, largest] = max(numPixels);
    finalMask = false(size(combined));
    finalMask(CC.PixelIdxList{largest}) = true;
    mask = finalMask;
    maskedImg = bsxfun(@times, img, cast(mask, 'like', img));
end