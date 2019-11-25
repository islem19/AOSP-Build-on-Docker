# AOSP 7.1 build environment on Docker

A Minimal AOSP Nougat 7.1 build environment as Docker image.

## Things to remember

This is an image which provides a **build environment** (includes any tools required for building AOSP), you should use it as a shell, then do anything you wanted.

## Prerequisites

Install Docker in your machine:
```shell
$ sudo apt-get update
$ sudo apt install docker.io
$ sudo systemctl start docker
$ sudo systemctl enable docker
```

if you want to run docker as non-root user then you need to add it to the docker group.
1- Create the docker group.
```shell
$ sudo groupadd docker
```

2- Add your user to the docker group.
```shell
$ sudo usermod -aG docker $USER
```

3- Logout and login again and run (that doesn't work you may need to reboot your machine first)

## Build your docker image 

first, clone this project in your "WORKING_DIRECTORY"
```shell
$ git clone https://github.com/islem19/AOSP-Build-on-Docker.git
```

```shell
$ cd WORKING_DIRECTORY
$ make
```
## Usage

Use it as a independent shell, and mount a local path to save source and result:
```shell
$ docker run --rm -it -v /path/to/source:/aosp sabdelkader/aosp
##### or you can run the script
$ bash run.sh
```

You can map the location of AOSP source code in your host machine with the path in your container. if you haven't got your AOSP yet, you can get it using repo command: 

> **Note:** Once you entered the shell, you can start building from [Downloading the Source: Initializing a Repo client](https://source.android.com/setup/build/downloading), every tools required is ready.

```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "you@example.com"
####### checkout a branch for AOSP 7.1: android-7.1.2_r39
$ repo init -u https://android.googlesource.com/platform/manifest -b android-7.1.2_r39
$ repo sync
```

## Building AOSP ROM

once you run your docker container, you can build AOSP with usual commands:

```shell
$ cpus=$(grep ^processor /proc/cpuinfo | wc -l)
#### set the cache size to 10G
$ prebuilts/misc/linux-x86/ccache/ccache -M 10G
#### build you ARM device
$ source build/envsetup.sh
$ lunch aosp_arm-eng
$ make -j $cpus
```

## License
This application is released under GNU GPLv3 (see [LICENSE](https://github.com/islem19/AOSP-Build-on-Docker/blob/master/LICENSE)). Some of the used libraries are released under different licenses.
