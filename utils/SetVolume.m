
% on a linux machine (tested on Ubuntu 18.04 in EEGlab G24), set the volume to
% a specified value

% set volume to 30 percent
volume = 30
command = sprintf('amixer -D pulse sset Master %i%%',volume);
unix(command)
