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

        stage('Debug OpenStack CLI') {
            steps {
                sh '''
                    echo "Comandos disponibles de OpenStack:"
                    ${VENV_DIR}/bin/openstack help
                '''
            }
        }

        stage('Check OpenStack version') {
            steps {
                sh '''
                    echo "OpenStack version:"
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

        stage('Keystone Health') {
            steps {
                sh '''
                    chmod +x scripts/openstack/keystone.sh
                    # Ejecutar con --insecure para evitar problemas de SSL/Cloudflare
                    bash -c "OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE} ${VENV_DIR}/bin/openstack --os-cloud all-in-one --insecure token issue"
                '''
            }
        }

        stage('Nova Health & Scheduler') {
            steps {
                sh '''
                    echo "=== Validando Nova ==="
                    chmod +x scripts/openstack/nova.sh
                    # Ejecutar el script usando bash del sistema y el venv
                    bash -c "OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE} ${VENV_DIR}/bin/bash scripts/openstack/nova.sh"
                '''
            }
        }

        stage('Check OpenStack Public Services') {
            steps {
                sh '''
                    echo "=== Validando endpoints públicos de OpenStack ==="
                    chmod +x scripts/openstack/public_services.sh
                    # Ejecutar el script con bash del sistema
                    bash scripts/openstack/public_services.sh
                '''
            }
        }        

    }

    post {
        always {
            script {
                if (!fileExists('reports')) {
                    sh 'mkdir -p reports'
                }
                echo 'Archiving reports (if any)...'
                archiveArtifacts artifacts: 'reports/**', fingerprint: true
            }
        }
        success {
            echo 'Pipeline completada correctamente '
        }
        failure {
            echo 'Pipeline falló '
        }
    }
}
