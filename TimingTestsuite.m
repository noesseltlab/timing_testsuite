% function TimingTestsuite()
% TimingTestsuite() loops over a mix of audio, visual, and audiovisual stimuli
%
% Use this script to benchmark the consistency of timing of a stimulus
% presentation PC

% log all output from matlab's console to a file
%-------------------------------------------------------------------------------
diary(sprintf('logfiles/logfile_%s.log',datestr(now,30)));

% minimal setup
%-------------------------------------------------------------------------------
ExpandPath();

% set seed to make randomization reproducible
rng(12345);

% if you want to measure the actual monitor speed (and not only the
% timestamps as provided by PTB), set the following variable to `true`.
% This will add to all flips a simple white/black oscillating rectangle in
% the upper left corner (to set the size of this one, go to
% InitializePTB()
measuringWithPhotodiode = true;


% Run Task(s)
%-------------------------------------------------------------------------------
try
    % initiliaze machine-related stuff
    %---------------------------------------------------------------------------
    P = PTB_Initialize('Peter', 127,measuringWithPhotodiode);

    %% Visual only
    % non-time-sensitive stuff:
    %---------------------------------------------------------------------------
    % initialize task-parameters
    T = Task_Visual_Prep(P);

    % time-sensitive stuff:
    %---------------------------------------------------------------------------
    % run "visual stimuli only"
    T = Task_Visual_Run(T, P);

    % post-process (non-time-sensitive)
    %---------------------------------------------------------------------------
    t = Task_Visual_Post(T, P.ifi);


    %% wind down again
    %---------------------------------------------------------------------------
    PTB_Close(P);

catch error
    PTB_Close(P);
    rethrow(error)
end

diary off

% end
