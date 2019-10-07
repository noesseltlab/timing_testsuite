function ExpandPath()
% ExpandPath() adds relevant (sub)folders to Matlab's path
%
% Note: this script currently assumes it is in the projectRoot directory
%

% get directory where this script is located
[projectRoot,~,~] = fileparts(mfilename('fullpath'));

% add PTB_tasks
addpath(sprintf('%s/PTB_tasks',projectRoot));

% add PTB utility functions (like InitializePTB)
addpath(sprintf('%s/PTB_utils',projectRoot));

% add utils unrelated to PTB
addpath(sprintf('%s/utils',projectRoot));

% add PTB test functions (to test audio and input device)
addpath(sprintf('%s/tests',projectRoot));

end
