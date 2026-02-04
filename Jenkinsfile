pipeline {
    agent any

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
                    ${VENV_DIR}/bin/bash scripts/openstack/services_health.sh
                '''
            }
        }

        stage('Keystone health') {
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
            archiveArtifacts artifacts: 'reports/**', fingerprint: true
        }
    }
}
