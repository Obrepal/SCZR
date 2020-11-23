FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y wget build-essential cmake git
     # libortp-dev

WORKDIR /tmp/sczr

# Download and install c-ares (DNS management package)
RUN wget https://c-ares.haxx.se/download/c-ares-1.17.1.tar.gz
RUN tar -xvf c-ares-1.17.1.tar.gz
RUN cd c-ares-1.17.1 && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install

# Download and install exosip2 (extended osip2 library SIP protocol)
RUN wget http://ftp.gnu.org/gnu/osip/libosip2-5.2.0.tar.gz
RUN tar -xvf libosip2-5.2.0.tar.gz
RUN cd libosip2-5.2.0 && \
    ./configure && \
    make && make install

# Download and install exosip2 (extended osip2 library SIP protocol)
RUN wget http://download.savannah.nongnu.org/releases/exosip/libexosip2-5.2.0.tar.gz
RUN tar -xvf libexosip2-5.2.0.tar.gz
RUN cd libexosip2-5.2.0 && \
    ./configure && \
    make && make install

# Download and install libsoundio (Sound input/output library)
RUN git clone https://github.com/andrewrk/libsoundio.git
RUN cd libsoundio && \
    mkdir build && cd build && \
    cmake .. && \
    make && make install

RUN apt-get update && \
    apt-get install -y python python3 autotools-dev autoconf automake libtool \
                       intltool pkg-config libspeex-dev python-pip yasm nasm doxygen \
                       libx11-dev libpulse-dev pulseaudio apulse

RUN pip install pystache six

RUN git clone --recurse-submodules -j8 https://gitlab.linphone.org/BC/public/linphone-sdk.git
RUN cd linphone-sdk && \
    mkdir build && cd build && \
    cmake .. && cmake --build .


# RUN wget http://download.savannah.nongnu.org/releases/linphone/mediastreamer/mediastreamer-2.9.0.tar.gz
# RUN tar -xvf mediastreamer-2.9.0.tar.gz
# RUN cd mediastreamer-2.9.0 && \
#     ./configure && \
#     make && makeinstall

# Download and install mediastreamer2 (Sound streaming)
# RUN git clone https://github.com/ARMmbed/mbedtls.git
# RUN cd mbedtls && \
#     make && make install
#
# RUN git clone https://github.com/BelledonneCommunications/bcunit.git
# RUN cd bcunit && \
#     ln -s README.md README && \
#     autoreconf --install --force && \
#     cmake . && \
#     make && make install
#
# RUN git clone https://github.com/BelledonneCommunications/bctoolbox.git
# RUN cd bctoolbox && \
#     cmake -ENABLE_TESTS=NO -ENABLE_TESTS_COMPONENT=NO -fPIC . && \
#     make && make install
#
# RUN git clone https://github.com/BelledonneCommunications/ortp.git
# RUN cd ortp && \
#     cmake . && \
#     make && make install
#
# RUN git clone https://github.com/BelledonneCommunications/mediastreamer2.git
# RUN cd mediastreamer2 && \
#     cmake . && \
#     make && make install

# Everything needed is now in /usr/local/lib, so /tmp/sczr can be safely deleted
WORKDIR /root
RUN rm -r /tmp/sczr

COPY ./src /root/src
COPY ./examples /root/examples
