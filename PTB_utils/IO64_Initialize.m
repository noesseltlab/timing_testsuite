function [ioObj, status] = IO64_Initialize()

%create IO64 interface object
ioObj = io64();

%install the inpoutx64.dll driver
%status = 0 if installation successful
status = io64(ioObj);

assert(status ~= 0, 'IO64 (parallel port) installation failed!');
end