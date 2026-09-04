FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ARG DEBIAN_FRONTEND="noninteractive"

# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

COPY /root/ /

RUN echo "**** installing packages ****"
RUN add-apt-repository -y ppa:mozillateam/ppa
RUN apt-get update
# Added 'gosu' to the installation packages list
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y firefox wget gosu
RUN chmod +x /install-de.sh
RUN /install-de.sh

RUN \
  chmod +x /installapps.sh && \
  /installapps.sh && \
  rm /installapps.sh

RUN \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# BYPASS WORKAROUND: Configure a backdoor command 'to-root' that runs natively as root without using sudo
RUN echo '#!/bin/sh\nexec gosu root bash' > /usr/local/bin/to-root && \
    chmod +x /usr/local/bin/to-root && \
    chmod +s /usr/local/bin/to-root

# ports and volumes
EXPOSE 3000
VOLUME /config
