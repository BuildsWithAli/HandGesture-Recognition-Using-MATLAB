function features = extractFeatures(mask)

    features.fingerCount = 0;
    features.area        = 0;
    features.perimeter   = 0;
    features.solidity    = 0;
    features.centroid    = [0 0];
    features.boundingBox = [0 0 1 1];
    features.aspectRatio = 1;

    if sum(mask(:)) < 300, return; end

    props = regionprops(mask, 'Area','Perimeter','Solidity',...
                              'Centroid','BoundingBox','ConvexArea');
    if isempty(props), return; end

    [~, idx] = max([props.Area]);
    p = props(idx);

    features.area        = p.Area;
    features.perimeter   = p.Perimeter;
    features.solidity    = p.Solidity;
    features.centroid    = p.Centroid;
    features.boundingBox = p.BoundingBox;
    features.aspectRatio = p.BoundingBox(4) / max(1, p.BoundingBox(3));
    fillRatio            = features.area / max(1, p.ConvexArea);

   
    isFist = (features.solidity > 0.82) || ...
             (features.aspectRatio < 0.95 && fillRatio > 0.82);
    if isFist
        features.fingerCount = 0; return;
    end

    [~, numCols] = size(mask);
    topProfile   = zeros(1, numCols);
    for c = 1:numCols
        whiteRows = find(mask(:, c));
        if ~isempty(whiteRows)
            topProfile(c) = whiteRows(1);
        end
    end

    activeCol  = topProfile > 0;
    profileVec = topProfile(activeCol);
    if length(profileVec) < 20
        features.fingerCount = 1; return;
    end

    handH = features.boundingBox(4);
    handW = features.boundingBox(3);


    smoothWin     = max(3, round(length(profileVec) * 0.015));
    profileSmooth = smoothdata(profileVec, 'movmean', smoothWin);
    profileInv    = -profileSmooth;
    minDist       = max(4, round(0.02 * handW));
    minProm       = max(2, round(0.01 * handH));

    [~, locs, ~, proms] = findpeaks(profileInv, ...
        'MinPeakDistance', minDist, ...
        'MinPeakProminence', minProm);

    if isempty(locs)
        nPeaks = 0;
    else
        topCutoff       = features.boundingBox(2) + 0.80 * handH;
        minPromVal      = max(2, 0.012 * handH);
        inTopRegion     = profileVec(locs) < topCutoff;
        prominentEnough = proms > minPromVal;
        nPeaks          = sum(inTopRegion & prominentEnough);
    end

    if nPeaks <= 1
        if features.aspectRatio < 1.15 && fillRatio < 0.74
            fc = 5;
        elseif features.aspectRatio > 1.80
            fc = 1;
        elseif features.aspectRatio > 1.10 && fillRatio > 0.72
            fc = 2;
        else
            fc = 1;
        end

    elseif nPeaks == 2
        if fillRatio > 0.78
            fc = 1;
        elseif features.aspectRatio > 1.27 && fillRatio > 0.74
            fc = 3;
        else
            fc = 2;
        end

    elseif nPeaks == 3
         
        if features.aspectRatio >= 1.15 && features.aspectRatio < 1.27
            fc = 2;
        else
            fc = 3;
        end

    elseif nPeaks == 4
       
        fc = 4;

    else
        fc = 5;
    end

    features.fingerCount = fc;
end