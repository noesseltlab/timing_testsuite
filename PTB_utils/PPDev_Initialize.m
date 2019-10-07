function PPDev_Initialize(address)
% PPDevInitialize(address)
% 
% Input: 
%   address    ... non-zero Integer. E.g. `1` will try to open /dev/parport1
% 


% force closing of the potentially open port, to avoid getting a "already
% claimed" error
try 
    ppdev_mex('Close',address);
catch
end

% open port
ppdev_mex('Open',address);
end