function [gestureName, confidence] = classifyGesture(features)

    gestureName = 'Unknown';
    confidence  = 'Low';

    if features.area < 300
        gestureName = 'No hand detected';
        return;
    end

    switch features.fingerCount
        case 0
            gestureName = 'Fist';
            confidence  = 'High';
        case 1
            gestureName = 'One finger (point)';
            if features.solidity > 0.75
                confidence = 'High';
            else
                confidence = 'Medium';
            end
        case 2
            gestureName = 'Two fingers (peace)';
            confidence  = 'High';
        case 3
            gestureName = 'Three fingers';
            confidence  = 'High';
        case 4
            gestureName = 'Four fingers';
            confidence  = 'High';
        case 5
            gestureName = 'Open hand (five)';
            confidence  = 'High';
        otherwise
            gestureName = sprintf('%d fingers', features.fingerCount);
            confidence  = 'Medium';
    end
end