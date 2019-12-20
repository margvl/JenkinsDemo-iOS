#!groovy

pipeline {
    agent any

    environment {
        def config = readJSON file: 'config.json'
        def enviroment = "${config.environment}"
    }

    options {
        ansiColor("xterm")
    }

    stages {
        stage('SetUp') {
            steps {
                sh 'echo "Will print projectName:"'
                sh 'echo ${projectName}'
            }
        }

        stage('Tests') {
            steps {
                sh 'bundle exec fastlane coverage projectName:${enviroment.projectName} sourcePath:${environment.sourcePath} reportPath:${environment.reportPath}'

                sh 'bundle exec fastlane test'
            }
        }
    }

    post {
        always {
            sh 'echo $PWD'

            // Processing test results
            junit 'build/results/scan/report.junit'

            // Cleanup
            sh 'rm -rf build'
        }

        success {
            sh 'echo "success :)"'
        }

        failure {
            sh 'echo "failure :("'
        }
    }
}
