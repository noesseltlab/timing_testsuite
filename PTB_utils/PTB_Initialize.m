function P = PTB_Initialize(computerName,colorBackground,measuringWithPhotodiode)
% InitializePTB(computerName) initiliazes psychtoolbox and opens a window
%
% Input:
%   computerName        ... String. Provides info on which computer is
%                       being used. Valid options include: 'linux', 'default'
%   colorBackground     ... color. [either a scalar between 0 and 255,
%                       or [r g b] triplet or [r g b a] quadruple) to be
%                       used for the background of the new window. default
%                       is white [255];
%
%   measuringWithPhotodiode ... Boolean. Indicates whether (audio)visual
%                       task should include a rectangle in the upper-left
%                       corner which oscillates between black & white for
%                       each Flip. Place there a photodiode to measure when
%                       exactly flips are actually happen on the monitor.
%                       Note: Specify `rectanglePhotodiodeSize` in the code
%                       below to set a smaller/larger stimulus.
%
% Output:
%   P                   ... struct. Contains PTB parameters which are
%                       necessary to run PTB tasks
%
% SEE ALSO: PTB_Close

%% initialize variables & set defaults
P = struct();

if ~exist('colorBackground','var')
    colorBackground = 127;
end

%% handle machine-independent stuff:

% stop all echo-ing
echo off all

% prepare monitor-related parameters
P.availableScreens      = Screen('Screens');
P.screenNumber          = max(P.availableScreens);
P.screenResolution      = Screen('Resolution', P.screenNumber);

% do NOT skip sync-tests
Screen('Preference', 'SkipSyncTests', 0);

%% handle machine specific stuff:
% first, set defaults (so that only machine which deviate need to specify
% those variables in the swich below)
P.windowRect = [0 0 P.screenResolution.width P.screenResolution.height];
P.viewingDistance = 40; % in cm
P.monitorWidth = 45; % in cm
P.verticalOffset = 0;

switch computerName
    % use this to open a non-full screen window for easier debugging
    case 'debug'
        P.windowRect = [0 0 400 400];

    case 'Prisma'
        P.viewingDistance = 35; % in cm
        P.monitorWidth = 30.2; % in cm

    case 'EEGLabG24'
        P.viewingDistance = 103; % in cm
        P.monitorWidth = 40.5; % in cm
        % buy how much to shift the vertical offset from the top downards
        P.verticalOffset = 100; % in px

    case 'EEGLabG24-linux'
        P.viewingDistance = 103; % in cm
        P.monitorWidth = 40.5; % in cm
        % buy how much to shift the vertical offset from the top downards
        P.verticalOffset = 250; % in px

    case 'Peter' % Peter's Linux PC
        % Monitor-related parameters
        P.windowRect = [1600+1680 0 1600+1680+1920 1200];
        P.viewingDistance = 100; % in cm
        P.monitorWidth = 45; % in cm

    otherwise
        fprintf('using default settings\n');
        fprintf(['WARNING: if specifying stimulus size/positions using' ...
            ' VisualAngleToPixel(..), the resulting values are essentially' ...
            'incorrect\n']);
        % use maximal window-size
        P.windowRect = [0 0 P.screenResolution.width P.screenResolution.height];
end

%% open PTB window
P.colorBackground = colorBackground;
[P.window,P.windowRect] = Screen('OpenWindow',...
    P.screenNumber, P.colorBackground, P.windowRect);

% store old priority
% Uncomment this to use maximal priority
% P.oldPriority = Priority(MaxPriority(P.window));

% enable flip logging
Screen('GetFlipInfo',P.window,1)

%% define parameters which depend on window being opened
% timing-related parameters
% [P.ifi, P.ifiSamepls,P.ifiSD] = Screen('GetFlipInterval', P.window, 300,0.00002 ); % interFrameInterval
P.ifi                 = Screen('GetFlipInterval', P.window);
P.refreshRate         = Screen('FrameRate',P.window);
% for each flip, use the following buffer
P.buffer              = .5; % as ratio of a frame

% create texture for measuring flips with photodiode
P.measuringWithPhotodiode = measuringWithPhotodiode;
if measuringWithPhotodiode
    % define rectangle for faster drawing of the texture
    P.sourcePhotodiodeRectangle = P.windowRect;
    % define white rectangle
    P.texturePhotodiodeRectangle(1) = Screen('MakeTexture', P.window,...
        ones( P.sourcePhotodiodeRectangle(3),...
        P.sourcePhotodiodeRectangle(4)) ...
        * 255);

    % define black rectangle
    P.texturePhotodiodeRectangle(2) = Screen('MakeTexture', P.window,...
        ones( P.sourcePhotodiodeRectangle(3),...
        P.sourcePhotodiodeRectangle(4)) * 127 );
end

%% prepare window for drawing
HideCursor;
% set mouse coordinates to upper left corner -- make sure there is no
% button to be clicked there...
SetMouse(0,0, P.window);

% jump to command window so that button presses do not affect your code
commandwindow

%% initialize parallel port
% initialize access to the inpoutx64 low-level I/O driver
P.io = ParallelPort_Initialize(computerName);

% will be sent whenever instructions are shown
P.triggerInstructions = 250;

%% Initialize key settings
P.kb = InputDevice_Initialize(computerName);

%% Initialize Sound Card
P.audio = Audio_Initialize(computerName);

end
