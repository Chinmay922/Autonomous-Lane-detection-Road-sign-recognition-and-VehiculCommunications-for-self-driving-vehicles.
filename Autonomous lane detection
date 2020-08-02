clearvars -except opencheck
clc
close all
%% PARAMETERS
% COMMUNICATIONS TOGGLE
COMMS = false;                      % switch comms on or off

% IMAGE DOWNSCALE FACTOR
downscale = 0.25;
% GAUSSIAN FILTER
sigma = 1.5;              % standard deviation
% CANNY EDGE DETECTOR
type = 'Sobel';         % 'Sobel', 'Prewitt', 'Roberts', 'log', 'zerocross', 'Canny', 'approxcanny'
low = 0.1;
high = 0.15;
% COLOR2GRAY
ri = 0;                   % red channel intensity
gi = 0;                   % green channel intensity
bi = 1;                  % blue channel intensity
% HOUGH TRANSFORM
numlines = 5;             %number of lines to detect
MinLength = 8;            % minimum length of detected line
FillGap = 12;             % size of line gap to fill
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
    udpB = udp(ipA,portA,'LocalPort',portB);
    fopen(udpB);
end

[Stop, ~, Imagestop]= imread('STOPf.png');
[Slowdown, ~, Imageslowdown] = imread('SLOWf.png');
[GO, ~, Imagego] = imread('GOf.png');

LogoImage = imread('steer.png');
LogoImage =imresize(LogoImage,0.5);

%% MAIN
load cameraParameters.mat
% change directory to Test Track Videos
cd ..
tree = dir();
cd('1. Project data\Test Track Videos\')
% read Clockwise.mp4
mov=VideoReader('Clockwise.mp4');
while(1)
    while hasFrame(mov)
        
        if COMMS == true
            if udpB.BytesAvailable > 0
                data = fread(udpB, udpB.BytesAvailable);
                flushinput(udpB)
            end
        end
        
        pic = readFrame(mov);
        pic = imresize(pic, downscale);
        pic_original = pic;
        %   apply gaussian filter to smooth image and filter noise
        pic = imgaussfilt(pic,sigma);
        shape = size(pic);
        %   equalize image histogram
        pic = histeq(pic);
        picgray = color2gray(pic,ri,gi,bi);
        picedge = edge(picgray, type);
        %     picedge = imbinarize(picgray, 0.5);
        %     picedge = bwskel(picedge);
        %   specify row coordinates of polygon
        a=[shape(2)*0.25,shape(2)*0.75,shape(2), 20];
        %   specify column coordinates of polygon
        b=[shape(1)*0.63,shape(1)*0.63,shape(1),shape(1)];
        bw=roipoly(pic,a,b);
        %   figure(3)
        %   imshow(bw)
        BW = picedge(:,:,1)&bw;
        %         figure(1); imshowpair(picgray,BW, 'montage');
        % perform hough transform
        [H,theta,rho] = hough(BW,'RhoResolution',2, 'Theta', -90:0.1:89);
        % Find hough peaks and plot locations on hough transform
        peaks = houghpeaks(H,numlines);
        lines = houghlines(BW,theta,rho,peaks,'FillGap',FillGap, 'MinLength', MinLength);
        %   plot hough lines onto image
        figure(2);
        imagesc(pic_original);
        
        if COMMS == true
            msg1 = fscanf(udpB);
            title(msg1)
        end
        
        hold on
        anglethres=0.01; %separate left/right by orientation threshold
        leftlines=[];
        rightlines=[]; %Two group of lines
        for k = 1:length(lines)
            x1=lines(k).point1(1);y1=lines(k).point1(2);
            x2=lines(k).point2(1);y2=lines(k).point2(2);
            if (x2>=shape(2)/2) && ((y2-y1)/(x2-x1)>anglethres)
                rightlines=[rightlines;x1,y1;x2,y2];
            elseif (x2<=shape(2)/2) && ((y2-y1)/(x2-x1)<(-1*anglethres))
                leftlines=[leftlines;x1,y1;x2,y2];
            end
        end
        draw_y=[shape(1)*0.6,shape(1)]; %two row coordinates
        if isempty(leftlines)
            PL = PLn;
        else
            PL=polyfit(leftlines(:,2),leftlines(:,1),1);
            PLn = PL;
        end
        draw_lx=polyval(PL,draw_y); %two col coordinates of left line
        if isempty(rightlines)
            PR = PRn;
        else
            PR=polyfit(rightlines(:,2),rightlines(:,1),1);
            PRn = PR;
        end
        draw_rx=polyval(PR,draw_y); %two col coordinates of right line
        imagesc(pic);
        hold on;
        plot(draw_lx,draw_y,'LineWidth',4,'Color','red');
        hold on
        plot(draw_rx,draw_y,'LineWidth',4,'Color','red');
        Xcf=   0.5*(draw_rx(1)+draw_lx(1));
        Zcf=   0.5*(draw_y(1)+draw_y(1));
        Xcn=   0.5*(draw_rx(2)+draw_lx(2));
        Zcn=   0.5*(draw_y(2)+draw_y(2));
        
        line([Xcf,Xcn],[Zcf,Zcn],'Color','green','LineWidth', 2)
        %         plot(Xcf,Zcf, 'xy','MarkerSize',16)
        theta_e = - atan2((Zcf-Zcn),(Xcf-Xcn))- 90;
        Cpos = 60;
        efa = Xcn + ((Xcf-Xcn)/(Zcf-Zcn))*(Zcn-Cpos);
        k = 1.1;
        k2 =.04;
        steer_control = (-k*theta_e) + (-k2*efa) -90 ;
        hold on
        text(18,18,['Steering angle = ',num2str(steer_control)],'Color','red')
        
        if COMMS == true
            HMI_steer(steer_control,LogoImage,msg1,Stop,Slowdown,GO,Imagestop,Imagego,Imageslowdown)
        end
    end
end
% plot center line
function [imagegray] = color2gray(image,r_intensity,g_intensity,b_intensity)
%   This function converts an image from color to grayscale using NTSC
r = image(:,:,1);
g = image(:,:,2);
b = image(:,:,3);
%   imagegray = 0.2989*r + 0.587*g + 0.114*b;
imagegray  = r_intensity*r + g_intensity*g + b_intensity*b;
end

function HMI_steer(steer_control,LogoImage,msg1,Stop,Slowdown,GO,Imagestop,Imagego,Imageslowdown)
figure(3)
a=imrotate(LogoImage,steer_control*4);
axis off
set(gca,'Color','none')
if msg1=="SLOW DOWN!"
    subplot(1,2,1),image(Slowdown, 'AlphaData', Imageslowdown)
    axis off
elseif msg1 == "STOP!"
    subplot(1,2,1),image(Stop, 'AlphaData', Imagestop)
    axis off
else
    subplot(1,2,1),image(GO, 'AlphaData', Imagego)
    axis off
end
title("HMI")
subplot(1,2,2),imshow(a)
title("Steer")
hold on
end
