pipeline {
    agent any

    environment {
        VENV_DIR = "${WORKSPACE}/openstack-venv"
        OS_CLIENT_CONFIG_FILE = "${WORKSPACE}/.config/openstack/clouds.yaml"
    }

    stages {
        stage('Run OpenStack Validation') {
            agent {
                docker {
                    image 'python:3.13-slim'
                    args '-u root'
                }
            }
            steps {
                sh '''
                    echo "Inicio validación cloud"
                    date

                    echo "Creando virtualenv..."
                    python3 -m venv ${VENV_DIR}
                    ${VENV_DIR}/bin/pip install --upgrade pip
                    ${VENV_DIR}/bin/pip install python-openstackclient

                    echo "Verificando OpenStack CLI..."
                    ${VENV_DIR}/bin/openstack --version

                    echo "Ejecutando OpenStack Services Health..."
                    chmod +x scripts/openstack/services_health.sh
                    bash scripts/openstack/services_health.sh

                    echo "Ejecutando Keystone health check..."
                    export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
                    chmod +x scripts/openstack/keystone.sh
                    . ${VENV_DIR}/bin/activate
                    bash scripts/openstack/keystone.sh
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**', fingerprint: true
        }
    }
}
