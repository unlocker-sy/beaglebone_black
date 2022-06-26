FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i s/archive.ubuntu.com/ftp.daumkakao.com/g /etc/apt/sources.list
RUN apt-get clean
RUN apt-get update 

# RUN apt-get install -y git bc bison flex libssl-dev make

# for cross compile
# RUN apt-get install -y git bc bison flex libssl-dev make libc6-dev libncurses5-dev

# Install the 32-bit Toolchain for a 32-bit Kernel
# # RUN apt-get install -y crossbuild-essential-armhf

RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping libsdl1.2-dev xterm

# Install the 64-bit Toolchain for a 64-bit Kernel
# RUN apt-get install -y crossbuild-essential-arm64

VOLUME /workdir
WORKDIR /workdir/bbb

CMD ["/bin/bash"]
