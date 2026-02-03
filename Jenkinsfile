pipeline {
    agent {
        docker {
            image 'python:3.13-slim'
            args '-u root'
        }
    }

    environment {
        VENV_DIR = "${WORKSPACE}/openstack-venv"
        OS_CLIENT_CONFIG_FILE = "${WORKSPACE}/.config/openstack/clouds.yaml"
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
                    ${VENV_DIR}/bin/pip install --upgrade pip
                    ${VENV_DIR}/bin/pip install python-openstackclient
                '''
            }
        }

        stage('Check OpenStack version') {
            steps {
                sh '''
                    ${VENV_DIR}/bin/openstack --version
                '''
            }
        }

        stage('OpenStack Services Health (No Auth)') {
            steps {
                sh '''
                    chmod +x scripts/openstack/services_health.sh
                    bash scripts/openstack/services_health.sh
                '''
            }
        }

        stage('Keystone health') {
            steps {
                sh '''
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
