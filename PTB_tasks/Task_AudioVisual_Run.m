function T = Task_AudioVisual_Run(T,P,trialRange)
% CueTarget_RunTask(P) runs a simple Visual task
%
% Note: assumes PTB has been initialized via InitializePTB()
%
% Input:
%   T           ... struct. Contains task-specific parameters. can be
%               obained from using PrepTask_AudioVisual().
%
%   P           ... struct. Contains Parameters of the current PTB session,
%               as returned by InitializePTB()
%
% Output:
%   T           ... struct. Same as the input, but includes the actual
%               timestamps from the run
%
% SEE ALSO: InitializePTB, PrepTask_AudioVisual

% send recorind trigger for start of Task
P.io.SendTrigger(T.triggerBlockStart);

assert(all(ismember(trialRange, 1:T.nTrials)), ...
    ['requested trial range (min=%i, max=%i) is ' ...
    ' outside of possible range (1 to %i)'], ...
    min(trialRange), max(trialRange), T.nTrials);

for iTrial = trialRange
    %---------------------------------------------------------------------------
    % Fixation point
    %---------------------------------------------------------------------------
    % start with iti
    % draw fixation point - not specifying which part of texture draws
    % everything, and not specify where to draw it, draws it at the center
    Screen('DrawTexture',P.window, T.textureFixation, T.sourceFixation, ...
        T.destinationFixation);

    % draw black rectangle
    DrawPhotodiodeRectangle(P,2);

    % done drawing
    %     Screen('DrawingFinished', P.window);

    % calcuate when to flip
    if iTrial == trialRange(1)
        whenFlip = []; % flip asap
    else
        whenFlip = T.timestampTargetOff(iTrial-1) + ...
            (T.durationResponseWindow(iTrial-1)-P.buffer)*P.ifi;
        T.whenFlipFixationOn(iTrial) = whenFlip;
    end

    % perform flip -- note that this "freezes" Matlab code-execution till
    % the flip has happend.
    P.io.SendTrigger(128);
    [T.timestampFixationOn(iTrial), ~, ~ , T.missedFixationOn(iTrial), ~] = ...
        Screen('Flip', P.window, whenFlip);
    % send recorind trigger for start of fixation
    P.io.SendTrigger(T.triggerTrialStart);

    %---------------------------------------------------------------------------
    % Reference screen - 300ms before end of ITI
    %---------------------------------------------------------------------------
    % draw fixation point - not specifying which part of texture draws
    % everything, and not specify where to draw it, draws it at the center
    Screen('DrawTexture',P.window, T.textureFixation, T.sourceFixation, ...
        T.destinationFixation);

    % draw black rectangle
    DrawPhotodiodeRectangle(P,2);

    % done drawing
    %     Screen('DrawingFinished', P.window);

    whenFlip = T.timestampFixationOn(iTrial) ...
        + (T.interTrialInterval(iTrial)-P.buffer)*P.ifi ...
        - T.referenceOffset;
    T.whenFlipReference(iTrial) = whenFlip;

    P.io.SendTrigger(128);
    [ T.timestampReference(iTrial), ~ , ~ , T.missedReference(iTrial), ~] = ...
        Screen('Flip', P.window, whenFlip);
    % send recorind trigger for start of fixation
    P.io.SendTrigger(T.triggerReference);

    %---------------------------------------------------------------------------
    % Initialize the response pad and get response
    %---------------------------------------------------------------------------
    T.whenKBStart(iTrial) = GetSecs;

    KbQueueRelease(P.kb.DeviceParticipant);
    KbQueueCreate(P.kb.DeviceParticipant);
    KbQueueStart(P.kb.DeviceParticipant);

    T.whenKBEnd(iTrial) = GetSecs;


    %---------------------------------------------------------------------------
    % Cue: Audio Stimulus
    %---------------------------------------------------------------------------
    % calculate when to start playing audio. This takes three things into
    % account: 1) the fact that currently, we are presenting the
    % inter-trial interval (fixation point), 2) the delay between audio and
    % visual -- this last one needs to be measured for each computer
    % separately!
    whenPlay = T.timestampReference(iTrial) ...
        + T.referenceOffset ...
        + P.audio.AudioDelay;

    T.whenAudio(iTrial) = whenPlay;

    %     tic
    PsychPortAudio('Start', P.audio.audioHandle, 1, whenPlay);
    %     toc

    %---------------------------------------------------------------------------
    % Target: Checkerboard Stimulus second
    %---------------------------------------------------------------------------
    % draw stimulus in desired location
    Screen('DrawTexture',P.window, T.textureStimulus,...
        T.sourceStimutulus,T.destinationStimulus);

    % add fixation point
    Screen('DrawTexture',P.window, T.textureFixation, T.sourceFixation, ...
        T.destinationFixation);

    % draw white rectangle
    DrawPhotodiodeRectangle(P,1);


    whenFlip = T.timestampReference(iTrial) ...
        + T.referenceOffset ...
        + T.audioStimulusDuration ...
        + T.delayCueTarget(iTrial) ...
        - P.buffer * P.ifi;
    T.whenFlipTargetOn(iTrial) = whenFlip;

    P.io.SendTrigger(128+1);
    [ T.timestampTargetOn(iTrial), ~ ,  ~ , T.missedTargetOn(iTrial), ~] = ...
        Screen('Flip', P.window, whenFlip);
    % send recorind trigger for start of stimulus
    P.io.SendTrigger(T.triggerTarget(iTrial));
    %     flipInfo = Screen('GetFlipInfo',P.window,3)

    %---------------------------------------------------------------------------
    % Response Window - i.e. StimulusOff
    %---------------------------------------------------------------------------
    % draw fixation point - not specifying which part of texture draws
    % everything, and not specify where to draw it, draws it at the center
    Screen('DrawTexture',P.window, T.textureFixation, T.sourceFixation, ...
        T.destinationFixation);

    % draw black rectangle
    DrawPhotodiodeRectangle(P,2);

    % done drawing
    %     Screen('DrawingFinished', P.window);

    whenFlip = T.timestampTargetOn(iTrial) + ...
        (T.durationTarget(iTrial)-P.buffer)*P.ifi;
    T.whenFlipTargetOff(iTrial) = whenFlip;

    P.io.SendTrigger(128+2);
    [T.timestampTargetOff(iTrial), ~ , ~ , ...
        T.missedTargetOff(iTrial), ~] = ...
        Screen('Flip', P.window, whenFlip);
    % send recorind trigger for end of stimulus -- simply add +1 to
    % original trigger
    P.io.SendTrigger(T.triggerTarget(iTrial)+1); % TODO: uncomment for scanner
    %     flipInfo = Screen('GetFlipInfo',P.window,3);

    %     wait for responseinterval to end - minus last 100ms -- we'll use that
    %     time to process the key-responses
    while GetSecs < ( ...
            T.timestampTargetOff(iTrial)...
            + T.durationResponseWindow(iTrial) * P.ifi ...
            - T.keyBoardProcessingTime...
            )
        % to avoid overloading CPU
        WaitSecs(0.001);
    end
    T.whenKBProcessStart(iTrial) = GetSecs;
    % Stop the queue, pressing a button will not be registered anymore
    KbQueueStop(P.kb.DeviceParticipant);

    % get which buttons were pressed
    [pressed, firstPress] = KbQueueCheck(P.kb.DeviceParticipant);

    if pressed % i.e. any button registered?
        % get button indices, excl. scannerTriggers
        Buttons = setdiff(find(firstPress),P.kb.keyScannerTrigger);

        % get timestamps of all button presses excluding scannerTriggers
        Times  = firstPress(Buttons);

        % if any non-scannerTrigger button registered, calculate reaction time
        if any(Buttons)
            T.whichButtons{iTrial} = Buttons;
            % assuming that the very first button press is the actual response:
            T.RT(iTrial) = min(Times) - T.timestampTargetOn(iTrial);
        else
            fprintf(' any Buttons is false - leaving RT as NaN..\n');
        end
    end
    T.whenKBProcessEnd(iTrial) = GetSecs;
end
P.io.SendTrigger(T.triggerTarget(iTrial)+1);


end
