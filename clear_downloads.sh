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

# Vemos si existe el folder donde almacenaremos los iso
if [ ! -d "$DOCDIRECTORY/isos/" ]; then
  echo "[INFO] Creando la carpeta isos"
  mkdir "$DOCDIRECTORY/isos"
  chmod 777 "$DOCDIRECTORY/isos"
  
fi

for ARCHIVO in "$DIRECTORY"/*; do
  if [[ "$ARCHIVO" =~ \.iso$ ]]; then
    mv $ARCHIVO "$DOCDIRECTORY/isos"
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

echo "[INFO] Se movieron $ISOMOVED imagenes ISO hacia Documents/isos"
echo "[INFO] Se eliminaron $DELETED archivos"
echo "[INFO] Podes ver que ficheros fueron eliminados en $DOCDIRECTORY"
