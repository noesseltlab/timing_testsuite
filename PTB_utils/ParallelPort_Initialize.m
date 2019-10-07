function io = ParallelPort_Initialize(machine)

io = struct();


% what is the default value of the parallel port
io.restValue = 0;

% when changing the port-output to a specific trigger, for how long
% should the port-value be changed for, before reverting back to
% the RestValue
io.triggerLength = .001; % in seconds, i.e. 1ms

switch machine
    case {'Prisma','EEGLabG24','debug'}
        switch machine
            case 'Prisma'
                io.address = hex2dec('C010');
            otherwise
                io.address = hex2dec('E000');
        end
        
        [ioObj,~] = IO64_Initialize(io);
        
        % define SendTrigger API
        io.SendTrigger = @(x) IO64_SendTrigger(...
            ioObj,...
            io.triggerLength, ...
            x,...
            io.restValue...
            );
        
        % define Close API
        io.Close = @() IO64_Close();
        
    case 'EEGLabG24-linux'
        io.address = 3; % corresponds to /dev/partport2
        
        % Note: Mex-file will throw an error if it cannot open & claim the
        % parallel port
        PPDev_Initialize(io.address);
        
        % define SendTrigger API
        io.SendTrigger = @(x) PPDev_SendTrigger(...
            io.address,...
            io.triggerLength,...
            x,...
            io.restValue...
            );
        
        % define Close API
        io.Close =@() PPDev_Close(io.address);
       
        
    otherwise
        fprintf('\n\n WARNING: Parallel port NOT WORKING\n');
        fprintf(['cannot set address of parallel port ' ...
            '- Unknown machine %s\n'] ,machine);
        fprintf('setting up dummy-functions so that the code will run..\n\n');
        
        % define a dummy setting
        io.address = 0; 
        io.SendTrigger = @DoNothing;
        io.Close = @DoNothing;
end


end