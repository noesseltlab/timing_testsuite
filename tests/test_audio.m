function test_audio(computerName)
% test Audio_Initialize() by running it and trying to play audio file


if ~exist('computerName','var')
    computerName = 'EEGLabG24-linux';
end

%% Run custom initialization
audio = Audio_Initialize(computerName);


%% play demo sound
% assign this as default sound file: Better than ol' handel - we're
    % sick of that sound.
    wavfilename = [ PsychtoolboxRoot 'PsychDemos' filesep 'SoundFiles' filesep 'funk.wav'];
% Read WAV file from filesystem:
[y, freq] = psychwavread(wavfilename);
wavedata = y';
 
% assert(audio.audioSamplingRate == freq,...
%     'freq: %g\nsamping rate: %g\n',freq,audio.audioSamplingRate);



% Make sure we have always 2 channels stereo output.
% Why? Because some low-end and embedded soundcards
% only support 2 channels, not 1 channel, and we want
% to be robust in our demos.
if  size(wavedata,1) < 2
    wavedata = [wavedata ; wavedata];
end


% Number of rows == number of channels.
assert(size(wavedata,1) == audio.numberOfChannels, ...
    'size(wave,1): %g\nnrOfChannels: %g\n',...
    size(wavedata,1),audio.numberOfChannels);


% write data into audio buffer
PsychPortAudio('FillBuffer', audio.audioHandle,wavedata);

% Start audio playback for 'repetitions' repetitions of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.
repetitions = 0
t1 = PsychPortAudio('Start', audio.audioHandle, repetitions, 0, 1);

lastSample = 0;
lastTime = t1;


% Stay in a little loop until keypress:
while ~KbCheck
    % Wait a seconds...
    WaitSecs(1);

    % Query current playback status and print it to the Matlab window:
    s = PsychPortAudio('GetStatus', audio.audioHandle);
    % tHost = GetSecs;

    % Print it:
    fprintf('\n\nAudio playback started, press any key for about 1 second to quit.\n');
    fprintf('This is some status output of PsychPortAudio:\n');
    disp(s);

    realSampleRate = (s.ElapsedOutSamples - lastSample) / (s.CurrentStreamTime - lastTime);
    fprintf('Measured average samplerate Hz: %f\n', realSampleRate);

    tHost = s.CurrentStreamTime;
    clockDelta = (s.ElapsedOutSamples / s.SampleRate) - (tHost - t1);
    clockRatio = (s.ElapsedOutSamples / s.SampleRate) / (tHost - t1);
    fprintf('Delta between audio hw clock and host clock: %f msecs. Ratio %f.\n', 1000 * clockDelta, clockRatio);
end

% Stop playback:
PsychPortAudio('Stop', audio.audioHandle);

%% Close using custom function
Audio_Close();

end