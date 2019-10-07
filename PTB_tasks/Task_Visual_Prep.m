function T = PrepTask_Visual(P)
% PrepTask_Visual(P) prepares task parameters based on PTB-parameters
%
% Input:
%   P           ... struct. PTB-Parameters as return by InitializePTB(..)
%
% Output:
%   T           ... struct. Task-parametes, which will be used by
%               RunTask_Visual(..)
%
% Note that all tasks use timing specs in number-of-frames, instead of
% seconds. As a good practice, specify the variable 'expectedRefreshRate'
% and let the code assert that
%
% SEE ALSO: RunTask_Visual, InitializePTB
%
%

T = struct();

%% Assert whether expected frame-rate matches roughly the actual one
expectedRefreshRate = 60;
toleranceRefreshRate = 0.05;
assert(...
    (abs(expectedRefreshRate-P.refreshRate)/expectedRefreshRate) ...
    <= toleranceRefreshRate, ...
    ['actual refresh deviates more than %g from the expected one.' ...
    ' Check whether stimulus durations make sense!'],...
    toleranceRefreshRate...
    );

%% specify trials
% Given that we asserted the frame rate is as expected, we can now specify
% all visual stimuli durations in nr of frames

% specify stimulus durations
stimulus_durations = [1,3,6,30,120];  % in frames!
nTrialsPerStimulus = 50;

% generate sequence of trials
T.durationStimulus = reshape(...
    ones(nTrialsPerStimulus,1) * stimulus_durations, ...
    [],1);

% generate associated ITIs
T.interTrialInterval = reshape(...
    GenerateITIs(...
        nTrialsPerStimulus, ...
        length(stimulus_durations),...
        P.refreshRate ...
    ), ...
    [], 1);

% save nr of trials for for-loops 
T.nTrials = length(T.durationStimulus); 


%% Initialize timestamps
T.timestampFixationOn = NaN(T.nTrials,1);
T.timestampStimulusOn = NaN(T.nTrials,1);
T.missedFixationOn = NaN(T.nTrials,1);
T.missedStimulusOn = NaN(T.nTrials,1);

%% define fixation-cross 
% destination rectangle used by Scree('DrawTexture',..)
T.destinationFixation = [0 0 P.windowRect(3)/2 P.windowRect(4)/2];

% define rectangle
fixationSize = 10; 
T.sourceFixation = [0 0 fixationSize fixationSize ];
T.textureFixation = Screen('MakeTexture', P.window, ones(fixationSize ));

%% define stimulus
diameterCheckerboard = 400;
squareLength = 25;
checkerboard = GenerateCheckerboard(...
    diameterCheckerboard,...
    squareLength, ...
    true ,...
    P.colorBackground);
T.sourceStimutulus = [0 0 diameterCheckerboard diameterCheckerboard];
T.textureStimulus = Screen('MakeTexture', P.window, checkerboard);

% center horizontally
xPosition = P.windowRect(1) - diameterCheckerboard/2;

% 5 degree offset from center vertically
yPosition = P.windowRect(3)/2 - ...
    diameterCheckerboard/2 - ... 
    VisualAngleToPixel(...
        5,...
        P.viewingDistance,...
        P.monitorWidth, ...
        P.windowRect(3:4) ... % do this to center on non-fullscreen
    );

T.destinationStimulus = [0 0 xPosition yPosition];




end

