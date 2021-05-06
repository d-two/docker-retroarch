ARG BASE_IMAGE_PREFIX

FROM multiarch/qemu-user-static as qemu

FROM ${BASE_IMAGE_PREFIX}ubuntu:18.04

COPY --from=qemu /usr/bin/qemu-*-static /usr/bin/

RUN \
  apt-get update && \
  apt-get install -y software-properties-common --no-install-recommends && \
  add-apt-repository ppa:libretro/stable && \
  apt-get update && \
  apt-get install -y libretro-* retroarch* && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/bin/qemu-*-static

RUN adduser --disabled-password --gecos '' retroarch \
 && adduser retroarch sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER retroarch

ENTRYPOINT [ "/usr/bin/retroarch" ]
