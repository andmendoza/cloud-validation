pipeline {
    agent any
    environment {
        VENV_DIR = "${WORKSPACE}/openstack-venv"
        OS_CLIENT_CONFIG_FILE ="${WORKSPACE}/.config/openstack/clouds.yaml"
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
                    ${VENV_DIR}/bin/python -m pip install --upgrade pip
                    ${VENV_DIR}/bin/python -m pip install python-openstackclient
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

        stage('Keystone health') {
            steps {
                sh '''
                    export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
                    chmod +x scripts/openstack/keystone.sh
	        source ${VENV_DIR}/bin/activate
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
