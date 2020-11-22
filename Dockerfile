FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y wget build-essential cmake git

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

# Everything needed is now in /usr/local/lib, so /tmp/sczr can be safely deleted
WORKDIR /root
RUN rm -r /tmp/sczr

COPY ./src /root/src
COPY ./examples /root/examples
