#!/bin/bash
set -e

# Exporta la configuración
export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}

echo "=== Probando autenticación con Keystone ==="
# Obtén un token válido
TOKEN=$(${VENV_DIR}/bin/openstack token issue -f value -c id)

if [ -z "$TOKEN" ]; then
    echo "Error: No se pudo emitir token"
    exit 1
fi

echo "Token emitido correctamente: $TOKEN"

# Validación del token
${VENV_DIR}/bin/openstack token validate $TOKEN

echo "Token validado correctamente"
