#! /bin/sh

CONFIG_DIR="/home/arti/.config/arti"
CONFIG_FILE_PATH="$CONFIG_DIR/arti.toml"

if [ ! -f $CONFIG_FILE_PATH ]; then
  mkdir -p $CONFIG_DIR
  echo "[proxy]
socks_listen = \"0.0.0.0:9150\"" > $CONFIG_FILE_PATH
fi

arti "$@"