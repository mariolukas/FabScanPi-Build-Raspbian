FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && \
    apt-get -y install \
        git vim parted \
        binfmt-support qemu qemu-user-static debootstrap kpartx lvm2 dosfstools apt-cacher-ng fakeroot sudo

RUN mkdir /home/dev
WORKDIR /home/dev

CMD ["./raspbian/build_raspbian_sd_card.sh"]
