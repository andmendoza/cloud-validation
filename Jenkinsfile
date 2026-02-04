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
                    python3 --version
                '''
            }
        }

        stage('Create venv & install OpenStack') {
            steps {
                sh '''
                    set -e

                    if [ ! -d "${VENV_DIR}" ]; then
                        python3 -m venv ${VENV_DIR}
                    fi

                    ${VENV_DIR}/bin/python -m pip install --upgrade pip
                    ${VENV_DIR}/bin/pip install python-openstackclient
                '''
            }
        }

        stage('Check OpenStack version') {
            steps {
                sh '''
                    set -e
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
                        echo "ERROR: clouds.yaml no encontrado en $OS_CLIENT_CONFIG_FILE"
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
        failure {
            echo ' Pipeline fallida'
        }
        success {
            echo ' Validación cloud completada'
        }
    }
}
