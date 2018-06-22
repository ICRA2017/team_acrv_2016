FROM ros:indigo-perception

RUN apt-get update && apt-get install -y \
	python-catkin-pkg python-rosdep python-wstool \
	python-catkin-tools ros-indigo-catkin \
	build-essential software-properties-common \
	&& rm -rf /var/lib/apt/lists

ENV CATKIN_WS=/root/catkin_ws
RUN rm /bin/sh \
	&& ln -s /bin/bash /bin/sh	

RUN apt-get update && apt-get install -y \
	libeigen3-dev \
	libnlopt-dev \
	libxmlrpc-c++8-dev \
	libudev-dev \
	ros-indigo-pcl-conversions \
	ros-indigo-ar-track-alvar \
	python-sklearn python-termcolor	\
	ros-indigo-moveit-* \
	&& rm -rf /var/lib/apt/lists	

RUN mkdir -p ~/ros_ws/src \
	&& cd ~/ros_ws/src \
	&& git clone https://github.com/ICRA2017/team_acrv_2016.git .

RUN mkdir ~/co && cd ~/co \
	&& git clone https://github.com/PointCloudLibrary/pcl.git \
	&& cd pcl && git checkout tags/pcl-1.8.0 -b local-1.8.0 \
	&& cd ~/ros_ws/src/apc_docs/pcl_patch \
	&& ./pcl_fix_pre.sh \
	&& cd - && mkdir build && cd build \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_GPU=ON -DBUILD_CUDA=ON \
	&& make -j7 install \
	&& cd ~/ros_ws/src/apc_docs/pcl_patch \
	&& ./pcl_fix_post.sh