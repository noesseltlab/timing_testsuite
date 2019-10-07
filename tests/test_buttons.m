function test_buttons(computerName, durationListening)
% test Responses_Initialize(..) by running it and listening for buttons for
% 5 secs (default)



%% Set defaults
if ~exist('computerName','var')
    computerName = 'EEGLabG24-linux';
end

if ~exist('durationListening','var')
    durationListening = 5; % in seconds
end


%% Initialize
kb = Responses_Initialize(computerName);

deviceNumber = kb.DeviceParticipant;

%% Listen for response using KBQueue
KbQueueCreate(deviceNumber)
fprintf('Queue created \n');
KbQueueStart(deviceNumber)
fprintf('Queue started \n');
tStart = GetSecs;

fprintf('Waiting for button presses \n');
WaitSecs(durationListening);


KbQueueStop(deviceNumber)
fprintf('Queue stopped\n');

%% collect button presses & print info
[pressed, firstPress, firstRelease, lastPress, lastRelease] =...
    KbQueueCheck(deviceNumber);

if pressed
    RT_first  = firstPress(firstPress > 0 ) - tStart;
    code_first = find(firstPress(firstPress > 0 ));
    
    RT_last = lastPress(lastPress > 0 ) - tStart;
    code_last = find(lastPress(lastPress > 0 ));
    
    for i = 1:length(code_first)
    fprintf('RT of first Press (code %i): %g\n',...
         code_first(i), RT_first(i));
    end
    
    for i = 1:length(code_last)
       fprintf('RT of last Press (code %i): %g\n', ...
        code_last(i), RT_last(i)); 
    end
end



end