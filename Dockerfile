# FROM resin/rpi-raspbian
#FROM balenalib/rpi-raspbian
ARG ARCH=
FROM ${ARCH}debian:bullseye

RUN apt-get update && \
    apt-get -y install gnupg2 alsa-utils libasound2-plugin-equal gettext curl apt-transport-https && \
    update-ca-certificates --fresh && \
    curl -skSL https://dtcooper.github.io/raspotify/key.asc | apt-key add -v - && \
    echo 'deb https://dtcooper.github.io/raspotify raspotify main' | tee /etc/apt/sources.list.d/raspotify.list && \
    apt-get update && \
    apt-get -y install raspotify && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN curl -sL https://dtcooper.github.io/raspotify/install.sh | sh

ENV SPOTIFY_NAME RaspotifySpeaker
ENV USER ''
ENV PASS ''
ENV BACKEND_NAME 'alsa'
ENV DEVICE_NAME 'equal'
ENV ALSA_SLAVE_PCM 'plughw:0,0'
ENV ALSA_SOUND_LEVEL '100%'
ENV VERBOSE 'false'
ENV EQUALIZATION ''

COPY /asound.conf /
COPY /equalizer.sh /
COPY /raspotify_config.default /etc/raspotify/conf

COPY /startup.sh /
ENTRYPOINT /startup.sh
