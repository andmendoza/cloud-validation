#!/usr/bin/env bash
set -e
set -o pipefail

export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
CLOUD_NAME="all-in-one"
NETWORK_NAME="test-net-$(date +%s)"
SUBNET_NAME="test-subnet-$(date +%s)"
SUBNET_CIDR="192.168.100.0/24"
SEC_GROUP_NAME="test-secgroup-$(date +%s)"

echo "=== Validando Neutron en $CLOUD_NAME ==="

# Crear red
echo "Creando red $NETWORK_NAME..."
openstack --os-cloud $CLOUD_NAME network create $NETWORK_NAME
echo "[OK] Red creada: $NETWORK_NAME"

# Crear subred
echo "Creando subred $SUBNET_NAME (CIDR $SUBNET_CIDR)..."
openstack --os-cloud $CLOUD_NAME subnet create --network $NETWORK_NAME --subnet-range $SUBNET_CIDR $SUBNET_NAME
echo "[OK] Subred creada: $SUBNET_NAME"

# Crear security group
echo "Creando Security Group $SEC_GROUP_NAME..."
openstack --os-cloud $CLOUD_NAME security group create $SEC_GROUP_NAME
echo "[OK] Security Group creado: $SEC_GROUP_NAME"

# Limpiar: eliminar subred, red y security group
echo "Eliminando recursos de prueba..."
openstack --os-cloud $CLOUD_NAME security group delete $SEC_GROUP_NAME
openstack --os-cloud $CLOUD_NAME subnet delete $SUBNET_NAME
openstack --os-cloud $CLOUD_NAME network delete $NETWORK_NAME
echo "[OK] Recursos de Neutron eliminados"

echo "=== Validación Neutron completada ==="
