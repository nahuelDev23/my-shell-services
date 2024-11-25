#!/bin/bash

DOCDIRECTORY=$HOME/Documents
DIRECTORY=$HOME/Downloads
IMPORTANT_EXTENSIONS=("iso" "deb") # Array corregido
ISOMOVED=0
DELETED=0

# VEMOS SI EXISTE EL DIRECTORIO DOWNLOADS
if [ ! -d "$DIRECTORY" ]; then
  echo "El directorio $DIRECTORY no existe"
  exit 1
fi

# Vemos si existe el fichero de logs de todos los eliminados
if [ ! -f "$DOCDIRECTORY/deleted.log" ]; then
  echo "[INFO] Creando fichero deleted.log"
  touch "$DOCDIRECTORY/deleted.log"
  chmod 644 "$DOCDIRECTORY/deleted.log"
fi

# Crear directorios para extensiones importantes
for EXTENSION in "${IMPORTANT_EXTENSIONS[@]}"; do
  if [ ! -d "$DOCDIRECTORY/$EXTENSION/" ]; then
    echo "[INFO] Creando la carpeta $EXTENSION"
    mkdir -p "$DOCDIRECTORY/$EXTENSION"
    chmod 777 "$DOCDIRECTORY/$EXTENSION"
  fi
done

# Procesar los archivos en Downloads
for ARCHIVO in "$DIRECTORY"/*; do
  # Ignorar si no es un archivo regular
  if [ ! -f "$ARCHIVO" ]; then
    continue
  fi

  MOVED=0
  BASENAME=$(basename "$ARCHIVO")

  for EXTENSION in "${IMPORTANT_EXTENSIONS[@]}"; do
    if [[ "$BASENAME" == *.$EXTENSION ]]; then
      mv "$ARCHIVO" "$DOCDIRECTORY/$EXTENSION/"
      echo "[INFO] Movido $BASENAME a $DOCDIRECTORY/$EXTENSION/"
      ((ISOMOVED++))
      MOVED=1
      break # Salir del bucle de extensiones si se movió el archivo
    fi
  done

  # Si no se movió, eliminar y registrar en el log
  if [ $MOVED -eq 0 ]; then
    echo "[WARNING] $BASENAME fue eliminado"
    echo "$BASENAME" >>"$DOCDIRECTORY/deleted.log"
    ((DELETED++))
    rm -Rf "$ARCHIVO"
  fi
done

# Informar resultados
echo "[INFO] Se movieron $ISOMOVED archivos con extensiones importantes a Documents"
echo "[INFO] Se eliminaron $DELETED archivos no importantes"
echo "[INFO] Podes ver qué ficheros fueron eliminados en $DOCDIRECTORY/deleted.log"
