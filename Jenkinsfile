#!groovy

pipeline {
    agent any

    environment {
        def config = readJSON file: 'config.json'
    }

    options {
        ansiColor("xterm")
    }

    stages {
        stage('SetUp') {
            steps {
                sh 'echo ${environment}'
            }
        }

        stage('Tests') {
            def projectName = config.environment.projectName

            steps {
                sh 'bundle exec fastlane coverage projectName:projectName sourcePath:$config.environment.sourcePath reportPath:$config.environment.reportPath'

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
