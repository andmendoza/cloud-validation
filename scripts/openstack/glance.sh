#!/usr/bin/env bash
set -e
export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
CLOUD_NAME="all-in-one"
DOWNLOAD_DIR="${WORKSPACE}/glance_downloads"

mkdir -p $DOWNLOAD_DIR

echo "=== Validando Glance en $CLOUD_NAME ==="

IMAGES=$(openstack --os-cloud $CLOUD_NAME image list -f value -c ID || true)
IMAGE_ID=$(echo "$IMAGES" | head -n 1)

if [ -z "$IMAGE_ID" ]; then
    echo "[WARN] No hay imágenes disponibles para descargar"
else
    echo "Descargando imagen $IMAGE_ID..."
    openstack --os-cloud $CLOUD_NAME image save --file $DOWNLOAD_DIR/${IMAGE_ID}.qcow2 $IMAGE_ID
    echo "[OK] Imagen descargada"
    rm -f $DOWNLOAD_DIR/${IMAGE_ID}.qcow2
fi

echo "=== Validación Glance completada ==="
