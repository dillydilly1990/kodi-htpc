FROM ghcr.io/ublue-os/base-main:latest
RUN rpm-ostree install cage kodi
WORKDIR /
RUN git clone https://github.com/graysky2/kodi-standalone-service.git
WORKDIR kodi-standalone-service
RUN make install
RUN systemctl enable kodi-wayland.service

RUN rm -rf /tmp /var
