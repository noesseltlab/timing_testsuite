function timestamps = WaitForScanner(nVolsToWait,keyScannerTrigger, window)

timestamps = NaN(nVolsToWait+1,1);
nVols = 0;

text = 'Waiting for scanner\n\n';

while nVols<=nVolsToWait          % Loop as long as volumes should be skipped (Usually 3 Volumes)
    DrawFormattedText(window, [ text num2str(nVolsToWait-nVols) '\n'],...
        'center','center', 255);  % use white 
    [timestamps(nVols+1),~] = Screen('Flip', window);        
    
    % listen keyboard for trigger
    keyCode = zeros(1,256);
    while ~keyCode(keyScannerTrigger)
        keyCode = zeros(1,256);
        [~, ~, keyCode] = KbCheck;
        WaitSecs(0.001);
    end
    
    nVols=nVols+1;                         
    % avoid looping too quickly,i.e. before the button gets released
    % Note: Should you be using a sequence with a TR of 1sec or below, you
    % will need to alter this code... 
    WaitSecs(0.2); 
end

% flip to empty screen
[timestamps(nVols+1),~] = Screen('Flip', window);

end