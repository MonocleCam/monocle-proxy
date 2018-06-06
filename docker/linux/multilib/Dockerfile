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
   gcc-multilib \
   g++-multilib \
&& apt-get clean
