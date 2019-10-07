function KB = InputDevice_Initialize(computerName)

KB = struct();

% One common naming scheme for all operating systems
KbName('UnifyKeyNames');

% Dummy Calls (make sure functions are loaded when they need to be)
GetSecs;
KbCheck;
KbQueueCreate;
KbQueueStart;
KbQueueStop;
KbQueueCheck;
KbQueueRelease;

KB.DeviseExperimenter    = GetKeyboardIndices;


% The task can be "manually" started off after the instructions with this
% button
KB.keyStartBlock         = KbName('space');

% Button fMRI Trigger, used to start the stimulus sequence
KB.keyScannerTrigger     = KbName('t');

switch computerName
    case 'Prisma'
        KB.DeviseParticipant = GetKeyboardIndices;
        % These are the names of the left and the right button on the 2
        % button responsepad at prisma scanner
        KB.keyLeftButton    = KbName('1!');
        KB.keyRightButton   = KbName('2@');
        
    case 'EEGLabG24'
        % in this lab, we use the mouse as a "response box"
        KB.DeviseParticipant = GetMouseIndices;
        KB.DeviseParticipant = KB.DeviseParticipant(1);
        
        KB.keyLeftButton     = KbName('left_mouse');
        KB.keyRightButton    = KbName('right_mouse');
        
        
    case 'EEGLabG24-linux'
        % same as above, but we need to specify which mouse.
        targetDeviceName = 'Logitech M325';
        
        [deviceIndex, productName,~ ] = GetMouseIndices;
        KB.DeviceParticipant = deviceIndex(...
            ismember(productName, targetDeviceName)...
            );
        
        % use the following code to figure out which code you need here
        % [secs, code, d] = KbWait(deviceNumber); find(code)
        KB.keyLeftButton     = 1; % left mouse
        KB.keyRightButton    = 3; % right mouse
        
        
    case 'Peter'
        targetDeviceName = 'Logitech USB-PS/2 Optical Mouse';
        [deviceIndex, productName, ~] = GetMouseIndices;
        KB.DeviceParticipant = deviceIndex(...
            ismember(productName, targetDeviceName)...
            );
        
        % use the following code to figure out which code you need here
        % [secs, code, d] = KbWait(deviceNumber); find(code)
        KB.keyLeftButton     = 1; % left mouse
        KB.keyRightButton    = 3; % right mouse
        
    case 'debug'
        KB.DeviseParticipant = GetMouseIndices;
        KB.DeviseParticipant = KB.DeviseParticipant(1);
        
        % `left_mouse` is only available on windows, it seems
        if ismember('left_mouse',KbName('KeyNames'))
            KB.keyLeftButton     = KbName('left_mouse');
            KB.keyRightButton    = KbName('right_mouse');
        else
            % use the following code to figure out which code you need here
            % [secs, code, d] = KbWait(deviceNumber); find(code)
            KB.keyLeftButton     = 1; % left mouse
            KB.keyRightButton    = 3; % right mouse
        end
        
    otherwise
        KB.DeviseParticipant = GetKeyboardIndices;
        KB.keyLeftButton     = KbName('Left');
        KB.keyRightButton    = KbName('Right');
end
end
