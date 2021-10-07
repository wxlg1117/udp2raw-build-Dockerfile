FROM ubuntu:latest
ENV TZ=Asia/Shanghai

# install all the Linux build dependencies;
RUN apt-get update; \
    apt-get install git wget bzip2 -y; \
    apt-get install build-essential g++-mingw-w64-i686 -y

# download cross compile tool chain;
RUN cd /; \
    wget -q https://github.com/wangyu-/files/releases/download/files/toolchains.tar.gz; \
    tar -zxf toolchains.tar.gz; \
    cd /toolchains; \
    wget -q http://archive.openwrt.org/releases/17.01.2/targets/x86/64/lede-sdk-17.01.2-x86-64_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz; \
    xz -d lede-sdk-17.01.2-x86-64_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz; \
    tar xf lede-sdk-17.01.2-x86-64_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar; \
    wget -q http://archive.openwrt.org/releases/17.01.2/targets/x86/generic/lede-sdk-17.01.2-x86-generic_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz; \
    xz -d lede-sdk-17.01.2-x86-generic_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar.xz; \
    tar xf lede-sdk-17.01.2-x86-generic_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar; \
    wget -q http://archive.openwrt.org/releases/17.01.2/targets/bcm53xx/generic/lede-sdk-17.01.2-bcm53xx_gcc-5.4.0_musl-1.1.16_eabi.Linux-x86_64.tar.xz; \
    xz -d lede-sdk-17.01.2-bcm53xx_gcc-5.4.0_musl-1.1.16_eabi.Linux-x86_64.tar.xz; \
    tar xf lede-sdk-17.01.2-bcm53xx_gcc-5.4.0_musl-1.1.16_eabi.Linux-x86_64.tar; \
    wget -q https://archive.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2; \
    bzip2 -d OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2; \
    tar xf OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar

# clean up the tool files;
Run rm -rf /toolchains.tar.gz; \
    rm -rf /toolchains/lede-sdk-17.01.2-x86-64_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar; \
    rm -rf /toolchains/lede-sdk-17.01.2-x86-generic_gcc-5.4.0_musl-1.1.16.Linux-x86_64.tar; \
    rm -rf /toolchains/lede-sdk-17.01.2-bcm53xx_gcc-5.4.0_musl-1.1.16_eabi.Linux-x86_64.tar; \
    rm -rf /toolchains/OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar

# clone git code;
RUN cd /usr/local/src; \
    git clone --recursive https://github.com/wangyu-/udp2raw-tunnel.git

# modify makefile;
RUN sed -i 's#home/wangyu/Desktop#toolchains#g' /usr/local/src/udp2raw-tunnel/makefile; \
    sed -i 's#mingw_cross_wepoll mac_cross##g' /usr/local/src/udp2raw-tunnel/makefile; \
    sed -i 's#\${NAME}_mp_wepoll.exe \${NAME}_mp_mac ##g' /usr/local/src/udp2raw-tunnel/makefile

# build a full release;
RUN cd /usr/local/src/udp2raw-tunnel/; \
    make release; \
    make release_mp