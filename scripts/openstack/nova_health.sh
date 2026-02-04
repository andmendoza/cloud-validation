#!/usr/bin/env bash
set -e
set -o pipefail

export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
CLOUD_NAME="all-in-one"
VM_NAME="test-vm-$(date +%s)"
IMAGE_NAME="cirros"      # Ajusta a una imagen disponible
FLAVOR_NAME="m1.tiny"    # Ajusta a un flavor disponible
NETWORK_NAME="private"    # Ajusta a la red que exista

echo "=== Validando Nova en $CLOUD_NAME ==="

# Emitir token (verifica que Keystone funcione)
echo "Comprobando autenticación..."
openstack --os-cloud $CLOUD_NAME token issue

# Crear VM
echo "Creando servidor $VM_NAME..."
SERVER_ID=$(openstack --os-cloud $CLOUD_NAME server create \
    --image $IMAGE_NAME \
    --flavor $FLAVOR_NAME \
    --network $NETWORK_NAME \
    --wait \
    -f value -c id \
    $VM_NAME)

echo "[OK] Servidor creado: $SERVER_ID"

# Verificar scheduler (dónde se programó)
HOST=$(openstack --os-cloud $CLOUD_NAME server show $SERVER_ID -f value -c OS-EXT-SRV-ATTR:host)
echo "[INFO] Servidor $VM_NAME fue programado en host: $HOST"

# Borrar VM
echo "Eliminando servidor $VM_NAME..."
openstack --os-cloud $CLOUD_NAME server delete $SERVER_ID --wait
echo "[OK] Servidor eliminado"

echo "=== Validación Nova completada ==="
