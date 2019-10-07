function T = Task_AudioVisual_Prep(P, blockOrder)

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
T = struct();

% define trigger values
% Note: triggers for StimulusOFF will be " (trigger_ON + 1) " (e.g. ON:
% 100, OFF: 101)
% middle integer is 0 for 'expected early' block
T.triggerTargetShortDelayExpected     = 100;
T.triggerTargetLongDelayUnexpected    = 200;
% middle integer is 1 for 'expected late' block
T.triggerTargetShortDelayUnexpected   = 110;
T.triggerTargetLongDelayExpected      = 210;

T.triggerTrialStart                   =  10;
T.triggerReference                   =  11;
T.triggerBlockStart                   =  1;

T.referenceOffset = 0.3; % in seconds

% specify Cue-Target Structure
% target: visual, cue: audio
target_durations = 6;  % in frames, i.e. 100ms
% define short/long delay between cue-target
delayShort = 0.5; % in seconds
delayLong  = 1.5; % in seconds
T.nTrialsPerBlock = 50; % for each run of the above stimulus durations


% define how long participants have maximally to respond (will have 0.1s
% less, to be able to use that time to process the responses)
durationResponesWindow = 0.8; % in seconds
T.keyBoardProcessingTime = 0.1; % in seconds

% define blocks: `expected early` delays
nFew = ceil(T.nTrialsPerBlock * 0.25);

assert(nFew == 13, ...
    ['did you change the number of trials in a block?'...
    ' expected to split 50 into 13/37...']);

% generate sequence of trials
T.durationTarget = reshape(...
    ones(T.nTrialsPerBlock * 2 ,1) * target_durations, ...
    [],1);

delayExpectedEarly = [...
    ones(T.nTrialsPerBlock-nFew,1) * delayShort;...
    ones(nFew,1) * delayLong...
    ]; % in seconds

delayUnexpectedEarly = [...
    ones(nFew,1) * delayShort; ...
    ones(T.nTrialsPerBlock-nFew,1) * delayLong ...
    ]; % in seconds

T.delayCueTarget = [ delayExpectedEarly; delayUnexpectedEarly ];

% based on the above, define which trigger each trial target is associated
% with:
T.triggerTarget = [...
    ones(T.nTrialsPerBlock-nFew,1) * T.triggerTargetShortDelayExpected;...
    ones(nFew,1) * T.triggerTargetLongDelayUnexpected; ...
    ones(nFew,1) * T.triggerTargetShortDelayUnexpected; ...
    ones(T.nTrialsPerBlock-nFew,1) * T.triggerTargetLongDelayExpected;...
    ];


% define response window duration (units: frames)
T.durationResponseWindow = P.refreshRate * durationResponesWindow ...
    * ones(size(T.durationTarget));
% for all short-delay trials, add the 1s difference to the response window,
% so that both blocks are equally long
T.durationResponseWindow(T.delayCueTarget == delayShort) = ...
    T.durationResponseWindow(T.delayCueTarget == delayShort) + ...
    (delayLong-delayShort)*P.refreshRate; % need to convert to frames

% save nr of trials for for-loops
T.nTrials = length(T.durationTarget);

% generate associated ITIs
%% TODO: load predifined ITIs from file (based on efficiency optimization)
T.interTrialInterval = reshape(...
    GenerateITIs(...
        T.nTrialsPerBlock, ...
        2,...
        P.refreshRate ...
    ), ...
    [], 1);

%% Apply randomization based on block-order and within-block randomization
% start with Unexpected Early First (default: ExpectedEarly First)
if blockOrder ~= 1
    % first swap delays
    T.delayCueTarget = reshape([
        T.delayCueTarget((1+T.nTrialsPerBlock):(T.nTrialsPerBlock*2)) ...
        T.delayCueTarget(1:T.nTrialsPerBlock) ...
        ],[],1);
    % then swap associated triggers
    T.triggerTarget = reshape([
        T.triggerTarget((1+T.nTrialsPerBlock):(T.nTrialsPerBlock*2)) ...
        T.triggerTarget(1:T.nTrialsPerBlock)...
        ],[],1);

    % then swap the response windows (short trials have longer response
    % window to keep block equally long)
    T.durationResponseWindow = reshape([
        T.durationResponseWindow((1+T.nTrialsPerBlock):(T.nTrialsPerBlock*2)) ...
        T.durationResponseWindow(1:T.nTrialsPerBlock)...
        ],[],1);
end

%% TODO: load randomization
T.orderBlock1 = randperm(T.nTrialsPerBlock);
T.orderBlock2 = T.nTrialsPerBlock + randperm(T.nTrialsPerBlock);
T.delayCueTarget = T.delayCueTarget([T.orderBlock1 T.orderBlock2]);
T.triggerTarget = T.triggerTarget([T.orderBlock1 T.orderBlock2]);
T.durationResponseWindow = ...
    T.durationResponseWindow([T.orderBlock1 T.orderBlock2]);


%% Initialize timestamps
T.timestampFixationOn   = NaN(T.nTrials,1);
T.timestampCueOn        = NaN(T.nTrials,1);
T.timestampCueOff       = NaN(T.nTrials,1);
T.timestampTargetOn     = NaN(T.nTrials,1);
T.timestampTargetOff    = NaN(T.nTrials,1);
T.timestampReference    = NaN(T.nTrials,1);

T.whenFlipFixationOn    = NaN(T.nTrials,1);
T.whenFlipCueOn         = NaN(T.nTrials,1);
T.whenFlipCueOff        = NaN(T.nTrials,1);
T.whenFlipTargetOn      = NaN(T.nTrials,1);
T.whenFlipTargetOff     = NaN(T.nTrials,1);
T.whenFlipReference     = NaN(T.nTrials,1);
T.whenAudio             = NaN(T.nTrials,1);

T.whenKBStart           = NaN(T.nTrials,1);
T.whenKBEnd             = NaN(T.nTrials,1);
T.whenKBProcessStart    = NaN(T.nTrials,1);
T.whenKBProcessEnd      = NaN(T.nTrials,1);

T.missedFixationOn      = NaN(T.nTrials,1);
T.missedCueOn           = NaN(T.nTrials,1);
T.missedCueOff          = NaN(T.nTrials,1);
T.missedTargetOn        = NaN(T.nTrials,1);
T.missedTargetOff       = NaN(T.nTrials,1);
T.missedReference       = NaN(T.nTrials,1);


T.timestampButtons      = cell(T.nTrials,1);
T.whichButtons          = cell(T.nTrials,1);
T.RT                    = NaN(T.nTrials,1);


%% define fixation-point
visualOffsetY = P.verticalOffset;

% destination rectangle used by Scree('DrawTexture',..)
% center of the screen
fixationSize = 20;
xPos = P.windowRect(3)/2 - fixationSize/2;
yPos = P.windowRect(4)/2+visualOffsetY - fixationSize/2;
T.destinationFixation = [xPos yPos xPos+fixationSize/2 yPos+fixationSize/2];

% define rectangle

T.sourceFixation = [0 0 fixationSize fixationSize];
T.textureFixation = Screen('MakeTexture', P.window, 255*ones(fixationSize));

%% define visual stimulus
diameterCheckerboard = 400;
squareLength = 25;
visualAngle = 7;
checkerboard = GenerateCheckerboard(...
    diameterCheckerboard,...
    squareLength, ...
    true ,...
    P.colorBackground);
T.sourceStimutulus = [0 0 diameterCheckerboard diameterCheckerboard];
T.textureStimulus = Screen('MakeTexture', P.window, checkerboard);

% center horizontally
xPosition = P.windowRect(3)/2 - diameterCheckerboard/2;

% 5 degree offset from center vertically
yPosition = P.windowRect(4)/2 - ...
    diameterCheckerboard/2 - ...
    VisualAngleToPixel(...
        visualAngle,...
        P.viewingDistance,...
        P.monitorWidth, ...
        P.windowRect(3:4) ... % do this to center on non-fullscreen
    ) + visualOffsetY;

T.destinationStimulus = [...
    xPosition ...
    yPosition ...
    xPosition+diameterCheckerboard ...
    yPosition+diameterCheckerboard ...
    ];


%% define audio stimulus
T.audioStimulusDuration = 0.100; % in seconds

% auditory stimulus has a "wavelet" form:
if P.measuringWithPhotodiode
    audioFrequency = 1000; % in Hz -- main frequency
else
    audioFrequency = 8000; % in Hz -- main frequency
end
audioRampDuration    = .005; % in seconds
audioSamplingRate     = 44100;  % in Hz

signal = GenerateAudioWavelet(...
    audioFrequency,...
    T.audioStimulusDuration, ...
    audioRampDuration,...
    audioSamplingRate...
    );

T.audioNumberOfChannels = 2; % stereo
% replicate the signal for each channel -- channels == rows
T.audioStimulus = ones(T.audioNumberOfChannels, 1) * signal;


% prepare first cue sound in the audiobuffer. Note that playing the sound
% out of this buffer does not delete it, so we need to create only once
% (like a texture). Note 2: if you need more than one sound, create
% multiple buffers using PsychPortAudio('CreateBuffer',[..])
PsychPortAudio('FillBuffer', P.audio.audioHandle, T.audioStimulus);

end
