#!/bin/bash

DIRECTORY=/home/akerman/Downloads

if [ ! -d DIRECTORY ]; then
  echo "El directorio  $DIRECTORY no  existe"
  exit 1
fi

for ARCHIVO in "DIRECTORY"/*; do
  if [[ "$ARCHIVO" =~ \.iso$ ]]; then
    continue
  else
    echo $ARCHIVO
    rm "$ARCHIVO"
  fi
done
