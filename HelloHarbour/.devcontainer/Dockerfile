FROM ubuntu

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y \
        libfcgi-dev \
        git \
        build-essential \
        libfcgi-dev \
        libgpm2 \
        gnupg \
        wget \
        psmisc

# install harbour from src
RUN git clone --depth=10 https://github.com/harbour/core.git hb32
WORKDIR /hb32
# Will request the make app to use up to 8 core.
RUN make -j 8 install
RUN ldconfig
