pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }

        stage('Wait Before Test') {
            steps {
                echo 'Waiting for 10 seconds before running tests...'
                sleep time: 10, unit: 'SECONDS'  // Sleep for 10 seconds
            }
        }

        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }

        stage('Wait Before Deploy') {
            steps {
                echo 'Waiting for 2 minutes before deploying...'
                sleep time: 2, unit: 'MINUTES'  // Sleep for 2 minutes
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
