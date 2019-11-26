FROM ubuntu:16.04

LABEL maintainer="Sellami Abdelkader <sellislem@gmail.com>"

WORKDIR /root/

ENV USER root

ENV PATH="/android_build/bin:${PATH}"

RUN apt-get update

#install essential build
RUN apt-get install -y bsdmainutils openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python python3 bc libc6

#install repo
RUN mkdir -p /android_build/bin && curl https://storage.googleapis.com/git-repo-downloads/repo > /android_build/bin/repo && chmod a+x /android_build/bin/repo

RUN rm -rf /var/cache/apt && rm -rf /var/lib/apt/lists

#install gcc 4.4
RUN mkdir -p /android_build/gcc

RUN curl http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-4.4/cpp-4.4_4.4.7-8ubuntu1_amd64.deb > /android_build/gcc/cpp-4.4_4.4.7-8ubuntu1_amd64.deb
RUN curl http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-4.4/gcc-4.4-base_4.4.7-8ubuntu1_amd64.deb > /android_build/gcc/gcc-4.4-base_4.4.7-8ubuntu1_amd64.deb
RUN curl http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-4.4/gcc-4.4_4.4.7-8ubuntu1_amd64.deb > /android_build/gcc/gcc-4.4_4.4.7-8ubuntu1_amd64.deb
RUN curl http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-4.4/gcc-4.4-multilib_4.4.7-8ubuntu1_amd64.deb > /android_build/gcc/gcc-4.4-multilib_4.4.7-8ubuntu1_amd64.deb

RUN dpkg -i /android_build/gcc/cpp-4.4_4.4.7-8ubuntu1_amd64.deb /android_build/gcc/gcc-4.4-base_4.4.7-8ubuntu1_amd64.deb /android_build/gcc/gcc-4.4_4.4.7-8ubuntu1_amd64.deb /android_build/gcc/gcc-4.4-multilib_4.4.7-8ubuntu1_amd64.deb

#install g++ 4.4
RUN mkdir -p /android_build/g++

RUN curl http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-4.4/g++-4.4_4.4.7-8ubuntu1_amd64.deb > /android_build/g++/g++-4.4_4.4.7-8ubuntu1_amd64.deb
RUN curl http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-4.4/libstdc++6-4.4-dev_4.4.7-8ubuntu1_amd64.deb > /android_build/g++/libstdc++6-4.4-dev_4.4.7-8ubuntu1_amd64.deb
RUN curl http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-4.4/g++-4.4-multilib_4.4.7-8ubuntu1_amd64.deb > /android_build/g++/g++-4.4-multilib_4.4.7-8ubuntu1_amd64.deb

RUN dpkg -i /android_build/g++/g++-4.4_4.4.7-8ubuntu1_amd64.deb /android_build/g++/libstdc++6-4.4-dev_4.4.7-8ubuntu1_amd64.deb /android_build/g++/g++-4.4-multilib_4.4.7-8ubuntu1_amd64.deb

#set gcc 4.4 and g++ 4.4 as default
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 44
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.4 44

#change dash to bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

#copy the entry script into the container

#set volume
RUN mkdir /aosp

WORKDIR /aosp
