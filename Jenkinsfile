
pipeline {
    agent any

    options {
        ansiColor('xterm')
    }
    
    stages {
        stage('SetUp') {
            steps {
                sh 'bundle install'
            }
        }
    }

    post {
        success {
            sh 'echo success :)'
        }

        failure {
            sh 'echo failure :('
        }
    }
}

