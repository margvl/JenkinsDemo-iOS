#!groovy
/*
class Configuration {
    TestStage testStage
    
    Configuration(configPath) {
        HashMap config = readJSON file: configPath
        def environment = config.environment
        def testStage = config.stages.test
        
        this.testStage = new TestStage(
                testStage.isEnabled,
                environment.projectName,
                testStage.devices,
                environment.reportPath)
    }
}

class TestStage {
    Boolean isEnabled
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
*/
pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        HashMap configuration = readJSON file: configPath
    }

    stages {
        stage('SetUp') {
            steps {
                sh "bundle install"
            }
        }

        stage('Test') {
            when { expression { configuration.stages.test.isEnabled } }
            steps {
                executeTestStage(configuration)
            }
            post {
                always {
                    junit "${configuration.testStage.reportPath}/scan/*.junit"
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

Configuration getConfiguration(String configPath) {
    return new Configuration(configPath)
}

void executeTestStage(HashMap configuration) {
    sh "bundle exec fastlane test"
            + " projectName:${configuration.environment.projectName}"
            + " devices:${configuration.stages.test.devices}"
            + " reportPath:${configuration.environment.reportPath}"
}

void executeTestCoverageStage(def json) {
    def config = readJSON text: json
    String projectName = "${config.environment.projectName}"
    String sourcePath = "${config.environment.sourcePath}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
}
