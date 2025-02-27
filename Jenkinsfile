pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'githubcred',url: 'https://github.com/XI-4568radhakrishna/terraform-scaner.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check'
            }
        }
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        stage('Run tflint') {
            steps {
                sh 'tflint --init && tflint'
            }
        }
        stage('Run tfsec') {
            steps {
                sh 'tfsec .'
            }
        }
        stage('Run Checkov') {
            steps {
                sh 'checkov -d .'
            }
        }
        stage('Run Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
    }
}
