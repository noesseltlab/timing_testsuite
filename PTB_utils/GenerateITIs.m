function ITIs = GenerateITIs(nTrials, nRepeats, framerate, max_ITI)
% function GenerateITIs(nTrialsPerStimulus, nStimuli, refreshRate)
% generates a set of exponentially distributed set of Inter-Trial-Intervals
% (ITIs). Units will be in frames, NOT seconds!
% 
% Input:
%   nTrials             ... integer. number of ITIs to generate.
%   
%   nRepeat             ... integer. number of times the sequence of ITIs
%                       should be repeated. Each repetition is a randomly
%                       permuted variante of the initial sequence
% 
%   framerate           ... integer. Frame-rate (in Hz). This will be used
%                       to set the temporal resolution to 1/framerate of
%                       the ITIs.
% 
%   max_ITI             ... integer. Optional. Maximal value of ITIs to
%                       allow (Unit: frames !). Beware that a small value will
%                       make the distribution of ITIs no longer
%                       exponentially distributed; whether such large
%                       values are present depends on nTrails. default = 8
%                       seconds * framerate;
% 
% 
% Output:
%    ITIs               ... matrix of size (nTrials x nRepeats) of
%                       exponentially distributed inter-trial intervals
%                       (unit: frames!). The values of the columns are
%                       identical, but randomly shuffled.
% 
% 
%   Example:
%       Let's assume a frame-rate of 60Hz. 
%       To generate a set of ITIs for 5 different stimuli, with each being
%       repeated 50 times, call:
%      
%       ITIs = GenerateITIs(50,5,60); 
%       
%       This will give 50 different ITIs, shuffled between the 5 different.
% 
%       To instead generate 250 different ITIs and reshape afterwards, call:
%       ITIs = GenerateITIs(250,1,60); ITIs = reshape(ITIs,50,5);

% set defaults
if ~exist('max_ITI','var')
   max_ITI = 8 * framerate;  % convert seconds into nr of frames
end

% generate exponentially distributed set of ITIs
% TODO: look up correct mean of this exponential distribution. Should be a
% function of HRF, I think...
exp_mean = 2 * framerate; % convert seconds into nr of frames
itis = exprnd(exp_mean,[nTrials,1]);

% limiti large ITIs to `max_ITI`
itis(itis > max_ITI) = max_ITI;

% round to temporal resolution implied by frame-rate
itis = round(itis);

% expand to matrix
ITIs = itis * ones(1,nRepeats); 

% shuffle rows
for iRepeat = 2:nRepeats
   ITIs(:,iRepeat) = ITIs(randperm(nTrials),iRepeat);
end

% 
% % % for debugging:
% figure(1)
% subplot(211)
% imagesc(ITIs)
% 
% subplot(212)
% hist(ITIs(:))


end