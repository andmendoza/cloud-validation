pipeline {
    agent any
    environment {
        WORKSPACE_DIR = "/var/jenkins_home/cloud-validation"
        VENV_DIR = "${WORKSPACE_DIR}/openstack-env"
        OS_CLIENT_CONFIG_FILE = "~/.config/openstack/clouds.yaml"
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
        stage('Preparar entorno OpenStack') {
            steps {
                sh '''
                    source ${VENV_DIR}/bin/activate
                    openstack --version
                '''
            }
        }
        stage('Keystone health') {
            steps {
                sh '''
                    source ${VENV_DIR}/bin/activate
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
