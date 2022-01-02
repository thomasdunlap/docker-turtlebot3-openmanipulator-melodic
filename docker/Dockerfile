FROM osrf/ros:melodic-desktop-full

# Set up Gazebo source
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

# Install dependent packages for TurtleBot3 control
RUN apt-get update && apt-get install -y \
  ros-melodic-joy ros-melodic-teleop-twist-joy \
  ros-melodic-teleop-twist-keyboard ros-melodic-laser-proc \
  ros-melodic-rgbd-launch ros-melodic-depthimage-to-laserscan \
  ros-melodic-rosserial-arduino ros-melodic-rosserial-python \
  ros-melodic-rosserial-server ros-melodic-rosserial-client \
  ros-melodic-rosserial-msgs ros-melodic-amcl ros-melodic-map-server \
  ros-melodic-move-base ros-melodic-urdf ros-melodic-xacro \
  ros-melodic-compressed-image-transport ros-melodic-rqt* \
  ros-melodic-gmapping ros-melodic-navigation \
  ros-melodic-interactive-markers ros-melodic-ros-control* \
  ros-melodic-control*

#RUN rosdep init && rosdep update --rosdistro melodic
RUN rosdep update --rosdistro melodic

RUN apt-get update && apt-get install -y ros-melodic-moveit* \
  ros-melodic-dynamixel-sdk ros-melodic-turtlebot3-msgs \
  ros-melodic-turtlebot3

# Install TurboVNC
RUN apt-get install -y expect x11-xkb-utils xauth xfonts-base xkb-data
RUN tmp="$(mktemp)" && \
	wget -O "$tmp" https://downloads.sourceforge.net/project/virtualgl/2.6.2/virtualgl_2.6.2_amd64.deb --no-check-certificate && \
	dpkg -i "$tmp" && \
	rm -f $tmp
RUN tmp="$(mktemp)" && \
	wget -O "$tmp" https://downloads.sourceforge.net/project/turbovnc/2.2.2/turbovnc_2.2.2_amd64.deb --no-check-certificate && \
	dpkg -i "$tmp" && \
	rm -f $tmp
ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin

# Create user
ARG uid
ARG user
ARG gid
RUN groupadd -g $gid -o $user
RUN useradd -m -u $uid -g $gid $user
RUN usermod -aG video $user
RUN chmod 755 /root
RUN apt-get install -y sudo
RUN echo "\n$user ALL=(ALL) NOPASSWD:ALL\n" >> /etc/sudoers

# Copy the current directory contents into the container at /
COPY ros_env.sh /
COPY ros_entrypoint.sh /
RUN sed -i "s/\${HOST_USER}/$user/g" /ros_entrypoint.sh
RUN echo "\nsource /ros_env.sh\nsource /home/$user/catkin_ws/.bashrc" >> /home/$user/.bashrc
RUN ln -s /home/$user/catkin_ws /root/catkin_ws

# Install pip libraries
RUN apt-get install -y python-pip python3.8 python3.8-venv python3-pip
#RUN python -m pip install pip==18.0
#RUN python -m pip install -U pip
#RUN pip install numpy==1.16 scipy matplotlib==2.2 jupyter scikits.bvp_solver dubins==0.9.2
# RUN dpkg --remove --force-depends python-enum34  # Installed by ros, newer version required by tensorflow
# RUN python -m pip install tensorflow==1.15

# Install additional apt packages
RUN apt-get -f install -y
RUN apt-get install -y net-tools iputils-ping vim nano less tmux

# Clear apt cache
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/*
