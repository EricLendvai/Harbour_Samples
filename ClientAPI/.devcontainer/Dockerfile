FROM ericlendvai/harbour_basic:latest

RUN echo "Using harbour_basic"

RUN apt-get install libcurl4-openssl-dev -y

ENV HB_WITH_CURL=/usr/include/x86_64-linux-gnu/

WORKDIR /harbour

# Will request the make app to use up to 8 core.
RUN make -j 8 install

#To fix symlinks
RUN ldconfig
