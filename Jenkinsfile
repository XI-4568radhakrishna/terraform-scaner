pipeline {
    agent any
    environment {
        TF_CLI_ARGS="-no-color"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'githubcred',url: 'https://github.com/XI-4568radhakrishna/terraform-script.git'
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
