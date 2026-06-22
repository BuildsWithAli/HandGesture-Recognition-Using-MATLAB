function [gestureName, confidence, features, mask, maskedImg] = runPipeline(img)

    [mask, maskedImg] = segmentHand(img);
    features          = extractFeatures(mask);
    [gestureName, confidence] = classifyGesture(features);
end