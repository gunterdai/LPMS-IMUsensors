close all
clear
clc
%% Read and categorice data

filename1 = 'name_2018-02-07T175658.txt';
filename2 = 'name_2018-02-07T175659.txt';
filename3 = 'name_2018-02-07T175700.txt';

T1 = readtable(filename1);
T2 = readtable(filename2);
T3 = readtable(filename3);

VA0 = cat(1,T1.VA0, T2.VA0, T3.VA0);
VA1 = cat(1,T1.VA1, T2.VA1, T3.VA1);
VA2 = cat(1,T1.VA2, T2.VA2, T3.VA2);

pos1X = cat(1,T1.pos1X, T2.pos1X, T3.pos1X);
pos1Y = cat(1,T1.pos1Y, T2.pos1Y, T3.pos1Y);
pos1Z = cat(1,T1.pos1Z, T2.pos1Z, T3.pos1Z);
pitchS1 = cat(1,T1.pitchS1, T2.pitchS1, T3.pitchS1);
rollS1 = cat(1,T1.rollS1, T2.rollS1, T3.rollS1);
yawS1 = cat(1,T1.yawS1, T2.yawS1, T3.yawS1);
linAccX1 = cat(1,T1.linAccX1, T2.linAccX1, T3.linAccX1);
linAccY1 = cat(1,T1.linAccY1, T2.linAccY1, T3.linAccY1);
linAccZ1  = cat(1,T1.linAccZ1 , T2.linAccZ1 , T3.linAccZ1 );

pos2X = cat(1,T1.pos2X, T2.pos2X, T3.pos2X);
pos2Y = cat(1,T1.pos2Y, T2.pos2Y, T3.pos2Y);
pos2Z = cat(1,T1.pos2Z, T2.pos2Z, T3.pos2Z);
pitchS2 = cat(1,T1.pitchS2, T2.pitchS2, T3.pitchS2);
rollS2 = cat(1,T1.rollS2, T2.rollS2, T3.rollS2);
yawS2 = cat(1,T1.yawS2, T2.yawS2, T3.yawS2);
linAccX2 = cat(1,T1.linAccX2, T2.linAccX2, T3.linAccX2);
linAccY2 = cat(1,T1.linAccY2, T2.linAccY2, T3.linAccY2);
linAccZ2  = cat(1,T1.linAccZ2, T2.linAccZ1, T3.linAccZ2);

Angle = cat(1, T1.Angle, T2.Angle, T3.Angle);

%% RNA

% input = [EMG + IMUS (2x)]'
input = [VA0 VA1 pos1X pos1Y pos1Z pitchS1 rollS1 yawS1 linAccX1 linAccY1 linAccZ1 pos2X pos2Y pos2Z pitchS2 rollS2 yawS2 linAccX2 linAccY2 linAccZ2]'; % INPUTS
% target = [Angle from IMUs and Voltage from flexSensor]'
target = [Angle VA2]';

net = feedforwardnet(10);
[net,tr] = train(net,input,target);
view(net)
% performance
y = net(input);
perf = perform(net,y,target);
% testing network
output = net([0.967700000000000,0.958000000000000,-0.970200000000000,-0.232500000000000,0.0686000000000000,0.0686000000000000,-0.00760000000000000,-2.90640000000000,-0.00100000000000000,0.000700000000000000,0.00450000000000000,-0.875400000000000,0.753500000000000,0.205900000000000,0.137800000000000,-0.0982000000000000,1.47500000000000,-0.000200000000000000,0.00110000000000000,0.00570000000000000]');
% generate Function
genFunction(net,'ANN_ExoData_Fcn');
y2 = ANN_ExoData_Fcn(input);
accuracy2 = max(abs(y-y2));