#!/usr/bin/env bash
set -e
set -o pipefail

export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
CLOUD_NAME="all-in-one"
DOWNLOAD_DIR="${WORKSPACE}/glance_downloads"

echo "=== Validando Glance en $CLOUD_NAME ==="

# Crear carpeta temporal para descargas
mkdir -p $DOWNLOAD_DIR

# Listar imágenes
echo "Listando imágenes disponibles..."
openstack --os-cloud $CLOUD_NAME image list

# Descargar la primera imagen disponible como prueba
IMAGE_ID=$(openstack --os-cloud $CLOUD_NAME image list -f value -c ID | head -n 1)

if [ -z "$IMAGE_ID" ]; then
    echo "[WARN] No hay imágenes disponibles para descargar"
else
    echo "Descargando imagen $IMAGE_ID..."
    openstack --os-cloud $CLOUD_NAME image save --file $DOWNLOAD_DIR/${IMAGE_ID}.qcow2 $IMAGE_ID
    echo "[OK] Imagen descargada en $DOWNLOAD_DIR/${IMAGE_ID}.qcow2"

    # Limpiar descarga
    rm -f $DOWNLOAD_DIR/${IMAGE_ID}.qcow2
    echo "[OK] Archivo temporal eliminado"
fi

echo "=== Validación Glance completada ==="
