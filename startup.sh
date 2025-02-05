#!/bin/bash

set -x
set -e

echo "Preparing container..."

echo "SPOTIFY_NAME=$SPOTIFY_NAME"
echo "BACKEND_NAME=$BACKEND_NAME"
echo "DEVICE_NAME=$DEVICE_NAME"
echo "USER=$USER"
echo "PASS=$PASS"
echo "LIBRESPOT_DISABLE_DISCOVERY=$LIBRESPOT_DISABLE_DISCOVERY"

if [ "$VERBOSE" == "true" ]; then
  VERB="-v"
else
  VERB=""
fi

if [ "$BACKEND_NAME" != "" ]; then
  BACKEND="--backend $BACKEND_NAME"
else
  BACKEND=""
fi

if [ "$DEVICE_NAME" != "" ]; then
  DEVICE="--device $DEVICE_NAME"
else
  DEVICE=""
fi

if [ "$USER" != "" ]; then
  USER="-u $USER"
else
  USER=""
fi

if [ "$PASS" != "" ]; then
  PASS="-p $PASS"
else
  PASS=""
fi

if [ "$LIBRESPOT_DISABLE_DISCOVERY" != "" ]; then
  export LIBRESPOT_DISABLE_DISCOVERY="$LIBRESPOT_DISABLE_DISCOVERY"
else
  LIBRESPOT_DISABLE_DISCOVERY=""
fi

if [ "$DEVICE_NAME" == "equal" ]; then
  if [ "$ALSA_SLAVE_PCM" == "" ]; then
    echo "ALSA_SLAVE_PCM must be defined. eg. use 'plughw:0,0' for device at card 0, sub 0"
    exit 1
  fi
fi

echo "/etc/asound.conf"
envsubst < /asound.conf > /etc/asound.conf
cat /etc/asound.conf
echo ''

if [ "$EQUALIZATION" != "" ]; then
  echo "Applying equalization $EQUALIZATION"
  /equalizer.sh "$EQUALIZATION"
fi

set +e
if [ "$ALSA_SOUND_LEVEL" != "" ]; then
  echo "Applying sound level to $ALSA_SOUND_LEVEL"
  #TODO: enhance this logic
  amixer cset numid=1 "$ALSA_SOUND_LEVEL"
  amixer cset numid=2 "$ALSA_SOUND_LEVEL"
  amixer cset numid=3 "$ALSA_SOUND_LEVEL"
  amixer cset numid=4 "$ALSA_SOUND_LEVEL"
  amixer cset numid=5 "$ALSA_SOUND_LEVEL"
  amixer cset numid=6 "$ALSA_SOUND_LEVEL"
  amixer cset numid=7 "$ALSA_SOUND_LEVEL"
  amixer cset numid=8 "$ALSA_SOUND_LEVEL"
fi
set -e

echo "Starting Raspotify..."
/usr/bin/librespot $VERB --name "$SPOTIFY_NAME" $BACKEND $DEVICE $USER $PASS --bitrate 320 --disable-audio-cache --enable-volume-normalisation

