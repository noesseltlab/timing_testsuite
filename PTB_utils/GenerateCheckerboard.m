function y = GenerateCheckerboard(diameter, squareLength , isCircle, backgroundColor)
% GenerateCheckerboard(diameter, squareLength , isCircle, backgroundColor)
% returns a matrix representing a black & white checkerboard stimulus.
%
% Input:
%   diameter            ... integer. Diameter in pixels of desired
%                       checkerboard stimulus (if isCircle is true) or the
%                       edge length in pixel of square (if isCircle is
%                       false)
%
%   squareLength        ... integer. how large a single square of on the
%                       checkerboard should be. `diameter` must be a
%                       multiple of squareLength (e.g. diameter = 400,
%                       squareLength = 40)
%
%   isCircle            ... Boolean. if true, the stimulus will be a circle
%                       if false, output will be a square
%
%   backgroundColor     ... a PTB color (scalar, triplet [rbg], or
%                       quadruplet [rbga]) which will be used a background
%                       color
%
%


% define colors of checkerboard
colorWhite = 255;
colorBlack = 0;

% checkerboard pattern
assert(mod(diameter,squareLength) == 0, ...
    ['diameter (%i) must be a multiple of squareLength (%i)' ...
    ' (e.g. diameter = 400, squareLength = 40)'], ...
    diameter, squareLength)

% initialize stimulus with a checkerboard pattern of whole rectangle
% start off with white in upper-left corner
y = ones(diameter) * colorWhite;
for iCol = 1:(diameter/(squareLength*2))
    for iRow= 1:(diameter/(squareLength*2))
        % i == 0 corresponds to odd, i == 1 corresponds to even columns
        for i = 0:1 
            offsetCol = (iCol-1)*squareLength*2 + squareLength*i;
            offsetRow = (iRow-1)*squareLength*2 + squareLength*i;
            
            indicesCol = (1+offsetCol):(squareLength+offsetCol);
            indicesRow = (1+offsetRow):(squareLength+offsetRow);            
            y(indicesCol ,indicesRow) = colorBlack;
        end
    end
end



if isCircle
    % define distances from center
    distX = ones(diameter,1) * ((1:diameter)-diameter/2); 
    distY = distX';
    
    indicesOutsideCircle = sqrt(distX.^2 + distY.^2) > (diameter/2);
    
    y(indicesOutsideCircle) = backgroundColor;
end


end
