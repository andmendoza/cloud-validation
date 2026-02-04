pipeline {
    agent any

    environment {
        VENV_DIR = "${WORKSPACE}/openstack-venv"
        OS_CLIENT_CONFIG_FILE = "${WORKSPACE}/.config/openstack/clouds.yaml"
        OPENSTACK_PY = "${VENV_DIR}/bin/python -m openstack"
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

        stage('Create venv & install OpenStack') {
            steps {
                sh '''
                    python3 -m venv ${VENV_DIR}
                    ${VENV_DIR}/bin/python -m ensurepip --upgrade
                    ${VENV_DIR}/bin/pip install --upgrade pip
                    ${VENV_DIR}/bin/pip install python-openstackclient
                '''
            }
        }

        stage('Check OpenStack version') {
            steps {
                sh '''
                    echo "OpenStack version:"
                    ${OPENSTACK_PY} --version
                '''
            }
        }

        stage('OpenStack Services Health (No Auth)') {
            steps {
                sh '''
                    chmod +x scripts/openstack/services_health.sh
                    ${VENV_DIR}/bin/bash scripts/openstack/services_health.sh
                '''
            }
        }

        stage('Keystone Health') {
            steps {
                sh '''
                    chmod +x scripts/openstack/keystone.sh
                    ${VENV_DIR}/bin/bash scripts/openstack/keystone.sh
                '''
            }
        }
    }

    post {
        always {
            echo 'Archiving reports (if any)...'
            archiveArtifacts artifacts: 'reports/**', fingerprint: true
        }
    }
}
