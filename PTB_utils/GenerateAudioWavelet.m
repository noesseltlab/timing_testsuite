function signal = GenerateAudioWavelet(frequency,duration,rampDuration,samplingRate)
% generates a "Wavelet" audio stimulus - mixture of linear ramp up/down
% with pure sinus tone
% 
        nTotalSamples = duration*samplingRate;
        
        % define envelope
        %-----------------------------------------------------------------------
        envelope = ones(1,nTotalSamples);
        
        % create linear ramp-up 
        nRampSamples = round(rampDuration * samplingRate);
        envelope(1:nRampSamples) = linspace(0,1,nRampSamples);
        % ramp-down
        envelope((end-nRampSamples+1):end) = linspace(1,0,nRampSamples);
        
        % define pure tone
        %-----------------------------------------------------------------------
        % define `time`
        t = (0:(nTotalSamples-1)) * 1/samplingRate;
        pure_tone = sin(2*pi*frequency*t);
        
        % calculate the signal based on pure tone and envelope
        %-----------------------------------------------------------------------
        signal = pure_tone .* envelope;      
end