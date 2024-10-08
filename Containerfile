# pull in the ublue minimal image
FROM ghcr.io/ublue-os/base-main:latest
# setup rpmfusion repos
# install packages
RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN rpm-ostree install rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted

RUN rpm-ostree install cage kodi kodi-inputstream-adaptive kodi-pvr-iptvsimple kodi-firewalld nfs-utils samba podman
# install extra tools
RUN rpm-ostree install tmux htop bmon vim micro nano

# now we need to get kodi to automagically launch on boot
WORKDIR /
COPY systemd/kodi-wayland.service /etc/systemd/system/kodi-wayland.service
RUN systemctl enable kodi-wayland.service

# copy over out example mounts
COPY systemd/var-mnt-nfs-media.mount /etc/systemd/system/var-mnt-nfs-media.mount
COPY systemd/var-mnt-smb-media.mount /etc/systemd/system/var-mnt-smb-media.mount

# enable ssh access
RUN systemctl enable sshd.service

# ok lets add user accounts

COPY systemd/generate-user-admin.service /etc/systemd/system/generate-user-admin.service
COPY systemd/generate-user-kodi.service /etc/systemd/system/generate-user-kodi.service
RUN systemctl enable generate-user-admin.service
RUN systemctl enable generate-user-kodi.service

# lets see if restorecon can save us
RUN restorecon -Rv /etc/systemd/system/generate-user-admin.service
RUN restorecon -Rv /etc/systemd/system/generate-user-kodi.service
 

# and now thats done lets ensure the default target is graphical
RUN systemctl set-default graphical.target

# then lets cleaup after ourselves
RUN rm -rf /tmp /var
  
