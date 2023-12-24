FROM ghcr.io/ublue-os/base-main:latest
run rpm-ostree install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
RUN rpm-ostree install cage kodi kodi-inputstream-adaptive kodi-pvr-iptvsimple kodi-firewalld nfs-utils flatpak samba

# lets make a user account for the kodi user so we can have a persistent config
useradd -m -G video,audio,kodi -s /bin/bash kodi

# now we need to get kodi to automagically launch on boot
WORKDIR /
COPY systemd/kodi-wayland.service /etc/systemd/system/kodi-wayland.service
RUN systemctl enable kodi-wayland.service

# copy over out example nfs mount
COPY systemd/var-mnt-nfs-media.mount /etc/systemd/system/var-mnt-nfs-media.mount
COPY systemd/var-mnt-smb-media.mount /etc/systemd/system/var-mnt-smb-media.mount

# enable ssh access
RUN systemctl enable sshd.service

RUN rm -rf /tmp /var

