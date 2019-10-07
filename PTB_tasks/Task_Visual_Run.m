function T = RunTask_Visual(T,P)
% TaskVisual(P) runs a simple Visual task
% 
% Note: assumes PTB has been initialized via InitializePTB()
% 
% Input:
%   T           ... struct. Contains task-specific parameters. can be
%               obained from using PrepTask_Visual().
% 
%   P           ... struct. Contains Parameters of the current PTB session,
%               as returned by InitializePTB()
% 
% Output: 
%   T           ... struct. Same as the input, but includes the actual
%               timestamps from the run
%               
% SEE ALSO: InitializePTB, PrepTask_Visual

if P.measuringWithPhotodiode 
    iPhotodiodeRectangle = 0; % will alternate between 0 and 1 to switch between black/white
end


for iTrial = 1:T.nTrials
    %---------------------------------------------------------------------------
    % Fixation point
    %---------------------------------------------------------------------------
    % start with iti
    % draw fixation point - not specifying which part of texture draws
    % everything, and not specify where to draw it, draws it at the center
    Screen('DrawTexture',P.window, T.textureFixation);
    
    % draw rectangle in upper-left corner
    iPhotodiodeRectangle = DrawPhotodiodeRectangle(P,iPhotodiodeRectangle);
    
    % done drawing 
    Screen('DrawingFinished', P.window);
    
    % calcuate when to flip
    if iTrial == 1
        whenFlip = 0; % flip asap
    else
        whenFlip = T.timestampStimulusOn(iTrial-1) + ...
            (T.durationStimulus(iTrial-1)-P.buffer)*P.ifi;
    end
    
    % perform flip -- not that this "freezes" Matlab code-execution till
    % the flip has happend.
    [T.timestampFixationOn(iTrial), ~ , ~ , T.missedFixationOn(iTrial), ~] = ...
        Screen('Flip', P.window, whenFlip);
    % TODO: send parallelport trigger immediately after flip
       
    %---------------------------------------------------------------------------
    % Checkerboard Stimulus
    %---------------------------------------------------------------------------
    % draw stimulus in desired location
    Screen('DrawTexture',P.window, T.textureStimulus);
    
    % draw rectangle in upper-left corner
    iPhotodiodeRectangle = DrawPhotodiodeRectangle(P,iPhotodiodeRectangle);
    
    
    % done drawing 
    Screen('DrawingFinished', P.window);
    
    % Note on whenFlip:
    % There are three ways we could be doing this. 
    % Option A)
    %   take the timestamp of the very first trial, calculate up-front when
    %   exactly we should be flipping, and provide these as input the the
    %   flip-call
    % Option B) 
    %   take the timestemp of the preceeding event (e.g. fixation cross)
    %   and add the presentation intended duration to calcate the
    %   appropriate time to flip to the next screen
    % Option C)
    %   take the timestamp of the first event in a trial (typically
    %   fixation cross) and time-lock all subsequent events to this
    %   timestamp. 
    %
    % Here, we use option C, so that within a single trial, we are not
    % increasing the overall length of the trial (option B might lead to
    % this). We also avoid having too short presentation of subsequent
    % trials, if, for some reason, a given trial takes longer to execute. 
    %   
    % Note that option B and C are only different if there are more than 2
    % events within a single trial. 

    whenFlip = T.timestampFixationOn(iTrial) + ...
        (T.interTrialInterval(iTrial)-P.buffer)*P.ifi;
    [T.timestampStimulusOn(iTrial), ~ , ~ , T.missedStimulusOn(iTrial), ~] = ...
        Screen('Flip', P.window, whenFlip);
    % TODO: send parallelport trigger immediately after flip
    
    
    
end

% flip one more time after the last stimulus, do end the presentation after
% the intended duration
whenFlip = T.timestampStimulusOn(T.nTrials) + ...
        (T.durationStimulus(T.nTrials)-P.buffer)*P.ifi;

[T.lastStimulusOff, ~ , ~ , T.missedLastStimulusOff, ~] = ...
    Screen('Flip', P.window, whenFlip);



end