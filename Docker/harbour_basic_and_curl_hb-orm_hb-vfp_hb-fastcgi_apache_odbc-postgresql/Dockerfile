FROM ericlendvai/harbour_basic:latest

# Used the harbour_basic as base, will be re-running harbour build, but image will be smaller.
# FROM ubuntu

## for apt to be noninteractive
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
        psmisc \
        libcurl4-openssl-dev \
        apache2 \
        libfcgi-dev \
        libapache2-mod-fcgid \
        unixodbc-dev \
        odbc-postgresql

RUN apt-get update && apt-get -y upgrade

# install harbour from src
RUN git clone --branch master https://github.com/harbour/core.git harbour
WORKDIR /harbour

ENV HB_WITH_CURL=/usr/include/x86_64-linux-gnu/

# Will request the make app to use up to 8 core.
RUN make -j 8 install

#To fix symlinks
RUN ldconfig

# Make some additional supporting libs
WORKDIR /src
RUN git clone https://github.com/EricLendvai/Harbour_FastCGI/
RUN git clone https://github.com/EricLendvai/Harbour_VFP/
RUN git clone https://github.com/EricLendvai/Harbour_ORM/


ENV HB_COMPILER gcc

ENV BuildMode release

WORKDIR /src/Harbour_VFP
RUN chmod +x ./BuildLIB.sh
ENV LIBName hb_vfp
RUN ./BuildLIB.sh

WORKDIR /src/Harbour_ORM
RUN chmod +x ./BuildLIB.sh
ENV LIBName hb_orm
RUN ./BuildLIB.sh

#also build debug libraries
ENV BuildMode debug

WORKDIR /src/Harbour_VFP
ENV LIBName hb_vfp
RUN ./BuildLIB.sh

WORKDIR /src/Harbour_ORM
ENV LIBName hb_orm
RUN ./BuildLIB.sh

#Could be used for future web apps builds
ENV HB_VFP_ROOT /src/Harbour_VFP/
ENV HB_ORM_ROOT /src/Harbour_ORM/
ENV HB_FASTCGI_ROOT /src/Harbour_FastCGI/



