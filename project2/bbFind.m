function [ leftbb, rightbb ] = bbFind( newInputImage )
load atlas 
load brain1mat 
load brain2mat 
load brain3mat 
load brain4mat 
load brain5mat 
load brain6mat

newInputImage(newInputImage < 0) = 0;
vals = reshape(newInputImage, [], 1, 1);
cap = prctile(vals, 99);
newInputImage(newInputImage > cap) = cap;
[newShrunk, ~, ~, ~] = shrinkImage(newInputImage, shrinkFactor);

leftbb = zeros(size(newInputImage));
rightbb = zeros(size(newInputImage));
origBrains = {brain1; brain2; brain3; brain4; brain5; brain6};
clear brain1 brain2 brain3 brain4 brain5 brain6

bestSSD = realmax;
bestIter = 0;

for iter = 1:numBrains
    scale = 1;
    tr = 0;
    tc = 0;
    tl = 0;
    
    [scale, tr, tc, tl, SSD] = register(newShrunk, shrunkBrains{iter}, scale, tr, tc, tl);
    if (SSD < bestSSD)
        bestIter = iter;
        bestSSD = SSD;
        bestscale = scale;
        besttr = tr * shrinkFactor;
        besttc = tc * shrinkFactor;
        besttl = tl * shrinkFactor;
    end
end

[scale, tr, tc, tl, ~] = register(newInputImage, origBrains{bestIter}, bestscale, besttr, besttc, besttl);

minLeft = [leftMinRCL(bestIter,:) - [tr tc tl]] / scale;
maxLeft = [leftMaxRCL(bestIter,:) - [tr tc tl]] / scale;
minRight = [rightMinRCL(bestIter,:) - [tr tc tl]] / scale;
maxRight = [rightMaxRCL(bestIter,:) - [tr tc tl]] / scale;

leftbb(minLeft(1):maxLeft(1), minLeft(2):maxLeft(2), minLeft(3):maxLeft(3)) = 1;
rightbb(minRight(1):maxRight(1), minRight(2):maxRight(2), minRight(3):maxRight(3)) = 1;
end

