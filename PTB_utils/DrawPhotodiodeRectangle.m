function i = DrawPhotodiodeRectangle(P,i)
% i = DrawPhotodiodeRectangle(P,i) draws a P.texturePhotodiodeRectangle texture
%
% The variable i  get incremented, so that it can be used to cycle through the
% textures stored in the array P.texturePhotodiodeRectangle.


if P.measuringWithPhotodiode
    iTexture = 1 + mod(i, length(P.texturePhotodiodeRectangle));

    Screen('DrawTexture', P.window, ...
        P.texturePhotodiodeRectangle(iTexture), ...
        P.sourcePhotodiodeRectangle,...
        P.sourcePhotodiodeRectangle);

    i = iTexture;
end

end
