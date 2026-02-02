pipeline {
    agent any

    environment {
        WORKSPACE_DIR = "/var/jenkins_home/cloud-validation"
        VENV_DIR = "${WORKSPACE_DIR}/openstack-venv"
        OS_CLIENT_CONFIG_FILE = "~/.config/openstack /clouds.yaml"
    }
    stages {
        stage('Info') {
            steps {
                sh '''
                    echo "Inicio validación cloud"
                    date
                '''
            }
        }

        stage('Create clean venv') {
            steps {
                sh '''
                python3 -m venv ${VENV_DIR}
                ${VENV_DIR}/bin/python -m ensurepip --upgrade
                '''
            }
        }

        stage('Install OpenStack CLI') {
            steps {
                sh '''
                ${VENV_DIR}/bin/pip install -U pip && \
                ${VENV_DIR}/bin/pip install python-openstackclient
                '''
            }
        }

        stage('Check version') {
            steps {
                sh '''
                ${VENV_DIR}/bin/openstack --version
                '''
            }
        }
        stage('Preparar entorno OpenStack') {
            steps {
                sh '''
                    . ${VENV_DIR}/bin/activate
                    openstack --version
                '''
            }
        }
        stage('Keystone health') {
            steps {
                sh '''
                    . ${VENV_DIR}/bin/activate
                    export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
                    chmod +x scripts/openstack/keystone.sh
                    scripts/openstack/keystone.sh
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
