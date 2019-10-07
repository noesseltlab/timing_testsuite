function PTB_Close(P)
% ClosePTB() close all relevant PsychToolbox window.
%
% This is the complement of InitilializePTB() and closes all relevant
% windows, etc.
%
% SEE ALSO: InitializePTB
%


%% close stuff

%% set defaults
if ~exist('P','var')
    P = struct();
end


% reset priority to old value
if isfield(P,'oldPriority')
    Priority(P.oldPriority);
end

ShowCursor;

sca;

% release audio-device again
PsychPortAudio('Close');

% uninstall parallel port driver
if isfield(P,'io')
    P.io.Close();
end


clear P.io;

end
