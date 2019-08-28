function i = DrawPhotodiodeRectangle(P,i)

if P.measuringWithPhotodiode
    Screen('DrawTexture', P.window, ...
        P.texturePhotodiodeRectangle(i+1), ...
        P.sourcePhotodiodeRectangle,...
        P.sourcePhotodiodeRectangle); 
    
    % makes i oscillate between 0 and 1
    i = mod(i+1,2);
end

end


