% function TimingTestsuite()
% TimingTestsuite() loops over a mix of audio, visual, and audiovisual stimuli
%
% Use this script to benchmark the consistency of timing of a stimulus
% presentation PC

% log all output from matlab's console to a file
%-------------------------------------------------------------------------------
diary(sprintf('logfile_%s.log',datestr(now,30)));

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
    P = InitializePTB('Peter', 127,measuringWithPhotodiode);
    
    %% Visual only
    % non-time-sensitive stuff:
    %---------------------------------------------------------------------------
    % initialize task-parameters
    T = PrepTask_Visual(P);
        
    % time-sensitive stuff:
    %---------------------------------------------------------------------------
    % run "visual stimuli only"
    T = RunTask_Visual(T, P);
    
    % post-process (non-time-sensitive)
    %---------------------------------------------------------------------------
    t = PostTask_Visual(T, P.ifi);
    
    
    %% wind down again
    %---------------------------------------------------------------------------
    ClosePTB(P);
    
catch error
    ClosePTB();
    rethrow(error)
end

diary off

% end

