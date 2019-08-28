function P = InitializePTB(computerName,colorBackground,measuringWithPhotodiode)
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
% SEE ALSO: ClosePTB

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

% One common naming scheme for all operating systems
KbName('UnifyKeyNames');

% Dummy Calls (make sure functions are loaded when they need to be)
GetSecs;
KbCheck;
KbQueueCreate; 
KbQueueCheck; 
KbQueueStop; 
KbQueueRelease;

% do NOT skip sync-tests
Screen('Preference', 'SkipSyncTests', 0);

%% handle machine specific stuff:
% first, set defaults (so that only machine which deviate need to specify
% those variables in the swich below)
P.windowRect = [0 0 P.screenResolution.width P.screenResolution.height];
P.viewingDistance = 40; % in cm
P.monitorWidth = 45; % in cm

switch computerName
    % use this to open a non-full screen window for easier debugging
    case 'debug'  
        P.windowRect = [0 0 1000 1000];
    
    case 'Peter' % Peter's Linux PC
        % use the right-most monitor
        P.windowRect = [1600+1680 0 1600+1680+1920 1200];
        P.viewingDistance = 40; % in cm
        P.monitorWidth = 45; % in cm
        
    otherwise
        fprintf('using default settings\n');
        fprintf(['WARNING: if specifying stimulus size/positions using' ...
            ' VisualAngleToPixel(..), the resulting values are essentially'
            'incorrect\n']);
        % use maximal window-size
        P.windowRect = [0 0 P.screenResolution.width P.screenResolution.height];
end

%% open PTB window
P.colorBackground = colorBackground;
[P.window,P.windowRect] = Screen('OpenWindow',...
    P.screenNumber, P.colorBackground, P.windowRect);

% store old priority
P.oldPriority = Priority(MaxPriority(P.window));

%% define parameters which depend on window being opened
% timing-related parameters
P.ifi = Screen('GetFlipInterval', P.window); % interFrameInterval
P.refreshRate        = Screen('FrameRate',P.window);
P.buffer             = .5; % as ratio of a frame

% create texture going to measure flips with photodiode
P.measuringWithPhotodiode = measuringWithPhotodiode; 
if measuringWithPhotodiode
   P.photodiodeRectangleSize = 100; % in px
   % define white rectangle
   P.texturePhotodiodeRectangle(1) = Screen('MakeTexture', P.window,...
       ones(P.photodiodeRectangleSize) * 255);
   
   % define black rectangle
   P.texturePhotodiodeRectangle(2) = Screen('MakeTexture', P.window,...
       zeros(P.photodiodeRectangleSize) );
   
   % define rectangle for faster drawing of the texture
   P.sourcePhotodiodeRectangle = ...
       [0 0 P.photodiodeRectangleSize P.photodiodeRectangleSize];
            
end


%% prepare window for drawing
HideCursor;

% jump to command window so that button presses do not affect your code
commandwindow

end