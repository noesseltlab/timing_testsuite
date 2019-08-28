function t = PostTask_Visual(T,ifi)
% PostTask_Visual(T) postprocess task-specific T-struct.
% 
% E.g.: store to BIDS-compatible format on disk
% 
% 


% Convert timestamps, stimulus durations, etc. into .tsv file
t = table();

t.timestampFixationOn = T.timestampFixationOn;
t.intendedDurationFixationInFrames = T.interTrialInterval;
t.intendedDurationFixation = T.interTrialInterval * ifi;
% compute actual presentation duration
t.durationFixation = T.timestampStimulusOn - T.timestampFixationOn;
t.missedFixation = T.missedFixationOn > 0;

t.timestampStimulusOn = T.timestampStimulusOn;
t.intendedDurationStimulusInFrames = T.durationStimulus;
t.intendedDurationStimulus = T.durationStimulus * ifi;
% calculate actual presentationDuration
t.durationStimulus = ...
    [T.timestampFixationOn(2:end);T.lastStimulusOff] - T.timestampStimulusOn ;
t.missedStimulus = T.missedStimulusOn > 0;



filenameBase = 'task_visual';



writetable(t,...
    sprintf('%s_%s.tsv',filenameBase,datestr(now,30)),...
    'Filetype','text',...
    'WriteVariableNames', true, ...
    'Delimiter', '\t',...
    'QuoteStrings', true, ...
    'Encoding','UTF-8' ...
    );



end