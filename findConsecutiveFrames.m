function [startIndices, endIndices] = findConsecutiveFrames(logicalVector, numFrames)
    startIndices = find(diff([0, logicalVector, 0]) == 1);
    endIndices = find(diff([0, logicalVector, 0]) == -1) - 1;

    % Filter out consecutive frames with fewer than numFrames elements
    validIndices = (endIndices - startIndices + 1) >= numFrames;
    startIndices = startIndices(validIndices);
    endIndices = endIndices(validIndices);
end