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
    apt-get install -y libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc \
    gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 gstreamer1.0-pulseaudio

# enable real time scheduling
RUN echo 'kernel.sched_rt_runtime_us=-1' > /etc/sysctl.conf

RUN echo '@realtime   -  rtprio     99\n@realtime   -  memlock    unlimited' \
    > /etc/security/limits.d/99-realtime.conf
RUN groupadd realtime
RUN usermod -a -G realtime root

# Everything needed is now in /usr/local/lib, so /tmp/sczr can be safely deleted
WORKDIR /root
RUN rm -rf /tmp/sczr

COPY ./src /root/src
COPY ./examples /root/examples

RUN cd src && gcc main.c -o main `pkg-config --cflags --libs gstreamer-1.0`

CMD apt-get update && apt-get install jackd2
