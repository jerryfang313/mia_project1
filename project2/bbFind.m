function [ leftbb, rightbb ] = bbFincd( newInputImage )
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
[newShrunk, newLostRows, newLostCols, newLostLays] = shrinkImage(newInputImage, shrinkFactor);

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
        besttr = tr;
        besttc = tc;
        besttl = tl;
    end
end

[scale, tr, tc, tl, SSD] = register(newInputImage, origBrains{bestIter});
minLeft = [];
maxLeft = [];
minRight = [];
maxRight = [];
end

