pipeline {
    agent any

    environment {
        TF_CLI_ARGS_apply="-auto-approve"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/XI-4568radhakrishna/Fast-api-2.git'
            }
        }

        stage('Init Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Validate Terraform') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Plan Terraform') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Terraform') {
            steps {
                sh 'terraform apply tfplan'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/*.tfstate', fingerprint: true
        }
        success {
            echo 'Terraform Infrastructure Applied Successfully'
        }
        failure {
            echo 'Terraform Execution Failed'
        }
    }
}
