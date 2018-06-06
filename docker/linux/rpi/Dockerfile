FROM debian:stretch-slim
MAINTAINER Robert Savage "robert@shadeblue.com"

ENV TZ=America/New_York

RUN apt-get update    \
&& apt-get install -y \
   git    \
   gcc    \
   g++    \
   make   \
   tree   \
   awscli \
&& apt-get clean

RUN git clone --depth=1 --branch=master https://github.com/raspberrypi/tools /root/rpi-tools && rm -Rf !$/.git
ENV RPI_CROSS_COMPILE_ON_X86="/root/rpi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-"
ENV RPI_CROSS_COMPILE_ON_X64="/root/rpi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-"
ENV RPI_CROSS_COMPILE=${RPI_CROSS_COMPILE_ON_X64}
