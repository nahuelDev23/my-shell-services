#!/bin/bash

DOCDIRECTORY=/home/akerman/Documents
DIRECTORY=/home/akerman/Downloads
ISOMOVED=0
DELETED=0

# VEMOS SI EXISTE EL DIRECTORIO DOWNLOADS
if [ ! -d "$DIRECTORY" ]; then
  echo "El directorio  $DIRECTORY no  existe"
  exit 1
fi

# Vemos si existe el fichero de logs de todos los eliminados.
if [ ! -f "$DOCDIRECTORY/deleted.log" ]; then
  echo "[INFO] Creando fichero deleted.log"
  touch "$DOCDIRECTORY/deleted.log"
  chmod 644 "$DOCDIRECTORY/deleted.log"
  
fi

for ARCHIVO in "$DIRECTORY"/*; do
  if [[ "$ARCHIVO" =~ \.iso$ ]]; then
    mv $ARCHIVO "$DOCDIRECTORY"
    ((ISOMOVED++))
    continue
  else
    BASENAME=$(basename "$ARCHIVO")
    echo "[WARNING] $ARCHIVO fue eliminado"
    echo "$BASENAME" >> "$DOCDIRECTORY/deleted.log"
    ((DELETED++))
    rm -Rf "$ARCHIVO"
    
  fi
done

echo "[INFO] Se movieron $ISOMOVED hacia Documents"
echo "[INFO] Se eliminaron $DELETED archivos"
echo "[INFO] Podes ver que ficheros fueron eliminados en $DOCDIRECTORY"
