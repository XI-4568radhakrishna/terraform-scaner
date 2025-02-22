pipeline {
    agent any
    environment {
        TF_CLI_ARGS="-no-color"
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo/terraform-project.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        
    }
}
