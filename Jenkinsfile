#!groovy

class Configuration {
    TestStage test
    
    Configuration() {
        def config = readJSON file: 'config.json'
    
        environment = new Environment(
                config.environment.projectName,
                config.environment.sourcePath)
    }
}

class TestStage {
    boolean isEnabled
    String projectName
    String[] devices
    String reportPath
    
    TestStage(isEnabled, projectName, devices, reportPath) {
        this.isEnabed = isEnabled
        this.projectName = projectName
        this.devices = devices
        this.reportPath = reportPath
    }
}

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        Configuration configuration = getConfiguration()
    }

    stages {
        stage('SetUp') {
            steps {
                sh "bundle install"
            }
        }

        stage('Test') {
            when { expression { configuration.testStage.isEnabled } }
            steps {
                executeTestStage(configuration.testStage)
            }
            post {
                always {
                    junit "$reportPath/scan/report.junit"
                }
            }
        }
        
        stage('Coverage') {
            when { expression { isTestCoverageStageEnabled > 0 } }
            steps {
                sh "echo ${environment.sourcePath}"
            }
        }
    }

    post {
        success {
            sh 'echo "success :)"'
        }

        failure {
            sh 'echo "failure :("'
        }
    }
}

Environment getConfiguration() {
    return new Configuration()
}

void executeTestStage(TestStage stage) {
    sh "bundle exec fastlane test"
            + " projectName:${stage.projectName}"
            + " devices:${stage.devices}"
            + " reportPath:${stage.reportPath}"
}

void executeTestCoverageStage(def json) {
    def config = readJSON text: json
    String projectName = "${config.environment.projectName}"
    String sourcePath = "${config.environment.sourcePath}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
}
