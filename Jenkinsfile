#!groovy

class JenkinsConfiguration {
    TestStage testStage
    
    JenkinsConfiguration() {
        def config = readJSON file: 'config.json'
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

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        JenkinsConfiguration configuration = getJenkinsConfiguration()
    }

    stages {
        stage('SetUp') {
            steps {
                sh "bundle install"
            }
        }

        stage('Test') {
            steps {
                executeTestStage(configuration.testStage)
            }
            post {
                always {
                    junit "${configuration.testStage.reportPath}/scan/*.junit"
                }
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

JenkinsConfiguration getJenkinsConfiguration() {
    return new JenkinsConfiguration()
}

void executeTestStage(TestStage stage) {
    println("Printing stage class:")
    println(configuration.getClass())
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
