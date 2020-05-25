# Autonomous Lane detection and Road sign recognition for self driving vehicles

# Overview

As I am an Automotive engineer working on autonomous vehicles, I would love to work on this project which may help in making self-driving features of vehicles more reliable and safe. The objective of this project is to design an algorithm for detecting lanes, calculating steering angle, and distance from other vehicles using a camera in a self-driving vehicle. The autonomous vehicle should also detect road traffic signs and act accordingly. Also, implementing an intuitive HMI to show the steering moment.
The road sign recognition and autonomous lane recognition cab be run on two different computers or the same computers and data between the two programs will be communicated in real-time. In this project I will be collecting data by mounting a Kinect camera on a real vehicle and calculating all the above-mentioned parameters and road images/video. 

Calculating the distance between the near-by vehicles and using a Microsoft Kinect camera with IMU and depth sensor which helps to find out the distance from other vehicles will be a new addition to my previous project.
An intuitive HMI will also be implemented which will show the road sign signals from one program to another and will also show the steering wheel movement in the display.
Carrying out this whole algorithm using MATLAB/ROS/Python.
This project is based on an ideology towrads innovation in self driving vehicles and is an open source project. It would be an honour if anybody wants to contribute to this project and add more value to it. Although all the softwares used in this project would not be completely free such as MATLAB but the same program can also be made in Python/ROS which are open source and free of cost. Also some of the resources such as the Kinect camera used to capture video of the lane or the RC vehicles might not be available to everyone but it would be easy to simply use the video uploaded in this project for futher work.

# Necessity

As many automakers are currently working on self-driving vehicles to make it more reliable, safe, and self-dependent. for self-driving to be safe the vehicle must respond to its nearby road signs, vehicles, and most importantly follows the traffic rules. As this project is focused on computer vision and motion planning which is one of the most important aspects of a self-driving vehicle it would help understand and implement the self-driving features in the real world vehicles and will be a new step towards understanding how the regulars vehicles in the market can be automated using a simple camera and computers. 

# Algorithm

Camera Calibration - this can be done using the camera calibration tools in MATLAB or some other software where the intrinsic and extrinsic parameters of the camera will be used for the distance and steering parameters measurement. This calibration can be done using dataset images of a checkboard.

Obtaining the Environment video- the image/video of the environment will be taken from the Microsoft Kinect Camera using the MATLAB tool. As the Kinect has IMU and depth sensor, it will be utilized to calculate the distance between the robot and other vehicles.

Filtering and downsizing - as the image obtained from the camera is too large and has noise and other reflection we will be using Gaussian filter and masking the unwanted portions of the images. 

Detecting the lanes- the next step would be detecting the lanes on either side of the road and simultaneously calculating the steering angle input required for the vehicle to follow the lanes. 

Data set training - the next step would be training the program with a data set to make the robot understand the road signs and act accordingly. for example, if the vehicle detects any 'School' sign then it should slow down or should stop at any 'STOP' sign. it should also send these messages to the lane detection programs or ay other systems running in the vehicle. All this will be carried out by using Machine learning to train the algorithm using data sets with several signs and no signs to understand the difference and act accurately. Now, for every time step the vehicle should get a message whether it should drive, slow down, speed-up, or slow down. this will be done using an intuitive HMI implementation.

Communications - it is very important for self-driving vehicles to communicate with the environment as well as with the vehicles nearby. For this function we will be implementing communications between computer using the IP address establishing the communication using a User-datagram protocol or Transmission Control Protocol/Internet Protocol. every vehicle should be getting the information and actions of the other vehicles.

Intuitive HMI - this HMI will show the steering moment and road signs messages as an input to the vehicle and information to the passengers. But, one of the major use of this would be displaying these messages through communications of V2X communications. V2X communication could be vehicle to vehicle, vehicle to infrastructure, or vehicle to person. 

For implementing these features we would be using ROS/MATLAB/Python whichever fits more convenient and less computationally expensive. for more help on working on these projects there are many courses on Udemy, Udacity, and Coursera but all working on different platforms and policies. 

# How to create, run the tests and perform functions

# References

# Dependencies

•	ROS kinectic/MATLAB/Python - MATLAB can not be found free but ROS kinect and Python are open source softwares.
•	Microsoft Kinect and Kinect drivers - it is used for my project and any other camera with depth sensors and IMU can be utilized.
•	Camera Calibration tool - We would be using MATLAB camera calibrartion tool but any other calibration tool can also be used.
•	Sufficient data set for training the algorithm - there should be enough data images of the Road signs, environment pictures to implement Machine learning. 
