close all
clear
clc
t = cputime;

%% Parameters
T = 400;        % number of samples to view on plot (seconds / 100)
nCount = 1;     % starting number
fprintf('Script to real time plot LPMS sensor data with %d data width \n', T);

%% Code to Serial port selection
COMPort = COMPort();
numOfSensors = length(COMPort);
if numOfSensors ~= 1
    fprintf('Sensors ports connected: %d. Review your connections.\n', numOfSensors);
    timeInterval = cputime - t;
    fprintf('Total Time: %f.\n', timeInterval);
    return
else
    fprintf('%d Sensor connected to the ports.\n', numOfSensors);
end

%% Comunication parameters
baudrate = 921600;          % rate at which information is transferred
lpSensor = lpms1();          % function lpms sensor given by LPMS

%% Data saving
gyrData = zeros(T,3);
accData = zeros(T,3);
magData = zeros(T,3);
quatData = zeros(T,4);
eulerData = zeros(T,3);
linAccData = zeros(T,3);

%% Connect to sensor
if ( ~lpSensor.connect(COMPort, baudrate) )
    disp('sensor not connected')
    return 
end
disp('sensor connected')

%% Setting streaming mode
disp('Setting mode ...')
lpSensor.setStreamingMode();

%% Loop Plot
figure('doublebuffer','on', ...
       'CurrentCharacter','a', ...
       'WindowStyle','modal')
disp('Plotting ...')
while double(get(gcf,'CurrentCharacter'))~=27
%while true
    nData = lpSensor.hasSensorData();
    for i=1:nData
        d = lpSensor.getQueueSensorData();
        if nCount == T
            accData = accData(2:end, :);
        else
            nCount = nCount + 1;
        end
        accData(nCount,:) = d.acc;
    end
    if nData ~=0
        DrawRotation(accData(nCount,1), accData(nCount,2), accData(nCount,3))
%         plot(1:T,magData)
%         grid on;
%         title(sprintf('ts = %fs', (d.timestamp)))
%         drawnow
    end
end

set(gcf,'WindowStyle','normal');
if (lpSensor.disconnect())
    disp('sensor disconnected')
end
