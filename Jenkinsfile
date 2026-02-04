pipeline {
    agent any

    environment {
        VENV_DIR = "${WORKSPACE}/openstack-venv"
        OS_CLIENT_CONFIG_FILE = "${WORKSPACE}/.config/openstack/clouds.yaml"
        REPORTS_DIR = "${WORKSPACE}/reports"
    }

    stages {

        stage('Info') {
            steps {
                sh """
                    mkdir -p ${REPORTS_DIR}
                    echo "Inicio validación cloud" | tee ${REPORTS_DIR}/info.log
                    date | tee -a ${REPORTS_DIR}/info.log
                """
            }
        }

        stage('Create venv & install OpenStack') {
            steps {
                sh """
                    mkdir -p ${REPORTS_DIR}
                    python3 -m venv ${VENV_DIR} | tee -a ${REPORTS_DIR}/venv.log
                    ${VENV_DIR}/bin/python -m ensurepip --upgrade | tee -a ${REPORTS_DIR}/venv.log
                    ${VENV_DIR}/bin/pip install --upgrade pip | tee -a ${REPORTS_DIR}/venv.log
                    ${VENV_DIR}/bin/pip install python-openstackclient | tee -a ${REPORTS_DIR}/venv.log
                """
            }
        }

        stage('Debug OpenStack CLI') {
            steps {
                sh """
                    echo "Comandos disponibles de OpenStack:" | tee ${REPORTS_DIR}/cli_debug.log
                    ${VENV_DIR}/bin/openstack help | tee -a ${REPORTS_DIR}/cli_debug.log
                """
            }
        }

        stage('Check OpenStack version') {
            steps {
                sh """
                    echo "OpenStack version:" | tee ${REPORTS_DIR}/version.log
                    ${VENV_DIR}/bin/openstack --version | tee -a ${REPORTS_DIR}/version.log
                """
            }
        }

        stage('OpenStack Services Health (No Auth)') {
            steps {
                sh """
                    echo "=== Validando endpoints públicos de OpenStack ===" | tee ${REPORTS_DIR}/services_health.log
                    chmod +x scripts/openstack/services_health.sh
                    bash scripts/openstack/services_health.sh 2>&1 | tee -a ${REPORTS_DIR}/services_health.log
                """
            }
        }

        stage('Debug clouds.yaml') {
            steps {
                sh """
                    echo "Usando clouds.yaml:" | tee ${REPORTS_DIR}/clouds_debug.log
                    cat ${OS_CLIENT_CONFIG_FILE} | tee -a ${REPORTS_DIR}/clouds_debug.log
                """
            }
        }

        stage('Keystone Health') {
            steps {
                sh """
                    chmod +x scripts/openstack/keystone.sh
                    echo "=== Validando Keystone ===" | tee ${REPORTS_DIR}/keystone.log
                    bash -c "OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE} ${VENV_DIR}/bin/openstack --os-cloud all-in-one --insecure token issue" 2>&1 | tee -a ${REPORTS_DIR}/keystone.log
                """
            }
        }
/*
        stage('Nova Health & Scheduler') {
            steps {
                sh """
                    mkdir -p ${REPORTS_DIR}
                    echo "=== Validando Nova ===" | tee ${REPORTS_DIR}/nova.log
                    chmod +x scripts/openstack/nova.sh
                    bash -c "OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE} bash scripts/openstack/nova.sh" 2>&1 | tee -a ${REPORTS_DIR}/nova.log
                """
            }
        }

        stage('Neutron Health') {
            steps {
                sh """
                    mkdir -p ${REPORTS_DIR}
                    echo "=== Validando Neutron ===" | tee ${REPORTS_DIR}/neutron.log
                    chmod +x scripts/openstack/neutron.sh
                    bash -c "OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE} bash scripts/openstack/neutron.sh" 2>&1 | tee -a ${REPORTS_DIR}/neutron.log
                """
            }
        }

        stage('Cinder Health') {
            steps {
                sh """
                    mkdir -p ${REPORTS_DIR}
                    echo "=== Validando Cinder ===" | tee ${REPORTS_DIR}/cinder.log
                    chmod +x scripts/openstack/cinder.sh
                    bash -c "OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE} bash scripts/openstack/cinder.sh" 2>&1 | tee -a ${REPORTS_DIR}/cinder.log
                """
            }
        }
*/
        stage('Glance Health') {
            steps {
                sh """
                    mkdir -p ${REPORTS_DIR}
                    echo "=== Validando Glance ===" | tee ${REPORTS_DIR}/glance.log
                    chmod +x scripts/openstack/glance.sh
                    export OS_CLIENT_CONFIG_FILE=${OS_CLIENT_CONFIG_FILE}
                    bash scripts/openstack/glance.sh 2>&1 | tee -a ${REPORTS_DIR}/glance.log
                """
            }
        }

    }

    post {
        always {
            script {
                // Crear carpeta reports si no existe
                if (!fileExists(REPORTS_DIR)) {
                    sh "mkdir -p ${REPORTS_DIR}"
                    echo 'Carpeta reports creada'
                }
                // Archivar los logs aunque la carpeta esté vacía
                echo 'Archiving reports (aunque esté vacía)...'
                archiveArtifacts artifacts: 'reports/**', allowEmptyArchive: true, fingerprint: true
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
