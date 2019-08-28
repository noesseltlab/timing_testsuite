function ClosePTB(P)
% ClosePTB() close all relevant PsychToolbox window.
% 
% This is the complement of InitilializePTB() and closes all relevant
% windows, etc.
% 
% SEE ALSO: InitializePTB
% 

%% set defaults
if ~exist('P','var')
    P = struct();
    P.oldPriority = 0;
end


%% close stuff
% reset priority to old value
Priority(P.oldPriority);

ShowCursor;

sca;

PsychPortAudio('CloseAll');

end