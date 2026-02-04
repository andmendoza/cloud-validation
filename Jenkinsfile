pipeline {
    agent any

    environment {
        VENV_DIR = "${WORKSPACE}/openstack-venv"
        OS_CLIENT_CONFIG_FILE = "${WORKSPACE}/.config/openstack/clouds.yaml"
        PATH = "${VENV_DIR}/bin:${env.PATH}"
    }

    stages {

        stage('Info') {
            steps {
                sh '''
                    set -e
                    echo "Inicio validación cloud"
                    date
                    whoami
                '''
            }
        }

        stage('Check venv') {
            steps {
                sh '''
                    set -e

                    if [ ! -x "${VENV_DIR}/bin/openstack" ]; then
                        echo "ERROR: venv no existe o openstack no está instalado"
                        exit 1
                    fi

                    python --version
                    openstack --version
                '''
            }
        }

        stage('Keystone health') {
            steps {
                sh '''
                    set -e

                    export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}

                    if [ ! -f "$OS_CLIENT_CONFIG_FILE" ]; then
                        echo "ERROR: clouds.yaml no encontrado"
                        exit 1
                    fi

                    chmod +x scripts/openstack/keystone.sh
                    bash scripts/openstack/keystone.sh
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/**', fingerprint: true, allowEmptyArchive: true
        }
    }
}
