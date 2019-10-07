function audio = Audio_Initialize(computerName)

audio = struct();

%% define basic settings
% define sampling rate and nr of channel
audio.audioSamplingRate = 44100;
audio.numberOfChannels = 2;

% set the audio-delay we can use to sync up audio and video stimulus
% presentation - measure this for each new OS/hardware combination using
% external recording devices (photodiode & microphone)
switch computerName
    case 'Prisma'
        audio.AudioDelay = .085;
    case 'EEGLabG24'
        audio.AudioDelay = 0.003;
    case 'EEGLabG24-linux'
        audio.AudioDelay = 0;
    otherwise
        audio.AudioDelay = 0;
end
    

%% Initialize audio 
InitializePsychSound(1);

% assert that we start "fresh" by close previously opened devices first
count = PsychPortAudio('GetOpenDeviceCount');
if count >= 1
    % close first - hopefully this does the trick
    PsychPortAudio('Close');
end

%% Pick appropriate audio device
audio.audioDevices = PsychPortAudio('GetDevices');
switch computerName
    case 'EEGLabG24-linux'
        targetDevice = 'Creative X-Fi: Front/WaveIn';
        
        indexTargetDevice = find(cellfun(...
            @(x) any(strfind(x,targetDevice)), ...
            {audio.audioDevices.DeviceName}));
        
        assert(~isempty(indexTargetDevice), ...
            'soundcard not found -- did the numbers change again?');
        assert(length(indexTargetDevice) == 1,...
            'more than one soundcard found -- did the numbers change again?');
        
        % audioDevice indices start counting with 0, but find starts off
        % with 1.. 
        audioDeviceIndex = indexTargetDevice - 1;
        
    otherwise
        % use default audioDevice for all other machines
        audioDeviceIndex = [];
end

%% Open actual connection
% open handle to audioDevice
audio.audioHandle = PsychPortAudio('Open', audioDeviceIndex,[], 1,...
    audio.audioSamplingRate, audio.numberOfChannels);

% get status struct from PTB
audio.audioStatus = PsychPortAudio('GetStatus', audio.audioHandle);

end