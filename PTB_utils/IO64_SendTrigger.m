function IO64_SendTrigger(ioObj,triggerLength, byte, restValue)

io64(ioObj,address,byte);

WaitSecs(triggerLength);

io64(ioObj,address,restValue);

end