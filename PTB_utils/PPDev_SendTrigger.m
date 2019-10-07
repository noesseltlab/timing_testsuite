function PPDev_SendTrigger(address, triggerLength, byte,restValue)
% SendTrigger_PPDev(address, triggerLength, restValue, byte)
% 
% Will send the `byte` code to the parallel port (identified by `address`
% -- a non-zero integer) for a duration of `triggerLength`. After that time
% has expired, the `restValue` will be send to the parallel port and the
% function returns.
% 
% Example: will set only pin nr 8 to "up" for 1ms, and than all pins to "down":
% SendTrigger_PPDev(0,0.001, 128, 0);
% 

% write trigger code
ppdev_mex('Write',address,byte);

% wait for triggerLength
WaitSecs(triggerLength);

% write rest-code
ppdev_mex('Write',address,restValue);

end