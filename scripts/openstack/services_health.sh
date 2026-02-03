#!/usr/bin/env bash
set -e

check_service () {
  NAME=$1
  URL=$2

  echo "=== Validando $NAME ==="
  HTTP_CODE=$(curl -k -s -o /dev/null -w "%{http_code}" "$URL")

  if [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 500 ]; then
    echo "[OK] $NAME responde (HTTP $HTTP_CODE)"
  else
    echo "[FAIL] $NAME no responde correctamente (HTTP $HTTP_CODE)"
    exit 1
  fi
}

check_service "Horizon"   "https://all-in-one.systemstackmr.com/"
check_service "Keystone"  "https://all-in-one.systemstackmr.com/identity/"
check_service "Nova"      "https://all-in-one.systemstackmr.com/compute/v2.1"
check_service "Glance"    "https://all-in-one.systemstackmr.com/image/v2"
check_service "Neutron"   "https://all-in-one.systemstackmr.com/network/v2.0"
check_service "Cinder"    "https://all-in-one.systemstackmr.com/volume/v3"
check_service "Placement" "https://all-in-one.systemstackmr.com/placement/"

echo "=== Todos los servicios responden ==="
