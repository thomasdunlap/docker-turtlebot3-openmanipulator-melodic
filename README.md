# Turtlebot3 with Open Manipulator Docker Image

The motivation for this is to provide ROS containerization, so developers can work on ROS projects regardless of their OS.  This repo is adapted from the [Stanford Priciples of Robot Autonomy I](https://github.com/PrinciplesofRobotAutonomy/aa274-docker) ROS Kinetic Docker Container. 

## Set Up

### Docker Install

If you already have docker installed, skip to [ROS Setup](#ros-setup).

#### Linux

1. Install Docker.
```
./install_docker.sh
```
2. Restart computer.

#### Mac

1. Install [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/) (not Docker Toolbox):
[https://download.docker.com/mac/stable/Docker.dmg](https://download.docker.com/mac/stable/Docker.dmg)
2. Install [XQuartz](https://www.xquartz.org).
3. Enable the following setting in XQuartz:

XQuartz > Preferences > Security > Allow connections from network clients

4. Install [TurboVNC](https://sourceforge.net/projects/turbovnc/files/).
5. Run Docker.

#### Windows

Partner up with a student with a Mac or Ubuntu laptop, or use the VM provided
last year: [VM Install Guide](https://docs.google.com/document/d/1ley_pauriyx0PrH8XYfkIrZwXnL3s-xBQvcUY6RE02I/edit?usp=sharing)

### ROS Setup

```
./init_melodic.sh
```
1. `init_melodic.sh` creates the Catkin workspace (`catkin_ws`) and Docker network
   (`melodic_net`). Other ROS packages can be put into `catkin_ws` as well.

```
./build_docker.sh
```

2. `build_docker.sh` builds the Docker image. This should be run any time `docker/Dockerfile` is changed.

```
./rosdep_install.sh
```
3. `rosdep_install.sh` builds the Catkin workspace. This should be run any time a new ROS package is added to `catkin_ws`.

```
./run.sh catkin_make
```


4. Whenever you make changes to your own ROS package, compile it with the
   following command:

# Running ROS

Roscore needs to be running before any other nodes. In one terminal window, run:
```
./run.sh roscore
```

Nodes can now be run in separate terminal windows.
```
./run.sh <shell command>
```

To choose the ROS master URI, call `run.sh` with `--rosmaster <hostname>` and/or
`--rosport <port>`. By default, `master:11311` is used.
```
./run.sh --rosmaster master --rosport 11311 <shell command>
```

*Note*: The Catkin workspace and ROS logs are written to the host filesystem (under
`catkin_ws` and `.ros`, respectively). Any changes made to these folders in the
host OS will also be reflected in the Docker containers. However, changes in the
Docker containers outside these folders are temporary and will not persist
across sessions.

If you are using Docker on a Mac (or on a remote Linux host via SSH) and need to
view the GUI, call the command with `--display <display_id>`. This will stream
the rendered GUI through a TurboVNC server. The display ID must be unique and
nonzero.
```
./run.sh --display 1 roslaunch turtlebot3_gazebo turtlebot3_world.launch
```
This command will ask you to create a password for the VNC session. You can then
connect to this session by opening TurboVNC and connecting to the host's address
with the display ID or VNC port. The following examples are equivalent:
```
localhost:1
localhost:5901
127.0.0.1:1
```
The optional `vncport` parameter can be manually specified to avoid port
collisions. Otherwise, the port number will default to `5900 + <display_id>`.
