FROM ubuntu:latest
RUN apt-get update
WORKDIR /

RUN apt-get install wget -y

RUN mkdir 3rdparty

# Installing Eigen
RUN cd 3rdparty && wget http://bitbucket.org/eigen/eigen/get/3.3.7.tar.gz
RUN cd 3rdparty && mkdir -p eigen && tar xvf 3.3.7.tar.gz -C eigen --strip-components=1


RUN apt-get install make -y
RUN apt-get install cmake -y
RUN apt-get install build-essential -y #C/C++ compiler

# Installing ITK
RUN cd 3rdparty && wget https://sourceforge.net/projects/itk/files/itk/4.13/InsightToolkit-4.13.2.tar.gz
RUN cd 3rdparty && tar xvf InsightToolkit-4.13.2.tar.gz
RUN mkdir 3rdparty/InsightToolkit-4.13.2/build
RUN cd 3rdparty/InsightToolkit-4.13.2/build && cmake -DCMAKE_INSTALL_PREFIX=../../itk ..
RUN cd 3rdparty/InsightToolkit-4.13.2/build && make -j4
RUN cd 3rdparty/InsightToolkit-4.13.2/build && make install

# Installing BOOST and TBB
RUN apt-get install libboost-all-dev -y
RUN apt-get install libtbb-dev -y

# Copying files
COPY / /home/

# Build code
RUN mkdir /home/build
RUN cd /home/build && THIRD_PARTY_DIR=/3rdparty cmake ..
RUN cd /home/build && THIRD_PARTY_DIR=/3rdparty make -j4