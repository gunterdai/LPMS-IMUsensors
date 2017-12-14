close all
clear
clc

%% Parameters
nData = 500;    % number of samples to record (seconds / 100)
nCount = 1;     % starting number
fprintf('Script to record LPMS sensor data with %d data \n', nData);

%% Code to Serial port selection
fprintf('%s \n',seriallist);
connectedSerials = seriallist;
x = input(['Which port of the list? [1->' num2str(length(connectedSerials)) ']. Zero to Exit: ']);
if x == 0
    return
end
COMPort = connectedSerials(x);
disp(COMPort)

%% Comunication parameters      
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms1();          % function lpms API sensor given by LPMS

ts = zeros(nData,1);
accData = zeros(nData,3);
quatData = zeros(nData,4);


%% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('sensor not connected')
    return 
end
disp('sensor connected')

%% Setting streaming mode
lpSensor.setStreamingMode();

%% Setting Wait Bar
h = waitbar(0,'1','Name','Getting Data...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

%% Reading Data
disp('Accumulating sensor data')
while nCount <= nData
    d = lpSensor.getQueueSensorData();
    if getappdata(h,'canceling')
        break
    end
    if (~isempty(d))
        ts(nCount) = d.timestamp;
        accData(nCount,:) = d.acc;
        quatData(nCount,:) = d.quat;
        % Report current estimate in the waitbar's message field
        waitbar(nCount/nData,h,sprintf('Data: %d',nCount))
        nCount=nCount + 1;
    end
end
disp('Done')
if (lpSensor.disconnect())
    disp('sensor disconnected')
end

%% Plotting
plot(ts-ts(1), accData);
xlabel('timestamp(s)');
ylabel('Acc(g)');
grid on
