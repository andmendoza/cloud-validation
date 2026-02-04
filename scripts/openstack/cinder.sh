#!/usr/bin/env bash
set -e
set -o pipefail

export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
CLOUD_NAME="all-in-one"

# Nombres temporales
VM_NAME="cinder-vm-$(date +%s)"
VOLUME_NAME="test-volume-$(date +%s)"
IMAGE_NAME="cirros"      # Ajusta a una imagen existente
FLAVOR_NAME="m1.tiny"    # Ajusta a un flavor existente
NETWORK_NAME="private"    # Ajusta a una red existente

echo "=== Validando Cinder en $CLOUD_NAME ==="

# Crear volumen
echo "Creando volumen $VOLUME_NAME (1GB)..."
openstack --os-cloud $CLOUD_NAME volume create --size 1 $VOLUME_NAME
echo "[OK] Volumen creado: $VOLUME_NAME"

# Crear VM temporal
echo "Creando VM temporal $VM_NAME..."
VM_ID=$(openstack --os-cloud $CLOUD_NAME server create \
    --image $IMAGE_NAME \
    --flavor $FLAVOR_NAME \
    --network $NETWORK_NAME \
    --wait \
    -f value -c id \
    $VM_NAME)
echo "[OK] VM creada: $VM_ID"

# Adjuntar volumen a VM
echo "Adjuntando volumen $VOLUME_NAME a VM $VM_NAME..."
openstack --os-cloud $CLOUD_NAME server add volume $VM_ID $VOLUME_NAME --wait
echo "[OK] Volumen adjuntado"

# Desadjuntar volumen
echo "Desadjuntando volumen $VOLUME_NAME de VM $VM_NAME..."
openstack --os-cloud $CLOUD_NAME server remove volume $VM_ID $VOLUME_NAME --wait
echo "[OK] Volumen desadjuntado"

# Limpiar recursos
echo "Eliminando VM temporal $VM_NAME..."
openstack --os-cloud $CLOUD_NAME server delete $VM_ID --wait
echo "Eliminando volumen $VOLUME_NAME..."
openstack --os-cloud $CLOUD_NAME volume delete $VOLUME_NAME
echo "[OK] Recursos de Cinder eliminados"

echo "=== Validación Cinder completada ==="
