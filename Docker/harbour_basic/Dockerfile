FROM ubuntu

# To most basic version of Harbour, no extra contribs using external dependency.

# for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Used by running apps to detect if inside a docker container. Testing for existence of /.dockerenv may not always work.
ENV InDocker=True

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y \
        git \
        build-essential \
        libgpm2 \
        gnupg \
        wget \
        psmisc

RUN apt-get update && apt-get -y upgrade

# install harbour from src
RUN git clone --branch master https://github.com/harbour/core.git harbour
WORKDIR /harbour

# Will request the make app to use up to 8 core.
RUN make -j 8 install

#To fix symlinks
RUN ldconfig
