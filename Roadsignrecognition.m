clearvars -except opencheck
clc
close all
%% PARAMETERS
% COMMUNICATIONS TOGGLE
COMMS = false;                      % switch comms on or off

% IMAGE DOWNSCALE FACTOR
downscale = 0.25;
% CASCADE OBJECT DETECTOR FILE SELECTION
signDetectorVersion = 4;            % 0 --> schoolSignDetector0.xml, 1 --> schoolSignDetector1.xml
%% Comms
if COMMS == true
    if exist('opencheck') == 0
        opencheck = true;
    else
        fclose(instrfindall);
    end
    
    % Define computer-specific variables
    % Modify these values to be those of your first computer.
    ipA = '10.2.5.2'; portA = 9090;
    % Modify these values to be those of your second computer.
    ipB = '10.2.5.2'; portB = 9092;
    % Create UDP Object
    udpA = udp(ipB,portB,'LocalPort',portA);
    % Connect to UDP Object
    fopen(udpA)
end

%% DEEP LEARNING APPROACH [NOT WORKING]
% load JiaNet.mat
% deepnet = JiaNet;

% CASCADE OBJECT DETECTOR APPROACH [WORKING, NEEDS MORE DATA]
stopSignDetector = vision.CascadeObjectDetector(['stopSignDetector' num2str(signDetectorVersion) '.xml']);
schoolSignDetector = vision.CascadeObjectDetector(['schoolSignDetector' num2str(signDetectorVersion) '.xml']);
%% MAIN
load cameraParameters.mat
% change directory to Test Track Videos
cd ..
tree = dir();
cd('1. Project data\Test Track Videos\')
% read Clockwise.mp4
mov=VideoReader('Clockwise.mp4');
count = 0;
while(1)
    while hasFrame(mov)
        frame = readFrame(mov);
        %   create more false detection data if necessary
        %   imwrite(frame, ['positives\signa' num2str(count) '.jpg'])
        %   count = count + 1;
        frame = imresize(frame, downscale);
        frame1 = imcrop(frame,[1 1 300 300]);
        
        %   detect stop signs in current frame
        stopSignBox = step(stopSignDetector, frame1);
        stopSigns = insertObjectAnnotation(frame1, 'rectangle', stopSignBox, 'stop sign');
        %   detect school signs in current frame
        schoolSignBox = step(schoolSignDetector, frame1);
        schoolSigns = insertObjectAnnotation(frame1, 'rectangle', schoolSignBox, 'school sign');
        if isempty(stopSignBox)
            detections = schoolSigns;
            msg = 'SLOW DOWN!';
        end
        if isempty(schoolSignBox)
            detections = stopSigns;
            msg = 'STOP!';
        end
        if isempty(stopSignBox) && isempty(schoolSignBox)
            detections = stopSigns;
            msg = 'GO!';
        end
        figure(1);
        imshow(frame)
        hold on 
        imshow(detections);
        
        if COMMS == true
            fwrite(udpA,msg)
        end
    end
end


