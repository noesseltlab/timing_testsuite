function T=Task_AudioVisual_Post(T,P)

filename = sprintf('logfiles/AudioVisual_logfile_%s.mat',...
    datestr(now,30));

if exist(filename,'file') == 2
    fprintf(['WARNING: log-file already existed!\n' ...
        'Trying to append new version number: ']);
    I_MAX = 10000;
    for i = 2:I_MAX
        newFilename = sprintf('logfiles/AudioVisual_logfile_%s_i.mat',...
            datestr(now,30), i);
        if ~exist(newFilename,'file')
            filename = newFilename;
            break
        end
    end
    fprintf('%i \n Will write to file %s\n', i, filename);
end


save(filename, 'T','P');
fprintf('data saved to file %s\n', filename);

end
