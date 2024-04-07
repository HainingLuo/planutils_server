FROM aiplanning/planutils:latest

LABEL maintainer "Haining Luo <hl18@ic.ac.uk>"

# set environment variables
ENV DEBIAN_FRONTEND noninteractive
# ENV LANG C.UTF-8
# ENV LC_ALL C.UTF-8
# ENV ROS_DISTRO=melodic
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

SHELL ["/bin/bash", "-c"]

# # install ROS
# RUN apt-get update && apt-get install -q -y --no-install-recommends \
#     dirmngr \
#     gnupg2 \
#     && rm -rf /var/lib/apt/lists/*
# RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'
# RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# RUN apt-get update \
#     && apt-get install -y --no-install-recommends ros-${ROS_DISTRO}-ros-full
#     # && apt-get autoclean \
#     # && apt-get autoremove \
#     # # Clear apt-cache to reduce image size
#     # && rm -rf /var/lib/apt/lists/*
# RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc

RUN /usr/local/bin/planutils install smtplan --yes
RUN /usr/local/bin/planutils install lama --yes

WORKDIR /pddl

CMD /bin/bash
# CMD bash -c 'PLANUTILS_PREFIX="~/.planutils" PATH="$PATH:$PLANUTILS_PREFIX/bin"'