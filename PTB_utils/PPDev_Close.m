function PPDev_Close(varargin)
% PPDevClose(..) tries to close open PPDev port. 
% 
% There are 3 potential uses: close one specific port, close multiple
% specified ports, close all open ports
% 
% Input:
%   varargin   ... [optional] either a single non-zero integer, several non-zero
%                  integers. If no argument is supplied, all ports will be
%                  closed.


if nargin > 0
    for i = 1:nargin
        fprintf('trying to close ppdev port %i\n',varargin{i});
        try 
        ppdev_mex('Close',varargin{i});
        catch e 
            fprintf('error with msg: %s \n',e.message);
        end
    end
else
    fprintf('closing all ppdev connections\n')
    ppdev_mex('CloseAll');
end

end