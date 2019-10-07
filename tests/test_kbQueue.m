[deviceIndex, productName, allInfo] = GetKeyboardIndices

[deviceIndex, productName, allInfo] = GetMouseIndices

deviceNumber = 6;

KbQueueCreate(deviceNumber )
fprintf('Queue created \n');
KbQueueStart(deviceNumber )
fprintf('Queue started \n');
tStart = GetSecs; 


WaitSecs(2);


KbQueueStop(deviceNumber )
fprintf('Queue stopped\n');


[pressed, firstPress, firstRelease, lastPress, lastRelease] =...
    KbQueueCheck(deviceNumber )


RT  = firstPress(firstPress > 0 ) - tStart